extends StaticBody3D

func _ready() -> void:
	# Street lamp head: the upper part of a street lamp
	var fixture_height := 0.5
	var fixture_width := 0.3
	
# Mounting bracket
var bracket_mesh := BoxMesh.new()
bracket_mesh.size := Vector3(0.08, 0.08, fixture_height)

var bracket_instance := MeshInstance3D.new()
bracket_instance.mesh := bracket_mesh
bracket_instance.name := "StreetLampBracket"
bracket_instance.position := Vector3(0, fixture_height * 0.5, 0)
bracket_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(bracket_instance)

# Lamp arm
var arm_mesh := BoxMesh.new()
arm_mesh.size := Vector3(fixture_width, 0.05, 0.05)

var arm_instance := MeshInstance3D.new()
arm_instance.mesh := arm_mesh
arm_instance.name := "StreetLampArm"
arm_instance.position := Vector3(fixture_width * 0.5, fixture_height, 0)
arm_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(arm_instance)

# Lamp shade
var shade_mesh := SphereMesh.new()
shade_mesh.radius := fixture_width * 0.6

var shade_instance := MeshInstance3D.new()
shade_instance.mesh := shade_mesh
shade_instance.name := "StreetLampShade"
shade_instance.position := Vector3(fixture_width, fixture_height + 0.1, 0)
shade_instance.material_override := preload("res://assets/materials/palettes.glass_tres")
add_child(shade_instance)

# Emission light
var mat := StandardMaterial3D.new()
mat.emission_enabled := true
mat.emission := Color(0.7, 0.7, 0.8)
mat.emission_energy_multiplier := 1.2
shade_instance.material_override := mat

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(fixture_width, fixture_height * 2, fixture_width)
collision.shape := shape
collision.position := Vector3(fixture_width * 0.5, fixture_height, 0)
add_child(collision)