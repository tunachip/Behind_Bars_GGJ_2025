extends StaticBody2D
@onready var ascending_object: StaticBody2D = $"."
@onready var area_2d: Area2D = $Area2D
@onready var puddle: Sprite2D = $Area2D/puddle

@export var ascend_speed: float = 40.0  # Speed of the ascent in pixels per second
@export var ascend_height: float = 250.0  # Maximum height to ascend in pixels
@export var reset_delay: float = 3.0  # Time (in seconds) to reset after reaching height

var bubble_active: bool = false

var original_position: Vector2  # Store the starting position
var ascending: bool = false
var target_height: float = 0.0
var timer: float = 0.0

func _ready():
	original_position = global_position
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.body_exited.connect(_on_area_2d_body_exited)

func _process(delta: float):
	if ascending:
		$Area2D/puddle.visible = false
		if global_position.y > target_height:
			global_position.y -= ascend_speed * delta
		else:
			ascending = false
			timer = reset_delay
	elif timer > 0:
		timer -= delta
		if timer <= 0:
			reset_position()

func reset_position():
	global_position = original_position
	ascending = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player" and bubble_active == true:
		ascending = false
		timer = reset_delay
	else:
		pass

func _on_area_2d_body_exited(body: Node2D) -> void:
	if bubble_active == false:
		print("bubble")
		bubble_active = true
		target_height = original_position.y - ascend_height
		ascending = true
	elif body.name == "player" and bubble_active == true:
		$Area2D/puddle.visible = true
		reset_position()
		bubble_active = false
