local function EMPTY_FUNC(...) end

---@class Logger
local Logger = {

    ---Logs the message as debug, optionally part of service.
    ---@param self Logger The logger instance to write to.
    ---@param service string|any The optional service. If service is a string it will be interpreted as the service, otherwise as part of the arguments. Use table function call notation if you want to skip it.
    ---@param ... any The arguments that go into printing. Are converted the Lua way (convert to string and concatenate).
    debg = function(self, service, ...) end,

    ---Logs the message as information, optionally part of service.
    ---@param self Logger The logger instance to write to.
    ---@param service string|any The optional service. If service is a string it will be interpreted as the service, otherwise as part of the arguments. Use table function call notation if you want to skip it.
    ---@param ... any The arguments that go into printing. Are converted the Lua way (convert to string and concatenate).
    info = function(self, service, ...) end,

    ---Logs the message as warning, optionally part of service.
    ---@param self Logger The logger instance to write to.
    ---@param service string|any The optional service. If service is a string it will be interpreted as the service, otherwise as part of the arguments. Use table function call notation if you want to skip it.
    ---@param ... any The arguments that go into printing. Are converted the Lua way (convert to string and concatenate).
    warn = function(self, service, ...) end,

    ---Logs the message as error, optionally part of service.
    ---@param self Logger The logger instance to write to.
    ---@param service string|any The optional service. If service is a string it will be interpreted as the service, otherwise as part of the arguments. Use table function call notation if you want to skip it.
    ---@param ... any The arguments that go into printing. Are converted the Lua way (convert to string and concatenate).
    errr = function(self, service, ...) end,
}

---Returns a logger that reports nothing.
---@return Logger logger The empty logger object.
local function empty()
    return Logger
end

local function logfn(type, service, ...)
    io.write("[" .. os.date("%c") .. "]")
    local i = 1
    if type(service) == "string" then
        io.write("[" .. service .. "] ")
    elseif service then
        arg[0] = service
        i = 0
    end
    io.write("[" .. type .. "] ")
    io.write(table.unpack({ ... }, i))
    io.write("\n")
end

local function debg(self, service, ...)
    logfn("DEBG", service, table.unpack({ ... }))
end

local function info(self, service, ...)
    logfn("INFO", service, table.unpack({ ... }))
end

local function warn(self, service, ...)
    logfn("WARN", service, table.unpack({ ... }))
end

local function errr(self, service, ...)
    logfn("ERRR", service, table.unpack({ ... }))
end

---Returns a new instace of a logger.
---@return Logger logger The newly created instance of the logger.
local function new()
    return {
        debg,
        info,
        warn,
        errr
    }
end

return {
    empty,
    new
}
