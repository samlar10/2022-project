extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/FullScreenButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FullScreenButton_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_SoundButton_pressed():
	pass # Replace with function body.


func _on_ReturnButton_pressed():
	get_tree().change_scene("res://Godot Assets/UI/Menu.tscn")
