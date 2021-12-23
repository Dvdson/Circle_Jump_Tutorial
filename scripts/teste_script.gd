extends MainLoop

var SETTINGS = preload("settings.gd")

var radius = 100
var rotation_speed = PI
var jumper = null

var num_orbits = 3
var current_orbits = 0
var orbit_start = null
var move_range = 100
var move_speed = 1.0

func _initialize():
	var levels = range(1, 30)
	for level in levels:
		test(level)

func test(level):
	var _mode = SETTINGS.rand_weighted([10, level-1])
	#set_mode(_mode)
	#position = _position
	var move_chance = clamp(level-10, 0, 9)/10.0
	var r = randf()
	if r <  move_chance:
		move_range = max(25, 100 * rand_range(0.75, 1.25) * move_chance) * pow(-1, randi() % 2)
		move_speed = max(2.5 - ceil(level/5) * 0.25, 0.75)
	var small_chance = min(0.9, max(0, (level-10) / 20.0))
	if randf() < small_chance:
		radius = max(50, radius - level * rand_range(0.75, 1.25))
		
	print("lvl: %s, _mode: %s, mc: %s, r < mc: %s, mr: %s, ms: %s, sc: %s, radius: %s" % 
		[level, _mode, move_chance, r < move_chance, move_range, move_speed, small_chance, radius])
