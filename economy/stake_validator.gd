extends RefCounted
class_name StakeValidator


enum Result {OK, NOT_INTEGER, BELOW_MINIMUM, EXCEEDS_BALANCE}


func check_stake(stake : Variant,wallet : ChipWallet, config : EconomyConfig) -> Result:
	if typeof(stake) != TYPE_INT:
		return Result.NOT_INTEGER
	if stake < config.minimum_bet:
		return Result.BELOW_MINIMUM
	if stake > wallet.current_chips:
		return Result.EXCEEDS_BALANCE
	return Result.OK

static func max_bet(chips: int, nerve: int) -> int:
	if chips <= 0:
		return 0
	var n: int = maxi(nerve, 0)
	var mb: int = chips * (30 + n) / 200
	return mini(mb, chips)
