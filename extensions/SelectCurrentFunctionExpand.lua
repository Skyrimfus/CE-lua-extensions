--[[
Author: Skyrimfus
Discord ID: 244490308782391316
Name: Expand Select Current Function
Version: Public version 2.5

Written for CE 7.4


Description: 
	This extension expands the "select current function" and adds the following options:
		- Select current function and goto top
		- Select current function and goto bottom
		- Select current function and copy bottom opcode


--]]

local fm = getMemoryViewForm()
local pop = fm.MenuItem2--get menu item
local orig = pop.OnClick--get original function 
pop.OnClick = nil--disable the original function so that it doesn't exec when menu expands

local goTop = createMenuItem(pop_scf)
	goTop.Caption = "Select function and goto top"
	goTop.OnClick = orig
	
local goBot = createMenuItem(pop_scf)
	goBot.Caption = "Select function and goto bottom"
	goBot.OnClick = function(s)
						orig(s)
						--Basic variable swaping:
						local tmp = fm.DisassemblerView.SelectedAddress
						fm.DisassemblerView.SelectedAddress = fm.DisassemblerView.SelectedAddress2
						fm.DisassemblerView.SelectedAddress2 = tmp
					end
					
local cpyOpc = createMenuItem(pop_scf)
	cpyOpc.Caption = "Select function and copy bottom opcode"
	cpyOpc.OnClick = function(s)
						orig(s)
						writeToClipboard(({splitDisassembledString(disassemble(fm.DisassemblerView.SelectedAddress2))})[2])
					 end

pop.add(goTop);pop.add(goBot);pop.add(cpyOpc)