--[[
Author: Skyrimfus
Discord ID: 244490308782391316
Name: Extensions Loader
Version: Public version 1.0

Written for CE 7.4


Description: 
	This extension checks for a folder called 'Extensions' located inside CE autorun folder.
	If it finds it, it scans that whole folder(and all sub-folders) and runs every .lua file

--]]
require('lfs')

local fExt = getAutorunPath().."\\Extensions\\"
local Folders = {fExt}
local Files = {}

local function fld(fExt)
	for folder in lfs.dir(fExt) do
		if not string.match(folder,"%.") then
			Folders[#Folders+1] = fExt..folder.."\\"
			fld(Folders[#Folders])
		end
	end
end



fld(fExt)

for i=1, #Folders do
 for file in lfs.dir(Folders[i]) do
  if file ~= "." and file ~= ".." and string.match(file,'^[^!]+.%.lua') then
    Files[#Files+1] = Folders[i].."\\"..file
  end
 end
end


for i=1, #Files do
	local opf = io.open(Files[i],"r")
	local rf = opf.read(opf,"*a")
	local fu = loadstring(rf)
	io.close(opf)
	fu()
end