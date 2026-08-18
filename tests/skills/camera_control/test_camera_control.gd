extends MdsTestScene

var right_box_is_visible: bool = false
var left_box_is_visible: bool = false
var bottom_box_is_visible: bool = false

func test() -> void:
	input_mouse(32, 0) # 
	await wait_physics_frames(10)
	assert_eq(right_box_is_visible, true, "Right box should be visible")
	assert_eq(left_box_is_visible, false, "Left box should not be visible")
	assert_eq(bottom_box_is_visible, false, "Bottom box should not be visible")
	input_mouse(-64, 0)
	await wait_physics_frames(10)
	assert_eq(right_box_is_visible, false, "Right box should not be visible")
	assert_eq(left_box_is_visible, true, "Left box should be visible")
	assert_eq(bottom_box_is_visible, false, "Bottom box should not be visible")
	input_mouse(32, 0) # Reset to initial position
	input_mouse(0, 64)
	await wait_physics_frames(10)
	assert_eq(right_box_is_visible, false, "Right box should not be visible")
	assert_eq(left_box_is_visible, false, "Left box should not be visible")
	assert_eq(bottom_box_is_visible, true, "Bottom box should be visible")

func _on_right_box_notifier_screen_entered() -> void:
	print("RightBox is visible")
	right_box_is_visible = true

func _on_right_box_notifier_screen_exited() -> void:
	print("RightBox is not visible")
	right_box_is_visible = false

func _on_left_box_notifier_screen_entered() -> void:
	print("LeftBox is visible")
	left_box_is_visible = true

func _on_left_box_notifier_screen_exited() -> void:
	print("LeftBox is not visible")
	left_box_is_visible = false

func _on_bottom_box_notifier_screen_entered() -> void:
	print("BottomBox is visible")
	bottom_box_is_visible = true

func _on_bottom_box_notifier_screen_exited() -> void:
	print("BottomBox is not visible")
	bottom_box_is_visible = false
