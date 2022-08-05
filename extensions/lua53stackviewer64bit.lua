if fm then fm.destroy() end
local fs,ss--,fm
local L--lua state
local stack_top, stack_bot, elements

local typedef = {"boolean","lightuserdata","number","string","table","function","userdata","thread","numtags"}
typedef[-1] = "none"
typedef[0] = "nil"
local function tovalue(i,id)
	if id==1 then--bool
		return readInteger(stack_top+(i<<4)) == 0 and "false" or "true"
	elseif id==4 then--string
		return readString(readInteger(stack_top+(i<<4))+0x20,500)
	elseif id==3 then--number
		return readInteger(stack_top+(i<<4))
	else
		return "not implemented"
	end
end


fs = [=[<?xml version="1.0" encoding="utf-8"?>
<FormData>
  <frmStackViewer Class="TCEForm" Encoding="Ascii85">y.jSP,AtI}36KC(,L;uPUFHi$sH)a@BaMa#Gz%oAfZ9b?h8S:$Hge2sTlE9FsQNekf-d=M^g2vlLIUD3K--/.;wA39xkuOek@]XqP%Bw(w[0O-RP6ClOTg}%Jw]Lc)^/Dn:J!/g9@w8#n7;nIn}jZG/@%S]!2Dr6x$6o%MJ{U*Gh!9GoyHXL8OH*yE+uNYX!cos0-XTV)WqxG!H9_[W/h@Pn823B*L^pa9FeIqQ:p([!w%})o)5%^:]xJh%d7J0Dqkg)3lES;P=r)LZ2%O)s*t1$),KnB9qkSnZ)$E9@y]R3eCy?f3AM0t)B}B/1RK4G!=K)W]4[7Pmg%l6EELzcjW{Heoa_8A(*{lMxQBRa47-@2uY/!GyA3-HwJlX?AtG/#!T;qBtRvc(T7dI5nu}i)MU92+Evri@M9RMsYKa9wR/]F=81X/-@Pp9-mTmeZB;WEonLokiuD^tNP)HSTcAQ{29ah+!H5TJIrU_JYLp7Z]%nVHgy#@)VTx@TfzqN(AyTcZziFKGQzNR,YqP+J^1#OEC@wB/F=BE*!aV+s,_1ng5oo*-]?7kgurE(+IF[/T3^yuM/AlM/@[-I6eU8WU-Y$,)#5d-YYiQurPUiDV!A;lykg/r{WfzJ8RQjI.9TGDrJi]r7H0h[6dZ97@edSPn*;ev[RJ,#O*({N%/nZ{GFe+A#Zx=aW6rc!1N^]q:%E(Wv-+Bjf+3+(15]mu^fx%o}1NW5GANLU*cFJz#aAXzw62@Jg%/:AkjVZixnD-=**^u!B!s9#Jidy;J[Lvs+sq^U+4!hU++^mc{SNfh^]242+rbWU_g8^eM#O+Cd*tW3lzK[l60UvtZ?(ZD.;:1uIA:zQ5Jt(JY:2L</frmStackViewer>
</FormData>
]=]
ss = createStringStream(fs)
fm = createFormFromStream(ss)
ss.destroy()

fm.inLuaState.OnChange = function(s)
L = getAddressSafe(s.Text)
end







local tm = createTimer(fm)
tm.Interval = 100
tm.OnTimer = function()
	if L == nil then return end
	stack_top = readPointer(readPointer(L+0x20))
	stack_bot = readPointer(L+0x10)
	elements = (stack_bot-stack_top-0x10)>>4
	fm.inStackBot.Text = string.format("%X",stack_bot)
	fm.inStackTop.Text = string.format("%X",stack_top)
	fm.lElements.Caption = "Elements: "..elements
	
	
	fm.lvStack.Items.clear()
	for i=1,elements do
		local it = fm.lvStack.Items.add()
		local typeID = readInteger(stack_top+(i<<4)+8)&0xF
		it.Caption = i
		it.SubItems.add(typedef[typeID])
		it.SubItems.add(tovalue(i,typeID))
	end
	
end




fm.show()
