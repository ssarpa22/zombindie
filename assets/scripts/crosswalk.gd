extends StaticBody3D

func _ready() -> void:
	# Crosswalk: pedestrian crossing area
	var crosswalk_length := 3.0
	var crosswalk_width := 2.0
	var stripe_width := 0.1
	
	var mesh := BoxMesh.new()
	mesh.size := Vector3(crosswalk_length, 0.05, crosswalk_width)
	
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh := mesh
	mesh_instance.name := "Crosswalk"
	mesh_instance.position := Vector3(crosswalk_length * 0.5, 0.025, 0)
	
	var material := StandardMaterial3D.new()
	material.albedo_color := Color(1.0, 1.0, 1.0)
	material.roughness := 0.8
	mesh_instance.material_override := material
	add_child(mesh_instance)
	
# Stripe lines (alternating white)
for i in range(6):
	var stripe_mesh := BoxMesh.new()
	stripe_mesh.size := Vector3(crosswalk_length, 0.05, stripe_width)
	
	var stripe_instance := MeshInstance3D.new()
	stripe_instance.mesh := stripe_mesh
	stripe_instance.name := "CrosswalkStripe_%d" % i
	stripe_instance.position := Vector3(crosswalk_length * 0.5, 0.025 + i * 0.07, stripe_width * 0.5 * (1 if i % 2 == 0 else -1))
	stripe_instance.material_override := material
	add_child(stripe_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(crosswalk_length, 0.1, crosswalk_width + 0.2)
	collision.shape := shape
	collision.position := Vector3(crosswalk_length * 0.5, 0.05, crosswalk_width * 0.5)
	add_child(collision)