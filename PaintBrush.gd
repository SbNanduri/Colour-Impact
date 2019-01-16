extends Node2D

const ADDITIONAL_LIMIT = 1400

var default_acceleration_magnitude = 100 setget _set_default_acceleration_magnitude
var square_pos = Vector2()
var flipped = false
var velocity = -Vector2(100, 0)
var angular_velocity = 0
var acceleration = -Vector2(default_acceleration_magnitude, 0)
var type = "PaintBrush"
var colour_weight = 0.5 	# The weight to apply in the lerp function when changing the square's colour
var colour = Color() setget _set_colour
var gravity_bodies
var mass = 5
var test = true

# Painting variables
var painting = false		# When it is painting the square



signal should_be_deleted

func _ready():
	
	$Brush/FuelParticles.process_material = $Brush/FuelParticles.process_material.duplicate()
	
	gravity_bodies = get_tree().get_nodes_in_group("gravitation")

	name = 'PaintBrush'
	
	connect("should_be_deleted", get_parent(), "refresh_gravitation_group")

func _physics_process(delta):
	if not painting:
		general_movement(delta)
	else:
		acceleration = acceleration.rotated(angular_velocity * delta)
		rotation += angular_velocity * delta
		velocity = acceleration * delta + velocity
		position += velocity * delta


func general_movement(delta):
	acceleration = default_acceleration_magnitude * Vector2(1, 0).rotated(rotation)
	
	for body in gravity_bodies:
		var acceleration_magnitude
		if body != self:
			var pos
			if body.name == 'Square':
				pos = body.get_parent().rect_position
			else:
				pos = body.position
			if position.distance_squared_to(pos) <= 10:
				acceleration_magnitude = 70
			else:
				acceleration_magnitude = 6*pow(10, -5) * body.mass / position.distance_squared_to(pos)
			
			acceleration += (pos - position).normalized() * acceleration_magnitude


	var new_rotation = lerp(abs(rotation), abs(acceleration.angle()), 1) * sign(acceleration.angle())
	angular_velocity = (new_rotation - rotation) / delta
	rotation = new_rotation
	velocity = acceleration * delta + velocity
	position += velocity * delta
	check_out_of_bounds()

func _set_colour(value):
	colour = value
	$Brush/PaintParticles.modulate = value
	$Brush/FuelParticles.modulate = value

func _set_default_acceleration_magnitude(value):
	default_acceleration_magnitude = value
	$Brush/FuelParticles.amount = int(value * 0.5)
	$Brush/FuelParticles.process_material.initial_velocity = value + 10



func check_out_of_bounds():
	if (position.x < -ADDITIONAL_LIMIT) or (position.y < -ADDITIONAL_LIMIT) or (position.x > get_viewport().size.x + ADDITIONAL_LIMIT) or (position.y > get_viewport().size.y + ADDITIONAL_LIMIT):
		emit_signal("should_be_deleted", self)


func _on_Handle_area_entered(area):
	if area.name == 'Square':
		painting = true
