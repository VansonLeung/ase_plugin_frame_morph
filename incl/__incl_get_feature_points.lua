require('__incl_math')





function getFeaturePoints(png, n, m)
    local fpts = {}
    if n < 1 or m < 1 then
        return fpts
    end
    
    local cw = png.width / n
    local ch = png.height / m
    local ccx = 0
    local ccy = 0
    local fc = 0
    local fd = png.height + png.width
    local tc = 0
    local idx = 0

    -- print(m, n)

    for j = 0, m+1 do
        fpts[j] = {}
        for i = 0, n+1 do
            fpts[j][i] = {
                [0] = i * cw, 
                [1] = j * ch
            }
            -- print(j, m, i, n)
            if j > 0 and j < m and i > 0 and i < n then
                fd = png.height + png.width
                fc = 0
                for y = 0, ch - 1 do
                    for x = 0, cw - 1 do
                        idx = (png.width * math.floor(y + j * ch - ch / 2) + math.floor(x + i * cw - cw / 2)) * 4
                        -- print("idx", idx)
                        tc = 0
                        tc = tc + math.abs( KV(png.data, (idx + 1) ) - KV(png.data, (idx + 5) ) )
                        tc = tc + math.abs( KV(png.data, (idx + 2) ) - KV(png.data, (idx + 6) ) )
                        tc = tc + math.abs( KV(png.data, (idx + 3) ) - KV(png.data, (idx + 7) ) )
                        tc = tc + math.abs( KV(png.data, (idx + 1) ) - KV(png.data, (idx - 3) ) )
                        tc = tc + math.abs( KV(png.data, (idx + 2) ) - KV(png.data, (idx - 2) ) )
                        tc = tc + math.abs( KV(png.data, (idx + 3) ) - KV(png.data, (idx - 1) ) )
                        tc = tc + math.abs( KV(png.data, (idx + 1) ) - KV(png.data, (idx + png.width + 1) ) )
                        tc = tc + math.abs( KV(png.data, (idx + 2) ) - KV(png.data, (idx + png.width + 2) ) )
                        tc = tc + math.abs( KV(png.data, (idx + 3) ) - KV(png.data, (idx + png.width + 3) ) )
                        tc = tc + math.abs( KV(png.data, (idx + 1) ) - KV(png.data, (idx - png.width + 1) ) )
                        tc = tc + math.abs( KV(png.data, (idx + 2) ) - KV(png.data, (idx - png.width + 2) ) )
                        tc = tc + math.abs( KV(png.data, (idx + 3) ) - KV(png.data, (idx - png.width + 3) ) )
                        
                        if (tc == fc and math_hypot(x - cw / 2, y - ch / 2) < fd) or (tc > fc) then
                            fpts[j][i] = {
                                [0] = x + i * cw - cw / 2, 
                                [1] = y + j * ch - ch / 2
                            }
                            fc = tc
                            fd = math_hypot(x - cw / 2, y - ch / 2)
                        end
                    end
                end
            end
        end
    end
    
    return fpts
end





function drawFeaturePoints(png, fpts, col)
    local idx = 0

    for j = 0, #fpts - 1 do
        for i = 0, #fpts[j] - 1 do
            idx = (
                png.width 
                * math.floor( ( fpts[j][i][1] or 0 ) )
                + math.floor( ( fpts[j][i][0] or 0 ) )
            ) * 4
            
            png.data[idx] = col[1]
            png.data[idx+1] = col[2]
            png.data[idx+2] = col[3]
            png.data[idx+3] = col[4]
        end
    end
end



