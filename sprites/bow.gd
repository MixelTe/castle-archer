extends Node2D

@export var arrow_scene: PackedScene
@export var arrows: Node2D

const SPEED = 2;

var power = 0;
var powering = false
var arrow: Variant;
var stringPoints = [];

func _ready() -> void:
	arrow = arrow_scene.instantiate();
	arrows.add_child(arrow)
	for i in 3:
		stringPoints.append($String.curve.get_point_position(i))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target = get_global_mouse_position()
	target = Vector2(clampf(target.x, -400, 400), clampf(target.y, -300, 200))
	var angle_to_mouse = target.angle_to_point(global_position)
	global_rotation = angle_to_mouse - (30 * PI / 180)
	if arrow != null:
		arrow.global_position = $ArrowHolder.global_position
		arrow.global_rotation = global_rotation + (30 * PI / 180)
	if powering:
		power = min(power + SPEED * delta, 1)
		$Image.scale = Vector2(1.0 + (0.1 * power), 1.0 - (0.2 * power))
		var d = power * 100
		if arrow != null:
			arrow.global_position += Vector2(cos(arrow.global_rotation) * d, sin(arrow.global_rotation) * d)
		var angle = global_rotation - (20 * PI / 180)
		d = power * 55
		$String.curve.set_point_position(0, stringPoints[0] - Vector2(cos(angle) * d, sin(angle) * d))
		angle = global_rotation - (110 * PI / 180)
		$String.curve.set_point_position(1, stringPoints[1] - Vector2(cos(angle) * d, sin(angle) * d))
		angle = global_rotation - (70 * PI / 180)
		$String.curve.set_point_position(2, stringPoints[2] + Vector2(cos(angle) * d, sin(angle) * d))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()
	if event.is_action_pressed("shoot"):
		powering = true
	if powering && event.is_action_released("shoot"):
		powering = false
		var p = power
		power = 0
		$Image.scale = Vector2(1.0, 1.0)
		for i in 3:
			$String.curve.set_point_position(i, stringPoints[i])
		if arrow == null:
			return
		arrow.piu(get_global_mouse_position(), p)
		arrow = null
		$Timer.start()
		

func _on_timer_timeout() -> void:
	arrow = arrow_scene.instantiate();
	arrow.global_position = $ArrowHolder.global_position
	arrow.global_rotation = global_rotation + (30 * PI / 180)
	var d = power * 100
	arrow.global_position += Vector2(cos(arrow.global_rotation) * d, sin(arrow.global_rotation) * d)
	arrows.add_child(arrow)
