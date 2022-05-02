local dlg = nil
local highlights = {}
local highlights_string = ''
local input = nil
local item = nil

local highlights_list = nil
local file_name = ''
local path = nil

-- VLC FUNCTIONS

function descriptor()
	return {
		title = "Highlights";
		version = "0.0.1";
		author = "Tom Allen";
		url = 'https://github.com/tswallen/vlc-highlights';
		shortdesc = "Highlights: set time highlights in files.";
		description = "Highlights will let you set highlights in your files and save them as .m3u files for later.";
		capabilities = {"menu", "input-listener"}
	}
end

function activate()
	input = vlc.object.input()
	item = vlc.input.item()
	file_name = item:metas()['filename']
	uri = item:uri()
	path = vlc.strings.make_path(uri)
	dlg = vlc.dialog('Highlights')
	init_dialog()
	dlg:show()
end

function close()
    vlc.deactivate()
end

function deactivate()
    if dlg then
        dlg:hide()
    end
end

-- INITIALISATION

function init_dialog()
	if item then
		dlg:add_label('Current file: ' .. file_name)
		dlg:add_label('Current URI: ' .. uri)
		dlg:add_label('Current path: ' .. path)
		dlg:add_button('Play/Pause', play_pause)
		dlg:add_button('Add start', add_start)
		dlg:add_button('Add stop', add_stop)
		dlg:add_button('Save file', save_file)
		highlights_list = dlg:add_list(2, 2, 1, 14)
	else
		dlg:add_label('Please open a file to use this extension.')
	end
end

-- FUNCTIONS

function play_pause()
	vlc.playlist.pause()
end

function add_start()
	start_string = '#EXTVLCOPT:start-time=' .. get_current_time()
	highlights_list:add_value(start_string)
	highlights_string = highlights_string .. start_string .. ' \n'
end

function add_stop()
	stop_string = '#EXTVLCOPT:stop-time=' .. get_current_time()
	highlights_list:add_value(stop_string)
	highlights_list:add_value(file_name)
	highlights_string = highlights_string .. stop_string .. ' \n'
	highlights_string = highlights_string .. file_name .. ' \n'
end

function save_file()
	os.execute('echo "' .. highlights_string .. '" > ~/Videos/test.m3u')
end

-- UTILS

function get_current_time()
	current_time_milliseconds = vlc.var.get(input, 'time')
	current_time_milliseconds = current_time_milliseconds * 0.000001
    return math.floor(current_time_milliseconds+0.5)
end

function set_highlights_string()
	for k, highlight in highlights_list:get_selection() do highlights_string = highlights_string .. highlight .. ' \n' end
	--for k, highlight in pairs(highlights) do highlights_string = highlights_string .. highlight .. '/n' end
	for index, highlight in pairs(highlights) do highlights_list:add_value(highlight, index) end
end