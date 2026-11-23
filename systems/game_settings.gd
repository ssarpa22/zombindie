extends Node

const SETTINGS_PATH := "user://zombindie_settings.cfg"
const DEFAULT_SENSITIVITY := 0.0022
const REBINDABLE_ACTIONS := ["move_forward", "move_back", "move_left", "move_right", "sprint", "interact", "flashlight", "inventory", "melee", "use_water", "use_food", "heal", "build", "save_game", "load_game", "weather_cycle", "weather_menu", "guide", "pause"]

var mouse_sensitivity := DEFAULT_SENSITIVITY
var invert_y := false
var master_volume := 0.8
var effects_volume := 0.8
var ambience_volume := 0.8
var windowed := true
var resolution_index := 0
var mode := "free"
var continue_requested := false

func _ready() -> void:
	_load_settings()
	_ensure_actions()
	_apply_settings()

func _ensure_actions() -> void:
	_add_key_action("move_forward", KEY_W)
	_add_key_action("move_back", KEY_S)
	_add_key_action("move_left", KEY_A)
	_add_key_action("move_right", KEY_D)
	_add_key_action("sprint", KEY_SHIFT)
	_add_key_action("interact", KEY_E)
	_add_key_action("flashlight", KEY_F)
	_add_key_action("noclip", KEY_V)
	_add_key_action("inventory", KEY_I)
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
	mouse_sensitivity = float(config.get_value("controls", "sensitivity", DEFAULT_SENSITIVITY))
	invert_y = bool(config.get_value("controls", "invert_y", false))
	master_volume = float(config.get_value("audio", "master", 0.8))
	effects_volume = float(config.get_value("audio", "effects", 0.8))
	ambience_volume = float(config.get_value("audio", "ambience", 0.8))
	windowed = bool(config.get_value("video", "windowed", true))
	resolution_index = clampi(int(config.get_value("video", "resolution", 0)), 0, 2)

func _apply_settings() -> void:
	_ensure_audio_buses()
	var bus := AudioServer.get_bus_index("Master")
	if bus >= 0:
		AudioServer.set_bus_volume_linear(bus, clampf(master_volume, 0.0, 1.0))
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if windowed else DisplayServer.WINDOW_MODE_FULLSCREEN)
	var sizes := [Vector2i(1280, 720), Vector2i(1600, 900), Vector2i(1920, 1080)]
	DisplayServer.window_set_size(sizes[resolution_index])
	_set_bus_volume("Efectos", effects_volume)
	_set_bus_volume("Ambiente", ambience_volume)

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
	config.set_value("controls", "sensitivity", mouse_sensitivity)
	config.set_value("controls", "invert_y", invert_y)
	config.set_value("audio", "master", master_volume)
	config.set_value("audio", "effects", effects_volume)
	config.set_value("audio", "ambience", ambience_volume)
	config.set_value("video", "windowed", windowed)
	config.set_value("video", "resolution", resolution_index)
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
	var defaults := {"move_forward": KEY_W, "move_back": KEY_S, "move_left": KEY_A, "move_right": KEY_D, "sprint": KEY_SHIFT, "interact": KEY_E, "flashlight": KEY_F, "inventory": KEY_I, "use_water": KEY_1, "use_food": KEY_2, "heal": KEY_H, "build": KEY_B, "save_game": KEY_F5, "load_game": KEY_F9, "weather_cycle": KEY_G, "weather_menu": KEY_F6, "guide": KEY_F1, "pause": KEY_ESCAPE}
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
	resolution_index = 0
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
