class_name EconomyConfig
extends Resource

@export var starting_chips: int = 500
@export var minimum_bet: int = 10

#รางวัลหลังจบเกม
# พารามิเตอร์สูตร House Token (สูตรจริงอยู่ใน RewardManager ทีหลัง)
@export var chips_per_house_token: int = 100
@export var tokens_per_floor: int = 5
@export var tokens_per_boss: int = 3

func validate() -> Array[String]:
	var errors: Array[String] = []
	if minimum_bet < 1:
		errors.append("economy: minimum_bet must be >= 1")
	if starting_chips < minimum_bet:
		errors.append("economy: starting_chips must be >= minimum_bet")
	if chips_per_house_token < 1:
		errors.append("economy: chips_per_house_token must be >= 1")
	return errors
