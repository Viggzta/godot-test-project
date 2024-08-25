extends Camera2D

class_name FollowCamera

var followPoints: Array[CameraFollowPoint]

func add_follow_point(p: CameraFollowPoint) -> void:
	followPoints.append(p)

func _process(_delta: float) -> void:
	position = _get_center_point()

func _get_center_point() -> Vector2:
	var c: int = len(followPoints)
	if c == 0:
		return Vector2.ZERO
	if c == 1:
		return followPoints[0].global_position

	var temp: Vector2 = Vector2.ZERO
	for p: CameraFollowPoint in followPoints:
		temp += p.global_position * p.weight

	return temp / c
