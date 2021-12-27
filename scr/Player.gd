extends KinematicBody

var camera_angle = 0
var mouse_sensitivity = 0.1
var MaxSpeed = 64
var Acceleration = 0.25

var CamDirection
var MoveDirection = Vector3()
var movementVelocity = Vector3()
var target

# Gravity Variables
export var mass = 10
export var velocity = Vector3(0,0,0)
var G = 0.000000674
var otherBody
var gravityDirection
var r
var gravitationalPull

var i = 1

func _ready():
	pass

func _physics_process(delta):
	# Calculate Gravity
	for i in range(get_parent_spatial().get_child_count()):
		velocity += calculategravitationalPull(i)
#	print(get_global_transform().basis.z)
#	var temp = get_global_transform()
#	temp.basis.y = -velocity.normalized()
#	set_global_transform(temp)
	
	print (self.rotation_degrees)
	# Calculate Movement velosity
	MoveDirection = Vector3()
	CamDirection = $ Camera.get_global_transform().basis
#	CamDirection.z.y = 0
	if Input.is_action_pressed("ui_forward"):
		MoveDirection -= CamDirection.z
	if Input.is_action_pressed("ui_back"):
		MoveDirection += CamDirection.z
	if Input.is_action_pressed("ui_left"):
		MoveDirection -= CamDirection.x
	if Input.is_action_pressed("ui_right"):
		MoveDirection += CamDirection.x
	if Input.is_action_pressed("ui_up"):
		movementVelocity.y += Acceleration
	if Input.is_action_pressed("ui_down"):
		movementVelocity.y -= Acceleration
#	if i == 1:
#		print(get_global_transform().basis)
#		i = 0
#	else:
#		i = 1
	MoveDirection = MoveDirection.normalized()
	target = MoveDirection * MaxSpeed
	movementVelocity = lerp(movementVelocity, target, Acceleration * delta)
	
	# Move (Player Input)
	movementVelocity = move_and_slide(movementVelocity)
	# Move (Gravity)
	velocity = move_and_slide(velocity)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x) * mouse_sensitivity)
		
		var change = -event.relative.y * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90:
			$ Camera.rotate_x(deg2rad(change))
			camera_angle += change

func calculategravitationalPull(otherBodyIndex):
	if otherBodyIndex == self.get_index():
		return Vector3()
	
	otherBody = get_parent_spatial().get_child(otherBodyIndex)
	# Calculates the direction of the other body
	gravityDirection = (otherBody.translation - translation).normalized()
	# Calculates the distance to the other body
	r = translation.distance_to(otherBody.translation)
	
	# Newton's law of universal gravitation & F = MA
	gravitationalPull = gravityDirection * G * (otherBody.mass) / r*r
	return gravitationalPull
