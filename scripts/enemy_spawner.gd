extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_radius: float = 700.0

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null or enemy_scene == null:
		return
		
	var enemy = enemy_scene.instantiate()
	var random_angle = randf() * PI * 2.0
	var spawn_pos = player.global_position + Vector2(cos(random_angle), sin(random_angle)) * spawn_radius
	
	enemy.global_position = spawn_pos
	get_tree().current_scene.add_child(enemy)
