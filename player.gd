extends KinematicBody

const FLOOR_NORMAL = Vector3(0.0, 1.0, 0.0)

export var speed := 7.0
export var gravity := 30.0
export var jump_force := 12.0

var velocity_y := 0.0

func _physics_process(delta):
	var direction_ground := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	
	if not is_on_floor():
		velocity_y -= gravity * delta
		
	var velocity = Vector3(
		direction_ground.x * speed,
		velocity_y,
		direction_ground.y * speed
	)
	move_and_slide(velocity, FLOOR_NORMAL)
	
	if is_on_floor() or is_on_ceiling():
		velocity_y = 0.0
		
	
	
	if Input.is_action_just_pressed("move_right"):
		$AnimationPlayer.play("walk")
		$Position3D/Sprite3D.set_flip_h(false)
	elif Input.is_action_just_pressed("move_left"):
		$AnimationPlayer.play("walk")
		$Position3D/Sprite3D.set_flip_h(true)
	
	if (velocity.x == 0 and velocity_y == 0):
		$AnimationPlayer.play("idle") 
