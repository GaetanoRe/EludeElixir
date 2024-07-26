extends Resource
class_name SaveGame

const SAVE_GAME_PATH := "res://scripts/resources/savedata.tres"

@export var saved_Musictab: int
@export var saved_SFXtab: int
#@export var checkpoint: int



func write_savegame() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)

static func load_savegame() -> Resource:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null

