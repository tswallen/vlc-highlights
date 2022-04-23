local dialog = nil
local highlights = {}
local input = nil
local item = nil

local player = nil

local current_time = nil


function descriptor()
	return {
		title = "Highlights";
		version = "0.0.1";
		author = "Tom Allen";
		url = 'tba';
		shortdesc = "Highlights: set time highlights in files.";
		description = "Highlights will let you set highlights in your files and save them as .m3u files for later.";
		capabilities = {"menu", "input-listener"}
	}
end

function activate()
	input = vlc.object.input()
	item = vlc.input.item()
	dialog = vlc.dialog('Highlights')
	open_dialog()
end

function open_dialog()
	if item then
		dialog:add_label('You have a file.')
		dialog:add_label(get_current_time())
	else
		dialog:add_label('Please open a file to use this extension.')
	end
	dialog:show()
end

function close()
    vlc.deactivate()
end

function deactivate()
    if dialog then
        dialog:hide()
    end
end

function close()
	vlc.deactivate()
end

function play_pause()
	vlc.playlist.pause()
end

function get_current_time()
    return vlc.var.get(input, 'time')
end