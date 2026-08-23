class_name TestLifeDead extends MdsTestScene

@onready var mds_life: MdsLife = %Life

var dead_emitted: bool = false

func test():
	assert_eq(mds_life.life, 100, "life should be 100")
	assert_eq(mds_life.max_life, 100, "max_life should be 100")
	mds_life.take_damage(200)
	assert_eq(mds_life.life, 0, "life should be 0")
	assert_true(dead_emitted, "dead_emitted signal should be emitted")

func _on_life_dead() -> void:
	dead_emitted = true
