--version 1.5 for testing...
useGetAllComments = true

if getAllComments == nil then
useGetAllComments =  false
function getAllComments()
  local results={}

  local ss=createStringStream()

  saveTable(ss)

  local xp=require("xmlSimple").newParser()
  local parsed=xp:ParseXmlText(ss.DataString)
  if parsed and parsed.CheatTable.DisassemblerComments then
    for i=1,parsed.CheatTable.DisassemblerComments:numChildren() do
      local ce=parsed.CheatTable.DisassemblerComments:children()[i]
      local e={}
      e.Address=getAddressSafe(ce.Address:value())

      if ce.Comment then
		results[e.Address] = ce.Comment:value()
      end


    end
  else
    results=nil
  end

  ss.destroy()

  return results or {}
end


end



dasmComments = createDisassembler()
arrComments = {}
arrDeleted = {}

function updateComments()
lvComments.beginUpdate()
 for i in pairs(arrComments) do
	local r = {pcall(string.find,string.upper(arrComments[i].comment),string.upper(edtSearch.Text))}
	
	if r[1]and r[2] then--string.find(string.upper(arrComments[i].comment),string.upper(edtSearch.Text)) then
		if arrDeleted[i] then
			--print("adding",arrComments[i].comment)
			local it=lvComments.Items.add()
			it.Caption = getComment(i)
			dasmComments.disassemble(i)
			local opcode = dasmComments.LastDisassembleData.opcode
			it.SubItems.Text = string.format("%X\n%s %s",i,opcode,(opcode == "??" and "" or dasmComments.LastDisassembleData.parameters))
	
			
			
			arrDeleted[i] = nil
			arrComments[i]['lvItem'] = it
		end
	else
		if arrDeleted[i] == nil then
			--print("removing",arrComments[i].comment)
			arrComments[i].lvItem.delete()
			arrDeleted[i] = true		
		end
	end
 end
lvComments.endUpdate()
end

function updateCommentsForce()
 if getAllComments == nil then 
	print("To force update the comments list, you need to have the getAllComments function!")
	return
 end
 
 arrComments = {}
 arrDeleted = {}
 lvComments.clear()
 local comments = getAllComments()
 for i,v in pairs(comments) do
  lvComments.beginUpdate()
  --if edtSearch.Text == '' or string.find(string.upper(v),string.upper(edtSearch.Text)) then
	  local it = lvComments.Items.add()
	     arrComments[i] = {}
         arrComments[i]['comment'] = v 
		 arrComments[i]['lvItem'] = it
	  it.Caption = v
	  dasmComments.disassemble(i)
	  local opcode = dasmComments.LastDisassembleData.opcode
	  it.SubItems.Text = string.format("%X\n%s %s",i,opcode,(opcode == "??" and "" or dasmComments.LastDisassembleData.parameters))
  --end
  lvComments.endUpdate()
 end
end

function diffDetected(a,c)
c = tostring(c)
 if arrComments[a] == nil then --not in the list so add it
  arrComments[a] = {}
  arrComments[a]['comment'] = c   
  local it = lvComments.Items.add()
  it.Caption = c
  dasmComments.disassemble(a)
  local opcode = dasmComments.LastDisassembleData.opcode
  it.SubItems.Text = string.format("%X\n%s %s",a,opcode,(opcode == "??" and "" or dasmComments.LastDisassembleData.parameters))

  
 
  
  arrComments[a]['lvItem'] = it
  
 elseif c:gsub("%s+","") == "" then
  --print("comment deleted",c)
  arrComments[a].lvItem.delete()
  arrComments[a] = nil
 else
  arrComments[a].comment = c
  arrComments[a].lvItem.Caption = c
end

end

----------GUI BEGIN----------------
frmCommentsList = createForm(false)
 frmCommentsList.Caption = "Comments list"
 frmCommentsList.BorderStyle = bsSizeable
 frmCommentsList.Width = 700
 frmCommentsList.Height = 400

lblSearch = createLabel(frmCommentsList)
 lblSearch.Caption = "Search:"
 lblSearch.Left = 5
 lblSearch.Top = 5

edtSearch = createEdit(frmCommentsList)
 edtSearch.AnchorSideLeft.Control = lblSearch
 edtSearch.AnchorSideLeft.Side = asrRight
 edtSearch.AnchorSideRight.Control = frmCommentsList
 edtSearch.AnchorSideRight.Side = asrRight

 edtSearch.BorderSpacing.Left = 5
 edtSearch.BorderSpacing.Right = 5
 edtSearch.Anchors = "akTop,akLeft,akRight"

lvComments = createListview(frmCommentsList)
 lvComments.Anchors = "akTop,akLeft,akRight,akBottom"
 lvComments.AnchorSideTop.Control = edtSearch
 lvComments.AnchorSideTop.Side = asrBottom
 lvComments.BorderSpacing.Top = 5
 lvComments.AnchorSideRight.Control = frmCommentsList
 lvComments.AnchorSideRight.Side = asrRight
 lvComments.AnchorSideBottom.Control = frmCommentsList
 lvComments.AnchorSideBottom.Side = asrBottom
 lvComments.RowSelect = true
 lvComments.ReadOnly = true
 lvComments.HideSelection = false


 lcComments = lvComments.Columns.add()
  lcComments.Caption = "Comments"
  lcComments.Width = 280

 lcAddress= lvComments.Columns.add()
  lcAddress.Caption = "Address"
  lcAddress.Width = 75

 lcOpcode = lvComments.Columns.add()
  lcOpcode.Caption = "Opcode"
  lcOpcode.Width = 320


if getAllComments ~= nil then
 btnForceUpdate =  createComponentClass('TSpeedButton', frmCommentsList)
 btnForceUpdate.Parent = frmCommentsList
 btnForceUpdate.Images = MainForm.mfImageList
 btnForceUpdate.ImageIndex = 15
 btnForceUpdate.ImageWidth = 20
 btnForceUpdate.OnClick = updateCommentsForce
 
 btnForceUpdate.Hint = useGetAllComments and "Force refresh list" or "Force refresh list(WARNING! NOT A NAITIVE IMPLEMENTATION" 
 
 btnForceUpdate.ShowHint = true
 btnForceUpdate.ParentShowHint = false
  
  btnForceUpdate.Height = 25
  btnForceUpdate.Width = btnForceUpdate.Height
  edtSearch.AnchorSideRight.Control = btnForceUpdate
  edtSearch.AnchorSideRight.Side = asrLeft
 
 
  btnForceUpdate.Anchors = "akRight, akTop"
  
  btnForceUpdate.AnchorSideRight.Control = frmCommentsList
   btnForceUpdate.AnchorSideRight.Side = asrRight
   btnForceUpdate.BorderSpacing.Right = 5



end
----------GUI END----------------------

local mf = getMemoryViewForm()
local pm = mf.DisassemblerView.PopupMenu
local pmi,gg,gg2
for i = 0, pm.Items.Count-1 do
 if pm.Items[i].Name == 'miUserdefinedComment' then
  pmi = pm.Items[i]
  break
 end
end
if not gg then gg = pmi.OnClick end
if not gg2 then gg2 = setComment end

pmi.OnClick = function(s)
addr = mf.DisassemblerView.SelectedAddress
local cmb = getComment(addr)
gg(s)
local cma = getComment(addr)

if cmb ~= cma then
 diffDetected(addr,cma)
end
end

setComment = function(a,c)
local cmb = getComment(a)
if cmb ~= c then 
 diffDetected(a,c)
end

gg2(a,c)
end

frmCommentsList.OnClose = function() frmCommentsList.hide() end
frmCommentsList.OnShow = function() updateComments() end

lvComments.OnDblClick = function(s) getMemoryViewForm().DisassemblerView.SelectedAddress = "0x"..s.Selected.SubItems[0] end
edtSearch.OnChange = function(s) updateComments() end






--Create menu shit for memory view:
 menuView = getMemoryViewForm().Menu.Items[2]
 miCommentsList = createMenuItem(menuView)
  miCommentsList.Caption = "Comments list"
  miCommentsList.ImageIndex = 69 --nice
  miCommentsList.OnClick = frmCommentsList.show
  miCommentsList.setShortcut("Ctrl+Shift+B")
 menuView.insert(7,miCommentsList)
 

