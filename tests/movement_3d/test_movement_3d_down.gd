class_name TestMovement3DDown extends MdsTestScene

@onready var character_body_3d: CharacterBody3D = %CharacterBody3D

func test():
	await input_press("down")
	await wait_physics_frame()
	assert_gt(character_body_3d.position.z, 0, "position.z should be > 0")
