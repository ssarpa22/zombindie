extends StaticBody3D

func _ready() -> void:
	# Wood Crate: standard shipping crate
	var crate_length := 0.8
	var crate_width := 0.6
	var crate_height := 0.6
	
	var mesh := BoxMesh.new()
	mesh.size := Vector3(crate_length, crate_height, crate_width)
	
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh := mesh
	mesh_instance.name := "CrateBody"
	mesh_instance.position := Vector3(crate_length * 0.5, crate_height * 0.5, 0)
	
	# Wood color with strap variation
	var material := StandardMaterial3D.new()
	material.albedo_color := Color(0.4, 0.25, 0.15)
	material.roughness := 0.8
	mesh_instance.material_override := material
	add_child(mesh_instance)
	
# Wood strap bands
for i in range(4):
	var strap_mesh := BoxMesh.new()
	strap_mesh.size := Vector3(crate_length * 0.1, 0.03, crate_width * 0.6)
	
	var strap_instance := MeshInstance3D.new()
	strap_instance.mesh := strap_mesh
	strap_instance.name := "CrateStrap%d" % i
	strap_instance.position := Vector3(0, crate_height * 0.3 + i * 0.15, 0)
	strap_instance.material_override := material
	add_child(strap_instance)

# Top planks variation
for i in range(3):
	var plank_mesh := BoxMesh.new()
	plank_mesh.size := Vector3(crate_length * 0.25, 0.03, crate_width * 0.45)
	
	var plank_instance := MeshInstance3D.new()
	plank_instance.mesh := plank_mesh
	plank_instance.name := "CratePlank%d" % i
	plank_instance.position := Vector3(0, crate_height * 0.6 + i * 0.05, 0)
	plank_instance.material_override := material
	add_child(plank_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(crate_length, crate_height, crate_width)
collision.shape := shape
collision.position := Vector3(crate_length * 0.5, crate_height * 0.5, 0)
add_child(collision)