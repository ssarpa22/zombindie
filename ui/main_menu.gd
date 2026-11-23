extends Control

var _settings_box: VBoxContainer
var _status: Label
var _waiting_for_binding := ""
var _resolution_picker: OptionButton

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_build_menu()

func _build_menu() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var background := ColorRect.new()
	background.color = Color(0.035, 0.045, 0.05, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(500, 680)
	center.add_child(scroll)
	var box := VBoxContainer.new()
	box.custom_minimum_size.x = 420
	box.add_theme_constant_override("separation", 12)
	scroll.add_child(box)
	var title := Label.new()
	title.text = "ZOMBINDIE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 42)
	box.add_child(title)
	var subtitle := Label.new()
	subtitle.text = "Nadie va a venir a buscarte."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(subtitle)
	_add_button(box, "Continuar", _continue_game, GameSettings.has_save())
	_add_button(box, "Mundo libre", _start_free)
	_add_button(box, "Modo desafío", _start_challenge)
	_add_button(box, "Opciones", _toggle_options)
	_settings_box = VBoxContainer.new()
	_settings_box.add_theme_constant_override("separation", 8)
	box.add_child(_settings_box)
	_settings_box.visible = false
	var sensitivity := HSlider.new()
	sensitivity.min_value = 0.0005
	sensitivity.max_value = 0.006
	sensitivity.step = 0.0001
	sensitivity.value = GameSettings.mouse_sensitivity
	sensitivity.value_changed.connect(_set_sensitivity)
	_settings_box.add_child(_labeled_control("Sensibilidad del mouse", sensitivity))
	var invert := CheckButton.new()
	invert.text = "Invertir eje vertical del mouse"
	invert.button_pressed = GameSettings.invert_y
	invert.toggled.connect(_set_invert_y)
	_settings_box.add_child(invert)
	var volume := HSlider.new()
	volume.min_value = 0.0
	volume.max_value = 1.0
	volume.value = GameSettings.master_volume
	volume.value_changed.connect(_set_volume)
	_settings_box.add_child(_labeled_control("Volumen general", volume))
	var effects := HSlider.new()
	effects.min_value = 0.0
	effects.max_value = 1.0
	effects.value = GameSettings.effects_volume
	effects.value_changed.connect(_set_effects_volume)
	_settings_box.add_child(_labeled_control("Efectos de sonido", effects))
	var ambience := HSlider.new()
	ambience.min_value = 0.0
	ambience.max_value = 1.0
	ambience.value = GameSettings.ambience_volume
	ambience.value_changed.connect(_set_ambience_volume)
	_settings_box.add_child(_labeled_control("Ambiente", ambience))
	var fullscreen := CheckButton.new()
	fullscreen.text = "Pantalla completa"
	fullscreen.button_pressed = not GameSettings.windowed
	fullscreen.toggled.connect(_set_fullscreen)
	_settings_box.add_child(fullscreen)
	_resolution_picker = OptionButton.new()
	_resolution_picker.add_item("1280 × 720")
	_resolution_picker.add_item("1600 × 900")
	_resolution_picker.add_item("1920 × 1080")
	_resolution_picker.select(GameSettings.resolution_index)
	_resolution_picker.item_selected.connect(_set_resolution)
	_settings_box.add_child(_labeled_control("Resolución de ventana", _resolution_picker))
	var vsync := CheckButton.new()
	vsync.text = "Sincronización vertical"
	vsync.button_pressed = DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED
	vsync.toggled.connect(func(enabled: bool): DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if enabled else DisplayServer.VSYNC_DISABLED))
	_settings_box.add_child(vsync)
	for action in GameSettings.REBINDABLE_ACTIONS:
		var bind_button := Button.new()
		bind_button.text = "%s: %s — cambiar" % [_action_label(str(action)), GameSettings.get_key_binding(action)]
		bind_button.pressed.connect(_begin_rebind.bind(str(action), bind_button))
		_settings_box.add_child(bind_button)
	var reset := Button.new()
	reset.text = "Restaurar opciones y controles"
	reset.pressed.connect(_reset_defaults)
	_settings_box.add_child(reset)
	_status = Label.new()
	_status.text = "WASD mover · Shift correr · E interactuar · F linterna · I mochila · Esc pausa"
	_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_status)
	_add_button(box, "Salir", func(): get_tree().quit())

func _input(event: InputEvent) -> void:
	if _waiting_for_binding.is_empty():
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		_waiting_for_binding = ""
		_status.text = "Cambio de control cancelado."
		get_viewport().set_input_as_handled()
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if not GameSettings.set_key_binding(_waiting_for_binding, event):
			_waiting_for_binding = ""
			_status.text = "Esa tecla ya está asignada a otra acción. Clic derecho cancela."
			get_viewport().set_input_as_handled()
			return
		GameSettings.save_settings()
		_waiting_for_binding = ""
		get_viewport().set_input_as_handled()
		get_tree().reload_current_scene()
	elif event is InputEventMouseButton and event.pressed:
		if not GameSettings.set_key_binding(_waiting_for_binding, event):
			_waiting_for_binding = ""
			_status.text = "Ese botón ya está asignado a otra acción."
			get_viewport().set_input_as_handled()
			return
		GameSettings.save_settings()
		_waiting_for_binding = ""
		get_viewport().set_input_as_handled()
		get_tree().reload_current_scene()

func _begin_rebind(action: String, button: Button) -> void:
	_waiting_for_binding = action
	button.text = "%s: presioná una tecla o botón..." % _action_label(action)

func _action_label(action: String) -> String:
	var labels := {
		"move_forward": "Avanzar", "move_back": "Retroceder", "move_left": "Izquierda", "move_right": "Derecha",
		"sprint": "Correr", "interact": "Interactuar", "flashlight": "Linterna", "inventory": "Mochila",
		"melee": "Atacar", "use_water": "Usar agua", "use_food": "Usar comida", "heal": "Curarse",
		"build": "Construir", "save_game": "Guardar", "load_game": "Cargar", "weather_cycle": "Cambiar clima",
		"weather_menu": "Selector de clima", "guide": "Guía", "pause": "Pausa"
	}
	return str(labels.get(action, action))

func _labeled_control(label_text: String, control: Control) -> Control:
	var row := VBoxContainer.new()
	var label := Label.new()
	label.text = label_text
	row.add_child(label)
	row.add_child(control)
	return row

func _add_button(parent: VBoxContainer, text_value: String, action: Callable, enabled: bool = true) -> void:
	var button := Button.new()
	button.text = text_value
	button.custom_minimum_size.y = 42
	button.disabled = not enabled
	button.pressed.connect(action)
	parent.add_child(button)

func _toggle_options() -> void:
	_settings_box.visible = not _settings_box.visible

func _set_sensitivity(value: float) -> void:
	GameSettings.mouse_sensitivity = value
	GameSettings.save_settings()

func _set_invert_y(value: bool) -> void:
	GameSettings.invert_y = value
	GameSettings.save_settings()

func _reset_defaults() -> void:
	GameSettings.reset_defaults()
	get_tree().reload_current_scene()

func _set_volume(value: float) -> void:
	GameSettings.master_volume = value
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)
	GameSettings.save_settings()

func _set_effects_volume(value: float) -> void:
	GameSettings.effects_volume = value
	GameSettings._set_bus_volume("Efectos", value)
	GameSettings.save_settings()

func _set_ambience_volume(value: float) -> void:
	GameSettings.ambience_volume = value
	GameSettings._set_bus_volume("Ambiente", value)
	GameSettings.save_settings()

func _set_fullscreen(enabled: bool) -> void:
	GameSettings.windowed = not enabled
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if enabled else DisplayServer.WINDOW_MODE_WINDOWED)
	GameSettings.save_settings()

func _set_resolution(index: int) -> void:
	var sizes := [Vector2i(1280, 720), Vector2i(1600, 900), Vector2i(1920, 1080)]
	if index >= 0 and index < sizes.size():
		GameSettings.resolution_index = index
		DisplayServer.window_set_size(sizes[index])
		GameSettings.save_settings()

func _start_free() -> void:
	GameSettings.mode = "free"
	get_tree().change_scene_to_file("res://Main.tscn")

func _start_challenge() -> void:
	GameSettings.mode = "challenge"
	get_tree().change_scene_to_file("res://Main.tscn")

func _continue_game() -> void:
	GameSettings.continue_requested = true
	get_tree().change_scene_to_file("res://Main.tscn")
