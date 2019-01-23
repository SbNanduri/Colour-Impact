extends Area2D

export var colour = Color()
var type = "PaintTube"
var active = true

var colour_weight = 0.5

func _ready():
	$TubeLabel.modulate = colour
	$PaintParticles.modulate = colour


func _on_PaintTube_area_entered(area):
	var parent = area.get_parent()
	if parent.get("type") and active:
		if (parent.type == "PaintBrush") and (not parent.repel):
			$Timer.start()
			active = false
			
			var result = global.combine_colours([parent.colour, parent.total_ryb, parent.lightness, parent.no_of_elements], 
												[colour, global.rgb2ryb(colour), 0, 1])
			parent.colour = result[0]
			parent.total_ryb = result[1]
			parent.lightness = result[2]
			parent.no_of_elements = result[3]
			
			$PaintParticles.rotation = (parent.position - position).angle()
			$PaintParticles.emitting = true


func _on_Timer_timeout():
	# do an animation to fade the paint tube away
	queue_free()
