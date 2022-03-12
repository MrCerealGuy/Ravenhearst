extends Node

const DEBUG=false

enum GAME_MODES {GM_SINGLEPLAYER, GM_LOCALCOOP}
var game_mode = GAME_MODES.GM_SINGLEPLAYER

const GAME_SCENE_PATH="res://Ravenhearst.tscn"
const MAINMENU_SCENE_PATH="res://assets/menu/MainMenu.tscn"

const screen_x = 1024
const screen_y = 576

const camera_zoom_x = 1.7
const camera_zoom_y = 1.7
const hud_scale_x = 1/1.7
const hud_scale_y = 1/1.7

var root_node = null
var world_node = null
var world_cells_x = 0
var world_cells_y = 0

var player1_node = null
var player2_node = null

var backpack1_node = null
var backpack2_node = null

var hotbar1_node = null
var hotbar2_node = null

func get_player_node(id):
	match id:
		1:
			return player1_node
		2:
			return player2_node
	return -1

func _ready():
	OS.window_size = Vector2(1024, 576)
	OS.window_fullscreen = true
	
	if DEBUG:
		logger._filename = 'user://log.txt'
		logger.print_stdout = false
	
