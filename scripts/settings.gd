extends Node

var score_file = "user://highscore.save"
var settings_file = "user://setting.save"
var file_pass = "8061B02A80395DF141036C164D4D5C0E75CFC91DD4709F625FC35CF43C9196287505588B4CB37A7050F4033C709DB7A572AA5F88D614DD0E26B197BB0D916678"
var enable_sound = true
var enable_music = true

var circles_per_level = 5

var color_schemes = {
	"NEON1": {
		'background': Color8(0, 0, 0),
		'player_body': Color8(203, 255, 0),
		'player_trail': Color8(204, 0, 255),
		'circle_fill': Color8(255, 0, 110),
		'circle_static': Color8(0, 255, 102),
		'circle_limited': Color8(204, 0, 255)
	},
	"NEON2": {
		'background': Color8(0, 0, 0),
		'player_body': Color8(246, 255, 0),
		'player_trail': Color8(255, 255, 255),
		'circle_fill': Color8(255, 0, 110),
		'circle_static': Color8(151, 255, 48),
		'circle_limited': Color8(127, 0, 255)
	},
	"NEON3": {
		'background': Color8(0, 0, 0),
		'player_body': Color8(255, 0, 187),
		'player_trail': Color8(255, 148, 0),
		'circle_fill': Color8(255, 148, 0),
		'circle_static': Color8(170, 255, 0),
		'circle_limited': Color8(204, 0, 255)
	}
}

var theme = color_schemes["NEON1"]

static func rand_weighted(weights):
	var sum = 0
	for weight in weights:
		sum += weight
	var num = rand_range(0, sum)
	for i in weights.size():
		if num < weights[i]:
			return i
		num -= weights[i]
		

func _ready():
	load_settings()

func save_settings():
	var f = File.new()
	var this = inst2dict(self)
	f.open_encrypted_with_pass(settings_file, File.WRITE, file_pass)
	f.store_string(var2str(this))
	f.close()
	
func load_settings():
	var f = File.new()
	if f.file_exists(settings_file):
		f.open_encrypted_with_pass(settings_file, File.READ, file_pass)
		if f.get_as_text() == '':
			return null
		print(f.get_path_absolute())
		var this = str2var(f.get_as_text())
		enable_sound = this['enable_sound']
		enable_music = this['enable_music']
		f.close()

