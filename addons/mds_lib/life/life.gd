class_name MdsLife extends Node

static var META = "mds_life"

signal damage_taken(amount: float, remaining_life: float)
signal heal_received(amount: float, remaining_life: float)
signal dead()

@export var parent: Node
@export var max_life: float = 100.0
@export var life: float = 100.0

func _ready() -> void:
	parent.set_meta(META, self)

func take_damage(amount_of_damage: float):
	life = max(life - amount_of_damage, 0.0)
	if life <= 0.0:
		dead.emit()
	else:
		damage_taken.emit(amount_of_damage, life)

func heal(amount_to_heal: float):
	var previous_life: float = life
	life = min(life + amount_to_heal, max_life)
	heal_received.emit(life - previous_life, life)
