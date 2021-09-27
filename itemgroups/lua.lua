ITEMGROUP.Base = 'base'
ITEMGROUP.Name = 'lualoader.lua'
ITEMGROUP.BackgroundTexture = 'item_search.png'
ITEMGROUP.GroupName = 'Lua'
ITEMGROUP.HasSearchBar = true

function ITEMGROUP:CreateIcon()
    return MAPI.GetLuaItem('lua'):get()
end