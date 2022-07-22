 --[[
Author: Skyrimfus
Discord ID: 244490308782391316
Name: Delete All Breakpoints
Version: Public version 2.0

Written for CE 7.4


Description: 
	This extension adds a option inside the breakpoint window that delets all breakpoints(Hotkey: Ctrl+Del)

--]]
 
 
 
function removeAllBp()
	local bpl = debug_getBreakpointList()
	for i=1,#bpl do
		debug_removeBreakpoint(bpl[i])
	end
end


local function addMi(fm)
	local pop = fm.ListView1.PopupMenu
	local orig = pop.onpopup
	local mi = createMenuItem(pop)
	mi.Caption = "Delete All"
	mi.ShortCut = "Ctrl+Del"
	mi.OnClick = removeAllBp
	pop.Items.add(mi)
	
	pop.onpopup = function(s)
		if fm.ListView1.Items.Count == 0 then
			mi.Enabled = false
		else
			mi.Enabled = true
		end
		orig(s)
	end


end


registerFormAddNotification(function(fm)
	if fm.ClassName == 'TfrmBreakpointlist' then
		fm.registerCreateCallback(addMi)
	end
end)