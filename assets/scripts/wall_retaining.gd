extends StaticBody3D

const MESH_SIZE := Vector3(1.0, 4.0, 0.2) # Retaining wall: 1m wide, 4m tall, 0.2m deep

func _ready() -> void:
	var mesh := BoxMesh.new()
	mesh.size = MESH_SIZE
	mesh.depth_segments = 1
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "RetainingWallMesh"
	mesh_instance.position = Vector3(0, 2.0, 0) # Pivot at middle height
	add_child(mesh_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = MESH_SIZE
	collision.shape = shape
	collision.position = Vector3(0, 2.0, 0)
	add_child(collision)