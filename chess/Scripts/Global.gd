extends Node

const CELL_WIDTH = 45

enum piece { NONE, KING, QUEEN, ROOK, BISHOP, KNIGHT, PAWN, WHITE = 8, BLACK = 16 }

enum enumSquare {
  a1, b1, c1, d1, e1, f1, g1, h1,
  a2, b2, c2, d2, e2, f2, g2, h2,
  a3, b3, c3, d3, e3, f3, g3, h3,
  a4, b4, c4, d4, e4, f4, g4, h4,
  a5, b5, c5, d5, e5, f5, g5, h5,
  a6, b6, c6, d6, e6, f6, g6, h6,
  a7, b7, c7, d7, e7, f7, g7, h7,
  a8, b8, c8, d8, e8, f8, g8, h8
}

# Bitboards for each piece type and color
var white_pawns: int = 0
var white_knights: int = 0
var white_bishops: int = 0
var white_rooks: int = 0
var white_queens: int = 0
var white_kings: int = 0

var black_pawns: int = 0
var black_knights: int = 0
var black_bishops: int = 0
var black_rooks: int = 0
var black_queens: int = 0
var black_kings: int = 0

# Combined bitboards
var all_pieces: int = 0
var white_pieces: int = 0
var black_pieces: int = 0

const BLACK_BISHOP = preload("res://Assets/black_bishop.svg")
const BLACK_KING = preload("res://Assets/black_king.svg")
const BLACK_KNIGHT = preload("res://Assets/black_knight.svg")
const BLACK_PAWN = preload("res://Assets/black_pawn.svg")
const BLACK_QUEEN = preload("res://Assets/black_queen.svg")
const BLACK_ROOK = preload("res://Assets/black_rook.svg")
const WHITE_BISHOP = preload("res://Assets/white_bishop.svg")
const WHITE_KING = preload("res://Assets/white_king.svg")
const WHITE_KNIGHT = preload("res://Assets/white_knight.svg")
const WHITE_PAWN = preload("res://Assets/white_pawn.svg")
const WHITE_QUEEN = preload("res://Assets/white_queen.svg")
const WHITE_ROOK = preload("res://Assets/white_rook.svg")

var pos1 : Vector2i
var pos2 : Vector2i

func pieceSprite(pieceType: int) -> Texture:
	var sprite : Texture
	match pieceType:
		piece.KING | piece.WHITE: sprite = WHITE_KING
		piece.QUEEN | piece.WHITE: sprite = WHITE_QUEEN
		piece.ROOK | piece.WHITE: sprite = WHITE_ROOK
		piece.BISHOP | piece.WHITE: sprite = WHITE_BISHOP
		piece.KNIGHT | piece.WHITE: sprite = WHITE_KNIGHT
		piece.PAWN | piece.WHITE: sprite = WHITE_PAWN
		piece.KING | piece.BLACK: sprite = BLACK_KING
		piece.QUEEN | piece.BLACK: sprite = BLACK_QUEEN
		piece.ROOK | piece.BLACK: sprite = BLACK_ROOK
		piece.BISHOP | piece.BLACK: sprite = BLACK_BISHOP
		piece.KNIGHT | piece.BLACK: sprite = BLACK_KNIGHT
		piece.PAWN | piece.BLACK: sprite = BLACK_PAWN
	return sprite

func resetBitBoards() -> void:
	white_pawns = 0
	white_knights = 0
	white_bishops = 0
	white_rooks = 0
	white_queens = 0
	white_kings = 0
	black_pawns = 0
	black_knights = 0
	black_bishops = 0
	black_rooks = 0
	black_queens = 0
	black_kings = 0

func update_bitboard_from_fen(symbol: int, bit: int) -> void:
	match symbol:
		piece.KING | piece.WHITE: white_kings |= bit
		piece.QUEEN | piece.WHITE: white_queens |= bit
		piece.ROOK | piece.WHITE: white_rooks |= bit
		piece.BISHOP | piece.WHITE: white_bishops |= bit
		piece.KNIGHT | piece.WHITE: white_knights |= bit
		piece.PAWN | piece.WHITE: white_pawns |= bit
		piece.KING | piece.BLACK: black_kings |= bit
		piece.QUEEN | piece.BLACK: black_queens |= bit
		piece.ROOK | piece.BLACK: black_rooks |= bit
		piece.BISHOP | piece.BLACK: black_bishops |= bit
		piece.KNIGHT | piece.BLACK: black_knights |= bit
		piece.PAWN | piece.BLACK: black_pawns |= bit
	
	white_pieces = white_pawns | white_knights | white_bishops | white_rooks | white_queens | white_kings
	black_pieces = black_pawns | black_knights | black_bishops | black_rooks | black_queens | black_kings
	all_pieces = white_pieces | black_pieces
	pass

func update_bitboards(newPosition: Vector2i, selectedPiece: Vector2i):
	var old_position : int = 1 << ((8 - selectedPiece.y)*8 + selectedPiece.x - 1)
	var new_position : int = 1 << ((8 - newPosition.y)*8 + newPosition.x - 1)
	
	var pieceMoved : int = remove_piece_from_position(old_position)
	
	remove_piece_from_position(new_position)
	
	move_piece_to_new_location(pieceMoved, new_position)
	
	pass

func remove_piece_from_position(old_position: int) -> int:
	var pieceColour: int
	var pieceType: int
	if old_position & white_pieces == old_position:
		pieceColour = piece.WHITE
		if old_position & white_kings == old_position:
			white_kings ^= old_position
			pieceType = piece.KING
		elif old_position & white_queens == old_position:
			white_queens ^= old_position
			pieceType = piece.QUEEN
		elif old_position & white_rooks == old_position:
			white_rooks ^= old_position
			pieceType = piece.ROOK
		elif old_position & white_bishops == old_position:
			white_bishops ^= old_position
			pieceType = piece.BISHOP
		elif old_position & white_knights == old_position:
			white_knights ^= old_position
			pieceType = piece.KNIGHT
		else:
			white_pawns ^= old_position
			pieceType = piece.PAWN
	else:
		pieceColour = piece.BLACK
		if old_position & black_kings == old_position:
			black_kings ^= old_position
			pieceType = piece.KING
		elif old_position & black_queens == old_position:
			black_queens ^= old_position
			pieceType = piece.QUEEN
		elif old_position & black_rooks == old_position:
			black_rooks ^= old_position
			pieceType = piece.ROOK
		elif old_position & black_bishops == old_position:
			black_bishops ^= old_position
			pieceType = piece.BISHOP
		elif old_position & black_knights == old_position:
			black_knights ^= old_position
			pieceType = piece.KNIGHT
		else:
			black_pawns ^= old_position
			pieceType = piece.PAWN
	
	return pieceColour | pieceType

func move_piece_to_new_location(pieceMoved, newPosition):
	match pieceMoved:
		piece.KING | piece.WHITE: white_kings |= newPosition
		piece.QUEEN | piece.WHITE: white_queens |= newPosition
		piece.ROOK | piece.WHITE: white_rooks |= newPosition
		piece.BISHOP | piece.WHITE: white_bishops |= newPosition
		piece.KNIGHT | piece.WHITE: white_knights |= newPosition
		piece.PAWN | piece.WHITE: white_pawns |= newPosition
		piece.KING | piece.BLACK: black_kings |= newPosition
		piece.QUEEN | piece.BLACK: black_queens |= newPosition
		piece.ROOK | piece.BLACK: black_rooks |= newPosition
		piece.BISHOP | piece.BLACK: black_bishops |= newPosition
		piece.KNIGHT | piece.BLACK: black_knights |= newPosition
		piece.PAWN | piece.BLACK: black_pawns |= newPosition
