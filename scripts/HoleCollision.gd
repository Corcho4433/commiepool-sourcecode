extends Area3D

func _on_body_entered(body):
	if "implements" in body:
		if Interface.Holeable in body.implements:
			body.disable_collision()
