extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GameOptions_pressed():
	get_tree().change_scene("res://Godot Assets/UI/GameOptions.tscn")


func _on_ReturnToGame_pressed():
	pass # Replace with function body.


func _on_ReturnToMenu_pressed():
	get_tree().change_scene("res://Godot Assets/UI/Menu.tscn")
