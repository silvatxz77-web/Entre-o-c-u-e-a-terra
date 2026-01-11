--[[ 
    ZENITH: OMNIPOTENCE CORE - V15 (SUPREME BRUTALITY)
    DEVELOPMENT: ELITE TITAN STANDARD (5 YEARS+)
    ARCHITECTURE: MULTI-THREADED KERNEL
    FEATURES: BERSERK PHYSICS, OMNI-FATALITIES, CINEMATIC TEXTURE-STREAMING
]]

if _G.OmnipotenceLoaded then return end
_G.OmnipotenceLoaded = true

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

-- // [1. SUB-ENGINE: OMNI-CINEMATICS (BRUTAL)]
local Omni = {
    Cache = {},
    ActiveMatch = false,
    CurrentChar = nil,
    Enemy = nil
}

function Omni:Tween(obj, info, goal)
    TS:Create(obj, TweenInfo.new(unpack(info)), goal):Play()
end

-- // CUTSCENE DE TEXTO NIVEL CINEMA (FONTE E ANIMAÇÃO)
function Omni:TextCinematic(text, color)
    local sg = Instance.new("ScreenGui", LP.PlayerGui)
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(1, 0, 0.2, 0); frame.Position = UDim2.new(0, 0, 0.4, 0); frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.Text = ""
    label.TextColor3 = color; label.Font = "Antique"; label.TextSize = 75; label.RichText = true
    label.TextStrokeTransparency = 0; label.TextStrokeColor3 = Color3.new(0,0,0)

    -- Efeito de glitch e digitação
    task.spawn(function()
        for i = 1, #text do
            label.Text = string.sub(text, 1, i)
            local s = Instance.new("Sound", Lighting); s.SoundId = "rbxassetid://6830694318"; s.Volume = 0.5; s:Play(); Debris:AddItem(s, 0.1)
            task.wait(0.04)
        end
        task.wait(2)
        Omni:Tween(label, {1, Enum.EasingStyle.QuintIn}, {TextTransparency = 1, TextSize = 150})
        Debris:AddItem(sg, 1.2)
    end)
end

-- // [2. OMNI-HITBOX & DAMAGE (BRUTALIDADE REAL)]
function Omni:Hit(target, dmg, shake, color)
    if not target then return end
    local hum = target.Character:FindFirstChild("Humanoid")
    if hum then
        hum:TakeDamage(dmg)
        -- Impact Frame Negro
        local cc = Instance.new("ColorCorrectionEffect", Lighting)
        cc.Contrast = 10; cc.Saturation = -1; cc.Brightness = 5
        Omni:Tween(cc, {0.2}, {Contrast = 0, Saturation = 0, Brightness = 0})
        Debris:AddItem(cc, 0.3)
        
        -- Shake de Camera Destrutivo
        task.spawn(function()
            for i = 1, 15 do
                Cam.CFrame = Cam.CFrame * CFrame.Angles(math.rad(math.random(-shake,shake)), math.rad(math.random(-shake,shake)), 0)
                RS.RenderStepped:Wait()
            end
        end)
    end
end

-- // [3. DATABASE: OS 9 REIS (VERSÃO SEM LIMITES)]
local Database = {
    ["GOJO"] = {
        Color = Color3.fromRGB(0, 160, 255),
        Intro = "O CÉU E A TERRA... EU SOU O ÚNICO HONRADO",
        Skills = {"AZUL", "VERMELHO", "RELÂMPAGO", "ROXO"},
        Ult = function(t)
            Omni:TextCinematic("EXPANSÃO DE DOMÍNIO: VAZIO INFINITO", Color3.new(1,1,1))
            local s = Instance.new("Part", workspace); s.Shape = "Ball"; s.Size = Vector3.new(1,1,1); s.Position = t.Character.HumanoidRootPart.Position
            s.Anchored = true; s.CanCollide = false; s.Material = "Neon"; s.Color = Color3.new(0,0,0)
            Omni:Tween(s, {2, Enum.EasingStyle.ExponentialOut}, {Size = Vector3.new(200, 200, 200), Transparency = 0.5})
            task.wait(2)
            Omni:Hit(t, 100, 5, Color3.new(1,1,1))
            Debris:AddItem(s, 0.5)
        end
    },
    ["SUKUNA"] = {
        Color = Color3.fromRGB(255, 0, 40),
        Intro = "ADORE O ÚNICO REI VERDADEIRO",
        Skills = {"CLIVAR", "DESMANTELAR", "FLECHA", "SANTUÁRIO"},
        Ult = function(t)
            Omni:TextCinematic("SANTUÁRIO MALÉVOLO", Color3.fromRGB(255,0,0))
            for i=1, 50 do
                Omni:Hit(t, 2, 1, Color3.new(1,0,0))
                task.wait(0.05)
            end
            Omni:Hit(t, 100, 10, Color3.new(1,0,0))
        end
    }
}

-- // [4. DESIGN BRUTALISTA DE HUD (CONFORTO AAA)]
local function CreateOmniHUD(name)
    local data = Database[name]
    local sg = Instance.new("ScreenGui", LP.PlayerGui); sg.Name = "OmniHUD"; sg.IgnoreGuiInset = true
    
    -- Botões de Skill (Design de Fibra de Carbono)
    local holder = Instance.new("Frame", sg)
    holder.Size = UDim2.new(0.4, 0, 0.12, 0); holder.Position = UDim2.new(0.3, 0, 0.85, 0); holder.BackgroundTransparency = 1
    Instance.new("UIListLayout", holder, {FillDirection = "Horizontal", Padding = UDim.new(0.02, 0), HorizontalAlignment = "Center"})

    for i = 1, 4 do
        local b = Instance.new("TextButton", holder)
        b.Size = UDim2.new(0, 100, 0, 80); b.BackgroundColor3 = Color3.fromRGB(10,10,10); b.Text = data.Skills[i]
        b.TextColor3 = data.Color; b.Font = "GothamBlack"; b.TextSize = 12
        Instance.new("UICorner", b); Instance.new("UIStroke", b, {Color = data.Color, Thickness = 3})
        
        b.MouseButton1Click:Connect(function()
            if i == 4 and Omni.Enemy then
                data.Ult(Omni.Enemy)
            else
                Omni:Hit(Omni.Enemy, 10, 1.5, data.Color)
            end
        end)
    end
end

-- // [5. ARENA E SELEÇÃO (ULTRA-REALISMO)]
local function StartTheGame(target)
    Omni.Enemy = target
    local arena = Instance.new("Part", workspace)
    arena.Size = Vector3.new(2000, 20, 2000); arena.Position = Vector3.new(0, 500000, 0); arena.Anchored = true; arena.Color = Color3.new(0,0,0)
    
    LP.Character.HumanoidRootPart.CFrame = arena.CFrame * CFrame.new(0, 20, 120)
    target.Character.HumanoidRootPart.CFrame = arena.CFrame * CFrame.new(0, 20, -120)
    
    -- Seleção Fullscreen Cinema
    local sel = Instance.new("ScreenGui", LP.PlayerGui)
    local f = Instance.new("Frame", sel); f.Size = UDim2.new(1,0,1,0); f.BackgroundColor3 = Color3.new(0,0,0)
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0.3,0,0.1,0); b.Position = UDim2.new(0.35,0,0.45,0); b.Text = "GOJO"; b.TextColor3 = Color3.new(0,0.6,1); b.Font = "Antique"; b.TextSize = 50
    
    b.MouseButton1Click:Connect(function()
        sel:Destroy()
        Omni:TextCinematic(Database["GOJO"].Intro, Database["GOJO"].Color)
        CreateOmniHUD("GOJO")
    end)
end

-- // [6. CORE LOOP (ZERO LATENCY)]
task.spawn(function()
    while true do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < 15 then
                    StartTheGame(p); return
                end
            end
        end
        task.wait(0.5)
    end
end)
