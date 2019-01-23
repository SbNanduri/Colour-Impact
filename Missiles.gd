extends Node2D

onready var missile = preload("res://PaintBrush.tscn")

var missile_counter = 0
export var max_missiles = 4

var dragging = false
var pos

export var acceleration_multiplier = 0.001

signal to_apply_acceleration

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	control_brush()

func spawn_missile(initial_pos, final_pos, colour):
	if missile_counter < max_missiles:
		missile_counter += 1
		var missile_instance = missile.instance()
		add_child(missile_instance)
		missile_instance.position = initial_pos
		missile_instance.square_pos = get_parent().get_node("SquareContainer").rect_position
		missile_instance.default_acceleration_magnitude = min((final_pos.distance_to(initial_pos) + 50) * 1.0005, 450)
		missile_instance.colour = colour
		missile_instance.get_node("Brush").get_node("BrushSprite").modulate = missile_instance.colour.lightened(0.7)
		missile_instance.rotation = missile_instance.acceleration.angle()		# Makes it face the square
		
		for missile in get_children():
			connect("to_apply_acceleration", missile, "apply_acceleration")

func refresh_gravitation_group(missile_to_delete):
	for missile in get_children():
		missile.gravity_bodies.erase(missile_to_delete)
		missile_to_delete.queue_free()

func control_brush():
	if get_parent().paint_brush_in_play:
		if Input.is_action_pressed("touch"):
			pos = get_viewport().get_mouse_position()
			var space_state = get_world_2d().direct_space_state
			var result = space_state.intersect_point(pos)
			var in_area = false
			for i in result:
				if i['collider'] == get_parent().get_node("RightContainer/RightArea"):
					in_area = true
			if not in_area:
				emit_signal("to_apply_acceleration", pos, acceleration_multiplier)