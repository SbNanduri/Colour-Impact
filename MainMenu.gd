extends Control


func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Options_pressed():
	$TransitionEffect.transition_to_scene("res://Menus/Options.tscn", Color(1, 0.8, 0))

func _on_Game_pressed():
	$TransitionEffect.transition_to_scene("res://Main.tscn", Color(0, 1, 0))


func _on_HowToPlay_pressed():
	$TransitionEffect.transition_to_scene("res://Menus/HowToPlay.tscn", Color(0.76, 0.05, 0.84))
