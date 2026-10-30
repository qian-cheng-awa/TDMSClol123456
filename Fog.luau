--!strict
-- FogPlaneModule (ModuleScript)
-- 相机空间多层雾平面（正反交替），可开关、可热更设置（含透明度）。

local RunService = game:GetService("RunService")

local FogPlane = {}

--==================== 内部状态 ====================--

local enabled = false
local connection = nil

local camPart = nil
local container = nil
local planeTemplate = nil
local invertedTemplate = nil

local pool = {}
local poolSize = 0

-- 可调参数（透明度也在里面）
local settings = {
	planeSpacing = 0.8,
	planeCount = 50,
	workerCount = 4,
	maxConcurrentTasks = 8,
	transparency = 0.989,   -- 0~1，越小越实
}

local prevCamCF, prevFOV, prevViewportX, prevViewportY
local frameToken = 0
local activeTaskCount = 0

local yawRight = CFrame.Angles(0, math.rad(90), 0)
local invertedYaw = CFrame.Angles(0, math.rad(180), 0)

--==================== 模板 / 容器 ====================--

local function getCamera()
	return workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera")
end

local function ensureTemplates()
	if camPart and camPart.Parent ~= nil and planeTemplate and invertedTemplate then
		return true
	end

	local existing = script:FindFirstChild("CameraPart")
	if existing then
		camPart = existing
		planeTemplate = camPart:FindFirstChild("Plane")
		invertedTemplate = camPart:FindFirstChild("InvertedPlane")
		if planeTemplate and invertedTemplate then
			return true
		end
	end

	local CameraPart = Instance.new("Part")
	CameraPart.Massless = true
	CameraPart.CanQuery = false
	CameraPart.CanCollide = false
	CameraPart.CFrame = CFrame.new(-263.6899719238281, 72.03553771972656, -146.81546020507812)
		* CFrame.fromEulerAnglesYXZ(0, -math.pi / 2, 0)
	CameraPart.CanTouch = false
	CameraPart.Anchored = true
	CameraPart.Transparency = 1
	CameraPart.Name = "CameraPart"
	CameraPart.Locked = true
	CameraPart.Material = Enum.Material.Neon
	CameraPart.CastShadow = false
	CameraPart.Size = Vector3.new(1, 1, 1)

	local InvertedPlane = Instance.new("MeshPart")
	InvertedPlane.CanCollide = false
	InvertedPlane.Parent = CameraPart
	InvertedPlane.Transparency = 1
	InvertedPlane.Name = "InvertedPlane"
	InvertedPlane.Material = Enum.Material.SmoothPlastic
	InvertedPlane.MeshId = "rbxassetid://114656556193866"

	local Plane = Instance.new("MeshPart")
	Plane.CanCollide = false
	Plane.Parent = CameraPart
	Plane.Transparency = 1
	Plane.Name = "Plane"
	Plane.Material = Enum.Material.SmoothPlastic
	Plane.MeshId = "rbxassetid://90584637195574"

	camPart = CameraPart
	planeTemplate = Plane
	invertedTemplate = InvertedPlane
	return true
end

local function ensureContainer()
	if container and container.Parent ~= nil then
		return true
	end

	local camera = getCamera()
	if not camera then
		return false
	end

	ensureTemplates()

	container = camPart:Clone()
	container.Parent = camera
	if container:FindFirstChild("Plane") then
		container.Plane:Destroy()
	end
	if container:FindFirstChild("InvertedPlane") then
		container.InvertedPlane:Destroy()
	end
	return true
end

--==================== 池管理 ====================--

local function ensurePoolSize(count)
	if count <= 0 then count = 0 end
	if not ensureContainer() then return end

	for i = poolSize + 1, count do
		local template = ((i % 2) == 1) and planeTemplate or invertedTemplate
		local p = template:Clone()
		p:SetAttribute("IsInverted", (i % 2) == 0)
		p.Anchored = true
		p.CanCollide = false
		p.CastShadow = false
		p.Transparency = settings.transparency
		p.Parent = container
		if not p:GetAttribute("OrigSizeX") then
			p:SetAttribute("OrigSizeX", p.Size.X)
			p:SetAttribute("OrigSizeY", p.Size.Y)
			p:SetAttribute("OrigSizeZ", p.Size.Z)
		end
		pool[i] = p
	end
	for i = count + 1, poolSize do
		if pool[i] then
			pool[i]:Destroy()
			pool[i] = nil
		end
	end
	poolSize = count
end

--==================== 尺寸计算 ====================--

local function computePlaneSize(distance, cam)
	local fovRad = math.rad(cam.FieldOfView)
	local height = 2 * distance * math.tan(fovRad * 0.5)
	local aspect = cam.ViewportSize.X / math.max(1, cam.ViewportSize.Y)
	local width = height * aspect
	return height, width
end

--==================== 单帧更新 ====================--

local function updateAllPlanes(camera)
	if not camera or poolSize == 0 then return end

	local camCF = camera.CFrame
	local spacing = settings.planeSpacing
	local transparency = settings.transparency

	for i = 1, poolSize do
		local p = pool[i]
		if not p then continue end
		local base = camCF * yawRight * CFrame.new(i * spacing, 0, 0)
		if p:GetAttribute("IsInverted") then
			p.CFrame = base * invertedYaw
		else
			p.CFrame = base
		end
		local distance = math.abs(i * spacing)
		local height, width = computePlaneSize(distance, camera)
		local origX = p:GetAttribute("OrigSizeX") or p.Size.X
		p.Size = Vector3.new(origX, height, width)
		p.Transparency = transparency
	end
end

--==================== RenderStepped 主循环 ====================--

local function onRenderStepped()
	if not enabled then return end

	local camera = getCamera()
	if not camera then return end

	local camCF = camera.CFrame
	local fov = camera.FieldOfView
	local vs = camera.ViewportSize

	if prevCamCF and camCF == prevCamCF and fov == prevFOV
		and vs.X == prevViewportX and vs.Y == prevViewportY then
		return
	end
	prevCamCF = camCF
	prevFOV = fov
	prevViewportX = vs.X
	prevViewportY = vs.Y

	if poolSize == 0 then return end

	frameToken = frameToken + 1
	local myToken = frameToken

	local configuredWorkers = math.max(1, math.floor(settings.workerCount))
	local configuredMaxTasks = math.max(1, math.floor(settings.maxConcurrentTasks))

	if activeTaskCount >= configuredMaxTasks then
		updateAllPlanes(camera)
		return
	end

	local batches = math.min(configuredWorkers, poolSize)
	local batchSize = math.floor(poolSize / batches)
	local ranges = {}
	local startIdx = 1
	for b = 1, batches do
		local endIdx = startIdx + batchSize - 1
		if b == batches then endIdx = poolSize end
		if endIdx >= startIdx then
			table.insert(ranges, { startIdx, endIdx })
		end
		startIdx = endIdx + 1
	end

	local spacing = settings.planeSpacing
	local transparency = settings.transparency

	for _, r in ipairs(ranges) do
		activeTaskCount = activeTaskCount + 1
		task.spawn(function()
			local ok, err = pcall(function()
				local localResults = {}
				for i = r[1], r[2] do
					local p = pool[i]
					if not p then
						localResults[i] = nil
						continue
					end
					local base = camCF * yawRight * CFrame.new(i * spacing, 0, 0)
					local cframe
					if p:GetAttribute("IsInverted") then
						cframe = base * invertedYaw
					else
						cframe = base
					end
					local distance = math.abs(i * spacing)
					local height, width = computePlaneSize(distance, camera)
					local origX = p:GetAttribute("OrigSizeX") or p.Size.X
					localResults[i] = {
						cframe = cframe,
						size = Vector3.new(origX, height, width),
					}
				end

				if myToken ~= frameToken then
					return
				end

				for i = r[1], r[2] do
					local res = localResults[i]
					local p = pool[i]
					if res and p then
						p.CFrame = res.cframe
						p.Size = res.size
						p.Transparency = transparency
					end
				end
			end)
			if not ok then
				warn("FogPlane worker error:", err)
			end
			activeTaskCount = activeTaskCount - 1
		end)
	end
end

--==================== 启停 ====================--

local function start()
	if enabled then return end
	enabled = true

	ensureTemplates()
	ensureContainer()
	ensurePoolSize(settings.planeCount)

	prevCamCF = nil

	if connection then
		connection:Disconnect()
		connection = nil
	end
	connection = RunService.RenderStepped:Connect(onRenderStepped)
end

local function stop()
	if not enabled then return end
	enabled = false

	if connection then
		connection:Disconnect()
		connection = nil
	end

	for i = poolSize, 1, -1 do
		if pool[i] then
			pool[i]:Destroy()
			pool[i] = nil
		end
	end
	poolSize = 0

	if container then
		container:Destroy()
		container = nil
	end

	prevCamCF = nil
end

--==================== 公开 API ====================--

-- 开关：true 启动，false 停止并清理
function FogPlane.Enable(state: boolean)
	if state then
		start()
	else
		stop()
	end
end

function FogPlane.IsEnabled(): boolean
	return enabled
end

-- 改设置：可只传部分字段
--   planeSpacing       (number, stud)
--   planeCount         (number, 层数)
--   workerCount        (number, worker 数)
--   maxConcurrentTasks (number, 并发上限)
--   transparency       (number, 0~1，越小越实)
function FogPlane.SetSettings(newSettings: { [string]: any })
	if type(newSettings) ~= "table" then
		return
	end

	local function applyNumber(key: string, minVal: number?, maxVal: number?)
		local v = newSettings[key]
		if type(v) == "number" then
			v = math.floor(v + 0.5)
			if minVal then v = math.max(minVal, v) end
			if maxVal then v = math.min(maxVal, v) end
			settings[key] = v
		end
	end

	local function applyFloat(key: string, minVal: number?, maxVal: number?)
		local v = newSettings[key]
		if type(v) == "number" then
			if minVal then v = math.max(minVal, v) end
			if maxVal then v = math.min(maxVal, v) end
			settings[key] = v
		end
	end

	applyFloat("planeSpacing", 0.01)
	applyNumber("planeCount", 0)
	applyNumber("workerCount", 1)
	applyNumber("maxConcurrentTasks", 1)
	applyFloat("transparency", 0, 1)

	if enabled then
		if poolSize ~= settings.planeCount then
			ensurePoolSize(settings.planeCount)
		end
		prevCamCF = nil
		local camera = getCamera()
		if camera then
			updateAllPlanes(camera)
		end
	end
end

-- 读取当前设置（返回副本）
function FogPlane.GetSettings(): { [string]: any }
	local copy = {}
	for k, v in pairs(settings) do
		copy[k] = v
	end
	return copy
end

-- 完全销毁模块资源（包括模板）
function FogPlane.Destroy()
	stop()
	if container then
		container:Destroy()
		container = nil
	end
	if camPart and camPart.Parent == nil then
		camPart:Destroy()
	end
	camPart = nil
	planeTemplate = nil
	invertedTemplate = nil
end

return FogPlane
