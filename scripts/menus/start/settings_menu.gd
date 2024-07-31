extends Control


var volume_db = [-80, -30, -23, -16, -12, -9, -8, -6, -5, -4.3, -2.8, -1.6, -1, -0.5, 0]
var bus_Music: int
var bus_SFX: int
@export var Musictab: int
@export var SFXtab: int


func _ready():
	bus_Music = AudioServer.get_bus_index("Music")
	bus_SFX = AudioServer.get_bus_index("SoundEffects")
	
	# Load save file and set volume slider (visual)
	var saved_data := load("res://scripts/resources/savedata.tres") as SaveGame
	if saved_data != null:
		Musictab = saved_data.saved_Musictab
		SFXtab = saved_data.saved_SFXtab
		$"Volume - Music".set_current_tab(Musictab)
		$"Volume - Sound Effects".set_current_tab(SFXtab)
	
	$Alchemist.play("Alchemist_Idle")
	$Shadow.play("Shadow_Idle")




#   Easter Eggs
func _process(delta):
	if Input.is_physical_key_pressed(KEY_SPACE):
		$Thor_SPACE.visible = true
	elif !Input.is_physical_key_pressed(KEY_SPACE):
		$Thor_SPACE.visible = false
	if Input.is_physical_key_pressed(KEY_W):
		$Thor_W.visible = true
	elif !Input.is_physical_key_pressed(KEY_W):
		$Thor_W.visible = false
	if Input.is_action_pressed("walk_left"):
		$Thor_A.visible = true
	elif !Input.is_action_pressed("walk_left"):
		$Thor_A.visible = false
	if Input.is_action_pressed("walk_right"):
		$Thor_D.visible = true
	elif !Input.is_action_pressed("walk_right"):
		$Thor_D.visible = false
	if Input.is_action_pressed("drink"):
		$Thor_E.visible = true
	elif !Input.is_action_pressed("drink"):
		$Thor_E.visible = false
	if Input.is_physical_key_pressed(KEY_SHIFT):
		$Thor_SHIFT.visible = true
	elif !Input.is_physical_key_pressed(KEY_SHIFT):
		$Thor_SHIFT.visible = false
	if Input.is_physical_key_pressed(KEY_CTRL):
		$Thor_CTRL.visible = true
	elif !Input.is_physical_key_pressed(KEY_CTRL):
		$Thor_CTRL.visible = false
	
	if Input.is_physical_key_pressed(KEY_SPACE) and Input.is_physical_key_pressed(KEY_W) and Input.is_action_pressed("walk_left") and Input.is_action_pressed("walk_right") and Input.is_action_pressed("drink") and Input.is_physical_key_pressed(KEY_SHIFT) and Input.is_physical_key_pressed(KEY_CTRL):
		$PsGameJam15.visible = true

	if Input.is_action_just_pressed("drink") and $Alchemist.get_animation() ==  "Alchemist_Idle":
		$Alchemist.play("Alchemist_Drink")
		await get_tree().create_timer(1.6).timeout
		$Alchemist.play("Shadow_Idle")
		$Shadow.play("Alchemist_Idle")
	if Input.is_action_just_pressed("drink") and $Alchemist.get_animation() ==  "Shadow_Idle":
		$Shadow.play("Alchemist_Drink")
		await get_tree().create_timer(1.6).timeout
		$Alchemist.play("Alchemist_Idle")
		$Shadow.play("Shadow_Idle")


func _input(event):
	if event.is_action_pressed("pause"):
		_on_back_button_pressed()


# Change Music volume when selected and update reference variable
func _on_volume__music_tab_clicked(tab):
	SoundFx.volume_click()
	AudioServer.set_bus_volume_db(bus_Music, volume_db[tab])
	Musictab = tab


func _on_volume__sound_effects_tab_clicked(tab):
	SoundFx.volume_click()
	AudioServer.set_bus_volume_db(bus_SFX, volume_db[tab])
	SFXtab = tab


# Back Button
func _on_back_button_pressed():
	SoundFx.button_click()
	
	# Save volume selection
	var save_volume = SaveGame.new()
	save_volume.saved_Musictab = Musictab
	save_volume.saved_SFXtab = SFXtab
	ResourceSaver.save(save_volume, "res://scripts/resources/savedata.tres")

	# Change scene to main menu
	var next_scene = load("res://scenes/main_menu.tscn")
	get_tree().change_scene_to_packed(next_scene)

