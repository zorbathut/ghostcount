require("mod-gui")
function init_gui(player)
	if mod_gui.get_button_flow(player).ghostCountGUI~=nil then
		mod_gui.get_button_flow(player).ghostCountGUI.destroy()
	end
	mod_gui.get_button_flow(player).add
	{
	type = "sprite-button",
	name = "ghostCountGUI",
	sprite = "ghostCountSprite",
	tooltip="Count ghosts on the map",
	style = mod_gui.button_style
	}
end

function count_ghosts(player)
	local count={}
	local test={}
	for c in game.surfaces[1].get_chunks() do
		for key, ent in pairs(game.surfaces[1].find_entities_filtered({area={{c.x * 32, c.y * 32}, {c.x * 32 + 32, c.y * 32 + 32}}, type="entity-ghost"})) do
			if count[ent.ghost_name]==nil then
				count[ent.ghost_name]=1
			else
				count[ent.ghost_name]=count[ent.ghost_name]+1
			end
		end
	end
	return count
end

function main_button(player)
	if player.gui.left.gcFrame~=nil then
		player.gui.left.gcFrame.destroy()
	else
		gcFrame=player.gui.left.add({type = "frame",name = "gcFrame", direction = "horizontal"})
		gcScroll=gcFrame.add({type = "scroll-pane", name = "gcScroll", vertical_scroll_policy = "auto"})
		gcScroll.style.maximal_height = 400
		gcTable=gcScroll.add({type = "table", colspan=2,name = "gcTable", direction = "vertical"})
		updateGUI(player)
	end
end

function updateGUI(player)
	gcTable=player.gui.left.gcFrame.gcScroll.gcTable
	gcTable.clear()
	gcTable.add({type="label",name="col1",caption="Item"})
	gcTable.add({type="label",name="col2",caption="#"})
	c=count_ghosts(player)
	for k,v in spairs(c, function(t,a,b) return t[b] < t[a] end) do
		gcTable.add({type="sprite",name=k,sprite="entity/"..k, caption=v})
		gcTable.add({type="label",name=k.."-count", caption=v})
	end
end

function spairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

script.on_event(defines.events.on_player_created, function(event)
    init_gui(game.players[event.player_index])
end)
script.on_event(defines.events.on_gui_click, function(event)
 	if event.element.name=="ghostCountGUI" then
    	main_button(game.players[event.player_index])
    end
end)
script.on_event(defines.events.on_tick, function(event)
    if event.tick % (60*settings.global["ghost-count-refresh"].value) == 0  then
        for index,player in pairs(game.players) do
			if player.gui.left.gcFrame~=nil then
				updateGUI(player)
			end
        end
    end
end)
script.on_init(function()
	for _,player in pairs(game.players) do
        init_gui(player)
    end
end)