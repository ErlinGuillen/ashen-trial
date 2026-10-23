extends CharacterBody3D

@export var speed: float = 5.0
@export var mouse_sensitivity: float = 0.003

@onready var camera_pivot: Node3D = $CameraPivot

# Use project settings gravity for consistency across your scene
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	# Release mouse on Escape
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	# Recapture mouse on click
	if event is InputEventMouseButton and event.pressed:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Mouse Look
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Rotate the body left/right (Yaw)
		rotate_y(-event.relative.x * mouse_sensitivity)

		# Rotate only the camera pivot up/down (Pitch)
		camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_pivot.rotation.x = clampf(
			camera_pivot.rotation.x,
			deg_to_rad(-40.0),
			deg_to_rad(45.0)
		)


func _physics_process(delta: float) -> void:
	# Apply Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Read Input
	var input_dir := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)

	# Calculate movement direction relative to character body rotation
	var direction := (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
		velocity.z = move_toward(velocity.z, 0.0, speed)

	move_and_slide()
