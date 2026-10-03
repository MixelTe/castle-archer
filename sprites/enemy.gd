extends Area2D

signal killed
signal reached
@export var scale_mod: float = 1

const SPEEDZ = 0.5
const SPEEDY = 0

var alive = true
var x = 0
var y = 470
var z = 12

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	x = randf_range(-400, 400)
	draw()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	draw()
	if alive:
		z = max(0.4, z - SPEEDZ * delta)
		if z <= 0.4:
			alive = false
			reached.emit()
			$AudioYewyew.pitch_scale = randf_range(0.8, 1.2)
			$AudioYewyew.play()
			$AnimationPlayer.play("vanish")

func draw():
	z_index = 50 - clamp(z * 4, 4, 48)
	var s = 1 / z
	global_scale = Vector2(s, s * scale_mod)
	global_position = Vector2(x / z, (y + 100) / z - 100)


func _on_body_entered(body: Node2D) -> void:
	if alive and body is Arrow:
		if abs(body.z - z) > 0.5:
			return
		body.queue_free()
		alive = false
		killed.emit()
		$AudioBew.pitch_scale = randf_range(0.8, 1.2)
		$AudioBew.play()
		$AnimationPlayer.play("vanish")
