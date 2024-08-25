extends Node2D

class_name CameraFollowPoint

@export var weight: float = 1.0

func _ready():
	var followCamera: FollowCamera = get_tree().get_root().get_node("Level").get_node("FollowCamera")
	
	if followCamera:
		followCamera.add_follow_point(self)
