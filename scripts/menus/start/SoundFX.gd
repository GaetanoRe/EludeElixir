extends Node

func button_click():
	$ButtonClick.play()

func volume_click():
	$VolumeClick.play()

func play_menu_music():
	var song_progress = $MenuMusic.get_playback_position()
	$MenuMusic.play()
	$MenuMusic.seek(song_progress)


func fade_menu_music():
	var fade_music = get_tree().create_tween()
	fade_music.tween_property($MenuMusic, "volume_db", -30, 1)
	await get_tree().create_timer(1).timeout
	$MenuMusic.stop()
