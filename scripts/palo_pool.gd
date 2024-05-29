extends Node3D
@onready var _cueStick : MeshInstance3D = get_node("Cylinder")
@export var  cue_scale = 0.5

func _ready():
	_cueStick.scale *=  cue_scale
	change_cue_color(1)
	GameEvent.change_turn.connect(change_cue_color)
	change_cue_visibility()
		
func update_cue_charge(ball_pos : Vector3, direction : Vector3, distance : float):
	const cue_lenght : float = 0.7
	var cueRotation : Vector3 = Vector3(1.5708, atan2(direction.x, direction.z), 0)
	var cuePosition : Vector3 = ball_pos + (-direction * distance) - (cue_lenght * direction * cue_scale)
	_cueStick.rotation = cueRotation
	_cueStick.position = cuePosition	
	
func change_cue_visibility():
	_cueStick.visible = !_cueStick.visible
		
		
func change_cue_color(turn : int):
	var material : Material 
	if turn == 1:
		material  = load("res://resources/materiales/palo1.tres")
	elif turn == 2: 
		material = load("res://resources/materiales/palo2.tres")
	_cueStick.set_surface_override_material(1,material)
