---------------------------------------------------------------------
--Config
---------------------------------------------------------------------
--set what items to filter out when inventory is full
--Format: filter[#] = {"minecraft/mod:block_ID",true/false}
--true will drop items from inventory when full
--false will disable the filter

filter = {}
filter[1] = {"minecraft:cobblestone",true}
filter[2] = {"minecraft:cobbled_deepslate",true}
filter[3] = {"minecraft:dirt",true}
filter[4] = {"minecraft:andesite",true}
filter[5] = {"minecraft:diorite",true}
filter[6] = {"minecraft:granite",true}
filter[7] = {"minecraft:tuff",true}
filter[8] = {"minecraft:calcite",true}
filter[9] = {"minecraft:gravel",true}

--list of liquids to check for tunnel flooding
--Format: floodBlocks[#] = "minecraft/mod:block_ID"
floodBlocks = {}
floodBlocks[1] = "minecraft:water"
floodBlocks[2] = "minecraft:lava"

--list of gravity blocks to check for when patching
--Format: gravityBlocks[#] = "minecraft/mod:block_ID"
gravityBlocks = {}
gravityBlocks[1] = "minecraft:sand"
gravityBlocks[2] = "minecraft:gravel"

---------------------------------------------------------------------
--Do not edit below this line
---------------------------------------------------------------------
--Functions
---------------------------------------------------------------------
--Movement
---------------------------------------------------------------------

function forward(x)

	for i = 1,x do
		turtle.forward()
	end
	
end
---------------------------
function back(x)

	for i = 1,x do
		turtle.back()
	end
	
end
---------------------------
function left(x)

	for i = 1,x do
		turtle.turnLeft()
	end
	
end
---------------------------
function right(x)

	for i = 1,x do
		turtle.turnRight()
	end
	
end
---------------------------
function up(x)

	for i = 1,x do
		turtle.up()
	end
	
end
---------------------------
function down(x)

	for i = 1,x do
		turtle.down()
	end
	
end
---------------------------
function retunToStart()
--return to starting position

	print(">:Returning home")
	
	right(2)
	forward(distanceTraveled)

end

---------------------------------------------------------------------
--Mining
---------------------------------------------------------------------
function tunnel()
-- dig a 3x3 tunnel and mine in a 5x5 area
	
	print(">:")
	print(">:Tunneling...")
	
	--tunnel bottom center
	dig()
	forward(1)
	
	--floor center
	oreDown()
	patchDown()
	
	--tunnel bottom left
	left(1)
	dig()
	
	--floor left
	forward(1)
	oreDown()
	patchDown()
	
	--left wall bottom
	ore()
	
	--tunnel center left
	digUp()
	up(1)
	
	--left wall center
	ore()
	
	--tunnel top left
	digUp()
	up(1)
	
	--left wall top
	ore()
	
	--ceiling left
	oreUp()
	
	--tunnel top center
	right(2)
	dig()
	
	--ceiling center
	forward(1)
	oreUp()
	
	--tunnel top right
	dig()
	
	--ceiling right
	forward(1)
	oreUp()
	
	--right wall top
	ore()
	
	--tunnel center right
	digDown()
	
	--right wall center
	down(1)
	ore()
	
	--tunnel bottom right
	digDown()
	
	--right wall bottom
	down(1)
	ore()
	
	--floor right
	oreDown()
	patchDown()
	
	--recenter
	left(2)
	forward(1)
	right(1)
	
	--tunnel center (leaving to last prevents center area from piling up with sand/gravel)
	digUp()

end
---------------------------
function dig()
--dig repeatedly forward until block is clear
	
	while(turtle.detect() == true) do
		turtle.dig()
	end
	
end
---------------------------
function digUp()
--dig repeatedly up until block is clear

	while(turtle.detectUp() == true) do
		turtle.digUp()
	end
	
end
---------------------------
function digDown()
--for consistency

	turtle.digDown()
	
end
---------------------------
function ore()
--inspect wall for ore and mine if found

	local success, block = turtle.inspect()
	
	if(success == true) then
		
		if(string.find(block.name, "ore")) then
			dig()
		end
		
	end
	
end
---------------------------
function oreUp()
--inspect ceiling for ore and mine if found

	local success, block = turtle.inspectUp()
	
	if(success == true) then
		
		if(string.find(block.name, "ore")) then
			digUp()
		end
		
	end
	
end
---------------------------
function oreDown()
--inspect floor for ore and mine if found

	local success, block = turtle.inspectDown()
	
	if(success == true) then
		
		if(string.find(block.name, "ore")) then
			digDown()
		end
		
	end
	
end

---------------------------------------------------------------------
--Walling
---------------------------------------------------------------------
function patch()
--patch wall with cobble

	local success, block = turtle.inspect()
	
	if(success == true) then
		
		--dig out gravity block if detected
		for i = 1,#(gravityBlocks) do
			if(block.name == gravityBlocks[i]) then
				dig()
				break
			end
		end
		
		--remove torch if in the way
		if(block.name == "minecraft:wall_torch") then
			dig()
		end
		
	end
	
	--patching
	local block = turtle.detect()
	
	if(block == false) then
	--no block detected, patch
	
		if(search("cobble") == true) then
			turtle.place()
			print(">:Patching")
		else
			print(">:Out of cobble")
		end
		
	end
	
end
---------------------------
function patchUp()
--patch floor with cobble

	local block = turtle.detectUp()
	
	if(block == false) then
	--no block detected, patch
	
		if(search("cobble") == true) then
			turtle.placeUp()
			print(">:Patching")
		else
			print(">:Out of cobble")
		end
		
	end
	
end
---------------------------
function patchDown()
--patch floor with cobble

	local block = turtle.detectDown()
	
	if(block == false) then
	--no block detected, patch
	
		if(search("cobble") == true) then
			turtle.placeDown()
			print(">:Patching")
		else
			print(">:Out of cobble")
		end
		
	end
	
end
---------------------------
function wall()
--wall off tunnel

	--move back
	right(2)
	forward(3)
	
	--bottom left
	right(1)
	patch()
	
	--bottom right
	right(2)
	patch()
	
	--center right
	up(1)
	patch()
	
	--center left
	left(2)
	patch()
	
	--top left
	up(1)
	patch()
	
	--top right
	right(2)
	patch()
	
	--top center
	left(1)
	down(1)
	patchUp()
	
	--center
	down(1)
	patchUp()
	
	--bottom center
	back(1)
	patch()
	
	--torch
	if(search("torch") == true) then
		turtle.placeUp()
	end
	
	--adjust travel distance
	if(distanceTraveled > 4) then
		distanceTraveled = distanceTraveled - 4
	end
	
end

---------------------------------------------------------------------
--Torch
---------------------------------------------------------------------
function torch()
--place torch every 10 blocks

	if(distanceTraveled % 10 == 0) then
	
		--check if torches available
		if(search("torch") == true) then
			
			print(">:Lighting torch")
			
			--reposition
			left(1)
			forward(1)
			up(1)
			
			--patch wall if necessary
			patch()
			
			--place torch
			back(1)
			search("torch")
			turtle.place()
			
			--recenter
			down(1)
			right(1)

		else
			print(">:Out of torches")
		end
		
	end
	
end

---------------------------------------------------------------------
--Inventory
---------------------------------------------------------------------
function search(item)
--search for and select item in inventory

	local found = false
	
	for i = 1,16 do
		
		turtle.select(i)
		local slot = turtle.getItemDetail()
		
		if(slot == nil) then
		
			if(item == "empty") then
				found = true
				break
			end
		
		else
		
			if(item == "fuel") then
			
				if(slot.name == "minecraft:coal" or slot.name == "minecraft:charcoal") then
					found = true
					break
				end
			
			elseif(item == "torch") then
		
				if(slot.name == "minecraft:torch") then
					found = true
					break
				end
			
			elseif(item == "cobble") then
			
				if(slot.name == "minecraft:cobblestone" or slot.name == "minecraft:cobbled_deepslate") then
					found = true
					break
				end
			
			elseif(item == "junk") then
				
				for x = 1,#(filter) do
					if(slot.name == filter[x][1] and filter[x][2] == true) then
						found = true
						break
					end
				end
			
			end
			
		end

	end
	
	return found
	
end
---------------------------
function checkInventory()
--check if inventory full
	
	local junkItems = false
	
	if(search("empty") == false) then
	--no empty slot found
		
		--search inventory for anything on the filter list to dump
		if(search("junk") == true) then
		
			poop()
			sortInventory()
			
			--verify if inventory has at least 1 open slot
			if(search("empty") == false) then
				inventoryFull = true
				print(">:Inventory full")
			end
			
		else
			inventoryFull = true
			print(">:Inventory full")
		end
	end
end
---------------------------
function poop()
--dump cobble from inventory, reserving 1 stack for patching

	print(">:BRB. Got to go poop")
	
	--dig poop hole
	left(1)
	forward(1)
	dig()
	forward(1)
	digDown()
	right(2)

	--poop filtered blocks reserving 1 stack of cobble for patching
	local reserveCobble = false
	for i = 1, 16 do
		
		turtle.select(i)
		local slot = turtle.getItemDetail()
		
		if(slot ~= nil) then
		
			for x = 1,#(filter) do
			
				if(slot.name == filter[x][1] and filter[x][2] == true) then
				
					if(slot.name == "minecraft:cobblestone" or slot.name == "minecraft:cobbled_deepslate") then
					
						if(reserveCobble == false) then
							--reserve some cobble for patching
							reserveCobble = true
							
							if(slot.count > 16) then
								turtle.dropDown(slot.count - 16)
							end
							
						else
							turtle.dropDown()
						end
						
					else
						turtle.dropDown()
					end
				end
			end
		end
	end

	--patch hole
	forward(1)
	right(2)
	patch()
	
	--recenter
	left(2)
	forward(1)
	left(1)
	
end
---------------------------
function sortInventory()
--sorts inventory so items are at the front of the inventory to prevent duplicate items falling into an empty slot instead of stacking
	
	print(">:Sorting inventory")
	
	--get list of empty slot indexes
	local emptySlots = {}
	
	for i = 1,16 do
		
		turtle.select(i)
		local slot = turtle.getItemDetail()
		
		if(slot == nil) then
			local index = #(emptySlots) + 1
			emptySlots[index] = i
		end
		
	end

	--search inventory in reverse and place items in lowest index slot available
	for i = 1,#(emptySlots) do
	
		for x = 16,1,-1 do
		
			turtle.select(x)
			local slot = turtle.getItemDetail()
		
			if(slot ~= nil) then
					
				--make sure to only sort items into a lower index slot than where it is already
				if(emptySlots[i] < x) then
					turtle.transferTo(emptySlots[i])
				end
					
				break
					
			end
		end
	end
end

---------------------------------------------------------------------
--Fuel
---------------------------------------------------------------------
function refuel()
	
	--calculate fuel levels
	local currentFuel = turtle.getFuelLevel()
	local minFuel = 30 + distanceTraveled --min required to complete tunnel, torch, poop and return home with a safety buffer
	local maxFuel = 0
	
	--calculate how much fuel is available inventory
	if(search("fuel") == true) then
		maxFuel = currentFuel + turtle.getItemCount() * 80
	else
		maxFuel = currentFuel
	end
	
	--status
	print(">:Fuel:",currentFuel," Min:",minFuel," Max:",maxFuel)
	
	--refuel
	while(currentFuel < minFuel) do
		
		print(">:Refueling")
		
		if(search("fuel") == true) then
		--refuel if available	
			turtle.refuel(1)
		else
		--no fuel in inventory
			break
		end
		
		--update fuel level
		currentFuel = turtle.getFuelLevel()
		
	end
	
	--check if sufficient fuel left
	if(maxFuel < minFuel) then
		outOfFuel = true
		print(">:Out of fuel")
	end
	
end

---------------------------------------------------------------------
--Flooding
---------------------------------------------------------------------
function checkFlooding()
--check if tunneled into a liquid pocket
	
	print(">:Checking for flooding")
	
	--above
	checkForLiquid(turtle.inspectUp())
	
	--forward
	checkForLiquid(turtle.inspect())
	
	--left
	left(1)
	checkForLiquid(turtle.inspect())
	
	--back
	left(1)
	checkForLiquid(turtle.inspect())
	
	--right
	left(1)
	checkForLiquid(turtle.inspect())
	
	--recenter
	left(1)
	
	if(flodding == true) then
		print(">:Flooding detected")
	end
	
	return flooding
	
end
---------------------------
function checkForLiquid(success, block)

	--detect
	if(success == true) then
		
		for i = 1,#(floodBlocks) do
			if(block.name == floodBlocks[i]) then
				flooding = true
			end
		end
		
	end
end

---------------------------------------------------------------------
--Status
---------------------------------------------------------------------
function report()
--print out reason for completion

	local status = ""
	
	if(inventoryFull == true) then
		status = "Inventory full"
		
	elseif(outOfFuel == true) then
		status = "Out of fuel"
		
	elseif(flooding == true) then
		status = "Flooding"
		
	end
	
	print(">:")
	print(">:Job Done")
	print(">:Reason:", status)
	print(">:Tunnel Length:", distanceTraveled)
	
end
---------------------------
function abort()
--check for various reasons to abort tunneling process

	local abort = false
	
	if(inventoryFull == true) then
		abort = true
	end
	
	if(outOfFuel == true) then
		abort = true
	end
	
	if(flooding == true) then
		abort = true
	end
	
	return abort
	
end

---------------------------------------------------------------------
--Main
---------------------------------------------------------------------
distanceTraveled = 0
inventoryFull = false
outOfFuel = false
flooding = false

--get starting fuel
print("")
refuel()

--tunnel
while(abort() == false) do
	
	tunnel()
	distanceTraveled = distanceTraveled + 1
		
	if(checkFlooding() == true) then
		wall()
	else
		torch()
		checkInventory()
	end
	
	refuel()
	
end

retunToStart()
report()
