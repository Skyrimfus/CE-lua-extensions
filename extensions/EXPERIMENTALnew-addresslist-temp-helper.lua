--Version 1.2
--Author: Skyrimfus
--[[
Changelog
----1.0-----
  First version

----1.1-----
  Saving the table in any way(except with lua) should now only save the Main Address List

----1.2-----
  Added a menu-item and implementation of saving the TEMP AL as new Cheat Table
--]]


local addr,originalAL,parent,obtn,btn,btn2,al,tm,tempAL,mi,oldSaveTable,sd

MainForm.registerFirstShowCallback(function()
showMessage("You have loaded an extension that adds an extra address list. It is highly experimental and can corrupt/override/delete tables you load into it. Use at your own risk and backup any table you load with this extension!")
local oldhandler, oMIS, oSA
oldhandler=MainForm.actSave.OnExecute
oldSaveTable = saveTable

function saveTable(...)
 args = {...}
 if type(args[#args]) == "table" then
  if args[#args][1] == "saveTemp" then
    print("temp")--save our temp
    return
  end
 end
 btn.OnClick()
 oldSaveTable(...)--save the main
end

MainForm.actSave.OnExecute=function(sender)
  btn.OnClick()
  oldhandler(sender)
end

oMIS = MainForm.miSave.OnClick
MainForm.miSave.OnClick = function(s)
  btn.OnClick()
  oMIS(s)
end

oSA = MainForm.Save1.OnClick
MainForm.Save1.OnClick = function(s)
--[[
 showMessage("before save as")
 oSA(s)
 showMessage("aftet save as")
 --]]
end




addr = readPointerLocal(tonumber("0x"..string.format("%s",AddressList.Parent):match("userdata: (.+)")))-0x14D8
originalAL = readPointerLocal(tonumber("0x"..string.format("%s",AddressList):match("userdata: (.+)")))
parent = AddressList.Parent
obtn = MainForm.btnMemoryView
btn = createButton(MainForm.btnMemoryView.Parent)
	btn.Caption = "Main Address List"
        btn.Anchors = obtn.Anchors
        btn.AnchorSideBottom = obtn.AnchorSideBottom
        btn.AnchorSideLeft.Control = obtn
        btn.AnchorSideLeft.Side = asrRight
        btn.AnchorSideRight = obtn.AnchorSideRight
        btn.AnchorSideTop = obtn.AnchorSideTop
        btn.Height = obtn.Height
        btn.Width = 100
        btn.Enabled = false
		btn.OnClick = function()
			--Main Address List is visible:
			writePointerLocal(addr,originalAL)
			btn.Enabled = false
			btn2.Enabled = true
			al.Visible = false
			AddressList.Visible = true
			MainForm.UpdateTimer.Enabled = true
			tm.Enabled = false
		end

btn2 = createButton(MainForm.btnMemoryView.Parent)
		btn2.Caption = "Temp Address List"
        btn2.Anchors = obtn.Anchors
        btn2.AnchorSideBottom = obtn.AnchorSideBottom
        btn2.AnchorSideLeft.Control = btn
        btn2.AnchorSideLeft.Side = asrRight
        btn2.AnchorSideRight = obtn.AnchorSideRight
        btn2.AnchorSideTop = obtn.AnchorSideTop
        btn2.Height = obtn.Height
        btn2.Width = 100
		btn2.OnClick = function()
			--Temp Address List:
			writePointerLocal(addr,tempAL)
			btn.Enabled = true
			btn2.Enabled = false
			al.Visible = true
			AddressList.Visible = false
			MainForm.UpdateTimer.Enabled = false
			tm.Enabled = true
		end


al = createComponentClass("TAddresslist",parent)
  al.Parent = parent
  al.Visible = false
  al.Height = AddressList.Height
  al.Width = AddressList.Width
  al.BevelColor = 0x005fbf
  al.BevelWidth = 5
  al.Anchors = AddressList.Anchors
  al.AnchorSideBottom = AddressList.AnchorSideBottom
  al.AnchorSideLeft = AddressList.AnchorSideLeft
  al.AnchorSideRight = AddressList.AnchorSideRight
  al.AnchorSideTop = AddressList.AnchorSideTop
  
  
  if tm then tm.destroy() end
	tm = createTimer()
	tm.Interval = GetSettings().Value["Update interval"]--GetSettings().Value["Freeze interval"]
	tm.OnTimer = function()
	 al.repaint()--update the values
    end
  
	
    al.List.PopupMenu = AddressList.PopupMenu

  
	for i=0, AddressList.Header.Sections.Count-1 do
	  al.Header.Sections[i].Width = AddressList.Header.Sections[i].Width
	end
	tempAL = readPointerLocal(tonumber("0x"..string.format("%s",al):match("userdata: (.+)")))
	
mi = createMenuItem(AddressList.PopupMenu)
	mi.Caption = "Save Temp Address List as new table"
	mi.ImageIndex = 4
	AddressList.PopupMenu.Items.insert(0,mi)
	mi.OnClick = function()
	    if not sd.execute() then return end
		btn2.OnClick()
		oldSaveTable(sd.FileName)
	end
	
sd = createSaveDialog(MainForm)
	sd.DefaultExt = ".ct"
	sd.Filter = "Cheat Engine Tables (*.CT)|*.CT"


end)   