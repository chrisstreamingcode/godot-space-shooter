extends CanvasLayer

signal new_game
signal game_over

const ENEMY_MIN_SPEED = 200
const ENEMY_MAX_SPEED = 800
const MAX_LIVES = 6

const FIRE_RATE = .333
const FAST_FIRE_RATE = .1666

export(PackedScene) var enemy_scene
export(PackedScene) var laser_scene
export(PackedScene) var health_scene
export(PackedScene) var battery_scene

var score
var lives

var can_fire

func _ready():
	randomize()
	
	
func new_game():
	score = 0
	lives = 4
	can_fire = true
	
	$FireRateTimer.wait_time = FIRE_RATE
	
	$FireRateTimer.start()
	$EnemySpawnTimer.start()
	$PowerUpSpawnTimer.start()
	update_lives()
	update_score()


func _process(delta):
	try_fire()


func update_score(change = 0):
	score += change
	
	$HUD.emit_signal("set_score", score)
	

func update_lives(change = 0):
	lives = clamp(lives + change, 0, MAX_LIVES)
	
	if lives <= 0:
		$FireRateTimer.stop()
		$EnemySpawnTimer.stop()
		$PowerUpSpawnTimer.stop()
	
		get_tree().call_group("bullets", "queue_free")
		get_tree().call_group("enemies", "queue_free")
		get_tree().call_group("powerups", "queue_free")
		
		emit_signal("game_over", score)
	else:
		$HUD.emit_signal("set_lives", lives)
		
	
func try_fire():
	if not can_fire or not Input.is_action_pressed("ship_fire"): return
	
	var laser = laser_scene.instance()
	laser.position = $Ship.position - Vector2(0, 40)
	
	add_child(laser)
	move_child(laser, $Ship.get_index())
	
	laser.connect("enemy_hit", self, "_on_Laser_enemy_hit")
	laser.add_to_group("bullets")
	
	can_fire = false
	
func _on_Laser_enemy_hit():
	update_score(50)
	

func _on_FireRateTimer_timeout():
	can_fire = true


func _on_EnemySpawnTimer_timeout():
	var enemy = enemy_scene.instance()
	
	$EnemyPath/EnemySpawnLocation.offset = randi()
	
	enemy.position = $EnemyPath/EnemySpawnLocation.position
	enemy.linear_velocity = Vector2(0, rand_range(ENEMY_MIN_SPEED, ENEMY_MAX_SPEED))
	
	enemy.add_to_group("enemies")
	
	add_child(enemy)


func _on_Ship_ship_hit():
	update_lives(-1)
	
func _on_Ship_fire_rate_powerup():
	$FireRateTimer.wait_time = FAST_FIRE_RATE
	$FireRatePowerUpTimer.start()


func _on_Ship_health_powerup():
	update_lives(1)


func _on_FireRatePowerUpTimer_timeout():
	$FireRateTimer.wait_time = FIRE_RATE


func _on_PowerUpSpawnTimer_timeout():
	var powerup = battery_scene.instance() if randi() % 2 else health_scene.instance()
	
	powerup.position = Vector2(
		rand_range($PowerUpSpawnStart.position.x, $PowerUpSpawnEnd.position.x),
		rand_range($PowerUpSpawnStart.position.y, $PowerUpSpawnEnd.position.y)
	)
	
	powerup.add_to_group("powerups")
	add_child(powerup)
