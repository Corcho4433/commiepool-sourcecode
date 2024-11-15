extends Area3D

func _on_body_entered(body):
	if "implements" in body:
		if Interface.Scorable in body.implements:
			body.animate_score()
