extends Area2D

var down = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("guy"):
		if !down:
			$AnimatedSprite2D.play("down")
			down = true
			# make the lever switch tiles on and off (idk how)
			get_parent().get_parent().get_node("keydoors").set_physics_layer_collision_mask(0,2)
		elif down:
			$AnimatedSprite2D.play("up")
			down = false
			
		
		# make it do something
