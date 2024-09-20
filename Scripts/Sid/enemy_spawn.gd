extends Area3D

@export var ENEMY_TRIGGER: CharacterBody3D = null
@export var SPAWN_POINTS: Array[Node3D] = []

var triggered = false

var ENEMY_TYPES = [
	preload("res://Prefabs/Sid/enemy_melee.tscn"),
	preload("res://Prefabs/Sid/enemy_projectile.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !triggered:
		if ENEMY_TRIGGER in get_overlapping_bodies():
			for j in range(len(SPAWN_POINTS)):
				var i = randi_range(0, len(ENEMY_TYPES)-1)
				var k = ENEMY_TYPES[i]
				
				var k_inst = k.instantiate()
				
				add_child(k_inst)
				k_inst.global_position = SPAWN_POINTS[j].global_position
			
			triggered = true
