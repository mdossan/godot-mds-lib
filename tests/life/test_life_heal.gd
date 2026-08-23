class_name TestLifeHeal extends MdsTestScene

@onready var mds_life: MdsLife = %Life

var heal_received_emitted: bool = false

func test():
	assert_eq(mds_life.life, 80, "life should be 80")
	assert_eq(mds_life.max_life, 100, "max_life should be 100")
	mds_life.heal(10)
	assert_eq(mds_life.life, 90, "life should be 90")
	assert_true(heal_received_emitted, "heal_received_emitted should be true")

func _on_life_heal_received(amount: float, remaining_life: float) -> void:
	heal_received_emitted = true
	assert_eq(amount, 10, "amount should be 10")
	assert_eq(remaining_life, 90, "remaining_life should be 90")
