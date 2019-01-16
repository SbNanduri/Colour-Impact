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
	if Input.is_key_pressed(KEY_R):
		colour = Color(1, 0, 0)
	if Input.is_key_pressed(KEY_G):
		colour = Color(0, 1, 0)
	if Input.is_key_pressed(KEY_B):
		colour = Color(0, 0, 1)
	if Input.is_key_pressed(KEY_Y):
		colour = global.ryb2rgb([0, 1, 0])
		
	if mouse_in_area:
		if Input.is_action_just_pressed("touch"):
			dragging = true
			initial_pos = get_viewport().get_mouse_position()
	if Input.is_action_just_released("touch") and dragging:
		dragging = false
		final_pos = get_viewport().get_mouse_position()
		emit_signal("to_spawn_missile", initial_pos, final_pos, colour)


func _on_RightArea_mouse_entered():
	mouse_in_area = true


func _on_RightArea_mouse_exited():
	mouse_in_area = false
