extends RefCounted
class_name BetRequestValidator

enum Result {OK, WRONG_TABLE, UNKNOWN_BET}

func validate(table : TableDefinition , bet_req : BetRequest) -> Result:
	if bet_req.table_id != table.id:
		return Result.WRONG_TABLE
	if table.find_bet(bet_req.bet_type) == null:
		return Result.UNKNOWN_BET
	return Result.OK
