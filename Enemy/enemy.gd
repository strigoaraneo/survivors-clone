extends CharacterBody2D

@export var movement_speed: float = 25.0
@export var hp: int = 10

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var enemy_sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim.play("walk")

func _physics_process(delta: float) -> void:
	var player_direction = global_position.direction_to(player.global_position)
	
	velocity = player_direction * movement_speed

	if velocity.x > 0.1:
		enemy_sprite.flip_h = true
	else:
		enemy_sprite.flip_h = false

	move_and_slide()

func _on_hurtbox_hurt(damage:Variant) -> void:
	hp -= damage

	if hp <= 0: queue_free()
