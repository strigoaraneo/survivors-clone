extends CharacterBody2D

var movement_speed: float = 80.0
var hp: int = 80

@onready var player_sprite: Sprite2D = $Sprite2D
@onready var walk_timer: Timer = %WalkTimer

func _physics_process(delta: float) -> void:
	movement()

func movement():
	var move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_dir.normalized() * movement_speed

	if velocity.x > 0:
		player_sprite.flip_h = true
	else:
		player_sprite.flip_h = false
	
	if velocity != Vector2.ZERO:
		if walk_timer.is_stopped():
			if player_sprite.frame >= player_sprite.hframes - 1:
				player_sprite.frame = 0
			else:
				player_sprite.frame += 1
			walk_timer.start()

	move_and_slide()


func _on_hurtbox_hurt(damage:Variant) -> void:
	hp -= damage
	print("Took damage, hp: ", hp)
