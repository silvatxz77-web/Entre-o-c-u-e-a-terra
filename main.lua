--[[ 
    SATORU GOJO: THE LIMITLESS ONE
    FEATURES: INFINITY (PASSIVE), HOLLOW PURPLE FUSION, VOID DIMENSION, SIX EYES ROOM
    STYLE: SONIC.EXE PREMIUM BUTTONS
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

-- // [1. PASSIVAS: ILIMITADO & ANTI-FLING]
task.spawn(function()
    while task.wait() do
        -- Ilimitado: Empurra qualquer coisa que chegue perto
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < 10 then
                    local v = Instance.new("BodyVelocity", p.Character.HumanoidRootPart)
                    v.Velocity = (p.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Unit * 50
                    v.MaxForce = Vector3.new(1e6, 1e6, 1e6); Debris:AddItem(v, 0.1)
                end
            end
        end
        -- Anti-Fling
        if LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            LP.Character.HumanoidRootPart.RotVelocity = Vector3.new(0,0,0)
        end
    end
end)

-- // [2. ENGINE DE SKILLS (DELAY DE 2s & FUSÃO)]
local Gojo = {
    AzulAtivo = false,
    VermelhoAtivo = false,
    Casting = false,
    InDomain = false
}

function Gojo:VFX_Charge(color)
    local p = Instance.new("Part", LP.Character); p.Size = Vector3.new(1,1,1); p.Shape = "Ball"
    p.Color = color; p.Material = "Neon"; p.CanCollide = false; p.Anchored = false
    local w = Instance.new("Weld", p); w.Part0 = p; w.Part1 = LP.Character["Right Arm"]; w.C1 = CFrame.new(0,-1.5,0)
    TS:Create(p, TweenInfo.new(2), {Size = Vector3.new(4,4,4)}):Play()
    Debris:AddItem(p, 2)
end

-- // [3. SKILLS PRINCIPAIS]
function Gojo:LapsoAzul()
    if Gojo.Casting then return end
    Gojo.Casting = true
    Gojo:VFX_Charge(Color3.new(0,0.5,1))
    task.wait(2)
    Gojo.AzulAtivo = true
    -- Puxa Geral
    for i=1, 50 do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                p.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame:Lerp(LP.Character.HumanoidRootPart.CFrame, 0.1)
            end
        end
        RS.RenderStepped:Wait()
    end
    Gojo.AzulAtivo = false
    Gojo.Casting = false
end

function Gojo:Vermelho()
    if Gojo.Casting then return end
    Gojo.Casting = true
    Gojo:VFX_Charge(Color3.new(1,0,0))
    task.wait(2)
    Gojo.VermelhoAtivo = true
    -- Fling Absurdo
    local p = Instance.new("Part", workspace); p.Size = Vector3.new(20,20,20); p.Transparency = 1; p.CanCollide = false
    p.Position = LP.Character.HumanoidRootPart.Position + LP.Character.HumanoidRootPart.CFrame.LookVector * 10
    local exp = Instance.new("Explosion", workspace); exp.Position = p.Position; exp.BlastRadius = 50; exp.BlastPressure = 1e7
    task.wait(0.5)
    Gojo.VermelhoAtivo = false
    Gojo.Casting = false
end

-- // [4. VAZIO ROXO: FUSÃO YIN YANG]
function Gojo:HollowPurple()
    Gojo.Casting = true
    -- Animação de Travamento
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP then
            local sg = Instance.new("ScreenGui", p.PlayerGui)
            local l = Instance.new("TextLabel", sg); l.Size = UDim2.new(1,0,1,0); l.Text = "MURASAKI"; l.TextSize = 100; l.TextColor3 = Color3.new(0.5,0,1); l.BackgroundTransparency = 0.5; l.BackgroundColor3 = Color3.new(0,0,0)
            Debris:AddItem(sg, 3)
        end
    end
    
    -- Cutscene de Ombro
    local r = Instance.new("Part", LP.Character); r.Color = Color3.new(1,0,0); r.Size = Vector3.new(2,2,2); r.Shape = "Ball"; r.Material = "Neon"
    local a = Instance.new("Part", LP.Character); a.Color = Color3.new(0,0,1); a.Size = Vector3.new(2,2,2); a.Shape = "Ball"; a.Material = "Neon"
    r.Anchored = true; a.Anchored = true
    
    for i=1, 100 do
        local t = i/10
        r.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(math.cos(t)*5, 5, math.sin(t)*5)
        a.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(math.cos(t+math.pi)*5, 5, math.sin(t+math.pi)*5)
        RS.RenderStepped:Wait()
    end
    
    -- Disparo que destrói o mapa
    local purple = Instance.new("Part", workspace); purple.Size = Vector3.new(10,10,10); purple.Shape = "Ball"; purple.Color = Color3.fromRGB(150,0,255); purple.Material = "Neon"
    purple.CFrame = LP.Character.HumanoidRootPart.CFrame
    local v = Instance.new("BodyVelocity", purple); v.Velocity = LP.Character.HumanoidRootPart.CFrame.LookVector * 300; v.MaxForce = Vector3.new(1e8, 1e8, 1e8)
    
    purple.Touched:Connect(function(hit)
        if not hit:IsDescendantOf(LP.Character) then
            local e = Instance.new("Explosion", workspace); e.Position = purple.Position; e.BlastRadius = 100; e.BlastPressure = 1e9
        end
    end)
    
    Debris:AddItem(purple, 5); Debris:AddItem(r, 0.1); Debris:AddItem(a, 0.1)
    Gojo.Casting = false
end

-- // [5. EXPANSÃO DE DOMÍNIO: VAZIO INFINITO]
function Gojo:DomainExpansion()
    local domainPos = LP.Character.HumanoidRootPart.Position
    local sphere = Instance.new("Part", workspace)
    sphere.Shape = "Ball"; sphere.Size = Vector3.new(1,1,1); sphere.Position = domainPos
    sphere.Anchored = true; sphere.Material = "Neon"; sphere.Color = Color3.new(0,0,0); sphere.CanCollide = true
    
    TS:Create(sphere, TweenInfo.new(3), {Size = Vector3.new(200,200,200)}):Play()
    
    -- Sub-mundo (O QUARTO)
    local room = Instance.new("Part", workspace); room.Size = Vector3.new(100, 10, 100); room.Position = domainPos + Vector3.new(0, 1000, 0); room.Anchored = true
    
    task.spawn(function()
        while sphere.Parent do
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and (p.Character.HumanoidRootPart.Position - domainPos).Magnitude < 95 then
                    -- Mantém dentro
                else
                    if p == LP then LP.Character.HumanoidRootPart.CFrame = CFrame.new(domainPos) end
                end
            end
            task.wait()
        end
    end)
end

-- // [6. INTERFACE SONIC.EXE PREMIUM]
local sg = Instance.new("ScreenGui", LP.PlayerGui)
local container = Instance.new("Frame", sg)
container.Size = UDim2.new(0.3, 0, 0.4, 0); container.Position = UDim2.new(0.7, 0, 0.3, 0); container.BackgroundTransparency = 1
Instance.new("UIListLayout", container, {Padding = UDim.new(0.05, 0)})

local function MakeBtn(name, color, func)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(1, 0, 0.2, 0); b.BackgroundColor3 = Color3.new(0,0,0); b.Text = name; b.TextColor3 = color; b.Font = "Antique"; b.TextSize = 25
    Instance.new("UIStroke", b, {Color = color, Thickness = 3}); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
end

MakeBtn("LAPSO AZUL", Color3.new(0,0.5,1), function() Gojo:LapsoAzul() end)
MakeBtn("VERMELHO", Color3.new(1,0,0), function() Gojo:Vermelho() end)
MakeBtn("VAZIO ROXO", Color3.new(0.6,0,1), function() Gojo:HollowPurple() end)
MakeBtn("EXPANSÃO", Color3.new(1,1,1), function() Gojo:DomainExpansion() end)
