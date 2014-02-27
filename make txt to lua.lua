dofile( "lib\\table.save-1.0.lua" )
dofile( "lib\\lua2txt2lua.lua" )


local in_file = "GameStringpt.txt"
local out_table = "GameString_en"
local out_file = "GameStringpt.lua.new"


local str = Txt2LuaTable(in_file,out_table)


local file=io.open(out_file,"w")
file:write(str)
io.close()
