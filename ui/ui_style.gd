extends RefCounted

const BACKGROUND := Color(0.035, 0.047, 0.048, 0.96)
const SURFACE := Color(0.075, 0.09, 0.085, 0.98)
const SURFACE_HOVER := Color(0.12, 0.15, 0.13, 1.0)
const BORDER := Color(0.22, 0.28, 0.24, 1.0)
const ACCENT := Color(0.58, 0.67, 0.48, 1.0)
const AMBER := Color(0.78, 0.57, 0.30, 1.0)
const TEXT := Color(0.88, 0.89, 0.82, 1.0)
const MUTED := Color(0.55, 0.61, 0.57, 1.0)
const DANGER := Color(0.72, 0.31, 0.24, 1.0)

static func create_theme() -> Theme:
	var theme := Theme.new()
	theme.default_font_size = 10
	theme.set_font_size("font_size", "Button", 9)
	theme.set_font_size("font_size", "CheckButton", 9)
	theme.set_font_size("font_size", "OptionButton", 9)
	theme.set_color("font_color", "Label", TEXT)
	theme.set_color("font_hover_color", "Label", TEXT)
	theme.set_color("font_color", "Button", TEXT)
	theme.set_color("font_hover_color", "Button", Color.WHITE)
	theme.set_color("font_pressed_color", "Button", Color.WHITE)
	theme.set_color("font_disabled_color", "Button", MUTED.darkened(0.25))
	theme.set_color("font_color", "CheckButton", TEXT)
	theme.set_color("font_color", "OptionButton", TEXT)
	theme.set_color("font_color", "ProgressBar", TEXT)
	theme.set_color("font_color", "Slider", TEXT)
	theme.set_stylebox("panel", "PanelContainer", panel_style())
	theme.set_stylebox("panel", "Panel", panel_style())
	theme.set_stylebox("normal", "Button", button_style(SURFACE, BORDER))
	theme.set_stylebox("hover", "Button", button_style(SURFACE_HOVER, ACCENT))
	theme.set_stylebox("pressed", "Button", button_style(Color(0.12, 0.17, 0.13), ACCENT))
	theme.set_stylebox("disabled", "Button", button_style(SURFACE.darkened(0.2), BORDER.darkened(0.3)))
	theme.set_stylebox("focus", "Button", button_style(SURFACE, ACCENT))
	theme.set_stylebox("normal", "OptionButton", button_style(SURFACE, BORDER))
	theme.set_stylebox("hover", "OptionButton", button_style(SURFACE_HOVER, ACCENT))
	theme.set_stylebox("background", "ProgressBar", progress_style(Color(0.1, 0.13, 0.12, 1.0)))
	theme.set_stylebox("fill", "ProgressBar", progress_style(ACCENT))
	return theme

static func panel_style(color: Color = BACKGROUND, border_color: Color = BORDER) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border_color
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	style.content_margin_left = 14.0
	style.content_margin_top = 12.0
	style.content_margin_right = 14.0
	style.content_margin_bottom = 12.0
	return style

static func button_style(color: Color, border_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border_color
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	style.content_margin_left = 10.0
	style.content_margin_top = 7.0
	style.content_margin_right = 10.0
	style.content_margin_bottom = 7.0
	return style

static func progress_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(3)
	return style

static func add_accent_bar(parent: Control, color: Color = ACCENT) -> ColorRect:
	var bar := ColorRect.new()
	bar.color = color
	bar.custom_minimum_size = Vector2(3.0, 0.0)
	bar.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(bar)
	return bar
