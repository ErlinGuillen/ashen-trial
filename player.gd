
extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_velocity: float = 4.5

var gravity: float = 9.8

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Read movement input
	var input_dir := Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
        "ui_down"
	)

	# Move relative to the world
	var direction := Vector3(
		input_dir.x, 0, input_dir.y
	)

	if direction.length() > 0:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
