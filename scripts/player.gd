extends CharacterBody2D

@export_group("Movement Stats")
@export var speed: float = 500.0
@export var max_hp: float = 100.0
var current_hp: float = 100.0

@export_group("Up-Down Animation")
@export var idle_bounce_speed: float = 7.0
@export var idle_squash: float = 0.15
@export var move_bounce_speed: float = 12.0
@export var move_squash: float = 0.3
@export var jump_height: float = 9.0
@export var leg_swing_amount: float = 12.0



var anim_time: float = 0.0
var current_facing: float = 1.0

@onready var visuals: Node2D = $Visuals
@onready var duck_body: Sprite2D = $Visuals/DuckBody
@onready var hat_slot: Sprite2D = $Visuals/HatSlot
@onready var accessory_slot: Sprite2D = $Visuals/AccessorySlot
@onready var water_trail: GPUParticles2D = $WaterTrail
@onready var left_foot: Sprite2D = $Visuals/LeftFoot
@onready var right_foot: Sprite2D = $Visuals/RightFoot
var left_foot_start_x: float = 0.0
var right_foot_start_x: float = 0.0

func _ready() -> void:
	current_hp = max_hp
	add_to_group("player")
	visuals.rotation = 0.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	if direction.x != 0:
		current_facing = -sign(direction.x)
	
	if direction.length() > 0:
		water_trail.emitting = true
		anim_time += delta * move_bounce_speed
		
		var wave: float = abs(sin(anim_time))
		visuals.scale.y = 1.0 - (wave * move_squash)
		visuals.scale.x = current_facing * (1.0 + (wave * move_squash * 0.5))
		visuals.position.y = -wave * jump_height
		left_foot.position.x = sin(anim_time) * leg_swing_amount
		right_foot.position.x = -sin(anim_time) * leg_swing_amount
		if left_foot and right_foot:
			left_foot.position.x = left_foot_start_x + (sin(anim_time) * leg_swing_amount)
			right_foot.position.x = right_foot_start_x - (sin(anim_time) * leg_swing_amount)
	else:
		water_trail.emitting = false
		anim_time += delta * idle_bounce_speed
		
		var wave: float = (sin(anim_time) + 1.0) * 0.5 
		visuals.scale.y = 1.0 - (wave * idle_squash)
		visuals.scale.x = current_facing * (1.0 + (wave * idle_squash * 0.4))
		visuals.position.y = lerp(visuals.position.y, 0.0, delta * 15.0)
		left_foot.position.x = lerp(left_foot.position.x, -10.0, delta * 15.0)
		right_foot.position.x = lerp(right_foot.position.x, 10.0, delta * 15.0)
		if left_foot and right_foot:
			left_foot.position.x = lerp(left_foot.position.x, left_foot_start_x, delta * 15.0)
			right_foot.position.x = lerp(right_foot.position.x, right_foot_start_x, delta * 15.0)

func equip_cosmetics(skin_tex: Texture2D, hat_tex: Texture2D, acc_tex: Texture2D) -> void:
	if skin_tex:
		duck_body.texture = skin_tex
	hat_slot.texture = hat_tex
	accessory_slot.texture = acc_tex
