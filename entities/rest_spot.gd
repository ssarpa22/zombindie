extends StaticBody3D

var game_session: Node
var prompt := "Descansar"
var _resting := false
var _cooldown := 0.0

func _process(delta: float) -> void:
	_cooldown = maxf(0.0, _cooldown - delta)

func configure(session: Node, interaction_name: String = "Descansar") -> void:
	game_session = session
	prompt = interaction_name

func _ready() -> void:
	add_to_group("interactables")
	var bench := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(1.8, 0.18, 0.55)
	bench.mesh = mesh
	bench.position.y = 0.58
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.22, 0.18, 0.13)
	material.roughness = 1.0
	bench.material_override = material
	add_child(bench)
	for x in [-0.7, 0.7]:
		var leg := MeshInstance3D.new()
		var leg_mesh := BoxMesh.new()
		leg_mesh.size = Vector3(0.12, 0.58, 0.12)
		leg.mesh = leg_mesh
		leg.position = Vector3(x, 0.29, 0)
		leg.material_override = material
		add_child(leg)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(2.0, 1.0, 0.8)
	collision.shape = shape
	collision.position.y = 0.5
	add_child(collision)

func interact(_actor: Node = null) -> void:
	if _resting or _cooldown > 0.0 or not is_instance_valid(game_session):
		return
	if game_session.player.is_sprinting():
		game_session.notify("No podés descansar mientras corrés.")
		return
	_resting = true
	game_session.rest_at(self)
	_cooldown = 30.0
	_resting = false
