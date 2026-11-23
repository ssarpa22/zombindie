extends AnimatableBody3D

@export var swing_angle_degrees := 96.0

var _closed_yaw := 0.0
var _is_open := false
var _motion: Tween

func _ready() -> void:
	_closed_yaw = rotation.y

func interact() -> void:
	if _motion != null and _motion.is_running():
		return
	_is_open = not _is_open
	var direction := 1.0 if _is_open else 0.0
	var target_yaw := _closed_yaw + deg_to_rad(swing_angle_degrees) * direction
	_motion = create_tween()
	_motion.set_trans(Tween.TRANS_SINE)
	_motion.set_ease(Tween.EASE_IN_OUT)
	_motion.tween_property(self, "rotation:y", target_yaw, 0.42)
