extends StaticBody3D

const MESH_SIZE := Vector3(1.0, 3.0, 1.0) # L-corner: 1m x 3m x 1m

func _ready() -> void:
	var mesh := BoxMesh.new()
	mesh.size = Vector3(MESH_SIZE.x, MESH_SIZE.y, MESH_SIZE.z)
	mesh.depth_segments = 1
	
	# Create two facing walls for the corner
	var mesh_instance1 = MeshInstance3D.new()
	mesh_instance1.mesh = mesh
	mesh_instance1.name = "CornerWall1"
	mesh_instance1.position = Vector3(0, 1.5, 0)
	mesh_instance1.rotation.y = 0.0
	add_child(mesh_instance1)
	
	var mesh_instance2 = MeshInstance3D.new()
	mesh_instance2.mesh = mesh
	mesh_instance2.name = "CornerWall2"
	mesh_instance2.position = Vector3(0, 1.5, 0)
	mesh_instance2.rotation.y = PI / 2.0
	add_child(mesh_instance2)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(MESH_SIZE.x, MESH_SIZE.y, MESH_SIZE.z)
	collision.shape = shape
	collision.position = Vector3(0, 1.5, 0)
	add_child(collision)