extends Area2D

var talkable = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("guy"):
		get_node("talkPrompt").visible = true
		talkable = true
		print("prompt")
		# make a prompt to let the player know you can talk
	

func _process(delta: float) -> void:
	if talkable and Input.is_action_just_pressed("interact"):
		get_node("talkbox").visible = true
		$talkbox.play("default")
		# add more dialogue
