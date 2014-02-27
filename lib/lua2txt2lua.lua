function Split(szFullString, szSeparator)
local nFindStartIndex = 1
local nSplitIndex = 1
local nSplitArray = {}
while true do
   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
   if not nFindLastIndex then
    nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
    break
   end
   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
   nFindStartIndex = nFindLastIndex + string.len(szSeparator)
   nSplitIndex = nSplitIndex + 1
end
return nSplitArray
end

function makeTxt2Table(in_file)
	local t = {}
	for line in io.lines(in_file) do
		local key_value = Split(line,"	")
		local key_str = key_value[1]
		local value = key_value[2]

		local key_array = Split(key_str,"|")
		for key,v in pairs(key_array) do
			if string.find(v,"^[+-]?%d+$") ~=nil then
			key_array[key] = tonumber(v)
			end

		end


		for key,v in pairs(key_array) do
				if key == 1 then
					if t[key_array[1]]==nil then

						if key ~= #key_array then

							t[key_array[1]] = {}
						else
							t[key_array[1]] = value
						end
					end
				elseif key == 2 then
					if t[key_array[1]][key_array[2]]==nil then
						if key ~= #key_array then
							t[key_array[1]][key_array[2]]={}
						else
							t[key_array[1]][key_array[2]]= value
						end
					end

				elseif key == 3 then
					if t[key_array[1]][key_array[2]][key_array[3]]==nil then
						if key ~= #key_array then
							t[key_array[1]][key_array[2]][key_array[3]]={}
						 else
							t[key_array[1]][key_array[2]][key_array[3]]=value
						end
					end
				elseif key == 4 then
					if t[key_array[1]][key_array[2]][key_array[3]][key_array[4]]==nil then
						if key ~= #key_array then
							t[key_array[1]][key_array[2]][key_array[3]][key_array[4]]={}
						else
							t[key_array[1]][key_array[2]][key_array[3]][key_array[4]]=value
						end
					end
				elseif key == 5 then
					if t[key_array[1]][key_array[2]][key_array[3]][key_array[4]][key_array[5]]==nil then
						if key ~= #key_array then
							t[key_array[1]][key_array[2]][key_array[3]][key_array[4]][key_array[5]]={}
						else
							t[key_array[1]][key_array[2]][key_array[3]][key_array[4]][key_array[5]]=value
						end
					end
				end
		end
	end
	table.save( t, "temp\\tbl_temp.lua" )
	local t2,err = table.load( "temp\\tbl_temp.lua" )
	return t2
end


function table.show(t, name, indent)
   local cart     -- a container
   local autoref  -- for self references

   --[[ counts the number of elements in a table
   local function tablecount(t)
      local n = 0
      for _, _ in pairs(t) do n = n+1 end
      return n
   end
   ]]
   -- (RiciLake) returns true if the table is empty
   local function isemptytable(t) return next(t) == nil end

   local function basicSerialize (o)
      local so = tostring(o)
      if type(o) == "function" then
         local info = debug.getinfo(o, "S")
         -- info.name is nil because o is not a calling level
         if info.what == "C" then
            return string.format("%q", so .. ", C function")
         else
            -- the information is defined through lines
            return string.format("%q", so .. ", defined in (" ..
                info.linedefined .. "-" .. info.lastlinedefined ..
                ")" .. info.source)
         end
      elseif type(o) == "number" or type(o) == "boolean" then
         return so
      else
         return string.format("%q", so)
      end
   end

   local function addtocart (value, name, indent, saved, field)
      indent = indent or ""
      saved = saved or {}
      field = field or name

      cart = cart .. indent .. field

      if type(value) ~= "table" then
         cart = cart .. " = " .. basicSerialize(value) .. ";\n"
      else
         if saved[value] then
            cart = cart .. " = {}; -- " .. saved[value]
                        .. " (self reference)\n"
            autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
         else
            saved[value] = name
            --if tablecount(value) == 0 then
            if isemptytable(value) then
               cart = cart .. " = {};\n"
            else
               cart = cart .. " = {\n"
               for k, v in pairs(value) do
                  k = basicSerialize(k)
                  local fname = string.format("%s[%s]", name, k)
                  field = string.format("[%s]", k)
                  -- three spaces between levels
                  addtocart(v, fname, indent .. "   ", saved, field)
               end
               cart = cart .. indent .. "};\n"
            end
         end
      end
   end

   name = name or "__unnamed__"
   if type(t) ~= "table" then
      return name .. " = " .. basicSerialize(t)
   end
   cart, autoref = "", ""
   addtocart(t, name, indent)
   return cart .. autoref
end

function printtable(pkey,t)
		for key,value in pairs(t) do
		   if type(value) == "table" then
			   if pkey == "" then
					 printtable(key,value)
				else
					 printtable(pkey.."|"..key,value)
				end
		   else
				if pkey == "" then
					printtable_str = printtable_str..key.." "..tostring(value).." "
				else
					printtable_str = printtable_str..pkey.."|"..key.." "..tostring(value).." "
				end
		   end
		end
	end
function printtable2strings(pkey,t)
		for key,value in pairs(t) do
		   if type(value) == "table" then
			   if pkey == "" then
					 printtable2strings(key,value)
				else
					 printtable2strings(pkey.."|"..key,value)
				end
		   else
				if pkey == "" then
					printtable_str = printtable_str..key.."\" = \""..tostring(value).."\" \""
				else
					printtable_str = printtable_str..pkey.."|"..key.."\" = \""..tostring(value).."\" \""
				end
		   end
		end
	end


function LuaTable2Txt(t)
	printtable_str = ""
	printtable("",t)

	return printtable_str

end

function LuaTable2Strings(t)
	printtable_str = ""
	printtable2strings("",t)

	return printtable_str

end


function Txt2LuaTable(in_file,out_table)
	local t = makeTxt2Table(in_file)
	local str = table.show(t,out_table)
return str;
end
