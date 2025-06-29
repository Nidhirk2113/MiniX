extends CanvasLayer

@onready var save: Button = $VBoxContainer/Save
@onready var load: Button = $VBoxContainer/Load

var is_paused : bool = false

func _ready() -> void:
	hide_pause_menu()
	
	save.pressed.connect( on_save_pressed )
	load.pressed.connect( on_load_pressed )
	pass 

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_paused == false:
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()

func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	save.grab_focus()

func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false

func on_save_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.save_game()
	hide_pause_menu()
	pass

func on_load_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.load_game()
	await LevelManager.level_load_started
	hide_pause_menu()
	pass
