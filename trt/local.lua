local T_FOR = turtle.forward
local T_BAC = turtle.back
local T_UP  = turtle.up
local T_DOW = turtle.down
local T_LEF = turtle.turnLeft
local T_RIG = turtle.turnRight

local pos = vector.new { 0, 0, 0 }
local dir = vector.new { 1, 0, 0 }
local up  = vector.new { 0, 1, 0 }

---Move the turtle forward one block.
---@return boolean success Whether the turtle could successfully move.
---@return string? reason The reason the turtle could not move.
turtle.forward = function()
    pos = pos + dir
    return T_FOR()
end

---Move the turtle backwards one block.
---@return boolean success Whether the turtle could successfully move.
---@return string? reason The reason the turtle could not move.
turtle.back = function()
    pos = pos + dir
    return T_BAC()
end

---Move the turtle up one block.
---@return boolean success Whether the turtle could successfully move.
---@return string? reason The reason the turtle could not move.
turtle.up = function()
    pos = pos + up
    return T_UP()
end

---Move the turtle downwards one block.
---@return boolean success Whether the turtle could successfully move.
---@return string? reason The reason the turtle could not move.
turtle.down = function()
    pos = pos - up
    return T_DOW()
end

---Rotate the turtle 90 degress to the left.
---@return boolean success Whether the turtle could successfully turn.
---@return string? reason The reason the turtle could not turn.
turtle.turnLeft = function()
    dir = vector.new { dir.z, dir.y, dir.x }
    return T_LEF()
end

---Move the turtle backwards one block.
---@return boolean success Whether the turtle could successfully move.
---@return string? reason The reason the turtle could not move.
turtle.up = function()
    dir = vector.new { dir.z, dir.y, -dir.x }
    return T_RIG()
end

return {
    reset_direction = function()
        local turn_fn = (dir.z == 1)
            and turtle.turnLeft
            or turtle.turnRight

        repeat
            turn_fn()
        until dir.x == 1
    end
}
