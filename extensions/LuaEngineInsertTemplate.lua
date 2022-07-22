local fm,mi,m_insert,pop,templates,name,script,split_pos

--[[
if hk then hk.destroy() end
hk = createHotkey(function()
	print("Cursor at:", getLuaEngine().mScript.SelStart)
end, VK_CONTROL)
--]]
templates = 
{
[==[
Create Timer
if tm then tm.destroy() end
tm = createTimer()
tm.Interval = 500
tm.OnTimer = function()
%caret%
end
]==],
[==[
Debug_breakpoint
addr = %dasmSelectedAddress%
debug_removeBreakpoint(addr)
debug_setBreakpoint(addr,function()
%caret%
end)
]==], 
[==[
Enum functions
local modules = enumModules()
for i=1,#modules do
 local export = enumExports(getAddress(modules[i].Name))
 if type(export) ~= "table" then goto cont end
 for j,v in pairs(export) do
    if j:match("%caret%") then
     printf("ADDRESS: %X, NAME: %s", v,j)
    end
 end
 ::cont::
end
]==],
}



local function insert(tpos, text)
	local pos = tpos
	if pos < 1 then pos = 1 end
	fm.mScript.Lines.Text= (fm.mScript.Lines.Text):sub(1,pos)..text..(fm.mScript.Lines.Text):sub(pos+1)
	fm.mScript.SelStart = tpos
end


fm = getLuaEngine()
pop = fm.mScript.PopupMenu
m_insert = createMenuItem(pop)
m_insert.Caption = "Insert"
pop.Items.Insert(0,m_insert)


for i=1,#templates do
    split_pos = (templates[i]):find("\n")
	name = (templates[i]):sub(1,split_pos)
	
	
	mi = createMenuItem(m_insert)
	mi.Caption = name
	m_insert.add(mi)
	
	mi.OnClick = function(s)
		local i = s.MenuIndex+1
		split_pos = (templates[i]):find("\n")
		script = (templates[i]):sub(split_pos+1)
		local caret = fm.mScript.SelStart-1
		if caret < 0 then caret = 0 end
		local original = fm.mScript.Lines.Text
		script = original:sub(1,caret)..script..original:sub(caret+1)
		script = (script):gsub("%%dasmSelectedAddress%%",string.format("0x%X",getMemoryViewForm().disassemblerview.SelectedAddress))
		
		fm.mScript.Lines.Text = script
		local bt = stringToByteTable(fm.mScript.Lines.Text)
		for i=1, #bt do 
			if bt[i] == 37 --[[% char]--]] and byteTableToString({bt[i+1],bt[i+2],bt[i+3],bt[i+4],bt[i+5],bt[i+6]}) == "caret%" then
				fm.mScript.Lines.Text = (fm.mScript.Lines.Text):gsub("%%caret%%","")
				fm.mScript.selStart = i
				return
			end
		end
		
	end
	
end


