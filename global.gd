extends Node

var previous_screen_image		# For transitions

static func rgb2ryb(colour):
	# Convert from Color RGB to RYB values
	var r = colour.r
	var g = colour.g
	var b = colour.b
	
	# Remove whiteness from colour
	var w = min(min(r, g), b)
	r -= w
	g -= w
	b -= w
	
	var mg = max(max(r, g), b)
	
	# Remove yellow from red + green
	var y = min(r, g)
	r -= y
	g -= y
	
	# If the colour value has blue and green, then divide in half to preserve the value's maximum range
	if b + g:
		b /= 2
		g /= 2
	
	# Redistribute remaining green
	y += g
	b += g
	
	# Normalize to values
	var my = max(max(r, y), b)
	
	if my:
		var n = mg / my
		r *= n
		y *= n
		b *= n
	
	# Add white back in
	r += w
	y += w
	b += w
	
	return [r, y, b]

static func ryb2rgb(colour_values):
# Convert from RYB values to  Color RGB
	var r = colour_values[0]
	var y = colour_values[1]
	var b = colour_values[2]
	
	# Remove whiteness from colour
	var w = min(min(r, y), b)
	r -= w
	y -= w
	b -= w
	
	var my = max(max(r, y), b)
	
	# Remove green from yellow + blue
	var g = min(y, b)
	y -= g
	b -= g
	
	if b + g:
		b *= 2
		g *= 2
	
	# Redistribute remaining yellow
	r += y
	g += y
	
	# Normalize to values
	var mg = max(max(r, g), b)
	
	if mg:
		var n = my / mg
		r *= n
		g *= n
		b *= n
	
	# Add white back in
	r += w
	g += w
	b += w
	
	return Color(r, g, b)