extends RefCounted
class_name TransactionEntry

var bet_id: StringName
var stake: int
var outcome: Dictionary
var gross_payout: int
var net_profit: int

func _init(p_bet_id: StringName = &"", p_stake: int = 0, p_outcome: Dictionary = {}, p_gross_payout: int = 0, p_net_profit: int = 0) -> void:
	bet_id = p_bet_id
	stake = p_stake
	outcome = p_outcome
	gross_payout = p_gross_payout
	net_profit = p_net_profit

static func from_result(request: BetRequest, result: BetResult) -> TransactionEntry:
	return TransactionEntry.new(
		request.bet_id,
		request.stake,
		result.outcome,
		result.gross_payout,
		result.net_profit
		)
