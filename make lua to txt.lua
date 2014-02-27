
dofile( "lib\\table.save-1.0.lua" )
dofile( "lib\\lua2txt2lua.lua" )



local in_file = "GameStringcn.lua";
local out_file = "GameStringcn.txt";
dofile(in_file)
local in_table = GameString;


local str = LuaTable2Txt(in_table);

local file=io.open(out_file,"w")
file:write(str)
io.close()


