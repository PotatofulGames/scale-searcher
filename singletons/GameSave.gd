# GameSave.gd #
# Scale Searcher By Potatoful Games #
# Made For The GMTK Game Jam 2024 #

extends Node

const userSavePath: String = "user://gamesave.dat"

func _ready() -> void:
	loadGame()

func getGameData() -> Dictionary:
	return GameData.userGameData

func saveGame() -> void:
	var file: FileAccess = FileAccess.open(userSavePath, FileAccess.WRITE)
	file.store_var(getGameData())
	
	file.close()

func loadGame() -> void:
	if not FileAccess.file_exists(userSavePath):
		GameData.isNewGame = true
		return
	
	var file: FileAccess = FileAccess.open(userSavePath, FileAccess.READ)
	GameData.userGameData = file.get_var()
	
	file.close()

func resetGame() -> void:
	DirAccess.remove_absolute(userSavePath)
