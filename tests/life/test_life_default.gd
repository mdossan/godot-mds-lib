class_name TestLifeDefault extends MdsTestScene

@onready var mds_life: MdsLife = %Life

func test():
	assert_eq(mds_life.life, 100, "life should be 100")
	assert_eq(mds_life.max_life, 100, "max_life should be 100")
	assert_eq(mds_life.parent, self, "parent should be the current test scene")
	assert_eq(get_meta(MdsLife.META), mds_life, "test scene should have meta corresponding to mds_life")
