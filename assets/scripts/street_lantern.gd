extends StaticBody3D

func _ready() -> void:
	# Street lantern: decorative pole-mounted lantern
	var pole_height := 3.0
	var lantern_width := 0.4
	
# Pole
var pole_mesh := CylinderMesh.new()
pole_mesh.top_radius := 0.1
pole_mesh.bottom_radius := 0.1
pole_mesh.height := pole_height
pole_mesh.radial_segments := 8

var pole_instance := MeshInstance3D.new()
pole_instance.mesh := pole_mesh
pole_instance.name := "LanternPole"
pole_instance.position := Vector3(0, pole_height * 0.5, 0)
pole_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(pole_instance)

# Lantern body
var body_mesh := BoxMesh.new()
body_mesh.size := Vector3(lantern_width, lantern_width, lantern_width * 1.5)

var body_instance := MeshInstance3D.new()
body_instance.mesh := body_mesh
body_instance.name := "LanternBody"
body_instance.position := Vector3(0, pole_height - lantern_width * 0.75, 0)
body_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(body_instance)

# Glass panels
for i in range(4):
	var glass_mesh := BoxMesh.new()
	glass_mesh.size := Vector3(lantern_width * 0.3, lantern_width * 0.3, 0.02)
	
	var glass_instance := MeshInstance3D.new()
	glass_instance.mesh := glass_mesh
	glass_instance.name := "LanGlass_%d" % i
	angle := i * PI / 2.0
	glass_instance.position := Vector3(
		sin(angle) * lantern_width * 0.4,
		pole_height - lantern_width * 0.75,
		cos(angle) * lantern_width * 0.4
	)
	glass_instance.material_override := preload("res://assets/materials/palettes.glass_tres")
	add_child(glass_instance)

# Top finial
var finial_mesh := SphereMesh.new()
finial_mesh.radius := lantern_width * 0.1

var finial_instance := MeshInstance3D.new()
finial_instance.mesh := finial_mesh
finial_instance.name := "LanternFinial"
finial_instance.position := Vector3(0, pole_height, 0)
finial_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(finial_instance)

var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := 0.1
shape.height := pole_height
collision.shape := shape
collision.position := Vector3(0, pole_height * 0.5, 0)
add_child(collision)