local distanceTraveled = 0

---

function Tunnel()
--dig a 3x3 tunnel 2 blocks long
	
	print("Tunneling...")
	print("")
	
	--left column
	Dig()
	Bridge()
	
	turtle.up()
	Dig()
	
	turtle.up()
	Dig()
	
	--middle column
	turtle.turnRight()
	turtle.forward()
	turtle.turnLeft()
	Dig()
	
	turtle.down()
	Dig()
	
	turtle.down()
	Dig()
	Bridge()
	
	--right column
	turtle.turnRight()
	turtle.forward()
	turtle.turnLeft()
	Dig()
	Bridge()
	
	turtle.up()
	Dig()
	
	turtle.up()
	Dig()
	
	--move forward
	turtle.forward()
	distanceTraveled = distanceTraveled + 1
	
	--right column
	Dig()
	
	turtle.down()
	Dig()
	
	turtle.down()
	Dig()
	
	Bridge()
	
	--middle column
	turtle.turnLeft()
	turtle.forward()
	turtle.turnRight()
	Dig()
	Bridge()
	
	turtle.up()
	Dig()
	
	turtle.up()
	Dig()
	
	--left column
	turtle.turnLeft()
	turtle.forward()
	turtle.turnRight()
	Dig()
	
	turtle.down()
	Dig()
	
	turtle.down()
	Dig()
	Bridge()
	
	--move forward
	turtle.forward()
	distanceTraveled = distanceTraveled + 1

end

---

function Dig()
--dig repeatedly until block is clear

	local blockDetected = turtle.inspect()
	
	while(blockDetected == true) do
	
		turtle.dig()
		blockDetected = turtle.inspect()
		
	end
end

---

function Bridge()
--build bridge under turtle if floor not solid

	local success, block = turtle.inspectDown()
	local bridgeRequired = false
	
	if(success == true) then
	--there is a block below
	
		if(block.name == "minecraft:water" or block.name == "minecraft:lava") then
		--block below is liquid
			bridgeRequired = true
		end
		
	else
	--block below is air
		bridgeRequired = true
	end
	
	if(bridgeRequired == true) then
	--search inventory for cobble
		
		for i = 2,16 do
			turtle.select(i)
			
			local slot = turtle.getItemDetail()
			
			if(slot.name == "minecraft:cobblestone" or slot.name == "minecraft:cobbled_deepslate") then
				--place bridge
				turtle.placeDown()
				
				print("Placed Bridge")
				print("")
				
				break
				
			end
		end
	end
end

--- 


---

function Refuel()
--refuel to required travel distance
	
	print("Checking Fuel")
	
	local fuelRequired = 0
	local minFuel = 25
	
	--select fuel slot
	turtle.select(1)
	
	--determine fuel level required
	if(distanceTraveled > minFuel) then
		fuelRequired = distanceTraveled
	else
		--min required fuel for next tunnel call
		fuelRequired = minFuel
	end
	
	print("Current Fuel: ", turtle.getFuelLevel())
	print("Required Fuel: ", fuelRequired)
	print("")
	
	--refuel
	while(turtle.getFuelLevel() < fuelRequired) do
	
		local slot = turtle.getItemDetail()
		
		if(slot.name == "minecraft:coal" or slot.name == "minecraft:charcoal") then
			
			turtle.refuel(1)
			print("Added Fuel")
			print("")
			
		else
		--fuel slot is empty or invalid
			print("No Fuel")
			return
		end
	end
end

---

function FuelAvailable()
--ensure available fuel is sufficient to be able to return home
	
	local fuelAvailable = 0
	
	--select fuel slot
	turtle.select(1)
	
	local slot = turtle.getItemDetail()
		
	if(slot.name == "minecraft:coal" or slot.name == "minecraft:charcoal") then
			
		fuelAvailable = slot.count * 80
		
	end
	
	if(fuelAvailable > distanceTraveled) then
	
		return true
		
	else
	
		print("Insufficient Fuel")
		print("")
		
		return false
		
	end
end

---

function InventoryFull()
	
	local isFull = true;
	
	for i = 2,16 do
		turtle.select(i)
			
		if(turtle.getItemDetail() == nil) then
			isFull = false;
			break
		end
	end
	
	if(isFull == true) then
	
		print("Inventory Full")
		print("")
		
	end
	
	return isFull
	
end

---

function Torch()
	
	if(distanceTraveled % 10 == 0) then
		
		print("Lighting Torch")
		print("")
		
		--select torch slot
		turtle.select(2)
	
		local slot = turtle.getItemDetail()
		
		if(slot.name == "minecraft:torch") then
			
			--reposition to inspect wall
			turtle.turnLeft()
			turtle.turnLeft()
			turtle.forward()
			turtle.turnRight()
			turtle.up()
			
			if(turtle.inspect() == false) then
			--block is an air tile
			
				--search inventory for cobble to patch wall
				for i = 2,16 do
					turtle.select(i)
			
					local slot = turtle.getItemDetail()
			
					if(slot.name == "minecraft:cobblestone" or slot.name == "minecraft:cobbled_deepslate") then
						
						--place patch
						turtle.place()
				
						print("Patched Wall")
						print("")
						
						--reselect torch slot
						turtle.select(2)
						
						break
				
					end
				end
			end
			
			--place torch
			turtle.down()
			turtle.placeUp()
			
			--reposition back to 0
			turtle.turnRight()
			turtle.forward()
			
		else
			print("Out of Torches")
			print("")
		end	
	end
end

---

function RetunToStart()
	
	print("Returning Home")
	
	turtle.turnRight()
	turtle.forward()
	turtle.turnRight()
	
	for i = 0,distanceTraveled do
		turtle.forward()
	end
	
	
end

--Main--

Refuel()

--reposition
turtle.turnLeft()
turtle.forward()
turtle.turnRight()

--tunnel
while(InventoryFull() == false and FuelAvailable() == true) do
	Refuel()
	Tunnel()
	Torch()
end

RetunToStart()
