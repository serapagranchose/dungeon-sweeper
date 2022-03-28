extends KinematicBody2D

onready var ray = $RayCast2D
onready var sprite = $AnimatedSprite

var damage = 1

func _ready():
	if randi() % 2:
		sprite.flip_h = true

func _process(delta):
	if !is_covered():
		$CollisionShape2D.disabled = false
		ray.cast_to = Vector2(0, 0)
		ray.force_raycast_update()
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider.is_in_group('player'):
				return true
	else:
		$CollisionShape2D.disabled = true

func is_covered():
	var collider
	
	ray.cast_to = Vector2(0, 0)
	ray.force_raycast_update()
	if !ray.is_colliding():
		return false

	collider = ray.get_collider()
	if collider.is_in_group('crate'):
		return true

	return false

func attack():
	if !is_covered():
		return(damage)
	return 0
