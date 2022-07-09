local export = {}

--- Current facing direction.
local T_direction = nil
local T_FOR       = turtle.forward
local T_BAC       = turtle.back
local T_LEF       = turtle.turnLeft
local T_RIG       = turtle.turnRight
local T_UP        = turtle.up
local T_DOW       = turtle.down

local function facing_to_number(facing)
    local t = {
        ["west"] = 1,
        ["north"] = 2,
        ["east"] = 3,
        ["south"] = 4
    }
    return t[facing]
end

local function number_to_facing(number)
    local t = {
        [1] = "west",
        [2] = "north",
        [3] = "east",
        [4] = "south"
    }
    return t[number]
end

local function verticality_to_number(vert)
    local t = {
        ["up"] = 1,
        ["none"] = 0,
        ["down"] = -1
    }
    return t[vert]
end

local function number_to_verticality(number)
    local t = {
        [1] = "up",
        [0] = "none",
        [-1] = "down"
    }
    return t[number]
end

---@param logger Logger?
local function find_direction(logger)
    -- unable to find direction if not turtle or no gps has been set.
    if not (turtle or gps) then
        if logger then
            logger:info { "No GPS or TURTLE field. Unable to find direction." }
        end
        return nil
    end
    -- get the first location.
    local l1 = vector.new(gps.locate(2, false))
    if logger then
        logger:debg { string.format("1st location found: %dx %dy %dz", l1) }
    end
    -- attempt to get second location.
    local l2 = nil
    if T_FOR() or T_BAC() then
        -- try by going forwards to backwards
        l2 = gps.locate(2, false)
        if logger then
            logger:debg { string.format("2nd location found: %dx %dy %dz", l2) }
        end
    else
        -- unable to optain second location
        if logger then
            logger:info { "Unable to move forward or back." }
        end
        return nil
    end

    -- calculate direction
    vec = l2 - l1
    return ((vec.x + math.abs(vec.x) * 2) + (vec.z + math.abs(vec.z) * 3))
end

--- When the turtle moves in any direction this is used to fire the event 'turtleMove'.
---@param blocks number The number of blocks moved.
---@param verticality number The vertical direction of the turtle. Follows the mapping: 1 = up, 0 = none, -1 = down.
---@param direction number? Nil if no direction has been set yet. Otherwise a number according to the following map: 1 = west, 2 = north, 3 = east, 4 = south.
---@param logger Logger? The optional logger to use.
local function moveEvent(blocks, verticality, direction, logger)
    if logger then
        if direction then
            logger:info("event:turtleMove",
                string.format(
                    "Facing %s (%d) and verticality %s (%d) for a total of %d blocks.",
                    number_to_facing(direction),
                    direction,
                    number_to_verticality(verticality),
                    verticality,
                    blocks
                ))
        else
            logger:info("event:turtleMove",
                string.format(
                    "Verticality  %s (%d) for a total of %d blocks.",
                    number_to_verticality(verticality),
                    verticality,
                    blocks
                ))
        end
    end
    ---@diagnostic disable-next-line: undefined-field
    os.queueEvent("turtleMove", blocks, verticality, direction)
end

---Move the turtle forward one block.
---@return boolean success Whether the turtle could successfully move.
---@return string? reason The reason the turtle could not move.
turtle.forward = function()
    T_direction = T_direction or find_direction()
    b, res = T_FOR()
    ---@diagnostic disable-next-line: undefined-field
    moveEvent((b and 1 or 0), 0, T_direction, _G.logger)
    return b, res
end

---Move the turtle backwards one block.
---@return boolean success Whether the turtle could successfully move.
---@return string? reason The reason the turtle could not move.
turtle.back = function()
    T_direction = T_direction or find_direction()
    b, res = T_BAC()
    ---@diagnostic disable-next-line: undefined-field
    moveEvent((b and 1 or 0), 0, T_direction, _G.logger)
    return b, res
end

---Move the turtle up one block.
---@return boolean success Whether the turtle could successfully move.
---@return string? reason The reason the turtle could not move.
turtle.up = function()
    T_direction = T_direction or find_direction()
    b, res = T_UP()
    ---@diagnostic disable-next-line: undefined-field
    moveEvent(0, (b and 1 or 0), T_direction, _G.logger)
    return b, res
end

---Move the turtle downwards one block.
---@return boolean success Whether the turtle could successfully move.
---@return string? reason The reason the turtle could not move.
turtle.down = function()
    T_direction = T_direction or find_direction()
    b, res = T_DOW()
    ---@diagnostic disable-next-line: undefined-field
    moveEvent(0, (b and 1 or 0), T_direction, _G.logger)
    return b, res
end

---Rotate the turtle 90 degress to the left.
---@return boolean success Whether the turtle could successfully turn.
---@return string? reason The reason the turtle could not turn.
turtle.turnLeft = function()
    T_direction = T_direction or find_direction()
    if T_direction then
        if T_direction == 1 then
            T_direction = 4
        else
            T_direction = T_direction - 1
        end
    end
    b, res = T_LEF()
    ---@diagnostic disable-next-line: undefined-field
    moveEvent(0, 0, T_direction, _G.logger)
    return b, res
end

---Move the turtle backwards one block.
---@return boolean success Whether the turtle could successfully move.
---@return string? reason The reason the turtle could not move.
turtle.up = function()
    T_direction = T_direction or find_direction()
    if T_direction then
        if T_direction == 4 then
            T_direction = 1
        else
            T_direction = T_direction + 1
        end
    end
    b, res = T_RIG()
    ---@diagnostic disable-next-line: undefined-field
    moveEvent(0, 0, T_direction, _G.logger)
    return b, res
end

return export
