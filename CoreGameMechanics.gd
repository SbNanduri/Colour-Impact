extends Node

var paint_brush_in_play = false

func _ready():
	$TargetColour/Colour.modulate = $SquareContainer/Square.target_colour

func _process(delta):
	if $Brushes.get_child_count():
		paint_brush_in_play = true
	else:
		paint_brush_in_play = false


func _on_Reset_pressed():
	get_tree().reload_current_scene()


func _on_Randomize_pressed():
	global.target_colour = Color()
	randomize()
	var brush_counter = 0
	var tube_counter = 0
	
	var a = [Color(1, 1, 1), [], 0, 1]	# Assuming the canvas is always going to be a white square at the beginning!!!!!
	
	for i in range($Brushes.max_missiles):
		if randi() % 6:
			var v = randi() % 4
			var b = $MarginContainer/ColourButtons.get_children()[v]
			a = global.combine_colours([a[0], a[1], a[2], a[3]], 
										[b.modulate, global.rgb2ryb(b.modulate), 0, 1])
			brush_counter += 1
			print(b.name)
	if get_parent():
		for tube in get_parent().get_node("PaintTubes").get_children():
			if randi()%2:
				if tube_counter < brush_counter:
					a = global.combine_colours([a[0], a[1], a[2], a[3]], 
											[tube.colour, global.rgb2ryb(tube.colour), 0, 1])
					tube_counter += 1
					print(tube.colour)
	
	global.target_colour = a[0]
	
	get_tree().reload_current_scene()
