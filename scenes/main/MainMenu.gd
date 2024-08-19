# MainMenu.gd #
# Scale Searcher By Potatoful Games #
# Made For The GMTK Game Jam 2024 #

class_name MainMenu
extends CanvasLayer

@onready var animationPlayer: AnimationPlayer = get_parent().get_node("AnimationPlayer")
@onready var asteroidSpawnerTimer: Timer = get_parent().get_node("Asteroid Spawner/Timer")
@onready var marketDealTimer: Timer = get_parent().get_node("Market/Timer")
@onready var gameTimer: Timer = get_parent().get_node("Timer")
@onready var player: Player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	%"Best Score".text = "Your Best Score: " + player.getCashString(GameData.userGameData["Best Score"])
	setTotalCashLabel()
	setShopButtons()

func _process(_delta: float) -> void:
	if %"Play Info Blink".current_animation != "Blink":
		%"Play Info Blink".current_animation = "Blink"

func _input(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventJoypadButton) and event.is_pressed() and visible:
		if GameData.isNewGame:
			get_tree().paused = true
			get_parent().get_node("Tutorial").visible = true
		
		else:
			animationPlayer.play("Begin")
			asteroidSpawnerTimer.start(0.1)
			marketDealTimer.start()
			gameTimer.start()
			player.get_node("Market Pointer").visible = true

func setTotalCashLabel() -> void:
	%"Total Cash".text = "Cash: " + player.getCashString(GameData.userGameData["Cash"])

func setShopButtons() -> void:
	for skinUnlocked: String in GameData.userGameData["Skins Unlocked"]:
		if skinUnlocked == "res://images/entity/player/PlayerSpaceship.png":
			%"Purple Spaceship Buy".text = "Owned"
			
			if skinUnlocked == GameData.userGameData["Current Skin"]:
				%"Purple Spaceship Buy".text = "Equipped"
		
		elif skinUnlocked == "res://images/entity/player/PlayerSpaceship-Red.png":
			%"Red Spaceship Buy".text = "Owned"
			
			if skinUnlocked == GameData.userGameData["Current Skin"]:
				%"Red Spaceship Buy".text = "Equipped"
		
		elif skinUnlocked == "res://images/entity/player/PlayerSpaceship-Gold.png":
			%"Gold Spaceship Buy".text = "Owned"
			
			if skinUnlocked == GameData.userGameData["Current Skin"]:
				%"Gold Spaceship Buy".text = "Equipped"


# Signals #

func _on_about_button_toggled(toggled_on: bool) -> void:
	%"About Info".visible = toggled_on
	
	if toggled_on:
		print("
	--- LICENSES ---
	This game uses Godot Engine, available under the following license:
	
	Copyright (c) 2014-present Godot Engine contributors.
	Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the \"Software\"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
	
	
	-- Godot Third-Party Licenses Link --
	https://github.com/godotengine/godot/blob/master/COPYRIGHT.txt
	
	
	-- Kdam Thmor Pro Font OFL --
	Copyright 2022 The Kdam Thmor Project Authors (https://www.github.com/sovichet/kdam-thmor-pro)
	
	This Font Software is licensed under the SIL Open Font License, Version 1.1.
	This license is copied below, and is also available with a FAQ at:
	http://scripts.sil.org/OFL
	
	SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007
	
	PREAMBLE
	The goals of the Open Font License (OFL) are to stimulate worldwide
	development of collaborative font projects, to support the font creation
	efforts of academic and linguistic communities, and to provide a free and
	open framework in which fonts may be shared and improved in partnership
	with others.
	
	The OFL allows the licensed fonts to be used, studied, modified and
	redistributed freely as long as they are not sold by themselves. The
	fonts, including any derivative works, can be bundled, embedded, 
	redistributed and/or sold with any software provided that any reserved
	names are not used by derivative works. The fonts and derivatives,
	however, cannot be released under any other type of license. The
	requirement for fonts to remain under this license does not apply
	to any document created using the fonts or their derivatives.
	
	DEFINITIONS
	\"Font Software\" refers to the set of files released by the Copyright
	Holder(s) under this license and clearly marked as such. This may
	include source files, build scripts and documentation.
	
	\"Reserved Font Name\" refers to any names specified as such after the
	copyright statement(s).
	
	\"Original Version\" refers to the collection of Font Software components as
	distributed by the Copyright Holder(s).
	
	\"Modified Version\" refers to any derivative made by adding to, deleting,
	or substituting -- in part or in whole -- any of the components of the
	Original Version, by changing formats or by porting the Font Software to a
	new environment.
	
	\"Author\" refers to any designer, engineer, programmer, technical
	writer or other person who contributed to the Font Software.
	
	PERMISSION & CONDITIONS
	Permission is hereby granted, free of charge, to any person obtaining
	a copy of the Font Software, to use, study, copy, merge, embed, modify,
	redistribute, and sell modified and unmodified copies of the Font
	Software, subject to the following conditions:
	
	1) Neither the Font Software nor any of its individual components,
	in Original or Modified Versions, may be sold by itself.
	
	2) Original or Modified Versions of the Font Software may be bundled,
	redistributed and/or sold with any software, provided that each copy
	contains the above copyright notice and this license. These can be
	included either as stand-alone text files, human-readable headers or
	in the appropriate machine-readable metadata fields within text or
	binary files as long as those fields can be easily viewed by the user.
	
	3) No Modified Version of the Font Software may use the Reserved Font
	Name(s) unless explicit written permission is granted by the corresponding
	Copyright Holder. This restriction only applies to the primary font name as
	presented to the users.
	
	4) The name(s) of the Copyright Holder(s) or the Author(s) of the Font
	Software shall not be used to promote, endorse or advertise any
	Modified Version, except to acknowledge the contribution(s) of the
	Copyright Holder(s) and the Author(s) or with their explicit written
	permission.
	
	5) The Font Software, modified or unmodified, in part or in whole,
	must be distributed entirely under this license, and must not be
	distributed under any other license. The requirement for fonts to
	remain under this license does not apply to any document created
	using the Font Software.
	
	TERMINATION
	This license becomes null and void if any of the above conditions are
	not met.
	
	DISCLAIMER
	THE FONT SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT
	OF COPYRIGHT, PATENT, TRADEMARK, OR OTHER RIGHT. IN NO EVENT SHALL THE
	COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	INCLUDING ANY GENERAL, SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL
	DAMAGES, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF THE USE OR INABILITY TO USE THE FONT SOFTWARE OR FROM
	OTHER DEALINGS IN THE FONT SOFTWARE.
	
	
	-- Music From Pixabay --
	https://pixabay.com/music/ambient-space-158081/
		")

func _on_shop_button_toggled(toggled_on: bool) -> void:
	%"Shop Panel".visible = toggled_on

func _on_buy_button_pressed(item: String, cost: int) -> void:
	if (str(item) in GameData.userGameData["Skins Unlocked"]):
		GameData.userGameData["Current Skin"] = str(item)
		player.get_node("Sprite2D").texture = load(str(item))
		
		GameSave.saveGame()
	
	elif GameData.userGameData["Cash"] >= cost:
		GameData.userGameData["Skins Unlocked"].append(str(item))
		GameData.userGameData["Cash"] -= cost
		
		GameData.userGameData["Current Skin"] = str(item)
		player.get_node("Sprite2D").texture = load(str(item))
		
		setTotalCashLabel()
		GameSave.saveGame()
	
	setShopButtons()

func _on_potatoful_games_logo_button_down() -> void:
	%"Potatoful Games Logo".flip_v = true

func _on_potatoful_games_logo_button_up() -> void:
	%"Potatoful Games Logo".flip_v = false

func _on_begin_pressed():
	GameData.isNewGame = false
	GameSave.saveGame()
	
	get_tree().paused = false
	get_parent().get_node("Tutorial").visible = false
	
	animationPlayer.play("Begin")
	asteroidSpawnerTimer.start(0.1)
	marketDealTimer.start()
	gameTimer.start()
	player.get_node("Market Pointer").visible = true
