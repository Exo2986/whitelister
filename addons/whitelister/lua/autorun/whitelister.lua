function playerlogin(ply)
	if (file.Exists("whitelist.txt","DATA")) then
		whitelist = file.Read("whitelist.txt")
		whitelist:gsub("-- PLEASE NOTE THAT WHEN ADDING USERS TO THE WHITELIST MANUALLY, YOU MUST PUT A SEMICOLON AT THE END OF THEIR NAME --","")
		returnedstring, amount = string.gsub(whitelist,";"..ply:Name(),";"..ply:Name())
		if (amount <= 0) then
			returnedstring, amount = string.gsub(whitelist,ply:Name(),ply:Name())
			if (amount > 0) then
				print(ply:Name().."'s username is whitelisted on this server. SteamID will be added. They should be allowed to join.")
				file.Write("whitelist.txt",string.gsub(whitelist, ply:Name()..";", ply:SteamID()..";"..ply:Name()))
				return
			end
		end
		returnedstring, amount = string.gsub(whitelist,ply:SteamID(),ply:SteamID())
		if (amount > 0) then
			print(ply:Name().."'s steamid is whitelisted on this server. They should be allowed to join.")
			return
		end
		if (!ply:IsBot()) then
			print(ply:Name().." is not in the whitelist. They should be kicked momentarily.")
			timer.Create("whitelist_kick"..ply:SteamID(),2,1,function() ply:Kick("You are not whitelisted on this server") end)
		end
	else
		ply:PrintMessage(HUD_PRINTTALK, "Whitelist has been created! To add a new player to the whitelist, either use '!whitelist add name' or go into the whitelist.txt file in garrysmod/data and add their name like this!")
		ply:PrintMessage(HUD_PRINTTALK, "name;")
		ply:PrintMessage(HUD_PRINTTALK, "EXAMPLE: Garry Newman;")
		ply:PrintMessage(HUD_PRINTTALK, "Once a user with the name you added logs in, their SteamID will be added so that nobody else with that name can join.")
		file.Write("whitelist.txt",ply:Name()..";\n")
	end
end
hook.Add("PlayerInitialSpawn", "PlayerLogin", playerlogin)

function whitelistCommand(ply, text, public)
    if (string.sub( string.lower(text), 1, 14) == "!whitelist add") then
		arg = string.gsub(text,"!whitelist add ","")
		file.Append("whitelist.txt",arg..";".."\n")
		ply:ChatPrint(arg.." has successfully been added to this server's whitelist!")
        return(false)
    end
	if (string.sub( string.lower(text), 1, 17) == "!whitelist remove") then
		arg = string.gsub(text,"!whitelist remove ","")
		whitelist = file.Read("whitelist.txt")
		whitelistlines = string.Explode("\n",whitelist)
		for i, line in ipairs(whitelistlines) do
			if line ~= "-- PLEASE NOTE THAT WHEN ADDING USERS TO THE WHITELIST MANUALLY, YOU MUST PUT A SEMICOLON AT THE END OF THEIR NAME --" then
				linesplit = string.Explode(";",line)
				if linesplit[2] ~= nil then
					if linesplit[2] == arg and linesplit[3] == nil then
						whitelistlines[i] = ""
						ply:ChatPrint(arg.." has successfully been removed from this server's whitelist!")
					elseif linesplit[1] == arg then
						whitelistlines[i] = ""
						ply:ChatPrint(arg.." has successfully been removed from this server's whitelist!")
					end
				end
			end
		end
		newWhitelist = ""
		for i, line in ipairs(whitelistlines) do
			if line ~= "" then newWhitelist = newWhitelist..line.."\n"
			else newWhitelist = newWhitelist..line end
		end
		file.Write("whitelist.txt",newWhitelist)
        return(false)
    end
end
hook.Add("PlayerSay", "whitelistCommand", whitelistCommand);
