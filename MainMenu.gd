extends Control


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Options_pressed():
	global.menu_transition_to_scene("res://Menus/Options.tscn")

func _on_Game_pressed():
	global.menu_transition_to_scene("res://Main.tscn")
