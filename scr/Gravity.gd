extends KinematicBody

export var mass = 70000
export var velocity = Vector3(2,0,0)
export var initialRotation = Vector3()

var G = 0.000000674
var otherBody
var gravityDirection
var r
var gravitationalPull

func _ready():
	pass

func _physics_process(delta):
	for i in range(get_parent_spatial().get_child_count()):
		velocity += calculategravitationalPull(i)
	rotate_x(deg2rad(initialRotation.x))
	rotate_y(deg2rad(initialRotation.y))
	rotate_z(deg2rad(initialRotation.z))
	velocity = move_and_slide(velocity)

func calculategravitationalPull(i):
	if i == self.get_index():
		return Vector3()
	else:
			otherBody = get_parent_spatial().get_child(i)
	
			# Calculates the distance between two bodies
			gravityDirection = (otherBody.translation - translation).normalized()
			r = translation.distance_to(otherBody.translation)
			
			# Newton's law of universal gravitation & F = MA
			gravitationalPull = gravityDirection * G * (otherBody.mass) / r*r
			return gravitationalPull
