extends KinematicBody

export var speed := 7.0
export var gravity := 30.0
export var jump_force := 12.0
export var run_multiplier := 2

var velocity = Vector3.ZERO

var key = false
var isPlayer = true

func _physics_process(delta):
	var runM = 1
	var jumpM = 1
	if (Input.get_action_strength("run") > 0):
		runM = run_multiplier
		jumpM = run_multiplier * 0.6
	$AnimationPlayer.playback_speed = runM * runM
		
	var direction_ground := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	
	if (Input.get_action_strength("jump") && is_on_floor()):
		velocity.y = jump_force * jumpM

	velocity = Vector3(0, velocity.y, 0)
	
	velocity += Vector3(
		(direction_ground.y * speed * runM) + (direction_ground.x * speed * runM),
		-gravity * delta,
		(direction_ground.y * speed * runM) - (direction_ground.x * speed * runM)
	)
		
	velocity = move_and_slide(velocity, Vector3.UP)
		
	if (self.global_transform.origin.y < -10):
		get_tree().reload_current_scene()
		
	animatePlayer(direction_ground)

func animatePlayer(dir):
	if(dir.x > 0):
		$AnimationPlayer.play("walk")
		$Position3D/Sprite3D.set_flip_h(false)
	elif (dir.x < 0):
		$AnimationPlayer.play("walk")
		$Position3D/Sprite3D.set_flip_h(true)
	elif (dir.y != 0):
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")

func _on_LevelEnd_body_entered(_body):
	if (key): 
		key = false
		$KeyLabel.text = ""
		if (get_tree().get_current_scene().get_name() == 'Level 1'):
			get_tree().change_scene("res://main1.tscn")
		else:
			get_tree().change_scene("res://main.tscn")

func collect_key(item):
	$KeyLabel.text += item.get_name() + "\n"
	key = true

func collect_coin(coin):
	$KeyLabel.text += coin.get_name() + "\n"
