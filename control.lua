local event = require("__flib__.event")

local function search_chunk(surface, chunk, player)
    local chunkCoords = chunk.area.left_top
    if surface.get_pollution({chunkCoords.x, chunkCoords.y}) <= 0 then
        return false
    end

    local pollutedEntities = surface.find_entities_filtered {
        area = chunk.area,
        type = "unit-spawner"
    }
    if #pollutedEntities <= 0 then return false end

    player.force.add_chart_tag(surface, {
        position = pollutedEntities[1].position,
        icon = {type = "virtual", name = "signal-red"},
        text = "[entity=spitter-spawner]",
        last_user = player
    })
    return true
end

event.on_lua_shortcut(function(e)
    if e.prototype_name == "biter-finder" then
        local player = game.get_player(e.player_index)
        local surface = player.surface
        local found = false
        for chunk in surface.get_chunks() do
            found = search_chunk(surface, chunk, player) or found
        end

        if found then
            player.add_custom_alert(player.character,
                                    {type = "virtual", name = "signal-red"},
                                    {"biter-finder-spawners-found"}, true)
        end
    end
end)
