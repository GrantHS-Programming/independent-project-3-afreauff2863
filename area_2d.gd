extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("obstacles"):
		get_parent().get_parent().get_node("guy").resetPlayer()
		print("died to obstalce tilemap")
