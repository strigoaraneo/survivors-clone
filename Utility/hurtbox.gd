extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitbox") var hurtbox_type = 0

@onready var collision = $CollisionShape2D
@onready var disable_timer = $DisableTimer

signal hurt(damage)


func _on_area_entered(area:Area2D) -> void:
	if area.is_in_group("attack"):
		if area.get("damage") != null:
			match hurtbox_type:
				0: # Cooldown
					collision.set_deferred("disabled", true)
					disable_timer.start()
				1: # HitOnce
					pass
				2: # DisableHitbox
					if area.has_method("temp_disable"):
						area.temp_disable()
				
			var damage: int = area.damage
			emit_signal("hurt", damage)


func _on_disable_timer_timeout() -> void:
	collision.set_deferred("disabled", false)
