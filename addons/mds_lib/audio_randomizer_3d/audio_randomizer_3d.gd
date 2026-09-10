class_name MdsAudioRandomizer3D extends AudioStreamPlayer3D

@export var pitch_randomness: float = .1 

func play(from_position: float = 0.0):
	pitch_scale = randf_range(1 - pitch_randomness, 1 + pitch_randomness)
	super(from_position)
