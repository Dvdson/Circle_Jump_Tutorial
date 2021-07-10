extends Area2D

signal captured

var velocity = Vector2(100, 0) 
var jump_speed = 1000
var target = null
var trail_length = 25

onready var trail = $Trail/Points

func _unhandled_input(event):
	if target and event is InputEventScreenTouch and event.is_pressed():
		jump()
		
func jump():
	target.implode()
	target = null
	velocity = transform.x * jump_speed
	
func _on_Jumper_area_entered(area):
	target = area
	velocity = Vector2()
	emit_signal("captured", area)
	target.get_node("Pivot").rotation = (position - target.position).angle()


func _physics_process(delta):
	if target:
		transform = target.orbit_position.global_transform
	else:
		position += velocity * delta
	
	if trail.points.size() > trail_length:
		trail.remove_point(0)
	trail.add_point(position)


