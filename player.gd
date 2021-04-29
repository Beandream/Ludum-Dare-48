extends KinematicBody

const FLOOR_NORMAL = Vector3(0.0, 1.0, 0.0)

export var speed := 7.0
export var gravity := 30.0
export var jump_force := 12.0

var velocity_y := 0.0

var key = false

func _ready():
	var collectables = get_tree().get_nodes_in_group('Collectables')
	for collectable in collectables:
		collectable.connect('collected', self, 'onCollect')

func _physics_process(delta):
	var spd = speed
	var jmpForce = jump_force
	$AnimationPlayer.playback_speed = 1
	if (Input.get_action_strength("run") > 0):
		spd = spd * 2
		jmpForce = jump_force + jump_force / 5
		$AnimationPlayer.playback_speed = 4
	var direction_ground := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	
	if not is_on_floor():
		velocity_y -= gravity * delta
		
	if (Input.get_action_strength("jump") && is_on_floor()):
		velocity_y = jmpForce
		
	var velocity = Vector3(
		(direction_ground.y * spd) + (direction_ground.x * spd),
		velocity_y,
		(direction_ground.y * spd) - (direction_ground.x * spd)
	)
	
	move_and_slide(velocity, FLOOR_NORMAL)
	
	if is_on_floor() or is_on_ceiling():
		velocity_y = 0.0
		
	if (self.global_transform.origin.y < -10):
		get_tree().reload_current_scene()

	if(direction_ground.x > 0):
		$AnimationPlayer.play("walk")
		$Position3D/Sprite3D.set_flip_h(false)
	elif (direction_ground.x < 0):
		$AnimationPlayer.play("walk")
		$Position3D/Sprite3D.set_flip_h(true)
	elif (direction_ground.y != 0):
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


func onCollect(_emitter, _collecter, emitterLabel):
	if (emitterLabel == 'key'):
		key = true
		$KeyLabel.text += "Key "
	elif (emitterLabel == 'key2'):
		key = true
		$KeyLabel.text += "Key2 "
