--Movement--

function forward(x)

	for i = 1,x do
	
		turtle.forward()
		
	end
	
end

---

function back(x)

	for i = 1,x do
	
		turtle.back()
		
	end
	
end

---

function left(x)

	for i = 1,x do
	
		turtle.turnLeft()
		
	end
	
end

---

function right(x)

	for i = 1,x do
	
		turtle.turnRight()
		
	end
	
end

---

function up(x)

	for i = 1,x do
	
		turtle.up()
		
	end
	
end

---

function down(x)

	for i = 1,x do
	
		turtle.down()
		
	end
	
end

---

function retunToStart()

	print(">: Returning home")
	
	right(2)
	forward(distanceTraveled)
	
	print(">: Job done")
	
end



--Mining--

function tunnel()
-- dig a 3x3 tunnel and mine in a 5x5 area

	print(">: Tunneling...")
	
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
	
	--floor center (retry in case no cobble to start)
	patchDown()

end

---

function dig()
--dig repeatedly forward until block is clear
	
	while(turtle.detect() == true) do
		turtle.dig()
	end
	
end

---

function digUp()
--dig repeatedly up until block is clear

	while(turtle.detectUp() == true) do
		turtle.digUp()
	end
	
end

---

function digDown()
	
	turtle.digDown()
	
end

---

function ore()
--inspect wall for ore and mine if found

	local success, block = turtle.inspect()
	
	if(success == true) then
		
		if(string.find(block.name, "ore")) then
		
			dig()
			
		end
		
	end
	
end

---

function oreUp()
--inspect ceiling for ore and mine if found

	local success, block = turtle.inspectUp()
	
	if(success == true) then
		
		if(string.find(block.name, "ore")) then
		
			digUp()
			
		end
		
	end
	
end

---

function oreDown()
--inspect floor for ore and mine if found

	local success, block = turtle.inspectDown()
	
	if(success == true) then
		
		if(string.find(block.name, "ore")) then
		
			digDown()
			
		end
		
	end
	
end



--Walling--

function patch()
--patch wall with cobble

	local block = turtle.detect()
	
	if(block == false) then
	--no block detected, patch
	
		if(search("cobble") == true) then
		
			turtle.place()
			print(">: Patching")
			
		else
		
			print(">: Out of cobble")
			
		end
		
	end
	
end

---

function patchUp()
--patch floor with cobble

	local block = turtle.detectUp()
	
	if(block == false) then
	--no block detected, patch
	
		if(search("cobble") == true) then
		
			turtle.placeUp()
			print(">: Patching")
			
		else
		
			print(">: Out of cobble")
			
		end
		
	end
	
end

---

function patchDown()
--patch floor with cobble

	local block = turtle.detectDown()
	
	if(block == false) then
	--no block detected, patch
	
		if(search("cobble") == true) then
		
			turtle.placeDown()
			print(">: Patching")
			
		else
		
			print(">: Out of cobble")
			
		end
		
	end
	
end

---

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



--Torch--

function torch()
--place torch every 10 blocks

	if(distanceTraveled % 10 == 0) then
	
		--check if torches available
		if(search("torch") == true) then
			
			print(">: Lighting torch")
			
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
		
			print(">: Out of torches")
			
		end
		
	end
	
end



--Inventory--

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
				
			end
			
		end

	end
	
	return found
	
end

---

function checkInventory()
--check if inventory full
	
	if(search("empty") == false) then
	--no empty slot found
		
		if(search("cobble") == true) then
		--search inventory for cobble to dump
				
			poop()
				
		else
		--no dumpable inventory
			
			print(">: Inventory full")
			
			inventoryFull = true
				
		end
		
	end
	
	print(">: Inventory Full:", inventoryFull)
	
end

---

function poop()
--dump cobble from inventory, reserving 1 stack for patching

	print(">: BRB. Got to go poop")
	
	--dig poop hole
	left(1)
	forward(1)
	dig()
	forward(1)
	digDown()
	right(2)
	
	--poop cobble
	while(search("cobble") == true) do
		turtle.dropDown()
	end
	
	--collect 1 cobble to patch hole
	search("empty")
	turtle.suckDown(1)
	
	--patch poop hole
	forward(1)
	right(2)
	patch()
	
	--recenter
	left(2)
	forward(1)
	left(1)
	
end



--Fuel--

function refuel()
	
	--calculate fuel levels
	local currentFuel = turtle.getFuelLevel()
	local minFuel = 20 + distanceTraveled --min required to complete tunnel, torch, poop and return home with a tiny buffer
	local maxFuel = 0
	
	if(search("fuel") == true) then
	--calculate how much fuel is in inventory
	
		maxFuel = turtle.getItemCount() * 80
		
	else
	--should only happen if no fuel was supplied to turtle at start
	
		maxFuel = turtle.getFuelLevel()
		
	end
	
	--status
	print(">: Fuel:",currentFuel," Min:",minFuel," Max:",maxFuel)
	
	--refuel
	while(currentFuel < minFuel) do
		
		print(">: Refueling")
		
		if(search("fuel") == true) then
		--refuel if available	
		
			turtle.refuel(1)
			
		else
		--no fuel in inventory
		
			outOfFuel = true
			break
			
		end
		
		--update fuel level
		currentFuel = turtle.getFuelLevel()
		
	end
	
	--check if sufficient fuel left
	if(maxFuel < minFuel) then
		
		outOfFuel = true

	end
	
	--status
	if(outOfFuel == true) then
		
		print(">: Out of fuel")
		
	end
	
end



--Flooding--

function checkFlooding()
--check if tunneled into a liquid pocket

	--forward
	local success, block = turtle.inspect()
	
	if(success == true) then
		
		if(block.name == "minecraft:water" or block.name == "minecraft:lava") then
			
			flooding = true

		end
		
	end
	
	--above
	local success, block = turtle.inspectUp()
	
	if(success == true) then
		
		if(block.name == "minecraft:water" or block.name == "minecraft:lava") then
			
			flooding = true

		end
		
	end
	

	if(flooding == true) then
		
		print(">: Flooding detected")
		
	end
	
	return flooding
	
end



--Status--
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
	
	print("")
	print(">: Job done")
	print(">: Reason: ", status)
	
end

---

function checkAbort()
--check for various reasons to abort tunning process

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



--Main---------------------------------------------------------------------
distanceTraveled = 0
inventoryFull = false
outOfFuel = false
flooding = false


--get starting fuel
refuel()

--tunnel
while(checkAbort() == false) do
	
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