extends Area


func _on_body_entered(body):
	if body.has_method("collect_key"):
		body.collect_key(self)
		self.queue_free()
