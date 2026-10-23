extends CanvasLayer
## Interface: barras de vida e XP, nível, tempo, joystick e tela de fim de jogo.

signal joystick_moved(dir: Vector2)
signal restart_requested

const JoystickScript := preload("res://scripts/joystick.gd")
const BAR_W := 400.0

var player

var _hp_fill: ColorRect
var _xp_fill: ColorRect
var _level_label: Label
var _info_label: Label
var _over_box: Control
var _over_label: Label


func _ready() -> void:
	# Joystick ocupa a metade de baixo da tela.
	var joy := JoystickScript.new()
	joy.position = Vector2(0, 640)
	joy.size = Vector2(720, 640)
	joy.moved.connect(func(d: Vector2) -> void: joystick_moved.emit(d))
	add_child(joy)

	# Barra de vida.
	add_child(_make_rect(Vector2(20, 20), Vector2(BAR_W, 22), Color(0, 0, 0, 0.55)))
	_hp_fill = _make_rect(Vector2(20, 20), Vector2(BAR_W, 22), Color(0.85, 0.2, 0.25))
	add_child(_hp_fill)

	# Barra de XP.
	add_child(_make_rect(Vector2(20, 48), Vector2(BAR_W, 12), Color(0, 0, 0, 0.55)))
	_xp_fill = _make_rect(Vector2(20, 48), Vector2(0, 12), Color(0.95, 0.8, 0.25))
	add_child(_xp_fill)

	_level_label = _make_label(Vector2(440, 12), 30)
	add_child(_level_label)
	_info_label = _make_label(Vector2(20, 68), 24)
	add_child(_info_label)

	# Tela de fim de jogo.
	_over_box = Control.new()
	_over_box.visible = false
	add_child(_over_box)
	_over_box.add_child(_make_rect(Vector2.ZERO, Vector2(720, 1280), Color(0, 0, 0, 0.65)))
	_over_label = _make_label(Vector2(60, 420), 36)
	_over_label.size = Vector2(600, 200)
	_over_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_over_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_over_box.add_child(_over_label)
	var btn := Button.new()
	btn.text = "Jogar de novo"
	btn.position = Vector2(210, 660)
	btn.size = Vector2(300, 90)
	btn.add_theme_font_size_override("font_size", 30)
	btn.pressed.connect(func() -> void: restart_requested.emit())
	_over_box.add_child(btn)


func _process(_delta: float) -> void:
	if player == null:
		return
	_hp_fill.size.x = BAR_W * clampf(player.hp / player.max_hp, 0.0, 1.0)
	_xp_fill.size.x = BAR_W * clampf(float(player.xp) / float(player.xp_next), 0.0, 1.0)
	_level_label.text = "Nv %d" % player.level
	_info_label.text = "Tempo %s  ·  Abates %d" % [_format_time(player.time_alive), player.kills]


func show_game_over() -> void:
	_over_label.text = "Você caiu!\nNível %d  ·  %d abates\nSobreviveu %s" % [
		player.level, player.kills, _format_time(player.time_alive)
	]
	_over_box.visible = true


func _format_time(seconds: float) -> String:
	var t := int(seconds)
	return "%02d:%02d" % [floori(t / 60.0), t % 60]


func _make_rect(pos: Vector2, sz: Vector2, col: Color) -> ColorRect:
	var r := ColorRect.new()
	r.position = pos
	r.size = sz
	r.color = col
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


func _make_label(pos: Vector2, font_size: int) -> Label:
	var l := Label.new()
	l.position = pos
	l.add_theme_font_size_override("font_size", font_size)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l
