extends Area2D

@export var base_speed: float = 300.0
@export var sprint_multiplier: float = 2.0
@export var padding: float = 0.0
@export var wrap_instead_of_clamp: bool = false
@export var follow_mouse: bool = false
@export var follow_stop_radius: float = 4.0
@export var rotate_to_motion: bool = true

var hello_timer := 0.0
var elapsed := 0.0
@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_half: Vector2 = sprite.texture.get_size() * sprite.scale * 0.5

func _process(delta: float) -> void:
	elapsed += delta
	hello_timer += delta
	if hello_timer >= 2.0:
		print("Hello!")
		hello_timer -= 2.0
	
	var velocity := _calculate_velocity()
	if velocity.length() > 0.001 and rotate_to_motion:
		var target_angle = velocity.angle()
		rotation = lerp_angle(rotation, target_angle, 5.0 * delta)
	
	position += velocity * delta
	
	if wrap_instead_of_clamp:
		_wrap_position()
	else:
		_clamp_position()

func _calculate_velocity() -> Vector2:
	var direction := Vector2.ZERO
	if follow_mouse:
		var mouse_pos = get_viewport().get_mouse_position()
		direction = (mouse_pos - position)
		var distance = direction.length()
		if distance <= follow_stop_radius:
			return Vector2.ZERO
		if distance > 0:
			direction = direction.normalized()
	else:
		if Input.is_action_pressed("ui_right"):
			direction.x += 1
		if Input.is_action_pressed("ui_left"):
			direction.x -= 1
		if Input.is_action_pressed("ui_down"):
			direction.y += 1
		if Input.is_action_pressed("ui_up"):
			direction.y -= 1
		if direction.length() > 0:
			direction = direction.normalized()
	
	var speed := base_speed
	if Input.is_key_pressed(KEY_SHIFT):
		speed *= sprint_multiplier
	return direction * speed

func _clamp_position() -> void:
	var screen_size: Vector2 = get_viewport_rect().size
	position.x = clamp(position.x, padding + sprite_half.x, screen_size.x - padding - sprite_half.x)
	position.y = clamp(position.y, padding + sprite_half.y, screen_size.y - padding - sprite_half.y)

func _wrap_position() -> void:
	var screen: Vector2 = get_viewport_rect().size
	if position.x > screen.x + sprite_half.x:
		position.x = -sprite_half.x
	elif position.x < -sprite_half.x:
		position.x = screen.x + sprite_half.x
	if position.y > screen.y + sprite_half.y:
		position.y = -sprite_half.y
	elif position.y < -sprite_half.y:
		position.y = screen.y + sprite_half.y
