extends Node

var previous_screen_image		# For transitions
var transition_colour

var target_colour = Color(0.758, 0.565, 0.69)

static func rgb2ryb(colour):
	# Convert from Color RGB to RYB values
	var r = colour.r * 255
	var g = colour.g * 255
	var b = colour.b * 255
	
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
	
	return [r/255, y/255, b/255]

static func ryb2rgb(colour_values):
# Convert from RYB values to  Color RGB
	var r = colour_values[0] * 255
	var y = colour_values[1] * 255
	var b = colour_values[2] * 255
	
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
	
	if b and g:
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
	
	return Color(r/255, g/255, b/255)

static func rgb2cmyk(colour):
	var r = colour.r
	var g = colour.g
	var b = colour.b
	
	var c = 1
	var m = 1
	var y = 1
	
	var k = 1-max(max(r, g), b)
	if k < 0.001:
		c = (1-r-k)/(1-k)
		m = (1-g-k)/(1-k)
		y = (1-b-k)/(1-k)
	
	return [c, m, y, k]

static func cmyk2rgb(colour_values):
	var c = colour_values[0]
	var m = colour_values[1]
	var y = colour_values[2]
	var k = colour_values[3]

	var r = (1-c) * (1-k)
	var g = (1-m) * (1-k)
	var b = (1-y) * (1-k)
	
	return Color(r, g, b)

static func ryb2cmyk(colour_values):
	return rgb2cmyk(Color(ryb2rgb(colour_values)[0], ryb2rgb(colour_values)[1], ryb2rgb(colour_values)[2]))

static func rgb2hsl(colour):	#These are wrong
	var r = colour.r
	var g = colour.g
	var b = colour.b 
	
	var cmax = max(max(r, g), b)
	var cmin = min(min(r, g), b)
	
	var h = 0
	var s = 0
	var l = (cmax+cmin)/2
	
	if cmax == cmin:
		pass
	elif cmax == r:
		h = 60*(0 + (g-b)/(cmax-cmin))
	elif cmax == g:
		h = 60*(2 + (b-r)/(cmax-cmin))
	elif cmax == b:
		h = 60*(4 + (r-g)/(cmax-cmin))
	
	if h < 0:
		h += 360
	
	if not (cmax == 0 or cmin == 1):
		s = (cmax-cmin)/(1-abs(cmax+cmin-1))
	
	
	return [h, s, l]

static func hsl2rgb(colour_values):	#These are wrong
	var r = 0
	var g = 0
	var b = 0
	
	var h = colour_values[0]
	var s = colour_values[1]
	var l = colour_values[2]
	
	var c = (1-abs(2*l - 1)) * s
	var h_prime = h / 60
	var x = c * (1-abs(fmod(h_prime, 2) - 1))
	
	if h_prime >= 0 and h_prime <= 1:
		r = c
		g = x
	elif h_prime >= 1 and h_prime <= 2:
		r = x
		g = c
	elif h_prime >= 2 and h_prime <= 3:
		g = c
		b = x
	elif h_prime >= 3 and h_prime <= 4:
		g = x
		b = c
	elif h_prime >= 4 and h_prime <= 5:
		r = x
		b = c
	elif h_prime >= 5 and h_prime <= 6:
		r = c
		b = x
	
	var m = l - c/2
	r += m
	g += m
	b += m
	return Color(r, g, b)

static func combine_colours(properties_a, properties_b):
	"""
	Returns an array in the same format as the inputs.
	"""
	# Assign the properties of the first colour (a) to the appropriately named variables
	var current_rgb_a = properties_a[0]	# The current actual rgb of the object
	var total_ryb_a = properties_a[1]	# The ryb values of all the colours added together. The values can be greater than 1
	var lightness_a = properties_a[2]	# The total lightness of all the colours that were combined but averaged 
	var no_of_elements_a = properties_a[3]	 # The number of colours that were combined together
	
	# Assign the properties of the second colour (b) to the appropriately named variables
	var current_rgb_b = properties_b[0]
	var total_ryb_b = properties_b[1]
	var lightness_b = properties_b[2]
	var no_of_elements_b = properties_b[3]
	
	if not total_ryb_a:
		total_ryb_a = [0, 0, 0]
	if not total_ryb_b:
		total_ryb_b = [0, 0, 0]
	
	
	var total_ryb = [total_ryb_a[0] + total_ryb_b[0], total_ryb_a[1] + total_ryb_b[1], total_ryb_a[2] + total_ryb_b[2]]
	
	if no_of_elements_a <= 1:	# sets the initial lightness value to be equal to the lightness of the rgb value
		lightness_a = global.rgb2hsl(current_rgb_a)[2]
	if no_of_elements_b <= 1:
		lightness_b = global.rgb2hsl(current_rgb_b)[2]

	var not_avged_lightness_a = lightness_a*no_of_elements_a		# The total lightness value if it was not averaged
	var not_avged_lightness_b = lightness_b*no_of_elements_b
	
	var no_of_elements = no_of_elements_a + no_of_elements_b	 # The total number of elements of both objects
	
	var lightness = (not_avged_lightness_a+not_avged_lightness_b)/(no_of_elements)	 # The averaged lightness of all the colours in both objects
	
	var sum_value = max(total_ryb[0] + total_ryb[1] + total_ryb[2], 0.0001)	# incase the brush colour is black
	var result_ryb_values = [0, 0, 0]
	for i in len(result_ryb_values):
		result_ryb_values[i] = total_ryb[i] / sum_value
	
	var result_hsl_values = global.rgb2hsl(global.ryb2rgb(result_ryb_values))
	result_hsl_values[2] = lightness
	return [global.hsl2rgb(result_hsl_values), total_ryb, lightness, no_of_elements]