extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


func _ready():
	get_node("SquareContainer").rect_position.x = get_viewport().size.x / 3
	get_node("SquareContainer/Labels/ColorValue").rect_position.x = (get_viewport().size.x / 3) - (get_node("SquareContainer/Labels/ColorValue").rect_size.x / 2)
	get_node("SquareContainer/Labels/RYB").rect_position.x = (get_viewport().size.x / 3) - (get_node("SquareContainer/Labels/RYB").rect_size.x / 2)
	get_node("SquareContainer/Labels/RYBValues").rect_position.x = (get_viewport().size.x / 3) - (get_node("SquareContainer/Labels/RYBValues").rect_size.x / 2)