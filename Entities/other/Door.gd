extends Spatial

export var locked := true setget update_door

var door
var door_locked

func _ready():
	door = $Door_Wooden
	door_locked = $Door_Wooden_Lock
	update_door(locked)

func _on_Area_Detection_body_entered(body):
	if ('isPlayer' in body):
		if ('key' in body):
			if (body.key == true):
				locked = false
				update_door(locked)
		if ($Door_Wooden):
			$Door_Wooden.rotate_y(90)
			$Door_Wooden.transform.origin.x += 0.5

func update_door(status):
	remove_child(door)
	remove_child(door_locked)
	if (status):
		add_child(door_locked)
	else: 
		add_child(door)


func _on_Area_Detection_body_exited(body):
		if ('isPlayer' in body):
			if ($Door_Wooden):
				$Door_Wooden.rotate_y(-90)
				$Door_Wooden.transform.origin.x -= 0.5
