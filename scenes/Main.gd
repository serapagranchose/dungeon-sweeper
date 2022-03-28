extends Node2D

var rng = RandomNumberGenerator.new()

onready var ground = $Ground
onready var wall = $Wall
onready var player = $Player
onready var exit = $Exit
onready var key = $Key

var rows = 5
var columns = 5
var level = 1

var monstersPercent = 0.15
var monstersNumber = 0
var Slime = preload("res://scenes/Slime.tscn")
var Number = preload("res://scenes/Number.tscn")
var Crate = preload("res://scenes/Crate.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	generation()

func _process(delta):
	if player.stand_on() == 'exit' && exit.is_open:
		print("exit")
		level += 1
		generation()

func generation():
	# generate ground
	for row in rows:
		for column in columns:
			if rng.randf()*1.00+0.00 < 0.10:
				ground.set_cellv(Vector2(row + 1, column + 2), rng.randi()%8+1)
			else:
				ground.set_cellv(Vector2(row + 1, column + 2), 1)

	# generate boundary
	for row in rows + 2:
		for column in columns + 2:
			var tile_pos = Vector2(row, column)
			if column == 0 && row == 0:
				wall.set_cellv(tile_pos, 13)
			elif column == 0:
				wall.set_cellv(tile_pos, 1)
			elif column == columns + 2 && row == rows + 2:
				wall.set_cellv(tile_pos, 15)

			elif row == 0:
				wall.set_cellv(tile_pos, 11)
			elif row == rows + 1:
					wall.set_cellv(tile_pos, 12)

			elif row == 0 && column == columns + 1:
				wall.set_cellv(tile_pos, 13)
			elif column == columns + 1:
				wall.set_cellv(tile_pos, 1)
			elif row == rows + 1 && column == columns + 1:
				wall.set_cellv(tile_pos, 15)

	# generate exit
	exit.position = Vector2(rng.randi_range(0, rows - 1), rng.randi_range(0, columns - 1)) * 16 + Vector2(16, 32)
	add_child(exit)

	# generate monsters
	for row in rows:
		for column in columns:
			if rng.randf()*1.00+0.00 < monstersPercent:
				monstersNumber += 1
				var monster = Slime.instance()
				monster.position = Vector2(row, column) * 16 + Vector2(24, 38)
				add_child(monster)

	# generate numbers
	for row in rows:
		for column in columns:
			var number = Number.instance()
			number.position = Vector2(row, column) * 16 + Vector2(20, 34)
			add_child(number)

	# generate key
	key.position = Vector2(rng.randi_range(0, rows - 1), rng.randi_range(0, columns - 1)) * 16 + Vector2(24, 39)
	while key.stand_on() == 'monster':
		key.position = Vector2(rng.randi_range(0, rows - 1), rng.randi_range(0, columns - 1)) * 16 + Vector2(24, 39)

	# generate player
	player.position = Vector2(rng.randi_range(0, rows - 1), rng.randi_range(0, columns - 1)) * 16 + Vector2(24, 42)
	while player.stand_on() == 'monster' || player.stand_on() == 'key':
		player.position = Vector2(rng.randi_range(0, rows - 1), rng.randi_range(0, columns - 1)) * 16 + Vector2(24, 42)

	# generate crate
	for row in rows:
		for column in columns:
			var crate = Crate.instance()
			crate.position = Vector2(row, column) * 16 + Vector2(24, 42)
			add_child(crate)

	#player.interact(Vector2(0, 0))
