extends KinematicBody2D

onready var ray = $RayCast2D

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

func stand_on():
	ray.cast_to = Vector2(0, 0)
	ray.force_raycast_update()
	var collider = ray.get_collider()

	if ray.is_colliding():
		if collider.is_in_group('monster'):
			return ('monster')
	return ('ground')
