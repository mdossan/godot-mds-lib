class_name TestMovement3DUp extends MdsTestScene

@onready var character_body_3d: CharacterBody3D = %CharacterBody3D

func test():
	await input_press("up")
	await wait_physics_frame()
	assert_lt(character_body_3d.position.z, 0, "position.z should be < 0")
