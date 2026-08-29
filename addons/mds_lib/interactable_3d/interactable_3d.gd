class_name MdsInteractable3D extends Area3D

static var META: String = "mds_interactable_3d"

@export var parent: Node3D
@export var shape: Shape3D = preload("res://addons/mds_lib/interactable_3d/interactable_3d_default_shape.tres")
@export var disabled: bool = false

var interactions: Array[MdsInteraction] = []
var current_actor: Node

func _ready():
	parent.set_meta(META, self)
	
	if shape != null:
		%Shape.shape = shape
	
	# Get interactions passed as children
	var children = get_children()
	interactions.assign(children.filter(func(e):
		return is_instance_valid(e) && e is MdsInteraction
	))
	
	# Build menu to choose interactions
	# Will be used when multiple interactions are possibles
	for interaction in interactions:
		var button: Button = Button.new()
		button.text = interaction.get_interaction_label()
		button.button_down.connect(func ():
			interaction.execute_interaction(current_actor)
			%InteractMenu.visible = false
		)
		%PossibleInteractions.add_child(button)
	%InteractMenu.visible = false

func interact(actor: Node):
	if disabled:
		return

	if interactions.is_empty():
		push_warning("No interaction")
		return

	if interactions.size() == 1:
		interactions.get(0).execute_interaction(actor)
		%InteractMenu.visible = false
		return
	
	current_actor = actor
	%InteractMenu.visible = true
