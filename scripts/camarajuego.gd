extends Camera3D
var CameraDictionary = {
	"PoolTable": 
		{
		2: ["position",Vector3(0,0.84,0),1],
		1: ["rotation",Vector3(-1.57,1.57,0),1]
		},
	"Shop": 
		{
		1: ["position",Vector3(0,0.7,0),1],
		2: ["rotation",Vector3(0,3.14,0),1]
		},
	"8Ball":
		{
		1: ["position",Vector3(0,0.7,0),1],
		2: ["rotation",Vector3(0,0,0),1],
		3: ["position",Vector3(0,0.7,-5),2],
		4: ["rotation", Vector3(0.52,-1.57,0),1],
		5: ["position",Vector3(1.15,2.28,-5),1]
		}}
var CameraState : String = "PoolTable"
var PastCameraState : String
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


	


func _on_tienda_pressed():
	
	
	if CameraState == "PoolTable": 
		CameraState = "8Ball"
	else:
		CameraState = "PoolTable"
	
	var ordered_steps = CameraDictionary[CameraState].keys()
	ordered_steps.sort()
	
	if PastCameraState:
		var past_ordered_steps = CameraDictionary[PastCameraState].keys()
		past_ordered_steps.sort()
		past_ordered_steps.reverse()
		cameraTransition(past_ordered_steps,PastCameraState)
		await get_tree().create_timer(6).timeout
		cameraTransition(ordered_steps,CameraState)
	else: 
		cameraTransition(ordered_steps,CameraState)
	
	PastCameraState = CameraState
	
	pass 
	
func cameraTransition(steps: Array, state: String):
	var tween = create_tween()
	for step in steps:
		var property = CameraDictionary[state][step][0]
		var vector = CameraDictionary[state][step][1]
		var duration = CameraDictionary[state][step][2]
		tween.tween_property(self,property, vector , duration)
	pass
