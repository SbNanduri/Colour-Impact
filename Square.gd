extends Area2D

onready var target_colour = global.target_colour

var colour_array = [1, 1, 1]
var total_ryb = []
var lightness = 0
var no_of_elements = 1 	# The number of colour elements that are involved in the colour

onready var mass = 5000 * $CollisionShape2D.shape.extents.x*2 * $CollisionShape2D.shape.extents.y*2 * scale.x*3 * scale.y*3


func _ready():
	$Sprite.modulate = Color(1, 1, 1)
	get_node("../../TargetColour/ColourValue").text = 'The target colour is: (%s, %s, %s)' %[stepify(target_colour.r, 0.001), 
																							stepify(target_colour.g, 0.001),
																							stepify(target_colour.b, 0.001)]
	update_labels()


func _on_Square_area_entered(area):
	var parent = area.get_parent()		# parent is the paintbrush in this case
	if parent.get("type"):
		if (parent.type == "PaintBrush") and (area.name == 'Brush'):
			var brush_rgb = parent.colour
			# Have to convert to ryb to do calculations because paint in real life uses subtractive colouring
			var brush_ryb_values = global.rgb2ryb(brush_rgb)		# Remember an array gets returned by this function
			
			var result = global.combine_colours([$Sprite.modulate, total_ryb, lightness, no_of_elements], 
												[parent.colour, parent.total_ryb, parent.lightness, parent.no_of_elements])
			$Sprite.modulate = result[0]
			total_ryb = result[1]
			lightness = result[2]
			no_of_elements = result[3]
			update_labels()
			check_victory()



func update_labels():
	var ryb_colour = global.rgb2ryb($Sprite.modulate)
	get_parent().get_node("Labels/RYBValues").text = '( %s, %s, %s )' %[stepify($Sprite.modulate.r, 0.001), 
																		stepify($Sprite.modulate.g, 0.001),
																		stepify($Sprite.modulate.b, 0.001)]
	
	get_parent().get_node("Labels/RYBValues").add_color_override("font_color", $Sprite.modulate)
	get_parent().get_node("Labels/RYB").add_color_override("font_color", $Sprite.modulate)
	
	get_parent().get_node("Labels/ColorValue").add_color_override("font_color", $Sprite.modulate.darkened(0.5))

func check_victory():
	if (abs($Sprite.modulate.r - target_colour.r) < 0.01) and (abs($Sprite.modulate.g - target_colour.g) < 0.01) and (abs($Sprite.modulate.b - target_colour.b) < 0.01):
		$Timer.start()


func _on_Timer_timeout():
	get_tree().change_scene("res://Menus/Victory.tscn")
