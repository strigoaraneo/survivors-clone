extends Node2D

@export var enemy_spawner: Array[SpawnInfo]

@onready var player = get_tree().get_first_node_in_group("player")

var time = 0


func _on_timer_timeout() -> void:
	time += 1
	for s in enemy_spawner:
		if time < s.time_start or time > s.time_end:
			continue

		if s.spawn_delay_counter < s.enemy_spawn_delay:
			s.spawn_delay_counter += 1
		else:
			s.spawn_delay_counter = 0
			var new_enemy = s.enemy

			for i in s.enemy_num:
				var new_enemy_instance = new_enemy.instantiate()
				new_enemy_instance.global_position = get_random_position()
				add_child(new_enemy_instance)


func get_random_position() -> Vector2:
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4)
	var player_pos = player.global_position
	var top_left = Vector2(player_pos.x - vpr.x/2, player_pos.y - vpr.y/2)
	var top_right = Vector2(player_pos.x + vpr.x/2, player_pos.y - vpr.y/2)
	var bottom_left = Vector2(player_pos.x - vpr.x/2, player_pos.y + vpr.y/2)
	var bottom_right = Vector2(player_pos.x + vpr.x/2, player_pos.y + vpr.y/2)

	var random_viewport_side = ["up", "down", "left", "right"].pick_random()
	var spawn_pos_1 = Vector2.ZERO
	var spawn_pos_2 = Vector2.ZERO

	match random_viewport_side:
		"up":
			spawn_pos_1 = top_left
			spawn_pos_2 = top_right
		"down":
			spawn_pos_1 = bottom_left
			spawn_pos_2 = bottom_right
		"left":
			spawn_pos_1 = top_left
			spawn_pos_2 = bottom_left
		"right":
			spawn_pos_1 = top_right
			spawn_pos_2 = bottom_right
	
	var spawn_pos_x = randf_range(spawn_pos_1.x, spawn_pos_2.x)
	var spawn_pos_y = randf_range(spawn_pos_1.y, spawn_pos_2.y)

	return Vector2(spawn_pos_x, spawn_pos_y)
