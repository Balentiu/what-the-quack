extends Area2D

@export var speed: float = 600.0
@export var damage: float = 15.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage, transform.x)
		queue_free()
