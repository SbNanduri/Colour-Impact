extends Node2D

const ADDITIONAL_LIMIT = 1400		# How far off the screen the paintbrush needs to go before being deleted

var default_acceleration_magnitude = 100 setget _set_default_acceleration_magnitude
var square_pos = Vector2()
var flipped = false
var velocity = -Vector2(100, 0)
var angular_velocity = 0
const MAX_ANGULAR_VELOCITY = 4
var acceleration = -Vector2(default_acceleration_magnitude, 0)
var control_acceleration = Vector2()
var type = "PaintBrush"
var colour_weight = 0.5 	# The weight to apply in the lerp function when changing the square's colour
var colour = Color() setget _set_colour
var gravity_bodies
var mass = 5
var test = true

# Colour combining variables
var total_ryb = []	# This is set in the _set_colour function if it has no value
var lightness = 0	# This is set in the _set_colour function if total_ryb has no value
var no_of_elements = 1		# The number of colour elements that make up the colour

# Painting variables
var repel = false		# When it enters the square, it should be repelled by it so that it can turn around and paint it



signal should_be_deleted

func _ready():
	
	$Brush/FuelParticles.process_material = $Brush/FuelParticles.process_material.duplicate()
	
	gravity_bodies = get_tree().get_nodes_in_group("gravitation")

	name = 'PaintBrush'
	
	connect("should_be_deleted", get_parent(), "refresh_gravitation_group")

func _physics_process(delta):

	general_movement(delta)

func general_movement(delta):
	acceleration = default_acceleration_magnitude * Vector2(1, 0).rotated(rotation)
	if not repel:
		acceleration += control_acceleration
	control_acceleration = Vector2()
	for body in gravity_bodies:
		var acceleration_magnitude
		if body != self:
			var pos
			if body.name == 'Square':
				pos = body.get_parent().rect_position
			else:
				pos = body.position
			if position.distance_squared_to(pos) <= 0.00001:
				acceleration_magnitude = 20
			else:
				acceleration_magnitude = min(6*pow(10, -5) * body.mass / position.distance_squared_to(pos), 20)
			if repel:
				acceleration_magnitude = -acceleration_magnitude
			acceleration += (pos - position).normalized() * acceleration_magnitude

	var new_rotation = lerp(abs(rotation), abs(acceleration.angle()), 1) * sign(acceleration.angle())
	angular_velocity = (new_rotation - rotation) / delta
	
	# Makes sure that the brush does not spin too fast
	if abs(angular_velocity) > MAX_ANGULAR_VELOCITY and abs(angular_velocity) < 360 - MAX_ANGULAR_VELOCITY:
		new_rotation = (delta * sign(angular_velocity)*MAX_ANGULAR_VELOCITY + rotation)
	rotation = new_rotation
	velocity = acceleration * delta + velocity
	position += velocity * delta
	check_out_of_bounds()

func apply_acceleration(touch_pos, multiplier):
	control_acceleration = (touch_pos - position) * multiplier

func _set_colour(value):
	colour = value
	$Brush/PaintParticles.modulate = value
	$Brush/FuelParticles.modulate = value
	
	if not total_ryb:
		total_ryb = global.rgb2ryb(value)
		lightness = global.rgb2hsl(value)[2]

func _set_default_acceleration_magnitude(value):
	default_acceleration_magnitude = value
	$Brush/FuelParticles.amount = int(value * 0.5)
	$Brush/FuelParticles.process_material.initial_velocity = value + 10


func check_out_of_bounds():
	if (position.x < -ADDITIONAL_LIMIT) or (position.y < -ADDITIONAL_LIMIT) or (position.x > get_viewport().size.x + ADDITIONAL_LIMIT) or (position.y > get_viewport().size.y + ADDITIONAL_LIMIT):
		emit_signal("should_be_deleted", self)


func _on_Handle_area_entered(area):
	if area.name == 'Square':
		repel = true


func _on_Handle_area_exited(area):
	if area.name == 'Square':
		default_acceleration_magnitude *= 15
