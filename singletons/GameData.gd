# GameData.gd #
# Scale Searcher By Potatoful Games #
# Made For The GMTK Game Jam 2024 #

extends Node

@onready var asteroidDataResources: Array[AsteroidData] = [
	preload("res://resources/asteroid-data/SmallAsteroid.tres"),
	preload("res://resources/asteroid-data/SmallAsteroid.tres"),
	preload("res://resources/asteroid-data/SmallAsteroid.tres"),
	
	preload("res://resources/asteroid-data/MediumAsteroid.tres"),
	preload("res://resources/asteroid-data/MediumAsteroid.tres"),
	
	preload("res://resources/asteroid-data/LargeAsteroid.tres")
]

var userGameData: Dictionary = {
	"Best Score" : 0,
	"Cash" : 0,
	"Skins Unlocked" : ["res://images/entity/player/PlayerSpaceship.png"],
	"Current Skin" : "res://images/entity/player/PlayerSpaceship.png"
}

var isNewGame: bool = false
