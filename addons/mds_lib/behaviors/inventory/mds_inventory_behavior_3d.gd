@tool
class_name MdsInventoryBehavior3D
extends Node3D

signal new_item_in_inventory(new_item: MdsItem3D)
signal item_dropped

@export var parent: Node3D
@export var drop_target: Node3D:
	set(new_value):
		drop_target = new_value
		update_configuration_warnings()
@export var spawner: MdsNode3DSpawner
@export var world_item_spawner: MdsNode3DSpawner
@export var max_item: int = 1
var items: Dictionary[String, MdsItem3D]
var selected_item: Node3D

func _get_configuration_warnings() -> PackedStringArray:
	var results: Array[String] = []
	if drop_target == null:
		results.push_back("'Drop Target' should be defined")
	return results

func _input(event: InputEvent) -> void:
	if multiplayer.get_unique_id() != get_multiplayer_authority():
		return
	
	if !is_instance_valid(selected_item):
		return
	
	var item: MdsItem3D = selected_item.get_meta(MdsItem3D.META)
	if event.is_action_pressed("use") and item.item_resource.usage:
		item.used.emit(item, self)
		item.item_resource.usage.use(item)

func pick_item(node: Node3D) -> void:
	if get_children().size() >= max_item:
		push_warning("Can't pick item, inventory is full")
		return
	
	if !node.has_meta(MdsItem3D.META):
		push_error("Picked item should have a meta `mds_item_3d`")
		return
	
	var item: MdsItem3D = node.get_meta(MdsItem3D.META)
	item.item_timestamp = Time.get_unix_time_from_system()
	item.inventory = self
	node.position = Vector3.ZERO
	node.reparent(self, false)
	selected_item = node
	new_item_in_inventory.emit(item)

func drop_item() -> void:
	if selected_item == null || !is_instance_valid(selected_item):
		return
	
	var item: MdsItem3D = selected_item.get_meta(MdsItem3D.META)
	if world_item_spawner and world_item_spawner.get_multiplayer_authority() != get_multiplayer_authority():
		world_item_spawner.remote_spawn.rpc({
			"resource_path": selected_item.scene_file_path,
			"position": selected_item.global_position,
			"rotation": parent.global_rotation,
			"callable_key": "drop_item",
			"properties": {
				"item_unique_id": item.item_unique_id,
				"item_timestamp": Time.get_unix_time_from_system(),
			}
		})
		selected_item.queue_free()
	elif world_item_spawner:
		var new_node = world_item_spawner.spawn({
			"multiplayer_authority": get_multiplayer_authority(),
			"resource_path": selected_item.scene_file_path,
			"position": selected_item.global_position,
			"rotation": parent.global_rotation,
			"properties": {
				"item_unique_id": item.item_unique_id,
				"item_timestamp": Time.get_unix_time_from_system(),
			}
		})
		var new_item: MdsItem3D = new_node.get_meta(MdsItem3D.META)
		new_item.dropped.emit()
		selected_item.queue_free()
	else:
		# TODO: find a way to handle drop in a "world node"
		selected_item.reparent(drop_target, false)
	item_dropped.emit()
	selected_item = null

func register_item(item: MdsItem3D):
	items[item.item_id] = item

func _on_child_entered_tree(node: Node3D) -> void:
	if node.has_meta(MdsItem3D.META):
		var new_item: MdsItem3D = node.get_meta(MdsItem3D.META)
		items[new_item.item_resource.item_id] = new_item
		selected_item = new_item
