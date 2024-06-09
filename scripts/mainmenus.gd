extends CanvasLayer

@onready var luz = $fondo/SpotLight3D
@onready var camara_rot = $fondo/SubViewportContainer/SubViewport/Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	while true:
		await get_tree().create_timer(0.02).timeout
		camara_rot.rotate_y(deg_to_rad(1))

func _ready_2():
	while true:
		luz.light_energy = 16
		await get_tree().create_timer(randf_range(0.5,3)).timeout
		luz.light_energy = 0.5
		await get_tree().create_timer(randf_range(0.1,0.2)).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_iniciar_pressed():
	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")


func _on_salir_pressed():
	get_tree().quit()
