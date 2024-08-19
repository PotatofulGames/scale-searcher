# Market.gd #
# Scale Searcher By Potatoful Games #
# Made For The GMTK Game Jam 2024 #

class_name Market
extends StaticBody2D

var marketDeal: String = "None"
var marketDealValue: float = 0.0

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var marketDealInfoUI: Label = get_parent().get_node("%Market Deal")
@onready var marketDealTimeLeftUI: Label = get_parent().get_node("%Market Deal Time Left")

func _ready() -> void:
	%"Small Scale Asteroids".get_node("Buttons/Sell One").pressed.connect(sellOneAsteroid.bind("Small"))
	%"Medium Scale Asteroids".get_node("Buttons/Sell One").pressed.connect(sellOneAsteroid.bind("Medium"))
	%"Large Scale Asteroids".get_node("Buttons/Sell One").pressed.connect(sellOneAsteroid.bind("Large"))
	
	%"Small Scale Asteroids".get_node("Buttons/Sell All").pressed.connect(sellAllAsteroids.bind("Small"))
	%"Medium Scale Asteroids".get_node("Buttons/Sell All").pressed.connect(sellAllAsteroids.bind("Medium"))
	%"Large Scale Asteroids".get_node("Buttons/Sell All").pressed.connect(sellAllAsteroids.bind("Large"))

func _process(_delta: float) -> void:
	marketDealTimeLeftUI.text = getMarketDealTimeLeftString()

func getMarketDealTimeLeftString() -> String:
	var minutes: String = str(floor($Timer.time_left / 60.0))
	var seconds: String = str(floor((($Timer.time_left / 60.0) - floor($Timer.time_left / 60.0)) * 60.0))
	
	return minutes + ":" + seconds.pad_zeros(2)

func setLabels() -> void:
	var smallScaleAsteroids: Array[Asteroid] = player.inventory.filter(func(a: Asteroid) -> bool:
		return a.asteroidData.scale == "Small")
	
	var mediumScaleAsteroids: Array[Asteroid] = player.inventory.filter(func(a: Asteroid) -> bool:
		return a.asteroidData.scale == "Medium")
	
	var largeScaleAsteroids: Array[Asteroid] = player.inventory.filter(func(a: Asteroid) -> bool:
		return a.asteroidData.scale == "Large")
	
	%"Small Scale Asteroids".get_node("Labels/Stock").text = \
		"You Have: " + str(smallScaleAsteroids.size())
	
	%"Medium Scale Asteroids".get_node("Labels/Stock").text = \
		"You Have: " + str(mediumScaleAsteroids.size())
	
	%"Large Scale Asteroids".get_node("Labels/Stock").text = \
		"You Have: " + str(largeScaleAsteroids.size())
	
	%"Small Scale Asteroids".get_node("Buttons/Sell One").text = "Sell One:\n" + \
		player.getCashString(floor(smallScaleAsteroids.front().mass * 1.0)) if smallScaleAsteroids.size() > 0 \
		else "Sell One:\n$0"
	
	%"Medium Scale Asteroids".get_node("Buttons/Sell One").text = "Sell One:\n" + \
		player.getCashString(floor(mediumScaleAsteroids.front().mass * 3.0)) if mediumScaleAsteroids.size() > 0 \
		else "Sell One:\n$0"
	
	%"Large Scale Asteroids".get_node("Buttons/Sell One").text = "Sell One:\n" + \
		player.getCashString(floor(largeScaleAsteroids.front().mass * 10.0)) if largeScaleAsteroids.size() > 0 \
		else "Sell One:\n$0"
	
	var smallScaleAsteroidsAllTotal: int = 0
	var mediumScaleAsteroidsAllTotal: int = 0
	var largeScaleAsteroidsAllTotal: int = 0
	
	for asteroid: Asteroid in smallScaleAsteroids:
		smallScaleAsteroidsAllTotal = smallScaleAsteroidsAllTotal + \
		floor(asteroid.mass * marketDealValue) if marketDeal == "Small" \
		else smallScaleAsteroidsAllTotal + floor(asteroid.mass * 1.0)
	
	for asteroid: Asteroid in mediumScaleAsteroids:
		mediumScaleAsteroidsAllTotal = mediumScaleAsteroidsAllTotal + \
		floor(asteroid.mass * marketDealValue) if marketDeal == "Medium" \
		else mediumScaleAsteroidsAllTotal + floor(asteroid.mass * 3.0)
	
	for asteroid: Asteroid in largeScaleAsteroids:
		largeScaleAsteroidsAllTotal = largeScaleAsteroidsAllTotal + \
		floor(asteroid.mass * marketDealValue) if marketDeal == "Large" \
		else largeScaleAsteroidsAllTotal + floor(asteroid.mass * 10.0)
	
	%"Small Scale Asteroids".get_node("Buttons/Sell All").text = "Sell ALL:\n" + \
		player.getCashString(smallScaleAsteroidsAllTotal) if smallScaleAsteroids.size() > 0 \
		else "Sell ALL:\n$0"
	
	%"Medium Scale Asteroids".get_node("Buttons/Sell All").text = "Sell ALL:\n" + \
		player.getCashString(mediumScaleAsteroidsAllTotal) if mediumScaleAsteroids.size() > 0 \
		else "Sell ALL:\n$0"
	
	%"Large Scale Asteroids".get_node("Buttons/Sell All").text = "Sell ALL:\n" + \
		player.getCashString(largeScaleAsteroidsAllTotal) if largeScaleAsteroids.size() > 0 \
		else "Sell ALL:\n$0"
	
	match marketDeal:
		"Small":
			%"Small Scale Asteroids".get_node("Buttons/Sell One").text = "Sell One:\n" + \
			player.getCashString(floor(smallScaleAsteroids.front().mass * marketDealValue)) \
			if smallScaleAsteroids.size() > 0 \
			else "Sell One:\n$0"
		
		"Medium":
			%"Medium Scale Asteroids".get_node("Buttons/Sell One").text = "Sell One:\n" + \
			player.getCashString(floor(mediumScaleAsteroids.front().mass * marketDealValue)) \
			if mediumScaleAsteroids.size() > 0 \
			else "Sell One:\n$0"
		
		"Large":
			%"Large Scale Asteroids".get_node("Buttons/Sell One").text = "Sell One:\n" + \
			player.getCashString(floor(largeScaleAsteroids.front().mass * marketDealValue)) \
			if largeScaleAsteroids.size() > 0 \
			else "Sell One:\n$0"

func sellOneAsteroid(scaleType: String) -> void:
	var asteroids: Array[Asteroid] = player.inventory.filter(func(a: Asteroid) -> bool:
		return a.asteroidData.scale == scaleType)
	var value: float = 1.0
	
	match scaleType:
		"Small":
			value = 1.0
		
		"Medium":
			value = 3.0
		
		"Large":
			value = 10.0
	
	if marketDeal == scaleType:
		value = marketDealValue
	
	if asteroids.size() > 0:
		player.cash += floor(asteroids.front().mass * value)
		player.inventory.erase(asteroids.front())
		player.setInventoryUI()
	
	setLabels()

func sellAllAsteroids(scaleType: String) -> void:
	var asteroids: Array[Asteroid] = player.inventory.filter(func(a: Asteroid) -> bool:
		return a.asteroidData.scale == scaleType)
	var value: float = 1.0
	
	match scaleType:
		"Small":
			value = 1.0
		
		"Medium":
			value = 3.0
		
		"Large":
			value = 10.0
	
	if marketDeal == scaleType:
		value = marketDealValue
	
	if asteroids.size() > 0:
		for asteroid: Asteroid in asteroids:
			player.cash += floor(asteroid.mass * value)
		
		for i: int in range(asteroids.size() - 1, -1, -1):
			player.inventory.erase(asteroids[i])
		
		player.setInventoryUI()
	
	setLabels()


# Signals #

func _on_market_entered(body: Node2D) -> void:
	if body is Player:
		$CanvasLayer.visible = true
		player.get_node("Market Pointer").visible = false
		setLabels()

func _on_market_exited(body: Node2D) -> void:
	if body is Player:
		$CanvasLayer.visible = false
		player.get_node("Market Pointer").visible = true

func _on_market_deal_timer_timeout() -> void:
	%"Small Scale Asteroids".get_node("Labels/Name").text = "Small Scale Asteroids ($1/kg)"
	%"Medium Scale Asteroids".get_node("Labels/Name").text = "Medium Scale Asteroids ($3/kg)"
	%"Large Scale Asteroids".get_node("Labels/Name").text = "Large Scale Asteroids ($10/kg)"
	
	%"Small Scale Asteroids".get_node("Labels/Name").self_modulate = Color.WHITE
	%"Medium Scale Asteroids".get_node("Labels/Name").self_modulate = Color.WHITE
	%"Large Scale Asteroids".get_node("Labels/Name").self_modulate = Color.WHITE
	
	marketDeal = ["Small", "Medium", "Large"].filter(func(a: String) -> bool:
		return a != marketDeal).pick_random()
	
	match marketDeal:
		"Small":
			marketDealValue = 10.0
			marketDealInfoUI.text = "MARKET DEAL:\nSmall Scale Asteroids\nNow: $10/kg - Was: $1/kg"
			%"Small Scale Asteroids".get_node("Labels/Name").text = "Small Scale Asteroids ($10/kg)"
			%"Small Scale Asteroids".get_node("Labels/Name").self_modulate = Color.GOLD
		
		"Medium":
			marketDealValue = 12.0
			marketDealInfoUI.text = "MARKET DEAL:\nMedium Scale Asteroids\nNow: $12/kg - Was: $3/kg"
			%"Medium Scale Asteroids".get_node("Labels/Name").text = "Medium Scale Asteroids ($12/kg)"
			%"Medium Scale Asteroids".get_node("Labels/Name").self_modulate = Color.GOLD
		
		"Large":
			marketDealValue = 15.0
			marketDealInfoUI.text = "MARKET DEAL:\nLarge Scale Asteroids\nNow: $15/kg - Was: $10/kg"
			%"Large Scale Asteroids".get_node("Labels/Name").text = "Large Scale Asteroids ($15/kg)"
			%"Large Scale Asteroids".get_node("Labels/Name").self_modulate = Color.GOLD
	
	setLabels()
