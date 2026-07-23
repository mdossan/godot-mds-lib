@tool
class_name MdsItem3D
extends Node3D

static var META = "mds_item_3d"

signal picked()
signal dropped()
signal dropped_from_inventory(inventory: MdsInventoryBehavior3D)
signal used(item: MdsItem3D, inventory: MdsInventoryBehavior3D)

@export var parent: Node3D
@export var item_resource: MdsItemResource:
	set(new_value):
		item_resource = new_value
		#if item_resource:
			#%Mesh.mesh = item_resource.mesh
		update_configuration_warnings()
@export var inventory: MdsInventoryBehavior3D: set = set_inventory

var item_unique_id: int = ResourceUID.create_id()
var item_timestamp: float = Time.get_unix_time_from_system()

#region Godot's Lifecycle

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	add_to_group(META)
	if parent:
		parent.set_meta(META, self)
	set_meta(META, self)
	#%Mesh.mesh = item_resource.mesh

#endregion

func set_inventory(new_inventory: MdsInventoryBehavior3D):
	inventory = new_inventory
	if is_multiplayer_authority():
		remote_set_inventory.rpc(new_inventory.get_path())

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if item_resource == null:
		warnings.push_back("'Item Resource' should be defined")
	return warnings

func delete():
	if parent:
		parent.queue_free()
	else:
		queue_free()

#region RPCs

@rpc("authority", "call_remote")
func remote_set_inventory(inventory_path: NodePath):
	var new_inventory = get_tree().root.get_node(inventory_path)
	inventory = new_inventory

@rpc("authority", "reliable")
func remote_delete():
	if parent:
		parent.queue_free()
	else:
		queue_free()

#endregion
