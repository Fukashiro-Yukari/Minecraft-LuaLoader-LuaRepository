ITEM.Base = 'base_sword'
ITEM.Register = true

ITEM.Name = 'test sword'
ITEM.ModID = 'test'
ITEM.Group = 'lua'
ITEM.ImmuneToFire = true

ITEM.IsMeat = false
ITEM.FastToEat = false
ITEM.CanEatWhenFull = false
ITEM.Hunger = 5
ITEM.Saturation = 3
ITEM.FoodEffects = {}

ITEM.AttackDamage = 10
ITEM.AttackSpeed = -2.4
ITEM.MaxDamage = 999

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