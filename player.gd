extends KinematicBody2D

var MOTION_SPEED = 250 # Pixels/second.

func _physics_process(_delta):
	MOTION_SPEED = 250 
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion.y /= 2
	if (Input.get_action_strength("run") > 0):
		MOTION_SPEED = MOTION_SPEED * 2
	motion = motion.normalized() * MOTION_SPEED
	#warning-ignore:return_value_discarded
	move_and_slide(motion)
