extends Area2D

var talkable = true
var showTalkPrompt = true
var talkState = 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("guy"):
		if showTalkPrompt == true:
			get_node("talkPrompt").visible = true
		talkable = true
		print("prompt")
	

func _process(delta: float) -> void:
	if Global.keyCollected == true:
		showTalkPrompt = true
		
	if talkable and Input.is_action_just_pressed("interact"):
		showTalkPrompt = false
		get_node("talkPrompt").visible = false
		get_node("talkbox").visible = true
		if talkState == 0:
			$talkbox.play("query")
		elif talkState == 1:
			pass
			# make congratulations dialogue, end game
