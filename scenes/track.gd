extends Node2D

func _ready() -> void:
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer2.play()

var paused = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var is_mouse_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	var is_touch = event is InputEventScreenTouch and event.pressed
	if is_mouse_click or is_touch:
		paused = !paused
		$Area2D/Cross.visible = paused
		$AudioStreamPlayer.stream_paused = paused
		$AudioStreamPlayer2.stream_paused = paused
