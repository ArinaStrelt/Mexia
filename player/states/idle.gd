extends LimboState

func _update(delta: float) -> void:
	if agent.movement_input != Vector2.ZERO:
		get_root().dispatch("to_walk")
