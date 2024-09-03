--made by skyrimfus
local fs,ss,fm
local Blocks = {}
local MAX_PER_LINE = 30

function parseSig(text)
         local s = {string.split(text, " ")}
         local b = {}
         for i=1, #s do
             local n = s[i]
             if n == "??" then n = -1 else n = tonumber(n,16) end
             b[i] = n
         end

         return b
end
function toTextSig(tab,maxLen)
 local tlen = #tab
 if len == 0 then return "" end
 for i=1,tlen do
	if type(tab[i]) == "number" then
        if tab[i] == -1 then tab[i] = "??" else tab[i] = string.format("%02X",tab[i]) end
    end
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
    local outText = toTextSig(diff(Blocks))
	mOut.Lines.Text = outText
    local totalBytes = tonumber(fm.inBufferSize.Text)
    totalBytes = totalBytes or 0
    if fm.cbBlockSize.Checked then totalBytes = totalBytes*2 end
    local _, nSigged = outText:gsub("%?%?","")
    fm.lblSiggedBytes.Caption = ("Masked bytes: %s/%s"):format(nSigged,totalBytes)
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
  <frmToolThingy_7 Class="TCEForm" Encoding="Ascii85">tyWEM,cp?cCCiemv[:_t-C-DX$Z;OnT;:!l#9p%(bC4o7,TIFUqHV%7X@=ah[aF4K,jiK0+m+x/e[?B,hXLDR:Z(PkEZ15Rx9},4Up^*?:Xu[jJiZ6O?WttoJM29?WqjTm@ZAf5GMr+MS-m-}[t99_ztkGf5S}n;eOa?IY,-+7oL4xOQ}Pi0-bp0!CF)IMIU^akB/V;UyFIv(n9*X^)L!n9[Id.)Ds!kH]JW+/Jw[O;A08fphYC)e4l$LYbB1ZU/qy![SV.E%Y(B2S[d5o[btCd;iY03Hd.OP*3!R4hRY)7hfTs%W!x17*G9oHbj*eH,gho?w2RKH$,_EWVpBBqqCMBEa0ecFgOIS1..J3)7WwlbKtd:3[[mn8;OE+CgK=BZoqz7jS8hFrUJVt!5fRSRUV[:#G/)C%+vzgQCrKvv(UO:umG=jY+XdR!%So*aWP}2Mm2OA.!!S$iwNrDfHWmVEPfCuG;e1A]6hIm5EX-3Q:L)FfPgMI_5=qL]zb;Qe,+KGlBfXF}XE-m1z$3CJHMI,cBqHFm}$+%;@[3jcF%{PrHxgyAIj767]7!/OXB()/[*%^ViYUt0]3v#QikzypZJ7rVYwbT@HxhY(YGv6p(v0pZT,Gn,IFhyVr3w32xzSzUGyBv:dh6/^)Mv0?^%u#}a!5.r,ee;N]cho,vI_9W^Z.B$t^dEwH@293%T4!-bg4Q8!L6H3e$QU{P;oOYeo^z(wCyin=Ur^+HSqp[0ViCfn]ZSa^f]qKXm?P+H#hviE3]GQ}2+-=vjFvW0gR*:);v/kR8gGxFXaY=^j5()5?r,]%%,zSxJges;Z7Eu(.Wyb^aX(HYV9Ks@S*P_Y]GwpT0KSr[yHteIw6m)Tan7$O.vd3#qFZJ6uN$Pj8MFaXJs.jnGhN;R+q9%m8;(A]skZ,CcRN+[EkmW+F275+TVLmbIi{A7bHJu*^MAfE*9/]OCOhe+J^IyNMpps39N;xJO6.UovRElZvb=)l#TZXm(Kk]A6:/3+H@1ZLEIV,fR#L8SHM8CA@fuSVnyVg^bJYp8oO3r#%+)Dg+0nu@6D#YnYf!^G-IYW_r2R$aj?P/vzU4UXV}T[yoGppOYFMhq@WW;b3k2hHN;.vq!LHJvLfN^n1x:::cPTE:f@nIgDracU-1,%ZDy=t0NbNQ$+KM=8%YLX,=$WGwJ-.mf1j/+PKWn!()$+^C]bn6{*f[{BL),v?xD6rna4lqWDvrsu][O%LP%C.TC@k0QsZUdR_Nj+GNTaY[zDm8$I@xaUCSiMfTekA9,CPIrpR6Oz%9HTu?zKVO3j7B</frmToolThingy_7>
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

miAddManual = createMenuItem(pm)
miAddManual.Caption = "Add manual AOB"
pm.Items.add(miAddManual)
miAddManual.OnClick = function()
    local textSig = inputQuery("Add manual AOB", "Paste the AOB you want to add","")
    if not textSig then return end
    local b = parseSig(textSig)
    local lv = fm.lvSigBlocks
	local it = lv.Items.add()
	it.Caption = "Manual"
    Blocks[#Blocks+1] = b
	it.SubItems.addText(toTextSig(b,MAX_PER_LINE)..((#b>MAX_PER_LINE) and " ...." or ""))
    updateOut()
end

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
