extends Node

func button_click():
	$ButtonClick.play()

func volume_click():
	$VolumeClick.play()


func play_menu_music():
	var menu_song_progress = $MenuMusic.get_playback_position()
	$MenuMusic.play()
	$MenuMusic.seek(menu_song_progress)

func fade_out_menu_music():
	var fade_music = get_tree().create_tween()
	fade_music.tween_property($MenuMusic, "volume_db", -30, 1)
	await get_tree().create_timer(1).timeout
	$MenuMusic.stop()

func fade_in_menu_music():
	var fade_music = get_tree().create_tween()
	fade_music.tween_property($MenuMusic, "volume_db", 0, 1)


func play_dungeon_music():
	var dung_song_progress = $DungeonMusic.get_playback_position()
	$DungeonMusic.play()
	$DungeonMusic.seek(dung_song_progress)

func fade_in_dung_music():
	var fade_dung_music = get_tree().create_tween()
	fade_dung_music.tween_property($DungeonMusic, "volume_db", 0, 1)

func fade_out_dung_music():
	var fade_dung_music = get_tree().create_tween()
	fade_dung_music.tween_property($DungeonMusic, "volume_db", -30, 1)
	await get_tree().create_timer(1).timeout
	$DungeonMusic.stop()
