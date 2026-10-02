class_name Arrow
extends Node2D

@export var scale_mod: float = 1

var SPEEDX = 1
var SPEEDY = 1500
var SPEEDZ = 1

var flying = false
var startY: float
var startX: float
var startA: float
const STARTY = 500
var y = STARTY
var x = 0
var s = 1
var dy
var dx
var z = 1
var dz = 1

func _process(delta: float) -> void:
	if not flying:
		global_scale = Vector2(s * scale_mod, s * scale_mod)
		return
	z_index = 52 - clamp(z * 4, 4, 48)
	z += SPEEDZ * delta * dz
	s = 1 / pow(z, 1.5)
	global_scale = Vector2(s, s)
	dy -= SPEEDY * delta
	y = max(0, y + dy * delta)
	x += dx * SPEEDX * delta
	if startX > 0:
		startX = max(0, startX - delta * startX * 5)
	if startX < 0:
		startX = min(0, startX + delta * startX * 5)
	var ny = startY - y + STARTY
	global_position = Vector2(startX + x / z, (ny + 100) / z - 100)
	global_rotation = min(startA, clampf(dy, -1000, 1000) / 1000 * 90 * PI / 180)
	if y <= 0:
		#print(z)
		flying = false
		$AnimationPlayer.play("vanish")

func piu(target: Vector2, power: float) -> void:
	#print(target)
	#power = 0.1
	flying = true
	dy = 1000 * (1 - (clampf(target.y, -300, 200) + 300) / 500) * (0.8 + power * 1.5)
	dx = (clampf(target.x, -400, 400) / 400 * 300) * (0.8 + power * 1.5)
	startX = global_position.x
	startY = global_position.y
	startA = global_rotation
	dz = 1 + power * 1.5
	z_index = 2


func _on_timer_timeout() -> void:
	queue_free() 
