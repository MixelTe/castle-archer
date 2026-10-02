extends Line2D

func _process(delta: float):
	var path = get_parent() as Path2D
	points.clear()
	if path:
		points = path.curve.get_baked_points()
