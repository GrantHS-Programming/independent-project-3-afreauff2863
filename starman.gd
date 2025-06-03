extends Area2D

var talkable = true
var showTalkPrompt = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("guy"):
		if showTalkPrompt == true:
			get_node("talkPrompt").visible = true
		talkable = true
		print("prompt")
	

func _process(delta: float) -> void:
	if talkable and Input.is_action_just_pressed("interact"):
		showTalkPrompt = false
		get_node("talkPrompt").visible = false
		get_node("talkbox").visible = true
		$talkbox.play("default")
		# add more dialogue
