extends Area2D
var firstTime = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("guy"):
		get_parent().get_parent().get_node("guy").deathPos = position
		print("checkpoint set")
		if firstTime:
			get_parent().get_parent().get_node("CanvasLayer/checkpointSetUI").visible = true
			await get_tree().create_timer(1).timeout
			get_parent().get_parent().get_node("CanvasLayer/checkpointSetUI").visible = false
		firstTime = false
