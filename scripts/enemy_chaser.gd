extends CharacterBody2D

@export var speed: float = 180.0
@export var max_hp: float = 30.0

var current_hp: float
var player: Node2D = null
var wobble_time: float = 0.0
var knockback_velocity: Vector2 = Vector2.ZERO

@onready var visuals: Node2D = $Visuals

func _ready() -> void:
	current_hp = max_hp
	add_to_group("enemies") 
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		if player == null:
			return
	
	var direction := global_position.direction_to(player.global_position)
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * 800.0)
	velocity = (direction * speed) + knockback_velocity
	move_and_slide()
	
	if direction.x != 0:
		visuals.scale.x = sign(direction.x)
	
	wobble_time += delta * 20.0
	visuals.scale.y = 1.0 - (abs(cos(wobble_time)) * 0.1)
	visuals.position.y = -abs(sin(wobble_time)) * 4.0

func take_damage(amount: float, knockback_dir: Vector2 = Vector2.ZERO) -> void:
	current_hp -= amount
	knockback_velocity = knockback_dir * 350.0
	
	if current_hp <= 0:
		queue_free()
