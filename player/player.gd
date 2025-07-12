extends CharacterBody3D

# State Machine
@export var state_machine : LimboHSM

# States
@onready var idle: LimboState = $LimboHSM/Idle
@onready var walk: LimboState = $LimboHSM/Walk

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.25

@onready var camera_3d: Camera3D = $Camera3D

var movement_input: Vector2 = Vector2.ZERO

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_initialize_state_machine()
	
func _initialize_state_machine() -> void:
	
	# Define State Transitions
	state_machine.add_transition(idle, walk, "to_walk")
	
	
	# Setup State Machine
	state_machine.initial_state = idle
	state_machine.initialize(self)
	state_machine.set_active(true)

func _unhandled_input(event):
	handle_mouse_input(event)

func apply_movement(delta):
	var direction := (transform.basis * Vector3(movement_input.x, 0, movement_input.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	movement_input = Input.get_vector("left", "right", "forward", "back")

	move_and_slide()

func handle_mouse_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		camera_3d.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-89), deg_to_rad(89))
