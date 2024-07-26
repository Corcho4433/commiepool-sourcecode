extends CanvasLayer

@onready var luz = $fondo/SpotLight3D
@onready var camara_pos = $fondo/SubViewportContainer/SubViewport/Node3D
@onready var anim_player = $AnimationPlayer
@onready var WorldE = $WorldEnvironment

# Called when the node enters the scene tree for the first time.
func _ready():
	while true:
		luz.light_energy = 16
		await get_tree().create_timer(randf_range(0.5,3)).timeout
		luz.light_energy = 0.5
		await get_tree().create_timer(randf_range(0.1,0.2)).timeout
	#while rotar == true: rompe todo la mierda esta :(
		#await get_tree().create_timer(0.02).timeout
		#camara_pos.rotate_y(deg_to_rad(1))

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_iniciar_pressed():
	anim_player.play("inicial_a_juegos")


func _on_salir_pressed():
	get_tree().quit()


func _on_config_pressed():
	anim_player.play("inicial_a_config")

func _on_creditos_pressed():
	anim_player.play("inicial_a_creditos")


func _on_juegos_atras_pressed():
	anim_player.play_backwards("inicial_a_juegos")


func _on_config_atras_pressed():
	anim_player.play_backwards("inicial_a_config")


func _on_clasico_pressed():
	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")


func _on_check_box_toggled(toggled_on):
	pass
func _on_check_box_2_toggled(toggled_on):
	pass # Replace with function body.
func _on_check_box_3_toggled(toggled_on):
	pass # Replace with function body.


func _on_creditos_atras_pressed():
	anim_player.play_backwards("inicial_a_creditos")


func _on_commie_pressed():
	$Control/MarginContainer_juegos/VBoxContainer/commie.text = "Proximamente"
	await get_tree().create_timer(1).timeout
	$Control/MarginContainer_juegos/VBoxContainer/commie.text = "Commie pool"
