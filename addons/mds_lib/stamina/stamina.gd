class_name MdsStamina extends Node

static var META: String = "mds_stamina"

#region Signals
signal stamina_changed(current_stamina: float)
signal stamina_consumed(remaining_stamina: float)
signal stamina_refilled(current_stamina: float)
signal not_enough_stamina()
#endregion

#region Exported Vars
@export var parent: Node
@export var stamina_quantity: float = 100.0:
	set(new_stamina_quantity):
		stamina_quantity = new_stamina_quantity
		stamina_changed.emit(stamina_quantity)
@export var stamina_max_quantity: float = 100.0
@export var stamina_refill_per_second: float = 5.0
#endregion

#region Godot's Lifecycle
func _ready() -> void:
	parent.set_meta(META, self)
#endregion

#region Business Logic
func consume_stamina(quantity: float):
	if stamina_quantity >= quantity:
		stamina_quantity -= quantity
		stamina_consumed.emit(stamina_quantity)
	else:
		not_enough_stamina.emit()

func refill_stamina_per_second():
	if stamina_quantity >= stamina_max_quantity:
		return
	
	stamina_quantity = min(stamina_quantity + stamina_refill_per_second, stamina_max_quantity)
	stamina_refilled.emit(stamina_quantity)

func refill() -> void:
	stamina_quantity = stamina_max_quantity

func refill_amount(amount: float) -> void:
	stamina_quantity = min(stamina_quantity + amount, stamina_max_quantity)
#endregion
