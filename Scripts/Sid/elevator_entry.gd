extends CharacterBody3D

signal reached_destination

@export var ELEVATION: float = 10.0
@export var SPEED: float = 0.01

var final_y = 0
var signal_sent = false


func _ready():
	final_y = position.y + ELEVATION
	

func _physics_process(delta):
	if (abs((final_y-position.y)/ELEVATION) < 0.01) and !signal_sent:
			position.y = final_y
			reached_destination.emit()
			signal_sent = true
			
	elif !GlobalValues.paused:
		if position.y <= final_y:
			position.y = lerp(position.y, final_y, SPEED)
		
			# not multiplying by delta because we're changing the position, -
			# not the velocity
