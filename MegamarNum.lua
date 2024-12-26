local MegamarNum = {}

-- Constructor
function MegamarNum.new(base, exponent)
    local self = {}
    self.base = base or 1
    self.exponent = exponent or 0
    setmetatable(self, { __index = MegamarNum })
    return self
end

-- Formatting for Four Array Notation
function MegamarNum:toString()
    if self.array then
        return "{" .. table.concat(self.array, ", ") .. "}"
    else
        return string.format("%s x 10^%s", self.base, self.exponent)
    end
end

-- Simplify the number
function MegamarNum:simplify()
    while math.abs(self.base) >= 10 do
        self.base = self.base / 10
        self.exponent = self.exponent + 1
    end
    while math.abs(self.base) < 1 and self.base ~= 0 do
        self.base = self.base * 10
        self.exponent = self.exponent - 1
    end
    return self
end

-- Four Array Notation
function MegamarNum.newArray(x, y, z, w)
    local self = {}
    self.array = { x or 0, y or 0, z or 0, w or 0 }
    setmetatable(self, { __index = MegamarNum })
    return self
end

function MegamarNum:fourArrayNext()
    local x, y, z, w = table.unpack(self.array)
    if w > 0 then
        w = w - 1
    elseif z > 0 then
        z = z - 1
        w = y
    elseif y > 0 then
        y = y - 1
        z = x
        w = x
    else
        x = x - 1
        y = x
        z = x
        w = x
    end
    return MegamarNum.newArray(x, y, z, w)
end

-- Fast-Growing Hierarchy
function MegamarNum:fastGrowing(level, n)
    if level == 0 then
        return n + 1
    elseif level == 1 then
        return 2 * n
    elseif level == 2 then
        return n ^ n
    else
        return self:fastGrowing(level - 1, self:fastGrowing(level, n))
    end
end

-- Slow-Growing Hierarchy
function MegamarNum:slowGrowing(level, n)
    if level == 0 then
        return 0
    elseif level == 1 then
        return n
    elseif level == 2 then
        return math.floor(math.log(n, 2))
    else
        return self:slowGrowing(level - 1, self:slowGrowing(level, n))
    end
end

-- Handle large numbers for Four Array Notation
function MegamarNum:handleLargeFourArray(maxBase, maxExponent)
    local x, y, z, w = table.unpack(self.array)
    if x > maxBase or y > maxBase or z > maxBase or w > maxExponent then
        error("Number exceeds library capacity!")
    end
    return self
end

return MegamarNum
