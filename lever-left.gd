extends Area2D

var down = false

func leverDown():
	$AnimatedSprite2D.play("on")
	get_parent().get_parent().get_node("keyblocksInitialOn").enabled = false
	get_parent().get_parent().get_node("keyblocksInitialOff").enabled = true
	down = true

func leverUp():
	$AnimatedSprite2D.play("off")
	get_parent().get_parent().get_node("keyblocksInitialOn").enabled = true
	get_parent().get_parent().get_node("keyblocksInitialOff").enabled = false
	down = false
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("guy"):
		if !down:
			for child in get_parent().get_children():
				child.leverDown()
		elif down:
			for child in get_parent().get_children():
				child.leverUp()
			
		
		# make it do something
