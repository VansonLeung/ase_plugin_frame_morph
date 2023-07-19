require('incl/__incl_math')
require('incl/__incl_get_image_from_sprite')
require('incl/__incl_get_feature_points')

print("=====")
print("welcome to van's frame_morph_v2")

function mathHypot(x ,y)
    return math.sqrt(x^2 + y^2)
end






























local sprite = app.activeSprite
if not sprite then
    app.alert("No sprite is active")
    return
end

-- Get the currently selected two frames
local frames = app.range.frames
if #frames ~= 2 then
    app.alert("Please select two frames for morphing")
    return
end



-- Get the source and target frames
local srcSprite = frames[1].sprite
local dstSprite = frames[2].sprite

print("frames: ", #frames)
print("frames[1]: ", frames[1])
print("frames[2]: ", frames[2])
print("frames[1].sprite: ", frames[1].sprite)
print("frames[2].sprite: ", frames[2].sprite)
print("sprite.frame: ", #sprite.frames, sprite.frames)


local layerCount = math.min(#srcSprite.layers, #dstSprite.layers)

    
-- Iterate through each pixel of each layer and perform linear interpolation
for i = 1, layerCount do
    local srcLayer = srcSprite.layers[i]
    local dstLayer = dstSprite.layers[i]
    
    -- local srcImage = getImageFromSprite(srcSprite)
    local srcImage = getImageFromSpriteFrame(srcSprite, frames[1])
    local dstImage = getImageFromSpriteFrame(dstSprite, frames[2])
    
    -- print(getImageAsString(srcImage) )
    -- print(getImageAsString(dstImage) )





    local featuregridwidth = 4
    local featuregridheight = 4



    local srcFpts = getFeaturePoints(
        srcImage, 
        featuregridwidth, 
        featuregridheight
    )


    local dstFpts = getFeaturePoints(
        dstImage,
        featuregridwidth,
        featuregridheight
    )



    



    print(srcFpts, #srcFpts)
    print(dstFpts, #dstFpts)

    drawFeaturePoints(srcImage, srcFpts, { 255, 0, 0, 255 } )
    drawFeaturePoints(dstImage, dstFpts, { 255, 0, 0, 255 } )
    
    -- print( arrayToString( srcImage.data ) )







    local outImages = {}

    local framerate = (frames[2].frameNumber - frames[1].frameNumber)
    

    for frame = frames[1].frameNumber + 1, frames[2].frameNumber - 1 do
        
        local outImage = makeEmptyImage(
            srcImage.width,
            srcImage.height
        )

        local j = frame - frames[1].frameNumber

        getFrame(
            srcImage,
            dstImage,
            outImage,
            srcFpts,
            dstFpts,
            j / framerate,
            math.sqrt(2)
        )

        fulfillImagePixelsFromItsData(outImage)
        outImages[frame] = outImage
    end


    print("Framerate:", framerate)

    for frame = frames[1].frameNumber + 1, frames[2].frameNumber - 1 do
        print(frame)

        local newImage = Image(
            srcImage.width, 
            srcImage.height
        )

        local outImage = outImages[frame]

        for y = 0, srcImage.height - 1 do
            for x = 0, srcImage.width - 1 do
                newImage:drawPixel(
                    x, 
                    y,
                    outImage.pixels[y][x]
                )
            end
        end

        local newCel = srcSprite:newCel(
            srcLayer, 
            frame, 
            newImage, 
            Point(0, 0)
        )

    end

end









