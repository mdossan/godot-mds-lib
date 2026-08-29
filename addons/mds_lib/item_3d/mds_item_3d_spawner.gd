class_name MdsItem3DSpawner
extends MultiplayerSpawner

@export var items: MdsItemsResource

var item_scene: PackedScene = preload("res://addons/mds_lib/item/mds_item_3d.tscn")

func _enter_tree() -> void:
	spawn_function = _custom_spawn

func _custom_spawn(item_id: String):
	var item: MdsItem3D = item_scene.instantiate()
	item.set_multiplayer_authority(get_multiplayer_authority())
	item.item_resource = items.data.get(item_id)
	var spawn_node: Node3D = get_node(spawn_path)
	item.position = Vector3.ZERO
	return item
