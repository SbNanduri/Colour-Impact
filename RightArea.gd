extends Area2D

var mouse_in_area = false

var dragging = false
var initial_pos
var final_pos

var colour = Color(1, 1, 1)

signal to_spawn_missile

func _ready():
	connect("to_spawn_missile", get_node("../../Brushes"), "spawn_missile")

func _process(delta):
	
	if Input.is_action_just_pressed("touch"):
		initial_pos = get_viewport().get_mouse_position()
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_point(initial_pos)
		for i in result:
			if i['collider'] == self:
				dragging = true
		
	if Input.is_action_just_released("touch") and dragging:
		dragging = false
		final_pos = get_viewport().get_mouse_position()
		emit_signal("to_spawn_missile", initial_pos, final_pos, colour)


func _on_RightArea_mouse_entered():
	mouse_in_area = true


func _on_RightArea_mouse_exited():
	mouse_in_area = false


func _on_ColourButtons_colour_change(new_colour):
	colour = new_colour
