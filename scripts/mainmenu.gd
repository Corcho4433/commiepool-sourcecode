extends CanvasLayer

@onready var luz = $fondo/SpotLight3D

# Called when the node enters the scene tree for the first time.
func _ready():
	while true:
		luz.light_energy = 28
		await get_tree().create_timer(randf_range(0.5,3)).timeout
		luz.light_energy = 2
		await get_tree().create_timer(randf_range(0.1,0.5)).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_iniciar_pressed():
	get_tree().change_scene_to_file("res://escenes/GameEscene.tscn")


func _on_salir_pressed():
	get_tree().quit()
