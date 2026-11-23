extends AnimatableBody3D

@export var swing_angle_degrees := 96.0

var _is_open := false
var _motion: Tween
var _closed_quaternion := Quaternion.IDENTITY

func _ready() -> void:
	_closed_quaternion = quaternion

func interact(_actor: Node = null) -> void:
	if _motion != null and _motion.is_running():
		return
	_is_open = not _is_open
	var target_quaternion := _closed_quaternion
	if _is_open:
		target_quaternion = _closed_quaternion * Quaternion(Vector3.UP, deg_to_rad(swing_angle_degrees))
	_motion = create_tween()
	_motion.set_trans(Tween.TRANS_SINE)
	_motion.set_ease(Tween.EASE_IN_OUT)
	_motion.tween_property(self, "quaternion", target_quaternion, 0.42)
