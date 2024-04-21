extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	var tween = create_tween()
	tween.tween_property(self,"position", Vector3(0,0.30,0) ,1)
	tween.tween_property(self,"rotation", Vector3(deg_to_rad(90),1.5707963268,0) ,1)
	tween.tween_property(self,"rotation", Vector3(0,3.1415926536,0) ,1)
	
