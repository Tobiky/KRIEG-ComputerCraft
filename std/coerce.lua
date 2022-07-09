--- Tries to coerce the value into the type, if any.
---
--- "boolean"\
---     {}, nil, false, 0, "" -> false\
---     {2}, true, 0, "t"     -> true\
---
--- "number"\
---     {}, nil, false, 0, "" -> 0\
---     "a", {1}, 1           -> 1\
---     "ab", {1,2}, 2        -> 2\
---     etc\
---
--- "table"\
---     {}, nil, false, 0, "" -> {}\
---     1                     -> {1}\
---     true                  -> {true}\
---     "abc"                 -> {"a", "b", "c"}\
---
--- "string"\
---     {}, nil, false, 0, "" -> ""\
---     {"a", "b"}            -> "ab"\
---     {97, 98}              -> "ab"\
---     97                    -> "a"\
---     true                  -> "true"\
--- @param value any
--- @param type string
--- @return any
local function coerce(value, type)
    if _G.type(value) == type then return value end

    local coerce_bool_table = {
        ["nil"]    = function() return false end,
        ["table"]  = function() return #value == 0 end,
        ["string"] = function() return string.len(value) == 0 end,
        ["number"] = function() return value == 0 end,
    }

    local coerce_number_table = {
        ["nil"]     = function() return 0 end,
        ["table"]   = function() return #value end,
        ["string"]  = string.len,
        ["boolean"] = function() if value then return 1 else return 0 end end,
    }

    local coerce_table_table = {
        ["nil"]     = function() return {} end,
        ["string"]  = function()
            str = {}
            value:gsub(".", function(c) table.insert(str, c) end)
            return str
        end,
        ["number"]  = function() return { value } end,
        ["boolean"] = function() return { value } end,
    }

    local coerce_string_table = {
        ["nil"]     = function() return "" end,
        ["table"]   = function()
            temp = {}
            for _, val in value do
                temp[#temp + 1] = coerce(value, "string")
            end
            return table.concat(temp)
        end,
        ["number"]  = string.char,
        ["boolean"] = (value and "true" or "false"),
    }

    local coerce_table = {
        [nil]       = coerce_bool_table,
        ["table"]   = coerce_table_table,
        ["string"]  = coerce_string_table,
        ["number"]  = coerce_number_table,
        ["boolean"] = coerce_bool_table,
    }

    return coerce_table[type][type(value)]()
end
