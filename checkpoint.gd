extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("guy"):
		get_parent().get_parent().get_node("guy").deathPos = position
		# add animation for checkpoint set
		print("checkpoint set")
