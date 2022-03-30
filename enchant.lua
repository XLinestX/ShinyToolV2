local Library, Blacklist, BUID, BankInfo, Functions
do--//Init
	repeat
		wait(1)
	until game:IsLoaded() and game:GetService('Players').LocalPlayer ~= nil and game:GetService('Players').LocalPlayer:FindFirstChild('__LOADED')
	Library     = require(game:GetService('ReplicatedStorage').Framework:FindFirstChild('Library'))
	Functions   = Library.Functions
	Blacklist   = {}
end

do --//Checks&Functions
	if Library.Network.Invoke('Get my Banks')[_G.BankIndex] == nil then
		_G.AutoWithdraw = false
	else
		BUID = Library.Network.Invoke('Get my Banks')[_G.BankIndex].BUID;
		BankInfo = Library.Network.Invoke('Get Bank', BUID)
	end
	table.foreach(Library.Directory.Pets, function(i, v)
		if v.rarity == "Mythical" or v.rarity == "Exclusive" then
			Blacklist[tostring(i)] = v.rarity
		end
	end)
	function GetPetInfo(uid)
		for i, v in pairs(Library.Save.Get().Pets) do
			if v.uid == uid then
				return v
			end
		end
	end
	function PetToValidTable(petpowers)
		local temptable = {}
		if petpowers then
			table.foreach(petpowers, function(i, powers)
				temptable[powers[1]] = powers[2]
			end)
		end
		return temptable
	end
	function Time(Tick)
		if typeof(Tick) ~= "number" then
			return warn('Integer expected, got', typeof(Tick))
		end
		local Tick = tick() - Tick
		local Weeks = math.floor(math.floor(math.floor(math.floor(Tick / 60) / 60) / 24) / 7)
		local Days =  math.floor(math.floor(math.floor(Tick / 60) / 60) / 24)
		local Hours = math.floor(math.floor(Tick / 60) / 60)
		local Minutes = math.floor(Tick / 60)
		local Seconds = math.floor(Tick)
		local MilliSeconds = (Tick * 1000)
		local Format = ""
		if Weeks > 0 then 
			Format = Format .. string.format("%d Week/s, ", Weeks)
		end
		if Days > 0 then 
			Format = Format .. string.format("%d Day/s, ", Days % 7)
		end
		if Hours > 0 then
			Format = Format .. string.format("%d Hour/s, ", Hours % 24)
		end
		if Minutes > 0 then
			Format = Format .. string.format("%d Minute/s, ", Minutes % 60)
		end
		if Seconds > 0 then
			Format = Format .. string.format("%d Second/s, ", Seconds % 60)
		end
		if MilliSeconds > 0 then
			Format = Format .. string.format("%d Ms", MilliSeconds % 1000)
		end
		return Format
	end	
end
do--//AutoEnch
	for i, v in pairs(Library.Save.Get().Pets) do
		if v.e and not Blacklist[v.id] and _G.Stop ~= true then
			local HasPower = false
			local startTime = tick()
			spawn(function()
				repeat
					if not Library.Functions.CompareTable(_G.Wanted, PetToValidTable(GetPetInfo(v.uid).powers)) and not HasPower and not _G.Stop then
						if #GetPetInfo(v.uid).powers > 1 then
							warn('Pet: ' .. v.nk .. '(' .. v.uid .. ')')
							warn("      ", GetPetInfo(v.uid).powers[1][1], Functions.ToRomanNum(GetPetInfo(v.uid).powers[1][2]))
							warn("      ", GetPetInfo(v.uid).powers[2][1], Functions.ToRomanNum(GetPetInfo(v.uid).powers[2][2]) .. "\n------------")
						else
							table.foreach(GetPetInfo(v.uid).powers, function(_, __)
								warn('Pet: ' .. v.nk .. '(' .. v.uid .. ')')
								warn("      ", __[1], Functions.ToRomanNum(__[2]) .. "\n------------")
							end)
						end
						Library.Network.Invoke("Enchant Pet", v.uid)
					else
						local printwith = rconsolewarn or warn
						printwith('Pet: ' .. v.nk .. '(' .. v.uid .. ')' .. " has wanted enchants. It took: " .. tostring(Time(startTime)))
						HasPower = true
					end
					if Library.Save.Get().Diamonds < 500000 and _G.Stop ~= true and _G.AutoWithdraw then
						Library.Network.Invoke('Bank withdraw', BUID, (function()
							if (1000000000000 - BankInfo.Storage.Currency.Diamonds) > 25000000000 then
								return (25000000000 - Library.Save.Get().Diamonds)
							else
								return (1000000000000 - BankInfo.Storage.Currency.Diamonds)
							end
						end))
					end
					task.wait()
				until HasPower == true or _G.Stop
			end)
		end
	end
end
