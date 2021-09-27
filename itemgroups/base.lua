ITEMGROUP.Base = 'base'
ITEMGROUP.Name = 'lualoader.base'
ITEMGROUP.BackgroundTexture = 'items.png'
ITEMGROUP.DrawTitle = true
ITEMGROUP.HasSearchBar = false

--[[
    Call when creating an itemgroup
]]
function ITEMGROUP:Init() end

--[[
    Call when itemgroup refresh
]]
function ITEMGROUP:OnReloaded() end

function ITEMGROUP:CreateIcon()
    return Blocks.PEONY
end

function ITEMGROUP:DrawInForegroundOfTab()
    return self.DrawTitle
end

--[[
    Gets the width of the search bar of the creative tab, use this if your
    creative tab name overflows together with a custom texture.
    
    @return The width of the search bar, 89 by default
]]
function ITEMGROUP:GetSearchbarWidth()
    return 89
end

function ITEMGROUP:GetBackgroundImage()
    return new.ResourceLocation('textures/gui/container/creative_inventory/tab_'..self.BackgroundTexture)
end

function ITEMGROUP:GetTabsImage()
    return new.ResourceLocation('textures/gui/container/creative_inventory/tabs.png')
end

function ITEMGROUP:GetLabelColor()
    return 4210752
end

function ITEMGROUP:GetSlotColor()
    return -2130706433
end