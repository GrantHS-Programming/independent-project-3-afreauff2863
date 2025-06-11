extends Area2D
var activateOnce = 1

func _on_body_entered(body: Node2D) -> void:
	pass
	
	#if body.is_in_group("guy") && activateOnce == 1:
		#get_parent().get_parent().get_node("CanvasLayer/titleCard").visible = true
		#activateOnce = 0
		#await get_tree().create_timer(2).timeout
		#get_parent().get_parent().get_node("CanvasLayer/titleCard").visible = false"
		
