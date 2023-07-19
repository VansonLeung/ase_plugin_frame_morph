
function makeEmptyImage(width, height)
    local image = {}
    local pixels = {}
    local data = {}

    local cel = nil

    for y = 0, height - 1 do
        pixels[y] = {}
        for x = 0, width - 1 do
            pixels[y][x] = app.pixelColor.rgba(0, 0, 0, 0)
        end
    end

    for y = 0, height - 1 do
        for x = 0, width - 1 do
            local idx = ( (y * width) + x ) * 4
            local color = getColorARGBFromPixel(pixels[y][x])
            data[ idx + 0 ] = color[2];
            data[ idx + 1 ] = color[3];
            data[ idx + 2 ] = color[4];
            data[ idx + 3 ] = color[1];
        end
    end

    image["pixels"] = pixels
    image["data"] = data
    image["width"] = width
    image["height"] = height

    -- print(sprite.cels[1].bounds.x,sprite.cels[1].bounds.y,sprite.cels[1].bounds.width,sprite.cels[1].bounds.height)

    return image
end



function getImageFromSpriteFrame(sprite, frame)
    local image = {}
    local pixels = {}
    local data = {}

    print("cels", #sprite.cels)

    local cel = nil

    for i, _cel in ipairs(sprite.cels) do
        if _cel.frameNumber == frame.frameNumber then
            cel = _cel
        end
    end

    for y = 0, sprite.height - 1 do
        pixels[y] = {}
        for x = 0, sprite.width - 1 do
            pixels[y][x] = app.pixelColor.rgba(0, 0, 0, 0)
        end
    end

    for y = cel.bounds.y, cel.bounds.y + cel.bounds.height - 1 do
        for x = cel.bounds.x, cel.bounds.x + cel.bounds.width - 1 do
            pixels[y][x] = cel.image:getPixel(x - cel.bounds.x, y - cel.bounds.y)
        end
    end

    for y = 0, sprite.height - 1 do
        for x = 0, sprite.width - 1 do
            local idx = ( (y*sprite.width) + x ) * 4
            local color = getColorARGBFromPixel(pixels[y][x])
            data[ idx + 0 ] = color[2];
            data[ idx + 1 ] = color[3];
            data[ idx + 2 ] = color[4];
            data[ idx + 3 ] = color[1];
        end
    end

    image["pixels"] = pixels
    image["data"] = data
    image["width"] = sprite.width
    image["height"] = sprite.height

    -- print(sprite.cels[1].bounds.x,sprite.cels[1].bounds.y,sprite.cels[1].bounds.width,sprite.cels[1].bounds.height)

    return image
end



function fulfillImagePixelsFromItsData(image)
    local pixels = {}
    local width = image.width
    local height = image.height
    local data = image.data

    for y = 0, height - 1 do
        pixels[y] = {}
        for x = 0, width - 1 do
            pixels[y][x] = app.pixelColor.rgba(0, 0, 0, 0)
        end
    end

    for y = 0, height - 1 do
        for x = 0, width - 1 do
            local idx = ( (y * width) + x ) * 4
            local color = makePixelColorFromRGBAIntegers(
                data[ idx + 0 ],
                data[ idx + 1 ],
                data[ idx + 2 ],
                data[ idx + 3 ]
            )
            pixels[y][x] = color
        end
    end

    image["pixels"] = pixels

    return image
end




function rgbToHex(rgba)
	local hexadecimal = ''
	for key, value in pairs(rgba) do
		local hex = ''

		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end

		if(string.len(hex) == 0)then
			hex = '00'

		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end

		hexadecimal = hexadecimal .. hex
	end
	return hexadecimal
end




function getColorARGBFromPixel(pixel)
    return { 
        app.pixelColor.rgbaA(pixel),
        app.pixelColor.rgbaR(pixel),
        app.pixelColor.rgbaG(pixel),
        app.pixelColor.rgbaB(pixel),
    }
end


function makePixelColorFromRGBAIntegers(
    r,
    g,
    b,
    a
)
    return app.pixelColor.rgba(r, g, b, a)
end




function arrayToString(data)
    local strdata = ""
    for y = 0, #data - 1 do
        strdata = strdata .. string.format("%s,", data[y] )
    end
    return strdata
end


function getImageAsString(image)
    local str = ""
    local strdata = ""
    local width = image.width
    local height = image.height
    local pixels = image.pixels
    local data = image.data

    for y = 0, height - 1 do
        for x = 0, width - 1 do
            str = str .. string.format("#%s,", rgbToHex( getColorARGBFromPixel( pixels[y][x] )  )   )
        end
        str = str .. "\n"
    end

    for y = 0, #data - 1 do
        strdata = strdata .. string.format("%s,", data[y] )
    end

    return string.format("[Image] %s, width: %s, height: %s, data: %s\npixel:\n%s\n%s\n", image, image.width, image.height, #image.data, str, strdata)
end





