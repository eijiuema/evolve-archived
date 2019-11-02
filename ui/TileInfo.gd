extends RichTextLabel

var tile_info setget set_tile_info

func set_tile_info(tile_info):
	tile_info = tile_info
	text = \
		"Coordinate: " + str(tile_info['coordinate']) + "\n" \
	+	"Terrain: " + str(tile_info['terrain']) + "\n" \
	+	"Building: " + str(tile_info['building']) + "\n" \
	+	"Objects: " + str(tile_info['objects'])
	