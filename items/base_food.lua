ITEM.IsMeat = false
ITEM.FastToEat = false
ITEM.CanEatWhenFull = false
ITEM.Hunger = 0
ITEM.Saturation = 0
ITEM.FoodEffects = {}

function ITEM:OnItemRightClick(worldIn,playerIn,handIn)
    local itemstack = playerIn:getHeldItem(handIn)

    if playerIn:canEat(self.CanEatWhenFull) then
        playerIn:setActiveHand(handIn)

        return ActionResult:resultConsume(itemstack)
    else
        return ActionResult:resultFail(itemstack)
    end
end

function ITEM:OnItemUseFinish(stack,worldIn,entityLiving)
    return entityLiving:onFoodEaten(worldIn,stack)
end

function ITEM:GetUseAction(stack)
    return UseAction.EAT
end

function ITEM:GetUseDuration(stack)
    return self.FastToEat and 16 or 32
end