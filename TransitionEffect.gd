extends CanvasLayer

export var colour = Color(1, 1, 1) setget _set_colour

func _ready():
	if global.previous_screen_image != null:
		$DryingPaint.visible = true
		$PreviousScreenTexture.visible = true
		$PaintRoller/Particles2D.emitting = true
		var itex = ImageTexture.new()
		itex.create_from_image(global.previous_screen_image)
		$PreviousScreenTexture.set_texture(itex)
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		$TransitionPlayer.play("transition")
	else:
		$DryingPaint.visible = false
		$PreviousScreenTexture.visible = false
		$PaintRoller/Particles2D.emitting = false

func _on_TransitionPlayer_animation_finished(anim_name):
	$DryingPaint.visible = false
	$PreviousScreenTexture.visible = false
	$PaintRoller/Particles2D.emitting = false

func _set_colour(value):
	colour = value
	if has_node("DryingPaint"):
		$DryingPaint.color = colour
		$PaintRoller/Particles2D.modulate = colour
		$PaintRoller.modulate = colour