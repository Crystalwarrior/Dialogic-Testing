extends ColorRect

func can_drop_data(position, data):
	# Check position if it is relevant to you
	# Otherwise, just check data
	return typeof(data) == TYPE_DICTIONARY and data.has("name")

func drop_data(position, data):
	print('Presenting evidence ' + data["name"])