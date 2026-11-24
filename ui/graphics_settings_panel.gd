extends VBoxContainer

const UIStyle = preload("res://ui/ui_style.gd")

var _draft: Dictionary
var _controls: Dictionary = {}
var _category_bodies: Dictionary = {}
var _category_buttons: Dictionary = {}
var _preset_picker: OptionButton
var _status: Label
var _confirmation_panel: PanelContainer
var _confirmation_label: Label
var _pending_confirmation := false
var _open_category := "display"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	theme = UIStyle.create_theme()
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_draft = GameSettings.capture_graphics_settings()
	_build_panel()
	_refresh_controls()
	_pending_confirmation = GameSettings.is_graphics_confirmation_pending()
	_confirmation_panel.visible = _pending_confirmation
	_set_controls_disabled(_pending_confirmation)

func _process(_delta: float) -> void:
	if not _pending_confirmation:
		return
	if not GameSettings.is_graphics_confirmation_pending():
		_pending_confirmation = false
		_confirmation_panel.visible = false
		_set_controls_disabled(false)
		_draft = GameSettings.capture_graphics_settings()
		_refresh_controls()
		_status.text = "Se revirtieron los cambios de pantalla."
	elif is_instance_valid(_confirmation_label):
		_confirmation_label.text = "¿Conservar los cambios de pantalla? Se revertirán en %d s." % ceili(GameSettings.graphics_confirmation_time_left())

func _build_panel() -> void:
	add_theme_constant_override("separation", 5)
	var preset_row := HBoxContainer.new()
	preset_row.add_child(_make_label("Preajuste gráfico"))
	_preset_picker = OptionButton.new()
	_preset_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for preset_name in ["Personalizado", "Rendimiento", "Equilibrado", "Calidad"]:
		_preset_picker.add_item(preset_name)
	_preset_picker.select(0)
	_preset_picker.item_selected.connect(_apply_preset_to_draft)
	preset_row.add_child(_preset_picker)
	add_child(preset_row)

	_add_category("Pantalla y presentación", "display")
	_add_category("Sombras e iluminación", "lighting")
	_add_category("Texturas y materiales", "textures")
	_add_category("Filtrado e imagen", "image")
	_add_category("Clima y entorno", "weather")
	_add_category("Posprocesado", "post")
	_add_category("Avanzado", "advanced")

	var note := Label.new()
	note.text = "Texturas, geometría y densidad de follaje se regeneran al cargar una escena. La distancia, el clima, las sombras y los efectos disponibles se aplican al instante."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.add_theme_color_override("font_color", UIStyle.MUTED)
	add_child(note)

	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 4)
	add_child(actions)
	_add_action(actions, "Aplicar", _apply_draft)
	_add_action(actions, "Descartar", _discard_draft)
	_add_action(actions, "Predeterminados", _restore_graphics_defaults)

	_status = Label.new()
	_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_status.add_theme_color_override("font_color", UIStyle.MUTED)
	add_child(_status)

	_confirmation_panel = PanelContainer.new()
	_confirmation_panel.visible = false
	var confirmation_layout := VBoxContainer.new()
	_confirmation_panel.add_child(confirmation_layout)
	_confirmation_label = Label.new()
	_confirmation_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	confirmation_layout.add_child(_confirmation_label)
	var confirmation_actions := HBoxContainer.new()
	confirmation_layout.add_child(confirmation_actions)
	_add_action(confirmation_actions, "Conservar", _keep_display_change)
	_add_action(confirmation_actions, "Revertir ahora", _revert_pending_display_change)
	add_child(_confirmation_panel)

func _add_category(title: String, key: String) -> void:
	var button := Button.new()
	button.text = title + ("  −" if key == _open_category else "  +")
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.pressed.connect(_toggle_category.bind(key))
	add_child(button)
	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 4)
	body.visible = key == _open_category
	_category_bodies[key] = body
	_category_buttons[key] = button
	add_child(body)
	match key:
		"display":
			_add_option(body, "Modo de ventana", "window_mode", GameSettings.WINDOW_MODE_NAMES)
			_add_option(body, "Resolución de ventana", "resolution_index", ["1280 × 720", "1600 × 900", "1920 × 1080"])
			_add_help(body, "En pantalla completa se usa la resolución nativa del monitor.")
			var vsync_options := ["Desactivada", "Activada"] if GameSettings.is_compatibility_renderer() else GameSettings.VSYNC_MODE_NAMES
			_add_option(body, "Sincronización vertical", "vsync_mode", vsync_options)
			_add_slider(body, "Brillo del mundo", "brightness", 0.6, 1.4, 0.05)
		"lighting":
			_add_option(body, "Calidad de sombras", "shadow_quality", GameSettings.SHADOW_QUALITY_NAMES)
			_add_slider(body, "Distancia de sombra direccional (m)", "shadow_distance", 40.0, 300.0, 10.0)
			_add_help(body, "Desactivadas elimina todas las sombras dinámicas. Baja limita el cálculo a luces clave; Media y Alta habilitan las luces compatibles y aumentan la resolución. Usa mapas de sombra estándar, no ray tracing.")
		"textures":
			_add_option(body, "Resolución de texturas", "texture_quality", GameSettings.TEXTURE_QUALITY_NAMES)
			_add_option(body, "Detalle de mallas procedurales", "mesh_quality", GameSettings.MESH_QUALITY_NAMES)
			_add_help(body, "La resolución se aplica a las texturas procedurales del mundo.")
		"image":
			_add_option(body, "Filtrado de texturas", "texture_filter", GameSettings.TEXTURE_FILTER_NAMES)
			_add_option(body, "Antialiasing 3D (MSAA)", "anti_aliasing", ["Desactivado", "2×", "4×"])
			_add_slider(body, "Escala de renderizado 3D", "render_scale", 0.5, 1.0, 0.05)
			_add_help(body, "La escala afecta solo al render 3D; la interfaz conserva su resolución para seguir siendo legible.")
		"weather":
			_add_option(body, "Calidad visual del clima", "weather_quality", GameSettings.WEATHER_QUALITY_NAMES)
			_add_slider(body, "Distancia de visión (m)", "view_distance", 50.0, 600.0, 10.0)
			_add_help(body, "Solo reduce partículas y detalle visual. No altera el clima, la supervivencia ni sus efectos de juego.")
		"post":
			_add_check(body, "Bloom / resplandor", "bloom_enabled")
			if GameSettings.is_ambient_occlusion_supported():
				_add_check(body, "Oclusión ambiental (SSAO)", "ambient_occlusion_enabled")
			else:
				_add_help(body, "SSAO no está disponible en este renderizador.")
			_add_help(body, "HDR de salida y desenfoque de movimiento no están disponibles con el renderizador Compatibility; no se aplicarán como opciones simuladas.")
		"advanced":
			_add_option(body, "Densidad de follaje", "foliage_quality", GameSettings.FOLIAGE_QUALITY_NAMES)
			_add_option(body, "Límite de fotogramas", "fps_limit", ["Sin límite", "30 FPS", "60 FPS", "120 FPS"])
			_add_help(body, "Los ajustes gráficos no modifican la simulación del clima ni los sistemas de supervivencia.")

func _toggle_category(key: String) -> void:
	_open_category = "" if _open_category == key else key
	for category_key in _category_bodies:
		var is_open: bool = category_key == _open_category
		(_category_bodies[category_key] as VBoxContainer).visible = is_open
		(_category_buttons[category_key] as Button).text = _category_title(category_key) + ("  −" if is_open else "  +")

func _category_title(key: String) -> String:
	var titles := {
		"display": "Pantalla y presentación",
		"lighting": "Sombras e iluminación",
		"textures": "Texturas y materiales",
		"image": "Filtrado e imagen",
		"weather": "Clima y entorno",
		"post": "Posprocesado",
		"advanced": "Avanzado"
	}
	return str(titles.get(key, key))

func _add_option(parent: Control, label_text: String, key: String, values: Array) -> void:
	var option := OptionButton.new()
	option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for value in values:
		option.add_item(str(value))
	option.select(int(_draft.get(key, 0)))
	option.item_selected.connect(_set_draft_value.bind(key))
	_controls[key] = option
	parent.add_child(_labeled_control(label_text, option))

func _add_slider(parent: Control, label_text: String, key: String, minimum: float, maximum: float, step: float) -> void:
	var slider := HSlider.new()
	slider.min_value = minimum
	slider.max_value = maximum
	slider.step = step
	slider.value = float(_draft.get(key, minimum))
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(_set_draft_value.bind(key))
	_controls[key] = slider
	parent.add_child(_labeled_control(label_text, slider))

func _add_check(parent: Control, label_text: String, key: String) -> void:
	var check := CheckButton.new()
	check.text = label_text
	check.button_pressed = bool(_draft.get(key, false))
	check.toggled.connect(_set_draft_value.bind(key))
	_controls[key] = check
	parent.add_child(check)

func _add_help(parent: Control, text: String) -> void:
	var label := _make_label(text)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", UIStyle.MUTED)
	parent.add_child(label)

func _make_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	return label

func _labeled_control(label_text: String, control: Control) -> VBoxContainer:
	var row := VBoxContainer.new()
	row.add_theme_constant_override("separation", 1)
	var label := _make_label(label_text)
	label.add_theme_color_override("font_color", UIStyle.MUTED)
	row.add_child(label)
	row.add_child(control)
	return row

func _add_action(parent: Control, text: String, action: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.pressed.connect(action)
	parent.add_child(button)

func _set_draft_value(value: Variant, key: String) -> void:
	_draft[key] = value
	if key == "window_mode" and _controls.has("resolution_index"):
		(_controls["resolution_index"] as OptionButton).disabled = int(value) != 0
	_preset_picker.select(0)
	_status.text = "Cambios pendientes. Pulsa Aplicar para guardarlos."

func _apply_preset_to_draft(index: int) -> void:
	if index == 0:
		return
	var preset := GameSettings.graphics_preset(index)
	for key in ["shadow_quality", "shadow_distance", "mesh_quality", "texture_quality", "texture_filter", "weather_quality", "foliage_quality", "view_distance", "brightness", "bloom_enabled", "anti_aliasing", "ambient_occlusion_enabled", "render_scale", "fps_limit"]:
		_draft[key] = preset[key]
	_refresh_controls()
	_status.text = "Preajuste listo. Pulsa Aplicar para guardarlo."

func _refresh_controls() -> void:
	for key in _controls:
		var control: Control = _controls[key]
		var value: Variant = _draft[key]
		if control is OptionButton:
			(control as OptionButton).select(int(value))
		elif control is HSlider:
			(control as HSlider).set_value_no_signal(float(value))
		elif control is CheckButton:
			(control as CheckButton).set_pressed_no_signal(bool(value))
	if _controls.has("resolution_index"):
		(_controls["resolution_index"] as OptionButton).disabled = int(_draft["window_mode"]) != 0

func _set_controls_disabled(disabled: bool) -> void:
	_preset_picker.disabled = disabled
	for control in _controls.values():
		if control is Range:
			(control as Range).editable = not disabled
		elif control is BaseButton:
			(control as BaseButton).disabled = disabled

func _apply_draft() -> void:
	if _pending_confirmation:
		return
	var previous := GameSettings.capture_graphics_settings()
	var display_changed := int(_draft["window_mode"]) != GameSettings.window_mode or int(_draft["resolution_index"]) != GameSettings.resolution_index
	GameSettings.apply_graphics_snapshot(_draft)
	_draft = GameSettings.capture_graphics_settings()
	_refresh_controls()
	if display_changed:
		_pending_confirmation = true
		_confirmation_panel.visible = true
		_set_controls_disabled(true)
		GameSettings.begin_graphics_confirmation(previous, 15.0)
		_status.text = "Confirma el modo de pantalla antes de que termine el contador."
	else:
		GameSettings.save_settings()
		_status.text = "Configuración aplicada y guardada."

func _keep_display_change() -> void:
	if not _pending_confirmation:
		return
	GameSettings.keep_graphics_confirmation()
	_pending_confirmation = false
	_confirmation_panel.visible = false
	_set_controls_disabled(false)
	_refresh_controls()
	_refresh_controls()
	_status.text = "Configuración de pantalla confirmada."

func _revert_pending_display_change() -> void:
	if not _pending_confirmation:
		return
	GameSettings.revert_graphics_confirmation()
	_pending_confirmation = false
	_confirmation_panel.visible = false
	_set_controls_disabled(false)
	_draft = GameSettings.capture_graphics_settings()
	_refresh_controls()
	_status.text = "Se revirtieron los cambios de pantalla."

func _discard_draft() -> void:
	if _pending_confirmation:
		_revert_pending_display_change()
		return
	_draft = GameSettings.capture_graphics_settings()
	_refresh_controls()
	_status.text = "Se descartaron los cambios pendientes."

func _restore_graphics_defaults() -> void:
	if _pending_confirmation:
		return
	var defaults := GameSettings.graphics_defaults()
	for key in defaults:
		_draft[key] = defaults[key]
	_refresh_controls()
	_preset_picker.select(2)
	_status.text = "Valores predeterminados listos. Pulsa Aplicar para guardarlos."
