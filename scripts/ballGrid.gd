extends Control
class_name GridBall

@export var containersP1 : Array[Sprite2D] = []
@export var containersP2 : Array[Sprite2D] = []



func display(balls : Array[BallObject],containerID : int):
	var idx : int = 0
	if containerID == 1: 
		for container in containersP1:
			container.set_texture(null)

	elif containerID == 2:
		for container in containersP2:
			container.set_texture(null)

	for ball in balls:
		if containerID == 1:
			containersP1[idx].set_texture(ball.ballImg)
		elif containerID == 2:
			containersP2[idx].set_texture(ball.ballImg)
		idx += 1
		# hacer q  loopee por las bochas que les pasa alguna señal o metodo y ponerlo
		# en los containers 

func toggle_display(value : bool):
	for container in containersP1:
		container.visible = value
	
	for container in containersP2:
		container.visible = value
