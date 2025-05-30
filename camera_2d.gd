extends Camera2D


func _ready() -> void:
	global_position = get_parent().global_position
