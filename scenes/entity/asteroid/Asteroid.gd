# Asteroid.gd #
# Scale Searcher By Potatoful Games #
# Made For The GMTK Game Jam 2024 #

class_name Asteroid
extends Entity

@export var asteroidData: AsteroidData

var movementDirection: float
var rotationDirection: float
var mass: float

@onready var player: Player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	asteroidData = GameData.asteroidDataResources.pick_random()
	
	speed = asteroidData.speed
	rotationSpeed = asteroidData.rotationSpeed
	
	$Sprite2D.texture = asteroidData.sprites.pick_random()
	$CollisionShape2D.shape = asteroidData.collisionShape
	
	movementDirection = randf_range(-1.0, 1.0)
	rotationDirection = randf_range(-1.0, 1.0)
	mass = randf_range(asteroidData.minMass, asteroidData.maxMass)

func _physics_process(_delta: float) -> void:
	if (self != player.currentAsteroidHovering or self not in player.asteroidsInRange) \
	and $Sprite2D.self_modulate == Color.AQUA:
		$Sprite2D.self_modulate = Color.WHITE
	
	var motion: Vector2 = Vector2(movementDirection * speed, 0.0).rotated(rotation - PI / 2)
	rotation_degrees += rotationDirection * rotationSpeed
	
	move_and_collide(motion)


# Signals #

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if self in player.asteroidsInRange and self == player.currentAsteroidHovering \
	and event is InputEventMouseButton and event.is_pressed():
		player.gatherAsteroid(self)

func _on_mouse_entered() -> void:
	if self in player.asteroidsInRange:
		player.currentAsteroidHovering = self
		$Sprite2D.self_modulate = Color.AQUA

func _on_mouse_exited() -> void:
	if player.currentAsteroidHovering == self:
		player.currentAsteroidHovering = null
	
	$Sprite2D.self_modulate = Color.WHITE
