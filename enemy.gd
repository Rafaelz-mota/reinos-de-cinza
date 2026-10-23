extends Node2D
## Inimigo simples: persegue o jogador e causa dano ao encostar.

var max_hp := 18.0
var hp := 18.0
var speed := 80.0
var damage := 6.0
var xp_value := 1
var target

var _hit_cd := 0.0
var _flash := 0.0


func _ready() -> void:
	add_to_group("enemies")


func _process(delta: float) -> void:
	_flash = maxf(0.0, _flash - delta)
	if target == null or not is_instance_valid(target) or target.dead:
		queue_redraw()
		return

	var to_player: Vector2 = target.position - position
	if to_player.length() > 30.0:
		position += to_player.normalized() * speed * delta
	else:
		_hit_cd -= delta
		if _hit_cd <= 0.0:
			_hit_cd = 0.8
			target.take_damage(damage)
	queue_redraw()


func take_damage(amount: float) -> void:
	hp -= amount
	_flash = 0.1
	if hp <= 0.0:
		if target != null and is_instance_valid(target):
			target.on_kill(xp_value)
		queue_free()


func _draw() -> void:
	var col := Color(0.9, 0.25, 0.25)
	if _flash > 0.0:
		col = Color(1, 1, 1)
	draw_circle(Vector2.ZERO, 14.0, col)
	draw_arc(Vector2.ZERO, 14.0, 0.0, TAU, 24, Color(0.35, 0.05, 0.05), 2.0)
	# Barra de vida.
	var w := 30.0
	draw_rect(Rect2(-w / 2.0, -26.0, w, 4.0), Color(0, 0, 0, 0.6))
	draw_rect(Rect2(-w / 2.0, -26.0, w * clampf(hp / max_hp, 0.0, 1.0), 4.0), Color(0.3, 0.9, 0.4))
