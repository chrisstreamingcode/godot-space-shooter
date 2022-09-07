extends Area2D

signal ship_hit
signal fire_rate_powerup
signal health_powerup

var screen_size
var ship_size
var can_fire = true
var ship_speed = 400

func _ready():
	screen_size = get_viewport_rect().size	
	ship_size = $ShipSize.shape.extents


func _process(delta):
	move_ship(delta)
	
	
func move_ship(delta):
	var velocity = Vector2.ZERO
	
	if (Input.is_action_pressed("ship_left")):
		velocity.x -= 1
	if (Input.is_action_pressed("ship_right")):
		velocity.x += 1
	if (Input.is_action_pressed("ship_up")):
		velocity.y -= 1
	if (Input.is_action_pressed("ship_down")):
		velocity.y += 1
		
	velocity = velocity.normalized() * ship_speed
			
	position += velocity * delta
	
	position.x = clamp(position.x, ship_size.x, screen_size.x - ship_size.x)
	position.y = clamp(position.y, (screen_size.y / 2) + ship_size.y, screen_size.y - ship_size.y)


func _on_Ship_body_entered(body):
	emit_signal("ship_hit")
	body.emit_signal("body_entered", self)


func _on_Ship_area_entered(area):
	if area.is_in_group("fire_rate_powerup"):
		emit_signal("fire_rate_powerup")
	elif area.is_in_group("health_powerup"):
		emit_signal("health_powerup")
