# AsteroidData.gd #
# Scale Searcher By Potatoful Games #
# Made For The GMTK Game Jam 2024 #

class_name AsteroidData
extends Resource

@export_enum("Small", "Medium", "Large") var scale: String = "Small"
@export var sprites: Array[CompressedTexture2D] = []
@export var collisionShape: Shape2D

@export_range(0, 10) var speed: float
@export_range(0, 10) var rotationSpeed: float

@export_range(200, 5000) var minMass: float
@export_range(200, 5000) var maxMass: float
