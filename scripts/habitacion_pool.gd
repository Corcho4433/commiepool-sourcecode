extends Node3D

func _ready():
	var skibidi : StaticBody3D = get_node("habitacion_pool/colisiones")
	skibidi.set_script(load("res://scripts/mesa.gd"))
	skibidi.set_physics_material_override(load("res://scenes/objects/zero_friction.tres"))

