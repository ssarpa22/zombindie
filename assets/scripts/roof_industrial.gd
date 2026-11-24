extends StaticBody3D

func _ready() -> void:
	# Corrugated industrial roof: large sheet, ribbed texture
	var mesh := BoxMesh.new()
	mesh.size = Vector3(6.0, 0.3, 4.0)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "IndustrialRoofMesh"
	mesh_instance.position = Vector3(0, 0.15, 0)
	add_child(mesh_instance)
	
	# Corrugation ribs (visual)
	for i in range(5):
		rib_mesh := BoxMesh.new()
		rib_mesh.size = Vector3(6.0, 0.05, 4.0)
		rib_instance := MeshInstance3D.new()
		rib_instance.mesh = rib_mesh
		rib_instance.name = "CorrugationRib%d" % i
		rib_instance.position = Vector3(0, 0.2 + i * 0.1, 0)
		rib_instance.material_override = preload("res://assets/materials/palettes/asphalt_tres")
		add_child(rib_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(6.0, 0.3, 4.0)
	collision.shape = shape
	collision.position = Vector3(0, 0.15, 0)
	add_child(collision)