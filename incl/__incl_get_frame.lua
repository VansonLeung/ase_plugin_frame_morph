require('__incl_math')


function tridraw(inpng1, inpng2, outpng, incoords1, incoords2, outcoords, alfa, subpixel)
    -- vectors init
    local bdx = outcoords[2][0] - outcoords[0][0]
    local bdy = outcoords[2][1] - outcoords[0][1]
    local adx = outcoords[2][0] - outcoords[1][0]
    local ady = outcoords[2][1] - outcoords[1][1]
    local bl = math_hypot(bdx, bdy)
    local al = math_hypot(adx, ady)
    
    if bl == 0 or al == 0 then
        return
    end
    
    local inbdx1 = incoords1[2][0] - incoords1[0][0]
    local inbdy1 = incoords1[2][1] - incoords1[0][1]
    local inadx1 = incoords1[2][0] - incoords1[1][0]
    local inady1 = incoords1[2][1] - incoords1[1][1]
    local inbl1 = math_hypot(inbdx1, inbdy1)
    local inal1 = math_hypot(inadx1, inady1)
    
    if inbl1 == 0 or inal1 == 0 then
        return
    end
    
    local inbdx2 = incoords2[2][0] - incoords2[0][0]
    local inbdy2 = incoords2[2][1] - incoords2[0][1]
    local inadx2 = incoords2[2][0] - incoords2[1][0]
    local inady2 = incoords2[2][1] - incoords2[1][1]
    local inbl2 = math_hypot(inbdx2, inbdy2)
    local inal2 = math_hypot(inadx2, inady2)
    
    if inbl2 == 0 or inal2 == 0 then
        return
    end
    
    -- swap to work on longer tri side
    if al > bl then
        outcoords[3] = outcoords[0]
        outcoords[0] = outcoords[1]
        outcoords[1] = outcoords[3]
        bdx = outcoords[2][0] - outcoords[0][0]
        bdy = outcoords[2][1] - outcoords[0][1]
        adx = outcoords[2][0] - outcoords[1][0]
        ady = outcoords[2][1] - outcoords[1][1]
        bl = math_hypot( bdx, bdy )
        al = math_hypot( adx, ady )
        incoords1[3] = incoords1[0]
        incoords1[0] = incoords1[1]
        incoords1[1] = incoords1[3]
        inbdx1 = incoords1[2][0] - incoords1[0][0]
        inbdy1 = incoords1[2][1] - incoords1[0][1]
        inadx1 = incoords1[2][0] - incoords1[1][0]
        inady1 = incoords1[2][1] - incoords1[1][1]
        inbl1 = math_hypot( inbdx1, inbdy1 )
        inal1 = math_hypot( inadx1, inady1 )
        incoords2[3] = incoords2[0]
        incoords2[0] = incoords2[1]
        incoords2[1] = incoords2[3]
        inbdx2 = incoords2[2][0] - incoords2[0][0]
        inbdy2 = incoords2[2][1] - incoords2[0][1]
        inadx2 = incoords2[2][0] - incoords2[1][0]
        inady2 = incoords2[2][1] - incoords2[1][1]
        inbl2 = math_hypot( inbdx2, inbdy2 )
        inal2 = math_hypot( inadx2, inady2 )
    end
    
    -- iterate on b side, get pb, pa
    local itarg = math.floor(bl * subpixel)
    local iprog = 0
    local jprog = 0
    local pa = {[0] = 0, [1] = 0}
    local pb = {[0] = 0, [1] = 0}
    local ps = {[0] = 0, [1] = 0}
    local sl = 0
    local idx1 = 0
    local idx2 = 0
    local idx3 = 0
    local inpa1 = {[0] = 0, [1] = 0}
    local inpb1 = {[0] = 0, [1] = 0}
    local inps1 = {[0] = 0, [1] = 0}
    local inpa2 = {[0] = 0, [1] = 0}
    local inpb2 = {[0] = 0, [1] = 0}
    local inps2 = {[0] = 0, [1] = 0}
    local ins1 = {[0] = 0, [1] = 0, [2] = 0, [3] = 0}
    local ins2 = {[0] = 0, [1] = 0, [2] = 0, [3] = 0}
    
    for i = 0, itarg - 1 do
        iprog = i / itarg
        pb = {
            [0] = outcoords[0][0] + bdx * iprog, 
            [1] = outcoords[0][1] + bdy * iprog
        }
        pa = {
            [0] = outcoords[1][0] + adx * iprog, 
            [1] = outcoords[1][1] + ady * iprog
        }
        inpb1 = {
            [0] = incoords1[0][0] + inbdx1 * iprog, 
            [1] = incoords1[0][1] + inbdy1 * iprog
        }
        inpa1 = {
            [0] = incoords1[1][0] + inadx1 * iprog, 
            [1] = incoords1[1][1] + inady1 * iprog
        }
        inpb2 = {
            [0] = incoords2[0][0] + inbdx2 * iprog, 
            [1] = incoords2[0][1] + inbdy2 * iprog
        }
        inpa2 = {
            [0] = incoords2[1][0] + inadx2 * iprog, 
            [1] = incoords2[1][1] + inady2 * iprog
        }
        
        sl = math_hypot(pb[0] - pa[0], pb[1] - pa[1])
        
        -- iterate on pb-pa line, ps is the output coordinates
        for j = 0, math.floor(sl * subpixel) - 1 do
            jprog = j / math.floor(sl * subpixel)
            -- sample coordinates
            ps = {
                [0] = pb[0] + (pa[0] - pb[0]) * jprog, 
                [1] = pb[1] + (pa[1] - pb[1]) * jprog
            }
            inps1 = {
                [0] = inpb1[0] + (inpa1[0] - inpb1[0]) * jprog, 
                [1] = inpb1[1] + (inpa1[1] - inpb1[1]) * jprog
            }
            inps2 = {
                [0] = inpb2[0] + (inpa2[0] - inpb2[0]) * jprog, 
                [1] = inpb2[1] + (inpa2[1] - inpb2[1]) * jprog
            }
            ins1 = {[0] = 0, [1] = 0, [2] = 0, [3] = 0}
            ins2 = {[0] = 0, [1] = 0, [2] = 0, [3] = 0}
            
            -- RGBA values if on image
            if inps1[0] >= 0 and inps1[0] < inpng1.width and inps1[1] >= 0 and inps1[1] < inpng1.height then
                idx2 = (inpng1.width * math.floor(inps1[1]) + math.floor(inps1[0])) * 4
                ins1 = {
                    [0] = inpng1.data[idx2 + 0], 
                    [1] = inpng1.data[idx2 + 1], 
                    [2] = inpng1.data[idx2 + 2], 
                    [3] = inpng1.data[idx2 + 3]
                }
            end
            
            if inps2[0] >= 0 and inps2[0] < inpng2.width and inps2[1] >= 0 and inps2[1] < inpng2.height then
                idx3 = (inpng2.width * math.floor(inps2[1]) + math.floor(inps2[0])) * 4
                ins2 = {
                    [0] = inpng2.data[idx3 + 0], 
                    [1] = inpng2.data[idx3 + 1], 
                    [2] = inpng2.data[idx3 + 2], 
                    [3] = inpng2.data[idx3 + 3]
                }
            end
            
            -- output draw, alfa blend
            if ps[0] >= 0 and ps[0] < outpng.width and ps[1] >= 0 and ps[1] < outpng.height then
                idx1 = (outpng.width * math.floor(ps[1]) + math.floor(ps[0])) * 4
                outpng.data[idx1 + 0] = math.floor(ins1[0] * (1 - alfa) + ins2[0] * alfa)
                outpng.data[idx1 + 1] = math.floor(ins1[1] * (1 - alfa) + ins2[1] * alfa)
                outpng.data[idx1 + 2] = math.floor(ins1[2] * (1 - alfa) + ins2[2] * alfa)
                outpng.data[idx1 + 3] = math.floor(ins1[3] * (1 - alfa) + ins2[3] * alfa)

                -- outpng.data[idx1 + 0] = math.floor(ins1[0] * (1) + ins2[0] * 0)
                -- outpng.data[idx1 + 1] = math.floor(ins1[1] * (1) + ins2[1] * 0)
                -- outpng.data[idx1 + 2] = math.floor(ins1[2] * (1) + ins2[2] * 0)
                -- outpng.data[idx1 + 3] = math.floor(ins1[3] * (1) + ins2[3] * 0)

                -- outpng.data[idx1 + 0] = math.floor(ins1[0] * (0) + ins2[0] * 1)
                -- outpng.data[idx1 + 1] = math.floor(ins1[1] * (0) + ins2[1] * 1)
                -- outpng.data[idx1 + 2] = math.floor(ins1[2] * (0) + ins2[2] * 1)
                -- outpng.data[idx1 + 3] = math.floor(ins1[3] * (0) + ins2[3] * 1)
            end
        end
    end
end



function getFrame(png1, png2, outpng, fpts1, fpts2, alfa, subpixel)
    for j = 0, #fpts1 - 1 - 1 do
        for i = 0, #fpts1[j] - 1 - 1 do
            -- print(j, i)

            -- inpng1 feature point triangle 1
            local inCoords1Triangle1 = {}
            inCoords1Triangle1[0] = fpts1[j][i]
            inCoords1Triangle1[1] = fpts1[j][i + 1]
            inCoords1Triangle1[2] = fpts1[j + 1][i]
            
            -- inpng2 feature point triangle 1
            local inCoords2Triangle1 = {}
            inCoords2Triangle1[0] = fpts2[j][i]
            inCoords2Triangle1[1] = fpts2[j][i + 1]
            inCoords2Triangle1[2] = fpts2[j + 1][i]
            
            local outCoordsTriangle1 = {}

            local outCoordsTriangle1_0 = {}
            outCoordsTriangle1_0[0] = fpts1[j][i][0] * (1 - alfa) + fpts2[j][i][0] * alfa
            outCoordsTriangle1_0[1] = fpts1[j][i][1] * (1 - alfa) + fpts2[j][i][1] * alfa

            local outCoordsTriangle1_1 = {}
            outCoordsTriangle1_1[0] = fpts1[j][i + 1][0] * (1 - alfa) + fpts2[j][i + 1][0] * alfa
            outCoordsTriangle1_1[1] = fpts1[j][i + 1][1] * (1 - alfa) + fpts2[j][i + 1][1] * alfa

            local outCoordsTriangle1_2 = {}
            outCoordsTriangle1_2[0] = fpts1[j + 1][i][0] * (1 - alfa) + fpts2[j + 1][i][0] * alfa
            outCoordsTriangle1_2[1] = fpts1[j + 1][i][1] * (1 - alfa) + fpts2[j + 1][i][1] * alfa

            outCoordsTriangle1[0] = outCoordsTriangle1_0
            outCoordsTriangle1[1] = outCoordsTriangle1_1
            outCoordsTriangle1[2] = outCoordsTriangle1_2
            -- out triangle 1 interpolated at alfa

            tridraw(png1, png2, outpng, inCoords1Triangle1, inCoords2Triangle1, outCoordsTriangle1, alfa, subpixel)
            
            -- inpng1 feature point triangle 2
            local inCoords1Triangle2 = {}
            inCoords1Triangle2[0] = fpts1[j][i + 1]
            inCoords1Triangle2[1] = fpts1[j + 1][i + 1]
            inCoords1Triangle2[2] = fpts1[j + 1][i]
            
            -- inpng2 feature point triangle 2
            local inCoords2Triangle2 = {}
            inCoords2Triangle2[0] = fpts2[j][i + 1]
            inCoords2Triangle2[1] = fpts2[j + 1][i + 1]
            inCoords2Triangle2[2] = fpts2[j + 1][i]
            
            local outCoordsTriangle2 = {}

            local outCoordsTriangle2_0 = {}
            outCoordsTriangle2_0[0] = fpts1[j][i + 1][0] * (1 - alfa) + fpts2[j][i + 1][0] * alfa
            outCoordsTriangle2_0[1] = fpts1[j][i + 1][1] * (1 - alfa) + fpts2[j][i + 1][1] * alfa

            local outCoordsTriangle2_1 = {}
            outCoordsTriangle2_1[0] = fpts1[j + 1][i + 1][0] * (1 - alfa) + fpts2[j + 1][i + 1][0] * alfa
            outCoordsTriangle2_1[1] = fpts1[j + 1][i + 1][1] * (1 - alfa) + fpts2[j + 1][i + 1][1] * alfa

            local outCoordsTriangle2_2 = {}
            outCoordsTriangle2_2[0] = fpts1[j + 1][i][0] * (1 - alfa) + fpts2[j + 1][i][0] * alfa
            outCoordsTriangle2_2[1] = fpts1[j + 1][i][1] * (1 - alfa) + fpts2[j + 1][i][1] * alfa

            outCoordsTriangle2[0] = outCoordsTriangle2_0
            outCoordsTriangle2[1] = outCoordsTriangle2_1
            outCoordsTriangle2[2] = outCoordsTriangle2_2
            -- out triangle 1 interpolated at alfa
            
            tridraw(png1, png2, outpng, inCoords1Triangle2, inCoords2Triangle2, outCoordsTriangle2, alfa, subpixel)
        end
    end
end

