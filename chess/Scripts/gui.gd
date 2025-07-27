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
var selectedPiece : Vector2i
var moveState : bool = false
var slots : Array = []
var whiteTurn : bool = false
var start : bool = false
var hasColourChanged : bool = false

func _ready() -> void:
	make2dArray()
	createGraphicalBoard()
	LoadPositionFromFen(startFen)
	updatePosition(Vector2(0, 0))

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("LMB"):
		var temp = snapped(get_global_mouse_position() / CELL_WIDTH, Vector2(1, 1))
		if !moveState && ((whiteTurn && (piece_positions[8-temp.y][temp.x-1] < 16)) || (!whiteTurn && piece_positions[8-temp.y][temp.x-1] > 16)):
			if piece_positions[8 - temp.y][temp.x-1]:
				selectedPiece = temp
				moveState = true
		elif moveState:
			movePiece(temp)

func movePiece(newPosition: Vector2i):
	moveState = false
	piece_positions[8 - newPosition.y][newPosition.x-1] = piece_positions[8 - selectedPiece.y][selectedPiece.x-1]
	piece_positions[8 - selectedPiece.y][selectedPiece.x-1] = 0
	
	Global.update_bitboards(newPosition, selectedPiece)

	if start:
		slots[Global.pos1.y*8 + Global.pos1.x - 9].change_colour()
		slots[Global.pos2.y*8 + Global.pos2.x - 9].change_colour()
	
	updatePosition(newPosition)

func updatePosition(newPosition: Vector2i) -> void:
	if start:
		slots[selectedPiece.y*8 + selectedPiece.x - 9].change_colour()
		slots[newPosition.y*8 + newPosition.x - 9].change_colour()
		
		Global.pos1 = selectedPiece
		Global.pos2 = newPosition
	
	for child in grid.get_children():
		if child is Node2D:
			child.queue_free()
	
	for rank in range(RANKS):
		for file in range(FILES):
			add_piece(piece_positions[rank][file], Vector2(CELL_WIDTH*file, CELL_WIDTH*(7-rank)))
	
	whiteTurn = !whiteTurn
	start = true

func make2dArray():
	for rank in range(RANKS):
		piece_positions.append([])
		for file in range(FILES):
			piece_positions[rank].append(0)

func LoadPositionFromFen(fen: String) -> void:
	Global.resetBitBoards()
	
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
				var square_index = rank * 8 + file
				var bit = 1 << square_index
				
				Global.update_bitboard_from_fen(pieceType | pieceColour, bit)
				file += 1

func createGraphicalBoard():
	for file in range(FILES):
		for rank in range(RANKS):
			var isLightSquare : bool = (file + rank) % 2 == 0
			var squareColour : Color = lightCol if isLightSquare else darkCol
			DrawSquare(squareColour)

func DrawSquare(squareColor : Color):
	var slot_instance = SLOT.instantiate()
	slot_instance.color = squareColor
	slots.append(slot_instance)
	grid.add_child(slot_instance)

func add_piece(piece: int, piece_position: Vector2i):
	var piece_instance = PIECE.instantiate()
	piece_instance.load_texture(piece)
	piece_instance.position = piece_position
	grid.add_child(piece_instance)
