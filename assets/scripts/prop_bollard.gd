extends StaticBody3D

func _ready() -> void:
	# Bollard: short post for vehicle control
	var height := 0.6
	var diameter := 0.15
	
	# Bollard post
	var post_mesh := CylinderMesh.new()
	post_mesh.top_radius := diameter
	post_mesh.bottom_radius := diameter
	post_mesh.height := height
	post_mesh.radial_segments := 6
	
	var post_instance := MeshInstance3D.new()
	post_instance.mesh := post_mesh
	post_instance.name := "BollardPost"
	post_instance.position := Vector3(0, height * 0.5, 0)
	post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(post_instance)
	
	# Reflective strip
	var strip_mesh := BoxMesh.new()
	strip_mesh.size := Vector3(diameter * 2, 0.03, 0.03)
	
	var strip_instance := MeshInstance3D.new()
	strip_instance.mesh := strip_mesh
	strip_instance.name := "BollardReflectiveStrip"
	strip_instance.position := Vector3(0, height - 0.05, 0)
	strip_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(strip_instance)
	
	var collision := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius := diameter
	shape.height := height
	collision.shape := shape
	collision.position := Vector3(0, height * 0.5, 0)
	add_child(collision)