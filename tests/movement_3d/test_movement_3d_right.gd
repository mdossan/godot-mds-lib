class_name TestMovement3DRight extends MdsTestScene

@onready var character_body_3d: CharacterBody3D = %CharacterBody3D

func test():
	await input_press("right")
	await wait_physics_frame()
	assert_gt(character_body_3d.position.x, 0, "position.x should be > 0")
