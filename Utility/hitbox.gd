extends Area2D

@export var damage: int = 1

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var disable_timer: Timer = $DisableTimer

func temp_disable() -> void:
	collision.set_deferred("disabled", true)
	disable_timer.start()


func _on_disable_timer_timeout() -> void:
	collision.set_deferred("disabled", false)