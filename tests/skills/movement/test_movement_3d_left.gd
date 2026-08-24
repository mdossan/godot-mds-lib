class_name TestMovement3DLeft extends MdsTestScene

@onready var character_body_3d: CharacterBody3D = %CharacterBody3D

func test():
	await input_press("left")
	await wait_physics_frame()
	assert_lt(character_body_3d.position.x, 0, "position.x should be < 0")
