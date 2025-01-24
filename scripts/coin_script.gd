extends StaticBody2D
@onready var area_2d: Area2D = $Area2D

@export var ascend_speed: float = 100.0  # Speed of the ascent in pixels per second
@export var ascend_height: float = 200.0  # Maximum height to ascend in pixels
@export var reset_delay: float = 3.0  # Time (in seconds) to reset after reaching height

var original_position: Vector2  # Store the starting position
var ascending: bool = false
var target_height: float = 0.0
var timer: float = 0.0

func _ready():
	original_position = global_position
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _process(delta: float):
	if ascending:
		if global_position.y > target_height:
			global_position.y -= ascend_speed * delta
		else:
			ascending = false
			timer = reset_delay
	elif timer > 0:
		timer -= delta
		if timer <= 0:
			reset_position()

func _on_body_entered():
	print("bubble")
	target_height = original_position.y - ascend_height
	ascending = true

func _on_body_exited():
	# Optional: Handle when the player leaves the platform
	pass

func reset_position():
	global_position = original_position
	ascending = false
