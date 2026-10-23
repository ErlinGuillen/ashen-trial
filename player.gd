extends CharacterBody3D

@export var move_speed: float = 5.0
@export var mouse_sensitivity: float = 0.003

@onready var camera_pivot: Node3D = $CameraPivot

var gravity: float = 9.8

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		return

	if event is InputEventMouseButton:
		if event.pressed and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event is InputEventMouseMotion:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			return

		camera_pivot.rotation.y -= (
			event.relative.x * mouse_sensitivity
		)

		camera_pivot.rotation.x -= (
			event.relative.y * mouse_sensitivity
		)

		camera_pivot.rotation.x = clampf(
			camera_pivot.rotation.x,
			deg_to_rad(-40.0),
			deg_to_rad(45.0)
		)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
        "move_backward"
	)

	var direction := (
		camera_pivot.global_basis.x * input_dir.x
		+ camera_pivot.global_basis.z * input_dir.y
	)
	direction.y = 0.0
	direction = direction.normalized()

	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed

	if direction.length_squared() > 0.01:
		rotation.y = lerp_angle(
			rotation.y,
			atan2(-direction.x, -direction.z),
			10.0 * delta
		)

	move_and_slide()
