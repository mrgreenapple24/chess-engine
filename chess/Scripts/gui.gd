extends Control

const SLOT : PackedScene = preload("res://Scenes/slot.tscn")
const PIECE : PackedScene = preload("res://Scenes/piece.tscn")
@onready var grid : GridContainer = $ChessBoard/GridContainer

const CELL_WIDTH : int = 45
const RANKS : int = 8
const FILES : int = 8
const startFen : String = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq − 0 1"

enum piece_type { NONE, KING, QUEEN, ROOK, BISHOP, KNIGHT, PAWN, WHITE = 8, BLACK = 16 }
var piece_positions : Array = []
var lightCol = Color8(238,238,210)
var darkCol = Color8(118,150,86)

func _ready() -> void:
	make2dArray()
	createGraphicalBoard()
	LoadPositionFromFen(startFen)
	updatePosition()

func updatePosition() -> void:
	for rank in range(RANKS):
		for file in range(FILES):
			add_piece(piece_positions[rank][file], Vector2(CELL_WIDTH*file, CELL_WIDTH*(7-rank)))
	pass

func make2dArray():
	for rank in range(RANKS):
		piece_positions.append([])
		for FILE in range(FILES):
			piece_positions[rank].append(0)

func LoadPositionFromFen(fen: String) -> void:
	var pieceTypeFromSymbol : Dictionary = {
		'k' = piece_type.KING, 'p' = piece_type.PAWN, 'q' = piece_type.QUEEN,
		'r' = piece_type.ROOK, 'n' = piece_type.KNIGHT, 'b' = piece_type.BISHOP
	}
	
	var fenBoard : String = fen.split(" ")[0]
	var file: int = 0
	var rank: int = 7
	
	for symbol in fenBoard:
		if symbol == '/':
			file = 0
			rank -= 1
		else:
			if symbol.is_valid_int():
				file += symbol.to_int()
			else:
				var pieceColour : int = piece_type.WHITE if symbol.to_upper() == symbol else piece_type.BLACK
				var pieceType: int  = pieceTypeFromSymbol[symbol.to_lower()]
				piece_positions[rank][file] = pieceType | pieceColour
				file += 1
	pass

func createGraphicalBoard():
	for file in range(FILES):
		for rank in range(RANKS):
			var isLightSquare : bool = (file + rank) % 2 == 0
			var squareColour : Color = lightCol if isLightSquare else darkCol
			var SquarePosition = Vector2(CELL_WIDTH/2 * file, CELL_WIDTH/2 * rank)
			DrawSquare(squareColour, SquarePosition)

func DrawSquare(squareColor : Color, SquarePosition: Vector2):
	var slot_instance = SLOT.instantiate()
	slot_instance.color = squareColor
	slot_instance.position = SquarePosition
	grid.add_child(slot_instance)

func add_piece(piece: int, piece_position: Vector2):
	var piece_instance = PIECE.instantiate()
	piece_instance.load_texture(piece)
	piece_instance.position = piece_position
	grid.add_child(piece_instance)
