extends KinematicBody2D

var Global = load("scripts/Global.gd")
var PlayerClass = load("scripts/Player.gd")
var parent_player = PlayerClass.new(500)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("instance_camera").make_current()
	set_fixed_process(true)

func _fixed_process(delta):
	# determine if must move
	var up = Input.is_action_pressed("game_up")
	var down = Input.is_action_pressed("game_down")
	var left = Input.is_action_pressed("game_left")
	var right = Input.is_action_pressed("game_right")
	
	var dpos = [0,0]
	# diagonals
	if (up && left): dpos = calculate_movement(delta, Global.NORTHWEST)
	elif (up && right): dpos = calculate_movement(delta, Global.NORTHEAST)
	elif (down && left): dpos = calculate_movement(delta, Global.SOUTHWEST)
	elif (down && right): dpos = calculate_movement(delta, Global.SOUTHEAST)
	
	# cancel out
	elif (down && up): dpos = [0, 0]
	elif (left && right): dpos = [0, 0]
	
	# cardinals
	elif (up): dpos = calculate_movement(delta, Global.NORTH)
	elif (down): dpos = calculate_movement(delta, Global.SOUTH)
	elif (left): dpos = calculate_movement(delta, Global.WEST)
	elif (right): dpos = calculate_movement(delta, Global.EAST)

	# make it move!
	var movement = Vector2(dpos[0], dpos[1])
	move(movement)
	
	# fix sticking to walls issue
	if (is_colliding()):
		var collision_normal = get_collision_normal()
		movement = collision_normal.slide(movement)
		move(movement)

func calculate_movement(delta, direction):
	# Calculate cardinal distance and diaganol distance
	var distance = delta * parent_player.speed
	var distanceroot = delta * sqrt((parent_player.speed*parent_player.speed/2))
	
	var dy = 0
	var dx = 0
	
	# determine distance changes
	if (direction == 0):
		dy = -distance
	elif (direction == 1):
		dy = -distanceroot
		dx = distanceroot
	elif (direction == 2):
		dx = distance
	elif (direction == 3):
		dy = distanceroot
		dx = distanceroot
	elif (direction == 4):
		dy = distance
	elif (direction == 5):
		dy = distanceroot
		dx = -distanceroot
	elif (direction == 6):
		dx = -distance
	elif (direction == 7):
		dy = -distanceroot
		dx = -distanceroot
	
	return [dx, dy]
	