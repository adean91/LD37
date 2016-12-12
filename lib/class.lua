local class = {}

function class:extend(subClass)
  return setmetatable(subClass or {}, {__index = self, __call = self.name or 'nil'})
end

function class:new(...)
  local copy = setmetatable({}, {__index = self})
  return copy, copy:init(...)
end

function class:init(...) end

return class