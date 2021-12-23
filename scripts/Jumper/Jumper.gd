extends Area2D

signal captured
signal died

var velocity = Vector2(100, 0) 
var jump_speed = 1000
var target = null
var trail_length = 25

onready var trail = $Trail/Points

func _ready():
	$Sprite.material.set_shader_param("color", SETTINGS.theme["player_body"])
	var trail_color = SETTINGS.theme["player_trail"]
	trail.gradient.set_color(1, trail_color)
	trail_color.a = 0
	trail.gradient.set_color(0, trail_color)

func _unhandled_input(event):
	if target and event is InputEventScreenTouch and event.is_pressed():
		jump()
		
func jump():
	target.implode()
	target = null
	velocity = transform.x * jump_speed
	if SETTINGS.enable_sound:
		$Jump.play()
	
func die():
	target = null
	queue_free()
	
func _on_VisibilityNotifier2D_screen_exited():
	if !target:
		emit_signal("died")
		die()
	
func _on_Jumper_area_entered(area):
	target = area
	velocity = Vector2.ZERO
	emit_signal("captured", area)
	if SETTINGS.enable_sound:
		$Capture.play()
	# target.get_node("Pivot").rotation = (position - target.position).angle()


func _physics_process(delta):
	if trail.points.size() > trail_length:
		trail.remove_point(0)
	trail.add_point(position)
	
	if target:
		transform = target.orbit_position.global_transform
	else:
		position += velocity * delta




func _on_VisibilityNotifier2D_visibility_changed():
	pass # Replace with function body.
