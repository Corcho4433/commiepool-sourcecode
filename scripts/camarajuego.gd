extends Camera3D
var CameraDictionary = {
	"PoolTable": 
		{
		2: ["position",Vector3(0,0.84,0),0.5],
		1: ["rotation",Vector3(-1.57,1.57,0),1]
		},
	"Shop": 
		{
		1: ["position",Vector3(0,0.7,0),0.5],
		2: ["rotation",Vector3(0,3.14,0),1]
		},
	"8Ball":
		{
		1: ["rotation", Vector3(-0.17,-1.57,0),1],
		2: ["position",Vector3(1.15,2.28,-5),1]
		}}
var CameraState : String = "PoolTable"
var CameraTransition: String


func _on_tienda_pressed():
	if CameraState == "PoolTable": 
		CameraState = "Shop"
	else:
		CameraState = "PoolTable"
	
	
	cameraTransition(CameraState)
	pass 
	
func cameraTransition(state: String):
	var tween = create_tween()
	var ordered_steps = CameraDictionary[state].keys()
	ordered_steps.sort()
	for step in ordered_steps:
		var property = CameraDictionary[state][step][0]
		var vector = CameraDictionary[state][step][1]
		var duration = CameraDictionary[state][step][2]
		tween.tween_property(self,property, vector , duration)
	pass
