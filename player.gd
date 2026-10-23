extends Node2D
## Jogador: anda com o joystick (ou setas), ataca sozinho o inimigo mais próximo,
## ganha XP ao abater inimigos e sobe de nível.

signal died

var max_hp := 100.0
var hp := 100.0
var speed := 260.0
var level := 1
var xp := 0
var xp_next := 8
var kills := 0
var time_alive := 0.0
var attack_range := 230.0
var attack_damage := 10.0
var attack_cooldown := 0.55
var move_input := Vector2.ZERO
var dead := false

var _cd := 0.0
var _hurt_flash := 0.0
var _level_flash := 0.0
var _line_time := 0.0
var _target_pos := Vector2.ZERO


func _ready() -> void:
	var cam := Camera2D.new()
	cam.position_smoothing_enabled = true
	cam.position_smoothing_speed = 8.0
	add_child(cam)


func _process(delta: float) -> void:
	if dead:
		return
	time_alive += delta

	# Movimento: joystick na tela ou setas do teclado (para testar no PC).
	var dir := move_input
	var kb := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if kb != Vector2.ZERO:
		dir = kb
	position += dir * speed * delta

	# Regeneração lenta de vida.
	hp = minf(max_hp, hp + 1.0 * delta)

	# Ataque automático.
	_cd -= delta
	if _cd <= 0.0:
		var t = _nearest_enemy()
		if t != null:
			_target_pos = t.position
			_line_time = 0.08
			_cd = attack_cooldown
			t.take_damage(attack_damage)

	_hurt_flash = maxf(0.0, _hurt_flash - delta)
	_level_flash = maxf(0.0, _level_flash - delta)
	_line_time = maxf(0.0, _line_time - delta)
	queue_redraw()


func _nearest_enemy():
	var best = null
	var best_d := attack_range * attack_range
	for e in get_tree().get_nodes_in_group("enemies"):
		if e.is_queued_for_deletion():
			continue
		var d := position.distance_squared_to(e.position)
		if d <= best_d:
			best_d = d
			best = e
	return best


func take_damage(amount: float) -> void:
	if dead:
		return
	hp -= amount
	_hurt_flash = 0.15
	if hp <= 0.0:
		hp = 0.0
		dead = true
		died.emit()


func on_kill(xp_value: int) -> void:
	kills += 1
	xp += xp_value
	while xp >= xp_next:
		xp -= xp_next
		level += 1
		xp_next = 8 + level * 4
		max_hp += 10.0
		hp = max_hp
		attack_damage += 2.5
		attack_range += 4.0
		_level_flash = 0.6


func _draw() -> void:
	# Alcance do ataque (bem discreto).
	draw_arc(Vector2.ZERO, attack_range, 0.0, TAU, 64, Color(1, 1, 1, 0.07), 2.0)

	if _line_time > 0.0:
		draw_line(Vector2.ZERO, _target_pos - position, Color(1.0, 0.9, 0.4), 3.0)

	if _level_flash > 0.0:
		var a := _level_flash / 0.6
		draw_arc(Vector2.ZERO, 34.0 + (1.0 - a) * 30.0, 0.0, TAU, 48, Color(1.0, 0.85, 0.3, a), 4.0)

	var body := Color(0.35, 0.65, 1.0)
	if dead:
		body = Color(0.4, 0.4, 0.45)
	elif _hurt_flash > 0.0:
		body = Color(1, 1, 1)
	draw_circle(Vector2.ZERO, 18.0, body)
	draw_arc(Vector2.ZERO, 18.0, 0.0, TAU, 32, Color(0.1, 0.2, 0.4), 3.0)
