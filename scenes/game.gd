extends Node2D

@export var enemy_scene: PackedScene
@export var enemies: Node2D

var dt = 0

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
	$Timer.start(randf_range(max(5 - dt, 0.2), max(10 - dt, 1)))
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
