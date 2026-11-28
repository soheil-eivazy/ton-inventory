extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const CAMERA_SPEED = 0.5
var health: int = 5

var interactee: Node3D = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * CAMERA_SPEED
		%Camera3D.rotation_degrees.x -= event.relative.y * CAMERA_SPEED
		%Camera3D.rotation_degrees.x = clamp(
			%Camera3D.rotation_degrees.x, -70.0, 70.0
		)
		
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("LEFT", "RIGHT", "FORWARD", "BACK")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if interactee != null:
		if Input.is_action_just_pressed("ACTION"):
			if interactee.has_method("action"):
				interactee.action()

	move_and_slide()


func _on_area_3d_area_entered(area: Area3D) -> void:
	interactee = area


func _on_area_3d_area_exited(area: Area3D) -> void:
	interactee = null
