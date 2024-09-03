local pos = {x=1.743873358, y=0.8921902776, z=-7.242519855}





--[[
x axis : -0.967479825 4.180755615 
y axis : -1.891366959 4.693154335
z axis : -2.733372688 -1.158482075

--]]

local parent = AddressList.createMemoryRecord();parent.Description="Parent";parent.IsAddressGroupHeader = true
function get3DDistance(src,dest)
 local dx = src.x-dest.x
 local dy = src.y-dest.y
 local dz = src.z-dest.z

 return math.sqrt(dx*dx+dy*dy+dz*dz)
end


list = MainForm.Foundlist3.Items

good = {}
for i=0, list.Count-1 do
local straddr = list[i].Caption
local addr = tonumber("0x"..straddr)
if not addr then goto cont end
local gem = {x=readFloat(addr-0x20), y=readFloat(addr-0x10), z=readFloat(addr+0)}
if gem.x == nil or gem.z == nil  then goto cont end
local dst = get3DDistance(pos, gem)
--printf("addr:%X  | dst: %s",addr,dst)

if dst < 5 then
 local t = {dst = dst, addr = addr}
 local placetoinsert = #good+1
 for j=1, #good do
   if dst < good[j].dst then placetoinsert = j;break end
 end
 table.insert(good,placetoinsert,t)
 --local m = AddressList.createMemoryRecord(); m.Description = dst; m.Address = addr;m.Parent = parent
end
::cont::
end


for i=1, #good do
 local m = AddressList.createMemoryRecord()
 m.Description = good[i].dst
 m.Address = good[i].addr
 m.Parent = parent
end

printf("Found %s good addresses", #good)
--PhysX3_x64.physx::ProjectionPlaneProperty::ProjectionPlaneProperty+1082
--PhysX3_x64.dll+D4A34