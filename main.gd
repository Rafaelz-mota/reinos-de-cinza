extends Node2D
## Cena principal: cria jogador, HUD, gera inimigos e desenha o chão.

const PlayerScript := preload("res://scripts/player.gd")
const EnemyScript := preload("res://scripts/enemy.gd")
const HudScript := preload("res://scripts/hud.gd")

const GRID_STEP := 80
const GRID_HALF := 900

var player
var hud
var _elapsed := 0.0
var _spawn_cd := 1.0
var _game_over_shown := false


func _ready() -> void:
	randomize()
	RenderingServer.set_default_clear_color(Color(0.07, 0.08, 0.11))

	player = PlayerScript.new()
	add_child(player)

	hud = HudScript.new()
	hud.player = player
	add_child(hud)
	hud.joystick_moved.connect(_on_joystick_moved)
	hud.restart_requested.connect(_on_restart)


func _process(delta: float) -> void:
	queue_redraw()
	if player.dead:
		if not _game_over_shown:
			_game_over_shown = true
			hud.show_game_over()
		return

	_elapsed += delta
	_spawn_cd -= delta
	if _spawn_cd <= 0.0:
		_spawn_cd = maxf(0.25, 1.1 - _elapsed * 0.008)
		if get_tree().get_nodes_in_group("enemies").size() < 70:
			_spawn_enemy()


func _spawn_enemy() -> void:
	var e = EnemyScript.new()
	var angle := randf() * TAU
	e.position = player.position + Vector2.from_angle(angle) * 700.0
	var growth := 1.0 + _elapsed / 60.0
	e.max_hp = 18.0 * growth
	e.hp = e.max_hp
	e.speed = minf(170.0, 80.0 + _elapsed * 0.6) + randf_range(-10.0, 10.0)
	e.damage = 6.0 + _elapsed / 30.0
	e.target = player
	add_child(e)


func _on_joystick_moved(dir: Vector2) -> void:
	player.move_input = dir


func _on_restart() -> void:
	get_tree().reload_current_scene()


func _draw() -> void:
	# Grade de chão que acompanha o jogador, para dar sensação de movimento.
	var c: Vector2 = player.position
	var x0 := floorf((c.x - GRID_HALF) / GRID_STEP) * GRID_STEP
	var y0 := floorf((c.y - GRID_HALF) / GRID_STEP) * GRID_STEP
	var count := int(2.0 * GRID_HALF / GRID_STEP) + 2
	var col := Color(1, 1, 1, 0.05)
	for i in count:
		var x := x0 + i * GRID_STEP
		var y := y0 + i * GRID_STEP
		draw_line(Vector2(x, c.y - GRID_HALF), Vector2(x, c.y + GRID_HALF), col, 2.0)
		draw_line(Vector2(c.x - GRID_HALF, y), Vector2(c.x + GRID_HALF, y), col, 2.0)
