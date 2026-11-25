extends RefCounted
class_name ChipWallet

var starting_chips : int
var current_chips : int
enum Result {OK, INVALID_AMOUNT, INSUFFICIENT_FUNDS}

func _init(config : EconomyConfig) -> void:
	starting_chips = GameSession.economy.starting_chips
	current_chips = starting_chips

func credit(amount : int) -> Result: #add chips to wallet hehe
	if amount <= 0 :
		return Result.INVALID_AMOUNT
	current_chips += amount
	return Result.OK

func debit(amount : int) -> Result : #remove chips from wallet to MY (dev) wallet
	if amount <= 0:
		return Result.INVALID_AMOUNT
	if amount > current_chips:
		return Result.INSUFFICIENT_FUNDS
	current_chips -= amount
	return Result.OK

func get_chip() -> int:
	return current_chips
