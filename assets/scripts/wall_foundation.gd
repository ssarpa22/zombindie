extends StaticBody3D

const MESH_SIZE := Vector3(1.0, 0.5, 0.1) # Foundation wall: 1m wide, 0.5m tall

func _ready() -> void:
	var mesh := BoxMesh.new()
	mesh.size = MESH_SIZE
	mesh.depth_segments = 1
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "FoundationMesh"
	mesh_instance.position = Vector3(0, 0.25, 0) # Pivot at middle
	add_child(mesh_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = MESH_SIZE
	collision.shape = shape
	collision.position = Vector3(0, 0.25, 0)
	add_child(collision)