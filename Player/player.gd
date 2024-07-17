extends CharacterBody2D

var movement_speed: float = 80.0
var hp: int = 80

# Attacks
var ice_spear := preload("res://Player/Attack/ice_spear.tscn")

# Attack nodes
@onready var ice_spear_timer: Timer = get_node("%IceSpearTimer")
@onready var ice_spear_burst_timer: Timer = get_node("%IceSpearBurstTimer")

# Ice Spear
var ice_spear_ammo: int = 0
var ice_spear_base_ammo: int = 5
var ice_spear_attack_speed: float = 1.5
var ice_spear_level: int = 1

# Enemy
var enemies_nearby: Array[CharacterBody2D]


@onready var player_sprite: Sprite2D = $Sprite2D
@onready var walk_timer: Timer = %WalkTimer

func _ready() -> void:
	attack()


func _physics_process(_delta: float) -> void:
	movement()


func movement() -> void:
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


func attack() -> void:
	if ice_spear_level > 0:
		ice_spear_timer.wait_time = ice_spear_attack_speed
		if ice_spear_timer.is_stopped():
			ice_spear_timer.start()


func _on_hurtbox_hurt(damage:Variant) -> void:
	hp -= damage
	print("Took damage, hp: ", hp)


func _on_ice_spear_timer_timeout() -> void:
	ice_spear_ammo += ice_spear_base_ammo
	ice_spear_burst_timer.start()


func _on_ice_spear_attack_timer_timeout() -> void:
	if ice_spear_ammo > 0:
		var ice_spear_instance = ice_spear.instantiate()
		# This only works because the ice_spears are set to 'top level' priority.
		ice_spear_instance.position = position
		ice_spear_instance.target = get_random_target()
		ice_spear_instance.level = ice_spear_level
		add_child(ice_spear_instance)

		ice_spear_ammo -= 1
		if ice_spear_ammo > 0:
			ice_spear_burst_timer.start()
		else:
			ice_spear_burst_timer.stop()

func get_random_target() -> Vector2:
	if enemies_nearby.size() > 0:
		return enemies_nearby.pick_random().global_position
	else:
		return Vector2.UP


func _on_enemy_detection_area_2d_body_entered(body:Node2D) -> void:
	if not enemies_nearby.has(body):
		enemies_nearby.append(body)  


func _on_enemy_detection_area_2d_body_exited(body:Node2D) -> void:
	if enemies_nearby.has(body):
		enemies_nearby.erase(body)
