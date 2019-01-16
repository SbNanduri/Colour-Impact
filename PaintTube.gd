extends Area2D

export var colour = Color()
var type = "PaintTube"
var active = true

var colour_weight = 0.5

func _ready():
	$TubeSprite.modulate = colour
	$PaintParticles.modulate = colour


func _on_PaintTube_area_entered(area):
	var parent = area.get_parent()
	if parent.get("type") and active:
		if (parent.type == "PaintBrush") and (not parent.painting):
			$Timer.start()
			active = false
			
			var tube_ryb_values = global.rgb2ryb(colour)
			var brush_ryb_values = global.rgb2ryb(parent.colour)
			
			var result_ryb_values = [lerp(brush_ryb_values[0], tube_ryb_values[0], parent.colour_weight),
									  lerp(brush_ryb_values[1], tube_ryb_values[1], parent.colour_weight),
									  lerp(brush_ryb_values[2], tube_ryb_values[2], parent.colour_weight),]
			
			parent.colour = global.ryb2rgb(result_ryb_values)
			$PaintParticles.rotation = (parent.position - position).angle()
			$PaintParticles.emitting = true


func _on_Timer_timeout():
	# do an animation to fade the paint tube away
	queue_free()
