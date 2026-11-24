extends Control

const UIStyle = preload("res://ui/ui_style.gd")
const GraphicsSettingsPanel = preload("res://ui/graphics_settings_panel.gd")

var _settings_box: VBoxContainer
var _status: Label
var _waiting_for_binding := ""
var _binding_button: Button
var _main_panel: PanelContainer
var _options_panel: PanelContainer
var _options_scroll: ScrollContainer
var _options_status: Label
var _active_option_section := "graphics"

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_build_menu()

func _build_menu() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	theme = UIStyle.create_theme()
	var background := ColorRect.new()
	background.color = Color(0.022, 0.03, 0.032, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	var glow := ColorRect.new()
	glow.color = Color(0.09, 0.13, 0.105, 0.42)
	glow.anchor_left = 0.0
	glow.anchor_top = 0.0
	glow.anchor_right = 0.54
	glow.anchor_bottom = 1.0
	glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(glow)
	var top_rule := ColorRect.new()
	top_rule.color = UIStyle.ACCENT
	top_rule.anchor_right = 1.0
	top_rule.offset_bottom = 2.0
	top_rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(top_rule)
	var bottom_note := Label.new()
	bottom_note.text = "ZONA DE CUARENTENA  /  SEÑAL DE RADIO INESTABLE"
	bottom_note.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	bottom_note.position = Vector2(18.0, -20.0)
	bottom_note.add_theme_color_override("font_color", UIStyle.MUTED)
	bottom_note.add_theme_font_size_override("font_size", 7)
	bottom_note.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bottom_note)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	_main_panel = PanelContainer.new()
	_main_panel.custom_minimum_size = Vector2(570.0, 300.0)
	center.add_child(_main_panel)
	var layout := HBoxContainer.new()
	layout.add_theme_constant_override("separation", 16)
	_main_panel.add_child(layout)
	var brand := VBoxContainer.new()
	brand.custom_minimum_size.x = 305.0
	brand.size_flags_vertical = Control.SIZE_EXPAND_FILL
	brand.add_theme_constant_override("separation", 6)
	layout.add_child(brand)
	var eyebrow := Label.new()
	eyebrow.text = "DIARIO DE SUPERVIVENCIA   /   01"
	eyebrow.add_theme_color_override("font_color", UIStyle.AMBER)
	eyebrow.add_theme_font_size_override("font_size", 8)
	brand.add_child(eyebrow)
	var title := Label.new()
	title.text = "ZOMBINDIE"
	title.add_theme_color_override("font_color", UIStyle.TEXT)
	title.add_theme_font_size_override("font_size", 30)
	brand.add_child(title)
	var subtitle := Label.new()
	subtitle.text = "NADIE VA A VENIR A BUSCARTE."
	subtitle.add_theme_color_override("font_color", UIStyle.ACCENT)
	subtitle.add_theme_font_size_override("font_size", 9)
	brand.add_child(subtitle)
	var divider := ColorRect.new()
	divider.color = UIStyle.BORDER
	divider.custom_minimum_size = Vector2(0.0, 1.0)
	brand.add_child(divider)
	var detail := Label.new()
	detail.text = "La clínica quedó atrás.\nEl bosque sigue respirando.\n\nCada recurso cuenta. Cada ruido también."
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail.add_theme_color_override("font_color", UIStyle.MUTED)
	brand.add_child(detail)
	var brand_spacer := Control.new()
	brand_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	brand.add_child(brand_spacer)
	var status_line := Label.new()
	status_line.text = "●  SISTEMA EN LÍNEA     ·     MODO %s" % ("DESAFÍO" if GameSettings.mode == "challenge" else "LIBRE")
	status_line.add_theme_color_override("font_color", UIStyle.ACCENT)
	status_line.add_theme_font_size_override("font_size", 7)
	brand.add_child(status_line)
	UIStyle.add_accent_bar(layout, UIStyle.BORDER)
	var actions := VBoxContainer.new()
	actions.custom_minimum_size.x = 215.0
	actions.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	actions.add_theme_constant_override("separation", 8)
	layout.add_child(actions)
	var menu_heading := Label.new()
	menu_heading.text = "PUNTO DE CONTROL"
	menu_heading.add_theme_color_override("font_color", UIStyle.MUTED)
	menu_heading.add_theme_font_size_override("font_size", 8)
	actions.add_child(menu_heading)
	_add_button(actions, "Continuar partida", _continue_game, GameSettings.has_save())
	_add_button(actions, "Explorar · mundo libre", _start_free)
	_add_button(actions, "Sobrevivir · desafío", _start_challenge)
	_add_button(actions, "Opciones", _toggle_options)
	_add_button(actions, "Salir", func(): get_tree().quit())
	_status = Label.new()
	_status.text = "WASD mover · Shift correr · Space saltar · E interactuar"
	_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_status.add_theme_color_override("font_color", UIStyle.MUTED)
	_status.add_theme_font_size_override("font_size", 7)
	actions.add_child(_status)

	_options_panel = PanelContainer.new()
	_options_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_options_panel.offset_left = 28.0
	_options_panel.offset_top = 20.0
	_options_panel.offset_right = -28.0
	_options_panel.offset_bottom = -20.0
	add_child(_options_panel)
	var options_layout := VBoxContainer.new()
	options_layout.add_theme_constant_override("separation", 7)
	_options_panel.add_child(options_layout)
	var options_header := HBoxContainer.new()
	options_layout.add_child(options_header)
	var options_title := Label.new()
	options_title.text = "CONFIGURACIÓN"
	options_title.add_theme_color_override("font_color", UIStyle.ACCENT)
	options_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	options_header.add_child(options_title)
	var back := Button.new()
	back.text = "VOLVER"
	back.pressed.connect(_toggle_options)
	options_header.add_child(back)
	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 4)
	options_layout.add_child(tabs)
	for tab: Array in [["graphics", "GRÁFICOS"], ["audio", "SONIDO"], ["camera", "CÁMARA"], ["controls", "CONTROLES"]]:
		var tab_button := Button.new()
		tab_button.text = str(tab[1])
		tab_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tab_button.pressed.connect(_show_option_section.bind(str(tab[0])))
		tabs.add_child(tab_button)
	_options_scroll = ScrollContainer.new()
	_options_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	options_layout.add_child(_options_scroll)
	_settings_box = VBoxContainer.new()
	_settings_box.add_theme_constant_override("separation", 6)
	_settings_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_options_scroll.add_child(_settings_box)
	_options_status = Label.new()
	_options_status.text = "Elegí una categoría para ajustar tu partida."
	_options_status.add_theme_color_override("font_color", UIStyle.MUTED)
	_options_status.add_theme_font_size_override("font_size", 7)
	options_layout.add_child(_options_status)
	var reset := Button.new()
	reset.text = "Restaurar valores predeterminados"
	reset.pressed.connect(_reset_defaults)
	options_layout.add_child(reset)
	_options_panel.visible = false
	_show_option_section(_active_option_section)

func _input(event: InputEvent) -> void:
	if _waiting_for_binding.is_empty():
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		if is_instance_valid(_binding_button):
			_binding_button.text = "%s     [%s]" % [_action_label(_waiting_for_binding), GameSettings.get_key_binding(_waiting_for_binding)]
		_waiting_for_binding = ""
		_binding_button = null
		_options_status.text = "Cambio de control cancelado."
		get_viewport().set_input_as_handled()
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if not GameSettings.set_key_binding(_waiting_for_binding, event):
			_options_status.text = "Esa tecla ya está asignada. Elegí otra; clic derecho cancela."
			get_viewport().set_input_as_handled()
			return
		GameSettings.save_settings()
		_waiting_for_binding = ""
		_options_status.text = "Control actualizado."
		get_viewport().set_input_as_handled()
		get_tree().reload_current_scene()
	elif event is InputEventMouseButton and event.pressed:
		if not GameSettings.set_key_binding(_waiting_for_binding, event):
			_options_status.text = "Ese botón ya está asignado a otra acción."
			get_viewport().set_input_as_handled()
			return
		GameSettings.save_settings()
		_waiting_for_binding = ""
		_options_status.text = "Control actualizado."
		get_viewport().set_input_as_handled()
		get_tree().reload_current_scene()

func _begin_rebind(action: String, button: Button) -> void:
	_waiting_for_binding = action
	_binding_button = button
	button.text = "%s: esperando entrada..." % _action_label(action)
	_options_status.text = "Presioná una tecla o botón. Clic derecho cancela."

func _action_label(action: String) -> String:
	var labels := {
		"move_forward": "Avanzar", "move_back": "Retroceder", "move_left": "Izquierda", "move_right": "Derecha",
		"sprint": "Correr", "jump": "Saltar", "interact": "Interactuar", "flashlight": "Linterna", "inventory": "Mochila",
		"quest_journal": "Diario de misiones", "world_map": "Mapa", "character_status": "Estado del personaje",
		"quick_menu": "Acceso rápido",
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

func _show_option_section(section: String) -> void:
	_active_option_section = section
	for child in _settings_box.get_children():
		child.queue_free()
	match section:
		"video":
			_add_graphics_settings()
		"graphics":
			_add_graphics_settings()
		"audio":
			_add_option_heading("SONIDO", "Ajustá la mezcla del refugio y el exterior.")
			_add_slider_setting("Volumen general", GameSettings.master_volume, _set_volume)
			_add_slider_setting("Efectos", GameSettings.effects_volume, _set_effects_volume)
			_add_slider_setting("Ambiente", GameSettings.ambience_volume, _set_ambience_volume)
		"controls":
			_add_option_heading("CONTROLES", "Seleccioná una acción y presioná una tecla o botón.")
			for action_variant: Variant in GameSettings.REBINDABLE_ACTIONS:
				var action := str(action_variant)
				var bind_button := Button.new()
				bind_button.text = "%s     [%s]" % [_action_label(action), GameSettings.get_key_binding(action)]
				bind_button.custom_minimum_size.y = 30.0
				bind_button.pressed.connect(_begin_rebind.bind(action, bind_button))
				_settings_box.add_child(bind_button)
		"camera":
			_add_option_heading("CÁMARA", "Ajustá cómo se siente la exploración.")
			var sensitivity := HSlider.new()
			sensitivity.min_value = 0.0005
			sensitivity.max_value = 0.006
			sensitivity.step = 0.0001
			sensitivity.value = GameSettings.mouse_sensitivity
			sensitivity.value_changed.connect(_set_sensitivity)
			_settings_box.add_child(_labeled_control("Sensibilidad del mouse", sensitivity))
			var invert := CheckButton.new()
			invert.text = "Invertir eje vertical"
			invert.button_pressed = GameSettings.invert_y
			invert.toggled.connect(_set_invert_y)
			_settings_box.add_child(invert)

func _add_option_heading(title_text: String, description: String) -> void:
	var title := Label.new()
	title.text = title_text
	title.add_theme_color_override("font_color", UIStyle.AMBER)
	_settings_box.add_child(title)
	var detail := Label.new()
	detail.text = description
	detail.add_theme_color_override("font_color", UIStyle.MUTED)
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_settings_box.add_child(detail)

func _add_graphics_settings() -> void:
	_settings_box.add_child(GraphicsSettingsPanel.new())

func _add_slider_setting(label_text: String, value: float, changed: Callable) -> void:
	var slider := HSlider.new()
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = 0.01
	slider.value = value
	slider.value_changed.connect(changed)
	_settings_box.add_child(_labeled_control(label_text, slider))

func _add_button(parent: VBoxContainer, text_value: String, action: Callable, enabled: bool = true) -> void:
	var button := Button.new()
	button.text = text_value
	button.custom_minimum_size.y = 34
	button.disabled = not enabled
	button.pressed.connect(action)
	parent.add_child(button)

func _toggle_options() -> void:
	var showing_options := not _options_panel.visible
	_main_panel.visible = not showing_options
	_options_panel.visible = showing_options
	if showing_options:
		_show_option_section(_active_option_section)

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

func _start_free() -> void:
	GameSettings.mode = "free"
	get_tree().change_scene_to_file("res://Main.tscn")

func _start_challenge() -> void:
	GameSettings.mode = "challenge"
	get_tree().change_scene_to_file("res://Main.tscn")

func _continue_game() -> void:
	GameSettings.continue_requested = true
	get_tree().change_scene_to_file("res://Main.tscn")
