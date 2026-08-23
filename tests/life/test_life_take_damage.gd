class_name TestLifeTakeDamage extends MdsTestScene

@onready var mds_life: MdsLife = %Life

var damage_taken_emitted: bool = false

func test():
	assert_eq(mds_life.life, 100, "life should be 100")
	assert_eq(mds_life.max_life, 100, "max_life should be 100")
	mds_life.take_damage(20)
	assert_eq(mds_life.life, 80, "life should be 80")
	assert_true(damage_taken_emitted, "damage_taken signal should be emitted")

func _on_life_damage_taken(amount: float, remaining_life: float) -> void:
	damage_taken_emitted = true
	assert_true(amount, "amount should be 20")
	assert_true(remaining_life, "remaining_life should be 80")
