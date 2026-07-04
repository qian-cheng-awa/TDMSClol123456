if not game:IsLoaded() then
	game.Loaded:Wait()
end
local isnetworkowner = function(Part)
	return not Part:IsGrounded() and Part.AssemblyRootPart.ReceiveAge == 0
end
local Connects = TDMConnections or {}
getgenv().TDMConnections = Connects
for i,v in pairs(Connects) do
	if typeof(v) == "RBXScriptConnection" then
		v:Disconnect()
		Connects[i] = nil
	end
end


local ScreenSize = workspace.CurrentCamera.ViewportSize
local LastPositionTable, PlayerVelocityTable, PlayerVelocityTable1 = {}, {}, {}
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerPing = Player:GetNetworkPing()
local RunService = game:GetService("RunService")
local GuiMain = Player.PlayerGui
if gethui then
	GuiMain = gethui()
elseif game.CoreGui then
	GuiMain = game.CoreGui
end
local cloneref = cloneref or function(...) return ... end
local AlrLoaded = _G.LoadedUrl or {}
_G.LoadedUrl = AlrLoaded
local AlrLoaded1 = _G.LoadedUrlSTR or {}
_G.LoadedUrlSTR = AlrLoaded1

local function MatchPlaceId(...)
	local Args = {}

	for i,v in pairs(Args) do
		if game.PlaceId ~= v then
			return false
		end
	end

	return true
end

local function GetUrl(Url)
	local sc
	if not AlrLoaded1[Url] then
		sc = game:HttpGet(Url)
		AlrLoaded1[Url] = sc
	else
		sc = AlrLoaded1[Url]
	end
	return sc
end

local function GetApi(Url)
	local sc
	if not AlrLoaded1[Url] then
		sc = game:HttpGet(Url)
		AlrLoaded1[Url] = sc
	else
		sc = AlrLoaded1[Url]
	end

	if not AlrLoaded[Url] then
		AlrLoaded[Url] = loadstring(sc)()
	end

	return AlrLoaded[Url]
end
local function GetRandomId()
	return HttpService:GenerateGUID()
end
if GuiMain:FindFirstChild("TDMEsp") then
	GuiMain:FindFirstChild("TDMEsp"):Destroy()
end

local CurrentPosition

local FlingRunning = false

local function SkidFling(TargetPlayer)
	if FlingRunning then
		return
	end
	
	local HRP = Player.Character:FindFirstChild("HumanoidRootPart")
	if not HRP then return end
	
	local CurrentPosition = Player.Character.HumanoidRootPart.CFrame
	
	local TargetHRP = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not TargetHRP then return end
	
	FlingRunning = true
	
	local conn = game:GetService('RunService').Heartbeat:Connect(function()
		pcall(function()
			sethiddenproperty(HRP, 'PhysicsRepRootPart', TargetHRP)
			HRP.CFrame = TargetHRP.CFrame * CFrame.new(0, 1.3, 0) * CFrame.Angles(math.rad(0), 0, 0)
			HRP.AssemblyLinearVelocity = Vector3.new(0, -9999, 0)
		end)
	end)
	
	task.delay(1,function()
		conn:Disconnect()
		
		if HRP then
			HRP.AssemblyLinearVelocity  = Vector3.zero
			HRP.AssemblyAngularVelocity = Vector3.zero
			HRP.CFrame = CurrentPosition
		end
		
		HRP = nil
		TargetHRP = nil
		conn = nil
		CurrentPosition = nil
		FlingRunning = false
	end)
end
local TDMRunId = game:GetService("HttpService"):GenerateGUID(true)
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

iyflyspeed = 5
vehicleflyspeed = 1
local Players = game:GetService("Players")
local flyKeyDown,flyKeyUp
local IYMouse = cloneref(Players.LocalPlayer:GetMouse())
IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, game:GetService("UserInputService"):GetPlatform())
local FLYING = false
function sFLY(vfly)
	local valuetable = {}
	repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and Players.LocalPlayer.Character.HumanoidRootPart and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	repeat wait() until IYMouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	valuetable.T = Players.LocalPlayer.Character.HumanoidRootPart
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	valuetable.SPEED = 0

	local function FLY()
		FLYING = true
		valuetable.BG = Instance.new('BodyGyro')
		valuetable.BV = Instance.new('BodyVelocity')
		valuetable.BG.P = 9e4
		valuetable.BG.Parent = valuetable.T
		valuetable.BV.Parent = valuetable.T
		valuetable.BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		valuetable.BG.cframe = valuetable.T.CFrame
		valuetable.BV.velocity = Vector3.new(0, 0, 0)
		valuetable.BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		task.spawn(function()
			repeat wait()
				if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					valuetable.SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and valuetable.SPEED ~= 0 then
					valuetable.SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					valuetable.BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * valuetable.SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and valuetable.SPEED ~= 0 then
					valuetable.BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * valuetable.SPEED
				else
					valuetable.BV.velocity = Vector3.new(0, 0, 0)
				end
				valuetable.BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			valuetable.SPEED = 0
			valuetable.BG:Destroy()
			valuetable.BV:Destroy()
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	flyKeyDown = IYMouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'd' then 
			CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	flyKeyUp = IYMouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		end
	end)
	FLY()
end

function NOFLY()
	FLYING = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
		Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

local velocityHandlerName = GetRandomId()
local gyroHandlerName = GetRandomId()
local mfly1
local mfly2

local unmobilefly = function(speaker)
	pcall(function()
		FLYING = false
		local root = speaker.Character.HumanoidRootPart
		root:FindFirstChild(velocityHandlerName):Destroy()
		root:FindFirstChild(gyroHandlerName):Destroy()
		speaker.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
		mfly1:Disconnect()
		mfly2:Disconnect()
	end)
end
local speaker = Players.LocalPlayer

local mobilefly = function(speaker, vfly)
	unmobilefly(speaker)
	FLYING = true

	local root = speaker.Character.HumanoidRootPart
	local camera = workspace.CurrentCamera
	local v3none = Vector3.new()
	local v3zero = Vector3.new(0, 0, 0)
	local v3inf = Vector3.new(9e9, 9e9, 9e9)

	local controlModule = require(speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
	local bv = Instance.new("BodyVelocity")
	bv.Name = velocityHandlerName
	bv.Parent = root
	bv.MaxForce = v3zero
	bv.Velocity = v3zero

	local bg = Instance.new("BodyGyro")
	bg.Name = gyroHandlerName
	bg.Parent = root
	bg.MaxTorque = v3inf
	bg.P = 1000
	bg.D = 50

	mfly1 = speaker.CharacterAdded:Connect(function()
		local bv = Instance.new("BodyVelocity")
		bv.Name = velocityHandlerName
		bv.Parent = root
		bv.MaxForce = v3zero
		bv.Velocity = v3zero

		local bg = Instance.new("BodyGyro")
		bg.Name = gyroHandlerName
		bg.Parent = root
		bg.MaxTorque = v3inf
		bg.P = 1000
		bg.D = 50
	end)

	mfly2 = game:GetService("RunService").RenderStepped:Connect(function()
		root = speaker.Character.HumanoidRootPart
		camera = workspace.CurrentCamera
		if speaker.Character:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild(velocityHandlerName) and root:FindFirstChild(gyroHandlerName) then
			local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
			local VelocityHandler = root:FindFirstChild(velocityHandlerName)
			local GyroHandler = root:FindFirstChild(gyroHandlerName)

			VelocityHandler.MaxForce = v3inf
			GyroHandler.MaxTorque = v3inf
			if not vfly then humanoid.PlatformStand = true end
			GyroHandler.CFrame = camera.CoordinateFrame
			VelocityHandler.Velocity = v3none

			local direction = controlModule:GetMoveVector()
			if direction.X > 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.X < 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.Z > 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.Z < 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
		end
	end)
end

local function Save(data,name,folder)
	local fullPath
	if folder then
		fullPath = [[TDM/]]..folder.."/"..tostring(name)..".json"
	else
		fullPath = [[TDM/]]..string.gsub(name," ","")..".json"
	end
	local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
	if not success then
		return false
	end
	print(encoded)
	writefile(fullPath, encoded)
	return true
end

function Load(name,folder)
	local file
	if folder then
		file = [[TDM/]]..folder.."/"..tostring(name)..".json"
	else
		file = [[TDM/]]..string.gsub(name," ","")..".json"
	end
	if not isfile(file) then return false end

	local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(file))
	if not success then return false end
	return decoded
end

local EspLib = GetApi("https://raw.githubusercontent.com/qian-cheng-awa/Tools/refs/heads/main/EspLib.luau")

local Starlight = loadstring(GetUrl("https://raw.githubusercontent.com/qian-cheng-awa/Tools/refs/heads/main/Starlight.luau"))()

local Values = {
	AntiAfkKick = true,
}

local aaa = game:GetService("VirtualUser")
pcall(function()
	game:GetService('Players').LocalPlayer.Idled:connect(function()
		if Values.AntiAfkKick then
			aaa:CaptureController()
			aaa:ClickButton2(Vector2.new())
		end
	end)
end)

local sus,gameinfo = pcall(function()
	return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
end)
if not sus then
	gameinfo = {
		IconImageAssetId = 109251559,
		Name = "TDM",
	}
end

for i,v in pairs(Starlight) do
	print(i,v)
end

local Window = Starlight:CreateWindow({
	Name = "TDM V4.0",
	Subtitle = gameinfo.Name.." | "..tostring(game.PlaceId),
	Icon = gameinfo.IconImageAssetId,

	LoadingSettings = {
		Title = "TDM V4",
		Subtitle = "By Obi_xieO",
	},

	FileSettings = {
		ConfigFolder = "TDMStarlight"
	},
	InterfaceAdvertisingPrompts = false,
})

Window:CreateHomeTab({})

local TabSection = Window:CreateTabSection("通用功能")
local MainTab = TabSection:CreateTab({
	Name = "主菜单",
	Columns = 1,
})

local function Message(_Title, _Text, Time)
	game:GetService("StarterGui"):SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
end

if identifyexecutor() == "Delta" then
	local Groupbox = MainTab:CreateGroupbox({
		Name = "忍者功能",
		Column = 1,
	})

	local imageid
	Groupbox:CreateInput({
		Name = "图像id",
		CurrentValue = "",
		PlaceholderText = "输入数字",
		Callback = function(Text)
			imageid = Text
		end,
	})

	Groupbox:CreateButton({
		Name = "更改忍者图标为输入的roblox图像资源",
		Tooltip = "更改后重启roblox",
		Callback = function()
			if imageid and imageid ~= "" then
				writefile("new_logo.png", game:HttpGet("https://assetdelivery.roblox.com/v1/asset/?id="..imageid))
			end
		end,
	})
end

local Groupbox = MainTab:CreateGroupbox({
	Name = "甩飞",
	Column = 1,
})

local fpl 
local pld2 = Groupbox:CreateDropdown({
	Special = 1,
	Name = "黑名单",
	Options = {},
	Required = true,
	MultipleOptions = false,
	CanNoneSeleted = true,
	Placeholder = "None Selected",
	Callback = function(Options)
		fpl = unpack(Options) and Players:FindFirstChild(unpack(Options)) or nil
	end,
})

Groupbox:CreateButton({
	Name = "甩飞",
	Callback = function()

		if fpl then
			if fpl.Character then
				SkidFling(fpl)
			end
		end
	end,
})

local Groupbox = MainTab:CreateGroupbox({
	Name = "狙击",
	Column = 1,
})

local teleportvaluestable;teleportvaluestable = {
	telepoartuserid = nil,
	getAvatar = function(userId)
		local res = Request({
			Url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. userId .. "&size=150x150&format=Png",
			Method = "GET"
		})
		local data = HttpService:JSONDecode(res.Body)
		return data.data and data.data[1] and data.data[1].imageUrl or nil
	end,
	checkBatch = function(batch, targetImage)
		local payload = {}
		for _, entry in ipairs(batch) do
			table.insert(payload, {
				requestId = "0:" .. entry[3] .. ":AvatarHeadshot:150x150:png:regular",
				type = "AvatarHeadShot",
				token = entry[3],
				format = "png",
				size = "150x150"
			})
		end

		local res = Request({
			Url = "https://thumbnails.roblox.com/v1/batch",
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode(payload)
		})
		local decoded = HttpService:JSONDecode(res.Body)
		for i, v in ipairs(decoded.data) do
			if v.imageUrl == targetImage then
				local entry = batch[i]
				return entry[1], entry[2]
			end
		end
	end,
	runBatches = function(tokens, image)
		for i = 1, #tokens, 100 do
			local batch = {}
			for j = i, math.min(i + 99, #tokens) do
				table.insert(batch, tokens[j])
			end
			local pid, sid = teleportvaluestable.checkBatch(batch, image)
			if pid and sid then return pid, sid end
			game:GetService("RunService").Heartbeat:Wait()
		end
	end,
	fetchTokens = function(placeId, maxPages,userId)
		local cursor, pages = "", 0
		local image = teleportvaluestable.getAvatar(userId)
		if not image then
			Rayfield:Notify({
				Title = "TDM",
				Content = "获取玩家信息错误",
				Duration = 6.5,
				Image = "rewind",
			})
			return
		end
		while true do
			local tokens = {}
			local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/0?limit=100"
			if cursor ~= "" then url = url .. "&cursor=" .. cursor end

			local success, response = pcall(function()
				local a = game:HttpGet(url)
				return a
			end)
			if not success or not response then
				Rayfield:Notify({
					Title = "TDM",
					Content = "访问服务器列表出错！"..pages,
					Duration = 6.5,
					Image = "rewind",
				})
				break
			end

			local ok, data = pcall(function() return HttpService:JSONDecode(response) end)

			if not ok or not data then
				Rayfield:Notify({
					Title = "TDM",
					Content = "服务器数据错误！"..pages,
					Duration = 6.5,
					Image = "rewind",
				})
				break
			end
			if data.errors and data.errors[1] and data.errors[1].message and data.errors[1].message == "Too many requests" then
				Rayfield:Notify({
					Title = "TDM",
					Content = "请求达到上限！(可能是加速器问题)",
					Duration = 6.5,
					Image = "rewind",
				})
				break
			end
			for _, server in ipairs(data.data) do
				if server.playerTokens then
					for _, token in ipairs(server.playerTokens) do
						table.insert(tokens, {placeId, server.id, token})
					end
				end
			end

			pages =  pages + 1
			print(pages)
			local pid, sid = teleportvaluestable.runBatches(tokens, image)
			if pid and sid then
				Rayfield:Notify({
					Title = "TDM",
					Content = "服务器找到！正在传送",
					Duration = 6.5,
					Image = "rewind",
				})
				TeleportService:TeleportToPlaceInstance(pid, sid)
				return
			else
				Rayfield:Notify({
					Title = "TDM",
					Content = "列表"..pages.." 未找到玩家",
					Duration = 6.5,
					Image = "rewind",
				})
			end
			if not data.nextPageCursor or pages >= maxPages then break end
			cursor = data.nextPageCursor
			task.wait(.15)
		end
	end,
	run = function(placeId, target)
		local userId = tonumber(target)
		if not userId then
			local ok, uid = pcall(function()
				return Players:GetUserIdFromNameAsync(target)
			end)
			if not ok then
				Rayfield:Notify({
					Title = "TDM",
					Content = "用户名错误/用户不存在",
					Duration = 6.5,
					Image = "rewind",
				})
				return
			end
			userId = uid
		end

		teleportvaluestable.fetchTokens(placeId, 1000,userId)
	end
}

Groupbox:CreateInput({
	Name = "用户名或者用户id",
	CurrentValue = "",
	PlaceholderText = "输入数字/文字",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		teleportvaluestable.telepoartuserid = Text
	end,
})


Groupbox:CreateButton({
	Name = "开始传送(必须和所选择玩家处同一游戏)",
	Callback = function()
		if teleportvaluestable.telepoartuserid ~= '' and teleportvaluestable.telepoartuserid then 
			teleportvaluestable.run(game.PlaceId,teleportvaluestable.telepoartuserid)
		end
	end,
})

local Groupbox = MainTab:CreateGroupbox({
	Name = "建筑保存",
	Column = 1,
})

local Path
Groupbox:CreateInput({
	Name = "输入路径(留空默认保存全部可见模型)",
	CurrentValue = "",
	PlaceholderText = "输入文字",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		Path = Text
	end,
})
local FileName
Groupbox:CreateInput({
	Name = "输入文件名",
	CurrentValue = "",
	PlaceholderText = "输入文字",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		FileName = Text
	end,
})
local saveplayermodel = false
Groupbox:CreateToggle({
	Name = "保存玩家模型",
	CurrentValue = false,
	Callback = function(Value)
		saveplayermodel = Value
	end    
})
local function isplayerpart(part)
	for i,v in ipairs(game:GetService("Players"):GetPlayers()) do
		if part:IsDescendantOf(v.Character) then
			return true
		end
	end
	return false
end
Groupbox:CreateButton({
	Name = "保存为文件",
	Callback = function()
		if not Path or Path == "" then
			Path = "workspace"
		end
		if FileName and FileName ~= "" and Path and Path ~= "" then
			local File = {}

			local Instance = loadstring("return "..Path)()
			if Instance then
				for i,v in ipairs(Instance:GetDescendants()) do
					if v:IsA("BasePart") and (not saveplayermodel and not isplayerpart(v) or saveplayermodel and isplayerpart(v)) then
						local tb = {Color = tostring(v.Color),Class = "Part",CFrame = tostring(v.CFrame),Properties = { Anchored = v.Anchored, Collision = v.CanCollide, Shadow = v.CastShadow},Material = v.Material.Name,Size = tostring(v.Size),Else = {},elsea = {}}
						if v:IsA("Part") then
							tb.Shape = v.Shape.Name
						end

						if v:IsA("MeshPart") then
							tb.Else.MeshID = string.gsub(v.MeshId, "%D", "")
							if v.TextureID and v.TextureID ~= "" then
								tb.Else.MeshTextureID = string.gsub(v.TextureID, "%D", "")
							end
							tb.elsea.MeshSize = tostring(v.MeshSize)
						elseif v:FindFirstChildOfClass("SpecialMesh") then
							local mesh = v:FindFirstChildOfClass("SpecialMesh")
							if mesh.MeshType == Enum.MeshType.Head then
								tb.Else.MeshID = "5591363797"
								tb.elsea.MeshScale = "1,1,1"
							else
								tb.Else.MeshID = string.gsub(mesh.MeshId, "%D", "")
								tb.elsea.MeshScale = tostring(mesh.Scale)
							end

							if mesh.TextureId and mesh.TextureId ~= "" then
								tb.Else.MeshTextureID = string.gsub(mesh.TextureId, "%D", "")
							end
						end

						if v:FindFirstChildOfClass("SurfaceAppearance") and tb.Else.MeshID then
							tb.Else.MeshTextureID = string.gsub(v:FindFirstChildOfClass("SurfaceAppearance").ColorMap, "%D", "")
						end

						tb.Light = {}
						tb.SFLight = {}
						if v:FindFirstChildOfClass("PointLight") and v:FindFirstChildOfClass("PointLight").Enabled then
							local light = v:FindFirstChildOfClass("PointLight")
							table.insert(tb.Light,{Range = light.Range,Brightness = light.Brightness,Color = tostring(light.Color),Shadows = light.Shadows})
						end
						if (v:FindFirstChildOfClass("SurfaceLight") and v:FindFirstChildOfClass("SurfaceLight").Enabled) or (v:FindFirstChildOfClass("SpotLight") and v:FindFirstChildOfClass("SpotLight").Enabled) then
							local light = v:FindFirstChildOfClass("SurfaceLight") or v:FindFirstChildOfClass("SpotLight")
							table.insert(tb.SFLight,{Angle = light.Angle,Brightness = light.Brightness,Color = tostring(light.Color),Shadows = light.Shadows,Face = light.Face.Name})
						end
						tb.Texture = {}
						tb.Decal = {}
						if v:FindFirstChildOfClass("Attachment") or v:FindFirstChildOfClass("Decal") or v:FindFirstChildOfClass("Texture") then
							for i,att in ipairs(v:GetChildren()) do
								if att:IsA("Attachment") then
									if att:FindFirstChildOfClass("PointLight") and att:FindFirstChildOfClass("PointLight").Enabled then
										local light = att:FindFirstChildOfClass("PointLight")
										table.insert(tb.Light,{Range = light.Range,Brightness = light.Brightness,Color = tostring(light.Color),Shadows = light.Shadows,Offset = tostring(att.CFrame)})
									end
									if (att:FindFirstChildOfClass("SurfaceLight") and att:FindFirstChildOfClass("SurfaceLight").Enabled) or (att:FindFirstChildOfClass("SpotLight") and att:FindFirstChildOfClass("SpotLight").Enabled) then
										local light = att:FindFirstChildOfClass("SurfaceLight") or att:FindFirstChildOfClass("SpotLight")
										table.insert(tb.SFLight,{Angle = light.Angle,Brightness = light.Brightness,Color = tostring(light.Color),Shadows = light.Shadows,Face = light.Face.Name,Offset = tostring(att.CFrame)})
									end
								elseif att:IsA("Texture") then
									tb.Texture[att.Face.Name] = {Texture = string.gsub(att.Texture,"%D",""),Transparency = att.Transparency,Color = tostring(att.Color3),OffsetU = att.OffsetStudsU,OffsetV = att.OffsetStudsV,StudsU = att.StudsPerTileU,StudsV = att.StudsPerTileV}
								elseif att:IsA("Decal") then
									tb.Decal[att.Face.Name] = {Texture = string.gsub(att.Texture,"%D",""),Transparency = att.Transparency,Color = tostring(att.Color3)}
								end
							end
						end

						tb.Else.Transparency = v.Transparency
						table.insert(File,tb)
					end
				end
			end
			if File and #File > 0 then
				writefile([[TDM/TSBAutoBuilder/]]..FileName..".build",game:GetService("HttpService"):JSONEncode(File))
			end
		end
	end,
})
local Groupbox = MainTab:CreateGroupbox({
	Name = "工具",
	Column = 1,
})

Groupbox:CreateButton({
	Name = "IY",
	Callback = function()
		loadstring(GetUrl('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
	end,
},"IYTool")
Groupbox:CreateButton({
	Name = "DEX",
	Callback = function()
		loadstring(GetUrl("https://raw.githubusercontent.com/qian-cheng-awa/Dex-/refs/heads/main/Main"))()
	end,
},"DexTool")

Groupbox:CreateButton({
	Name = "Rspy",
	Callback = function()
		loadstring(GetUrl("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
	end,
},"RspyTool")

Groupbox:CreateButton({
	Name = "Rspy客户端事件记录版",
	Callback = function()
		loadstring(GetUrl("https://raw.githubusercontent.com/qian-cheng-awa/Tools/refs/heads/main/RemoteSpy-ClientLog.lua"))()
	end,
},"RspyClientLogTool")

Groupbox:CreateButton({
	Name = "保存场景/saveinstance(支持更多注入器)",
	Callback = function()
		local Params = {
			RepoURL = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/",
			SSI = "saveinstance",
		}
		local synsaveinstance = loadstring(GetUrl(Params.RepoURL .. Params.SSI .. ".luau"), Params.SSI)()
		local Options = {}
		synsaveinstance(Options)
	end,
},"SaveInstanceTool")


local Groupbox = MainTab:CreateGroupbox({
	Name = "杂项",
	Column = 1,
})

Groupbox:CreateToggle({
	Name = "防止挂机踢出",
	CurrentValue = Values.AntiAfkKick,
	Style = 2,
	Callback = function(Value)
		Values.AntiAfkKick = Value
	end,
})

local MainTab = TabSection:CreateTab({
	Name = "功能",
	Columns = 1,
})

local Groupbox = MainTab:CreateGroupbox({
	Name = "加速",
	Column = 1,
})

local CFrameSpeed = 2

Groupbox:CreateSlider({
	Name = "移动速度",
	Range = {0, 100},
	CurrentValue = 2,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	Suffix = "m/s",
	Callback = function(Value)
		CFrameSpeed = Value
	end    
})

local CFrameSpeedEnabled = false

Groupbox:CreateToggle({
	Name = "启用",
	CurrentValue = false,
	Callback = function(Value)
		CFrameSpeedEnabled = Value
	end    
})

local Groupbox = MainTab:CreateGroupbox({
	Name = "飞行",
	Column = 1,
})

Groupbox:CreateToggle({
	Name = "IY飞行",
	CurrentValue = false,
	Callback = function(Value)
		if Value then
			mobilefly(Player)
		else
			unmobilefly(Player)
		end
	end    
})
Groupbox:CreateToggle({
	Name = "IY飞行(pc端)",
	CurrentValue = false,
	Callback = function(Value)
		if Value then
			sFLY(false)
		else
			NOFLY()
		end
	end    
})
Groupbox:CreateSlider({
	Name = "飞行速度",
	Range = {0, 100},
	CurrentValue = 1,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	Callback = function(Value)
		iyflyspeed = Value
	end    
})
local fly = false
local down = false
local up = false
local jp = 50
local ds = 50
local flyspeed = 2
Groupbox:CreateToggle({
	Name = "飞行2",
	CurrentValue = false,
	Callback = function(Value)
		local character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
		local Sc = Player.PlayerGui:FindFirstChild("FLUI") or Instance.new("ScreenGui",Player.PlayerGui)
		Sc.Name = "FLUI"
		local button
		if not Sc:FindFirstChild("TextButtonD") then
			button = Instance.new("TextButton",Sc)
			button.Name = "TextButtonD"
			button.Size = UDim2.new(0.1, 0, 0.08, 0)
			button.Position = UDim2.new(0.822, 0,0.76, 0)
			button.TextScaled = true
			button.Text = "下降"
			button.BackgroundColor3 = Color3.new(0.470588, 0.470588, 0.470588)
		else
			button = Sc:FindFirstChild("TextButtonD")
		end
		local buttonu
		if not Sc:FindFirstChild("TextButtonU") then
			buttonu = Instance.new("TextButton",Sc)
			buttonu.Name = "TextButtonU"
			buttonu.Size = UDim2.new(0.1, 0, 0.08, 0)
			buttonu.Position = UDim2.new(0.822, 0,0.61, 0)
			buttonu.TextScaled = true
			buttonu.Text = "上升"
			buttonu.BackgroundColor3 = Color3.new(0.470588, 0.470588, 0.470588)
		else
			buttonu = Sc:FindFirstChild("TextButtonU")
		end

		if Value == true then
			jp = character.Humanoid.JumpPower
			character.Humanoid.JumpPower = 0
			local bodyg = Instance.new("BodyVelocity",character.HumanoidRootPart)
			bodyg.MaxForce = Vector3.new(1000000,1000000,1000000)
			bodyg.P = 1250
			bodyg.Name = "FLG"
			table.insert(TDMConnections,button.MouseButton1Down:Connect(function()
				down = true
			end))
			table.insert(TDMConnections,button.MouseLeave:Connect(function()
				down = false
			end))
			table.insert(TDMConnections,buttonu.MouseButton1Down:Connect(function()
				up = true
			end))
			table.insert(TDMConnections,buttonu.MouseLeave:Connect(function()
				up = false
			end))
		else
			character.Humanoid.JumpPower = jp
			down = false
			up = false
			if character.HumanoidRootPart:FindFirstChild("FLG") then
				character.HumanoidRootPart.FLG:Destroy()
			end
			Sc:Destroy()
		end
		fly = Value
	end    
})

Groupbox:CreateSlider({
	Name = "飞行速度",
	Range = {0, 100},
	CurrentValue = 2,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	Callback = function(Value)
		flyspeed = Value
	end    
})

Groupbox:CreateSlider({
	Name = "上升/下降速度",
	Range = {0, 100},
	CurrentValue = 50,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	Callback = function(Value)
		ds = Value
	end    
})

local MainTab = TabSection:CreateTab({
	Name = "自瞄",
	Columns = 1,
})

local Groupbox = MainTab:CreateGroupbox({
	Name = "",
	Column = 1,
})

local mainaimbot = false
local aimbuttonscreen = Instance.new("ScreenGui",EspFolder)
aimbuttonscreen.IgnoreGuiInset = true
aimbuttonscreen.Enabled = false
aimbuttonscreen.ResetOnSpawn = false
local aimbutton = Instance.new("TextLabel",aimbuttonscreen)
local cu = Instance.new("UICorner",aimbutton)
cu.CornerRadius = UDim.new(1,0)
aimbutton.Size = UDim2.new(0,100,0,100)
aimbutton.BackgroundTransparency = .5
aimbutton.BackgroundColor3 = Color3.new(0,0,0)
local st = Instance.new("UIStroke",aimbutton)
st.Thickness = 2
st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
st.Color = Color3.new(1,1,1)
aimbutton.Position = UDim2.fromScale(.9,.5)
aimbutton.AnchorPoint = Vector2.new(1,1)
aimbutton.TextColor3 = Color3.new(1,1,1)
aimbutton.Text = "自瞄"
local mainaimbotenabled = true
local moveaimbutton = Instance.new("ImageButton",aimbutton)
moveaimbutton.Size = UDim2.fromScale(.2,.2)
moveaimbutton.AnchorPoint = Vector2.new(.5,.5)
moveaimbutton.Position = UDim2.fromScale(1,1)
moveaimbutton.Image = "rbxassetid://3429558445"
moveaimbutton.BackgroundTransparency = 1
local moveaimbuttonvalue = false

table.insert(TDMConnections,moveaimbutton.MouseButton1Down:Connect(function()
	moveaimbuttonvalue = true
end))
table.insert(TDMConnections,moveaimbutton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		moveaimbuttonvalue = false
	end
end))
Groupbox:CreateToggle({
	Name = "开启自瞄",
	CurrentValue = false,
	Callback = function(Value)
		mainaimbot = Value
	end    
})
local wallcheck = false
Groupbox:CreateToggle({
	Name = "墙体检测",
	CurrentValue = false,
	Callback = function(Value)
		wallcheck = Value
	end    
})
local teamcheck = false
Groupbox:CreateToggle({
	Name = "团队检测",
	CurrentValue = false,
	Callback = function(Value)
		teamcheck = Value
	end    
})
Groupbox:CreateToggle({
	Name = "自瞄按钮",
	CurrentValue = false,
	Callback = function(Value)
		mainaimbotenabled = not Value
		moveaimbuttonvalue = false
		aimbuttonscreen.Enabled = Value
	end    
})
local lockposition = false
Groupbox:CreateToggle({
	Name = "锁定自瞄按钮位置",
	CurrentValue = false,
	Callback = function(Value)
		lockposition = Value
	end    
})
Groupbox:CreateSlider({
	Name = "按钮大小",
	Range = {0, math.max(ScreenSize.X,ScreenSize.Y)},
	CurrentValue = 200,
	Increment = 1,
	Suffix = "",
	Callback = function(Value)
		aimbutton.Size = UDim2.new(0,Value,0,Value)
	end    
})
local pingpre = false
Groupbox:CreateToggle({
	Name = "延迟补偿",
	CurrentValue = false,
	Callback = function(Value)
		pingpre = Value
	end    
})
local aimdistancemain = 0
Groupbox:CreateSlider({
	Name = "提前量",
	Range = {0, 10},
	CurrentValue = 0,
	Increment = 0.1,
	Suffix = "",
	Callback = function(Value)
		aimdistancemain = Value
	end    
})
local autodistanceaim = false
Groupbox:CreateToggle({
	Name = "根据距离调整提前量",
	CurrentValue = false,
	Callback = function(Value)
		autodistanceaim = Value
	end    
})
local aimcirclevalue = 100
local AimbotCircle = Instance.new("ScreenGui",EspFolder)
AimbotCircle.Name = "AimbotCircle"
AimbotCircle.IgnoreGuiInset = true
AimbotCircle.Enabled = false
AimbotCircle.ResetOnSpawn = false
local AimbotCircleFrame = Instance.new("Frame",AimbotCircle)
AimbotCircleFrame.Size = UDim2.new(0,aimcirclevalue*2,0,aimcirclevalue*2)
AimbotCircleFrame.Position = UDim2.new(0.5,0,0.5,0)
AimbotCircleFrame.AnchorPoint = Vector2.new(0.5,0.5)
AimbotCircleFrame.BackgroundTransparency = 1
local AimbotCircleUIStroke = Instance.new("UIStroke",AimbotCircleFrame)
AimbotCircleUIStroke.Thickness = 2
AimbotCircleUIStroke.Color = Color3.fromRGB(255,0,0)
local cu = Instance.new("UICorner",AimbotCircleFrame)
cu.CornerRadius = UDim.new(1,0)
Groupbox:CreateSlider({
	Name = "自瞄半径",
	Range = {0, ScreenSize.X > ScreenSize.Y and ScreenSize.X or ScreenSize.Y},
	CurrentValue = aimcirclevalue,
	Increment = 1,
	Suffix = "",
	Callback = function(Value)
		aimcirclevalue = Value
		AimbotCircleFrame.Size = UDim2.new(0,Value*2,0,Value*2)
	end    
})
local aimcircle = false
Groupbox:CreateToggle({
	Name = "开启自瞄半径",
	CurrentValue = false,
	Callback = function(Value)
		aimcircle = Value
		AimbotCircle.Enabled = Value
	end    
})

local MainTab = TabSection:CreateTab({
	Name = "透视",
	Columns = 1,
})

local Groupbox = MainTab:CreateGroupbox({
	Name = "",
	Column = 1,
})

local PlayerEspFunc = function(v)
	EspLib:WrapObject({
		Object = v.Character,
		DisplayText = `{v.DisplayName}{(v.DisplayName == v.Name and "" or "(@"..v.Name..")")}`,
	})
end

local NormalEspPlayer = false

local function Esp(Folders,CheckFunction,EspFunction,Enable)
	for i,v in pairs(Folders) do
		for i,v in ipairs(v:GetChildren()) do
			if CheckFunction(v) then
				if Enable then
					EspFunction(v)
				else
					EspLib:UnwrapObject(v)
				end
			end
		end
	end
end

local function ESPManger(Folders,CheckFunction,EspFunction,GetEnable)
	for i,v in pairs(Folders) do
		local a;a = v.ChildAdded:Connect(function(v)
			if GetEnable() and CheckFunction(v) then
				EspFunction(v)
			end
		end)

		local b;b = v.Destroying:Connect(function()
			a:Disconnect()
			b:Disconnect()
		end)
	end
end


Groupbox:CreateToggle({
	Name = "透视玩家",
	CurrentValue = false,
	Callback = function(Value)
		NormalEspPlayer = Value
		if NormalEspPlayer then
			for i,v in ipairs(Players:GetPlayers()) do
				if v.Character then
					task.spawn(function()
						local Humanoid = v.Character:WaitForChild("Humanoid")
						local HumanoidRootPart = v.Character:WaitForChild("HumanoidRootPart")
						PlayerEspFunc(v)
					end)
				end
			end
		else
			for i,v in ipairs(Players:GetPlayers()) do
				if v.Character then
					EspLib:UnwrapObject(v.Character)
				end
			end
		end
	end    
})
local EspRay = false

Groupbox:CreateToggle({
	Name = "透视射线",
	CurrentValue = false,
	Callback = function(Value)
		EspRay = Value
	end    
})

Groupbox:CreateSlider({
	Name = "射线粗细",
	Range = {0, 10},
	CurrentValue = 0.5,
	Increment = 0.1,
	Suffix = "",
	Callback = function(Value)
		LineWidth = Value
	end    
})

local PlayerEsp = Instance.new("Folder",EspFolder)
PlayerEsp.Name = "Players"
local lockedplayer

table.insert(TDMConnections,UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		local mouse = Players.LocalPlayer:GetMouse()
		local mouseposition = Vector2.new(mouse.X,mouse.Y)
		if (mouseposition-aimbutton.AbsolutePosition+-aimbutton.AbsoluteSize/2).Magnitude <= aimbutton.AbsoluteSize.Y/2 then
			mainaimbotenabled = true
		end
	end
end))
table.insert(TDMConnections,UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		if mainaimbotenabled and aimbuttonscreen.Enabled then
			mainaimbotenabled = false
		end
	end
end))
table.insert(TDMConnections,Players.PlayerAdded:Connect(function(v)
	TDMConnections[v] = v.CharacterAdded:Connect(function(Character)
		local Humanoid = Character:WaitForChild("Humanoid")
		local HRP = Character:WaitForChild("HumanoidRootPart")
		if NormalEspPlayer then
			PlayerEspFunc(v)
		end
	end)
end))

for i,v in ipairs(Players:GetPlayers()) do
	TDMConnections[v] = v.CharacterAdded:Connect(function(Character)
		local Humanoid = Character:WaitForChild("Humanoid")
		local HRP = Character:WaitForChild("HumanoidRootPart")
		if NormalEspPlayer then
			PlayerEspFunc(v)
		end
	end)
end
table.insert(TDMConnections,Players.PlayerRemoving:Connect(function(Pl)
	if TDMConnections[Pl] then
		TDMConnections[Pl]:Disconnect()
		TDMConnections[Pl] = nil
	end
end))

local function AddAll(...)
	local Args = {...}
	local a
	for i,v in ipairs(Args) do
		if not a then
			a = v
		else
			a += v
		end
	end
	return a
end

local function aunpack(tbl,index)
	local max = #tbl
	local rv = {}

	for i=0,index do
		table.insert(rv,tbl[max-i])
	end

	return unpack(rv)
end
table.insert(TDMConnections,RunService.Heartbeat:Connect(function(dt)
	PlayerPing = Player:GetNetworkPing()
	ScreenSize = workspace.CurrentCamera.ViewportSize
	if mainaimbot and mainaimbotenabled then
		local mouse = Players.LocalPlayer:GetMouse()
		local mouseposition = Vector2.new(mouse.X,mouse.Y+58)
		local function isPointInCenterCircle(point)
			point = point + Vector2.new(0,58)
			if not aimcircle then
				return true
			end
			return (point - ScreenSize/2).Magnitude <= aimcirclevalue
		end
		if not lockedplayer then
			for i,v in ipairs(Players:GetPlayers()) do
				local character = v.Character
				if character and v ~= Player and v.Character ~= Player.Character then
					local ScreenPoint, OnScreen = Camera:WorldToScreenPoint(character:GetPivot().Position)
					local ScreenPoint2, OnScreen2 = Camera:WorldToScreenPoint(lockedplayer and lockedplayer:GetPivot().Position or character:GetPivot().Position)
					ScreenPoint = Vector2.new(ScreenPoint.X,ScreenPoint.Y+58)
					ScreenPoint2 = Vector2.new(ScreenPoint2.X,ScreenPoint2.Y+58)
					if (not lockedplayer or (lockedplayer and ((ScreenPoint - ScreenSize/2).Magnitude + (character:GetPivot().Position - Player.Character:GetPivot().Position).Magnitude)/2 < ((ScreenPoint2 - ScreenSize/2).Magnitude)+(lockedplayer:GetPivot().Position - Player.Character:GetPivot().Position).Magnitude)/2) and isPointInCenterCircle(ScreenPoint) and OnScreen then
						local raycastp = RaycastParams.new()
						raycastp.FilterType = Enum.RaycastFilterType.Exclude
						raycastp.FilterDescendantsInstances = {character,Player.Character}
						if wallcheck and workspace:Raycast(Player.Character:GetPivot().Position,character:GetPivot().Position - Player.Character:GetPivot().Position,raycastp) then
							continue
						end
						if teamcheck and Player.Team and v.Team and v.Team == Player.Team then
							continue
						end
						lockedplayer = v.Character
					end
				end
			end
		else
			if (lockedplayer:FindFirstChild("Humanoid") and lockedplayer:FindFirstChild("Humanoid").Health <= 0) or not lockedplayer.Parent then

				lockedplayer = nil
			end
			local targetposition = PlayerVelocityTable[Players:GetPlayerFromCharacter(lockedplayer)]*aimdistancemain
			if autodistanceaim then
				targetposition = PlayerVelocityTable[Players:GetPlayerFromCharacter(lockedplayer)]*(Player.Character:GetPivot().Position - lockedplayer:GetPivot().Position).Magnitude*aimdistancemain*.01
			end
			if pingpre then
				targetposition = targetposition * PlayerPing
			end
			targetposition = targetposition + lockedplayer:GetPivot().Position
			workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position,targetposition)
		end
	else
		lockedplayer = nil
	end
	for i,v in ipairs(game:GetService("Players"):GetPlayers()) do
		if v.Character and v.Character.Parent then
			if not LastPositionTable[v] then
				LastPositionTable[v] = v.Character:GetPivot().Position
			end

			if not PlayerVelocityTable1[v] then
				PlayerVelocityTable1[v] = {}
			end

			local UpdateDealy = 10

			if #PlayerVelocityTable1[v] >= UpdateDealy then
				local Max = #PlayerVelocityTable1[v]

				local N = (AddAll(aunpack(PlayerVelocityTable1[v],UpdateDealy-1)))/UpdateDealy
				PlayerVelocityTable[v] = N
			end
			table.insert(PlayerVelocityTable1[v],( v.Character:GetPivot().Position - LastPositionTable[v] ) / dt)
			LastPositionTable[v] = v.Character:GetPivot().Position
		end
	end

	if moveaimbuttonvalue and not lockposition then
		aimbutton.Position = UDim2.new(0,Players.LocalPlayer:GetMouse().X,0,Players.LocalPlayer:GetMouse().Y+58)
	end
	if CFrameSpeedEnabled then
		Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
			Players.LocalPlayer.Character.HumanoidRootPart.CFrame +
			Players.LocalPlayer.Character.Humanoid.MoveDirection * CFrameSpeed
	end
	if fly then
		local character = Players.LocalPlayer.Character
		local b = character.HumanoidRootPart:FindFirstChild("FLG")
		if up and not down then
			b.Velocity = Vector3.new(0,ds,0)
		elseif down and not up then
			b.Velocity = Vector3.new(0,-ds,0)
		else
			b.Velocity = Vector3.new(0,0,0)
		end
		local cf = character.HumanoidRootPart.CFrame + character.Humanoid.MoveDirection * flyspeed
		character.HumanoidRootPart.CFrame = cf
	end

end))

if workspace:FindFirstChild("GlobalPianoConnector") and game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("PianoGui") and game:GetService("Players").LocalPlayer.PlayerGui.PianoGui:FindFirstChild("Main") then
	local MidiToTable = GetApi("https://raw.githubusercontent.com/qian-cheng-awa/Tools/refs/heads/main/MidiToTable.lua")

	local function MidiNoteToPianoKey(midiNote)
		local baseMidi = 60
		local basePiano = 31

		local offset = midiNote - baseMidi
		local rawPianoKey = basePiano + offset
		local zeroBased = rawPianoKey - 1
		local modResult = zeroBased % 61
		local pianoKey = modResult + 1

		return pianoKey
	end
	local ftab = getsenv(game:GetService("Players").LocalPlayer.PlayerGui.PianoGui.Main)
	local function Press(index)
		ftab.PlayNoteClient(index)
	end

	local function Release(index)
		return
	end
	local Players = game:GetService("Players")
	local Player = Players.LocalPlayer

	local TabSection = Window:CreateTabSection("自动弹琴")
	local Tab = TabSection:CreateTab({
		Name = "功能",
		Columns = 1,
	})
	local Groupbox = Tab:CreateGroupbox({
		Name = "",
		Column = 1,
	})

	if not isfolder("TDM/AutoPiano") then
		makefolder("TDM/AutoPiano")
	end
	local Folder = listfiles("TDM/AutoPiano")
	for i,v in pairs(Folder) do
		Folder[i] = string.gsub(v,"TDM/AutoPiano/","",1)
	end
	local midiData
	local Disabled = {}
	local yg

	local ad = Groupbox:CreateDropdown({
		Options = Folder,
		Required = true,
		MultipleOptions = false,
		Placeholder = "None Selected",
		Name = "选择文件",
		Callback = function(Options)
			midiData = MidiToTable(Options[1] and readfile("TDM/AutoPiano/"..Options[1]))
			Disabled = {}
			local tracks = {}

			for i=1,#midiData.tracks do
				table.insert(tracks, tostring(i))
			end

			yg:Set({Options = tracks})
		end,
	})

	Groupbox:CreateButton({
		Name = "刷新",
		Callback = function()
			local Folder = listfiles("TDM/AutoPiano")
			for i,v in pairs(Folder) do
				Folder[i] = string.gsub(v,"TDM/AutoPiano/","",1)
			end
			ad:Set({Options = Folder})
		end,
	})

	local qy

	yg = Groupbox:CreateDropdown({
		Options = {},
		Required = true,
		Placeholder = "None Selected",
		Name = "选择音轨",
		Callback = function(Options)
			qy:Set(Disabled[tonumber(Options[1])])
		end,
	})

	qy = Groupbox:CreateToggle({
		Name = "禁用",
		CurrentValue = false,
		Callback = function(Value)
			for _,v in pairs(yg.CurrentOption) do
				if tonumber(v) then
					Disabled[tonumber(v)] = Value
				end
			end
		end    
	})

	local TIME_SCALE = 1

	Groupbox:CreateSlider({
		Name = "速度倍率",
		Range = {0.1, 5},
		Increment = .1,
		Suffix = "",
		CurrentValue = 1,
		Flag = "Slider1",
		Callback = function(Value)
			TIME_SCALE = 1/Value
		end,
	})

	local st = tick()
	Groupbox:CreateToggle({
		Name = "开始演奏(61键)",
		CurrentValue = false,
		Callback = function(Value)
			local tic = tick()
			st = tic
			if Value then
				local midiData = midiData
				local Disabled = Disabled
				local active = {}
				local PPQ = midiData.header and midiData.header.ppq or 480
				local bpm
				for _,v in pairs(midiData.tracks) do
					for i,v in pairs(v.events) do
						if v.bpm then
							bpm = v.bpm
							break
						end
					end
				end

				local TICK_TO_SEC = (60 / bpm or 180) / PPQ

				local globalClock = os.clock()

				for trakeindex, track in ipairs(midiData.tracks) do
					if Disabled[trakeindex] then continue end
					task.spawn(function()
						local trackBaseTime = 0 
						for _, e in ipairs(track.events) do
							if tic ~= st then return end
							trackBaseTime = trackBaseTime + e.deltaTime * TIME_SCALE * TICK_TO_SEC
							local waitTime = trackBaseTime - (os.clock() - globalClock)
							if waitTime > 0 then
								task.wait(waitTime)
							end
							if tic ~= st then return end
							if e.name == "NOTE_ON" and e.velocity > 0 then
								local pianoKey = MidiNoteToPianoKey(e.note)
								Press(pianoKey)
							end

							if e.name == "NOTE_OFF" or (e.name == "NOTE_ON" and e.velocity == 0) then
								local pianoKey = MidiNoteToPianoKey(e.note)
								Release(pianoKey)
							end
						end
					end)
				end
			end
		end    
	})
end

if MatchPlaceId(83645629621104,18687417158) then -- Forsaken
	local Actors = require(game:GetService("ReplicatedStorage").Modules.Gameplay.Actors)
	local Util = require(game.ReplicatedStorage.Modules.Utilities.Util)
	local PlayerStaminaManager = (function()
		local PlayerStaminaManager = {
			Players = {}
		}

		local function IsSprinting(Player)
			if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid:FindFirstChild("Animator") and Actors.CurrentActors[Player] and Actors.CurrentActors[Player].Config.Animations and Actors.CurrentActors[Player].Config.Animations.Run then
				for i,v:AnimationTrack in pairs(Player.Character.Humanoid.Animator:GetPlayingAnimationTracks()) do
					if v.Animation.AnimationId == Actors.CurrentActors[Player].Config.Animations.Run or v.Animation.AnimationId == Actors.CurrentActors[Player].Config.Animations.InjuredRun then
						return true
					end
				end
			end
			return false
		end

		local function Toggle(Player,Value)
			if not Value then
				if PlayerStaminaManager.Players[Player].timeUntilStaminaRecovers > 0.1 then
					local v17 = PlayerStaminaManager.Players[Player]
					local v18 = PlayerStaminaManager.Players[Player].timeUntilStaminaRecovers + 0.1
					v17.timeUntilStaminaRecovers = math.clamp(v18, 0, 3)
					return
				end
				PlayerStaminaManager.Players[Player].timeUntilStaminaRecovers = 0.1
			end
		end

		PlayerStaminaManager.AddPlayer = function(Player)

			if not Actors.CurrentActors[Player] then
				print("no actors")
				local a = 0
				repeat
					a += RunService.RenderStepped:Wait()
				until Actors.CurrentActors[Player] or a >= 5
				task.wait(PlayerPing+1)
				if not Actors.CurrentActors[Player] then
					return
				end
			end

			if not PlayerStaminaManager.Players[Player] then
				PlayerStaminaManager.Players[Player] = {
					timeUntilStaminaRecovers = 0,
					IsSprinting = false,
					StaminaLossDisabled = false,
					CanSprint = true,
					MinStamina = Actors.CurrentActors[Player].Config.MinStamina or 0,
					MaxStamina = Actors.CurrentActors[Player].Config.MaxStamina or 100,
					Stamina = Actors.CurrentActors[Player].Config.MaxStamina or 100,
					StaminaGain = Actors.CurrentActors[Player].Config.StaminaGain or 20,
					StaminaLoss = Actors.CurrentActors[Player].Config.StaminaLoss or 10,
					StaminaCap = nil,
				}
			end

			Player.Character.Destroying:Connect(function()
				PlayerStaminaManager.RemovePlayer(Player)
			end)
		end

		PlayerStaminaManager.RemovePlayer = function(Player)
			PlayerStaminaManager.Players[Player] = nil
		end

		table.insert(TDMConnections,Players.PlayerRemoving:Connect(function(Player)
			PlayerStaminaManager.RemovePlayer(Player)
		end))


		local last = 0

		table.insert(TDMConnections,RunService.Heartbeat:Connect(function(dt)
			last = last + dt
			for i,v in pairs(PlayerStaminaManager.Players) do
				local NowIsSprinting = IsSprinting(i)

				if NowIsSprinting ~= v.IsSprinting then
					Toggle(i,NowIsSprinting)
				end

				v.IsSprinting = NowIsSprinting

				if last >= 0.1 then
					if i.Character.Parent.Name == "Killers" then
						local v95 = Util:GetClosestPlayerFromPosition(i.Character:GetPivot().Position, {
							["MaxDistance"] = 85,
							["PlayerSelection"] = "Survivors",
							["OverrideUndetectable"] = true,
							["VerticalMultiplier"] = 3
						})
						if v95 then
							v95 = v95.PrimaryPart
						end
						if v95 and v.StaminaLossDisabled then
							v.StaminaLossDisabled = false
						elseif not (v95 or v.StaminaLossDisabled) then
							v.StaminaLossDisabled = true
						end
					end
				end

				local sus,res = pcall(function()
					if not i.Character.Parent then
						PlayerStaminaManager.RemovePlayer(i)
						return
					end
					if not i.Character.PrimaryPart then
						return
					end
					if v.IsSprinting and ((PlayerVelocityTable[i].Magnitude > 1 and (v.CanSprint and (not v.StaminaLossDisabled and i.Character.Parent.Name ~= "Spectating")))) then
						return true
					end
					if v.StaminaLossDisabled or (not v.IsSprinting or PlayerVelocityTable[i].Magnitude <= 1 and (v.Stamina < v.MaxStamina or v.StaminaCap and v.Stamina > v.StaminaCap)) then
						local v21 = v
						local v22 = v.timeUntilStaminaRecovers - dt
						v21.timeUntilStaminaRecovers = math.clamp(v22, 0, 3)
						if v.timeUntilStaminaRecovers <= 0+Player:GetNetworkPing()+0.25 and not i.Character:GetAttribute("AbilityStaminaOverride") then
							local v23 = v
							local v24 = v.Stamina + v.StaminaGain * dt
							local v25 = v.MinStamina
							local v26 = v.StaminaCap or v.MaxStamina
							v23.Stamina = math.clamp(v24, v25, v26)
						end
					end
				end)
				if sus and res == true then
					local v27 = v
					local v28 = v.timeUntilStaminaRecovers + dt * 0.05
					v27.timeUntilStaminaRecovers = math.clamp(v28, 0.2, 3)
					local v29 = v
					local v30 = v.Stamina - v.StaminaLoss * dt
					v29.Stamina = v30
				end
			end
			if last >= 0.1 then
				last = 0
			end
		end))

		return PlayerStaminaManager
	end)()

	local oldaa;oldaa = hookfunction(getconnections(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("Network"):WaitForChild("RemoteEvent").OnClientEvent)[1].Function,function(...)
		local args = {...}
		if args[1] == "ActorCreated" then
			task.delay(.1,function()
				PlayerStaminaManager.AddPlayer(args[2][1].Player)
			end)
		end

		return oldaa(...)
	end)

	for _,v in pairs(Players:GetPlayers()) do
		PlayerStaminaManager.AddPlayer(v)
	end

	PlayerEspFunc = function(v)
		local tbl = {
			Object = v.Character,
			DisplayText = `{v.DisplayName}{(v.DisplayName == v.Name and "" or "(@"..v.Name..")")}`,
		}

		if v.Character.Parent ~= workspace.Players.Spectating and v.Character.Parent ~= workspace then
			tbl.Infos = {
				{
					Text = v.Character.Name,
					Color = v.Character.Parent.Name == "Killers" and Color3.new(1,0,0) or Color3.new(1,1,0)
				},
				{
					Text = function(Character)
						local Pl = Players:GetPlayerFromCharacter(Character)

						local Ve = PlayerVelocityTable[Pl]

						if Ve then
							return `速度 {math.floor(Ve.Magnitude)}`
						else
							return "无速度数据"
						end
					end,
					Color = Color3.new(1,1,1)
				},
				{
					Text = function(Character)
						local Player = Players:GetPlayerFromCharacter(v.Character)

						local TBL = PlayerStaminaManager.Players[Player]
						if TBL then
							return `{TBL.IsSprinting and "冲刺" or "非冲刺"}`
						end
					end,

					Color = Color3.new(1,1,1)
				},
				{
					Text = function(Character)
						local Player = Players:GetPlayerFromCharacter(v.Character)
						local TBL = PlayerStaminaManager.Players[Player]
						if TBL then
							return `{math.floor(TBL.Stamina)}/{TBL.MaxStamina}`
						end
					end,
					Color = function(Character)
						local Player = Players:GetPlayerFromCharacter(v.Character)
						local TBL = PlayerStaminaManager.Players[Player]
						if TBL and TBL.Stamina and TBL.MinStamina then
							if TBL.Stamina <= (TBL.MinStamina or 0) then
								return Color3.new(1,0,0)
							end
						end

						return Color3.new(1,1,1)
					end,
				},
			}
		end

		EspLib:WrapObject(tbl)
	end

	local TabSection = Window:CreateTabSection(gameinfo.Name)
	local Tab = TabSection:CreateTab({
		Name = "主要功能",
		Columns = 1,
	})
	local Groupbox = MainTab:CreateGroupbox({
		Name = "体力",
		Column = 1,
	})

	local InfStamina = false
	Groupbox:CreateToggle({
		Name = "无限体力",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			InfStamina = Value
		end,
	})

	local Sprinting = require(game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting)

	Groupbox:CreateInput({
		Name = "体力流失速度",
		CurrentValue = tostring(Sprinting.StaminaLoss),
		PlaceholderText = "输入数字",
		RemoveTextAfterFocusLost = false,
		Flag = "Input1",
		Callback = function(Text)
			if typeof(tonumber(Text)) == "number" then
				Sprinting.StaminaLoss = tonumber(Text)
			end
		end,
	})
	Groupbox:CreateInput({
		Name = "最大体力",
		CurrentValue = tostring(Sprinting.MaxStamina),
		PlaceholderText = "输入数字",
		RemoveTextAfterFocusLost = false,
		Flag = "Input1",
		Callback = function(Text)
			if typeof(tonumber(Text)) == "number" then
				Sprinting.MaxStamina = tonumber(Text)
			end
		end,
	})
	Groupbox:CreateInput({
		Name = "最小体力",
		CurrentValue = tostring(Sprinting.MinStamina),
		PlaceholderText = "输入数字",
		RemoveTextAfterFocusLost = false,
		Flag = "Input1",
		Callback = function(Text)
			if typeof(tonumber(Text)) == "number" then
				Sprinting.MinStamina = tonumber(Text)
			end
		end,
	})
	Groupbox:CreateInput({
		Name = "体力恢复速度",
		CurrentValue = tostring(Sprinting.StaminaGain),
		PlaceholderText = "输入数字",
		RemoveTextAfterFocusLost = false,
		Flag = "Input1",
		Callback = function(Text)
			if typeof(tonumber(Text)) == "number" then
				Sprinting.StaminaGain = tonumber(Text)
			end
		end,
	})


	local Groupbox = MainTab:CreateGroupbox({
		Name = "杂项",
		Column = 1,
	})


	local FakeLag = false

	Groupbox:CreateToggle({
		Name = "伪装高ping(自身碰撞箱不受影响)",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			FakeLag = Value
		end,
	})

	local autojump = false
	Groupbox:CreateToggle({
		Name = "维罗妮卡自动跳跃",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			autojump = Value
		end
	})

	local oldsk8
	Groupbox:CreateToggle({
		Name = "维罗妮卡不撞墙",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			if Value then
				if not oldsk8 then
					oldsk8 = require(game:GetService("ReplicatedStorage").Assets.Survivors.Veeronica.Config).Sk8PhaseTime
				end
				require(game:GetService("ReplicatedStorage").Assets.Survivors.Veeronica.Config).Sk8PhaseTime = math.huge
			else
				require(game:GetService("ReplicatedStorage").Assets.Survivors.Veeronica.Config).Sk8PhaseTime = oldsk8 or 1
			end
		end
	})

	local Tab = TabSection:CreateTab({
		Name = "透视",
		Columns = 1,
	})

	local Groupbox = Tab:CreateGroupbox({
		Name = "",
		Column = 1,
	})

	local ESP = {}

	local CheckFunctions = {
		Items = function(Obj)
			if Obj:FindFirstChild("ItemRoot") then
				return true
			end

			return false
		end,
		Generator = function(Obj)
			if Obj.Name == "Generator" or Obj.Name == "FakeGenerator" then
				return Obj.Name
			end

			return false
		end,
		Pizza = function(Obj)
			if Obj.Name == "Pizza" then
				return true
			end

			return false
		end,
		Taph = function(Obj)
			if Obj.Name == "SubspaceTripmine" then
				return "SubspaceTripmine"
			elseif Obj.Name:find("TaphTripwire") then
				return "TaphTripwire"
			end

			return false
		end,
		Builder = function(Obj)
			if Obj.Name == "BuildermanSentry" then
				return "BuildermanSentry"
			elseif Obj.Name == "BuildermanDispenser" then
				return "BuildermanDispenser"
			end

			return false
		end,
	}

	local EspFunctions = {
		Items = function(v)
			EspLib:WrapObject({
				Object = v,
				DisplayText = v.Name,
				Color = Color3.new(0, 0.764706, 1),
			})
		end,

		Generator = function(v)
			local tbl = {
				Object = v,
				DisplayText = "发电机",
				Color = Color3.new(0, 1, 0.0666667),
				Infos = {
					{
						Text = function(Obj)
							return `{Obj:FindFirstChild("Progress").Value >= 100 and 100 or v:FindFirstChild("Progress").Value/26*25}%`
						end,
						Color = Color3.new(1, 1, 1)
					}
				}
			}

			if Generator_CheckFunction(v) == "FakeGenerator" then
				tbl = {
					Object = v,
					DisplayText = "假发电机",
					Color = Color3.new(0, 0.419608, 0.027451),
					Infos = {
						{
							Text = function(Obj)
								return `{Obj:FindFirstChild("Progress").Value >= 100 and 100 or v:FindFirstChild("Progress").Value/26*25}%`
							end,
							Color = Color3.new(1, 0, 0)
						}
					}
				}	
			end

			EspLib:WrapObject(tbl)
		end,

		Pizza = function(v)
			EspLib:WrapObject({
				Object = v,
				DisplayText = "披萨",
				Color = Color3.new(0.556863, 1, 0.85098),
			})
		end,

		Taph = function(v)
			local tbl = {
				Object = v,
				DisplayText = "子空间炸弹",
				Color = Color3.new(0.666667, 0, 1),
			}

			if CheckFunctions.Taph(v) == "TaphTripwire" then
				tbl = {
					Object = v,
					DisplayText = "拌线",
					Color = Color3.new(0.666667, 0, 1),
				}
			end

			EspLib:WrapObject(tbl)
		end,

		Builder = function(v)
			local tbl = {
				Object = v,
				DisplayText = "炮塔",
				Color = Color3.new(1, 0.666667, 0),
			}

			if CheckFunctions.Builder(v) == "BuildermanDispenser" then
				tbl = {
					Object = v,
					DisplayText = "回血机",
					Color = Color3.new(1, 0.666667, 0.219608),
				}
			end

			EspLib:WrapObject(tbl)
		end,
	}

	Groupbox:CreateToggle({
		Name = "透视物品",
		CurrentValue = false,
		Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Value)
			ESP.Items = Value

			Esp({workspace.Map.Ingame},CheckFunctions.Items,EspFunctions.Items,Value)
		end,
	})

	ESPManger({workspace.Map.Ingame},CheckFunctions.Items,EspFunctions.Items,function()
		return ESP.Items
	end)

	Groupbox:CreateToggle({
		Name = "透视电机",
		CurrentValue = false,
		Callback = function(Value)
			ESP.Generator = Value

			if workspace.Map.Ingame:FindFirstChild("Map") then
				Esp({workspace.Map.Ingame.Map},CheckFunctions.Generator,EspFunctions.Generator,Value)
			end
		end,
	})

	workspace.Map.Ingame.ChildAdded:Connect(function(v)
		if v.Name == "Map" then
			Esp({v},CheckFunctions.Generator,EspFunctions.Generator,ESP.Generator)
			ESPManger({v},CheckFunctions.Generator,EspFunctions.Generator,function()
				return ESP.Generator
			end)
		end
	end)

	Groupbox:CreateToggle({
		Name = "透视披萨",
		CurrentValue = false,
		Callback = function(Value)
			ESP.Pizza = Value

			Esp({workspace.Map.Ingame},CheckFunctions.Pizza,EspFunctions.Pizza,Value)
		end,
	})

	ESPManger({workspace.Map.Ingame},CheckFunctions.Pizza,EspFunctions.Pizza,function()
		return ESP.Pizza
	end)

	Groupbox:CreateToggle({
		Name = "透视塔夫拌线/子空间地雷",
		CurrentValue = false,
		Callback = function(Value)
			ESP.Taph = Value
			Esp({workspace.Map.Ingame},CheckFunctions.Taph,EspFunctions.Taph,Value)
		end,
	})

	ESPManger({workspace.Map.Ingame},CheckFunctions.Taph,EspFunctions.Taph,function()
		return ESP.Taph
	end)

	Groupbox:CreateToggle({
		Name = "透视建造师炮塔/回血装置",
		CurrentValue = false,
		Callback = function(Value)
			ESP.Builder = Value
			Esp({workspace.Map.Ingame},CheckFunctions.Builder,EspFunctions.Builder,Value)
		end,
	})

	ESPManger({workspace.Map.Ingame},CheckFunctions.Builder,EspFunctions.Builder,function()
		return ESP.Builder
	end)

	local MainTab = TabSection:CreateTab({
		Name = "高危功能",
		Columns = 1,
	})

	local Groupbox = MainTab:CreateGroupbox({
		Name = "",
		Column = 1,
	})

	local pld = Groupbox:CreateDropdown({
		Special = 1,
		Name = "黑名单",
		Options = {},
		Required = false,
		Placeholder = "None Selected",
		Callback = function(Options)
			fpl = unpack(Options) and Players:FindFirstChild(unpack(Options)) or nil
		end,
	})

	local hitbox = false
	Groupbox:CreateToggle({
		Name = "全图追踪碰撞箱(近战攻击生效)",
		CurrentValue = false,
		Callback = function(Value)
			hitbox = Value
		end,
	})

	local autor = false
	Groupbox:CreateToggle({
		Name = "自动旋转角色（提高成功率）",
		CurrentValue = false,
		Callback = function(Value)
			autor = Value
		end,
	})

	local PosTog = false
	Groupbox:CreateToggle({
		Name = "完美隐身并无敌",
		CurrentValue = false,
		Callback = function(Value)
			PosTog = Value
		end
	})

	local MainTab = TabSection:CreateTab({
		Name = "其他功能",
		Columns = 1,
	})

	local Groupbox = MainTab:CreateGroupbox({
		Name = "发电机",
		Column = 1,
	})

	local gensize = 2
	Groupbox:CreateSlider({
		Name = "更改修机页面格子数量",
		Range = {2, 20},
		Increment = 1,
		Suffix = "",
		CurrentValue = 2,
		Callback = function(Value)
			gensize = Value
		end,
	})
	local hookgenfunc = false
	Groupbox:CreateToggle({
		Name = "启用",
		CurrentValue = false,
		Callback = function(Value)
			hookgenfunc = Value
		end,
	})

	local old;old = hookfunction(require(game:GetService("ReplicatedStorage").Modules.Minigames.FlowGameManager).startGame, function(...)
		local args = {...}
		if hookgenfunc then
			print(args[2])
			args[2] = gensize
			return old(unpack(args))
		end
		return old(...)
	end)

	local Groupbox = MainTab:CreateGroupbox({
		Name = "其他",
		Column = 1,
	})

	local c00lkidd = false
	Groupbox:CreateToggle({
		Name = "冲刺不撞墙(c00lkidd,noli)",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			c00lkidd = Value
		end,
	})
	Groupbox:CreateToggle({
		Name = "noli冲刺随意转弯",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			require(game.ReplicatedStorage.Assets.Killers.Noli.Config).VoidRushTurnSpeed = Value and math.huge or 1
		end,
	})
	local n7 = false
	Groupbox:CreateToggle({
		Name = "007n7分身跟随本体",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			n7 = Value
		end,
	})
	local Pizza = false
	Groupbox:CreateToggle({
		Name = "披萨全图追踪",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			Pizza = Value
		end,
	})

	local EatPizza = false
	Groupbox:CreateToggle({
		Name = "全图吃披萨（自己）",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			EatPizza = Value
		end,
	})

	local MainTab = TabSection:CreateTab({
		Name = "自瞄",
		Columns = 1,
	})

	local Groupbox = MainTab:CreateGroupbox({
		Name = "",
		Column = 1,
	})

	local difdis = false
	Groupbox:CreateToggle({
		Name = "使用推荐设置",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			difdis = Value
		end,
	})
	local aimtargettype = "最近"
	Groupbox:CreateDropdown({
		Name = "自瞄类型",
		Options = {"最近","血量最低"},
		CurrentOption = {"最近"},
		MultipleOptions = false,
		Flag = "Dropdown1",
		Callback = function(Options)
			aimtargettype = unpack(Options)
		end,
	})
	local cameraaim = false
	Groupbox:CreateToggle({
		Name = "自瞄时同时移动视角",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			cameraaim = Value
		end,
	})

	local CharacterAim
	local Shiftlock = false
	Groupbox:CreateToggle({
		Name = "自瞄结束后自动锁定视角",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			Shiftlock = Value
		end,
	})

	Groupbox:CreateToggle({
		Name = "角色自瞄",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			CharacterAim = Value
			if Value == true then else
				Player.Character.Humanoid.AutoRotate = false
				require(game.ReplicatedStorage.Systems.Player.Game.SmoothShiftLock):ToggleShiftLock(Shiftlock);
			end
		end,
	})

	local UsingAim
	Groupbox:CreateToggle({
		Name = "仅放技能时自瞄",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			UsingAim = Value
		end,
	})


	local DifDisTable = {
		Entanglement = function(distance)
			return distance/Actors.CurrentActors[Player].Config.EntanglementSpeed
		end,
		MassInfection = function(distance)
			return distance/Actors.CurrentActors[Player].Config.MassInfectionShockwaveSpeed
		end,
		WalkspeedOverride = function(distance)
			return distance/Actors.CurrentActors[Player].Config.WalkspeedOverrideSpeed
		end,
		CorruptNature = function(distance)
			return distance/50
		end,
	}

	local Disdis
	Groupbox:CreateToggle({
		Name = "跟随距离额外增加预瞄量",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			Disdis = Value
		end,
	})
	local adis = 2.5
	Groupbox:CreateSlider({
		Name = "预瞄量",
		Range = {0, 10},
		Increment = .1,
		Suffix = "",
		CurrentValue = 2.5,
		Flag = "Slider1",
		Callback = function(Value)
			adis = Value
		end,
	})


	local MouseAim
	Groupbox:CreateToggle({
		Name = "准星自瞄",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			MouseAim = Value
		end,
	})

	local Disdis1
	Groupbox:CreateToggle({
		Name = "跟随距离额外增加预瞄量(小孩)",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(Value)
			Disdis1 = Value
		end,
	})

	local vdis = 10
	Groupbox:CreateSlider({
		Name = "预瞄量",
		Range = {0, 10},
		Increment = .1,
		Suffix = "",
		CurrentValue = 10,
		Flag = "Slider1",
		Callback = function(Value)
			vdis = Value
		end,
	})

	local pl1
	local pldaim = Groupbox:CreateDropdown({
		Special = 1,
		Name = "黑名单",
		Options = {},
		Required = false,
		Placeholder = "None Selected",
		Callback = function(Options)
			fpl = unpack(Options) and Players:FindFirstChild(unpack(Options)) or nil
		end,
	})

	local IsInFov = function(Anchor, Target, Fov)
		if not (typeof(Target) == "Vector3") then
			if not Target:IsA("BasePart") then return end
			Target = Target.Position
		end
		if not (typeof(Anchor) == "CFrame") then
			if not Anchor:IsA("BasePart") then return end
			Anchor = Anchor.CFrame
		end
		local A = CFrame.lookAt(Anchor.Position,Target)
		local cf = A
		local rotation =  (cf - cf.Position)
		local rx, ry, rz = rotation:ToOrientation()
		local orientationa = Vector3.new(math.deg(rx), math.deg(ry),math.deg(rz))

		local B = Anchor.Rotation
		local cf = B
		local rotation =  (cf - cf.Position)
		local rx, ry, rz = rotation:ToOrientation()
		local orientationb = Vector3.new(math.deg(rx), math.deg(ry),math.deg(rz))

		return (math.abs(orientationa.Y - orientationb.Y) <= Fov)
	end
	local aimbottargetplayer

	local ti = tick()

	local Killers = workspace.Players.Killers
	local Survivors = workspace.Players.Survivors
	local hookucf = false		
	local enabledautofix = false
	local fireserverhook
	local hook;hook =  hookmetamethod(game,"__namecall",function(self,...)
		local method = getnamecallmethod():lower()
		if tostring(method) == "fireserver" then
			fireserverhook = hook
			local args = {...}
			if args[1] == ("%*C00lkiddCollision"):format(Player.Name) then
				if c00lkidd then
					return
				end
			elseif args[1] ==  Player.Name.."VoidRushCollision" then
				if c00lkidd then
					return
				end
			end
		elseif tostring(method) == "invokeserver" then
			local args = {...}
			if self.Name == "RF" then
				if args[1] == "enter" and autofix then
					enabledautofix = true
					task.spawn(function()
						while enabledautofix and self.Parent.Parent.Progress.Value < 100 and autofix do
							task.wait(math.random(2,5))
							if not enabledautofix or self.Parent.Parent.Progress.Value >= 100 then
								return
							end
							self.Parent:FindFirstChild("RE"):FireServer()
						end
					end)
				else
					enabledautofix = false
				end
			end
		end
		return hook(self,...)
	end)

	local AnimationsTable = {
		Slash = "1",
		Entanglement = "1",
		MassInfection = "1",
		Behead = "3",
		GashingWoundStart = "1",
		CorruptEnergy = "1",
		Attack = "1",
		CorruptNature = "2",
		WalkspeedOverrideStart = "1",
		AimGun = "1",
		StaffShot = "2",
		ParryPunch = "1",
		Punch = "1",
		Charge = "3",
		Stab = "1",
		LungeStart = "1",
		NovaThrow = "2",
		StartDashInit = "3",
		LoopDashInit = "3",
	}

	local hitboxtable = {
		Slash = 1,
		MassInfection = 3,
		Behead = 1,
		GashingWound = 1,
		Attack = 1,
		ParryPunch = 1,
		Punch = 1,
		Charge = 1,
		Stab = 1,
		WalkspeedOverride = 2,
		VoidRush = 3,
		Nova = 2,
		["Carving Slash"] = 1,
		DemonicPursuit = 3,
		DigitalFootprint = 3,
		CorruptEnergy = 4,
		Axe = 2,
		Dagger = 1,
		Sk8 = 1,
		Shoot = 2,
	}

	local lastfakeposition
	local oldposition

	local oldfireserverc;oldfireserverc = hookfunction(require(game:GetService("ReplicatedStorage").Modules.Network.Network).FireServerConnection,function(self,Name,RE,...)
		local args = {...}

		if Name == "UseActorAbility" and hitboxtable[args[1]] then
			if hitbox then
				hookucf = true
				task.spawn(function()
					local t = tick()
					local b = hitboxtable[args[1]]
					local c = tick()

					local a;a = game:GetService("RunService").RenderStepped:Connect(function(dt)
						if tick() - t >= b then
							if oldposition then
								Player.Character:PivotTo(oldposition)
								oldposition = nil
							end
							hookucf = false
							workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
							a:Disconnect()
							return
						end

						local nearst

						if pl then
							nearst = pl.Character
						else
							for i,v in ipairs(workspace.Players:FindFirstChild(Players.LocalPlayer.Character.Parent == workspace.Players.Killers and "Survivors" or Players.LocalPlayer.Character.Parent == workspace.Players.Survivors and "Killers"):GetChildren()) do
								if Players:GetPlayerFromCharacter(v) and (not nearst or nearst and (v:IsA("Model") and v.Humanoid.Health ~= 0 and (v.PrimaryPart.Position - Players.LocalPlayer.Character.PrimaryPart.Position).Magnitude <= (nearst.PrimaryPart.Position - Players.LocalPlayer.Character.PrimaryPart.Position).Magnitude)) then
									nearst = v
								end
							end
						end
						if nearst then
							local Actor = Actors.CurrentActors[Player]
							local oldv = Players.LocalPlayer.Character.PrimaryPart.AssemblyLinearVelocity

							hookucf = true
							runned = true
							if not oldposition then
								oldposition = Player.Character:GetPivot()
							end

							local finalcf = CFrame.new(	nearst.PrimaryPart.Position + PlayerVelocityTable[Players:GetPlayerFromCharacter(nearst)] * (math.clamp(Player:GetNetworkPing(), 0, 100)+0.1))

							if autor then
								finalcf = CFrame.new(finalcf.Position) * nearst.PrimaryPart.CFrame.Rotation
							end


							Player.Character:PivotTo(finalcf)
							workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable

						else
							hookucf = false
							runned = false
							workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
							if oldposition then
								Player.Character:PivotTo(oldposition)
								oldposition = nil
							end
						end	
					end)
				end)
			end
		elseif Name == "UpdateCharacterPosition" then
			if (PosTog or oldposition) then
				if not checkcaller() then
					return
				end
			elseif FakeLag and math.floor(((tick()-ti)*2)%2) == 0 then
				return
			end
		end

		return oldfireserverc(self,Name,RE,...)
	end)
	if not _G.TDMMouseFunction then
		_G.TDMMouseFunction = require(game.ReplicatedStorage.Systems.Player.Miscellaneous.GetPlayerMousePosition).GetMousePos
	end
	table.insert(TDMConnections,RunService.Heartbeat:Connect(function(dt)
		if PosTog and Player.Character and Player.Character:FindFirstChild("QueryHitbox") then
			if (Player.Character:FindFirstChild("QueryHitbox").Position - Vector3.new(0,-6000,0)).Magnitude > 5 then
				require(game:GetService("ReplicatedStorage").Modules.Network.Network):FireServerConnection("UpdateCharacterPosition","UREMOTE_EVENT",require(game:GetService("ReplicatedStorage").Systems.Player.Game.CharacterReplication).Serialize(CFrame.new(0,-6000,0),Player.Character.PrimaryPart.AssemblyLinearVelocity))
			end
		end

		if autojump and game:GetService("ReplicatedStorage").Assets.Survivors.Veeronica.Behavior:FindFirstChild("Highlight") then
			if game:GetService("ReplicatedStorage").Assets.Survivors.Veeronica.Behavior:FindFirstChild("Highlight").Adornee == Player.Character then
				keypress(32)
				task.delay(1,function()
					keyrelease(32)
				end)
			end
		end

		local Actor = Actors.CurrentActors[Player]
		local AutoRotationValue = true
		if Actor then
			local function addanimationfunc(index,anim)
				if typeof(anim) == "table" then
					for i,v in ipairs(anim) do
						addanimationfunc(index,v)
					end
				elseif anim.IsPlaying then
					if AnimationsTable[index] then
						if UsingAim and CharacterAim and AnimationsTable[index] ~= "2" then
							Player.Character.Humanoid.AutoRotate = false
							require(game.ReplicatedStorage.Systems.Player.Game.SmoothShiftLock):ToggleShiftLock(false);
							AutoRotationValue = false
							local nearst

							if aimtargettype == "最近" then
								for _,v in pairs((Player.Character.Parent == workspace.Players.Killers and Survivors or Player.Character.Parent == workspace.Players.Survivors and Killers):GetChildren()) do
									if Players:GetPlayerFromCharacter(v) and (not nearst or (nearst and (nearst:GetPivot().Position - Player.Character:GetPivot().Position).Magnitude > (v:GetPivot().Position - Player.Character:GetPivot().Position).Magnitude and IsInFov(Player.Character:GetPivot(),v:GetPivot().Position,45) and nearst.Humanoid.Health > 0)) then
										nearst = v
									end
								end
							elseif aimtargettype == "血量最低" then
								for _,v in pairs((Player.Character.Parent == workspace.Players.Killers and Survivors or Player.Character.Parent == workspace.Players.Survivors and Killers):GetChildren()) do
									if Players:GetPlayerFromCharacter(v) and (not nearst or (nearst and v.Humanoid.Health > 0 and nearst.Humanoid.Health > v.Humanoid.Health)) then
										nearst = v
									end
								end
							end
							if not Player.Character.PrimaryPart.Anchored then
								if pl1 and Players:FindFirstChild(pl1) then
									local v = Players:FindFirstChild(pl1).Character
									local Distance = (v.CollisionHitbox.Position - Player.Character:GetPivot().Position).Magnitude

									local vcframe = v.CollisionHitbox.Position + PlayerVelocityTable[Players:GetPlayerFromCharacter(v)] * (1+PlayerPing) * (difdis and (DifDisTable[index] and DifDisTable[index](Distance) or 1) or ((Disdis and (Distance*adis*.1) or adis)))


									Player.Character:PivotTo(CFrame.new(Player.Character:GetPivot().Position,Vector3.new(vcframe.X,Player.Character:GetPivot().Y,vcframe.Z)))
								else
									local Distance = (nearst.CollisionHitbox.Position - Player.Character:GetPivot().Position).Magnitude
									local vcframe = nearst.CollisionHitbox.Position + PlayerVelocityTable[Players:GetPlayerFromCharacter(nearst)] * (1+PlayerPing) * (difdis and (DifDisTable[index] and DifDisTable[index](Distance) or 1) or ((Disdis and (Distance*adis*.1) or adis)))
									Player.Character:PivotTo(CFrame.new(Player.Character:GetPivot().Position,Vector3.new(vcframe.X,Player.Character:GetPivot().Y,vcframe.Z)))
									aimbottargetplayer = nearst
									if cameraaim or (difdis and AnimationsTable[index] == "3") then
										local cam = workspace.CurrentCamera
										cam.CFrame = CFrame.new(cam.CFrame.Position,Vector3.new(vcframe.X,cam.CFrame.Position.Y,vcframe.Z))
									end
								end
							end
						end
						if MouseAim and AnimationsTable[index] == "2" then
							require(game:GetService("ReplicatedStorage").Systems.Player.Miscellaneous.GetPlayerMousePosition).GetMousePos = function(v2)
								local l_Character_0 = Player.Character
								local v11 = require(game.ReplicatedStorage.Modules.Util);
								local l_v11_ClosestPlayerFromPosition_0 = v11:GetClosestPlayerFromPosition(l_Character_0 and l_Character_0.PrimaryPart and l_Character_0.PrimaryPart.Position or Vector3.new(), {
									PlayerSelection = Player.Character.Parent == workspace.Players.Killers and "Survivors" or Player.Character.Parent == workspace.Players.Survivors and "Killers", 
									ReturnTable = true
								});
								if pl1 and Players:FindFirstChild(pl1) then
									l_v11_ClosestPlayerFromPosition_0 = {
										[1] = {
											Player = Players:FindFirstChild(pl1).Character,
											l_Distance_0 = (Players:FindFirstChild(pl1).Character:GetPivot().Position - Player.Character:GetPivot().Position).Magnitude
										}
									}
								end
								for _, v14 in pairs(l_v11_ClosestPlayerFromPosition_0) do
									local l_Player_0 = v14.Player;
									local l_Distance_0 = v14.Distance;
									if l_Distance_0 then
										local l_Position_0 = l_Player_0.PrimaryPart.Position;
										local l_AssemblyLinearVelocity_0 = PlayerVelocityTable[Players:GetPlayerFromCharacter(l_Player_0)];
										if l_AssemblyLinearVelocity_0.Magnitude == 0 then
											return l_Position_0;
										else
											return l_Position_0 + l_AssemblyLinearVelocity_0 * PlayerPing * (difdis and (DifDisTable[index] and DifDisTable[index](l_Distance_0) or 1) or ((Disdis and (l_Distance_0*adis*.1) or adis)))
										end;
									end;
								end;
							end
						end
					end
				end
			end
			for i,v in pairs(Actor.Animations) do
				addanimationfunc(i,v)
			end
		end
		Player.Character.Humanoid.AutoRotate = AutoRotationValue
		if EatPizza or Pizza or n7 then
			for i,v in ipairs(workspace.Map.Ingame:GetChildren()) do
				if Pizza and Player.Character.Name == "Elliot" and v.Name == "Pizza" and isnetworkowner(v) then
					local targetplayer
					for i,v in ipairs(workspace.Players.Survivors:GetChildren()) do
						if v ~= Player.Character and v.Humanoid.Health < v.Humanoid.MaxHealth and (not targetplayer or (v.Humanoid.Health > 0 and v.Humanoid.Health < targetplayer.Humanoid.Health)) then
							targetplayer = v
						end
					end
					if pl1 then
						if Players:FindFirstChild(pl1) then
							local v = Players:FindFirstChild(pl1).Character
							targetplayer = v
						end
					end
					if targetplayer then
						v.Position = targetplayer.PrimaryPart.Position + PlayerVelocityTable[Players:GetPlayerFromCharacter(targetplayer)]*PlayerPing*2.5
					end
				end
				if EatPizza and v.Name == "Pizza" and not isnetworkowner(v) and Player.Character.Humanoid.Health < Player.Character.Humanoid.MaxHealth and Player.Character.Humanoid.Health > 0 then
					v.CFrame = Player.Character:GetPivot()
				end

				if n7 and Player.Character.Name == "007n7" and v.Name == "007n7" and isnetworkowner(v.PrimaryPart) then
					v.PrimaryPart.CanTouch = false
					v:PivotTo(Player.Character:GetPivot())
				end
			end
		end



		for i,v in ipairs(Players:GetPlayers()) do
			if aimbottargetplayer and aimbottargetplayer ~= v.Character and v.Character:FindFirstChild("AimLight") then
				v.Character:FindFirstChild("AimLight"):Destroy()
			end
			if aimbottargetplayer and not aimbottargetplayer:FindFirstChild("AimLight") then
				local light = Instance.new("Highlight",aimbottargetplayer)
				light.Name = "AimLight"
			end
		end

		if CharacterAim and not UsingAim and not Player.Character.PrimaryPart.Anchored then
			Player.Character.Humanoid.AutoRotate = false
			require(game.ReplicatedStorage.Systems.Player.Game.SmoothShiftLock):ToggleShiftLock(false);
			if pl1 then
				if Players:FindFirstChild(pl1) then
					local v = Players:FindFirstChild(pl1).Character
					local Distance = (v:GetPivot().Position - Player.Character:GetPivot().Position).Magnitude
					local vcframe = v:GetPivot().Position + v.PrimaryPart.AssemblyLinearVelocity * PlayerPing * (Disdis and (Distance*adis*.1) or adis)

					Player.Character:PivotTo(CFrame.new(Player.Character:GetPivot().Position,Vector3.new(vcframe.X,Player.Character:GetPivot().Y,vcframe.Z)))
				end
			else
				local nearst


				if aimtargettype == "最近" then
					for _,v in ipairs((Player.Character.Parent == workspace.Players.Killers and Survivors or Player.Character.Parent == workspace.Players.Survivors and Killers):GetChildren()) do
						if Players:GetPlayerFromCharacter(v) and (not nearst or (nearst and (nearst:GetPivot().Position - Player.Character:GetPivot().Position).Magnitude > (v:GetPivot().Position - Player.Character:GetPivot().Position).Magnitude and IsInFov(Player.Character:GetPivot(),v:GetPivot().Position,45) and nearst.Humanoid.Health > 0)) then
							nearst = v
						end
					end
				elseif aimtargettype == "血量最低" then
					for _,v in ipairs((Player.Character.Parent == workspace.Players.Killers and Survivors or Player.Character.Parent == workspace.Players.Survivors and Killers):GetChildren()) do
						if Players:GetPlayerFromCharacter(v) and (not nearst or (nearst and v.Humanoid.Health > 0 and nearst.Humanoid.Health > v.Humanoid.Health)) then
							nearst = v
						end
					end
				end
				local Distance = (nearst:GetPivot().Position - Player.Character:GetPivot().Position).Magnitude
				local vcframe = nearst:GetPivot().Position + PlayerVelocityTable[Players:GetPlayerFromCharacter(nearst)] * PlayerPing * (Disdis and (Distance*adis*.1) or adis)
				Player.Character:PivotTo(CFrame.new(Player.Character:GetPivot().Position,Vector3.new(vcframe.X,Player.Character:GetPivot().Y,vcframe.Z)))
				aimbottargetplayer = nearst
				if cameraaim then
					local cam = workspace.CurrentCamera
					cam.CFrame = CFrame.new(cam.CFrame.Position,Vector3.new(vcframe.X,cam.CFrame.Position.Y,vcframe.Z))
				end
			end
		end

		if not MouseAim then
			require(game:GetService("ReplicatedStorage").Systems.Player.Miscellaneous.GetPlayerMousePosition).GetMousePos = _G.TDMMouseFunction
		end
	end))

	local MainTab = TabSection:CreateTab({
		Name = "娱乐",
		Columns = 1,
	})

	local Groupbox = MainTab:CreateGroupbox({
		Name = "",
		Column = 1,
	})

	local tbk = {}

	for i,v in ipairs(game:GetService("ReplicatedStorage").Assets.Killers:GetChildren()) do
		tbk[#tbk+1] = v.Name
	end
	for i,v in ipairs(game:GetService("ReplicatedStorage").Assets.Survivors:GetChildren()) do
		tbk[#tbk+1] = v.Name
	end
	local Unit
	local allanimation = {}
	local Skins
	local Animation
	local AnimationsD
	local Skin
	local Sounds
	local Units = Groupbox:CreateDropdown({
		Name = "选择角色",
		Options = tbk,
		MultipleOptions = false,
		Flag = "Dropdown1",
		Callback = function(Options)


			Unit = game:GetService("ReplicatedStorage").Assets.Killers:FindFirstChild(unpack(Options),true) or game:GetService("ReplicatedStorage").Assets.Survivors:FindFirstChild(unpack(Options),true)
			Skin = nil
			local tbs = {}
			if game:GetService("ReplicatedStorage").Assets.Skins:FindFirstChild(unpack(Options),true) then
				for i,v in ipairs(game:GetService("ReplicatedStorage").Assets.Skins:FindFirstChild(unpack(Options),true):GetChildren()) do
					table.insert(tbs,v.Name) 
				end
			end
			Skins:Refresh(tbs)
			Skins:Set({""})

			local sound = {}

			for i,v in pairs(require(Unit.Config).Sounds) do
				if typeof(v) == "string" then
					table.insert(sound,i)
				elseif typeof(v) == "table" then
					for a,v in pairs(v) do
						table.insert(sound,i.."|"..a)
					end
				end
			end

			local Anima = {}

			for i,v in pairs(require(Unit.Config).Animations) do
				if typeof(v) == "string" then
					table.insert(Anima,i)
				elseif typeof(v) == "table" then
					for a,v in pairs(v) do
						table.insert(Anima,i.."|"..a)
					end
				end
			end

			allanimation = Anima

			AnimationsD:Set({CurrentOption = {""},Options = Anima})
			Sounds:Set({CurrentOption = {""},Options = sound})
		end,
	})
	Groupbox:CreateButton({
		Name = "获取角色",
		Callback = function()
			if not (Player.PlayerData.Purchased.Killers:FindFirstChild(Unit.Name) or Player.PlayerData.Purchased.Survivors:FindFirstChild(Unit.Name)) then
				local newvalue = Instance.new("IntValue")
				newvalue.Name = Unit.Name
				newvalue.Parent = Player.PlayerData.Purchased[Unit.Parent.Name]
			end
		end,
	})

	local unitlevel = 100
	Groupbox:CreateSlider({
		Name = "等级",
		Range = {0, 1000},
		Increment = 1,
		Suffix = "%",
		CurrentValue = 1,
		Flag = "Slider1",
		Callback = function(Value)
			unitlevel = Value
		end,
	})
	Groupbox:CreateButton({
		Name = "设置角色等级",
		Callback = function()
			if Player then
				local value = Player.PlayerData.Purchased.Killers:FindFirstChild(Unit.Name) or Player.PlayerData.Purchased.Survivors:FindFirstChild(Unit.Name)

				if value then

					local v16 = 0;
					for v17 = 1, unitlevel - 1 do
						v16 = v16 + math.round(100 + 10 * v17);
					end;
					value.Value = v16;
				end;
			end;
		end,
	})
	Skins = Groupbox:CreateDropdown({
		Name = "选择皮肤",
		Options = {},
		MultipleOptions = false,
		Flag = "Dropdown1",
		Callback = function(Options)
			pcall(function()
				Skin = game:GetService("ReplicatedStorage").Assets.Skins:FindFirstChild(unpack(Options),true) or nil
				local sound = {}
				if require(Skin.Config).Sounds then
					for i,v in pairs(require(Skin.Config).Sounds) do
						if typeof(v) == "string" then
							table.insert(sound,i)
						elseif typeof(v) == "table" then
							for a,v in pairs(v) do
								table.insert(sound,i.."|"..a)
							end
						end
					end
				end
				Sounds:Set({CurrentOption = {""},Options = sound})
				local Anima = {}
				if require(Skin.Config).Animations then
					for i,v in pairs(require(Skin.Config).Animations) do
						if typeof(v) == "string" then
							table.insert(Anima,i)
						elseif typeof(v) == "table" then
							for a,v in pairs(v) do
								table.insert(Anima,i.."|"..a)
							end
						end
					end
				end
				Animations:Set({CurrentOption = {""},Options = Anima})
			end)
		end,
	})
	Groupbox:CreateButton({
		Name = "获取皮肤",
		Callback = function()
			if not (Player.PlayerData.Purchased.Skins:FindFirstChild(Skin.Name)) then
				local newvalue = Instance.new("IntValue")
				newvalue.Name = Skin.Name
				newvalue.Parent = Player.PlayerData.Purchased.Skins
			end
		end,
	})
	local Sound

	Sounds = Groupbox:CreateDropdown({
		Name = "选择音效",
		Options = {},
		MultipleOptions = false,
		Flag = "Dropdown1",
		Callback = function(Options)
			local config
			if Skin then
				config = require(Skin.Config)
			elseif Unit then
				config = require(Unit.Config)
			end
			if config.Sounds then
				if string.find(unpack(Options),"|") then
					if tostring(tonumber(string.sub(unpack(Options),string.find(unpack(Options),"|")+1,-1))) == string.sub(unpack(Options),string.find(unpack(Options),"|")+1,-1) then
						Sound = config.Sounds[string.sub(unpack(Options),1,string.find(unpack(Options),"|")-1)][tonumber(string.sub(unpack(Options),string.find(unpack(Options),"|")+1,-1))]
					else
						Sound = config.Sounds[string.sub(unpack(Options),1,string.find(unpack(Options),"|")-1)][string.sub(unpack(Options),string.find(unpack(Options),"|")+1,-1)]
					end
					if typeof(Sound) == "table" and Sound.ID then
						Sound = Sound.ID
					end
				else
					Sound = config.Sounds[unpack(Options)]
				end
			end
		end,
	})

	local PlaySound = Groupbox:CreateButton({
		Name = "播放音效",
		Callback = function()
			require(game:GetService("ReplicatedStorage").Modules.Sounds):Play(Sound)
		end,
	})
	local PlaySound = Groupbox:CreateButton({
		Name = "停止音效",
		Callback = function()
			require(game:GetService("ReplicatedStorage").Modules.Sounds):Stop(Sound)
		end,
	})



	AnimationsD = Groupbox:CreateDropdown({
		Name = "选择动画",
		Options = {},
		MultipleOptions = false,
		Flag = "Dropdown1",
		Callback = function(Options)
			local config
			if Skin then
				config = require(Skin.Config)
			elseif Unit then
				config = require(Unit.Config)
			end
			if config and config.Animations and unpack(Options) ~= "" then
				if string.find(unpack(Options),"|") then
					local Animator = game:GetService("Players").LocalPlayer.Character.Humanoid:FindFirstChild("Animator") or Instance.new("Animator",game:GetService("Players").LocalPlayer.Character.Humanoid)
					local animation = Animator:FindFirstChild(unpack(Options)) or Instance.new("Animation",Animator)
					animation.AnimationId = config.Animations[string.sub(unpack(Options),1,string.find(unpack(Options),"|")-1)][string.sub(unpack(Options),string.find(unpack(Options),"|")+1,-1)]
					animation.Name = unpack(Options)
					Animation = Animator:LoadAnimation(animation)
				else

					local Animator = game:GetService("Players").LocalPlayer.Character.Humanoid:FindFirstChild("Animator") or Instance.new("Animator",game:GetService("Players").LocalPlayer.Character.Humanoid)
					local animation = Animator:FindFirstChild(unpack(Options)) or Instance.new("Animation",Animator)
					animation.AnimationId = config.Animations[unpack(Options)]
					animation.Name = unpack(Options)
					if unpack(Options) == "Walk" or unpack(Options) == "Run" or unpack(Options) == "Idle" then
						Animation = Animator:LoadAnimation(animation)
						Animation.Priority = Enum.AnimationPriority.Core;
					else
						Animation = Animator:LoadAnimation(animation)
					end


				end
			end
		end,
	})

	local PlayAnimation = Groupbox:CreateButton({
		Name = "播放动画",
		Callback = function()
			Animation:Play()
		end,
	})

	local PlayAnimation = Groupbox:CreateButton({
		Name = "停止动画",
		Callback = function()
			Animation:Stop()
		end,
	})

	local CUSound
	local cus = Groupbox:CreateDropdown({
		Name = "选择当前角色音效",
		Options = {},
		MultipleOptions = false,
		Flag = "Dropdown1",
		Callback = function(Options)
			CUSound = unpack(Options)
		end,
	})

	local CUAnimation
	local cua = Groupbox:CreateDropdown({
		Name = "选择当前角色动画",
		Options = {},
		MultipleOptions = false,
		Flag = "Dropdown1",
		Callback = function(Options)
			CUAnimation = unpack(Options)
		end,
	})

	local a = Groupbox:CreateButton({
		Name = "刷新列表",
		Callback = function()
			if Actors.CurrentActors[Players] then
				local p = Actors.CurrentActors[Players]
				if p.Config then
					local Config = p.Config
					if Config.Sounds then
						local sound = {}
						for i,v in pairs(Config.Sounds) do
							if typeof(v) == "string" then
								table.insert(sound,i)
							elseif typeof(v) == "table" then
								for a,v in pairs(v) do
									table.insert(sound,i.."|"..a)
								end
							end
						end

						cus:Refresh({CurrentOption = {""},Options = sound})
					end
					if Config.Animations then
						local Ani = {}
						for i,v in pairs(Config.Animations) do
							if typeof(v) == "string" then
								table.insert(Ani,i)
							elseif typeof(v) == "table" then
								for a,v in pairs(v) do
									table.insert(Ani,i.."|"..a)
								end
							end
						end

						cua:Refresh({CurrentOption = {""},Options = Ani})
					end
				end
			end


		end,
	})

	local a = Groupbox:CreateButton({
		Name = "替换选择动画",
		Callback = function()
			if Actors.CurrentActors[Player] then
				local p = Actors.CurrentActors[Players]
				if p.Config then
					local Config = p.Config
					if Config.Animations then
						if string.find(CUAnimation,"|") then
							if tostring(tonumber(string.sub(CUAnimation,string.find(CUAnimation,"|")+1,-1))) == string.sub(CUAnimation,string.find(CUAnimation,"|")+1,-1) then
								p.Animations[string.sub(CUAnimation,1,string.find(CUAnimation,"|")-1)][tonumber(string.sub(CUAnimation,string.find(CUAnimation,"|")+1,-1))] = Animation
							else
								p.Animations[string.sub(CUAnimation,1,string.find(CUAnimation,"|")-1)][string.sub(CUAnimation,string.find(CUAnimation,"|")+1,-1)] = Animation
							end
						else
							p.Animations[CUAnimation] = Animation
						end
					end
				end
			end
		end,
	})

	Groupbox:CreateButton({
		Name = "一键替换动画",
		Callback = function()
			if Actors.CurrentActors[Player] then
				local p = Actors.CurrentActors[Player]
				if p.Config then
					local Config = p.Config
					if Config.Animations then
						local config
						if Skin then
							config = require(Skin.Config)
						elseif Unit then
							config = require(Unit.Config)
						end
						for i,v in pairs(allanimation) do
							pcall(function()
								local CUAnimation = v

								local Animation
								if config and config.Animations and v ~= "" then
									if string.find(v,"|") then
										local Animator = game:GetService("Players").LocalPlayer.Character.Humanoid:FindFirstChild("Animator") or Instance.new("Animator",game:GetService("Players").LocalPlayer.Character.Humanoid)
										local animation = Animator:FindFirstChild(v) or Instance.new("Animation",Animator)
										if typeof(config.Animations[string.sub(v,1,string.find(v,"|")-1)][string.sub(v,string.find(v,"|")+1,-1)]) == "string" then
											animation.AnimationId = config.Animations[string.sub(v,1,string.find(v,"|")-1)][string.sub(v,string.find(v,"|")+1,-1)]
											animation.Name = v
											Animation = Animator:LoadAnimation(animation)
										end
									else
										local Animator = game:GetService("Players").LocalPlayer.Character.Humanoid:FindFirstChild("Animator") or Instance.new("Animator",game:GetService("Players").LocalPlayer.Character.Humanoid)
										local animation = Animator:FindFirstChild(v) or Instance.new("Animation",Animator)
										animation.AnimationId = config.Animations[v]
										animation.Name = v
										if typeof(config.Animations[v]) == 'string' then
											if v == "Walk" or v == "Run" or v == "Idle" then
												Animation = Animator:LoadAnimation(animation)
												Animation.Priority = Enum.AnimationPriority.Core;
											else
												Animation = Animator:LoadAnimation(animation)
											end
										end

									end
								end
								if string.find(CUAnimation,"|") then
									if not p.Animations[string.sub(CUAnimation,1,string.find(CUAnimation,"|")-1)] then
										p.Animations[string.sub(CUAnimation,1,string.find(CUAnimation,"|")-1)] = {}
									end
									p.Animations[string.sub(CUAnimation,1,string.find(CUAnimation,"|")-1)][string.sub(CUAnimation,string.find(CUAnimation,"|")+1,-1)] = Animation

								else
									p.Animations[CUAnimation] = Animation
								end
							end)
						end
					end
				end
			end
		end,
	})



	table.insert(TDMConnections,RunService.RenderStepped:Connect(function()
		if InfStamina then
			require(game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting).Stamina = math.huge
		end
	end))
end
