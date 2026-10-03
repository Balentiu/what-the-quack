extends CharacterBody2D

@export_group("Movement Stats")
@export var speed: float = 380.0
@export var max_hp: float = 100.0
var current_hp: float = 100.0

@export_group("Brotato Wobble Animation")
@export var wobble_speed: float = 18.0
@export var wobble_angle: float = 0.16
@export var squash_amount: float = 0.14

var wobble_time: float = 0.0

@onready var visuals: Node2D = $Visuals
@onready var duck_body: Sprite2D = $Visuals/DuckBody
@onready var hat_slot: Sprite2D = $Visuals/HatSlot
@onready var accessory_slot: Sprite2D = $Visuals/AccessorySlot
@onready var water_trail: GPUParticles2D = $WaterTrail

func _ready() -> void:
	current_hp = max_hp
	add_to_group("player")

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	if direction.x != 0:
		visuals.scale.x = sign(direction.x)
	
	if direction.length() > 0:
		water_trail.emitting = true
		wobble_time += delta * wobble_speed
		visuals.rotation = sin(wobble_time) * wobble_angle
		var bounce = abs(cos(wobble_time)) * squash_amount
		visuals.scale.y = 1.0 - bounce
	else:
		water_trail.emitting = false
		wobble_time = 0.0
		visuals.rotation = lerp(visuals.rotation, 0.0, delta * 15.0)
		visuals.scale.y = lerp(visuals.scale.y, 1.0, delta * 15.0)

func equip_cosmetics(skin_tex: Texture2D, hat_tex: Texture2D, acc_tex: Texture2D) -> void:
	if skin_tex:
		duck_body.texture = skin_tex
	hat_slot.texture = hat_tex
	accessory_slot.texture = acc_tex
