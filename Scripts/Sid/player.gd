extends CharacterBody3D

# Code referenced from: https://youtu.be/xIKErMgJ1Yk

@export var JUMP_VELOCITY = 4.5
@export var WALKING_SPEED = 5.0
@export var SPRINTING_SPEED = 8.0
@export var CROUCHING_SPEED = 3.0
@export var CROUCH_DEPTH = 0.5
@export var MOUSE_SENSE = 0.4
@export var LERP_SPEED = 10.0
@export var PAUSE_MENU: Control = null

var current_speed = 5.0
var direction = Vector3.ZERO
var head_will_collide = false
var can_move = false

@onready var head = $Head
@onready var standing_collision_shape = $StandingCollisionShape
@onready var crouching_collision_shape = $CrouchingCollisionShape
@onready var ray_cast_3d = $RayCast3D

func _ready():
	PAUSE_MENU.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if !GlobalValues.paused:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSE))
			head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSE))
			
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		GlobalValues.paused = !GlobalValues.paused
		if !GlobalValues.paused:
			PAUSE_MENU.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			PAUSE_MENU.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	if !GlobalValues.paused:
		if position.y < -200:
			get_tree().reload_current_scene()
			return null
		
		head_will_collide = ray_cast_3d.is_colliding()
		
		if Input.is_action_pressed("crouch"):
			current_speed = CROUCHING_SPEED
			
			head.position.y = lerp(head.position.y, 1.0 - CROUCH_DEPTH, delta * LERP_SPEED)
			
			standing_collision_shape.disabled = true
			crouching_collision_shape.disabled = false
			
		elif !head_will_collide:
			head.position.y = lerp(head.position.y, 1.0, delta * LERP_SPEED)
			
			standing_collision_shape.disabled = false
			crouching_collision_shape.disabled = true
			
			if Input.is_action_pressed("sprint"):
				current_speed = SPRINTING_SPEED
				
			else:
				current_speed = WALKING_SPEED
		
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("jump") and is_on_floor() and !head_will_collide and can_move:
			velocity.y = JUMP_VELOCITY

		var input_dir = Input.get_vector("left", "right", "forward", "backward")
		direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),\
		 delta * LERP_SPEED)
		if direction and can_move:
			velocity.x = direction.x * current_speed
			velocity.z = direction.z * current_speed
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed)
			velocity.z = move_toward(velocity.z, 0, current_speed)

		move_and_slide()


func _on_elevator_entry_reached_destination():
	can_move = true
