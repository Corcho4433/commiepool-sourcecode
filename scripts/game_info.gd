extends Node

# La influencia maxima que puede tener la distancia en el calculo de la fuerza
const MAX_DISTANCE_FORCE = 0.4
# Distancia visual del palo y la pelota
const MAX_DISTANCE = 0.3
const MIN_DISTANCE = 0.04
const  cue_scale = 0.5

const PLAYER_ONE = 1
const PLAYER_TWO = 2


var infoPlayer = {
	PLAYER_ONE: {"Balls": []},
	PLAYER_TWO: {"Balls": []},
}


