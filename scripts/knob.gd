extends Node2D

# Variables for rotation and player tracking
var rotating = false
var player_on_handle = null
var rotation_speed = 0.0

# Timer duration (adjust as needed)
@export var rotation_stop_delay = 1.0

# Called when a player enters a handle
func _on_handle_body_entered(body: Area2D) -> void:
	if body.name == "player":  # Ensure we're working with the correct player node
		player_on_handle = body
		print("entered")
		calculate_rotation_speed(body.global_position)
		rotating = true
		$Timer.stop()  # Stop any active timer if the player enters again

# Called when a player exits a handle
func _on_handle_body_exited(body: Area2D) -> void:
	if body.name == "player":
		print("exited")
		player_on_handle = null
		rotating = false
		$Timer.start(rotation_stop_delay)  # Start the timer to stop rotation

# Calculate rotation speed based on player distance from the center
func calculate_rotation_speed(player_position: Vector2) -> void:
	var center_position = $CentralScrew.global_position
	var distance = player_position.distance_to(center_position)
	
	# Scale rotation speed based on distance, normalize to avoid extreme speeds
	rotation_speed = clamp(distance / 100.0, 0.1, 3.0)

# Rotate the knob when the player is on a handle
func _process(delta: float) -> void:
	if rotating and player_on_handle:
		self.rotation += rotation_speed * delta  # Rotate the knob

# Stop rotation when the timer times out
func _on_Timer_timeout() -> void:
	rotating = false

# Handle right handle signals
func _on_right_handle_area_entered(area: Area2D) -> void:
	if area.name == "player":
		_on_handle_body_entered(area)

func _on_right_handle_area_exited(area: Area2D) -> void:
	if area.name == "player":
		_on_handle_body_exited(area)

# Handle top handle signals
func _on_top_handle_area_entered(area: Area2D) -> void:
	if area.name == "player":
		_on_handle_body_entered(area)

func _on_top_handle_area_exited(area: Area2D) -> void:
	if area.name == "player":
		_on_handle_body_exited(area)

# Handle left handle signals
func _on_left_handle_area_entered(area: Area2D) -> void:
	if area.name == "player":
		_on_handle_body_entered(area)

func _on_left_handle_area_exited(area: Area2D) -> void:
	if area.name == "player":
		_on_handle_body_exited(area)

# Handle bottom handle signals
func _on_bottom_handle_area_entered(area: Area2D) -> void:
	if area.name == "player":
		_on_handle_body_entered(area)

func _on_bottom_handle_area_exited(area: Area2D) -> void:
	if area.name == "player":
		_on_handle_body_exited(area)
