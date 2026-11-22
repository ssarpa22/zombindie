extends Node3D

const PlayerScene = preload("res://player.tscn")

func _ready() -> void:
	_build_room()
	_build_lighting()
	var player = PlayerScene.instantiate()
	player.position = Vector3(0, 0, 4)
	add_child(player)
	_build_sign()

func _build_room() -> void:
	_add_box("Floor", Vector3(0, -0.15, 0), Vector3(10, 0.3, 14), Color(0.16, 0.18, 0.17))
	_add_box("Ceiling", Vector3(0, 3.2, 0), Vector3(10, 0.25, 14), Color(0.08, 0.09, 0.09))
	_add_box("BackWall", Vector3(0, 1.5, -7), Vector3(10, 3, 0.3), Color(0.23, 0.22, 0.19))
	_add_box("LeftWall", Vector3(-5, 1.5, 0), Vector3(0.3, 3, 14), Color(0.19, 0.20, 0.19))
	_add_box("RightWall", Vector3(5, 1.5, 0), Vector3(0.3, 3, 14), Color(0.19, 0.20, 0.19))
	_add_box("FrontWallLeft", Vector3(-3.4, 1.5, 7), Vector3(3.2, 3, 0.3), Color(0.23, 0.22, 0.19))
	_add_box("FrontWallRight", Vector3(3.4, 1.5, 7), Vector3(3.2, 3, 0.3), Color(0.23, 0.22, 0.19))
	_add_box("DoorLintel", Vector3(0, 2.65, 7), Vector3(3.6, 0.7, 0.3), Color(0.23, 0.22, 0.19))
	_add_box("Counter", Vector3(-2.2, 0.55, -2), Vector3(2.5, 1.1, 0.8), Color(0.24, 0.20, 0.15))
	_add_box("Gurney", Vector3(2.1, 0.65, -1.3), Vector3(1.2, 0.15, 2.5), Color(0.29, 0.31, 0.29))
	_add_box("Cabinet", Vector3(3.8, 1.0, -4.8), Vector3(1.2, 2.0, 0.6), Color(0.24, 0.22, 0.18))

func _build_lighting() -> void:
	var world = WorldEnvironment.new()
	var environment = Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.015, 0.019, 0.023)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.15, 0.18, 0.21)
	environment.ambient_light_energy = 0.32
	world.environment = environment
	add_child(world)
	var lamp = OmniLight3D.new()
	lamp.position = Vector3(0, 2.65, -2)
	lamp.light_color = Color(0.72, 0.78, 0.72)
	lamp.light_energy = 0.55
	lamp.omni_range = 7
	add_child(lamp)

func _build_sign() -> void:
	var label = Label3D.new()
	label.text = "CLINICA  |  SALIDA"
	label.position = Vector3(0, 2.35, 6.78)
	label.font_size = 36
	label.modulate = Color(0.72, 0.16, 0.12)
	label.pixel_size = 0.006
	add_child(label)

func _add_box(box_name: String, box_position: Vector3, box_size: Vector3, color: Color) -> void:
	var body = StaticBody3D.new()
	body.name = box_name
	body.position = box_position
	var mesh_instance = MeshInstance3D.new()
	var mesh = BoxMesh.new()
	mesh.size = box_size
	mesh_instance.mesh = mesh
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 1.0
	mesh_instance.material_override = material
	body.add_child(mesh_instance)
	var collision = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = box_size
	collision.shape = shape
	body.add_child(collision)
	add_child(body)

