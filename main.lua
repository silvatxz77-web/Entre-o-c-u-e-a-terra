--[[ 
    PROJECT: ENTRE O CÉU E A TERRA - OMNIPOTENCE SUPREME (GOTY)
    REFINAMENTO: TOTAL (PHYSICS, VFX, CINEMATICS, SYNC)
    DESENVOLVEDOR: O TOP 1 MUNDIAL
]]

if _G.OmniSupreme then return end
_G.OmniSupreme = true

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

-- // [ENGINE DE MOVIMENTO E IMPACTO]
local Omni = {
    Energy = 0,
    Combo = 1,
    InMatch = false,
    Target = nil,
    Char = nil,
    Debounce = false
}

function Omni:Tween(obj, info, goal)
    local t = TS:Create(obj, TweenInfo.new(unpack(info)), goal)
    t:Play()
    return t
end

function Omni:Shake(p)
    task.spawn(function()
        for i=1, 6 do
            Cam.CFrame *= CFrame.new(math.random(-p,p)/10, math.random(-p,p)/10, math.random(-p,p)/10)
            RS.RenderStepped:Wait()
        end
    end)
end

-- // [VFX: IMPACT FRAMES E CRATERAS]
function Omni:VFX_Impact(pos)
    local p = Instance.new("Part", workspace)
    p.Size = Vector3.new(1,1,1); p.CFrame = CFrame.new(pos); p.Anchored = true; p.CanCollide = false
    p.Material = "Neon"; p.Color = Color3.new(1,1,1); p.Shape = "Ball"
    Omni:Tween(p, {0.4, Enum.EasingStyle.QuartOut}, {Size = Vector3.new(25,25,25), Transparency = 1})
    Debris:AddItem(p, 0.4)
    
    local cc = Instance.new("ColorCorrectionEffect", Lighting)
    cc.Brightness = 2; cc.Contrast = 5; cc.Saturation = -1
    Omni:Tween(cc, {0.2}, {Brightness = 0, Contrast = 0, Saturation = 0})
    Debris:AddItem(cc, 0.3)
end

-- // [MOVIMENTAÇÃO FLUIDA (PROCEDURAL)]
RS.RenderStepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        local hum = LP.Character.Humanoid
        local root = LP.Character.HumanoidRootPart
        local moveVec = hum.MoveDirection
        
        -- Inclinação ao andar
        local tilt = root.CFrame:VectorToObjectSpace(moveVec)
        local lerpVal = 0.1
        LP.Character.UpperTorso.Root.C0 = LP.Character.UpperTorso.Root.C0:Lerp(CFrame.new(0,0,0) * CFrame.Angles(math.rad(tilt.Z * 10), 0, math.rad(-tilt.X * 15)), lerpVal)
    end
end)

-- // [OS 4 REIS: CUTSCENES E PODER]
local Data = {
    ["GOJO"] = {C = Color3.fromRGB(0, 160, 255), S = {"AZUL", "VERMELHO", "VAZIO", "ROXO"}},
    ["SUKUNA"] = {C = Color3.fromRGB(255, 0, 50), S = {"CLIVAR", "CORTE", "FOGO", "SANTUÁRIO"}},
    ["TOJI"] = {C = Color3.fromRGB(180, 180, 180), S = {"CADEIA", "DASH", "LANÇA", "MATAR"}},
    ["HAKARI"] = {C = Color3.fromRGB(255, 0, 255), S = {"SORTE", "PORTÃO", "FEBRE", "JACKPOT"}}
}

-- // [ARENA DO CELL: RENDERIZADA]
local function BuildArena(target)
    local arena = Instance.new("Part", workspace)
    arena.Size = Vector3.new(1500, 20, 1500); arena.Position = Vector3.new(500000, 500000, 500000)
    arena.Anchored = true; arena.Material = "Slate"; arena.Color = Color3.fromRGB(15, 35, 15)
    
    -- Pilares e Atmosfera
    local sky = Instance.new("Sky", Lighting); sky.Name = "OmniSky"
    sky.SkyboxBk = "rbxassetid://600830446"; sky.SkyboxDn = "rbxassetid://600830446"
    
    for i=1, 15 do
        LP.Character.HumanoidRootPart.CFrame = arena.CFrame * CFrame.new(0, 25, 100)
        target.Character.HumanoidRootPart.CFrame = arena.CFrame * CFrame.new(0, 25, -100)
        RS.RenderStepped:Wait()
    end
end

-- // [INTERFACE GOTY 2077]
local function CreateHUD(target, name)
    local char = Data[name]
    local sg = Instance.new("ScreenGui", LP.PlayerGui)
    
    -- Estrela de Shenanigans (Dinâmica)
    local star = Instance.new("ImageLabel", sg)
    star.Size = UDim2.new(0, 120, 0, 120); star.Position = UDim2.new(0.47, 0, 0.72, 0); star.BackgroundTransparency = 1
    star.Image = "rbxassetid://15260172986"; star.ImageColor3 = Color3.new(0.1,0.1,0.1)
    
    RS.RenderStepped:Connect(function()
        if Omni.Energy < 100 then star.ImageColor3 = Color3.new(0.1,0.1,0.1)
        elseif Omni.Energy < 200 then star.ImageColor3 = Color3.new(1,1,0)
        elseif Omni.Energy < 300 then star.ImageColor3 = Color3.new(0,0.6,1)
        else 
            star.ImageColor3 = Color3.new(1,0,0)
            star.Size = UDim2.new(0, 120 + math.sin(tick()*10)*5, 0, 120 + math.sin(tick()*10)*5)
        end
    end)

    -- Skills (Design TSB)
    local bar = Instance.new("Frame", sg)
    bar.Size = UDim2.new(0.4,0,0.1,0); bar.Position = UDim2.new(0.3,0,0.85,0); bar.BackgroundTransparency = 1
    Instance.new("UIListLayout", bar, {FillDirection = "Horizontal", Padding = UDim.new(0.02,0), HorizontalAlignment = "Center"})

    for i=1, 4 do
        local b = Instance.new("TextButton", bar)
        b.Size = UDim2.new(0, 100, 0, 80); b.BackgroundColor3 = Color3.new(0,0,0); b.BackgroundTransparency = 0.5
        b.Text = char.S[i]; b.TextColor3 = char.C; b.Font = "Antique"; b.TextSize = 14
        Instance.new("UICorner", b); Instance.new("UIStroke", b, {Color = char.C, Thickness = 3})
        
        b.MouseButton1Click:Connect(function()
            if Omni.Debounce then return end
            Omni.Debounce = true
            
            -- Cutscene de Habilidade
            local oldFOV = Cam.FieldOfView
            Omni:Tween(Cam, {0.3, Enum.EasingStyle.BackOut}, {FieldOfView = 120})
            Omni:VFX_Impact(LP.Character.HumanoidRootPart.Position)
            
            task.wait(0.5)
            Omni:Tween(Cam, {0.5}, {FieldOfView = oldFOV})
            Omni.Debounce = false
        end)
    end
end

-- // [O COMBATE ZIKA P CARALHO]
LP.Character.Humanoid.AnimationPlayed:Connect(function() end) -- Bypass
Mouse = LP:GetMouse()
Mouse.Button1Down:Connect(function()
    if Omni.Debounce then return end
    Omni:Attack()
end)

function Omni:Attack()
    Omni.Debounce = true
    Omni.Combo = (Omni.Combo % 4) + 1
    
    -- Animação de Soco Procedural
    local arm = LP.Character:FindFirstChild("Right Arm") or LP.Character:FindFirstChild("RightUpperArm")
    Omni:Shake(Omni.Combo * 2)
    
    if Omni.Target then
        local dist = (LP.Character.HumanoidRootPart.Position - Omni.Target.Character.HumanoidRootPart.Position).Magnitude
        if dist < 15 then
            Omni.Energy = math.min(Omni.Energy + 10, 300)
            Omni:VFX_Impact(Omni.Target.Character.HumanoidRootPart.Position)
            Omni.Target.Character.Humanoid:TakeDamage(20)
            
            -- Hitstop (Congelamento GOTY)
            local speed = LP.Character.Humanoid.WalkSpeed
            LP.Character.Humanoid.WalkSpeed = 0
            task.wait(0.1)
            LP.Character.Humanoid.WalkSpeed = speed
        end
    end
    
    task.wait(0.3)
    Omni.Debounce = false
end

-- // [MENU DE CONVOCAÇÃO]
local iconSg = Instance.new("ScreenGui", LP.PlayerGui)
local btn = Instance.new("ImageButton", iconSg)
btn.Size = UDim2.new(0, 70, 0, 70); btn.Position = UDim2.new(0.02, 0, 0.45, 0); btn.Image = "rbxassetid://15623267039"; btn.Draggable = true
Instance.new("UICorner", btn, {CornerRadius = UDim.new(1,0)})

btn.MouseButton1Click:Connect(function()
    local f = Instance.new("Frame", iconSg); f.Size = UDim2.new(0, 250, 0, 150); f.Position = UDim2.new(0.1, 0, 0.45, 0); f.BackgroundColor3 = Color3.new(0,0,0)
    Instance.new("UICorner", f)
    local i = Instance.new("TextBox", f); i.Size = UDim2.new(0.9,0,0.3,0); i.Position = UDim2.new(0.05,0,0.1,0); i.PlaceholderText = "NICK DO ALVO"
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0.9,0,0.3,0); b.Position = UDim2.new(0.05,0,0.6,0); b.Text = "CONVOCAR PARA O CÉU"; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(function()
        local t = Players:FindFirstChild(i.Text)
        if t then
            f:Destroy()
            BuildArena(t)
            Omni.Target = t
            -- Cutscene de Entrada Invasiva no Inimigo
            local esg = Instance.new("ScreenGui", t.PlayerGui)
            local el = Instance.new("TextLabel", esg); el.Size = UDim2.new(1,0,1,0); el.BackgroundColor3 = Color3.new(0,0,0); el.Text = "ENTRE O CÉU E A TERRA..."; el.TextColor3 = Color3.new(1,1,1); el.Font = "Antique"; el.TextSize = 60
            Debris:AddItem(esg, 4)
            CreateHUD(t, "GOJO") -- Default de início
        end
    end)
end)
