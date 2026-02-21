extends Node2D

var score: int = 0
@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
	_update_score_label()

func add_score(amount: int) -> void:
	score += amount
	_update_score_label()

func _update_score_label() -> void:
	if score_label:
		score_label.text = "Score: %d" % score
