extends Area2D

var level: int = 1
var hp: int = 1
var speed: int = 50
var damage: int = 5
var knockback_amount: int = 100
var attack_size: float = 1.0
var target: Vector2 = Vector2.ZERO
var target_direction: Vector2 = Vector2.ZERO

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	target_direction = global_position.direction_to(target)
	rotation = target_direction.angle() + deg_to_rad(135)
	
	match level:
		1:
			hp = 1
			speed = 150
			damage = 5
			knockback_amount = 100
			attack_size = 1.0
	
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2(1, 1) * attack_size, 1) \
		.set_trans(Tween.TRANS_QUINT) \
		.set_ease(Tween.EASE_OUT)
	scale_tween.play()


func _physics_process(delta: float) -> void:
	position += target_direction * speed * delta


func enemy_hit(charge: int = 1):
	hp -= charge
	if hp <= 0: queue_free()


func _on_timer_timeout() -> void:
	queue_free()
