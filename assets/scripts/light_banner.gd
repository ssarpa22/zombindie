extends StaticBody3D

func _ready() -> void:
	# Light banner: advertising banner with backlight
	var banner_width := 2.0
	var banner_height := 0.5
	var depth := 0.05
	
# Banner board
var board_mesh := BoxMesh.new()
board_mesh.size := Vector3(banner_width, banner_height, depth)

var board_instance := MeshInstance3D.new()
board_instance.mesh := board_mesh
board_instance.name := "BannerBoard"
board_instance.position := Vector3(banner_width * 0.5, banner_height * 0.5, 0)
board_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(board_instance)

# Back lighting (emissive)
var light_mesh := BoxMesh.new()
light_mesh.size := Vector3(banner_width, banner_height, depth)

var light_instance := MeshInstance3D.new()
light_instance.mesh := light_mesh
light_instance.name := "BannerBacklight"
light_instance.position := Vector3(banner_width * 0.5, banner_height * 0.5, depth * 0.5 + 0.001)
light_instance.material_override := StandardMaterial3D.new()
light_instance.material_override.emission_enabled := true
light_instance.material_override.emission := Color(0.9, 0.7, 0.3)
light_instance.material_override.emission_energy_multiplier := 1.5
add_child(light_instance)

# Banner frame
for side in [-1, 1]:
	var frame_mesh := BoxMesh.new()
	frame_mesh.size := Vector3(0.1, banner_height, depth)

	var frame_instance := MeshInstance3D.new()
	frame_instance.mesh := frame_mesh
	frame_instance.name := "BannerFrame_%d" % (side == -1 and 1 or 2)
	frame_instance.position := Vector3(side * banner_width * 0.5, banner_height * 0.5, depth * 0.5 + 0.001)
	frame_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(frame_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(banner_width, banner_height, depth + 0.1)
collision.shape := shape
collision.position := Vector3(banner_width * 0.5, banner_height * 0.5, depth * 0.5)
add_child(collision)