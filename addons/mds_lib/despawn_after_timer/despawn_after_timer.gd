class_name MdsDespawnAfterTimer extends Node

signal despawned

@export var target: Node
@export var despawn_delay: float = 1.0

func _ready() -> void:
	%Timer.wait_time = despawn_delay
	%Timer.start()

func _on_timer_timeout() -> void:
	if target:
		target.call_deferred("queue_free")
		despawned.emit()
