extends Node

onready var viewport1 = $Viewports/ViewportContainer_1/Viewport_1
onready var viewport2 = $Viewports/ViewportContainer_2/Viewport_2
onready var camera1   = $Viewports/ViewportContainer_1/Viewport_1/Camera2D
onready var camera2   = $Viewports/ViewportContainer_2/Viewport_2/Camera2D
onready var canvasmod1 = $Viewports/ViewportContainer_1/Viewport_1/CanvasModulate
onready var canvasmod2 = $Viewports/ViewportContainer_2/Viewport_2/CanvasModulate
onready var world     = $Viewports/ViewportContainer_1/Viewport_1/World

onready var hotbar_1  = $Hotbar_1
onready var hotbar_2  = $Hotbar_2

onready var backpack_1  = $Backpack_1
onready var backpack_2  = $Backpack_2

func setup_hud():
	match global.game_mode:
		global.GAME_MODES.GM_SINGLEPLAYER:
			# hotbar
			hotbar_1.rect_position.x = (global.screen_x / 2) - 		\
				((hotbar_1.rect_size.x*global.hud_scale_x) / 2)
			hotbar_1.rect_position.y = global.screen_y - 			\
				hotbar_1.rect_size.y*global.hud_scale_y
			hotbar_1.rect_scale.x = global.hud_scale_x
			hotbar_1.rect_scale.y = global.hud_scale_y
			
			global.hotbar1_node = hotbar_1
			global.hotbar2_node = null
			
			# backpack
			backpack_1.rect_position.x = (global.screen_x / 2) - 		\
				((backpack_1.rect_size.x*global.hud_scale_x) / 2)
			backpack_1.rect_position.y = (global.screen_y / 8)
			backpack_1.rect_scale.x = global.hud_scale_x
			backpack_1.rect_scale.y = global.hud_scale_y
			
			global.backpack1_node = backpack_1
			global.backpack2_node = null
		global.GAME_MODES.GM_LOCALCOOP:
			# hotbar
			hotbar_1.rect_position.x = (global.screen_x / 4) - 		\
				((hotbar_1.rect_size.x*global.hud_scale_x) / 2)
			hotbar_1.rect_position.y = global.screen_y - 			\
				hotbar_1.rect_size.y*global.hud_scale_y
			hotbar_1.rect_scale.x = global.hud_scale_x
			hotbar_1.rect_scale.y = global.hud_scale_y
			
			hotbar_2.rect_position.x = 3*(global.screen_x / 4) - 	\
				((hotbar_2.rect_size.x*global.hud_scale_x) / 2)
			hotbar_2.rect_position.y = global.screen_y - 			\
				hotbar_2.rect_size.y*global.hud_scale_y
			hotbar_2.rect_scale.x = global.hud_scale_x
			hotbar_2.rect_scale.y = global.hud_scale_y
			
			global.hotbar1_node = hotbar_1
			global.hotbar2_node = hotbar_2
			
			# backpack
			backpack_1.rect_position.x = (global.screen_x / 4) - 	\
				((backpack_1.rect_size.x*global.hud_scale_x) / 2)
			backpack_1.rect_position.y = (global.screen_y / 8)
			backpack_1.rect_scale.x = global.hud_scale_x
			backpack_1.rect_scale.y = global.hud_scale_y

			backpack_2.rect_position.x = (global.screen_x / 2)+((global.screen_x / 2)-(backpack_2.rect_size.x*global.hud_scale_x))/2
			backpack_2.rect_position.x = 3*(global.screen_x / 4) - 	\
				((backpack_2.rect_size.x*global.hud_scale_x) / 2)
			backpack_2.rect_position.y = (global.screen_y / 8)
			backpack_2.rect_scale.x = global.hud_scale_x
			backpack_2.rect_scale.y = global.hud_scale_y
			
			global.backpack1_node = backpack_1
			global.backpack2_node = backpack_2
			
func setup_camera_and_viewport():
	viewport2.world_2d = viewport1.world_2d
	
	match global.game_mode:
		global.GAME_MODES.GM_SINGLEPLAYER:
			$Viewports/ViewportContainer_2.visible = false
			camera1.set_target(1, global.player1_node)
			camera2.set_target(2, null)
			
			global.player2_node.queue_free()
		global.GAME_MODES.GM_LOCALCOOP:
			$Viewports/ViewportContainer_2.visible = true
			camera1.set_target(1, global.player1_node)
			camera2.set_target(2, global.player2_node)
	
func give_initial_stuff():
	for hotbar in [hotbar_1, hotbar_2]:
		hotbar.add_item_to_slot(1, items._Item.new(items.ITEM_WEAPON_SHOTGUN))
		hotbar.add_item_to_slot(2, items._Item.new(items.ITEM_TOOL_TORCH))
		hotbar.add_item_to_slot(3, items._Item.new(items.ITEM_BLOCK_WOOD))
		#hotbar.add_item_to_slot(2, items.ITEM_TOOL_IRONPICKAXE)
		hotbar.select_slot(1)
		
	for backpack in [backpack_1, backpack_2]:
		backpack.get_inventory().add_item_to_slot(1, items._Item.new(items.ITEM_TOOL_IRONPICKAXE))
		backpack.get_inventory().add_item_to_slot(2, items._Item.new(items.ITEM_STONE))
		backpack.get_inventory().add_item_to_slot(15, items._Item.new(items.ITEM_WEAPON_SHOTGUN))
		backpack.get_inventory().select_slot(1)
		

func _physics_process(delta):
	pass

func set_camera_limits():
	var map_limits = world.get_used_rect()
	var map_cellsize = world.cell_size

	for cam in [camera1, camera2]:
		cam.limit_left = map_limits.position.x * map_cellsize.x
		cam.limit_right = map_limits.end.x * map_cellsize.x
		cam.limit_top = 0
		cam.limit_bottom = 1280
		cam.set_zoom(Vector2(global.camera_zoom_x,global.camera_zoom_y))

func _on_music_finished():
	$music.play()
	
func _init():
	# if scene was reloaded
	global.root_node 	= null
	global.world_node 	= null
	global.player1_node = null
	global.player2_node = null
	global.hotbar1_node = null
	global.hotbar2_node = null
	global.backpack1_node = null
	global.backpack2_node = null

func _ready():
	global.root_node = self
	global.player1_node = world.get_node("player_1")
	global.player2_node = world.get_node("player_2")
	
	# init game
	setup_camera_and_viewport()
	set_camera_limits()
	setup_hud()
	give_initial_stuff()
