extends Node

var economy: EconomyConfig
var rng := RngService.new()
var run_active: bool = false
var current_floor: int = 0

func _ready() -> void:
	economy = load("res://data/economy_config.tres")

func start_new_run(seed_value: int = 0) -> void:
	run_active = true
	current_floor = 1
	rng.set_run_seed(seed_value if seed_value != 0 else randi())
