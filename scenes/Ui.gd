extends Control

onready var label = $Label
var monsterNumber = 4
# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = "Nb of monsters: " + str(monsterNumber)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
