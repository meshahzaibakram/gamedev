extends Area2D

@export var value: int = 1

func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Player" and get_parent().has_method("add_score"):
		get_parent().add_score(value)
		queue_free()
