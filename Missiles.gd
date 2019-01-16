extends Node

onready var missile = preload("res://PaintBrush.tscn")

var missile_counter = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func spawn_missile(initial_pos, final_pos, colour):
	if missile_counter < 10:
		missile_counter += 1
		var missile_instance = missile.instance()
		add_child(missile_instance)
		missile_instance.position = initial_pos
		missile_instance.square_pos = get_parent().get_node("SquareContainer").rect_position
		missile_instance.default_acceleration_magnitude = min((final_pos.distance_to(initial_pos) + 50) * 1.0005, 450)
		missile_instance.colour = colour
		missile_instance.get_node("Brush").get_node("BrushSprite").modulate = missile_instance.colour.lightened(0.7)
		missile_instance.rotation = missile_instance.acceleration.angle()		# Makes it face the square

func refresh_gravitation_group(missile_to_delete):
	for missile in get_children():
		missile.gravity_bodies.erase(missile_to_delete)
		missile_to_delete.queue_free()