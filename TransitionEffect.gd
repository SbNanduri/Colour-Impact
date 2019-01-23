extends CanvasLayer

onready var colour = Color(1, 1, 1) setget _set_colour
var path

func _ready():
	if global.transition_colour != null:
		self.colour = global.transition_colour
		$TransitionPlayer.play("fade in")
		$PaintRollerRoller/Particles2D.emitting = true
	else:
		$AppliedPaint.visible = false
		$DryingPaint.visible = false
		$PaintRollerRoller/Particles2D.emitting = false


func _on_TransitionPlayer_animation_finished(anim_name):
	if anim_name == 'fade in':
		$AppliedPaint.visible = false
		$PaintRollerRoller/Particles2D.emitting = false
	if anim_name == 'fade out':
		perform_scene_change()
		
		
func transition_to_scene(received_path, colour):
	path = received_path
	global.transition_colour = colour
	self.colour = colour
	$TransitionPlayer.play("fade out")
	

func perform_scene_change():
	get_tree().change_scene(path)
	
func _set_colour(value):
	colour = value

	$AppliedPaint.color = colour
	$DryingPaint.color = colour
	$PaintRollerRoller/Particles2D.modulate = colour
	$PaintRollerRoller.modulate = colour
