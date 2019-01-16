extends Area2D

export var boost_amount = 5

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Booster_area_entered(area):
	var parent = area.get_parent()
	if parent.get("type"):
		if (parent.type == "PaintBrush") and (not parent.painting):
			parent.default_acceleration_magnitude *= boost_amount
			queue_free()