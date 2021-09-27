ITEM.Base = 'base' -- extends class

ITEM.Register = false -- Can this item be registered?
ITEM.ModID = '' -- MODID E.g: item.(MODID).base If the string is empty, it is lualoader
ITEM.Group = ItemGroup.MATERIALS -- The item group in creative mode, if it is a string, it is the lua item group
ITEM.Rarity = Rarity.COMMON -- Item rarity
ITEM.ContainerItem = nil -- Container Item
ITEM.MaxDamage = 0 -- Item Max Damage
ITEM.MaxStackSize = 64 -- Item Max Stack Size
ITEM.ImmuneToFire = false -- Immune To Fire, if true, it can be on lava
ITEM.CanRepair = true -- Can it be repaired with an anvil?
ITEM.IsMeat = false -- This item is meat
ITEM.FastToEat = false -- This item will be eaten soon
ITEM.CanEatWhenFull = false -- Can items be eaten when they are not hungry?
ITEM.Hunger = 0 -- Recovered hunger
ITEM.Saturation = 0 -- Restore saturation
ITEM.FoodEffects = {} -- The effect you will get after eating this item
ITEM.ToolClasses = {} -- Tool type of item

--[[
Example:

ITEM.FoodEffects = {
    {
        effect = new.EffectInstance(Effects.POISON,3*20,1),
        probability = 1,
        func = function()
        end
    }
}

ITEM.ToolClasses = {
    [ToolType.AXE] = 1
}

]]

--[[
    Call when creating an item
]]
function ITEM:Init() end

--[[
    Call when items refresh
]]
function ITEM:OnReloaded() end

--[[
    Called as the item is being used by an entity.
]]
function ITEM:OnUse(worldIn,livingEntityIn,stack,count) end

--[[
    Called when an ItemStack with NBT data is read to potentially that ItemStack's NBT data
]]
function ITEM:UpdateItemStackNBT(nbt) end

function ITEM:CanPlayerBreakBlockWhileHolding(state,worldIn,pos,player)
    return true
end

--[[
    Called when this item is used when targetting a Block
]]
function ITEM:OnItemUse(context)
    return ActionResultType.PASS
end

function ITEM:GetDestroySpeed(stack,state)
    return 1.0
end

--[[
    Called to trigger the item's "innate" right click behavior. To handle when this item is used on a Block, see
    {@link #onItemUse}.
]]
function ITEM:OnItemRightClick(worldIn,playerIn,handIn)
    return ActionResult:resultPass(playerIn:getHeldItem(handIn))
end

--[[
    Called when the player finishes using this Item (E.g. finishes eating.). Not called when the player stops using
    the Item before the action is complete.
]]
function ITEM:OnItemUseFinish(stack,worldIn,entityLiving)
    return stack;
end

function ITEM:IsDamageable(damageSource)
    if damageSource then
        return self:IsImmuneToFire() or damageSource:isFireDamage()
    else
        return self.MaxDamage > 0
    end
end

--[[
    Current implementations of this method in child classes do not use the entry argument beside ev. They just raise
    the damage on the stack.
]]
function ITEM:HitEntity(stack,target,attacker)
    return false
end

--[[
    Called when a Block is destroyed using this Item. Return true to trigger the "Use Item" statistic.
]]
function ITEM:OnBlockDestroyed(stack,worldIn,state,pos,entityLiving)
    return false
end

--[[
    Check whether this Item can harvest the given Block
]]
function ITEM:CanHarvestBlock(stack,blockIn)
    return false
end

--[[
    Returns true if the item can be used on the given entity, e.g. shears on sheep.
]]
function ITEM:ItemInteractionForEntity(stack,playerIn,target,hand)
    return ActionResultType.PASS
end

--[[
    If this function returns true (or the item is damageable), the ItemStack's NBT tag will be sent to the client.
]]
function ITEM:ShouldSyncTag()
    return true
end

--[[
    Called each tick as long the item is on a player inventory. Uses by maps to check if is on a player hand and
    update it's contents.
]]
function ITEM:InventoryTick(stack,worldIn,entityIn,itemSlot,isSelected) end

--[[
    Called when item is crafted/smelted. Used only by maps so far.
]]
function ITEM:OnCreated(stack,worldIn,playerIn) end

--[[
    Returns {@code true} if this is a complex item.
]]
function ITEM:IsComplex()
    return false
end

--[[
    returns the action that specifies what animation to play when the items is being used
]]
function ITEM:GetUseAction(stack)
    return UseAction.NONE
end

--[[
    How long it takes to use or consume an item
]]
function ITEM:GetUseDuration(stack)
    return 0
end

--[[
    Called when the player stops using an Item (stops holding the right mouse button).
]]
function ITEM:OnPlayerStoppedUsing(stack,worldIn,entityLiving,timeLeft) end

--[[
    allows items to add custom lines of information to the mouseover description
]]
function ITEM:AddInformation(stack,worldIn,tooltip,flagIn) end

--[[
    Returns true if this item has an enchantment glint. By default, this returns <code>stack.isItemEnchanted()</code>,
    but other items can override it (for instance, written books always return true).

    Note that if you override this method, you generally want to also call the super version (on {@link Item}) to get
    the glint for enchanted items. Of course, that is unnecessary if the overwritten version always returns true.
]]
function ITEM:HasEffect(stack)
    return stack:isEnchanted()
end

--[[
    Return an item rarity from EnumRarity
]]
local raritys = {
    [Rarity.COMMON] = Rarity.RARE,
    [Rarity.UNCOMMON] = Rarity.RARE,
    [Rarity.RARE] = Rarity.EPIC,
}
function ITEM:GetRarity(stack)
    if !stack:isEnchanted() then
        return self.Rarity
    else
        if raritys[self.Rarity] then
            return raritys[self.Rarity]
        else
            return self.Rarity
        end
    end
end

--[[
    Checks isDamagable and if it cannot be stacked
]]
function ITEM:IsEnchantable(stack)
    return self.MaxStackSize == 1 and self:IsDamageable()
end

--[[
    Return the enchantability factor of the item, most of the time is based on material.
]]
function ITEM:GetItemEnchantability(stack)
    return 0
end

--[[
    returns a list of items with the same ID, but different meta (eg: dye returns 16 items)
]]
function ITEM:FillItemGroup(group,items) end

--[[
    Return whether this item is repairable in an anvil.
]]
function ITEM:GetIsRepairable(toRepair,repair)
    return false
end

--[[
    Called by CraftingManager to determine if an item is reparable.
    
    @return True if reparable
]]
function ITEM:IsRepairable(stack)
    return self.CanRepair and self:IsDamageable()
end

function ITEM:GetToolTypes(stack)
    return self.toolClasses:keySet()
end

function ITEM:GetHarvestLevel(stack,tool,player,blockState)
    return self.toolClasses:getOrDefault(tool,-1)
end

function ITEM:GetTags()
    return self.reverseTags:getTagNames()
end

--[[
    If this itemstack's item is a crossbow
]]
function ITEM:IsCrossbow(stack)
    return stack:getItem() == Items.CROSSBOW
end

function ITEM:IsIn(tagIn)
    return tagIn:contains(self)
end

function ITEM:GetDrinkSound()
    return SoundEvents.ENTITY_GENERIC_DRINK
end

function ITEM:GetEatSound()
    return SoundEvents.ENTITY_GENERIC_EAT
end

function ITEM:IsImmuneToFire()
    return self.ImmuneToFire
end

--[[
    Called when a player drops the item into the world, returning false from this
    will prevent the item from being removed from the players inventory and
    spawning in the world

    @param player The player that dropped the item
    @param item   The item stack, before the item is removed.
]]
function ITEM:OnDroppedByPlayer(item,player)
    return true
end

--[[
    Allow the item one last chance to modify its name used for the tool highlight
    useful for adding something extra that can't be removed by a user in the
    displayed name, such as a mode of operation.

    @param item        the ItemStack for the item.
    @param displayName the name that will be displayed unless it is changed in
                   this method.
]]
function ITEM:GetHighlightTip(item,displayName)
    return displayName
end

--[[
    This is called when the item is used, before the block is activated.

    @return Return PASS to allow vanilla handling, any other to skip normal code.
]]
function ITEM:OnItemUseFirst(stack,context)
    return ActionResultType.PASS
end

--[[
    Called by Piglins when checking to see if they will give an item or something in exchange for this item.
    
    @return True if this item can be used as "currency" by piglins
]]
function ITEM:IsPiglinCurrency(stack)
    return stack:getItem() == Items.GOLD_INGOT
end

--[[
    Called by Piglins to check if a given item prevents hostility on sight. If this is true the Piglins will be neutral to the entity wearing this item, and will not
    attack on sight. Note: This does not prevent Piglins from becoming hostile due to other actions, nor does it make Piglins that are already hostile stop being so.
    
    @param wearer The entity wearing this ItemStack
    
    @return True if piglins are neutral to players wearing this item in an armor slot
]]
function ITEM:MakesPiglinsNeutral(stack,wearer)
    -- return stack.getItem() instanceof ArmorItem && ((ArmorItem) stack.getItem()).getArmorMaterial() == ArmorMaterial.GOLD;

    return false
end

--[[
    Determines the amount of durability the mending enchantment
    will repair, on average, per point of experience.
]]
function ITEM:GetXpRepairRatio(stack)
    return 2
end

--[[
    Override this method to change the NBT data being sent to the client. You
    should ONLY override this when you have no other choice, as this might change
    behavior client side!
    
    Note that this will sometimes be applied multiple times, the following MUST
    be supported:
      Item item = stack.getItem();
      NBTTagCompound nbtShare1 = item.getNBTShareTag(stack);
      stack.setTagCompound(nbtShare1);
      NBTTagCompound nbtShare2 = item.getNBTShareTag(stack);
      assert nbtShare1.equals(nbtShare2);
    
    @param stack The stack to send the NBT tag for
    @return The NBT tag
]]
function ITEM:GetShareTag(stack)
    return stack:getTag()
end

--[[
    Override this method to decide what to do with the NBT data received from
    getNBTShareTag().
    
    @param stack The stack that received NBT
    @param nbt   Received NBT, can be null
]]
function ITEM:ReadShareTag(stack,nbt)
    stack:setTag(nbt)
end

--[[
    Called before a block is broken. Return true to prevent default block
    harvesting.
    
    Note: In SMP, this is called on both client and server sides!
    
    @param itemstack The current ItemStack
    @param pos       Block's position in world
    @param player    The Player that is wielding the item
    @return True to prevent harvesting, false to continue as normal
]]
function ITEM:OnBlockStartBreak(itemstack,pos,player)
    return false
end

--[[
    Called each tick while using an item.
    
    @param stack  The Item being used
    @param player The Player using the item
    @param count  The amount of time in tick the item has been used for
                  continuously
]]
function ITEM:OnUsingTick(stack,player,count) end

--[[
    Called when the player Left Clicks (attacks) an entity. Processed before
    damage is done, if return value is true further processing is canceled and
    the entity is not attacked.
    
    @param stack  The Item being used
    @param player The player that is attacking
    @param entity The entity being attacked
    @return True to cancel the rest of the interaction.
]]
function ITEM:OnLeftClickEntity(stack,player,entity)
    return false
end

--[[
    ItemStack sensitive version of hasContainerItem
    
    @param stack The current item stack
    @return True if this item has a 'container'
]]
function ITEM:HasContainerItem(itemStack)
    return self.ContainerItem != nil
end

--[[
    ItemStack sensitive version of getContainerItem. Returns a full ItemStack
    instance of the result.
    
    @param itemStack The current ItemStack
    @return The resulting ItemStack
]]
function ITEM:GetContainerItem(itemStack)
    if self:HasContainerItem(itemStack) then
        return ItemStack.EMPTY
    end

    return new.ItemStack(self.ContainerItem)
end

--[[
    Retrieves the normal 'lifespan' of this item when it is dropped on the ground
    as a EntityItem. This is in ticks, standard result is 6000, or 5 mins.
    
    @param itemStack The current ItemStack
    @param world     The world the entity is in
    @return The normal lifespan in ticks.
]]
function ITEM:GetEntityLifespan(itemStack,world)
    return 6000
end

--[[
    Determines if this Item has a special entity for when they are in the world.
    Is called when a EntityItem is spawned in the world, if true and
    Item#createCustomEntity returns non null, the EntityItem will be destroyed
    and the new Entity will be added to the world.
    
    @param stack The current item stack
    @return True of the item has a custom entity, If true,
            Item#createCustomEntity will be called
]]
function ITEM:HasCustomEntity(stack)
    return false
end

--[[
    This function should return a new entity to replace the dropped item.
    Returning null here will not kill the EntityItem and will leave it to
    function normally. Called when the item it placed in a world.
    
    @param world     The world object
    @param location  The EntityItem object, useful for getting the position of
                     the entity
    @param itemstack The current item stack
    @return A new Entity object to spawn or null
]]
function ITEM:CreateEntity(world,location,itemstack)
    return nil
end

--[[
    Called by the default implemetation of EntityItem's onUpdate method, allowing
    for cleaner control over the update of the item without having to write a
    subclass.
    
    @param entity The entity Item
    @return Return true to skip any further update code.
]]
function ITEM:OnEntityItemUpdate(stack,entity)
    return false
end

--[[
    Gets a list of tabs that items belonging to this class can display on,
    combined properly with getSubItems allows for a single item to span many
    sub-items across many tabs.
    
    @return A list of all tabs that this item could possibly be one.
]]
function ITEM:GetCreativeTabs()
    if isstring(self.Group) then
        self.modgroup = self.modgroup or MAPI.GetLuaItemGroup(self.Group)

        return self.modgroup
    end

    return self.Group
end

--[[
    Determines the base experience for a player when they remove this item from a
    furnace slot. This number must be between 0 and 1 for it to be valid. This
    number will be multiplied by the stack size to get the total experience.
    
    @param item The item stack the player is picking up.
    @return The amount to award for each item.
]]
function ITEM:GetSmeltingExperience(item)
    return -1
end

--[[
    Should this item, when held, allow sneak-clicks to pass through to the
    underlying block?
    
    @param world  The world
    @param pos    Block position in world
    @param player The Player that is wielding the item
    @return
]]
function ITEM:DoesSneakBypassUse(stack,world,pos,player)
    return false
end

--[[
    Called to tick armor in the armor slot. Override to do something
]]
function ITEM:OnArmorTick(stack,world,player) end

--[[
    Determines if the specific ItemStack can be placed in the specified armor
    slot, for the entity.
    
    @param stack     The ItemStack
    @param armorType Armor slot to be verified.
    @param entity    The entity trying to equip the armor
    @return True if the given ItemStack can be inserted in the slot
]]
function ITEM:CanEquip(stack,armorType,entity)
    return MobEntity:getSlotForItemStack(stack) == armorType
end

--[[
    Override this to set a non-default armor slot for an ItemStack, but <em>do
    not use this to get the armor slot of said stack; for that, use
    {@link net.minecraft.entity.EntityLiving#getSlotForItemStack(ItemStack)}.</em>
    
    @param stack the ItemStack
    @return the armor slot of the ItemStack, or {@code null} to let the default
            vanilla logic as per {@code EntityLiving.getSlotForItemStack(stack)}
            decide
]]
function ITEM:GetEquipmentSlot(stack)
    return nil
end

--[[
    Allow or forbid the specific book/item combination as an anvil enchant
    
    @param stack The item
    @param book  The book
    @return if the enchantment is allowed
]]
function ITEM:IsBookEnchantable(stack,book)
    return true
end

--[[
    Called by RenderBiped and RenderPlayer to determine the armor texture that
    should be use for the currently equipped item. This will only be called on
    instances of ItemArmor.
    
    Returning null from this function will use the default value.
    
    @param stack  ItemStack for the equipped armor
    @param entity The entity wearing the armor
    @param slot   The slot the armor is in
    @param type   The subtype, can be null or "overlay"
    @return Path of texture to bind, or null to use default
]]
function ITEM:GetArmorTexture(stack,entity,slot,type)
    return nil
end

--[[
    Returns the font renderer used to render tooltips and overlays for this item.
    Returning null will use the standard font renderer.
    
    @param stack The current item stack
    @return A instance of FontRenderer or null to use default
]]
function ITEM:GetFontRenderer(stack)
    return nil
end

--[[
    Override this method to have an item handle its own armor rendering.
    
    @param entityLiving The entity wearing the armor
    @param itemStack    The itemStack to render the model of
    @param armorSlot    The slot the armor is in
    @param _default     Original armor model. Will have attributes set.
    @return A ModelBiped to render instead of the default
]]
function ITEM:GetArmorModel(entityLiving,itemStack,armorSlot,_default)
    return nil
end

--[[
    Called when a entity tries to play the 'swing' animation.
    
    @param entity The entity swinging the item.
    @return True to cancel any further processing by EntityLiving
]]
function ITEM:OnEntitySwing(stack,entity)
    return false
end

--[[
    Called when the client starts rendering the HUD, for whatever item the player
    currently has as a helmet. This is where pumpkins would render there overlay.
    
    @param stack        The ItemStack that is equipped
    @param player       Reference to the current client entity
    @param resolution   Resolution information about the current viewport and
                        configured GUI Scale
    @param partialTicks Partial ticks for the renderer, useful for interpolation
]]
function ITEM:RenderHelmetOverlay(stack,player,width,height,partialTicks) end

--[[
    Return the itemDamage represented by this ItemStack. Defaults to the Damage
    entry in the stack NBT, but can be overridden here for other sources.
    
    @param stack The itemstack that is damaged
    @return the damage value
]]
function ITEM:GetDamage(stack)
    return !stack:hasTag() and 0 or stack:getTag():getInt('Damage')
end

--[[
    Determines if the durability bar should be rendered for this item. Defaults
    to vanilla stack.isDamaged behavior. But modders can use this for any data
    they wish.
    
    @param stack The current Item Stack
    @return True if it should render the 'durability' bar.
]]
function ITEM:ShowDurabilityBar(stack)
    return stack:isDamaged()
end

--[[
    Queries the percentage of the 'Durability' bar that should be drawn.
    
    @param stack The current ItemStack
    @return 0.0 for 100% (no damage / full bar), 1.0 for 0% (fully damaged /
            empty bar)
]]
function ITEM:GetDurabilityForDisplay(stack)
    return stack:getDamage()/stack:getMaxDamage()
end

--[[
    Returns the packed int RGB value used to render the durability bar in the
    GUI. Defaults to a value based on the hue scaled based on
    {@link #getDurabilityForDisplay}, but can be overriden.
    
    @param stack Stack to get durability from
    @return A packed RGB value for the durability colour (0x00RRGGBB)
]]
function ITEM:GetRGBDurabilityForDisplay(stack)
    return MathHelper:hsvToRGB(math.max(0,(1-self:GetDurabilityForDisplay(stack)))/3,1,1)
end

--[[
    Return the maxDamage for this ItemStack. Defaults to the maxDamage field in
    this item, but can be overridden here for other sources such as NBT.
    
    @param stack The itemstack that is damaged
    @return the damage value
]]
function ITEM:GetMaxDamage(stack)
    return self.MaxDamage
end

--[[
    Return if this itemstack is damaged. Note only called if
    {@link #isDamageable()} is true.
    
    @param stack the stack
    @return if the stack is damaged
]]
function ITEM:IsDamaged(stack)
    return self:GetDamage(stack) > 0
end

--[[
    Set the damage for this itemstack. Note, this method is responsible for zero
    checking.
    
    @param stack  the stack
    @param damage the new damage value
]]
function ITEM:SetDamage(stack,damage)
    stack:getOrCreateTag():putInt("Damage",math.max(0,damage))
end

--[[
    Gets the maximum number of items that this stack should be able to hold. This
    is a ItemStack (and thus NBT) sensitive version of Item.getItemStackLimit()
    
    @param stack The ItemStack
    @return The maximum number this item can be stacked to
]]
function ITEM:GetItemStackLimit(stack)
    return self.MaxStackSize
end

--[[
    Checks whether an item can be enchanted with a certain enchantment. This
    applies specifically to enchanting an item in the enchanting table and is
    called when retrieving the list of possible enchantments for an item.
    Enchantments may additionally (or exclusively) be doing their own checks in
    {@link net.minecraft.enchantment.Enchantment#canApplyAtEnchantingTable(ItemStack)};
    check the individual implementation for reference. By default this will check
    if the enchantment type is valid for this item type.
    
    @param stack       the item stack to be enchanted
    @param enchantment the enchantment to be applied
    @return true if the enchantment can be applied to this item
]]
function ITEM:CanApplyAtEnchantingTable(stack,enchantment)
    return enchantment.type:canEnchantItem(stack:getItem())
end

--[[
    Determine if the player switching between these two item stacks
    
    @param oldStack    The old stack that was equipped
    @param newStack    The new stack
    @param slotChanged If the current equipped slot was changed, Vanilla does not
                       play the animation if you switch between two slots that
                       hold the exact same item.
    @return True to play the item change animation
]]
function ITEM:ShouldCauseReequipAnimation(oldStack,newStack,slotChanged)
    return !oldStack:equals(newStack)
end

--[[
    Called when the player is mining a block and the item in his hand changes.
    Allows to not reset blockbreaking if only NBT or similar changes.
    
    @param oldStack The old stack that was used for mining. Item in players main
                    hand
    @param newStack The new stack
    @return True to reset block break progress
]]
function ITEM:ShouldCauseBlockBreakReset(oldStack,newStack)
    return !(newStack:getItem() == oldStack:getItem() and ItemStack:areItemStackTagsEqual(newStack,oldStack) and (newStack:isDamageable() or newStack:getDamage() == oldStack:getDamage()))
end

--[[
    Called while an item is in 'active' use to determine if usage should
    continue. Allows items to continue being used while sustaining damage, for
    example.
    
    @param oldStack the previous 'active' stack
    @param newStack the stack currently in the active hand
    @return true to set the new stack to active and continue using it
]]
function ITEM:CanContinueUsing(oldStack,newStack)
    return ItemStack:areItemsEqualIgnoreDurability(oldStack,newStack)
end

--[[
    Called to get the Mod ID of the mod that *created* the ItemStack, instead of
    the real Mod ID that *registered* it.
    
    For example the Forge Universal Bucket creates a subitem for each modded
    fluid, and it returns the modded fluid's Mod ID here.
    
    Mods that register subitems for other mods can override this. Informational
    mods can call it to show the mod that created the item.
    
    @param itemStack the ItemStack to check
    @return the Mod ID for the ItemStack, or null when there is no specially
            associated mod and {@link #getRegistryName()} would return null.
]]
function ITEM:GetCreatorModId(itemStack)
    return ForgeHooks:getDefaultCreatorModId(itemStack)
end

--[[
    Called from ItemStack.setItem, will hold extra data for the life of this
    ItemStack. Can be retrieved from stack.getCapabilities() The NBT can be null
    if this is not called from readNBT or if the item the stack is changing FROM
    is different then this item, or the previous item had no capabilities.
    
    This is called BEFORE the stacks item is set so you can use stack.getItem()
    to see the OLD item. Remember that getItem CAN return null.
    
    @param stack The ItemStack
    @param nbt   NBT of this item serialized, or null.
    @return A holder instance associated with this ItemStack where you can hold
            capabilities for the life of this item.
]]
function ITEM:InitCapabilities(stack,nbt)
    return nil
end

--[[
    Can this Item disable a shield
    
    @param stack    The ItemStack
    @param shield   The shield in question
    @param entity   The EntityLivingBase holding the shield
    @param attacker The EntityLivingBase holding the ItemStack
    @retrun True if this ItemStack can disable the shield in question.
]]
function ITEM:CanDisableShield(stack,shield,entity,attacker)
    -- return this instanceof AxeItem;
    return false
end

--[[
    Is this Item a shield
    
    @param stack  The ItemStack
    @param entity The Entity holding the ItemStack
    @return True if the ItemStack is considered a shield
]]
function ITEM:IsShield(stack,entity)
    return stack:getItem() == Items.SHIELD;
end

--[[
    @return the fuel burn time for this itemStack in a furnace. Return 0 to make
            it not act as a fuel. Return -1 to let the default vanilla logic
            decide.
]]
function ITEM:GetBurnTime(itemStack)
    return -1
end

--[[
    Called every tick from {@link EntityHorse#onUpdate()} on the item in the
    armor slot.
    
    @param stack the armor itemstack
    @param world the world the horse is in
    @param horse the horse wearing this armor
]]
function ITEM:OnHorseArmorTick(stack,world,horse) end

--[[
    Reduce the durability of this item by the amount given.
    This can be used to e.g. consume power from NBT before durability.
    
    @param stack The itemstack to damage
    @param amount The amount to damage
    @param entity The entity damaging the item
    @param onBroken The on-broken callback from vanilla
    @return The amount of damage to pass to the vanilla logic
]]
function ITEM:DamageItem(stack,amount,entity,onBroken)
    return amount
end

--[[
    Whether this Item can be used to hide player head for enderman.
    
    @param stack the ItemStack
    @param player The player watching the enderman
    @param endermanEntity The enderman that the player look
    @return true if this Item can be used to hide player head for enderman
]]
function ITEM:IsEnderMask(stack,player,endermanEntity)
    return stack:getItem() == Blocks.CARVED_PUMPKIN:asItem()
end

--[[
    Used to determine if the player can use Elytra flight.
    This is called Client and Server side.
    
    @param stack The ItemStack in the Chest slot of the entity.
    @param entity The entity trying to fly.
    @return True if the entity can use Elytra flight.
]]
function ITEM:CanElytraFly(stack,entity)
    return false
end

--[[
    Used to determine if the player can continue Elytra flight,
    this is called each tick, and can be used to apply ItemStack damage,
    consume Energy, or what have you.
    For example the Vanilla implementation of this, applies damage to the
    ItemStack every 20 ticks.
    
    @param stack       ItemStack in the Chest slot of the entity.
    @param entity      The entity currently in Elytra flight.
    @param flightTicks The number of ticks the entity has been Elytra flying for.
    @return True if the entity should continue Elytra flight or False to stop.
]]
function ITEM:ElytraFlightTick(stack,entity,flightTicks)
    return false
end

--[[
    Gets a map of item attribute modifiers, used by ItemSword to increase hit damage.
]]
function ITEM:GetAttributeModifiers(slot,stack)
    return ImmutableMultimap:of()
end

function ITEM:GetItemStackTileEntityRenderer()
end