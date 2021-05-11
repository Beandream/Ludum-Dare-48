extends Node

# Instancing this Collectable tscn into a item will make it be collectable.
# renaming the Instance will give it let you check for its name when collecting

var Label = 'default'

signal collected

func _ready():
	Label = self.get_name()

func _on_Area_body_entered(body):
	if (body.get_name() == 'Player'): # check if colliding body is the Player
		emit_signal("collected", self.get_parent(), body, Label) 
		# sends collected signal, this colletable's self, and body that collided.
		
		get_parent().queue_free()
		# removes this collectable from scene.
