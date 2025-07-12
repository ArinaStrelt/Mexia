extends LimboState

func _update(delta: float) -> void:
	agent.apply_movement(delta)
