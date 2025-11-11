@icon("res://assets/node_icons/map.png")
@tool
class_name Map
extends TileMapLayer


const NUM_TILES_IN_ROW = 8;

@export var map_size: Vector2 = Vector2(100, 100)

@export_tool_button(
	"Generate Map", 
	"TileMapLayer"
) var TOOL_generate_map := func() -> void: 
	self.clear()
	_init_noise()
	_generate_map()
@export_tool_button(
	"Clear Map",
	"Eraser"
) var TOOL_clear_map := func() -> void:
	self.clear()

@export_group("Noise")
@export var noise_type: FastNoiseLite.NoiseType = FastNoiseLite.NoiseType.TYPE_SIMPLEX
@export var noise_seed: int = 0
@export var fractal_gain: float = 0.5
@export var fractal_octaves: int = 1
@export var empty_tile_chance: float = 0.8

@export_tool_button(
	"Randomize Seed", 
	"RandomNumberGenerator"
) var TOOL_randomize_seed := func() -> void:
	noise_seed = randi()
@export_tool_button(
	"Randomize All",
	"AudioStreamRandomizer"
) var TOOL_randomize_all := func() -> void:
	noise_type = randi_range(0, 5) as FastNoiseLite.NoiseType
	noise_seed = randi()
	fractal_gain = randf_range(0, 200)
	fractal_octaves = randi_range(1, 20)

var noise := FastNoiseLite.new();


func _ready() -> void:
	_init_noise()
	
	if not Engine.is_editor_hint():
		_generate_map()


func _init_noise() -> void:
	noise.noise_type = noise_type
	noise.seed = noise_seed
	noise.fractal_gain = fractal_gain
	noise.fractal_octaves = fractal_octaves


func _generate_map() -> void:
	for x: int in map_size.x:
		for y: int in map_size.y:
			if randf_range(0.01, 1.00) <= empty_tile_chance:
				continue
			
			var noise_value: int = _parse_noise_value_at(x, y)
			var tile_set_coords := Vector2(noise_value % NUM_TILES_IN_ROW, noise_value / NUM_TILES_IN_ROW)
			self.set_cell(Vector2(x, y), 0, tile_set_coords)


func _parse_noise_value_at(x: int, y: int) -> int:
	## get_noise_2d is of range [-1, 1]...
	var noise_value := noise.get_noise_2d(x, y)
	## so remap() fits it to range [0, 23], which is our number of tiles in the set.
	var noise_value_remapped := remap(noise_value, -1, 1, 1, 23)
	## finally, the value is rounded to an integer.
	var noise_value_i := roundi(noise_value_remapped)
	
	return noise_value_i
