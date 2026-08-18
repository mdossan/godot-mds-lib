class_name TestJump extends MdsTestScene

func test():
	await input_press("jump")
	await wait_physics_frames(10)
	assert_gt(%CharacterBody3D.position.y, 1, "Jump was done")
