extends Node
class_name TurnManager 


## Almacena una referencia al objeto [BallsArray] de la escena.
@onready
var ball_array : BallsArray = get_node("BallArrayComponent")
## Almacena una referencia al objeto [CueObject] de la escena.
@onready
var cue_component : CueObject = get_node("CueComponent")
