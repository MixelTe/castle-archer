extends Node2D

@export var enemy_scene: PackedScene
@export var enemies: Node2D

var dt = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn():
	var enemy = enemy_scene.instantiate();
	enemy.killed.connect(_on_enemy_killed)
	enemy.reached.connect(_on_enemy_reached)
	enemies.add_child(enemy)
	$Timer.start(randf_range(max(5 - dt, 0.5), max(10 - dt, 1)))
	dt += 0.1
	#$Timer.start(randf_range(0.1, 0.2))

func _on_timer_timeout() -> void:
	spawn()

var reached = 0
var killed = 0

func _on_enemy_killed() -> void:
	killed += 1
	updateLabel()

func _on_enemy_reached() -> void:
	reached += 1
	updateLabel()
	
func updateLabel():
	$Label.text = str(reached) + "/" + str(killed)

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	if event.is_action_pressed("reload"):
		if OS.has_feature("web"):
			JavaScriptBridge.eval("window.location.reload();")
		else:
			get_tree().reload_current_scene()
