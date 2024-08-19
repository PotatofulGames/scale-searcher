# AsteroidSpawner.gd #
# Scale Searcher By Potatoful Games #
# Made For The GMTK Game Jam 2024 #

class_name AsteroidSpawner
extends Node2D

const maxAsteroidsAmount: int = 100
const maxMapBounds: Vector2 = Vector2(2500.0, 2500.0)
const minMapBounds: Vector2 = Vector2(-2500.0, -2500.0)
const timerWaitTime: float = 60.0


# Signals #

func _on_timer_timeout() -> void:
	var currentAsteroidsAmountOnMap: int = $Asteroids.get_child_count()
	var asteroidScene: Resource = load("res://scenes/entity/asteroid/Asteroid.tscn")
	
	for i: int in lerp(currentAsteroidsAmountOnMap, maxAsteroidsAmount, 0.5) - currentAsteroidsAmountOnMap:
		var asteroidToSpawn: Asteroid = asteroidScene.instantiate()
		asteroidToSpawn.global_position = Vector2(
			randf_range(minMapBounds.x, maxMapBounds.x),
			randf_range(minMapBounds.y, maxMapBounds.y)
		)
		
		$Asteroids.add_child(asteroidToSpawn)
	
	$Timer.start(timerWaitTime)
