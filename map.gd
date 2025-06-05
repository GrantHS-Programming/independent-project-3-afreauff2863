extends Node2D


@export var spawnpoint: Node2D

func _ready() -> void:
	get_node("keyblocksInitialOff").enabled = false
	get_node("keyblocksInitialOn").enabled = true
