extends Node2D

@export var projectile_scene: PackedScene
@export var attack_range: float = 400.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var muzzle: Marker2D = $Sprite2D/Muzzle
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_shoot)

func _physics_process(_delta: float) -> void:
	var closest_enemy = _get_closest_enemy()
	
	if closest_enemy != null:
		look_at(closest_enemy.global_position)
		
		if closest_enemy.global_position.x < global_position.x:
			sprite.flip_v = true
		else:
			sprite.flip_v = false

func _get_closest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest: Node2D = null
	var min_dist = attack_range
	
	for enemy in enemies:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < min_dist:
			min_dist = dist
			closest = enemy
			
	return closest

func _shoot() -> void:
	var closest_enemy = _get_closest_enemy()
	
	if closest_enemy != null and projectile_scene != null:
		var proj = projectile_scene.instantiate()
		get_tree().current_scene.add_child(proj)
		proj.global_transform = muzzle.global_transform
