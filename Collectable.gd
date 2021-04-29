extends Node

# Instancing this Collectable tscn into a item will make it be collectable. 

signal collected

func _on_Area_body_entered(body):
	emit_signal("collected", self.get_parent(), body) 
	# sends collected signal, this colletable's self, and body that collided.
	
	get_parent().queue_free()
	# removes this collectable from scene.
