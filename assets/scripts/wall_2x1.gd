extends StaticBody3D

const MESH_SIZE := Vector3(2.0, 3.0, 0.1) # 2m wide, 3m tall, 0.1m deep

func _ready() -> void:
	var mesh := BoxMesh.new()
	mesh.size = MESH_SIZE
	mesh.depth_segments = 1
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "WallMesh"
	mesh_instance.position = Vector3(0, 1.5, 0)
	add_child(mesh_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = MESH_SIZE
	collision.shape = shape
	collision.position = Vector3(0, 1.5, 0)
	add_child(collision)