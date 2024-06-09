--When pressing CTRL+U to view symbols, in the memory view window:
--automoatically fill in the address field with the currently highlighted address in the disassembler.

--helper func:
function enumForms()
 local i=0
 local n = getFormCount()
 return function()
   i=i+1
   if i>n then return nil end
   return getForm(i-1)
 end
end
registerLuaFunctionHighlight("enumForms")

local mvf = getMemoryViewForm()
if orig_miUserdefinedSymbols_OnClick == nil then orig_miUserdefinedSymbols_OnClick = mvf.miUserdefinedSymbols.OnClick end
mvf.miUserdefinedSymbols.OnClick = function(...)
  local ret = orig_miUserdefinedSymbols_OnClick(...)
  for f in enumForms() do
    if f.ClassName == "TfrmSymbolhandler" then
      local sel = getNameFromAddress(mvf.DisassemblerView.SelectedAddress)
      f.edtAddress.Text = sel
    end
  end

end