extends KinematicBody2D

var marked = false

func uncover():
	if !marked:
		queue_free()

func mark():
	if marked:
		$Crane.hide()
		marked = false
		return
	$Crane.show()
	marked = true
