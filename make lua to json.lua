local file_name = "GameStringcn";
dofile(file_name..".lua")
local in_table = GameString;


local str = table2json(in_table);
local file=io.open(file_name..".json","w")
file:write(str)
io.close()
