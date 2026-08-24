extends MdsTestScene

func test():
	var subject = %Subject
	await %DespawnAfterTimer.despawned
	await %DespawnAfterTimer.tree_exited
	await wait_physics_frame() # Queue free occurs after the physics frame
	assert_eq(get_child_count(), 0, "Subject node should be removed")
	assert_is_valid(!is_instance_valid(subject), "Subject node should not be a valid instance")
