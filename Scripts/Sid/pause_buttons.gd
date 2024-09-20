extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_resume_button_pressed():
	GlobalValues.paused = false
	get_parent().hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_restart_button_pressed():
	GlobalValues.paused = false
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed():
	GlobalValues.paused = false
	get_tree().change_scene_to_file("res://Scenes/Sid/main_menu.tscn")
