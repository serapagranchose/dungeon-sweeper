extends KinematicBody2D

onready var ray = $RayCast2D
onready var sprite = $AnimatedSprite

enum {
	IDLE,
	MOVE,
	INTERACT,
	ATTACK
}

var directions = {
	'ui_up': Vector2.UP,
	'ui_down': Vector2.DOWN,
	'ui_left': Vector2.LEFT,
	'ui_right': Vector2.RIGHT,
}
var state = IDLE
var mark_mod = false
var front_position = Vector2.RIGHT * 16
var has_key = false
var hp = 5
var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	match state:
		IDLE:
			pass
		MOVE:
			move_state()
		INTERACT:
			interact_state()
		ATTACK:
			attack_state()
	state = IDLE

func _unhandled_input(event):
	if event.is_action_pressed("mark_mod"):
		mark_mod = !mark_mod
	if event.is_action_pressed("basic_attack"):
		state = ATTACK
	for direction in directions.keys():
		if event.is_action_pressed(direction):
			if directions[direction].x * 16 > 0:
				sprite.flip_h = false
			elif directions[direction].x * 16 < 0:
				sprite.flip_h = true
			front_position = directions[direction] * 16

			if can_move_to(front_position):
				state = MOVE
			else:
				state = INTERACT

func can_move_to(position):
	ray.cast_to = position
	ray.force_raycast_update()
	if !ray.is_colliding():
		return true
	else:
		var collider = ray.get_collider()
		if collider.is_in_group('key'):
			return true
		elif collider.is_in_group('exit') && collider.is_open:
			return true
		else:
			return false

func stand_on():
	ray.cast_to = Vector2(0, 0)
	ray.force_raycast_update()
	var collider = ray.get_collider()

	if ray.is_colliding():
		if collider.is_in_group('monster'):
			return ('monster')
		if collider.is_in_group('exit'):
			return ('exit')
		if collider.is_in_group('key'):
			has_key = true
			return ('key')
	return ('ground')

func move_state():
	position += front_position
	stand_on()
	front_position += front_position
	state = IDLE

func attack_state():
	print("SLASH")

func interact_state():
	ray.cast_to = front_position
	ray.force_raycast_update()
	var collider = ray.get_collider()

	if collider.is_in_group('crate'):
		if !mark_mod:
			collider.uncover()
			return
		collider.mark()
	elif collider.is_in_group('monster'):
		hp -= collider.attack()
	elif collider.is_in_group('exit'):
		if !collider.is_open && has_key:
			collider.open()
