local VIVID = 0.25
local BLUE_SEPARATION = 0.45

-- VIVID:
-- 0.00 = original Nordic
-- 0.10 = subtle
-- 0.18 = good default
-- 0.25 = more vivid
-- 0.35 = probably too much

-- BLUE_SEPARATION:
-- 0.00 = original light blue
-- 0.25 = subtle separation
-- 0.35 = good default
-- 0.50 = stronger separation

local function clamp(x)
	return math.max(0, math.min(255, x))
end

local function hex_to_rgb(hex)
	hex = hex:gsub("#", "")

	return tonumber(hex:sub(1, 2), 16),
		tonumber(hex:sub(3, 4), 16),
		tonumber(hex:sub(5, 6), 16)
end

local function rgb_to_hex(r, g, b)
	return string.format(
		"#%02X%02X%02X",
		clamp(math.floor(r + 0.5)),
		clamp(math.floor(g + 0.5)),
		clamp(math.floor(b + 0.5))
	)
end

local function vivid(hex, amount)
	local r, g, b = hex_to_rgb(hex)

	-- grayscale reference brightness
	local gray = 0.299 * r + 0.587 * g + 0.114 * b

	-- push color away from gray = more vivid
	r = gray + (r - gray) * (1 + amount)
	g = gray + (g - gray) * (1 + amount)
	b = gray + (b - gray) * (1 + amount)

	return rgb_to_hex(r, g, b)
end

local function mix(hex1, hex2, amount)
	local r1, g1, b1 = hex_to_rgb(hex1)
	local r2, g2, b2 = hex_to_rgb(hex2)

	return rgb_to_hex(
		r1 + (r2 - r1) * amount,
		g1 + (g2 - g1) * amount,
		b1 + (b2 - b1) * amount
	)
end

local function vivid_family(color)
	color.base = vivid(color.base, VIVID)
	color.bright = vivid(color.bright, VIVID)
	color.dim = vivid(color.dim, VIVID)
end

return {
	{
		"AlexvZyl/nordic.nvim",
		name = "nordic",
		lazy = false,
		priority = 1000,
		config = function()
			vim.o.termguicolors = true

			require("nordic").setup({
				transparent = {
					bg = true,
					float = true,
				},

				reduced_blue = false,
				italic_comments = false,
				bold_keywords = false,
				bright_border = true,

				on_palette = function(palette)
					-- Make the main syntax colors slightly more vivid.
					vivid_family(palette.red)
					vivid_family(palette.orange)
					vivid_family(palette.yellow)
					vivid_family(palette.green)
					vivid_family(palette.magenta)
					vivid_family(palette.cyan)

					-- Blues are used heavily by Nordic.
					palette.blue0 = vivid(palette.blue0, VIVID)
					palette.blue1 = vivid(palette.blue1, VIVID)
					palette.blue2 = vivid(palette.blue2, VIVID)

					-- Pull light blue away from cyan.
					-- blue2 is the one that can feel too cyan-ish.
					palette.blue2 = mix(palette.blue2, palette.blue0, BLUE_SEPARATION)
				end,

				-- on_highlight = function(highlights, _palette)
				-- 	-- Remove italics globally.
				-- 	for _, hl in pairs(highlights) do
				-- 		hl.italic = false
				-- 	end
				-- end,
                on_highlight = function(highlights, palette)
                    -- Remove italics globally.
                    for _, hl in pairs(highlights) do
                        hl.italic = false
                    end

                    -- Make the bottom statusline more readable.
                    -- This is the active statusline.
                    highlights.StatusLine = {
                        fg = palette.white0,
                        bg = palette.black0,
                    }

                    -- This is inactive statuslines.
                    highlights.StatusLineNC = {
                        fg = palette.gray4,
                        bg = palette.black0,
                    }

                    -- Make the vertical colorcolumn different from the horizontal cursorline.
                    -- CursorLine stays Nordic default.
                    highlights.ColorColumn = {
                        bg = palette.black1,
                    }
                end,
			})

			require("nordic").load()
		end,
	},
}
