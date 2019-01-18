extends Area2D

export var target_colour = Vector3(0.425, 0.459, 0.74)

var colour_array = [1, 1, 1]

var mass

func _ready():
	$Sprite.modulate = Color(1, 1, 1)
	
	update_labels()
	
	mass = 1000 * $CollisionShape2D.shape.extents.x*2 * $CollisionShape2D.shape.extents.y*2 * scale.x*2 * scale.y*2
func _process(delta):
	if Input.is_key_pressed(KEY_Z):
		$Sprite.modulate.r /= 1.1
	if Input.is_key_pressed(KEY_X):
		$Sprite.modulate.g /= 1.1
	if Input.is_key_pressed(KEY_C):
		$Sprite.modulate.b /= 1.1

func _physics_process(delta):
	scale = Vector2(max(scale.x*0.9999, 0.2), max(scale.y*0.9999, 0.2))
	mass = 10000 * $CollisionShape2D.shape.extents.x*2 * $CollisionShape2D.shape.extents.y*2 * scale.x*2 * scale.y*2


func _on_Square_area_entered(area):
	var parent = area.get_parent()
	if parent.get("type"):
		if (parent.type == "PaintBrush") and (area.name == 'Brush'):
			var brush_rgb = parent.colour
			# Have to convert to ryb to do calculations because paint in real life uses subtractive colouring
			var brush_ryb_values = global.rgb2ryb(brush_rgb)		# Remember an array gets returned by this function
			var square_ryb_values = global.rgb2ryb($Sprite.modulate)
			
			
			var result_ryb_values = [lerp(square_ryb_values[0], brush_ryb_values[0], parent.colour_weight),
									  lerp(square_ryb_values[1], brush_ryb_values[1], parent.colour_weight),
									  lerp(square_ryb_values[2], brush_ryb_values[2], parent.colour_weight),]
			$Sprite.modulate = global.ryb2rgb(result_ryb_values)
			
			update_labels()
			check_victory()


func update_labels():
	var ryb_colour = global.rgb2ryb($Sprite.modulate)
	get_parent().get_node("Labels/RYBValues").text = '( %s, %s, %s )' %[stepify(ryb_colour[0], 0.001), 
																		stepify(ryb_colour[1], 0.001),
																		stepify(ryb_colour[2], 0.001)]
	
	get_parent().get_node("Labels/RYBValues").add_color_override("font_color", $Sprite.modulate)
	get_parent().get_node("Labels/RYB").add_color_override("font_color", $Sprite.modulate)
	
	get_parent().get_node("Labels/ColorValue").add_color_override("font_color", $Sprite.modulate.darkened(0.5))

func check_victory():
	if (abs($Sprite.modulate.r - target_colour.x) < 0.01) and (abs($Sprite.modulate.g - target_colour.y) < 0.01) and (abs($Sprite.modulate.b - target_colour.z) < 0.01):
		$Timer.start()


func _on_Timer_timeout():
	get_tree().change_scene("res://Menus/Victory.tscn")
