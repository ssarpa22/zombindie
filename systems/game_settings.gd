extends Node

const SETTINGS_PATH := "user://zombindie_settings.cfg"
const DEFAULT_SENSITIVITY := 0.0022
const DISPLAY_DEFAULTS_VERSION := 1
const GRAPHICS_SETTINGS_VERSION := 3
const SHADOW_QUALITY_NAMES := ["Desactivadas", "Baja", "Media", "Alta"]
const MESH_QUALITY_NAMES := ["Baja", "Media", "Alta"]
const TEXTURE_QUALITY_NAMES := ["Baja", "Media", "Alta"]
const TEXTURE_FILTER_NAMES := ["Bilineal", "Trilineal", "Anisotrópico"]
const WEATHER_QUALITY_NAMES := ["Baja", "Media", "Alta"]
const FOLIAGE_QUALITY_NAMES := ["Baja", "Media", "Alta"]
const WINDOW_MODE_NAMES := ["Ventana", "Pantalla completa sin bordes", "Pantalla completa exclusiva"]
const VSYNC_MODE_NAMES := ["Desactivada", "Activada", "Adaptativa"]
const REBINDABLE_ACTIONS := ["move_forward", "move_back", "move_left", "move_right", "sprint", "jump", "interact", "flashlight", "inventory", "quest_journal", "world_map", "character_status", "quick_menu", "melee", "use_water", "use_food", "heal", "build", "save_game", "load_game", "weather_cycle", "weather_menu", "guide", "pause"]

var mouse_sensitivity := DEFAULT_SENSITIVITY
var invert_y := false
var master_volume := 0.8
var effects_volume := 0.8
var ambience_volume := 0.8
var windowed := true
var resolution_index := 2
var vsync_enabled := true
var window_mode := 0
var vsync_mode := 1
var shadow_quality := 1
var mesh_quality := 1
var texture_quality := 1
var texture_filter := 1
var weather_quality := 1
var foliage_quality := 1
var view_distance := 300.0
var shadow_distance := 68.0
var brightness := 1.0
var bloom_enabled := false
var anti_aliasing := 1
var ambient_occlusion_enabled := false
var render_scale := 1.0
var fps_limit := 0
var mode := "free"
var continue_requested := false
var _display_defaults_migrated := false
var _graphics_settings_migrated := false
var _graphics_confirmation_timer: Timer
var _pending_graphics_snapshot: Dictionary = {}

func _ready() -> void:
	_graphics_confirmation_timer = Timer.new()
	_graphics_confirmation_timer.one_shot = true
	_graphics_confirmation_timer.process_mode = Node.PROCESS_MODE_ALWAYS
	_graphics_confirmation_timer.timeout.connect(revert_graphics_confirmation)
	add_child(_graphics_confirmation_timer)
	_load_settings()
	_ensure_actions()
	_apply_settings()
	if _display_defaults_migrated or _graphics_settings_migrated:
		save_settings()

func _ensure_actions() -> void:
	_add_key_action("move_forward", KEY_W)
	_add_key_action("move_back", KEY_S)
	_add_key_action("move_left", KEY_A)
	_add_key_action("move_right", KEY_D)
	_add_key_action("sprint", KEY_SHIFT)
	_add_key_action("jump", KEY_SPACE)
	_add_key_action("interact", KEY_E)
	_add_key_action("flashlight", KEY_F)
	_add_key_action("noclip", KEY_V)
	_add_key_action("inventory", KEY_I)
	_add_key_action("quest_journal", KEY_Q)
	_add_key_action("world_map", KEY_M)
	_add_key_action("character_status", KEY_C)
	_add_key_action("quick_menu", KEY_TAB)
	_add_key_action("use_water", KEY_1)
	_add_key_action("use_food", KEY_2)
	_add_key_action("heal", KEY_H)
	_add_key_action("build", KEY_B)
	_add_key_action("save_game", KEY_F5)
	_add_key_action("load_game", KEY_F9)
	_add_key_action("weather_menu", KEY_F6)
	_add_key_action("weather_cycle", KEY_G)
	_add_key_action("guide", KEY_F1)
	_add_key_action("pause", KEY_ESCAPE)
	if not InputMap.has_action("melee"):
		InputMap.add_action("melee")
		var click := InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		InputMap.action_add_event("melee", click)
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) == OK:
		for action in REBINDABLE_ACTIONS:
			var saved_value: Variant = config.get_value("keybinds", action, {})
			if saved_value is Dictionary and InputMap.has_action(action):
				var saved_event: InputEvent
				if saved_value.get("kind", "key") == "mouse":
					var mouse_event := InputEventMouseButton.new()
					mouse_event.button_index = int(saved_value.get("code", MOUSE_BUTTON_LEFT))
					saved_event = mouse_event
				else:
					var key_event := InputEventKey.new()
					key_event.physical_keycode = int(saved_value.get("code", KEY_NONE))
					saved_event = key_event
				set_key_binding(action, saved_event)
			elif saved_value is int and int(saved_value) > 0 and InputMap.has_action(action):
				var saved_event := InputEventKey.new()
				saved_event.physical_keycode = int(saved_value)
				set_key_binding(action, saved_event)

func _add_key_action(action: String, key: Key) -> void:
	if InputMap.has_action(action):
		return
	InputMap.add_action(action)
	var event := InputEventKey.new()
	event.physical_keycode = key
	InputMap.action_add_event(action, event)

func _load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) != OK:
		return
	mouse_sensitivity = clampf(float(config.get_value("controls", "sensitivity", DEFAULT_SENSITIVITY)), 0.0005, 0.006)
	invert_y = bool(config.get_value("controls", "invert_y", false))
	master_volume = float(config.get_value("audio", "master", 0.8))
	effects_volume = float(config.get_value("audio", "effects", 0.8))
	ambience_volume = float(config.get_value("audio", "ambience", 0.8))
	windowed = bool(config.get_value("video", "windowed", true))
	window_mode = clampi(int(config.get_value("video", "window_mode", 0 if windowed else 1)), 0, 2)
	resolution_index = clampi(int(config.get_value("video", "resolution", 2)), 0, 2)
	vsync_enabled = bool(config.get_value("video", "vsync", true))
	vsync_mode = clampi(int(config.get_value("video", "vsync_mode", 1 if vsync_enabled else 0)), 0, 2)
	if is_compatibility_renderer() and vsync_mode == 2:
		vsync_mode = 1
	var graphics_version := int(config.get_value("graphics", "version", 1))
	var max_shadow_quality := SHADOW_QUALITY_NAMES.size() - 1 if graphics_version >= 2 else 2
	var saved_shadow_quality := clampi(int(config.get_value("graphics", "shadows", 1)), 0, max_shadow_quality)
	shadow_quality = 3 if graphics_version < 2 and saved_shadow_quality == 2 else saved_shadow_quality
	mesh_quality = clampi(int(config.get_value("graphics", "mesh_detail", 1)), 0, 2)
	texture_quality = clampi(int(config.get_value("graphics", "texture_quality", 1)), 0, 2)
	texture_filter = clampi(int(config.get_value("graphics", "texture_filter", 1)), 0, 2)
	weather_quality = clampi(int(config.get_value("graphics", "weather_quality", 1)), 0, 2)
	foliage_quality = clampi(int(config.get_value("graphics", "foliage_quality", 1)), 0, 2)
	view_distance = clampf(float(config.get_value("graphics", "view_distance", 300.0)), 50.0, 600.0)
	shadow_distance = clampf(float(config.get_value("graphics", "shadow_distance", 68.0)), 40.0, 300.0)
	brightness = clampf(float(config.get_value("graphics", "brightness", 1.0)), 0.6, 1.4)
	bloom_enabled = bool(config.get_value("graphics", "bloom", false))
	anti_aliasing = clampi(int(config.get_value("graphics", "anti_aliasing", 1)), 0, 2)
	ambient_occlusion_enabled = bool(config.get_value("graphics", "ambient_occlusion", false))
	render_scale = clampf(float(config.get_value("graphics", "render_scale", 1.0)), 0.5, 1.0)
	fps_limit = clampi(int(config.get_value("graphics", "fps_limit", 0)), 0, 3)
	_graphics_settings_migrated = graphics_version < GRAPHICS_SETTINGS_VERSION
	if int(config.get_value("video", "ui_defaults_version", 0)) < DISPLAY_DEFAULTS_VERSION:
		windowed = true
		window_mode = 0
		resolution_index = 2
		_display_defaults_migrated = true

func _apply_settings() -> void:
	_ensure_audio_buses()
	var bus := AudioServer.get_bus_index("Master")
	if bus >= 0:
		AudioServer.set_bus_volume_linear(bus, clampf(master_volume, 0.0, 1.0))
	_apply_display_settings()
	_set_bus_volume("Efectos", effects_volume)
	_set_bus_volume("Ambiente", ambience_volume)
	apply_graphics_settings()

func _apply_display_settings() -> void:
	var sizes := [Vector2i(1280, 720), Vector2i(1600, 900), Vector2i(1920, 1080)]
	match window_mode:
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		_:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(sizes[resolution_index])
	windowed = window_mode == 0
	if vsync_mode == 2 and not is_compatibility_renderer():
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
	elif vsync_mode > 0:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	vsync_enabled = vsync_mode > 0

func apply_graphics_settings() -> void:
	var atlas_sizes := [256, 256, 512, 2048]
	var viewport := get_viewport()
	if is_instance_valid(viewport):
		viewport.positional_shadow_atlas_size = atlas_sizes[shadow_quality]
		viewport.msaa_3d = [Viewport.MSAA_DISABLED, Viewport.MSAA_2X, Viewport.MSAA_4X][anti_aliasing]
		viewport.scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
		viewport.scaling_3d_scale = render_scale
		viewport.anisotropic_filtering_level = Viewport.ANISOTROPY_8X if texture_filter == 2 else Viewport.ANISOTROPY_DISABLED
	_apply_light_settings(get_tree().root)
	_apply_world_graphics(get_tree().root)
	Engine.max_fps = [0, 30, 60, 120][fps_limit]

func _apply_light_settings(node: Node) -> void:
	if node is Light3D:
		var light := node as Light3D
		if not light.has_meta("graphics_shadow_requested"):
			light.set_meta("graphics_shadow_requested", light.shadow_enabled)
		var low_quality_shadow := bool(light.get_meta("graphics_shadow_low_priority", light is DirectionalLight3D))
		light.shadow_enabled = shadow_quality > 0 and bool(light.get_meta("graphics_shadow_requested")) and (shadow_quality > 1 or low_quality_shadow)
		light.shadow_blur = 1.0 if shadow_quality == 3 else 0.0
		if light is DirectionalLight3D:
			var directional := light as DirectionalLight3D
			directional.directional_shadow_max_distance = shadow_distance
			match shadow_quality:
				2:
					directional.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_2_SPLITS
				3:
					directional.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_4_SPLITS
				_:
					directional.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
	for child in node.get_children():
		_apply_light_settings(child)

func _apply_world_graphics(node: Node) -> void:
	if node is WorldEnvironment and (node as WorldEnvironment).environment:
		var environment := (node as WorldEnvironment).environment
		environment.glow_enabled = bloom_enabled
		environment.ssao_enabled = ambient_occlusion_enabled and is_ambient_occlusion_supported()
		environment.adjustment_enabled = true
		environment.adjustment_brightness = brightness
	if node is Camera3D:
		(node as Camera3D).far = view_distance
	if node is GeometryInstance3D:
		var geometry := node as GeometryInstance3D
		_apply_material_filter(geometry.material_override)
		if geometry is MeshInstance3D and (geometry as MeshInstance3D).mesh:
			var mesh_instance := geometry as MeshInstance3D
			var mesh := mesh_instance.mesh
			for surface_index in range(mesh.get_surface_count()):
				_apply_material_filter(mesh_instance.get_surface_override_material(surface_index))
				_apply_material_filter(mesh.surface_get_material(surface_index))
	if node is CanvasItem:
		(node as CanvasItem).texture_filter = [
			CanvasItem.TEXTURE_FILTER_LINEAR,
			CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS,
			CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
		][texture_filter]
	if node.has_method("apply_weather_quality"):
		node.call("apply_weather_quality")
	for child in node.get_children():
		_apply_world_graphics(child)

func _apply_material_filter(material: Material) -> void:
	if material is BaseMaterial3D:
		(material as BaseMaterial3D).texture_filter = [
			BaseMaterial3D.TEXTURE_FILTER_LINEAR,
			BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS,
			BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
		][texture_filter]

func is_compatibility_renderer() -> bool:
	return str(ProjectSettings.get_setting("rendering/renderer/rendering_method", "gl_compatibility")) == "gl_compatibility"

func is_ambient_occlusion_supported() -> bool:
	return str(ProjectSettings.get_setting("rendering/renderer/rendering_method", "gl_compatibility")) != "mobile"

func capture_graphics_settings() -> Dictionary:
	return {
		"window_mode": window_mode,
		"resolution_index": resolution_index,
		"vsync_mode": vsync_mode,
		"shadow_quality": shadow_quality,
		"shadow_distance": shadow_distance,
		"mesh_quality": mesh_quality,
		"texture_quality": texture_quality,
		"texture_filter": texture_filter,
		"weather_quality": weather_quality,
		"foliage_quality": foliage_quality,
		"view_distance": view_distance,
		"brightness": brightness,
		"bloom_enabled": bloom_enabled,
		"anti_aliasing": anti_aliasing,
		"ambient_occlusion_enabled": ambient_occlusion_enabled,
		"render_scale": render_scale,
		"fps_limit": fps_limit
	}

func graphics_defaults() -> Dictionary:
	return {
		"window_mode": 0,
		"resolution_index": 2,
		"vsync_mode": 1,
		"shadow_quality": 1,
		"shadow_distance": 68.0,
		"mesh_quality": 1,
		"texture_quality": 1,
		"texture_filter": 1,
		"weather_quality": 1,
		"foliage_quality": 1,
		"view_distance": 300.0,
		"brightness": 1.0,
		"bloom_enabled": false,
		"anti_aliasing": 1,
		"ambient_occlusion_enabled": false,
		"render_scale": 1.0,
		"fps_limit": 0
	}

func apply_graphics_snapshot(settings: Dictionary) -> void:
	window_mode = clampi(int(settings.get("window_mode", window_mode)), 0, 2)
	resolution_index = clampi(int(settings.get("resolution_index", resolution_index)), 0, 2)
	vsync_mode = clampi(int(settings.get("vsync_mode", vsync_mode)), 0, 2)
	shadow_quality = clampi(int(settings.get("shadow_quality", shadow_quality)), 0, 3)
	shadow_distance = clampf(float(settings.get("shadow_distance", shadow_distance)), 40.0, 300.0)
	mesh_quality = clampi(int(settings.get("mesh_quality", mesh_quality)), 0, 2)
	texture_quality = clampi(int(settings.get("texture_quality", texture_quality)), 0, 2)
	texture_filter = clampi(int(settings.get("texture_filter", texture_filter)), 0, 2)
	weather_quality = clampi(int(settings.get("weather_quality", weather_quality)), 0, 2)
	foliage_quality = clampi(int(settings.get("foliage_quality", foliage_quality)), 0, 2)
	view_distance = clampf(float(settings.get("view_distance", view_distance)), 50.0, 600.0)
	brightness = clampf(float(settings.get("brightness", brightness)), 0.6, 1.4)
	bloom_enabled = bool(settings.get("bloom_enabled", bloom_enabled))
	anti_aliasing = clampi(int(settings.get("anti_aliasing", anti_aliasing)), 0, 2)
	ambient_occlusion_enabled = bool(settings.get("ambient_occlusion_enabled", ambient_occlusion_enabled))
	render_scale = clampf(float(settings.get("render_scale", render_scale)), 0.5, 1.0)
	fps_limit = clampi(int(settings.get("fps_limit", fps_limit)), 0, 3)
	_apply_display_settings()
	apply_graphics_settings()

func begin_graphics_confirmation(previous_settings: Dictionary, timeout_seconds: float) -> void:
	_pending_graphics_snapshot = previous_settings.duplicate(true)
	_graphics_confirmation_timer.start(timeout_seconds)

func is_graphics_confirmation_pending() -> bool:
	return is_instance_valid(_graphics_confirmation_timer) and _graphics_confirmation_timer.time_left > 0.0

func graphics_confirmation_time_left() -> float:
	return _graphics_confirmation_timer.time_left if is_instance_valid(_graphics_confirmation_timer) else 0.0

func keep_graphics_confirmation() -> void:
	if not is_graphics_confirmation_pending():
		return
	_graphics_confirmation_timer.stop()
	_pending_graphics_snapshot.clear()
	save_settings()

func revert_graphics_confirmation() -> void:
	if _pending_graphics_snapshot.is_empty():
		return
	if is_instance_valid(_graphics_confirmation_timer):
		_graphics_confirmation_timer.stop()
	var previous := _pending_graphics_snapshot.duplicate(true)
	_pending_graphics_snapshot.clear()
	apply_graphics_snapshot(previous)
	save_settings()

func graphics_preset(preset_index: int) -> Dictionary:
	var settings := graphics_defaults()
	match preset_index:
		1:
			settings["shadow_quality"] = 1
			settings["shadow_distance"] = 40.0
			settings["mesh_quality"] = 0
			settings["texture_quality"] = 0
			settings["texture_filter"] = 0
			settings["weather_quality"] = 0
			settings["foliage_quality"] = 0
			settings["view_distance"] = 150.0
			settings["anti_aliasing"] = 0
			settings["render_scale"] = 0.7
		2:
			pass
		3:
			settings["shadow_quality"] = 3
			settings["mesh_quality"] = 2
			settings["texture_quality"] = 2
			settings["texture_filter"] = 2
			settings["weather_quality"] = 2
			settings["foliage_quality"] = 2
			settings["shadow_distance"] = 110.0
			settings["anti_aliasing"] = 2
			settings["bloom_enabled"] = true
			settings["ambient_occlusion_enabled"] = true
		_:
			return settings
	return settings

func set_shadow_quality(value: int) -> void:
	shadow_quality = clampi(value, 0, SHADOW_QUALITY_NAMES.size() - 1)
	apply_graphics_settings()
	save_settings()

func set_mesh_quality(value: int) -> void:
	mesh_quality = clampi(value, 0, MESH_QUALITY_NAMES.size() - 1)
	save_settings()

func _ensure_audio_buses() -> void:
	for bus_name in ["Efectos", "Ambiente"]:
		if AudioServer.get_bus_index(bus_name) >= 0:
			continue
		var index := AudioServer.bus_count
		AudioServer.add_bus(index)
		AudioServer.set_bus_name(index, bus_name)
		AudioServer.set_bus_send(index, "Master")

func _set_bus_volume(bus_name: String, value: float) -> void:
	var index := AudioServer.get_bus_index(bus_name)
	if index >= 0:
		AudioServer.set_bus_volume_linear(index, clampf(value, 0.0, 1.0))

func save_settings() -> void:
	var config := ConfigFile.new()
	var saved_window_mode := window_mode
	var saved_resolution_index := resolution_index
	var saved_vsync_mode := vsync_mode
	if not _pending_graphics_snapshot.is_empty():
		saved_window_mode = int(_pending_graphics_snapshot.get("window_mode", window_mode))
		saved_resolution_index = int(_pending_graphics_snapshot.get("resolution_index", resolution_index))
		saved_vsync_mode = int(_pending_graphics_snapshot.get("vsync_mode", vsync_mode))
	config.set_value("controls", "sensitivity", mouse_sensitivity)
	config.set_value("controls", "invert_y", invert_y)
	config.set_value("audio", "master", master_volume)
	config.set_value("audio", "effects", effects_volume)
	config.set_value("audio", "ambience", ambience_volume)
	config.set_value("video", "windowed", saved_window_mode == 0)
	config.set_value("video", "window_mode", saved_window_mode)
	config.set_value("video", "resolution", saved_resolution_index)
	config.set_value("video", "vsync", saved_vsync_mode > 0)
	config.set_value("video", "vsync_mode", saved_vsync_mode)
	config.set_value("video", "ui_defaults_version", DISPLAY_DEFAULTS_VERSION)
	config.set_value("graphics", "shadows", shadow_quality)
	config.set_value("graphics", "shadow_distance", shadow_distance)
	config.set_value("graphics", "mesh_detail", mesh_quality)
	config.set_value("graphics", "texture_quality", texture_quality)
	config.set_value("graphics", "texture_filter", texture_filter)
	config.set_value("graphics", "weather_quality", weather_quality)
	config.set_value("graphics", "foliage_quality", foliage_quality)
	config.set_value("graphics", "view_distance", view_distance)
	config.set_value("graphics", "brightness", brightness)
	config.set_value("graphics", "bloom", bloom_enabled)
	config.set_value("graphics", "anti_aliasing", anti_aliasing)
	config.set_value("graphics", "ambient_occlusion", ambient_occlusion_enabled)
	config.set_value("graphics", "render_scale", render_scale)
	config.set_value("graphics", "fps_limit", fps_limit)
	config.set_value("graphics", "version", GRAPHICS_SETTINGS_VERSION)
	for action in REBINDABLE_ACTIONS:
		var events := InputMap.action_get_events(action)
		if not events.is_empty():
			if events[0] is InputEventKey:
				config.set_value("keybinds", action, {"kind": "key", "code": (events[0] as InputEventKey).physical_keycode})
			elif events[0] is InputEventMouseButton:
				config.set_value("keybinds", action, {"kind": "mouse", "code": (events[0] as InputEventMouseButton).button_index})
	var error := config.save(SETTINGS_PATH)
	if error != OK:
		push_warning("No se pudieron guardar las opciones del juego.")

func has_save() -> bool:
	var config := ConfigFile.new()
	return config.load("user://zombindie_save.cfg") == OK and config.has_section("survival") and config.has_section("inventory")

func reset_defaults() -> void:
	if not _pending_graphics_snapshot.is_empty():
		_graphics_confirmation_timer.stop()
		_pending_graphics_snapshot.clear()
	var defaults := {"move_forward": KEY_W, "move_back": KEY_S, "move_left": KEY_A, "move_right": KEY_D, "sprint": KEY_SHIFT, "jump": KEY_SPACE, "interact": KEY_E, "flashlight": KEY_F, "inventory": KEY_I, "quest_journal": KEY_Q, "world_map": KEY_M, "character_status": KEY_C, "quick_menu": KEY_TAB, "use_water": KEY_1, "use_food": KEY_2, "heal": KEY_H, "build": KEY_B, "save_game": KEY_F5, "load_game": KEY_F9, "weather_cycle": KEY_G, "weather_menu": KEY_F6, "guide": KEY_F1, "pause": KEY_ESCAPE}
	for action in REBINDABLE_ACTIONS:
		InputMap.action_erase_events(action)
		if action == "melee":
			var click := InputEventMouseButton.new()
			click.button_index = MOUSE_BUTTON_LEFT
			InputMap.action_add_event(action, click)
		elif defaults.has(action):
			var key := InputEventKey.new()
			key.physical_keycode = int(defaults[action])
			InputMap.action_add_event(action, key)
	mouse_sensitivity = DEFAULT_SENSITIVITY
	invert_y = false
	master_volume = 0.8
	effects_volume = 0.8
	ambience_volume = 0.8
	windowed = true
	window_mode = 0
	resolution_index = 2
	vsync_enabled = true
	vsync_mode = 1
	shadow_quality = 1
	mesh_quality = 1
	texture_quality = 1
	texture_filter = 1
	weather_quality = 1
	foliage_quality = 1
	view_distance = 300.0
	shadow_distance = 68.0
	brightness = 1.0
	bloom_enabled = false
	anti_aliasing = 1
	ambient_occlusion_enabled = false
	render_scale = 1.0
	fps_limit = 0
	_apply_settings()
	save_settings()

func set_key_binding(action: String, event: InputEvent) -> bool:
	if not InputMap.has_action(action):
		return false
	for other_action in REBINDABLE_ACTIONS:
		if other_action == action:
			continue
		for existing in InputMap.action_get_events(other_action):
			if existing.as_text() == event.as_text():
				return false
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	return true

func get_key_binding(action: String) -> String:
	var events := InputMap.action_get_events(action)
	if events.is_empty():
		return "Sin asignar"
	return events[0].as_text().trim_suffix(" (Physical)")
