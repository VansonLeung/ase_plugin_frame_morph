

function math_hypot(x ,y)
    return math.sqrt(x^2 + y^2)
end


function KV(set, key)
    -- print(set, key)
    if set[(key)] ~= nil then
        return set[(key)]
    end
    return 0
end
