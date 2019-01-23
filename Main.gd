extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


func _ready():
	global.transition_colour = null
	get_node("CoreGameMechanics/SquareContainer").rect_position.x = get_viewport().size.x / 3
	get_node("CoreGameMechanics/SquareContainer/Labels/ColorValue").rect_position.x = (get_viewport().size.x / 3) - (get_node("CoreGameMechanics/SquareContainer/Labels/ColorValue").rect_size.x / 2)
	get_node("CoreGameMechanics/SquareContainer/Labels/RYB").rect_position.x = (get_viewport().size.x / 3) - (get_node("CoreGameMechanics/SquareContainer/Labels/RYB").rect_size.x / 2)
	get_node("CoreGameMechanics/SquareContainer/Labels/RYBValues").rect_position.x = (get_viewport().size.x / 3) - (get_node("CoreGameMechanics/SquareContainer/Labels/RYBValues").rect_size.x / 2)