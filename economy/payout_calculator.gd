extends RefCounted
class_name PayoutCalculator

static func gross_payout(stake: int, multiplier: float) -> int:
	if stake <= 0:
		return 0
	if multiplier <= 0:
		return 0
	var int_mult : int = roundi(multiplier * 100)
	return floor_div(stake * int_mult, 100)

static func net_profit(gross_payout: int, stake: int) -> int:
	#Net = Gross - Stake
	var net = gross_payout - stake
	return net

static func floor_div(a: int, b: int) -> int:
	if a < 0:
		a = 0
	if b <= 0:
		return 0
	return a / b
	
	
	
	
	
