extends StaticBody3D

var game_session: Node
var document_title := "Registro"
var document_text := ""
var accent := Color(0.58, 0.53, 0.39)

func configure(session: Node, title: String, content: String, tint: Color = Color(0.58, 0.53, 0.39)) -> void:
	game_session = session
	document_title = title
	document_text = content
	accent = tint

func _ready() -> void:
	add_to_group("interactables")
	var paper := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(0.38, 0.035, 0.28)
	paper.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = accent
	material.roughness = 1.0
	paper.material_override = material
	add_child(paper)
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(0.55, 0.25, 0.45)
	shape.shape = box
	add_child(shape)

func interact(_actor: Node = null) -> void:
	if is_instance_valid(game_session):
		game_session.read_document(name, document_title, document_text)
