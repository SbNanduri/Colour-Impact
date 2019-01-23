extends VBoxContainer

signal colour_change

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Colour1_pressed():
	emit_signal("colour_change", Color($Colour1.modulate.r, $Colour1.modulate.g, $Colour1.modulate.b))


func _on_Colour2_pressed():
	emit_signal("colour_change", Color($Colour2.modulate.r, $Colour2.modulate.g, $Colour2.modulate.b))


func _on_Colour3_pressed():
	emit_signal("colour_change", Color($Colour3.modulate.r, $Colour3.modulate.g, $Colour3.modulate.b))


func _on_Colour4_pressed():
	emit_signal("colour_change", Color($Colour4.modulate.r, $Colour4.modulate.g, $Colour4.modulate.b))




