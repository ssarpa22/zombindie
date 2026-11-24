extends StaticBody3D

func _ready() -> void:
	# Downpipe: vertical gutter for rainwater
	var height := 6.0
	var pipe_radius := 0.15
	
	# Cylinder-like pipe using scaled box mesh
	var mesh := BoxMesh.new()
	mesh.size = Vector3(pipe_radius * 2, height, pipe_radius * 2)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "DownpipeMesh"
	mesh_instance.position = Vector3(0, height * 0.5, 0)
	add_child(mesh_instance)
	
	# Pipe segments visual (rings)
	for i in range(6):
		var ring_mesh := BoxMesh.new()
		ring_mesh.size = Vector3(pipe_radius * 2.2, 0.05, pipe_radius * 2.2)
		var ring_instance = MeshInstance3D.new()
		ring_instance.mesh = ring_mesh
		ring_instance.name = "DownpipeRing%d" % i
		ring_instance.position = Vector3(0, i * height / 5.0 + height * 0.1, 0)
		ring_instance.material_override = preload("res://assets/materials/palettes.asphalt_tres")
		add_child(ring_instance)
	
	var collision := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius := pipe_radius
	shape.height := height
	collision.shape = shape
	collision.position = Vector3(0, height * 0.5, 0)
	add_child(collision)