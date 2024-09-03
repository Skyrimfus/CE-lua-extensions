--made by skyrimfus
local fs,ss,fm
local Blocks = {}
local MAX_PER_LINE = 30


function toTextSig(tab,maxLen)
 local tlen = #tab
 if len == 0 then return "" end
 for i=1,tlen do
	if type(tab[i]) == "number" then tab[i] = string.format("%02X",tab[i]) end
 end
 if maxLen then tab = table.move(tab,1,maxLen,1,{}) end
 return table.concat(tab," ")
end
function diff(arr) --arr must be a arr of tables. tables need to be same size
    sig = {}
	if arr[1] == nil then return sig end
	for i=1,#arr[1] do
		sig[i] = arr[1][i]
	end
	
	for i=2, #arr do
		for j=1, #arr[i] do
			sig[j] = sig[j] == arr[i][j] and sig[j] or "??"
		end
	end
	return sig
end

function updateOut()
local mOut = fm.mOutSig
	mOut.Lines.Text = toTextSig(diff(Blocks))
end
function toggleGUI(s)
	if s then
		fm.btnAdd.Caption = "Start"
		fm.cbBlockSize.Enabled = true
		fm.inBufferSize.Enabled = true
	else
		fm.btnAdd.Caption = "Add"
		fm.cbBlockSize.Enabled = false
		fm.inBufferSize.Enabled = false
	end
end
fs = [=[<?xml version="1.0" encoding="utf-8"?>
<FormData>
  <frmToolThingy Class="TCEForm" Encoding="Ascii85">tyax$)?GSc+hy@1g^ri]T[EHKxI]5Tkgo2g2@0^iis{g1PV7lC%48.+nY7J*gS%k_3+Lb;55X)2V2[Ys!J0ec?lPCLwS=PM;T}AvIp6o4/9X*.)0[Kg?ASJ54.i0c8S-hLG14DnI$G3wXejOXwdP{lM]LN9+6co.+^=w31(-y_^$@b^h$KEmT{CBm#PP^#h)^g5qKR/2a3)RMO/w}BGC_zx5^#)K?qF]t26tTn3CSU+QnZgSP4hm3y[JAD?Xl*Wy1nO!3.iDFZhOCdue{dk*l3f#5NVMCIf!G9gt(1*qcP)lj+*JvomJc%NUBo*D8d}kC7b36TM8p-D8(Dugb-@x/-@*e::hY/Vcl@Iitw9oqBC7MF:+gghw(Kka0VkqLpy/K=Uo.(B$%z7H#aT*FaH[jili/hjJp76tscf$dYE3(,+1F$D:GSi/3Yhqf!B,$YH1z7wQ?#(zN.!j,z?k@5py#k:40lQH%byXIM(Ttzzq:zCFIfqp8DBCbfmZgJAHI6A1i$iS:y?OM2dMBO-i9qE)mg)L)yR+28GroohsT%#lBfY6VCH@!DzJ}QVi2?qwEB]mO9}n=gR%.l6MqV+eR;7(RKgGIKfXE3v[2yX4t}CGan8WhDxgPLy4o!98rSUz!N^RVR;3uqW1q/!dH{Z$0$.SpZn1uueOqvW$HF$Wf_fUtk_zXM$2wpx6%Cf$uNj=)I^4^5)R?}hbpuHivZ5mtD)dZBxDi9Y)5_.ZU._fAR/UbFl0Pnv}-9jC@IIo-p;J}?%jvkMli^UF-MVhTOv}{b23]Dx$3zyw-qhp.6Zj*Ts7[t$LvhE/,_A}uaMgUz+7:,:8907j#HI3jpH,l]0uc8bgLZsWrOUkCar*{FNL4VOyes6D?*@cLiMebYWq9+weLq]%[eE;m7kg8+5A2cjbzSzJvQyMjIS+tnttXMGTCO5dRWNk7?aMD,BZ[m1S@Fw.msu_cDG=U8!-C:(??_4erL(9Zor9)q,DNWQ9JADRhycT]Bd4zmJ^uy*wtPh#X7h9aAakJbq/Q$MrR;Wk!k.#S;mOhl{8-MJxr1C^G(OMSZzo)ZQf6#c7kAhOv%FYPS^zRRLEKPw2Ed]x}Jj/%?}+F]+DP)%$Xj}r4smpd)vj;aoIZ=(gt+k/5wosuID%2x1fBJ]BJ.Ad*D6g3XNJ{q^/;4$c57sLa*)6t475KQT[b}</frmToolThingy>
</FormData>
]=]
ss = createStringStream(fs)
fm = createFormFromStream(ss)
ss.destroy()

fm.OnDblClick = function()
print("Blocks Size:",#Blocks)
for i=1, #Blocks do
	print("Block n:",i)
	for j=1, #Blocks[i] do
		printf("\tIndex %s: %s",j, Blocks[i][j])
	end
end
print("----------------------------------------------")
print("----------------------------------------------")
print("----------------------------------------------")
end



fm.lvSigBlocks.OnDblClick = function()
	fmm = createForm(false)
	fmm.Left = fm.Left+fm.Width/2-fmm.Width/2
	fmm.Top = fm.Top +fm.Height/2-fmm.Height/2
	fmm.Caption = "Info"
	local mm = createMemo(fmm)
	mm.Anchors = "[akTop,akLeft,akRight,akBottom]"
	mm.AnchorSideTop.Control = fmm
	mm.AnchorSideTop.Side = asrTop
	mm.AnchorSideBottom.Control = fmm
	mm.AnchorSideBottom.Side = asrBottom
	mm.AnchorSideLeft.Control = fmm
	mm.AnchorSideLeft.Side = asrLeft
	mm.AnchorSideRight.Control = fmm
	mm.AnchorSideRight.Side = asrRight
	mm.ReadOnly = true
	mm.ScrollBars = ssBoth
	mm.OnKeyDown = function(_, k)
		if k == VK_ESCAPE then fmm.close() end
	end
	local sel = fm.lvSigBlocks.Selected
    local index	
	if sel then
		index = sel.Index
		mm.Lines.Text = toTextSig(Blocks[index+1])
	end
	fmm.showModal()
end
local pm = createPopupMenu(fm)
local miDeleteAll = createMenuItem(pm)
miDeleteAll.Caption = "Remove all"
fm.lvSigBlocks.PopupMenu = pm
miDeleteAll.OnClick = function()
	if messageDialog("WARNING!", "Are you sure you want to remove EVERYTHING?", 0, mbYes,mbNo) == 6 then
		Blocks = {}
		fm.lvSigBlocks.Items.clear()
		toggleGUI(true)
		updateOut()
	end
end
miDeleteSingle = createMenuItem(pm)
miDeleteSingle.Caption = "Delete"
pm.Items.add(miDeleteSingle)
miDeleteSingle.OnClick = function()
local lv = fm.lvSigBlocks
	for i=0, lv.Items.Count-1 do
		local it = lv.Items[i]
		if it and it.Selected == true then
			table.remove(Blocks,it.Index+1)
			it.delete()
		end
	end
	if lv.Items.Count == 0 then toggleGUI(true) end
	updateOut()
end


pm.Items.add(miDeleteAll)

fm.btnAdd.OnClick = function(btn)
	local addrText = fm.inAddress.Text
	if addrText:gsub("%s+", "") == "" then addrText = AddressList.SelectedRecord.AddressString end
	fm.inAddress.Text = addrText
	local addr = getAddressSafe(addrText)
		if addr == nil then print("error:addr is nil");return end--error
	local buff = tonumber(fm.inBufferSize.Text)
		if buff == nil then print("error:buff is nil");return end--error
	local bBothDir = fm.cbBlockSize.Checked


	toggleGUI(false)
	local b = {}
	if bBothDir then
		buff = math.abs(buff)
		b = readBytes(addr-buff,buff*2,true)
	else
		if buff>0 then
			b = readBytes(addr,buff,true)
		else
			local t=math.abs(buff)
			b = readBytes(addr-t,t,true)
		end
	end
	Blocks[#Blocks+1] = b
	
local lv = fm.lvSigBlocks
	local it = lv.Items.add()
	it.Caption = string.format("%X",addr)
	it.SubItems.addText(toTextSig(b,MAX_PER_LINE)..((#b>MAX_PER_LINE) and " ...." or ""))
	
updateOut()

end



fm.show()