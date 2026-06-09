local Players = game:GetService("Players")

if identifyexecutor() == "Delta" then
	--getrenv().RunInDeltaUi = readfile("TDM/DeltaUiEnabled") == "true"
end
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/qian-cheng-awa/Rayfield/refs/heads/main/Main.lua'))()
local Player = Players.LocalPlayer
local GuiMain = game.CoreGui
if gethui then
	GuiMain = gethui()
end

local AlrLoaded = {}

local function GetApi(Url)
	if not AlrLoaded[Url] then
		AlrLoaded[Url] = loadstring(game:HttpGet(Url))()
	end
	return AlrLoaded[Url]
end
if game.CoreGui:FindFirstChild("TDMEsp") then
	game.CoreGui:FindFirstChild("TDMEsp"):Destroy()
end
local TDMRunId = game:GetService("HttpService"):GenerateGUID(true)

local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local EspFolder = Instance.new("Folder",game.CoreGui)
EspFolder.Name = "TDMEsp"
local ElseEsp = Instance.new("Folder",EspFolder)
ElseEsp.Name = "Else"
local ScreenSize = workspace.CurrentCamera.ViewportSize
local Esped = {}
local PlayerVelocityTable = {}
local LastPositionTable = {}

local function GetScale(Size)
	return UDim2.new(0,ScreenSize.X*Size.X.Scale,0,Size.Y.Scale*ScreenSize.Y)
end
local Request = (syn and syn.request) or request or http_request
local TargetPartName = "HumanoidRootPart"
local GenericHumanoidTargetPartName = TargetPartName	
local LineColor = Color3.new(255, 255, 255)
local TeammateLineColor = Color3.new(0, 0.25, 1)
local GenericHumanoidLineColor = Color3.new(1, 0, 0)
local LineWidth = 0.5
local DrawTeammates = true
local FindHumanoids = true
local GetLineOrigin = function(Camera)
	return Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y*.9)
end

local Camera = workspace.CurrentCamera
local LineOrigin = nil
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	LineOrigin = GetLineOrigin(Camera)
end)
LineOrigin = GetLineOrigin(Camera)


local Gui = Instance.new("ScreenGui")
Gui.Name = "SnaplineGui"
Gui.Parent = EspFolder
local Lines = {}


function Setline(Line, Width, Color, Origin, Destination)
	local  espvaluetable = {}
	espvaluetable.Position = (Origin + Destination) / 2
	Line.Position = UDim2.new(0,  espvaluetable.Position.X, 0,  espvaluetable.Position.Y)
	espvaluetable.Length = (Origin - Destination).Magnitude
	Line.BackgroundColor3 = Color
	Line.BorderColor3 = Color
	Line.Size = UDim2.new(0,  espvaluetable.Length, 0, Width)
	Line.Rotation = math.deg(math.atan2(Destination.Y - Origin.Y, Destination.X - Origin.X))
end

local function Esp(Toggle,Objective,FolderName,Text,TextColor,Size,Change,Func,StrokeColor,TextSize)
	local espvaluetable = {
		Folder = EspFolder:FindFirstChild(FolderName) or Instance.new("Folder",EspFolder)
	}
	espvaluetable.Folder.Name = FolderName
	if not Toggle then
		if not espvaluetable.Folder:GetAttribute("Toggle") then
			return
		end
	end
	espvaluetable.Folder:SetAttribute("Toggle",Toggle)
	for i,v in ipairs(espvaluetable.Folder:GetChildren()) do
		v.Enabled = Toggle
		if v:IsA("BillboardGui") and Toggle then
			v.Enabled = v.Adornee:IsDescendantOf(workspace)
		end
	end

	if Objective and not Esped[Objective] then
		Esped[Objective] = {
			Color = TextColor or StrokeColor or Color3.new(0,0,0),
			EspPFolder = espvaluetable.Folder or EspFolder:FindFirstChild(FolderName)
		}
		espvaluetable.esp = Instance.new("BillboardGui",espvaluetable.Folder)
		espvaluetable.esp.Adornee = Objective
		espvaluetable.esp.AlwaysOnTop = true
		if not Size then
			local pos,siz
			if Objective:IsA("Model") then
				pos,siz = Objective:GetBoundingBox()
			elseif Objective:IsA("BasePart") then
				siz = Objective.Size
			end
			local longger
			if siz.X>siz.Z then
				longger = siz.X
			else
				longger = siz.Z
			end
			Size = UDim2.fromScale(longger,siz.Y)
		end
		espvaluetable.esp.Size = Size
		espvaluetable.esp.ResetOnSpawn = false
		espvaluetable.esp.ClipsDescendants = false

		espvaluetable.secondframe = Instance.new("Frame", espvaluetable.esp)
		espvaluetable.secondframe.Size = UDim2.fromScale(0.95,0.95)
		espvaluetable.secondframe.AnchorPoint = Vector2.new(0.5,0.5)
		espvaluetable.secondframe.Position = UDim2.fromScale(0.5,0.5)
		espvaluetable.secondframe.BackgroundTransparency = 1
		espvaluetable.NameEsp = Instance.new("TextLabel", espvaluetable.esp)
		espvaluetable.NameEsp.BackgroundTransparency = 1
		espvaluetable.NameEsp.TextScaled = true
		espvaluetable.NameEsp.TextColor3 = Color3.new(1,1,1)
		espvaluetable.NameEsp.AnchorPoint = Vector2.new(0.5,0.5)
		espvaluetable.NameEsp.Position = UDim2.fromScale(0.5,0.5)
		espvaluetable.stroke = Instance.new("UIStroke",espvaluetable.NameEsp)
		espvaluetable.stroke.Thickness = 1
		espvaluetable.stroke.Color = Color3.new(0,0,0)
		espvaluetable.NameEsp.Text = Text
		espvaluetable.NameEsp.TextColor3 = TextColor or Color3.new(1,1,1)
		espvaluetable.NameEsp.Size = TextSize or UDim2.fromScale(1,1)
		espvaluetable.stroke = Instance.new("UIStroke", espvaluetable.secondframe)
		espvaluetable.stroke.Thickness = 1
		espvaluetable.stroke.Color = StrokeColor or Color3.new(0,0,0)
		if Change and Func then
			Change:Connect(function()
				Func(espvaluetable.esp)
			end)
		end
		if Objective:IsDescendantOf(workspace) then
			espvaluetable.esp.Enabled = true
		else
			espvaluetable.esp.Enabled = false
		end
		Objective.Destroying:Connect(function()
			espvaluetable.esp:Destroy()
			Esped[Objective] = nil
		end)
	end
end
local HttpService = game:GetService("HttpService")



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

local velocityHandlerName = "addaawadsd"
local gyroHandlerName = "adwasdawsd"
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

local PlayerPing = Player:GetNetworkPing()
print("start")
if true then
	local aaa = game:GetService("VirtualUser")
	pcall(function()
		game:GetService('Players').LocalPlayer.Idled:connect(function()
			aaa:CaptureController()
			aaa:ClickButton2(Vector2.new())
		end)
	end)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()

	local sus,gameinfo = pcall(function()
		return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
	end)
	if not sus then
		gameinfo = {
			IconImageAssetId = 109251559,
			Name = "TDM",
		}
	end
	local Window = Rayfield:CreateWindow({
		Name = "TDM V3.0",
		Icon = gameinfo.IconImageAssetId,
		LoadingUiIcon = gameinfo.IconImageAssetId,
		ShowText = "TDM",
		LoadingUiText = gameinfo.Name,
		LoadingTitle = "TDM",
		LoadingSubtitle = "by 牢大",
		Theme = "Amethyst",
		DisableRayfieldPrompts = false,
		DisableBuildWarnings = false,
		ConfigurationSaving = {
			Enabled = false,
		},
	})
	task.delay(Random.new(Random.new(RandomSeed):NextInteger(1,500000)):NextNumber(0,2),function()
		EnabledAntiHook = false
	end)
	for i,v in pairs({
		"TDMInputBegan",
		"TDMInputEnded",
		"TDMhookmetamethod",
		"TDMRenderStepped",
		"TDMHeartbeat",
		}) do
		Rayfield["_G"][v] = {}
	end
	local MainTab = Window:CreateTab("通用功能", "airplay")
	local function Message(_Title, _Text, Time)
		game:GetService("StarterGui"):SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
	end

	local function SkidFling(TargetPlayer)
		local valuetable = {}

		valuetable.Character = Player.Character
		valuetable.Humanoid = valuetable.Character and valuetable.Character:FindFirstChildOfClass("Humanoid")
		valuetable.RootPart = valuetable.Humanoid and valuetable.Humanoid.RootPart

		valuetable.TCharacter = TargetPlayer.Character
		valuetable.THumanoid = valuetable.TCharacter and valuetable.TCharacter:FindFirstChildOfClass("Humanoid")
		valuetable.TRootPart = valuetable.THumanoid and valuetable.THumanoid.RootPart
		valuetable.THead = valuetable.TCharacter and valuetable.TCharacter:FindFirstChild("Head")
		valuetable.Accessory = valuetable.TCharacter and valuetable.TCharacter:FindFirstChildOfClass("Accessory")
		valuetable.Handle = valuetable.Accessory and valuetable.Accessory:FindFirstChild("Handle")

		if valuetable.Character and valuetable.Humanoid and valuetable.RootPart then
			if valuetable.RootPart.Velocity.Magnitude < 50 then
				getgenv().OldPos = valuetable.RootPart.CFrame
			end
			if valuetable.THumanoid and valuetable.THumanoid.Sit then
				return Message("Error Occurred", "Target is sitting", 5)
			end
			if valuetable.THead then
				workspace.CurrentCamera.CameraSubject = valuetable.THead
			elseif valuetable.Handle then
				workspace.CurrentCamera.CameraSubject = valuetable.Handle
			else
				workspace.CurrentCamera.CameraSubject = valuetable.THumanoid
			end
			if not valuetable.TCharacter:FindFirstChildWhichIsA("BasePart") then
				return
			end

			local function FPos(BasePart, Pos, Ang)
				valuetable.RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
				valuetable.Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
				valuetable.RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
				valuetable.RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
			end

			local function SFBasePart(BasePart)
				local TimeToWait = 2
				local Time = tick()
				local Angle = 0

				repeat
					if valuetable.RootPart and valuetable.THumanoid then
						if BasePart.Velocity.Magnitude < 50 then
							Angle = Angle + 100

							FPos(BasePart, CFrame.new(0, 1.5, 0) + valuetable.THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
							task.wait()

							FPos(BasePart, CFrame.new(0, -1.5, 0) + valuetable.THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + valuetable.THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + valuetable.THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, 1.5, 0) + valuetable.THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, -1.5, 0) + valuetable.THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
							task.wait()
						else
							FPos(BasePart, CFrame.new(0, 1.5, valuetable.THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, -1.5, -valuetable.THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, 1.5, valuetable.THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, 1.5, valuetable.TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, -1.5, -valuetable.TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, 1.5, valuetable.TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
							task.wait()
						end
					else
						break
					end
				until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or TargetPlayer.Character ~= valuetable.TCharacter or valuetable.THumanoid.Sit or valuetable.Humanoid.Health <= 0 or tick() > Time + TimeToWait
			end

			workspace.FallenPartsDestroyHeight = 0/0

			local BV = Instance.new("BodyVelocity")
			BV.Name = "EpixVel"
			BV.Parent = valuetable.RootPart
			BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
			BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

			valuetable.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

			if valuetable.TRootPart and valuetable.THead then
				if (valuetable.TRootPart.CFrame.p - valuetable.THead.CFrame.p).Magnitude > 5 then
					SFBasePart(valuetable.THead)
				else
					SFBasePart(valuetable.TRootPart)
				end
			elseif valuetable.TRootPart and not valuetable.THead then
				SFBasePart(valuetable.TRootPart)
			elseif not valuetable.TRootPart and valuetable.THead then
				SFBasePart(valuetable.THead)
			elseif not valuetable.TRootPart and not valuetable.THead and valuetable.Accessory and valuetable.Handle then
				SFBasePart(valuetable.Handle)
			end

			BV:Destroy()
			valuetable.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
			workspace.CurrentCamera.CameraSubject = valuetable.Humanoid

			repeat
				valuetable.RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
				valuetable.Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
				valuetable.Humanoid:ChangeState("GettingUp")
				table.foreach(valuetable.Character:GetChildren(), function(_, x)
					if x:IsA("BasePart") then
						x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
					end
				end)
				task.wait()
			until (valuetable.RootPart.Position - getgenv().OldPos.p).Magnitude < 25
			workspace.FallenPartsDestroyHeight = getgenv().FPDH
		else
			return Message("Error Occurred", "Random error", 5)
		end
	end
	if identifyexecutor() == "Delta" then
		local imageid
		MainTab:CreateInput({
			Name = "图像id",
			CurrentValue = "",
			PlaceholderText = "输入数字",
			RemoveTextAfterFocusLost = false,
			Flag = "Input1",
			Callback = function(Text)
				imageid = Text
			end,
		})

		MainTab:CreateButton({
			Name = "更改忍者图标为输入的roblox图像资源",
			Desc = "更改后重启roblox",
			Callback = function()
				if imageid and imageid ~= "" then
					writefile("new_logo.png", game:HttpGet("https://assetdelivery.roblox.com/v1/asset/?id="..imageid))
				end
			end    
		})
		MainTab:CreateToggle({
			Name = "使用新版（忍者）UI",
			CurrentValue = getrenv().RunInDeltaUi,
			Callback = function(Value)
				getrenv().RunInDeltaUi = Value
				writefile("TDM/DeltaUiEnabled", tostring(Value))
			end    
		})
	end
	MainTab:CreateSection("加入别人的服务器")
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
	MainTab:CreateInput({
		Name = "用户名或者用户id",
		CurrentValue = "",
		PlaceholderText = "输入数字/文字",
		RemoveTextAfterFocusLost = false,
		Flag = "Input1",
		Callback = function(Text)
			teleportvaluestable.telepoartuserid = Text
		end,
	})


	MainTab:CreateButton({
		Name = "开始传送(必须和所选择玩家处同一游戏)",
		Callback = function()
			if teleportvaluestable.telepoartuserid ~= '' and teleportvaluestable.telepoartuserid then 
				teleportvaluestable.run(game.PlaceId,teleportvaluestable.telepoartuserid)
			end
		end,
	})


	MainTab:CreateSection("保存建筑文件")
	local Path
	MainTab:CreateInput({
		Name = "输入路径(留空默认保存全部可见模型)",
		CurrentValue = "",
		PlaceholderText = "输入文字",
		RemoveTextAfterFocusLost = false,
		Flag = "Input1",
		Callback = function(Text)
			Path = Text
		end,
	})
	local FileName
	MainTab:CreateInput({
		Name = "输入文件名",
		CurrentValue = "",
		PlaceholderText = "输入文字",
		RemoveTextAfterFocusLost = false,
		Flag = "Input1",
		Callback = function(Text)
			FileName = Text
		end,
	})
	local saveplayermodel = false
	MainTab:CreateToggle({
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
	MainTab:CreateButton({
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

	MainTab:CreateSection("功能")
	MainTab:CreateButton({
		Name = "IY",
		Callback = function()
			loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'),true))()
		end,
	})
	MainTab:CreateButton({
		Name = "DEX",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/qian-cheng-awa/Dex-/refs/heads/main/Main"))()
		end,
	})

	MainTab:CreateButton({
		Name = "Rspy",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
		end,
	})

	MainTab:CreateButton({
		Name = "Rspy客户端事件记录版",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/qian-cheng-awa/Tools/refs/heads/main/RemoteSpy-ClientLog.lua"))()
		end,
	})

	MainTab:CreateButton({
		Name = "保存场景/saveinstance(支持更多注入器)",
		Callback = function()
			local Params = {
				RepoURL = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/",
				SSI = "saveinstance",
			}
			local synsaveinstance = loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
			local Options = {}
			synsaveinstance(Options)
		end,
	})

	MainTab:CreateSection("甩飞")

	local fpl
	local playertb = {}
	for i,v in ipairs(Players:GetPlayers()) do
		playertb[#playertb + 1] = v.Name
	end
	local pld2 =  MainTab:CreateDropdown({
		Name = "黑名单",
		Options = playertb,
		MultipleOptions = false,
		CanNoneSeleted = true,
		Flag = "Dropdown1",
		Callback = function(Options)
			fpl = unpack(Options) and Players:FindFirstChild(unpack(Options)) or nil
		end,
	})
	local Button = MainTab:CreateButton({
		Name = "甩飞",
		Callback = function()
			if fpl then
				if fpl.Character then
					SkidFling(fpl)
				end
			end
		end,
	})
	Players.PlayerAdded:Connect(function()
		local playertb = {}
		for i,v in ipairs(Players:GetPlayers()) do
			playertb[#playertb + 1] = v.Name
		end
		pld2:Refresh(playertb)
	end)
	Players.PlayerRemoving:Connect(function()
		local playertb = {}
		for i,v in ipairs(Players:GetPlayers()) do
			playertb[#playertb + 1] = v.Name
		end
		pld2:Refresh(playertb)
	end)
	MainTab:CreateSection("速度")
	local CFrameSpeed = 2

	MainTab:CreateSlider({
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

	MainTab:CreateToggle({
		Name = "启用",
		CurrentValue = false,
		Callback = function(Value)
			CFrameSpeedEnabled = Value
		end    
	})

	MainTab:CreateSection("飞行")

	MainTab:CreateToggle({
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
	MainTab:CreateToggle({
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
	MainTab:CreateSlider({
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
	MainTab:CreateToggle({
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
				button.MouseButton1Down:Connect(function()
					down = true
				end)
				button.MouseLeave:Connect(function()
					down = false
				end)
				buttonu.MouseButton1Down:Connect(function()
					up = true
				end)
				buttonu.MouseLeave:Connect(function()
					up = false
				end)
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

	MainTab:CreateSlider({
		Name = "飞行速度",
		Range = {0, 100},
		CurrentValue = 2,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		Callback = function(Value)
			flyspeed = Value
		end    
	})

	MainTab:CreateSlider({
		Name = "上升/下降速度",
		Range = {0, 100},
		CurrentValue = 50,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		Callback = function(Value)
			ds = Value
		end    
	})
	MainTab:CreateSection("自瞄")
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
	moveaimbutton.MouseButton1Down:Connect(function()
		moveaimbuttonvalue = true
	end)
	moveaimbutton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			moveaimbuttonvalue = false
		end
	end)
	MainTab:CreateToggle({
		Name = "开启自瞄",
		CurrentValue = false,
		Callback = function(Value)
			mainaimbot = Value
		end    
	})
	local wallcheck = false
	MainTab:CreateToggle({
		Name = "墙体检测",
		CurrentValue = false,
		Callback = function(Value)
			wallcheck = Value
		end    
	})
	local teamcheck = false
	MainTab:CreateToggle({
		Name = "团队检测",
		CurrentValue = false,
		Callback = function(Value)
			teamcheck = Value
		end    
	})
	MainTab:CreateToggle({
		Name = "自瞄按钮",
		CurrentValue = false,
		Callback = function(Value)
			mainaimbotenabled = not Value
			moveaimbuttonvalue = false
			aimbuttonscreen.Enabled = Value
		end    
	})
	local lockposition = false
	MainTab:CreateToggle({
		Name = "锁定自瞄按钮位置",
		CurrentValue = false,
		Callback = function(Value)
			lockposition = Value
		end    
	})
	MainTab:CreateSlider({
		Name = "按钮大小",
		Range = {0, ScreenSize.X > ScreenSize.Y and ScreenSize.X or ScreenSize.Y},
		CurrentValue = 200,
		Increment = 1,
		Suffix = "",
		Callback = function(Value)
			aimbutton.Size = UDim2.new(0,Value,0,Value)
		end    
	})
	local pingpre = false
	MainTab:CreateToggle({
		Name = "延迟补偿",
		CurrentValue = false,
		Callback = function(Value)
			pingpre = Value
		end    
	})
	local aimdistancemain = 0
	MainTab:CreateSlider({
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
	MainTab:CreateToggle({
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
	MainTab:CreateSlider({
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
	MainTab:CreateToggle({
		Name = "开启自瞄半径",
		CurrentValue = false,
		Callback = function(Value)
			aimcircle = Value
			AimbotCircle.Enabled = Value
		end    
	})

	MainTab:CreateSection("透视")

	local NormalEspPlayer = false

	MainTab:CreateToggle({
		Name = "透视玩家",
		CurrentValue = false,
		Callback = function(Value)
			NormalEspPlayer = Value
		end    
	})
	local EspRay = false

	MainTab:CreateToggle({
		Name = "透视射线",
		CurrentValue = false,
		Callback = function(Value)
			EspRay = Value
		end    
	})



	MainTab:CreateSlider({
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
	table.insert(Rayfield["_G"].TDMInputBegan,function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local mouse = Players.LocalPlayer:GetMouse()
			local mouseposition = Vector2.new(mouse.X,mouse.Y)
			if (mouseposition-aimbutton.AbsolutePosition+-aimbutton.AbsoluteSize/2).Magnitude <= aimbutton.AbsoluteSize.Y/2 then
				mainaimbotenabled = true
			end
		end
	end)
	table.insert(Rayfield["_G"].TDMInputEnded,function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			if mainaimbotenabled and aimbuttonscreen.Enabled then
				mainaimbotenabled = false
			end
		end
	end)
	table.insert(Rayfield["_G"].TDMHeartbeat,function(dt)
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
				elseif v.Character:GetPivot().Position == LastPositionTable[v] then
					continue
				end
				PlayerVelocityTable[v] = (v.Character:GetPivot().Position - LastPositionTable[v])/dt
				LastPositionTable[v] = v.Character:GetPivot().Position
			end
		end
		if EspRay then
			local Targets = {}
			for i, v in pairs(Esped) do
				local pos
				if i:IsA("Model") then
					pos = i:GetPivot()
				else
					pos = i.Position
				end
				if typeof(pos) == "CFrame" then
					pos = pos.Position
				end
				if i and i.Parent then
					local ScreenPoint, OnScreen = Camera:WorldToScreenPoint(pos)
					if OnScreen then
						Targets[i] = {Vector2.new(ScreenPoint.X, ScreenPoint.Y), v.Color or LineColor}
						if not Lines[i] then
							local NewLine = Instance.new("Frame")
							NewLine.Name = "Snapline"
							NewLine.AnchorPoint = Vector2.new(.5, .5)
							local linesscreen = v.EspPFolder:FindFirstChild("Lines") or Instance.new("ScreenGui",v.EspPFolder)
							linesscreen.Name = "Lines"
							NewLine.Parent = linesscreen
							Lines[i] = NewLine
						end
					end
				end
			end
			for i, Line in pairs(Lines) do
				local TargetData = Targets[i]
				if not TargetData or not i.Parent or not i:IsDescendantOf(workspace) then
					Line:Destroy()
					Lines[i] = nil

				else
					Setline(Line, LineWidth, TargetData[2], LineOrigin, TargetData[1])
				end

			end
		else
			for i, Line in pairs(Lines) do
				Line:Destroy()
				Lines[i] = nil
			end
		end
	end)
	table.insert(Rayfield["_G"].TDMRenderStepped,function(dt)
		Gui.Enabled = EspRay
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
		for i,v in ipairs(PlayerEsp:GetChildren()) do
			v.Enabled = NormalEspPlayer
		end
		for i,v in ipairs(Players:GetPlayers()) do
			if v.Character and not Esped[v.Character] and v ~= Player then
				Esped[v.Character] = {Color = Color3.new(0.537255, 0.690196, 0.976471),EspPFolder = PlayerEsp}

				local sus,res = pcall(function()
					local esp1 = Instance.new("BillboardGui",PlayerEsp)
					esp1.Adornee = v.Character:FindFirstChild("HumanoidRootPart") or v.Character.PrimaryPart
					esp1.AlwaysOnTop = true
					esp1.Size = UDim2.new(4,0,7,0)
					esp1.ResetOnSpawn = false
					esp1.ClipsDescendants = false
					local esp2 = Instance.new("BillboardGui",PlayerEsp)
					esp2.Adornee = v.Character:FindFirstChild("HumanoidRootPart") or v.Character.PrimaryPart
					esp2.AlwaysOnTop = true
					esp2.Size = GetScale(UDim2.new(.1,0,.2,0))
					esp2.ResetOnSpawn = false
					esp2.ClipsDescendants = false
					local secondframe = Instance.new("Frame",esp1)
					secondframe.Size = UDim2.fromScale(0.95,0.95)
					secondframe.AnchorPoint = Vector2.new(0.5,0.5)
					secondframe.Position = UDim2.fromScale(0.5,0.5)
					secondframe.BackgroundTransparency = 1

					local Humanoid = v.Character:FindFirstChild("Humanoid")

					if Humanoid then
						local HealthEsp = Instance.new("Frame",esp2)
						HealthEsp.Size = UDim2.fromScale(1,0.05)
						HealthEsp.Position = UDim2.fromScale(0,.1)
						local HealthText = Instance.new("TextLabel",esp2)
						HealthText.BackgroundTransparency = 1
						HealthText.TextScaled = true
						HealthText.TextColor3 = Color3.new(1,1,1)
						local stroke = Instance.new("UIStroke",HealthText)
						stroke.Thickness = 1

						HealthText.Size = UDim2.fromScale(1,.1)
						local C = Instance.new("UICorner",HealthEsp)
						C.CornerRadius = UDim.new(1,0)
						local G = Instance.new("UIGradient",HealthEsp)
						local function update()
							pcall(function()
								HealthText.Text = ("%*/%*"):format(math.floor(Humanoid.Health),Humanoid.MaxHealth)
								G.Color = ColorSequence.new(Humanoid.Health == 0 and Color3.new(0.75, 0.25, 0) or Humanoid.Health == Humanoid.MaxHealth and Color3.new(0, 1, 0) or {
									ColorSequenceKeypoint.new(0,Color3.new(0,1,0)),
									ColorSequenceKeypoint.new(Humanoid.Health/Humanoid.MaxHealth,Color3.new(0,1,0)),
									ColorSequenceKeypoint.new(Humanoid.Health/Humanoid.MaxHealth+0.001,Color3.new(0.75, 0.25, 0)),
									ColorSequenceKeypoint.new(1,Color3.new(0.75, 0.25, 0))
								})
							end)
						end
						update()
						Humanoid:GetPropertyChangedSignal("Health"):Connect(update)
						Humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(update)
					end
					local NameEsp = Instance.new("TextLabel",esp2)
					NameEsp.BackgroundTransparency = 1
					NameEsp.TextScaled = true
					NameEsp.TextColor3 = Color3.new(1,1,1)
					NameEsp.ZIndex = -1
					local YTEsp = Instance.new("TextLabel",esp2)
					YTEsp.BackgroundTransparency = 1
					YTEsp.TextScaled = true
					YTEsp.TextColor3 = Color3.new(0, 1, 0)
					YTEsp.Text = '在墙后'
					YTEsp.Size = UDim2.fromScale(1,0.2)
					YTEsp.AnchorPoint = Vector2.new(.5,1)
					YTEsp.Position = UDim2.fromScale(.5,1)

					local stroke = Instance.new("UIStroke",NameEsp)
					stroke.Thickness = 1
					local stroke = Instance.new("UIStroke",secondframe)
					stroke.Thickness = 1
					NameEsp.Text = ("%*"):format(v.Name)
					NameEsp.Size = UDim2.fromScale(1,0.2)
					NameEsp.AnchorPoint = Vector2.new(.5,.5)
					NameEsp.Position = UDim2.fromScale(.5,.5)
					table.insert(Rayfield["_G"].TDMRenderStepped,function(dt)
						if not v.Character or not v.Character.Parent then
							return
						end
						if v.Team then
							NameEsp.TextColor3 = v.Team == Player.Team and Color3.new(0,0,1) or Color3.new(1,0,0)
						end
						local raycastp = RaycastParams.new()
						raycastp.FilterType = Enum.RaycastFilterType.Exclude
						raycastp.FilterDescendantsInstances = {v.Character,Player.Character}
						if workspace:Raycast(Player.Character:GetPivot().Position,v.Character:GetPivot().Position - Player.Character:GetPivot().Position,raycastp) then
							YTEsp.Text = "在墙后"
							YTEsp.TextColor3 = Color3.new(0,1,0)
						else
							YTEsp.Text = "在视野中"
							YTEsp.TextColor3 = Color3.new(1,0,0)
						end
					end)
					if game.PlaceId == 18687417158 and v.Character.Parent ~= workspace.Players.Spectating and v.Character.Parent ~= workspace then
						NameEsp.Text = ("%*\n%*"):format(v.Name,v.Character.Name)
						NameEsp.TextColor3 = v.Character.Parent.Name == "Killers" and Color3.new(1,0,0) or Color3.new(1,1,0)
						Esped[v.Character].Color = v.Character.Parent.Name == "Killers" and Color3.new(1,0,0) or Color3.new(1,1,0)
						stroke.Color = v.Character.Parent.Name == "Killers" and Color3.new(1,0,0) or Color3.new(1,1,0)
						local stroke = Instance.new("UIStroke",NameEsp)
						stroke.Thickness = 1
					end

					local esp = Instance.new("BillboardGui",PlayerEsp)
					esp.Adornee = v.Character:FindFirstChild("Head") or nil
					esp.AlwaysOnTop = true
					esp.Size = UDim2.new(2,0,2,0)
					esp.ResetOnSpawn = false
					esp.ClipsDescendants = false
					local secondframe = Instance.new("Frame",esp)
					secondframe.Size = UDim2.fromScale(0.95,0.95)
					secondframe.AnchorPoint = Vector2.new(0.5,0.5)
					secondframe.Position = UDim2.fromScale(0.5,0.5)
					secondframe.BackgroundTransparency = 1
					local stroke = Instance.new("UIStroke",secondframe)
					stroke.Thickness = 1
					local C = Instance.new("UICorner",secondframe)
					C.CornerRadius = UDim.new(1,0)
					v.Character.Destroying:Connect(function()
						esp:Destroy()
						esp1:Destroy()
						Esped[v.Character] = nil
					end)
				end)
				if not sus then
					print(v,res)
				end
			end
		end
	end)

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
		local Tab = Window:CreateTab("自动弹琴", "airplay")

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
		local ad = Tab:CreateDropdown({
			Name = "选择文件",
			Options = Folder,
			MultipleOptions = false,
			Flag = "Dropdown1",
			Callback = function(Options)
				midiData = MidiToTable(Options[1] and readfile("TDM/AutoPiano/"..Options[1]))
				Disabled = {}
				local tracks = {}

				for i=1,#midiData.tracks do
					table.insert(tracks, tostring(i))
				end

				yg:Refresh(tracks)
			end,
		})

		Tab:CreateButton({
			Name = "刷新",
			Callback = function()
				local Folder = listfiles("TDM/AutoPiano")
				for i,v in pairs(Folder) do
					Folder[i] = string.gsub(v,"TDM/AutoPiano/","",1)
				end
				ad:Refresh(Folder)
			end,
		})

		local qy

		yg = Tab:CreateDropdown({
			Name = "音轨",
			Options = {},
			MultipleOptions = true,
			Flag = "Dropdown1",
			Callback = function(Options)
				if #Options > 1 then
					qy:Set(false)
				else
					qy:Set(Disabled[tonumber(Options[1])])
				end
			end,
		})

		qy = Tab:CreateToggle({
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

		Tab:CreateSlider({
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
		Tab:CreateToggle({
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

	if game.PlaceId == 14279724900 then

		local times = game:GetService("ReplicatedStorage").Game.Clock
		local character = game:GetService("ReplicatedStorage").Chapter
		local firsttower = nil
		local gameend = game:GetService("ReplicatedStorage").ended
		local inm = game:GetService("ReplicatedStorage").ended.inMenu
		local F = {}

		local inc = false
		local Tab = Window:CreateTab("主要功能", "camera")
		local RS = game:GetService("ReplicatedStorage")
		local CurrentTowers = {}
		local function updatetowers(v)
			if tostring(v:GetAttribute("Creator")) == Player.Name then
				table.insert(CurrentTowers, v)
			end
		end
		for i,v in ipairs(workspace:WaitForChild("Scripted"):WaitForChild("TowerData"):GetChildren()) do
			updatetowers(v)
		end
		workspace:WaitForChild("Scripted"):WaitForChild("TowerData").ChildAdded:Connect(updatetowers)

		Tab:CreateSection("倍速")
		local waveskiptoggle
		local speed = 5
		Tab:CreateDropdown({
			Name = "选择倍速",
			Options = {"1","2", "3", "4", "5","6"},
			CurrentOption = {"5"},
			MultipleOptions = false,
			Callback = function(Options)
				speed = tonumber(unpack(Options))
			end,
		})
		local V1 = false
		Tab:CreateToggle({
			Name = "锁定倍速",
			CurrentValue = false,
			Callback = function(Value)
				V1 = Value
				pcall(function()
					while true do
						if gameend.Value ~= true then
							repeat 
								game:GetService("RunService").RenderStepped:Wait()
								if V1 == false then
									return
								end
							until game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Speed").Value ~= speed
							game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Speed"):WaitForChild("Change"):FireServer(tonumber(speed))
						end
						game:GetService("RunService").RenderStepped:Wait()
					end
				end)
			end,
		})
		local ping = true
		Tab:CreateSection("录制")
		Tab:CreateButton({
			Name = "全部升级",
			Desc = "录制别用自带的容易卡bug",
			Callback = function()
				pcall(function()
					for i,v in ipairs(CurrentTowers) do
						for i=1,5,1 do
							game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("UpgradeTower"):FireServer(tostring(v.Name))
						end
					end
				end)
				local currenttick = ping and times.Value - PlayerPing or times.Value
				if inc == true then
					F[#F+1] = {tostring(currenttick),"AllUpgraded"}
				end
			end,
		})
		Tab:CreateToggle({
			Name = "自动跳波",
			CurrentValue = false,
			Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				waveskiptoggle = Value
				repeat
					if waveskiptoggle ~= false and gameend.Value == false then
						game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("waveSkip"):FireServer(true)
					end
					game:GetService("RunService").RenderStepped:Wait()
				until waveskiptoggle == false
			end,
		})
		local V11 = false
		Tab:CreateToggle({
			Name = "自动解冻",
			CurrentValue = false,
			Callback = function(Value)
				V11 = Value
				pcall(function()
					while true do
						if V11 == false then
							return
						end
						for i,v in ipairs(CurrentTowers) do
							game:GetService("ReplicatedStorage"):WaitForChild("UnfreezeRequest"):FireServer(v.Name)
						end
						game:GetService("RunService").RenderStepped:Wait()
					end
				end)
			end,
		})
		Tab:CreateSection("录制")

		Tab:CreateToggle({
			Name = "延迟补偿",
			CurrentValue = ping,
			Flag = "Toggle1",
			Callback = function(Value)
				ping = Value
			end,
		})
		Tab:CreateButton({
			Name = "开始录制",
			Desc = "一定要点击重播之后再录制,点击重播自动结束录制",
			Callback = function()
				Rayfield:Notify({
					Title = "TDM",
					Content = "已开始录制",
					Duration = 6.5,
					Image = 4483362458,
				})
				inc = true
			end,
		})
		Tab:CreateButton({
			Name = "保存",
			Desc = "",
			Callback = function()
				Save(F,character.Value)
				Rayfield:Notify({
					Title = "TDM",
					Content = "录制结束",
					Duration = 6.5,
					Image = 4483362458,
				})
				inc = false
				F = {}
			end,
		})
		local waveskipenabled
		local V = false
		Tab:CreateToggle({
			Name = "开始执行",
			Desc = "重播页面开启",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				V = Value
				local data = Load(character.Value)
				if data then
					while true do
						for i,v in pairs(data) do
							local currenttick = ping and times.Value - PlayerPing or times.Value
							if currenttick < tonumber(v[1]) then
								repeat
									currenttick = ping and times.Value - PlayerPing or times.Value
									if V == false or gameend.Value then break end
									game:GetService("RunService").Heartbeat:Wait()
								until currenttick >= tonumber(v[1])
							end
							if V == false or gameend.Value then break end
							local sus,err = pcall(function()
								if v[2] == "placeTower" then
									pcall(function()
										local cefra = v[4]:split(", ")
										game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild(tostring(v[2])):FireServer(v[3],CFrame.new(unpack(cefra)),v[5] == "true")
									end)
								elseif v[2] == "BoostSelect" then
									pcall(function()
										game:GetService("ReplicatedStorage"):WaitForChild("BoostSelect"):FireServer(tonumber(CurrentTowers[tonumber(v[3])].Name),tostring(CurrentTowers[tonumber(v[4])].Name))
									end)
								elseif v[2] == "TimestopEvent" then
									pcall(function()
										game:GetService("ReplicatedStorage"):WaitForChild("TimestopEvent"):FireServer()
									end)
								elseif v[2] == "AllUpgraded" then
									pcall(function()
										for i,v in ipairs(CurrentTowers) do
											for i=1,5,1 do
												game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("UpgradeTower"):FireServer(tostring(v.Name))
											end
										end
									end)
								elseif v[2] == "spawnTowerAbility" then
									pcall(function()
										game:GetService("ReplicatedStorage"):WaitForChild("TowerScript"):WaitForChild("spawnTowerAbility"):InvokeServer(CurrentTowers[tonumber(v[3])].Name,v[4])
									end)
								elseif v[2] == "waveSkip" then
									pcall(function()
										game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("waveSkip"):FireServer(true)
									end)
								else
									pcall(function()
										print(CurrentTowers[tonumber(v[3])])
										game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild(tostring(v[2])):FireServer(tostring(CurrentTowers[tonumber(v[3])].Name))
									end)
								end
							end)
							if not sus then
								Rayfield:Notify({
									Title = "TDM",
									Content = "执行错误！"..err,
									Duration = 6.5,
									Image = 4483362458,
								})
							end
						end
						repeat
							game:GetService("RunService").RenderStepped:Wait()
						until gameend.Value == true or V == false
						while true do
							if V == false then
								return
							end
							if gameend.Value == true then
								times.Value = 0 
								CurrentTowers = {}
								game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("ReplayCore"):FireServer()
							else
								times.Value = 0
								game:GetService("ReplicatedStorage"):WaitForChild("GAME_START"):WaitForChild("readyButton"):FireServer(game:GetService("Players").LocalPlayer)
								if workspace:FindFirstChild("Map") then
									break
								end
							end
							game:GetService("RunService").RenderStepped:Wait()
						end
						if V == false then
							return
						end
					end
				else
					Rayfield:Notify({
						Title = "TDM",
						Content = "未找到录制文件",
						Duration = 6.5,
						Image = 4483362458,
					})
				end
			end,
		})
		local hook;hook = hookmetamethod(game, "__namecall",newcclosure(function(self,...)
			if getnamecallmethod():lower() == "fireserver" then
				local args = {...}
				if inc then
					local currenttick = ping and times.Value + PlayerPing or times.Value

					if self == RS.Event.placeTower then
						F[#F+1] = {tostring(currenttick), self.Name, tostring(args[1]), tostring(args[2]), tostring(args[3])}
					elseif self == RS.Event.RemoveTower or self == RS.Event.UpgradeTower or self == RS.Event.ChangeTowerTargetMode then
						for i, v in ipairs(CurrentTowers) do
							if v.Name == args[1] then
								F[#F+1] = {tostring(currenttick), self.Name, tostring(i)}
							end
						end
					elseif self == RS.BoostSelect then
						F[#F+1] = {tostring(currenttick), self.Name, tostring(args[1]), tostring(args[2])}
					elseif self == RS.TimestopEvent then
						F[#F+1] = {tostring(currenttick), self.Name}
					elseif self == RS.Event.ReplayCore then
						Save(F, character.Value)
						inc = false
						Rayfield:Notify({
							Title = "TDM",
							Content = "录制结束",
							Duration = 6.5,
							Image = 4483362458,
						})
						F,CurrentTowers = {},{}
					elseif self == RS.Event.waveSkip and not checkcaller() then
						F[#F+1] = {tostring(currenttick), self.Name}
					end
				else
					if self == RS.Event.ReplayCore then
						F,CurrentTowers = {},{}
					end
				end
			elseif getnamecallmethod():lower() == "invokeserver" then
				if inc and self == RS.TowerScript.spawnTowerAbility then
					local args = {...}
					for i,v in ipairs(CurrentTowers) do
						if v.Name == args[1] then
							F[#F+1] = {tostring(ping and times.Value + PlayerPing or times.Value),self.Name,tostring(i),args[2]}
						end
					end
				end
			end
			return hook(self,...)
		end))
	elseif game.PlaceId == 14279693118 then
		local player = game:GetService("Players").LocalPlayer
		local SaveAbb = {"Eq1","Eq2","Eq3","Eq4","Eq5","Eq6","Eq7","Eq8","Eq9","Eq10"}
		local Tab = Window:CreateTab("主要功能", "camera")
		local Section = Tab:CreateSection("通行证奖励查询")
		local runmode = 1
		local tx
		local Input = Tab:CreateInput({
			Name = "用户名",
			CurrentValue = "",
			PlaceholderText = "输入文字",
			RemoveTextAfterFocusLost = false,
			Flag = "Input1",
			Callback = function(Text)
				Username = Text
			end,
		})
		Tab:CreateDropdown({
			Name = "关键词",
			Options = {"CrateTokens","Credits","Clocks","Diamond","Golden","Cursed","LuckyShard","Boost2X","Boost3X","Coupon","Premium"},
			MultipleOptions = true,
			Flag = "Dropdown1",
			Callback = function(Options)
				tx = Options
			end,
		})
		Tab:CreateDropdown({
			Name = "运行模式",
			Options = {"具体","数量统计"},
			MultipleOptions = false,
			Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Options)
				local pz = unpack(Options)
				if pz == "具体" then
					runmode = 1
				elseif pz == "数量统计" then
					runmode = 2
				end
			end,
		})
		local function fy(tx)
			local txt = tx
			txt = string.gsub(txt,"CrateTokens","箱子钥匙")
			txt = string.gsub(txt,"Crystal","水晶")
			txt = string.gsub(txt,"Boost2X","2倍积分")
			txt = string.gsub(txt,"Unit","角色")
			txt = string.gsub(txt,"Credits","积分")
			txt = string.gsub(txt,"LuckyShard","幸运碎片")
			txt = string.gsub(txt,"Coupon/Premium","高级升级优惠券")
			txt = string.gsub(txt,"Coupon/Normal","升级优惠券")
			txt = string.gsub(txt,"Shard","碎片")
			txt = string.gsub(txt,"Diamond","钻石")
			txt = string.gsub(txt,"Goldenen","黄金金（bug）")
			txt = string.gsub(txt,"Golden","黄金")
			txt = string.gsub(txt,"Cursed","诅咒")
			txt = string.gsub(txt,"Premium","高级货币")
			txt = string.gsub(txt,"Boost3X","3倍积分")
			txt = string.gsub(txt,"Mahoraga","魔虚罗/伏黑惠")
			txt = string.gsub(txt,"SukunaTV","宿傩")
			txt = string.gsub(txt,"Mahito","真人")
			txt = string.gsub(txt,"volcanospeaker","漏壶")
			txt = string.gsub(txt,"MiniTSM","终极音响")
			txt = string.gsub(txt,"UltimateCamera","终极监控")
			txt = string.gsub(txt,"UpgradedTitanTVMan","UTTV")
			txt = string.gsub(txt,"UltimateTV","终极电视")
			txt = string.gsub(txt,"TitanSpeakerToilet","马桶音响")
			txt = string.gsub(txt,"AstroUTCM","天文UTC")
			txt = string.gsub(txt,"OverchargedUTS","充能UTS")
			txt = string.gsub(txt,"TitanClockman","泰坦时钟")
			txt = string.gsub(txt,"FutureLargeClock","未来")
			txt = string.gsub(txt,"UpgradedTitanCameraman","UTC")
			txt = string.gsub(txt,"UpgradedTitanSpeakerman","UTS")
			txt = string.gsub(txt,"yugi","虎杖")
			txt = string.gsub(txt,"ReaperCamera","镰刀")
			txt = string.gsub(txt,"AUTTVM","工作室UTTV")
			txt = string.gsub(txt,"Clocks","时钟币")
			return txt
		end
		Tab:CreateButton({
			Name = "保存查询结果",
			Callback = function()
				local PlayerService = game:GetService("Players")
				local free = "\n 免费通行证 \n\n"
				local prem = "\n 高级通行证 \n\n"
				local tab = {free = {},perm = {}}
				local tbl_7_upvr = {}
				local httpService = game:GetService("HttpService")
				local Rewards = require(game.ReplicatedStorage.BattlepassUpdate.Rewards)
				local InfiniteReward_upvr = require(game.ReplicatedStorage.BattlepassUpdate.XPGivings).InfiniteReward
				local var82_upvw = 1
				local len_upvr_2 = #tbl_7_upvr
				local random_state_upvr = Random.new(PlayerService:GetUserIdFromNameAsync(Username))
				print(PlayerService:GetUserIdFromNameAsync(Username))
				local len_upvr = #InfiniteReward_upvr
				local var86_upvw = tbl_7_upvr[#tbl_7_upvr]
				local function ResyncEndless()
					if 1000 < var82_upvw then
					else
						for i_8 = var82_upvw, 1000 do
							local var91 = len_upvr_2 + i_8
							local var92
							var92 = 1
							while not nil do
								local var93 = InfiniteReward_upvr[random_state_upvr:NextInteger(1, len_upvr)]
								if var93[3] <= i_8 and i_8 <= (var93[4] or math.huge) and not var93[5] and random_state_upvr:NextInteger(1, var93[6] or 1) == 1 then
									if tx then
										for i,v in pairs(tx) do
											if string.find(var93[1],v) then
												free = free.."等级 "..tostring(i_8).."   奖励 "..fy(var93[1]).."\n"
												tab.free[var93] = 1 + (tab.free[var93] or 0)
												break
											end
										end
									else
										free = free.."等级 "..tostring(i_8).."   奖励 "..fy(var93[1]).."\n"
										tab.free[var93] = 1 + (tab.free[var93] or 0)
									end
									break
								end
							end
							while not nil do
								local var94 = InfiniteReward_upvr[random_state_upvr:NextInteger(1, len_upvr)]
								if var94[3] <= i_8 and i_8 <= (var94[4] or math.huge) and random_state_upvr:NextInteger(1, var94[6] or 1) == 1 and var92 <= var94[2] then
									if tx then
										for i,v in pairs(tx) do
											if string.find(var94[1],v) then
												prem = prem.."等级 "..tostring(i_8).."   奖励 "..fy(var94[1]).."\n"
												tab.perm[var94] = 1 + (tab.perm[var94] or 0)
												break
											end
										end
									else
										prem = prem.."等级 "..tostring(i_8).."   奖励 "..fy(var94[1]).."\n"
										tab.perm[var94] = 1 + (tab.perm[var94] or 0)
									end
									break
								end
							end
						end
					end
				end
				ResyncEndless()
				if runmode == 1 then
					writefile("TDM/BattlePass/"..Username..".txt", free..prem)
					Rayfield:Notify({
						Title = "TDM",
						Content = "文件已保存至 注入器文件夹/TDM/BattlePass/"..Username..".txt",
						Duration = 6.5,
						Image = 4483362458,
					})
				elseif runmode == 2 then
					local free = "\n 免费通行证 \n\n"
					local prem = "\n 高级通行证 \n\n"
					for i,v in pairs(tab.free) do
						free = free..'"'..fy(i[1])..'"'.." = "..v.."\n"
					end
					for i,v in pairs(tab.perm) do
						prem = prem..'"'..fy(i[1])..'"'.." = "..v.."\n"
					end
					writefile("TDM/BattlePass/"..Username..".txt", free..prem)
					Rayfield:Notify({
						Title = "TDM",
						Content = "文件已保存至 注入器文件夹/Workspace/TDM/BattlePass/"..Username..".txt",
						Duration = 6.5,
						Image = 4483362458,
					})
				end
			end,
		})
		Tab:CreateButton({
			Name = "保存此赛季的无尽通行证奖励",
			Callback = function()
				local Rewards = require(game.ReplicatedStorage.BattlepassUpdate.Rewards)
				local InfiniteReward_upvr = require(game.ReplicatedStorage.BattlepassUpdate.XPGivings).InfiniteReward
				local inftf = "免费通行证\n\n\n"
				local inftp = "\n\n\n高级通行证\n\n\n"
				local count = 0
				for i,v in pairs(InfiniteReward_upvr) do
					count = count + 1
				end
				for i,v in pairs(InfiniteReward_upvr) do
					if v[5] == true then
						inftp = inftp..string.format("%s 所需经验(%s) 最小刷新等级(%s) 最大刷新等级(%s) 刷新概率(1/%s) \n\n",fy(v[1]),tostring(v[2] * 8000),tostring(v[3]),tostring(v[4]),tostring(v[6]+count))
					else
						inftf = inftf..string.format("%s 所需经验(%s) 最小刷新等级(%s) 最大刷新等级(%s) 刷新概率(1/%s) \n\n",fy(v[1]),tostring(v[2] * 8000),tostring(v[3]),tostring(v[4]),tostring(v[6]+count))
					end
				end
				writefile("TDM/InfRewards/Rewards.txt", inftf..inftp)
				Rayfield:Notify({
					Title = "TDM",
					Content = "文件已保存至 注入器文件夹/Workspace/TDM/InfRewards/Rewards.txt",
					Duration = 6.5,
					Image = 4483362458,
				})
			end,
		})
		Tab:CreateSection("保存塔")

		local slc = "1"

		Tab:CreateDropdown({
			Name = "选择槽位",
			Options = {"1","2","3","4","5","6","7","8","9","10"},
			CurrentOption = {"1"},
			MultipleOptions = false,
			Flag = "Dropdown1",
			Callback = function(Options)
				slc = unpack(Options)
			end,
		})

		Tab:CreateButton({
			Name = "保存当前装备的塔到该槽位",
			Callback = function()
				local eq = {}
				for i,v in pairs(SaveAbb) do
					eq[v] = player:GetAttribute(v)
				end
				Save(eq,slc,"SaveTowers")
			end,
		})

		Tab:CreateButton({
			Name = "加载当前槽位保存的塔",
			Callback = function()
				local data = Load(slc,"SaveTowers")
				if data then
					for i,v in pairs(SaveAbb) do
						pcall(function()
							game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("equipID"):FireServer(player:GetAttribute(v),false)
							game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("equipID"):FireServer(data[v],true)
						end)
					end
				end
			end,
		})
	elseif game.PlaceId == 18711550363 then
		local Tab = Window:CreateTab("主要功能", "camera")
		Tab:CreateSection("挂机")
		local V1 = false
		local Toggle = Tab:CreateToggle({
			Name = "自动抽奖（最大速度）",
			CurrentValue = false,
			Callback = function(Value)
				V1 = Value
				pcall(function()
					while true do
						if V1 == false then
							return
						end
						game:GetService("ReplicatedStorage"):WaitForChild("Roll"):FireServer(game:GetService("Players").LocalPlayer:GetAttribute("MaxSpeed"))
						wait()
					end
				end)
			end,
		})
	elseif game.PlaceId == 70876832253163 then
		local Tab = Window:CreateTab("主要功能", "camera")
		local Section = Tab:CreateSection("物品")
		function updataitems()
			local items = {}
			for i,v in ipairs(workspace.RuntimeItems:GetChildren()) do
				items[#items+1] = tostring(i).."/"..tostring(v.Name)
			end
			return items
		end
		local item
		local V1 = false
		local Toggle = Tab:CreateToggle({
			Name = "物品透视",
			CurrentValue = false,
			Callback = function(Value)
				V1 = Value
			end,
		})
		local Dropdown = Tab:CreateDropdown({
			Name = "选择物品",
			Options = updataitems(),
			MultipleOptions = false,
			Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Options)
				print(string.sub(unpack(Options),0,string.find(unpack(Options),"/")-1))
				item = workspace.RuntimeItems:GetChildren()[tonumber(string.sub(unpack(Options),0,string.find(unpack(Options),"/")-1))]
			end,
		})
		workspace:WaitForChild("RuntimeItems").ChildAdded:Connect(function()
			Dropdown:Refresh(updataitems())
		end)
		workspace:WaitForChild("RuntimeItems").ChildRemoved:Connect(function()
			Dropdown:Refresh(updataitems())
		end)

		local Button = Tab:CreateButton({
			Name = "固定物品到火车上(可能会导致火车卡住)",
			Callback = function()
				if item then
					if item:GetAttribute("IsBeingDragged") then
						Rayfield:Notify({
							Title = "提示",
							Content = "目标已被其他玩家抓取！",
							Duration = 6.5,
							Image = "rewind",
						})
					else
						game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("Weld"):WaitForChild("RequestWeld"):FireServer(item,workspace:WaitForChild("Train"):WaitForChild("Platform"):WaitForChild("Part"))
					end
				else
					Rayfield:Notify({
						Title = "提示",
						Content = "请先选择一个物品！",
						Duration = 6.5,
						Image = "rewind",
					})
				end
			end,
		})
		local Section = Tab:CreateSection("敌对生物")
		local V2 = false
		local Toggle = Tab:CreateToggle({
			Name = "敌对生物透视",
			CurrentValue = false,
			Callback = function(Value)
				V2 = Value
			end,
		})




		table.insert(Rayfield["_G"].TDMRenderStepped,function()
			if V1 then
				pcall(function()
					for i,itemi in ipairs(workspace.RuntimeItems:GetChildren()) do
						if not itemi:GetAttribute("ESP") then
							itemi:SetAttribute("ESP",true)
							local bill = Instance.new("BillboardGui")
							bill.Name = "Espui"
							bill.Parent = itemi
							bill.Adornee = itemi
							bill.Size = UDim2.new(10,0,5,0)
							bill.AlwaysOnTop = true
							local textlabel = Instance.new("TextLabel")
							textlabel.Parent = bill
							textlabel.Size = UDim2.new(1,0,1,0)
							textlabel.BackgroundTransparency = 1
							textlabel.Text = itemi.Name
							if itemi:FindFirstChild("Humanoid") then
								textlabel.TextColor3 = Color3.new(0.509804, 0.203922, 0.203922)
							else
								textlabel.TextColor3 = Color3.new(1,1,1)
							end
							textlabel.TextScaled = true
							local stk = Instance.new("UIStroke")
							stk.Parent = textlabel
							stk.Thickness = 2
							stk.LineJoinMode = Enum.LineJoinMode.Miter
						end
					end
				end)
			else
				pcall(function()
					for i,itemi in ipairs(workspace.RuntimeItems:GetChildren()) do
						if itemi:GetAttribute("ESP") then
							itemi:SetAttribute("ESP",false)
							itemi:FindFirstChild("Espui"):Destroy()
						end
					end
				end)
			end
			if V2 then
				pcall(function()
					for i,en in ipairs(workspace:GetDescendants()) do
						if en:FindFirstChild("Configuration") and en:FindFirstChild("Humanoid") and en.Parent ~= workspace.RuntimeItems then
							if not en:GetAttribute("ESP") then
								en:SetAttribute("ESP",true)
								local bill = Instance.new("BillboardGui")
								bill.Name = "Espui"
								bill.Parent = en
								bill.Adornee = en
								bill.Size = UDim2.new(10,0,5,0)
								bill.AlwaysOnTop = true
								local textlabel = Instance.new("TextLabel")
								textlabel.Parent = bill
								textlabel.Size = UDim2.new(1,0,1,0)
								textlabel.BackgroundTransparency = 1
								textlabel.Text = en.Name
								textlabel.TextColor3 = Color3.new(1, 0, 0)
								textlabel.TextScaled = true
								local stk = Instance.new("UIStroke")
								stk.Parent = textlabel
								stk.Thickness = 2
								stk.LineJoinMode = Enum.LineJoinMode.Miter
							end
						elseif en:FindFirstChild("Configuration") and en:FindFirstChild("Humanoid") and en.Parent == workspace.RuntimeItems then
							if en:GetAttribute("ESP") then
								en:SetAttribute("ESP",false)
								en:FindFirstChild("Espui"):Destroy()
							end
						end
					end
				end)
			else
				pcall(function()
					for i,en in ipairs(workspace:GetDescendants()) do
						if en:FindFirstChild("Humanoid") and en:FindFirstChild("Configuration") and en.Parent ~= workspace.RuntimeItems then
							if en:GetAttribute("ESP") then
								en:SetAttribute("ESP",false)
								en:FindFirstChild("Espui"):Destroy()
							end
						end
					end
				end)
			end
		end)
	elseif game.PlaceId == 18687417158 or game.PlaceId == 83645629621104 then
		local Tab = Window:CreateTab("主要功能", "camera")
		local Section = Tab:CreateSection("功能")
		local InfStamina = false
		Tab:CreateToggle({
			Name = "无限体力",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				InfStamina = Value
			end,
		})


		local FakeLag = false

		Tab:CreateToggle({
			Name = "伪装高ping(自身碰撞箱不受影响)",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				FakeLag = Value
			end,
		})

		local autojump = false
		Tab:CreateToggle({
			Name = "维罗妮卡自动跳跃",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				autojump = Value
			end
		})

		local oldsk8
		Tab:CreateToggle({
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


		local Sprinting = require(game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting)

		Tab:CreateSection("体力")
		Tab:CreateInput({
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
		Tab:CreateInput({
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
		Tab:CreateInput({
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
		Tab:CreateInput({
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
		Tab:CreateSection("透视")
		local ESP = {
			["Items"] = false,
			["Generator"] = false
		}
		Tab:CreateToggle({
			Name = "透视物品",
			CurrentValue = false,
			Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				ESP.Items = Value
			end,
		})
		Tab:CreateToggle({
			Name = "透视电机",
			CurrentValue = false,
			Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				ESP.Generator = Value
			end,
		})
		Tab:CreateToggle({
			Name = "透视披萨",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				ESP.Pizza = Value
			end,
		})
		Tab:CreateToggle({
			Name = "透视塔夫拌线/子空间地雷",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				ESP.Taph = Value
			end,
		})
		Tab:CreateToggle({
			Name = "透视建造师炮塔/回血装置",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				ESP.Builder = Value
			end,
		})

		local Tab = Window:CreateTab("高危功能", "camera")
		local pl
		local playertb = {}
		for i,v in ipairs(Players:GetPlayers()) do
			playertb[#playertb + 1] = v.Name
		end
		local pld = Tab:CreateDropdown({
			Name = "玩家黑名单",
			Options = playertb,
			MultipleOptions = false,
			CanNoneSeleted = true,
			Flag = "Dropdown1",
			Callback = function(Options)
				pl = unpack(Options) and Players:FindFirstChild(unpack(Options)) or nil
			end,
		})

		Players.PlayerAdded:Connect(function()
			local playertb = {}
			for i,v in ipairs(Players:GetPlayers()) do
				playertb[#playertb + 1] = v.Name
			end
			pld:Refresh(playertb)
		end)
		Players.PlayerRemoving:Connect(function()
			local playertb = {}
			for i,v in ipairs(Players:GetPlayers()) do
				playertb[#playertb + 1] = v.Name
			end
			pld:Refresh(playertb)
		end)

		local hitbox = false
		Tab:CreateToggle({
			Name = "全图追踪碰撞箱(近战攻击生效)",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				hitbox = Value
			end,
		})


		local autor = false
		Tab:CreateToggle({
			Name = "自动旋转角色（提高成功率）",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				autor = Value
			end,
		})
		if not  Rayfield["_G"].TDMMouseFunction then
			Rayfield["_G"].TDMMouseFunction = require(game.ReplicatedStorage.Systems.Player.Miscellaneous.GetPlayerMousePosition).GetMousePos
		end

		local PosTog = false
		Tab:CreateToggle({
			Name = "完美隐身并无敌",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				PosTog = Value
			end
		})

		local Tab = Window:CreateTab("其他", "boxes")

		local autofix = false
		Tab:CreateToggle({
			Name = "自动修机",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				autofix = Value
			end,
		})
		local gensize = 2
		Tab:CreateSlider({
			Name = "更改修机页面格子数量",
			Range = {2, 20},
			Increment = 1,
			Suffix = "",
			CurrentValue = 2,
			Flag = "Slider1",
			Callback = function(Value)
				gensize = Value
			end,
		})
		local hookgenfunc = false
		Tab:CreateToggle({
			Name = "启用",
			CurrentValue = false,
			Flag = "Toggle1",
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

		Tab:CreateSection("主要")
		local Actors = require(game:GetService("ReplicatedStorage").Modules.Gameplay.Actors)
		local c00lkidd = false
		Tab:CreateToggle({
			Name = "冲刺不撞墙(c00lkidd,noli)",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				c00lkidd = Value
			end,
		})
		Tab:CreateToggle({
			Name = "noli冲刺随意转弯",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				require(game.ReplicatedStorage.Assets.Killers.Noli.Config).VoidRushTurnSpeed = Value and math.huge or 1
			end,
		})
		local n7 = false
		Tab:CreateToggle({
			Name = "007n7分身跟随本体",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				n7 = Value
			end,
		})
		local Pizza = false
		Tab:CreateToggle({
			Name = "披萨全图追踪",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				Pizza = Value
			end,
		})

		local EatPizza = false
		Tab:CreateToggle({
			Name = "全图吃披萨（自己）",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				EatPizza = Value
			end,
		})

		local AutoGuest = false

		Tab:CreateToggle({
			Name = "访客自动格挡(吃延迟)",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				AutoGuest = Value
			end,
		})
		local AutoGuestDistance = 10

		Tab:CreateSlider({
			Name = "触发距离",
			Range = {0, 100},
			Increment = .1,
			Suffix = "",
			CurrentValue = 10,
			Flag = "Slider1",
			Callback = function(Value)
				AutoGuestDistance = Value
			end,
		})

		local autojohn
		Tab:CreateToggle({
			Name = "约翰多自动势不可挡",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				autojohn = Value
			end,
		})

		local autojohndis = 10

		Tab:CreateSlider({
			Name = "触发距离",
			Range = {0, 100},
			Increment = .1,
			Suffix = "",
			CurrentValue = 10,
			Flag = "Slider1",
			Callback = function(Value)
				autojohndis = Value
			end,
		})



		Tab:CreateSection("自瞄")
		local difdis = false
		Tab:CreateToggle({
			Name = "使用推荐设置",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				difdis = Value
			end,
		})
		local aimtargettype = "最近"
		Tab:CreateDropdown({
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
		Tab:CreateToggle({
			Name = "自瞄时同时移动视角",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				cameraaim = Value
			end,
		})

		local CharacterAim
		local Shiftlock = false
		Tab:CreateToggle({
			Name = "自瞄结束后自动锁定视角",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				Shiftlock = Value
			end,
		})

		Tab:CreateToggle({
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
		Tab:CreateToggle({
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
		Tab:CreateToggle({
			Name = "跟随距离额外增加预瞄量",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				Disdis = Value
			end,
		})
		local adis = 2.5
		Tab:CreateSlider({
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
		Tab:CreateToggle({
			Name = "准星自瞄",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				MouseAim = Value
			end,
		})

		local Disdis1
		Tab:CreateToggle({
			Name = "跟随距离额外增加预瞄量(小孩)",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				Disdis1 = Value
			end,
		})

		local vdis = 10
		Tab:CreateSlider({
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
		local playertb = {}
		for i,v in ipairs(Players:GetPlayers()) do
			playertb[#playertb + 1] = v.Name
		end
		local pld1 = Tab:CreateDropdown({
			Name = "自瞄黑名单",
			Options = playertb,
			MultipleOptions = false,
			Flag = "Dropdown1",
			Callback = function(Options)
				pl1 = unpack(Options) and Players:FindFirstChild(unpack(Options)) or nil
			end,
		})

		Players.PlayerAdded:Connect(function()
			local playertb = {}
			for i,v in ipairs(Players:GetPlayers()) do
				playertb[#playertb + 1] = v.Name
			end
			pld1:Refresh(playertb)
		end)
		Players.PlayerRemoving:Connect(function()
			local playertb = {}
			for i,v in ipairs(Players:GetPlayers()) do
				playertb[#playertb + 1] = v.Name
			end
			pld1:Refresh(playertb)
		end)

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



		local isnetworkowner = function(Part)
			return not Part:IsGrounded() and Part.AssemblyRootPart.ReceiveAge == 0
		end

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
								local Actor = require(game:GetService("ReplicatedStorage").Modules.Gameplay.Actors).CurrentActors[Player]
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

		table.insert(Rayfield["_G"].TDMHeartbeat,function(dt)
			if PosTog and Player.Character and Player.Character:FindFirstChild("QueryHitbox") then
				if (Player.Character:FindFirstChild("QueryHitbox").Position - Vector3.new(0,-6000,0)).Magnitude > 5 then
					require(game:GetService("ReplicatedStorage").Modules.Network.Network):FireServerConnection("UpdateCharacterPosition","UREMOTE_EVENT",require(game:GetService("ReplicatedStorage").Systems.Player.Game.CharacterReplication).Serialize(CFrame.new(0,-6000,0),Player.Character.PrimaryPart.AssemblyLinearVelocity))
				end
			end

			if autojump and game:GetService("ReplicatedStorage").Assets.Survivors.Veeronica.Behavior:FindFirstChild("Highlight") then
				if game:GetService("ReplicatedStorage").Assets.Survivors.Veeronica.Behavior:FindFirstChild("Highlight").Adornee == Player.Character then
					for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.MainUI.SprintingButton.MouseButton1Down)) do
						v:Fire()						
					end

					for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.MainUI.SprintingButton.MouseButton1Up)) do
						v:Fire()						
					end
				end
			end

			local Actor = require(game:GetService("ReplicatedStorage").Modules.Gameplay.Actors).CurrentActors[Player]
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
				require(game:GetService("ReplicatedStorage").Systems.Player.Miscellaneous.GetPlayerMousePosition).GetMousePos = Rayfield["_G"].TDMMouseFunction
			end
			if AutoGuest and Player.Character.Name == "Guest1337" then
				for i,v in ipairs(Killers:GetChildren()) do
					if Players:GetPlayerFromCharacter(v) and ((v:GetPivot().Position + v.PrimaryPart.AssemblyLinearVelocity * PlayerPing * 2.5) - Player.Character:GetPivot().Position).Magnitude < AutoGuestDistance and IsInFov(v:GetPivot(),Player.Character:GetPivot().Position,45) then
						local PlayerActorSounds = Actors.CurrentActors[Players:GetPlayerFromCharacter(v)].Config.Sounds
						for index,id in pairs({
							PlayerActorSounds.Attack,
							PlayerActorSounds.Slash,
							PlayerActorSounds.Swing,
							PlayerActorSounds.GashingWoundSwing,
							PlayerActorSounds.WalkspeedOverrideLoop,
							PlayerActorSounds.WalkspeedOverrideLunge,
							PlayerActorSounds.VoidRushDashLoop,
							}) do
							if id and v.PrimaryPart:FindFirstChild(id) then
								require(game:GetService("ReplicatedStorage").Modules.Network.Network):FireServerConnection("UseActorAbility", "REMOTE_EVENT", "Block")
							end
						end
					end
				end
			elseif autojohn and Player.Character.Name == "JohnDoe" then
				for i,v in ipairs(Survivors:GetChildren()) do
					if ((v:GetPivot().Position + v.PrimaryPart.AssemblyLinearVelocity * PlayerPing * 2.5) - Player.Character:GetPivot().Position).Magnitude < autojohndis and IsInFov(v:GetPivot(),Player.Character:GetPivot().Position,45) then
						local PlayerActorSounds = Actors.CurrentActors[Players:GetPlayerFromCharacter(v)].Config.Sounds
						for index,id in pairs({
							PlayerActorSounds.Punch,
							PlayerActorSounds.Parry,
							PlayerActorSounds.GunWindUpSFX,
							PlayerActorSounds.Slash,
							PlayerActorSounds.Unsheath,
							}) do
							if id and v.PrimaryPart:FindFirstChild(id) then
								require(game:GetService("ReplicatedStorage").Modules.Network.Network):FireServerConnection("UseActorAbility", "REMOTE_EVENT", "CorruptEnergy")
								require(game:GetService("ReplicatedStorage").Modules.Network.Network):FireServerConnection("UseActorAbility", "REMOTE_EVENT", "404Error")
							end
						end
					end
				end
			end
		end)

		local Tab = Window:CreateTab("美化(别人看不到动画)", 4483362458)

		local SkinsFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Skins") or game:GetObjects("rbxassetid://110364703563633")[1]
		SkinsFolder.Parent = game.ReplicatedStorage
		SkinsFolder.Name = "Skins"
		for i,v in ipairs(SkinsFolder.Killer:GetChildren()) do
			if v.Name ~= "c00lkidd" then
				for i,v in ipairs(v:GetChildren()) do
					v.Name = v.Name..v.Parent.Name
				end
			end

		end
		local tbk = {}

		for i,v in ipairs(SkinsFolder.Killer:GetChildren()) do
			tbk[#tbk+1] = v.Name
		end
		for i,v in ipairs(SkinsFolder.Survivor:GetChildren()) do
			tbk[#tbk+1] = v.Name
		end

		local Unit
		local Skin
		local Skins

		local Units = Tab:CreateDropdown({
			Name = "选择角色",
			Options = tbk,
			MultipleOptions = false,
			Flag = "Dropdown1",
			Callback = function(Options)
				Unit = game:GetService("ReplicatedStorage").Assets.Killers:FindFirstChild(unpack(Options),true) or game:GetService("ReplicatedStorage").Assets.Survivors:FindFirstChild(unpack(Options),true)
				Skin = nil
				local tbs = {}
				if SkinsFolder:FindFirstChild(unpack(Options),true) then
					for i,v in ipairs(SkinsFolder:FindFirstChild(unpack(Options),true):GetChildren()) do
						table.insert(tbs,v.Name) 
					end
				end
				Skins:Refresh(tbs)
				Skins:Set({""})
			end,
		})

		Skins = Tab:CreateDropdown({
			Name = "选择皮肤",
			Options = {},
			MultipleOptions = false,
			Flag = "Dropdown1",
			Callback = function(Options)
				pcall(function()
					Skin = SkinsFolder:FindFirstChild(unpack(Options),true)
				end)
			end,
		})

		local MHB = false

		local MHBToggle = Tab:CreateToggle({
			Name = "启用",
			CurrentValue = false,
			Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				MHB = true
			end,
		})
		local v30 = {};
		local CurrentSkin
		--[[require(game.ReplicatedStorage.Modules.Network).Connections["UseActorAbility"].Callback = function(v125,v126)
			--a(v125,v126)
			if CurrentSkin then
				local v127 = CurrentSkin
				if not v127 then
					return;
				else
					local v130 = v127.Behavior.Abilities
					local v131 = tonumber(v126 and typeof(v126) == "table" and v126.Cooldown or typeof(v130.Cooldown) == "function" and v130.Cooldown(v127, v125) or v130.Cooldown or v127.Config[("%*Cooldown"):format(v125)]);

					if typeof(v126) == "table" and v126.Cancelled then
						v131 = 0;
					end;

					if v126 == "Cancelled" then
						v131 = 0;
					end;

					if v131 and v131 > 0 and (not v127.Cooldowns[v125] or v127.Cooldowns[v125].TimePast > 0.025) and not workspace:GetAttribute("CooldownsDisabled") then
						v127.Cooldowns[v125] = {
							Duration = v131, 
							TimePast = 0
						};
					end;
					v127.Behavior.Abilities.Callback(v127, v126);
					return;
				end;
			end

		end]]
		table.insert(Rayfield["_G"].TDMRenderStepped,function()
			local Actor = Actors.CurrentActors[Player]
			if MHB and Player.Character.Parent ~= workspace and Player.Character.Parent ~= workspace.Players.Spectating then
				if Skin and SkinsFolder:FindFirstChild(Skin.Name,true) and not CurrentSkin and Player.Character.Name == Unit.Name then
					local SkinRig = SkinsFolder:FindFirstChild(Skin.Name,true):FindFirstChild("Rig")

					local NewActor = {
						Cache = {}, 
						Cooldowns = {}, 
						AbilityDisablers = {}
					}
					NewActor.Player = Player;
					NewActor.Folder = Unit;
					NewActor.ActorType = Player.Character.Parent == workspace.Players.Survivors and "Survivor" or "Killer"
					NewActor.ActorName = Player.Character.Name;
					NewActor.ActorSkin = Skin.Name;

					Actors:ApplySkinDataToActorInfo(NewActor)
					CurrentSkin = NewActor
					if NewActor.SkinFolder then 
						if NewActor.SkinFolder:FindFirstChild("Abilities") then
							local tb = require(NewActor.SkinFolder:FindFirstChild("Abilities"))
							for i,v in pairs(NewActor.Behavior.Abilities) do
								if tb[i] then
									v["Callback"] = tb[i]
								end
							end
						end
					end
					NewActor.Rig = SkinRig
					if NewActor.Behavior.GetRig then
						NewActor.Rig = NewActor.Behavior:GetRig(NewActor);
					else
						NewActor.Rig = NewActor.Rig:Clone();
					end;
					for i,v in pairs({"FOVMultipliers","ResistanceMultipliers","SpeedCapMultipliers","SpeedMultipliers"}) do
						if not NewActor.Rig:FindFirstChild(v) then
							Instance.new("Folder",NewActor.Rig).Name = v
						end
					end
					if NewActor.Config.Sounds and NewActor.Config.Sounds.Ambience then
						require(game.ReplicatedStorage.Modules.Sounds):Play(NewActor.Config.Sounds.Ambience, {
							Parent = NewActor.Rig.PrimaryPart, 
							Looped = true
						});
					end;

					require(game.ReplicatedStorage.Modules.Util):PreloadAssets(NewActor.Config)


					if NewActor.Rig then
						local NewSkinRig = NewActor.Rig
						NewSkinRig.Parent = workspace
						NewSkinRig.Name = "SkinModel"
						NewSkinRig:PivotTo(Player.Character:GetPivot())
						NewActor.Animations = {};

						for v26, v27 in pairs(NewActor.Config.Animations) do
							if typeof(v27) == "string" then
								local Animator = NewSkinRig.Humanoid:FindFirstChild("Animator") or Instance.new("Animator",NewSkinRig.Humanoid)
								local Animation = Instance.new("Animation",NewSkinRig)
								Animation.AnimationId = v27
								Animation.Name = v27
								local AnimationTrack = Animator:LoadAnimation(Animation)
								NewActor.Animations[v26] = AnimationTrack
							elseif typeof(v27) == "table" then
								for v28, v29 in pairs(v27) do
									if typeof(v29) == "string" then
										if not NewActor.Animations[v26] then
											NewActor.Animations[v26] = {};
										end;
										local Animator = NewSkinRig.Humanoid:FindFirstChild("Animator") or Instance.new("Animator",NewSkinRig.Humanoid)
										local Animation = Instance.new("Animation",NewSkinRig)
										Animation.AnimationId = v29
										Animation.Name = v29
										local AnimationTrack = Animator:LoadAnimation(Animation)
										NewActor.Animations[v26][v28] = AnimationTrack
									end;
								end;
							end;
						end;

						NewActor.Animations.Idle.Priority = Enum.AnimationPriority.Core;
						NewActor.Animations.Walk.Priority = Enum.AnimationPriority.Core;
						NewActor.Animations.Run.Priority = Enum.AnimationPriority.Core;
						CurrentSkin = NewActor
						for i,v in ipairs(NewSkinRig:GetDescendants()) do
							if v:IsA("BasePart") then
								v.CollisionGroup = "Killers"
								v.CanCollide = false
								v.Massless = true
								v.Anchored = false
							end
						end

						local hs = Player.Character.PrimaryPart.ChildAdded:Connect(function(sound)
							if sound:IsA("Sound") then
								for i,v in pairs(Actor.Config.Sounds) do
									if typeof(v) == "table" then
										for a,b in pairs(v) do
											if b == sound.SoundId then

												require(game.ReplicatedStorage.Modules.Sounds):Play(NewActor.Config.Sounds[i][a],{Parent = sound.Parent,PlaybackSpeed = sound.PlaybackSpeed,Volume = sound.Volume})
												sound.Volume = 0
											end
										end
									else
										if v == sound.SoundId then

											require(game.ReplicatedStorage.Modules.Sounds):Play(NewActor.Config.Sounds[i],{Parent = sound.Parent,PlaybackSpeed = sound.PlaybackSpeed,Volume = sound.Volume})
											sound.Volume = 0
										end
									end
								end
							end
						end)

						local ss = workspace.Sounds.ChildAdded:Connect(function(sound)
							if sound:IsA("Sound") then
								for i,v in pairs(Actor.Config.Sounds) do
									if typeof(v) == "table" then
										for a,b in pairs(v) do
											if b == sound.SoundId then

												require(game.ReplicatedStorage.Modules.Sounds):Play(NewActor.Config.Sounds[i][a],{Parent = sound.Parent})
												sound.Volume = 0
											end
										end
									else
										if v == sound.SoundId then

											require(game.ReplicatedStorage.Modules.Sounds):Play(NewActor.Config.Sounds[i],{Parent = sound.Parent})
											sound.Volume = 0
										end
									end
								end
							end
						end)

						local cf = game["Run Service"].Heartbeat:Connect(function()
							NewSkinRig:PivotTo(Player.Character:GetPivot())
						end)

						Player.Character.Destroying:Connect(function()
							NewSkinRig:Destroy()
							hs:Disconnect()
							ss:Disconnect()
							cf:Disconnect()
						end)
					end
				end
			elseif CurrentSkin then
				CurrentSkin.Rig:Destroy()
				CurrentSkin = nil
			end
			if CurrentSkin then
				for i,v in ipairs(Player.Character:GetDescendants()) do
					if v:IsA("ParticleEmitter") or v:IsA("Beam") then
						v.Enabled = false
					elseif v:IsA("BasePart") or v:IsA("Decal") then
						v.Transparency = 1
					end
				end
				for i,v in pairs(Actor.Animations) do
					if typeof(v) == "table" then
						for a,b in pairs(v) do
							if b.IsPlaying then
								if not v30[i] then
									v30[i] = {}
								end

								if not v30[i][a] then
									CurrentSkin.Animations[i][a]:Play()
									v30[i][a] = CurrentSkin.Animations[i][a]
								else
									CurrentSkin.Animations[i][a]:AdjustSpeed(v.Speed)
								end
							else
								if v30[i] and v30[i][a] then
									CurrentSkin.Animations[i][a]:Stop()
									v30[i][a] = nil
								end
							end
						end
					else
						if v.IsPlaying then
							if not v30[i] then
								CurrentSkin.Animations[i]:Play()
								v30[i] = CurrentSkin.Animations[i]
							else
								CurrentSkin.Animations[i]:AdjustSpeed(v.Speed)
							end
						else
							if v30[i] then
								CurrentSkin.Animations[i]:Stop()
								v30[i] = nil
							end
						end
					end
				end
			end

		end)

		local Tab = Window:CreateTab("娱乐", "camera")

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
		local Units = Tab:CreateDropdown({
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

				AnimationsD:Refresh(Anima)
				AnimationsD:Set({""})
				Sounds:Refresh(sound)
				Sounds:Set({""})
			end,
		})
		Tab:CreateButton({
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
		Tab:CreateSlider({
			Name = "等级",
			Range = {0, 100},
			Increment = 10,
			Suffix = "%",
			CurrentValue = 1,
			Flag = "Slider1",
			Callback = function(Value)
				unitlevel = Value
			end,
		})
		Tab:CreateButton({
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
		Skins = Tab:CreateDropdown({
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
					Sounds:Refresh(sound)
					Sounds:Set({""})
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
					AnimationsD:Refresh(Anima)
					AnimationsD:Set({""})
				end)
			end,
		})
		Tab:CreateButton({
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

		Sounds = Tab:CreateDropdown({
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

		local PlaySound = Tab:CreateButton({
			Name = "播放音效",
			Callback = function()
				require(game:GetService("ReplicatedStorage").Modules.Sounds):Play(Sound)
			end,
		})
		local PlaySound = Tab:CreateButton({
			Name = "停止音效",
			Callback = function()
				require(game:GetService("ReplicatedStorage").Modules.Sounds):Stop(Sound)
			end,
		})



		AnimationsD = Tab:CreateDropdown({
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

		local PlayAnimation = Tab:CreateButton({
			Name = "播放动画",
			Callback = function()
				Animation:Play()
			end,
		})

		local PlayAnimation = Tab:CreateButton({
			Name = "停止动画",
			Callback = function()
				Animation:Stop()
			end,
		})

		local CUSound
		local cus = Tab:CreateDropdown({
			Name = "选择当前角色音效",
			Options = {},
			MultipleOptions = false,
			Flag = "Dropdown1",
			Callback = function(Options)
				CUSound = unpack(Options)
			end,
		})

		local CUAnimation
		local cua = Tab:CreateDropdown({
			Name = "选择当前角色动画",
			Options = {},
			MultipleOptions = false,
			Flag = "Dropdown1",
			Callback = function(Options)
				CUAnimation = unpack(Options)
			end,
		})

		local a = Tab:CreateButton({
			Name = "刷新列表",
			Callback = function()
				if require(game:GetService("ReplicatedStorage").Modules.Gameplay.Actors).CurrentActors[game:GetService("Players").LocalPlayer] then
					local p = require(game:GetService("ReplicatedStorage").Modules.Gameplay.Actors).CurrentActors[game:GetService("Players").LocalPlayer]
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

							cus:Refresh(sound)
							cus:Set({""})
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

							cua:Refresh(Ani)
							cua:Set({""})
						end
					end
				end


			end,
		})

		local a = Tab:CreateButton({
			Name = "替换选择动画",
			Callback = function()
				if require(game:GetService("ReplicatedStorage").Modules.Gameplay.Actors).CurrentActors[game:GetService("Players").LocalPlayer] then
					local p = require(game:GetService("ReplicatedStorage").Modules.Gameplay.Actors).CurrentActors[game:GetService("Players").LocalPlayer]
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

		Tab:CreateButton({
			Name = "一键替换动画",
			Callback = function()
				if require(game:GetService("ReplicatedStorage").Modules.Gameplay.Actors).CurrentActors[game:GetService("Players").LocalPlayer] then
					local p = require(game:GetService("ReplicatedStorage").Modules.Gameplay.Actors).CurrentActors[game:GetService("Players").LocalPlayer]
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


		table.insert(Rayfield["_G"].TDMRenderStepped,function()
			if InfStamina then
				require(game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting).Stamina = math.huge
			end

			for espname,v in pairs(ESP) do
				if v == true then
					if workspace.Map.Ingame:FindFirstChild("Map") then
						for i,v in ipairs(workspace.Map.Ingame.Map:GetChildren()) do
							if ESP.Items and v:FindFirstChild("ItemRoot") then
								Esp(true,v.ItemRoot,espname,v.Name.."\n物品",Color3.new(0.52549, 1, 0.490196),nil,nil,nil,Color3.new(0.52549, 1, 0.490196),GetScale(UDim2.fromScale(0.1,0.1)))
							end
							if ESP.Generator then
								if v.Name == "Generator" then
									Esp(true,v,espname,("%*\n%*"):format("电机",(v:FindFirstChild("Progress").Value >= 100 and 100 or v:FindFirstChild("Progress").Value/26*25).."%"),Color3.new(0, 0.815686, 1),UDim2.fromScale(8,5),v:FindFirstChild("Progress").Changed,function(UI)
										UI:FindFirstChild("TextLabel").Text = ("%*\n%*"):format("电机",(v:FindFirstChild("Progress").Value >= 100 and 100 or v:FindFirstChild("Progress").Value/26*25).."%")
									end,Color3.new(0, 0.815686, 1),GetScale(UDim2.fromScale(0.1,0.1)))
								elseif v.Name == "FakeGenerator" then
									Esp(true,v,espname,("%*\n%*"):format("假机子",(v:FindFirstChild("Progress").Value >= 100 and 100 or v:FindFirstChild("Progress").Value/26*25).."%"),Color3.new(0, 0, 1),UDim2.fromScale(8,5),v:FindFirstChild("Progress").Changed,function(UI)
										UI:FindFirstChild("TextLabel").Text = ("%*\n%*"):format("假机子",(v:FindFirstChild("Progress").Value >= 100 and 100 or v:FindFirstChild("Progress").Value/26*25).."%")
									end,Color3.new(0, 0, 1),GetScale(UDim2.fromScale(0.1,0.1)))
								end
							end
						end
					end
					for i,v in ipairs(workspace.Map.Ingame:GetChildren()) do
						if ESP.Items and v:FindFirstChild("ItemRoot") then
							Esp(true,v.ItemRoot,espname,v.Name.."\n物品",Color3.new(0.52549, 1, 0.490196),nil,nil,nil,Color3.new(0.52549, 1, 0.490196),GetScale(UDim2.fromScale(0.1,0.1)))
						end
						if ESP.Pizza and v.Name == "Pizza" then
							Esp(true,v,espname,"披萨",Color3.new(1, 0.615686, 0.0745098),nil,nil,nil,Color3.new(1, 0.615686, 0.0745098),GetScale(UDim2.fromScale(0.1,0.1)))
						end
						if ESP.Taph then
							if v.Name == "SubspaceTripmine" then
								Esp(true,v,espname,"塔夫子空间地雷",Color3.new(0.5, 0, 1),nil,nil,nil,Color3.new(0.5, 0, 1),GetScale(UDim2.fromScale(0.1,0.1)))
							elseif v.Name:find("TaphTripwire") then
								Esp(true,v,espname,string.gsub(v.Name,"TaphTripwire","").."\n塔夫拌线",Color3.new(0.5, 0, 1),nil,nil,nil,Color3.new(0.5, 0, 1),GetScale(UDim2.fromScale(0.1,0.1)))
							end
						end
						if ESP.Builder then
							if v.Name == "BuildermanSentry" then
								Esp(true,v,espname,"建造者炮塔",Color3.new(.7, 1, 1),nil,nil,nil,Color3.new(.7, 1, 1),GetScale(UDim2.fromScale(0.1,0.1)))
							elseif v.Name == "BuildermanDispenser" then
								Esp(true,v,espname,"建造者回血装置",Color3.new(.7, 1, 1),nil,nil,nil,Color3.new(.7, 1, 1),GetScale(UDim2.fromScale(0.1,0.1)))
							end
						end
					end
				else
					Esp(false,nil,espname)
				end
			end
		end)
	elseif game.PlaceId == 18816546575 or game.PlaceId == 18816473146 then

		local Player = game:GetService("Players").LocalPlayer
		local Tab = Window:CreateTab("主要", "camera")
		local function reset()
			local charcter = game:GetService("Players").LocalPlayer.Character
			for i,v in ipairs(charcter:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
					v.CanQuery = false
					v.CanTouch = false
				end
			end
			if charcter:FindFirstChildOfClass("BodyVelocity") then
				charcter:FindFirstChildOfClass("BodyVelocity"):Destroy()
			end
			if charcter:FindFirstChildWhichIsA("BodyVelocity") then
				charcter:FindFirstChildWhichIsA("BodyVelocity"):Destroy()
			end
			local ve = Instance.new("BodyVelocity",charcter.PrimaryPart)
			ve.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
			ve.Velocity = Vector3.new(0,-10000,0)
		end
		local charactertable = {}
		for i,v in ipairs(game:GetService("Players").LocalPlayer.UnlockData:GetChildren()) do
			table.insert(charactertable,v.Name)
		end
		Tab:CreateSection("切换角色")
		local currentcharacter
		local characterdropdown = Tab:CreateDropdown({
			Name = "选择角色",
			Options = charactertable,
			MultipleOptions = false,
			Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Options)
				currentcharacter = game:GetService("Players").LocalPlayer.UnlockData:FindFirstChild(unpack(Options))
			end,
		})
		game:GetService("Players").LocalPlayer.UnlockData.ChildAdded:Connect(function(child)
			table.insert(charactertable,child.Name)
			characterdropdown:Refresh(charactertable)
		end)
		Tab:CreateButton({
			Name = "切换到选择的角色（局内不知道修复没有）",
			Callback = function()
				if not currentcharacter then
					return
				end
				game:GetService("ReplicatedStorage"):WaitForChild("ForChangeCharacter"):FireServer(unpack({
					currentcharacter.Name,
					currentcharacter.SkinNumber.Value
				}))

			end,
		})
		Tab:CreateSection("商店")
		Tab:CreateButton({
			Name = "显示全部物品（切换角色后可购买该角色能购买的）",
			Callback = function()
				for i,v in ipairs(game:GetService("Players").LocalPlayer.PlayerGui["003-A"].Main.ScrollingFrame.Weapons:GetChildren()) do
					if v:IsA("Frame") then
						v.Visible = true
					end
				end
				for i,v in ipairs(game:GetService("Players").LocalPlayer.PlayerGui["003-A"].Main.ScrollingFrame.Misc:GetChildren()) do
					if v:IsA("Frame") then
						v.Visible = true
					end
				end
			end,
		})
		Tab:CreateSection("重置")
		local Button = Tab:CreateButton({
			Name = "重置(回满血)",
			Callback = function()
				reset()
			end,
		})
		local AutoReset = false
		Tab:CreateToggle({
			Name = "血量较低自动重置",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				AutoReset = Value
			end,
		})
		local a = 0.1
		Tab:CreateSlider({
			Name = "血量低于百分之几触发重置",
			Range = {0, 100},
			Increment = 10,
			Suffix = "%",
			CurrentValue = 10,
			Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				a = Value / 100
			end,
		})
		Tab:CreateSection("透视")
		local esp = false
		local ESP = Tab:CreateToggle({
			Name = "透视敌对血量",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				esp = Value
			end,
		})
		local itemesp = false
		Tab:CreateToggle({
			Name = "透视物品",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				itemesp = Value
			end,
		})
		Tab:CreateSection("其他")
		local ItemAcc = false
		Tab:CreateToggle({
			Name = "刷物品通知",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				ItemAcc = Value
			end,
		})
		workspace.ChildAdded:Connect(function(item)
			if ItemAcc then
				if item:FindFirstChild("ProximityPrompt",true) and item:FindFirstChild("ProximityPrompt",true):FindFirstChild("WeaponNickName") then
					Rayfield:Notify({
						Title = "TDM",
						Content = "物品刷新:"..item.Name.."("..item:FindFirstChild("ProximityPrompt",true).WeaponNickName.Value..")",
						Duration = 6.5,
						Image = "rewind",
					})
				end
			end
		end)
		local tp = false
		Tab:CreateToggle({
			Name = "传送到敌对生物旁边",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				tp = Value
			end,
		})
		local aimb = false
		Tab:CreateToggle({
			Name = "角色自动面向最近敌对生物",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				aimb = Value
			end,
		})
		local dis = 20
		Tab:CreateSlider({
			Name = "传送最小距离",
			Range = {0, 1000},
			Increment = 1,
			Suffix = "m",
			CurrentValue = 20,
			Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				dis = Value
			end,
		})
		local hl = false
		Tab:CreateToggle({
			Name = "自动治疗",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				hl = Value
			end,
		})
		local Tab = Window:CreateTab("抽奖", "camera")
		local ev = "Skins"
		Tab:CreateDropdown({
			Name = "抽奖项目",
			Options = {"角色","皮肤"},
			CurrentOption = {"皮肤"},
			MultipleOptions = false,
			Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Options)
				local tb = {
					["皮肤"] = "Skins",
					["角色"] = "Character",
				}
				ev = tb[unpack(Options)]
			end,
		})

		local spin = "1Spin"
		Tab:CreateDropdown({
			Name = "抽奖选项",
			Options = {"1次","幸运1次","10次"},
			CurrentOption = {"1次"},
			MultipleOptions = false,
			Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Options)
				local tb = {
					["1次"] = "1Spin",
					["幸运1次"] = "1SpinLucky",
					["10次"] = "10Spins"
				}
				spin = tb[unpack(Options)]
			end,
		})

		local cj = false
		Tab:CreateToggle({
			Name = "运行",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				cj = Value
			end,
		})

		local Tab = Window:CreateTab("娱乐(自己可见)", "camera")
		Tab:CreateSection("设置精通等级")
		local tb = {}
		for i,v in pairs(game:GetService("Players").LocalPlayer.MasteryFolder:GetChildren()) do
			tb[#tb+1] = v.Name
		end
		local sl = Instance.new("ObjectValue")
		Tab:CreateDropdown({
			Name = "选择角色",
			Options = tb,
			MultipleOptions = false,
			Flag = "Dropdown1",
			Callback = function(Options)
				sl.Value = game:GetService("Players").LocalPlayer.MasteryFolder:FindFirstChild(unpack(Options))
			end,
		})

		Tab:CreateInput({
			Name = "等级",
			CurrentValue = "",
			PlaceholderText = "",
			RemoveTextAfterFocusLost = false,
			Flag = "Input1",
			Callback = function(Text)
				if sl.Value then
					sl.Value.Value = tostring(tonumber(Text)..":"..string.split(sl.Value.Value,":")[2]..":"..string.split(sl.Value.Value,":")[3])
				end
			end,
		})
		Tab:CreateInput({
			Name = "升级所需经验",
			CurrentValue = "",
			PlaceholderText = "",
			RemoveTextAfterFocusLost = false,
			Flag = "Input1",
			Callback = function(Text)
				if sl.Value then
					sl.Value.Value = tostring(string.split(sl.Value.Value,":")[1]..":"..tostring(tonumber(Text))..":"..string.split(sl.Value.Value,":")[3])
				end
			end,
		})
		Tab:CreateInput({
			Name = "经验",
			CurrentValue = "",
			PlaceholderText = "",
			RemoveTextAfterFocusLost = false,
			Flag = "Input1",
			Callback = function(Text)
				if sl.Value then
					sl.Value.Value = tostring(string.split(sl.Value.Value,":")[1]..":"..string.split(sl.Value.Value,":")[2]..":"..tostring(tonumber(Text)))
				end
			end,
		})
		Tab:CreateSection("解锁角色")
		local tb = {}
		for i,v in pairs(game:GetService("Players").LocalPlayer.MasteryFolder:GetChildren()) do
			tb[#tb+1] = string.gsub(v.Name,":Mastery","")
		end
		Tab:CreateDropdown({
			Name = "选择角色",
			Options = tb,
			MultipleOptions = false,
			Flag = "Dropdown1",
			Callback = function(Options)
				if not game:GetService("Players").LocalPlayer.UnlockData:FindFirstChild(unpack(Options)) then
					local vl = Instance.new("NumberValue")
					vl.Name = unpack(Options)
					vl.Value = 0
					vl.Parent = game:GetService("Players").LocalPlayer.UnlockData
				end
			end,
		})
		table.insert(Rayfield["_G"].TDMRenderStepped,function()
			if cj then
				game:GetService("ReplicatedStorage"):WaitForChild("Gacha"..ev):FireServer(spin)
			end
			if tp or aimb then
				local nearst
				local character = Player.Character
				for i,v in ipairs(workspace.Living:GetChildren()) do
					if v:FindFirstChild("Humanoid") and v:FindFirstChild("AI") and not Players:GetPlayerFromCharacter(v) then
						if not nearst or nearst and (nearst:GetPivot().Position - character:GetPivot().Position).Magnitude > (v:GetPivot().Position - character:GetPivot().Position).Magnitude and v.Humanoid.Health >= 0 then
							nearst = v
						end
					end
				end
				if aimb and nearst and nearst.Parent then
					local pos,siz  = nearst:GetBoundingBox()
					if not FLYING then
						character:PivotTo(CFrame.lookAt(character:GetPivot().Position,Vector3.new(pos.X,character:GetPivot().Y,pos.Z)))
					else
						character:PivotTo(CFrame.lookAt(character:GetPivot().Position,pos.Position))
					end
				end
				if tp and not character:GetAttribute("Reseting") and not (hl and (character.Humanoid.Health/character.Humanoid.MaxHealth <= a)) and nearst and (nearst:GetPivot().Position - character:GetPivot().Position).Magnitude >= dis and nearst.Humanoid.Health>=0 then
					game:GetService("TweenService"):Create(character.HumanoidRootPart,TweenInfo.new((nearst:GetPivot().Position - character:GetPivot().Position).Magnitude/1000),{CFrame = nearst:GetPivot()}):Play()
				end
			end
			if hl and Player.Character.Humanoid.Health < Player.Character.Humanoid.Health then
				game:GetService("ReplicatedStorage"):WaitForChild("ShopSystem"):FireServer("Buy","FillHP")
			end
			if AutoReset and Player.Character.Humanoid.Health/Player.Character.Humanoid.MaxHealth <= a then
				reset()
			end
			if esp then
				for i,v in ipairs(workspace.Living:GetChildren()) do
					if v:FindFirstChild("Humanoid") and v:FindFirstChild("AI") then
						if not v:FindFirstChild("Espui") then
							Esp(true,v,"Enemy",("%*/%*"):format(v.Humanoid.Health,v.Humanoid.MaxHealth),Color3.new(0, 1, 0.917647),nil,v.Humanoid:GetPropertyChangedSignal("Health"),function(UI)
								UI.TextLabel.Text = ("%*/%*"):format(v.Humanoid.Health,v.Humanoid.MaxHealth)
							end,Color3.new(0, 1, 0.917647),GetScale(UDim2.new(0.1,0.1)))
						end
					end
				end
			else
				Esp(false,nil,"Enemy")
			end
			if itemesp then
				for i,item in ipairs(workspace:GetChildren()) do
					if item:FindFirstChild("ProximityPrompt",true) and item:FindFirstChild("ProximityPrompt",true):FindFirstChild("WeaponNickName") then
						Esp(true,item,"Item",item.Name.."("..item:FindFirstChild("ProximityPrompt",true):FindFirstChild("WeaponNickName").Value..")",Color3.new(1, 0, 0.784314),nil,nil,nil,Color3.new(1, 0, 0.784314),GetScale(UDim2.fromScale(0.1,0.1)))
					end
				end
			else
				Esp(false,nil,"Item")
			end
		end)
	elseif game.PlaceId == 10449761463 then
		local Characters = {"q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m"} -- table of all characters on a keyboard

		local function GenerateString()
			local Success = false
			local String = ""
			for i = 1, 14 do
				local Char
				Char = Characters[math.random(1,26)]
				if math.random(1,2) == 1 then
					Char = string.upper(Char)
				else
					Char = string.lower(Char)
				end
				String = String..Char
			end
			return String
		end
		local CFrameTable = {}
		local AddBlock = function(args)
			local tb = {
				Color = args.Color,
				Class = "Part",
				Todo = "Place",
				Goal = "PS Build",
				CFrame = args.CFrame,
				Properties = args.Properties,
				Material = args.Material,
				Serial = args.Serial,
				Size = args.Size
			}
			tb.CFrame = loadstring(("return CFrame.new(%*)"):format(string.gsub(args.CFrame or "1,1,1", " ", "")))()
			tb.Color = loadstring(("return Color3.new(%*)"):format(string.gsub(args.Color or "1,1,1", " ", "")))()
			tb.Size = loadstring(("return vector.create(%*)"):format(string.gsub(args.Size or "1,1,1", " ", "")))()
			tb.Properties.Anchored = tostring(args.Properties.Anchored) == "true"
			tb.Properties.Collision = tostring(args.Properties.Collision) == "true"
			tb.Properties.Shadow = tostring(args.Properties.Shadow) == "true"
			local string = ""
			for i,v in pairs(tb) do
				string = string..i.." = "..tostring(v)..","
			end
			game:GetService("Players").LocalPlayer.Character:WaitForChild("Communicate"):FireServer(tb)
		end
		local edit = function(Property,Value,Serial)
			local args = {
				{
					Todo = "Property Change",
					Goal = "PS Build",
					List = {
						{
							Serial = Serial,
						}
					},
					Property = Property,
					New = Value,
				}
			}
			game:GetService("Players").LocalPlayer.Character:WaitForChild("Communicate"):FireServer(unpack(args))

		end
		local Tab = Window:CreateTab("主要", "camera")

		if not isfolder("TDM/TSBAutoBuilder") then
			makefolder("TDM/TSBAutoBuilder")
		end
		local Folder = listfiles("TDM/TSBAutoBuilder")
		for i,v in pairs(Folder) do
			Folder[i] = string.gsub(v,"TDM/TSBAutoBuilder/","",1)
		end

		local Selected : string
		Tab:CreateDropdown({
			Name = "选择文件",
			Options = Folder,
			MultipleOptions = false,
			Flag = "Dropdown1",
			Callback = function(Options)
				Selected = Options[1]
			end,
		})
		local pixel = Tab:CreateSlider({
			Name = "像素（如果是图片文件）",
			Range = {0, 100},
			Increment = 1,
			CurrentValue = 10,
			Callback = function(Value)

			end,
		})

		local viewmodel = workspace:FindFirstChild("TDMBuilderViewModel") or Instance.new("Model",workspace)
		viewmodel:ClearAllChildren()
		viewmodel.Name = "TDMBuilderViewModel"
		local viewtable = {}
		local meshscalesize = 4
		local meshcoll = false

		local CurrentImage

		Tab:CreateToggle({
			Name = "预览",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				if Value then
					viewmodel = workspace:FindFirstChild("TDMBuilderViewModel") or Instance.new("Model",workspace)
					viewmodel:ClearAllChildren()
					viewmodel:PivotTo(CFrame.new(0,0,0))
					viewmodel.Name = "TDMBuilderViewModel"
					if Selected and isfile([[TDM/TSBAutoBuilder/]]..Selected) then
						if string.sub(Selected,-4,-1) == ".png" then
							local Pixel = pixel.CurrentValue

							local ImageId = getcustomasset([[TDM/TSBAutoBuilder/]]..Selected)
							if ImageId then
								local ImageTool = GetApi("https://raw.githubusercontent.com/qian-cheng-awa/Tools/refs/heads/main/Image.lua")
								CurrentImage = ImageTool.NewImage(ImageId)
								local NewImageSize = CurrentImage.Size


								for i=1,NewImageSize.X,Pixel do
									for i2=1,NewImageSize.Y,Pixel do
										local Color,Transparency = ImageTool.GetPixel(CurrentImage,i,i2)
										if Transparency == 1 then
											continue
										end
										local Newpart = Instance.new("Part",viewmodel)
										Newpart.Size = Vector3.new(.1,.1,0)
										Newpart.CFrame = CFrame.new(i/Pixel/10,-i2/Pixel/10,0)
										Newpart.Name = ("%*X %*Y"):format(i,i2)
										Newpart.Transparency = Transparency
										Newpart.Color = Color
										Newpart.Material = Enum.Material.SmoothPlastic
										Newpart.CanCollide = false
										Newpart.Anchored = true
									end
								end
							end
						else
							local File = game:GetService("HttpService"):JSONDecode(readfile([[TDM/TSBAutoBuilder/]]..Selected))
							for i,v in pairs(File) do
								v.CFrame = loadstring(("return CFrame.new(%*)"):format(string.gsub(v.CFrame, " ", "")))()
								v.Color = loadstring(("return Color3.new(%*)"):format(string.gsub(v.Color, " ", "")))()
								v.Size = loadstring(("return vector.create(%*)"):format(string.gsub(v.Size, " ", "")))()
								v.Properties.Anchored = tostring(v.Properties.Anchored) == "true"
								v.Properties.Collision = tostring(v.Properties.Collision) == "true"
								v.Properties.Shadow = tostring(v.Properties.Shadow) == "true"

								local part = Instance.new("Part",viewmodel)

								if v.Else and v.Else.MeshID then
									local mesh = Instance.new("SpecialMesh",part)
									mesh.MeshId = "rbxassetid://"..v.Else.MeshID
									if v.Else.MeshTextureID then
										mesh.TextureId = "rbxassetid://"..v.Else.MeshTextureID
									end

									part.Size = Vector3.new(1,1,1)
									if not meshcoll then
										part.CanCollide = false
									end
									if v.elsea.MeshSize then
										local MeshSize = loadstring(("return vector.create(%*)"):format(v.elsea.MeshSize))()
										local size = loadstring(("return vector.create(%*)"):format(v.Size))()
										local finalsize = vector.create(size.X/MeshSize.X,size.Y/MeshSize.Y,size.Z/MeshSize.Z)
										mesh.Scale = finalsize * meshscalesize/4
										viewtable[mesh] = finalsize
									elseif v.elsea.MeshScale then
										mesh.Scale = loadstring(("return vector.create(%*)"):format(v.elsea.MeshScale))()
										viewtable[mesh] = mesh.Scale
									end


								else
									part.CanCollide = v.Properties.Collision
									part.Size = v.Size
								end

								part.Anchored = true
								part.Color = v.Color
								part.Material = Enum.Material[v.Material]

								part.CFrame = v.CFrame
								part.Name = i
								if not viewmodel.PrimaryPart then
									local PrimaryPart = Instance.new("Part",viewmodel)
									PrimaryPart.Position = part.Position
									PrimaryPart.Transparency = 1
									PrimaryPart.Name = "PrimaryPart"
									viewmodel.PrimaryPart = PrimaryPart
								end

								part.Transparency = v.Else.Transparency or 0

							end
						end
					end
				else
					viewmodel:Destroy()
					viewtable = {}
				end
			end,
		})
		Tab:CreateSlider({
			Name = "Mesh大小",
			Range = {0, 10},
			Increment = .1,
			Suffix = "",
			CurrentValue = 4,
			Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				meshscalesize = Value
				for i,v in pairs(viewtable) do
					i.Scale = v * meshscalesize
				end
			end,
		})

		Tab:CreateToggle({
			Name = "Mesh碰撞",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				meshcoll = Value
			end,
		})
		local buildercount = 4
		Tab:CreateSlider({
			Name = "建造频率（太高了可能会有bug）",
			Range = {0, 100},
			Increment = 1,
			Suffix = "",
			CurrentValue = 4,
			Flag = "Slider1",
			Callback = function(Value)
				buildercount = Value
			end,
		})
		local function move(Offset)
			viewmodel:PivotTo(CFrame.new(viewmodel:GetPivot().Position + Offset))
		end
		Tab:CreateDivider()
		local X
		Tab:CreateInput({
			Name = "移动数值",
			CurrentValue = "",
			PlaceholderText = "输入数字",
			RemoveTextAfterFocusLost = false,
			Flag = "Input1",
			Callback = function(Text)
				if tonumber(Text) then
					X = tonumber(Text)
				end
			end,
		})
		Tab:CreateButton({
			Name = "X轴移动",
			Callback = function()
				move(Vector3.new(X,0,0))
			end,
		})
		Tab:CreateDivider()
		local Y
		Tab:CreateInput({
			Name = "移动数值",
			CurrentValue = "",
			PlaceholderText = "输入数字",
			RemoveTextAfterFocusLost = false,
			Flag = "Input1",
			Callback = function(Text)
				if tonumber(Text) then
					Y = tonumber(Text)
				end
			end,
		})
		Tab:CreateButton({
			Name = "Y轴移动",
			Callback = function()
				move(Vector3.new(0,Y,0))
			end,
		})
		Tab:CreateDivider()
		local Z
		Tab:CreateInput({
			Name = "移动数值",
			CurrentValue = "",
			PlaceholderText = "输入数字",
			RemoveTextAfterFocusLost = false,
			Flag = "Input1",
			Callback = function(Text)
				if tonumber(Text) then
					Z = tonumber(Text)
				end
			end,
		})
		Tab:CreateButton({
			Name = "Z轴移动",
			Callback = function()
				move(Vector3.new(0,0,Z))
			end,
		})
		Tab:CreateDivider()
		Tab:CreateButton({
			Name = "移动到玩家位置",
			Callback = function()
				viewmodel:PivotTo(CFrame.new(Player.Character:GetPivot().Position) * CFrame.Angles(0,math.rad(Player.Character.PrimaryPart.Rotation.Y),0))
			end,
		})
		Tab:CreateDivider()
		Tab:CreateButton({
			Name = "开始建造",
			Callback = function()
				local Info_upvr = require(game.ReplicatedStorage.Info)
				local GetSerial_upvr = Info_upvr.GetSerial
				local function var15_upvr(arg1)
					local GetSerial_upvr_result1 = GetSerial_upvr(arg1)
					return GetSerial_upvr_result1
				end
				local message = Instance.new("Message",GuiMain)



				if Selected and isfile([[TDM/TSBAutoBuilder/]]..Selected) then
					if string.sub(Selected,-4,-1) == ".png" then
						local Pixel = pixel.CurrentValue


						local c = 0
						local ImageTool = GetApi("https://raw.githubusercontent.com/qian-cheng-awa/Tools/refs/heads/main/Image.lua")
						local NewImageSize = CurrentImage.Size


						for i=1,NewImageSize.X,Pixel do
							for i2=1,NewImageSize.Y,Pixel do
								c += 1
								if c >= buildercount then
									c = 0
									game:GetService("RunService").RenderStepped:Wait()
								end
								local Color,Transparency = ImageTool.GetPixel(CurrentImage,i,i2)
								if Transparency == 1 then
									continue
								end

								local part = Instance.new("Part")
								local Name = ("%*X %*Y"):format(i,i2)
								local CF = viewmodel:FindFirstChild(Name) and viewmodel[Name].CFrame or CFrame.new(i/Pixel/10,-i2/Pixel/10,0)
								part.CFrame = CF

								local id = var15_upvr(part)
								AddBlock({
									Color = tostring(Color),
									Class = "Part",
									Todo = "Place",
									Goal = "PS Build",
									CFrame = tostring(CF),
									Properties = {
										Collision = false,
										Anchored = true,
										Shadow = false,
									},
									Material = Enum.Material.SmoothPlastic,
									Serial = id,
									Size = ".1, .1, .1"
								})
								message.Text = string.format("Building... %*/%*",i,NewImageSize.X)
								task.delay(.1,function()
									edit("Transparency",Transparency,id)
								end)
							end
						end

						message:Destroy()
					else
						local File = game:GetService("HttpService"):JSONDecode(readfile([[TDM/TSBAutoBuilder/]]..Selected))

						local ar

						local i = 1

						local function pairsfunc()
							if i == #File + 1 then
								message:Destroy()
								return "end"
							end
							i = i + 1
							pcall(function()
								local part = Instance.new("Part")

								local v = File[i]

								if viewmodel:FindFirstChild(tostring(i)) then
									v.CFrame = tostring(viewmodel:FindFirstChild(tostring(i)).CFrame)
								end

								part.CFrame = loadstring(("return CFrame.new(%*)"):format(v.CFrame or "1,1,1"))()

								local id = var15_upvr(part)

								local size = loadstring(("return vector.create(%*)"):format(v.Size or "1,1,1"))()
								if v.Else.MeshID then
									local AddSize

									if v.elsea.MeshSize then
										local MeshSize = loadstring(("return vector.create(%*)"):format(v.elsea.MeshSize))()
										local finalsize = vector.create(size.X/MeshSize.X,size.Y/MeshSize.Y,size.Z/MeshSize.Z)
										AddSize = finalsize*meshscalesize
									elseif v.elsea.MeshScale then
										AddSize = loadstring(("return vector.create(%*)"):format(v.elsea.MeshScale))()
									end

									if not meshcoll then
										v.Properties.Collision = "false"
									end

									local blocknewtb = {
										Color = v.Color,
										Class = "Part",
										Todo = "Place",
										Goal = "PS Build",
										CFrame = v.CFrame,
										Properties = v.Properties,
										Material = Enum.Material[v.Material],
										Serial = id,
										Size = AddSize and tostring(AddSize) or "1, 1, 1"
									}
									AddBlock(blocknewtb)
								else
									local blocknewtb = {
										Color = v.Color,
										Class = "Part",
										Todo = "Place",
										Goal = "PS Build",
										CFrame = v.CFrame,
										Properties = v.Properties,
										Material = Enum.Material[v.Material],
										Serial = id,
										Size = v.Else.MeshID and "1,1,1" or v.Size
									}
									AddBlock(blocknewtb)
								end


								if v.Else then
									for i,v in pairs(v.Else) do
										edit(i,v,id)
									end
								end
							end)

							message.Text = string.format("Building... %*/%*",i,#File.." (%" ..math.floor(i/#File*10000)/100)
						end
						while true do
							local i1 = 1
							repeat
								pairsfunc()
								i1 = i1 + 1
							until i1 >= buildercount or i == #File + 1
							game:GetService("RunService").Heartbeat:Wait()
						end
					end
				end
			end,
		})
	elseif game.PlaceId == 137925884276740 then
		local Tab = Window:CreateTab("主要", "camera")
		local Island = workspace.Islands:FindFirstChild(Player.Important.Island.Value)
		local flysit
		local setffunction = Rayfield["_G"].TDMSetFlyFunction or debug.getupvalue(require(game:GetService("Players").LocalPlayer.PlayerScripts.Client.MainClient.LaunchController).init,10)
		Rayfield["_G"].TDMSetFlyFunction = setffunction

		debug.setupvalue(require(game:GetService("Players").LocalPlayer.PlayerScripts.Client.MainClient.LaunchController).init,10,function(sit)
			flysit = sit
			setffunction(sit)
		end)

		local gameflyspeed = 200
		Tab:CreateInput({
			Name = "飞机最大速度",
			CurrentValue = "",
			PlaceholderText = "输入数字",
			RemoveTextAfterFocusLost = false,
			Flag = "Input1",
			Callback = function(Text)
				if tonumber(Text) then
					gameflyspeed = tonumber(Text)
				end
			end,
		})
		local hoverheight = 100
		local Slider = Tab:CreateSlider({
			Name = "飞行高度",
			Range = {0, 500},
			Increment = 1,
			Suffix = "m",
			CurrentValue = 100,
			Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				hoverheight = Value
			end,
		})
		local inffuel = false
		Tab:CreateToggle({
			Name = "无限燃料",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				inffuel = Value
			end,
		})
		local nohitbox = false
		Tab:CreateToggle({
			Name = "关闭碰撞损耗",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				nohitbox = Value
			end,
		})
		table.insert(Rayfield["_G"].TDMRenderStepped,function()
			local infotable = debug.getupvalue(setffunction,1)
			infotable.MaxSpeed = gameflyspeed
			infotable.HoverHeight = hoverheight
			if inffuel then
				infotable.TotalFuelUsage = 0.001
			end
			debug.setupvalue(setffunction,1,infotable)
		end)
		local hook;hook =  hookmetamethod(game,"__namecall",clonefunction(newcclosure(function(self,...)
			local method = getnamecallmethod():lower()
			local args = {...}
			if method == "fireserver" then
				if self.Name == "BlockBroken" and nohitbox then
					return
				end
			end
			return hook(self,...)
		end)))
	elseif game.PlaceId == 99567941238278 then
		local Tab = Window:CreateTab("主要", "camera")
		local BuildClient = require(game:GetService("ReplicatedStorage"):WaitForChild("BuildClient"))
		if not isfolder("TDM/TSBAutoBuilder") then
			makefolder("TDM/TSBAutoBuilder")
		end
		local Folder = listfiles("TDM/TSBAutoBuilder")
		for i,v in pairs(Folder) do
			Folder[i] = string.gsub(v,"TDM/TSBAutoBuilder/","",1)
		end
		local Selected
		Tab:CreateDropdown({
			Name = "选择文件",
			Options = Folder,
			MultipleOptions = false,
			Flag = "Dropdown1",
			Callback = function(Options)
				Selected = Options[1]
			end,
		})
		local viewmodel = workspace:FindFirstChild("TDMBuilderViewModel") or Instance.new("Model",workspace)
		viewmodel:ClearAllChildren()
		viewmodel.Name = "TDMBuilderViewModel"
		local viewtable = {}
		local meshscalesize = 1
		local meshcoll = false
		Tab:CreateToggle({
			Name = "预览",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				if Value then
					viewmodel = workspace:FindFirstChild("TDMBuilderViewModel") or Instance.new("Model",workspace)
					viewmodel:ClearAllChildren()
					viewmodel:PivotTo(CFrame.new(0,0,0))
					viewmodel.Name = "TDMBuilderViewModel"
					if Selected and isfile([[TDM/TSBAutoBuilder/]]..Selected) then
						local File = game:GetService("HttpService"):JSONDecode(readfile([[TDM/TSBAutoBuilder/]]..Selected))
						for i,v in pairs(File) do
							v.CFrame = loadstring(("return CFrame.new(%*)"):format(string.gsub(v.CFrame, " ", "")))()
							v.Color = loadstring(("return Color3.new(%*)"):format(string.gsub(v.Color, " ", "")))()
							v.Size = loadstring(("return vector.create(%*)"):format(string.gsub(v.Size, " ", "")))()
							v.Properties.Anchored = tostring(v.Properties.Anchored) == "true"
							v.Properties.Collision = tostring(v.Properties.Collision) == "true"
							v.Properties.Shadow = tostring(v.Properties.Shadow) == "true"

							local part = Instance.new("Part",viewmodel)

							if v.Else and v.Else.MeshID then
								local mesh = Instance.new("SpecialMesh",part)
								mesh.MeshId = "rbxassetid://"..v.Else.MeshID
								if v.Else.MeshTextureID then
									mesh.TextureId = "rbxassetid://"..v.Else.MeshTextureID
								end

								part.Size = Vector3.new(1,1,1)
								if not meshcoll then
									part.CanCollide = false
								end
								if v.elsea.MeshSize then
									local MeshSize = loadstring(("return vector.create(%*)"):format(v.elsea.MeshSize))()
									local size = loadstring(("return vector.create(%*)"):format(v.Size))()
									local finalsize = vector.create(size.X/MeshSize.X,size.Y/MeshSize.Y,size.Z/MeshSize.Z)
									mesh.Scale = finalsize * meshscalesize
									viewtable[mesh] = finalsize
								elseif v.elsea.MeshScale then
									mesh.Scale = loadstring(("return vector.create(%*)"):format(v.elsea.MeshScale))()
									viewtable[mesh] = mesh.Scale
								end


							else
								part.CanCollide = v.Properties.Collision
								part.Size = v.Size
							end

							part.Anchored = true
							part.Color = v.Color
							part.Material = Enum.Material[v.Material]

							part.CFrame = v.CFrame
							part.Name = i
							if not viewmodel.PrimaryPart then
								local PrimaryPart = Instance.new("Part",viewmodel)
								PrimaryPart.Position = part.Position
								PrimaryPart.Transparency = 1
								PrimaryPart.Name = "PrimaryPart"
								viewmodel.PrimaryPart = PrimaryPart
							end

							part.Transparency = v.Else.Transparency or 0

						end
					end
				else
					viewmodel:Destroy()
					viewtable = {}
				end
			end,
		})
		Tab:CreateSlider({
			Name = "Mesh大小",
			Range = {0, 10},
			Increment = .1,
			Suffix = "",
			CurrentValue = 1,
			Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				meshscalesize = Value
				for i,v in pairs(viewtable) do
					i.Scale = v * meshscalesize
				end
			end,
		})

		Tab:CreateToggle({
			Name = "Mesh碰撞",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(Value)
				meshcoll = Value
			end,
		})
		local buildercount = 1
		Tab:CreateSlider({
			Name = "建造频率（太高了可能会有bug）",
			Range = {0, 10},
			Increment = 1,
			Suffix = "",
			CurrentValue = buildercount,
			Flag = "Slider1",
			Callback = function(Value)
				buildercount = Value
			end,
		})
		local function move(Offset)
			viewmodel:PivotTo(CFrame.new(viewmodel:GetPivot().Position + Offset))
		end
		Tab:CreateDivider()
		local X
		Tab:CreateInput({
			Name = "移动数值",
			CurrentValue = "",
			PlaceholderText = "输入数字",
			RemoveTextAfterFocusLost = false,
			Flag = "Input1",
			Callback = function(Text)
				if tonumber(Text) then
					X = tonumber(Text)
				end
			end,
		})
		Tab:CreateButton({
			Name = "X轴移动",
			Callback = function()
				move(Vector3.new(X,0,0))
			end,
		})
		Tab:CreateDivider()
		local Y
		Tab:CreateInput({
			Name = "移动数值",
			CurrentValue = "",
			PlaceholderText = "输入数字",
			RemoveTextAfterFocusLost = false,
			Flag = "Input1",
			Callback = function(Text)
				if tonumber(Text) then
					Y = tonumber(Text)
				end
			end,
		})
		Tab:CreateButton({
			Name = "Y轴移动",
			Callback = function()
				move(Vector3.new(0,Y,0))
			end,
		})
		Tab:CreateDivider()
		local Z
		Tab:CreateInput({
			Name = "移动数值",
			CurrentValue = "",
			PlaceholderText = "输入数字",
			RemoveTextAfterFocusLost = false,
			Flag = "Input1",
			Callback = function(Text)
				if tonumber(Text) then
					Z = tonumber(Text)
				end
			end,
		})
		Tab:CreateButton({
			Name = "Z轴移动",
			Callback = function()
				move(Vector3.new(0,0,Z))
			end,
		})
		Tab:CreateDivider()
		Tab:CreateButton({
			Name = "移动到玩家位置",
			Callback = function()
				viewmodel:PivotTo(Player.Character:GetPivot())
			end,
		})
		Tab:CreateDivider()
		local AddBlock = function(args)
			args.Shape = args.Shape or "Block"
			args.CFrame = loadstring(("return CFrame.new(%*)"):format(string.gsub(args.CFrame or "1,1,1", " ", "")))()

			return game:GetService("ReplicatedStorage"):WaitForChild("PSCreate"):InvokeServer(args.Shape,args.CFrame)
		end
		local MaterialIDTable = {
			Asphalt = 9930003046,
			Basalt = 9920482056,
			Brick = 9920482813,
			Cardboard = 14108651729,
			Carpet = 14108662587,
			CeramicTiles = 17429425079,
			ClayRoofTiles = 18147681935,
			Cobblestone = 9919718991,
			Concrete = 9920484153,
			CorrodedMetal = 9920589327,
			CrackedLava = 9920484943,
			DiamondPlate = 10237720195,
			Fabric = 9920517696,
			Foil = 9466552117,
			ForceField = nil, -- 无有效ID
			Glacier = 9920518732,
			Glass = 9438868521,
			Granite = 9920550238,
			Grass = 9920551868,
			Ground = 9920554482,
			Ice = 9920555943,
			LeafyGrass = 9920557906,
			Leather = 14108670073,
			Limestone = 9920561437,
			Marble = 9439430596,
			Metal = 9920574687,
			Mud = 9920578473,
			Neon = nil, -- 无有效ID
			Pavement = 9920579943,
			Pebble = 9920581082,
			Plaster = 14108671255,
			Plastic = nil, -- 无有效ID
			Rock = 9920587470,
			RoofShingles = 119722544879522,
			Rubber = 14108673018,
			Salt = 9920590225,
			Sand = 9920591683,
			Sandstone = 9920596120,
			Slate = 9920599782,
			SmoothPlastic = nil, -- 无有效ID
			Snow = 9920620284,
			Wood = 9920625290,
			WoodPlanks = 9920626778
		}

		local Functions;Functions = {
			Color = BuildClient.Paint,
			Material = BuildClient.SetMaterial,
			Size = function(_,Block,Size)
				game:GetService("ReplicatedStorage"):WaitForChild("PSTransform"):FireServer(Block,Block.CFrame,Size)
			end,
			Collide = BuildClient.SetCollide,
			Transparency = BuildClient.SetTransparency,
			Light = BuildClient.SetLight,
			LightFunction = function(_,NewBlock,Args)
				if Args.Offset then
					local LightBlock = AddBlock({CFrame = tostring(NewBlock.CFrame * Args.Offset),Shape = "Block"})
					Functions:Collide(LightBlock,false)
					Functions:Transparency(LightBlock,1)
					Functions:Light(LightBlock,{
						Color = loadstring(("return Color3.new(%*)"):format(Args.Color or "1,1,1"))(),
						Type = Args.Type,
						Range = tonumber(Args.Range),
						Brightness = tonumber(Args.Brightness),
						Face = Args.Face,
					})
				else
					Functions:Light(NewBlock,{
						Color = loadstring(("return Color3.new(%*)"):format(Args.Color or "1,1,1"))(),
						Type = Args.Type,
						Range = tonumber(Args.Range),
						Brightness = tonumber(Args.Brightness),
						Face = Args.Face,
					})
				end
			end,
			Texture = BuildClient.SetTexture,
		}
		Tab:CreateButton({
			Name = "开始建造",
			Callback = function()
				local message = Instance.new("Message",GuiMain)



				if Selected and isfile([[TDM/TSBAutoBuilder/]]..Selected) then
					local File = game:GetService("HttpService"):JSONDecode(readfile([[TDM/TSBAutoBuilder/]]..Selected))

					local i = 1

					local function pairsfunc()
						if i == #File + 1 then
							message:Destroy()
							return "end"
						end
						i = i + 1
						xpcall(function()
							local v = File[i]
							if v == nil then
								warn("nil!")
								return
							end
							if viewmodel:FindFirstChild(tostring(i)) then
								v.CFrame = tostring(viewmodel:FindFirstChild(tostring(i)).CFrame)
							end


							local size = loadstring(("return vector.create(%*)"):format(v.Size or "1,1,1"))()

							local newblock = AddBlock({CFrame = v.CFrame,Shape = v.Shape})



							v.Color = loadstring(("return Color3.new(%*)"):format(string.gsub(v.Color or "1,1,1", " ", "")))()
							Functions:Material(newblock,v.Material)
							Functions:Color(newblock,v.Color)
							Functions:Collide(newblock,tostring(v.Properties.Collision) == "true")
							Functions:Transparency(newblock,tonumber(v.Else.Transparency))

							if v.Light then
								for i,tba in pairs(v.Light) do
									Functions:LightFunction(newblock,{
										Color = tba.Color,
										Type = "PointLight",
										Range = tonumber(tba.Range),
										Brightness = tonumber(tba.Brightness),
										Offset = loadstring(("return CFrame.new(%*)"):format(tba.Offset or "0,0,0"))(),
									})
								end
							end

							if v.SFLight then
								for i,tba in pairs(v.SFLight) do
									Functions:LightFunction(newblock,{
										Color = tba.Color,
										Type = "SurfaceLight",
										Range = tonumber(tba.Range),
										Brightness = tonumber(tba.Brightness),
										Face = tba.Face,
										Offset = loadstring(("return CFrame.new(%*)"):format(tba.Offset or "0,0,0"))(),
									})
								end
							end

							if v.Else.MeshID then
								local AddSize

								if v.elsea.MeshSize then
									local MeshSize = loadstring(("return vector.create(%*)"):format(v.elsea.MeshSize))()
									local finalsize = vector.create(size.X/MeshSize.X,size.Y/MeshSize.Y,size.Z/MeshSize.Z)
									AddSize = finalsize*meshscalesize
								elseif v.elsea.MeshScale then
									AddSize = loadstring(("return vector.create(%*)"):format(v.elsea.MeshScale))()
								end

								if not meshcoll then
									v.Properties.Collision = "false"
								end

								BuildClient:SetMesh(newblock,"FileMesh",{nil,AddSize,v.Else.MeshID,v.Else.MeshTextureID})

								if not v.Else.MeshTextureID and MaterialIDTable[v.Material] then
									for i,en in pairs(Enum.NormalId:GetEnumItems()) do
										if v.Decal[en.Name] or v.Texture[en.Name] then continue end
										Functions:Texture(newblock,{
											Face = en.Name,
											Type = "Texture",
											Texture = MaterialIDTable[v.Material],
											Color = v.Color,
											Transparency = tonumber(v.Else.Transparency),
											TileV = 8,
											TileU = 8,
										})
									end
								end

								if v.Texture then
									for en,argss in pairs(v.Texture) do
										Functions:Texture(newblock,{
											Face = en.Name,
											Type = "Texture",
											Texture = argss.Texture,
											Color = loadstring(("return Color3.new(%*)"):format(argss.Color or "1,1,1"))(),
											Transparency = tonumber(argss.Transparency),
											TileV = argss.StudsU,
											TileU = argss.StudsV,
										})
									end
								end

								if v.Decal then
									for en,argss in pairs(v.Decal) do
										if v.Texture and v.Texture[en.Name] then continue end
										Functions:Texture(newblock,{
											Face = en.Name,
											Type = "Decal",
											Texture = argss.Texture,
											Color = loadstring(("return Color3.new(%*)"):format(argss.Color or "1,1,1"))(),
											Transparency = tonumber(argss.Transparency),
										})
									end
								end
							else
								Functions:Size(newblock,size)
							end
						end,function(error)
							warn(error)
						end)

						message.Text = string.format("Building... %*/%*",i,#File.." (%" ..math.floor(i/#File*10000)/100)
					end

					while true do
						local i1 = 1
						repeat
							task.spawn(pairsfunc)
							i1 = i1 + 1
						until i1 >= buildercount or i == #File + 1
						game:GetService("RunService").Heartbeat:Wait()
					end
				end
			end,
		})
	elseif game.PlaceId == 5593470048 then
		local ftable = require(game:GetService("ReplicatedStorage").Controllers.PianoController)
		local MidiToTable = GetApi("https://raw.githubusercontent.com/qian-cheng-awa/Tools/refs/heads/main/MidiToTable.lua")

		local function MidiNoteToPianoKey(midiNote)
			local baseMidi = 60
			local basePiano = 40
			local offset = midiNote - baseMidi
			local pianoKey = (basePiano + offset) % 89
			return math.max(pianoKey, 0)
		end

		local function Press(index)
			ftable:PressClientKey(index, index)
		end

		local function Release(index)
			ftable:ReleaseClientKey(index)
		end
		local Players = game:GetService("Players")
		local Player = Players.LocalPlayer
		local Tab = Window:CreateTab("自动弹琴", "airplay")

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
		local ad = Tab:CreateDropdown({
			Name = "选择文件",
			Options = Folder,
			MultipleOptions = false,
			Flag = "Dropdown1",
			Callback = function(Options)
				midiData = MidiToTable(Options[1] and readfile("TDM/AutoPiano/"..Options[1]))
				Disabled = {}
				local tracks = {}

				for i=1,#midiData.tracks do
					table.insert(tracks, tostring(i))
				end

				yg:Refresh(tracks)
			end,
		})

		Tab:CreateButton({
			Name = "刷新",
			Callback = function()
				local Folder = listfiles("TDM/AutoPiano")
				for i,v in pairs(Folder) do
					Folder[i] = string.gsub(v,"TDM/AutoPiano/","",1)
				end
				ad:Refresh(Folder)
			end,
		})

		local qy

		yg = Tab:CreateDropdown({
			Name = "音轨",
			Options = {},
			MultipleOptions = true,
			Flag = "Dropdown1",
			Callback = function(Options)
				if #Options > 1 then
					qy:Set(false)
				else
					qy:Set(Disabled[tonumber(Options[1])])
				end
			end,
		})

		qy = Tab:CreateToggle({
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

		Tab:CreateSlider({
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
		Tab:CreateToggle({
			Name = "开始演奏",
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
	elseif game.PlaceId == 6520999642 then
		local s = game:GetService("Players").LocalPlayer.PlayerGui.Main.FNFMain.songPlay
		local a = require(s)

		local CreateNote
		local CreateNote2

		for _,v in pairs(debug.getupvalues(a.PlaySong)) do
			if typeof(v) == "function" and debug.info(v,"n") == "CreateNote" then
				CreateNote = v
			elseif typeof(v) == "function" and debug.info(v,"n") == "CreateNote2" then
				CreateNote2 = v
			end
		end

		local BotPlay = false
		local Tab = Window:CreateTab("自动游玩", "airplay")
		Tab:CreateToggle({
			Name = "开启",
			CurrentValue = BotPlay,
			Callback = function(Value)
				BotPlay = Value
			end    
		})

		local KeyPress = getsenv(s).KeyPress
		local KeyLift = getsenv(s).KeyLift

		local Inputs = getsenv(game:GetService("Players").LocalPlayer.PlayerGui.Main.FNFMain.songPlay)._G.Settings.Inputs

		if not ishooked(CreateNote) and not ishooked(CreateNote2) then
			local old;old = hookfunction(CreateNote,function(...)
				if BotPlay then
					local args = {...}
					local ArrowNumber = args[1]
					local Ln = args[3]

					task.delay(2,function()
						local InputK = {
							KeyCode = Enum.KeyCode[Inputs[ArrowNumber]],
							UserInputType = Enum.UserInputType.Keyboard,
						}
						KeyPress(InputK,false)
						task.delay(Ln,function()
							KeyLift(InputK,false)
						end)
					end)

				end
				return old(...)
			end)

			local old2;old2 = hookfunction(CreateNote2,function(...)
				if BotPlay then
					local args = {...}
					local ArrowNumber = args[1]
					local Ln = args[3]

					task.delay(2,function()
						local InputK = {
							KeyCode = Enum.KeyCode[Inputs[ArrowNumber]],
							UserInputType = Enum.UserInputType.Keyboard,
						}
						KeyPress(InputK,false)
						task.delay(Ln,function()
							KeyLift(InputK,false)
						end)
					end)
				end
				return old2(...)
			end)

			local notese = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Notes")
			local IsA = game.IsA
			local oldnamecall;oldnamecall = hookmetamethod(game, "__namecall", function(remote,...)
				if BotPlay then
					local method = getnamecallmethod()

					if method and (method == "FireServer" or method == "fireServer") then
						if typeof(remote) == 'Instance' then
							local args = {...}
							if IsA(remote,"RemoteEvent") and remote == notese and args[1] and typeof(args[1]) == "table" then    
								args[2] = 0
								return oldnamecall(remote,unpack(args))
							end
						end
					end
				end
				return oldnamecall(remote,...)
			end)
		end
	end


	if not Rayfield["_G"].TDMRunId then
		game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
			for i,v in pairs(Rayfield["_G"].TDMHeartbeat) do
				local sus,err = pcall(function()
					v(deltaTime)
				end)
				if not sus then
					warn(err)
				end
			end
		end)
		game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
			for i,v in pairs(Rayfield["_G"].TDMRenderStepped) do
				local sus,err = pcall(function()
					v(deltaTime)
				end)
				if not sus then
					warn(err)
				end
			end
		end)
		game:GetService("UserInputService").InputBegan:Connect(function(input)
			for i,v in pairs(Rayfield["_G"].TDMInputBegan) do
				local sus,err = pcall(function()
					v(input)
				end)
				if not sus then
					warn(err)
				end
			end
		end)
		game:GetService("UserInputService").InputEnded:Connect(function(input)
			for i,v in pairs(Rayfield["_G"].TDMInputEnded) do
				local sus,err = pcall(function()
					v(input)
				end)
				if not sus then
					warn(err)
				end
			end
		end)
	end
	if not Rayfield["_G"].TDMRunId then
		Rayfield["_G"].TDMRunId = TDMRunId
	end
end
