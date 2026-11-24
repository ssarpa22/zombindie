extends StaticBody3D

func _ready() -> void:
	# Gurney/Stretcher: wheeled patient transport
	var gurney_length := 1.8
	var gurney_width := 0.6
	var gurney_height := 0.5
	
	# Main platform
	var platform_mesh := BoxMesh.new()
	platform_mesh.size := Vector3(gurney_length, gurney_height, gurney_width)
	
	var platform_instance := MeshInstance3D.new()
	platform_instance.mesh := platform_mesh
	platform_instance.name := "GurneyPlatform"
	platform_instance.position := Vector3(gurney_length * 0.5, gurney_height * 0.5, 0)
	
	# Dark material for mattress area
	var mat := StandardMaterial3D.new()
	mat.albedo_color := Color(0.2, 0.2, 0.15)
	mat.roughness := 0.8
	platform_instance.material_override := mat
	add_child(platform_instance)
	
# Head section (elevated)
var head_mesh := BoxMesh.new()
head_mesh.size := Vector3(gurney_length * 0.3, gurney_height * 0.3, gurney_width * 0.5)

var head_instance := MeshInstance3D.new()
head_instance.mesh := head_mesh
head_instance.name := "GurneyHead"
head_instance.position := Vector3(gurney_length * 0.15, gurney_height * 0.65, 0)
head_instance.material_override := StandardMaterial3D.new()
head_instance.material_override.albedo_color := Color(0.3, 0.3, 0.2)
head_instance.material_override.roughness := 0.8
add_child(head_instance)

# Foot section
var foot_mesh := BoxMesh.new()
foot_mesh.size := Vector3(gurney_length * 0.3, gurney_height * 0.3, gurney_width * 0.5)

var foot_instance := MeshInstance3D.new()
foot_instance.mesh := foot_mesh
foot_instance.name := "GurneyFoot"
foot_instance.position := Vector3(gurney_length * 0.85, gurney_height * 0.65, 0)
foot_instance.material_override := StandardMaterial3D.new()
foot_instance.material_override.albedo_color := Color(0.3, 0.3, 0.2)
foot_instance.material_override.roughness := 0.8
add_child(foot_instance)

# Leg straps (visual)
for side in [-1, 1]:
	var strap_mesh := BoxMesh.new()
	strap_mesh.size := Vector3(0.05, gurney_height * 0.8, 0.02)
	
	var strap_instance := MeshInstance3D.new()
	strap_instance.mesh := strap_mesh
	strap_instance.name := "GurneyStrap_%d" % (side == -1 and 1 or 2)
	strap_instance.position := Vector3(side * gurney_length * 0.4, gurney_height * 0.4, 0)
	strap_instance.material_override := StandardMaterial3D.new()
	strap_instance.material_override.albedo_color := Color(0.5, 0.5, 0.5)
	strap_instance.material_override.roughness := 0.8
	add_child(strap_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(gurney_length, gurney_height, gurney_width)
collision.shape := shape
collision.position := Vector3(gurney_length * 0.5, gurney_height * 0.5, 0)
add_child(collision)