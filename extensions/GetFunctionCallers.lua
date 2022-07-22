--[[
Author: Skyrimfus
Discord ID: 244490308782391316
Name: Get Function Callers
Version: Public version 1.0

Written for CE 7.4


Description: 
	This extension is a tool that you can use to figure where the function got called from, and how many times
	Tool can be opened from Memory Viewer->Tools->Function Callers


--]]
local fm,ed,lv,tm,btn,mn,mi
local started = false

local mvf = getMemoryViewForm()
local menu = mvf.Extra1
local mi = createMenuItem(menu)
mi.Caption = "Function Callers"
menu.insert(mvf.miLuaEngine.MenuIndex+1,mi)


fm = createForm(false)
fm.Caption = "Function callers"
fm.Width = 500
fm.BorderStyle = bsSizeable


mi.OnClick = function()
	fm.show()
end

btn = createButton(fm)
btn.Anchors = "[akTop,akRight]"
btn.Width = 100
btn.Hint = "Hold shift to select the current address in the dissasembler"
btn.ShowHint = true
btn.Caption = "Start"
btn.AnchorSideRight.Control = fm
btn.AnchorSideRight.Side = asrRight
btn.tabOrder = 1

ed = createEdit(fm)
ed.Anchors = "[akTop,akLeft,akRight]"
ed.AnchorSideRight.Control = btn
ed.AnchorSideRight.Side = asrLeft



lv = createListView(fm)
lv.MultiSelect = true
lv.OnDblClick = function(s) if s.Selected == nil then return end;getMemoryViewForm().DisassemblerView.SelectedAddress = getAddressSafe(s.Selected.Caption) end
lv.ReadOnly = true
lv.RowSelect = true
lv.Top = 25
lv.Anchors = "[akTop,akBottom,akLeft,akRight]"
lv.AnchorSideRight.Control = fm
lv.AnchorSideRight.Side = asrRight
lv.AnchorSideBottom.Control = fm
lv.AnchorSideBottom.Side = asrBottom
cAddr = lv.Columns.add()
cAddr.Caption = "Address"
cAddr.Width = 300
cHits = lv.Columns.add()
cHits.Caption = "Count"
cHits.Width = 100


mn = createPopupMenu(lv)
mi = createMenuItem(mn)
mi.Caption = "Copy"
mi.Shortcut = "CTRL+C"
mn.Images = MainForm.mfImageList
mi.ImageIndex = 20
mi.OnClick = function()
	local str = ""
	for i=0,lv.Items.Count-1 do
		if lv.Items[i].Selected then str = str..lv.Items[i].Caption.." | "..lv.Items[i].SubItems[0].."\n" end
	end
	writeToClipboard(str)

end
mn.Items.add(mi)
lv.PopupMenu = mn
mn.onPopup = function() mi.Enabled = lv.Selected or false and true end

fm.OnClose = function()
	started = false
	btn.Caption = "Start"
	if tm then tm.destroy() end
	if bAddr then debug_removeBreakpoint(bAddr) end
	fm.hide()
end

btn.OnClick = function()
    if isKeyPressed(VK_SHIFT) then ed.Text = getNameFromAddress(getMemoryViewForm().disassemblerview.SelectedAddress) end
	bAddr = getAddressSafe(ed.Text)
	if bAddr == nil then messageDialog("Error","Could not resolve address!",1);return end

	if not started then
		started = true
		btn.Caption = "Stop"

                lv.clear()
		rAddr = {}
		debug_removeBreakpoint(bAddr)
		debug_setBreakpoint(bAddr,function()
			ret = readPointer(RSP)
			if rAddr[ret] == nil then
				rAddr[ret] = 0
			end
			rAddr[ret] = rAddr[ret]+1
		end)

		if tm then tm.destroy() end
		tm = createTimer()
		tm.Parent = fm
		tm.Interval = 50
		lAddr = {}
		tm.OnTimer = function()
			for i in pairs(rAddr) do
				if lAddr[i] == nil then
					lAddr[i] = lv.Items.add()
					--lAddr[i].Caption = string.format("%X",i)
					lAddr[i].Caption = getNameFromAddress(i)
					lAddr[i].SubItems.add(0)
				end
				lAddr[i].SubItems[0] = rAddr[i]
			end
		end

	else
		started = false
		btn.Caption = "Start"
		if tm then tm.destroy() end
		debug_removeBreakpoint(bAddr)

	end




end
ed.OnKeyDown = function(key)if isKeyPressed(VK_RETURN) then btn.OnClick()end end


