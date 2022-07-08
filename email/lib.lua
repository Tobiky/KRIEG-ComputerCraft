--- Verifies that the recipient part follows the format requirement. Must be /^t:\w{2,16}$/.
--- @param line string The line, or part of a line, that should contain the recipient.
--- @return boolean True if the input is formatted correctly, otherwise false.
local function verify_recipient(line)
    return string.find(line, "^t:[%w_][%w_]+$") ~= nil and string.len(line) <= 18
end

--- Verifies that the sender part follows the format requirement. Must be /^r:\w{2,16}$/.
--- @param line string The line, or part of the line, that should contain the sender.
--- @return boolean True if the input is formatted correctly, otherwise false.
local function verifiy_sender(line)
    return string.find(line, "^r:[%w_][%w_]+$") ~= nil and string.len(line) <= 18
end

--- Verifies that the subject part follows the format requirement. Must be /^s:[^\n\r]{0,52}$/.
--- @param line string The line, or part of the line, that should contain the sender.
--- @return boolean True if the input is formatted correctly, otherwise false.
local function verify_subject(line)
    return string.find(line, "^s:[^%c\\n\\r]") ~= nil and string.len(line) <= 52
end

local function get_recipient(line)
    if verify_recipient(line) then
        return line:sub(line:find(":", nil, true) + 1)
    end
end

local function get_sender(line)
    if verifiy_sender(line) then
        return line:sub(line:find(":", nil, true) + 1)
    end
end

local function get_subject(line)
    if verify_subject(line) then
        return line:sub(line:find(":", nil, true) + 1)
    end
end
