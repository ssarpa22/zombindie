extends StaticBody3D

var game_session: Node
var _elapsed := 0.0
var _body_visual: MeshInstance3D

func configure(session: Node, spawn_position: Vector3) -> void:
	game_session = session
	position = spawn_position

func _ready() -> void:
	add_to_group("interactables")
	_body_visual = MeshInstance3D.new()
	var body_mesh := CapsuleMesh.new()
	body_mesh.radius = 0.36
	body_mesh.height = 1.55
	_body_visual.mesh = body_mesh
	_body_visual.position.y = 0.85
	var clothes := StandardMaterial3D.new()
	clothes.albedo_color = Color(0.23, 0.28, 0.25)
	clothes.roughness = 1.0
	_body_visual.material_override = clothes
	add_child(_body_visual)
	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.36
	capsule.height = 1.65
	collision.shape = capsule
	collision.position.y = 0.83
	add_child(collision)
	var head := MeshInstance3D.new()
	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.22
	head_mesh.height = 0.44
	head.mesh = head_mesh
	head.position.y = 1.72
	head.material_override = clothes
	add_child(head)

func _process(delta: float) -> void:
	_elapsed += delta
	if is_instance_valid(_body_visual):
		_body_visual.rotation.y = sin(_elapsed * 0.4) * 0.08

func interact(_actor: Node = null) -> void:
	game_session.trade_with_survivor()
