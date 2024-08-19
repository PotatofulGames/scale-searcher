# Player.gd #
# Scale Searcher By Potatoful Games #
# Made For The GMTK Game Jam 2024 #

class_name Player
extends Entity

var cash: int = 0
const maxInventoryCapacity: int = 8
var inventory: Array[Asteroid] = []
var asteroidsInRange: Array[Asteroid] = []
var currentAsteroidHovering: Asteroid = null

@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var gameTimer: Timer = get_parent().get_node("Timer")
@onready var timeLeftUI: Label = get_parent().get_node("%Time Left")
@onready var cashUI: Label = get_parent().get_node("%Cash")
@onready var inventoryUI: HBoxContainer = get_parent().get_node("%Inventory")
@onready var market: Market = get_parent().get_node("Market")
@onready var asteroids: Node2D = get_parent().get_node("Asteroid Spawner/Asteroids")

func _ready() -> void:
	speed = 5.0
	rotationSpeed = 3.5
	$Sprite2D.texture = load(GameData.userGameData["Current Skin"])

func _physics_process(_delta: float) -> void:
	timeLeftUI.text = getTimeLeftString()
	cashUI.text = getCashString()
	
	$"Market Pointer".look_at(market.global_position)
	
	var rotationDirection: float = Input.get_axis("ui_left", "ui_right")
	var movementDirection: float = Input.get_axis("ui_down", "ui_up")
	var motion: Vector2 = Vector2.ZERO
	
	if rotationDirection:
		rotation_degrees += rotationDirection * rotationSpeed
	
	if movementDirection:
		motion = Vector2(movementDirection * speed, 0.0).rotated(rotation - PI / 2)
		
		if movementDirection < 0.0:
			motion *= Vector2(0.5, 0.5)
		
		particles.emitting = true
	
	else:
		particles.emitting = false
	
	move_and_collide(motion)

func getTimeLeftString() -> String:
	var minutes: String = str(floor(gameTimer.time_left / 60.0))
	var seconds: String = str(floor(((gameTimer.time_left / 60.0) - floor(gameTimer.time_left / 60.0)) * 60.0))
	
	return minutes + ":" + seconds.pad_zeros(2)

func getCashString(cashAmount: int = cash) -> String:
	var cashString: String = str(cashAmount)
	var formattedCashString: String = ""
	var mod: int = cashString.length() % 3
	
	for i: int in range(cashString.length() - 1, -1, -1):
		formattedCashString = cashString[i] + formattedCashString
		
		if i % 3 == mod and i != 0 and cashAmount >= 1000:
			formattedCashString = "," + formattedCashString
	
	return "$" + formattedCashString

func gatherAsteroid(asteroid: Asteroid, isAlreadyInInventory: bool = false) -> void:
	if inventory.size() < maxInventoryCapacity or isAlreadyInInventory:
		var asteroidUI: Button = Button.new()
		asteroidUI.custom_minimum_size = Vector2(92, 92)
		asteroidUI.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		
		asteroidUI.add_theme_constant_override("icon_max_width", 72)
		asteroidUI.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		asteroidUI.icon = asteroid.get_node("Sprite2D").texture
		
		var scaleLabel: Label = Label.new()
		var massLabel: Label = Label.new()
		
		scaleLabel.text = asteroid.asteroidData.scale
		massLabel.text = str(asteroid.mass).pad_decimals(1) + " kg"
		
		scaleLabel.add_theme_font_override("font", load("res://extras/fonts/KdamThmorPro-Regular.ttf"))
		massLabel.add_theme_font_override("font", load("res://extras/fonts/KdamThmorPro-Regular.ttf"))
		
		scaleLabel.set_anchors_preset(Control.PRESET_FULL_RECT)
		massLabel.set_anchors_preset(Control.PRESET_FULL_RECT)
		
		scaleLabel.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		scaleLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		massLabel.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		massLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		asteroidUI.add_child(scaleLabel)
		asteroidUI.add_child(massLabel)
		
		asteroidUI.pressed.connect(releaseAsteroid.bind(asteroid, asteroidUI))
		
		if !isAlreadyInInventory:
			inventory.append(asteroid)
			asteroid.get_parent().remove_child(asteroid)
		
		inventoryUI.add_child(asteroidUI)
		
		market.setLabels()

func releaseAsteroid(asteroid: Asteroid, asteroidUI: Button) -> void:
	inventory.erase(asteroid)
	inventoryUI.remove_child(asteroidUI)
	
	asteroid.global_position = global_position + Vector2(
		[randf_range(-125, -50), randf_range(50, 125)].pick_random(),
		[randf_range(-125, -50), randf_range(50, 125)].pick_random())
	
	asteroids.add_child(asteroid)
	
	market.setLabels()

func setInventoryUI() -> void:
	for existingAsteroidUI: Button in inventoryUI.get_children():
		inventoryUI.remove_child(existingAsteroidUI)
	
	for asteroid: Asteroid in inventory:
		gatherAsteroid(asteroid, true)


# Signals #

func _on_asteroid_pickup_range_entered(body: Node2D) -> void:
	if body is Asteroid and body not in asteroidsInRange:
		asteroidsInRange.append(body)

func _on_asteroid_pickup_range_exited(body: Node2D) -> void:
	if body is Asteroid and body in asteroidsInRange:
		asteroidsInRange.erase(body)

func _on_game_finished() -> void:
	GameData.userGameData["Cash"] += cash
	GameData.userGameData["Best Score"] = maxi(GameData.userGameData["Best Score"], cash)
	
	set_physics_process(false)
	get_parent().get_node("%Final Score").text = "Time's Up!\nYour Final Score: " + getCashString()
	get_parent().get_node("Game Finished Screen").visible = true
	
	GameSave.saveGame()

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/Game.tscn")
