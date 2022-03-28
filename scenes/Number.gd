extends KinematicBody2D

onready var ray = $RayCast2D
var value = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	value = check_bomb()
	if value > 0:
		$Label.text = str(value)

func check_bomb():
	var tilesPositions = [
		(Vector2.UP) * 16,
		(Vector2.DOWN) * 16,
		(Vector2.LEFT) * 16,
		(Vector2.RIGHT) * 16,
		
		(Vector2.UP + Vector2.LEFT) * 16,
		(Vector2.UP + Vector2.RIGHT) * 16,
		(Vector2.DOWN + Vector2.LEFT) * 16,
		(Vector2.DOWN + Vector2.RIGHT) * 16,
	]

	#print("Number position: ", self.position.x, " ", self.position.y)
	var collider
	for tilePosition in tilesPositions:
		ray.cast_to = tilePosition
		ray.force_raycast_update()
		if ray.is_colliding():
			collider = ray.get_collider()
			if collider.is_in_group('monster'):
				#print("		monster collider here: ", tilePosition.x / 16, " ", tilePosition.y / 16, collider.damage)
				value += 1
		collider = null

	return value
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
