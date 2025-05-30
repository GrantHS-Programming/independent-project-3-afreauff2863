extends Area2D

var pulled = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("guy") && !pulled:
		$AnimatedSprite2D.play("down")
		pulled = true
		print("leverleft1 pulled")
		
		# make it do something
