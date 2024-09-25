extends CharacterBody3D

signal reached_destination

@export var MUSIC_DAMP_TRIGGER: CharacterBody3D = null
@export var ELEVATION: float = 10.0
@export var SPEED: float = 0.01

@onready var elevator_music = $ElevatorMusic
@onready var level_arrived_music = $ElevatorMusic/LevelArrivedMusic

var final_y = 0
var signal_sent = false


func _ready():
	final_y = position.y + ELEVATION
	

func _physics_process(delta):
	# print(elevator_music.get_stream_paused())
	if !GlobalValues.paused:
		if (abs((final_y-position.y)/ELEVATION) < 0.01) and !signal_sent:
				position.y = final_y
				level_arrived_music.play()
				reached_destination.emit()
				signal_sent = true
				
		elif position.y < final_y:
			position.y = lerp(position.y, final_y, SPEED)
			# not multiplying by delta because we're changing the position,-
			# not the velocity
		
		elevator_music.set_stream_paused(false)
		
	else:
		elevator_music.set_stream_paused(true)


func _on_elevator_music_finished():
	if !signal_sent:
		elevator_music.play()


func _on_level_arrived_music_finished():
	elevator_music.stop()
