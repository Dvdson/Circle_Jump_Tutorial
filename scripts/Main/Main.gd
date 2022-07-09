extends Node2D

var Circle = preload("res://objects/Circle.tscn")
var Jumper = preload("res://objects/Jumper.tscn")

var player
var score = 0 setget set_score
var num_circles = 0
var highscore = 0
var new_record = false
var level = 0
var bonus = 0 setget set_bonus



func _ready():
	randomize()
	load_score()
	$HUD.hide()
	
func new_game():
	new_record=false
	self.score = 0
	self.bonus = 0
	self.num_circles = 0
	level = 1
	$HUD.update_score(score, 0)
	$Camera2D.position = $StartPosition.position
	
	player = Jumper.instance()
	player.position = $StartPosition.position
	add_child(player)
	player.connect("captured", self, "_on_Jumper_captured")
	player.connect("died", self, "_on_Jumper_died")
	spawn_circle($StartPosition.position)
	
	$HUD.show()
	$HUD.show_message('GO!')
	
	if SETTINGS.enable_music:
		$Music.volume_db = 0
		$Music.play()
	
	
func spawn_circle(_position=null):
	var c = Circle.instance()
	if !_position:
		var x = rand_range(-150, 150)
		var y = rand_range(-500, -400)
		_position = player.target.position + Vector2(x,y)
	add_child(c)
	c.connect("full_orbit", self, "set_bonus", [1])
	c.init(_position, level)

func set_score(value):
	$HUD.update_score(score, value)
	score = value
	if !new_record && score > highscore:
		$HUD.show_message("New Record!")
		new_record=true

"""
Note that because this function is called during physics processing, we’ll get 
an error if we try and add to the scene tree. Using call_deferred() tells the 
engine to execute that function as soon as it’s safe to do so.
"""
func _on_Jumper_captured(object):
	$Camera2D.position = object.position
	object.capture(player)
	call_deferred("spawn_circle")
	self.score += 1 * bonus
	self.bonus += 1
	num_circles += 1
	if num_circles > 0 and num_circles % SETTINGS.circles_per_level == 0:
		level += 1
		$HUD.show_message("Level %s" % str(level))
	
func _on_Jumper_died():
	if score > highscore:
		highscore = score
		save_score()
	get_tree().call_group("circles", "implode")
	$Screens.game_over(score, highscore)
	$HUD.hide()
	if SETTINGS.enable_music:
		fade_music()
		
func load_score():
	var f = File.new()
	if f.file_exists(SETTINGS.score_file):
		f.open(SETTINGS.score_file, File.READ)
		highscore = f.get_var()
		f.close()

func save_score():
	var f = File.new()
	f.open(SETTINGS.score_file, File.WRITE)
	f.store_var(highscore)
	f.close()

func fade_music():
	$MusicFade.interpolate_property($Music, "volume_db",
		0, -50, 1.0, Tween.TRANS_SINE, Tween.EASE_IN)
	$MusicFade.start()
	yield($MusicFade, "tween_all_completed")
	$Music.stop()

func set_bonus(value):
	bonus = value
	$HUD.update_bonus(bonus)
