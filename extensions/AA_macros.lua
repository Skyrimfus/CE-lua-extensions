--Place in autorun folder
--In auto assembler you can use definemacro(name,line1;line2)
--This will only register the macro, to use it in a script use:
--macro(name)
--this will produce the following assembly at the line(s) of the macro():
--line1
--line2
--Macros are global(you can use macros from outside the defining script)
(function()
local defined_macros = {}
registerAutoAssemblerCommand("definemacro", function(p, s)
local name = p:split(",")
local macro = table.concat({p:split(",")},",",2)
macro = macro:gsub(";","\n")
defined_macros[name] = macro
end)
registerAutoAssemblerCommand("macro", function(name, s)
if defined_macros[name] == nil then return nil, "Macro: '"..name.."' does not exist!" end
return defined_macros[name]
end)
end)()
