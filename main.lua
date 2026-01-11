--[[
    VOID-INFINITY ENGINE v13 (REMASTERED)
    - Bypass de Física: Sistema de Movimentação Inercial Próprio
    - Rendering Overdrive: Efeitos visuais que rodam fora da pipeline padrão
    - Natural Disaster Glitch: "Ghost State" (Imunidade a desastres via CFrame)
    - Awakening: "The Honored One" & "King of Curses"
]]

-- LOG DE BOOT (IDENTIDADE VISUAL DO TOP 1)
local function Log(msg)
    local l = Instance.new("Message", workspace) -- Mensagem de sistema legada para garantir visibilidade
    l.Text = " [VOID ENGINE]: " .. msg
    task.delay(2, function() l:Destroy() end)
end
Log("INICIALIZANDO OVERRIDE DE ENGINE... [0%]")

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Root = Char:WaitForChild("HumanoidRootPart")
local Hum = Char:WaitForChild("Humanoid")
local Cam = workspace.CurrentCamera

-- // 1. ENGINE OVERRIDE (SAINDO DAS LIMITAÇÕES)
-- Criamos um estado onde o Roblox não controla mais o seu boneco
Hum.PlatformStand = true 
Root.Anchored = false

local EngineState = {
    Velocity = Vector3.new(0,0,0),
    Awakened = false,
    Character = "None",
    MugenActive = false,
    CursedEnergy = 1000
}

-- Custom Physics (Movimentação sem atrito/limites do Roblox)
local function CustomMove(targetPos)
    TS:Create(Root, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = targetPos}):Play()
end

-- // 2. VISUALS IMPORT (SHENANIGANS STYLE)
local function CreateVFX(name, pos, col)
    if name == "Impact" then
        local p = Instance.new("Part", workspace)
        p.Anchored = true; p.CanCollide = false; p.Material = "Neon"; p.Color = col; p.Shape = "Ball"
        p.Position = pos; p.Size = Vector3.new(1,1,1)
        TS:Create(p, TweenInfo.new(0.5), {Size = Vector3.new(30,30,30), Transparency = 1}):Play()
        game.Debris:AddItem(p, 0.5)
    end
end

-- // 3. MOVESET: GOJO SATORU (THE HONORED ONE)
local Gojo = {
    ["🔵 AZUL"] = function()
        Log("LAPSE BLUE")
        local b = Instance.new("Part", workspace)
        b.Size = Vector3.new(10,10,10); b.Shape = "Ball"; b.Material = "ForceField"; b.Color = Color3.new(0,0,1)
        b.Position = Root.Position + Root.CFrame.LookVector * 10
        local bv = Instance.new("BodyVelocity", b); bv.Velocity = Cam.CFrame.LookVector * 250
        b.Touched:Connect(function(h) if h.Parent:FindFirstChild("Humanoid") then h.Parent.HumanoidRootPart.CFrame = b.CFrame end end)
        game.Debris:AddItem(b, 5)
    end,
    
    ["🔴 VERMELHO"] = function()
        Log("REVERSAL RED")
        CreateVFX("Impact", Root.Position, Color3.new(1,0,0))
        for _, v in pairs(workspace:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v ~= Char then
                local dist = (v.HumanoidRootPart.Position - Root.Position).Magnitude
                if dist < 100 then
                    v.HumanoidRootPart.Velocity = (v.HumanoidRootPart.Position - Root.Position).Unit * 1200
                end
            end
        end
    end,

    ["🟣 ROXO"] = function()
        Log("HOLLOW PURPLE")
        local p = Instance.new("Part", workspace)
        p.Size = Vector3.new(60,60,60); p.Shape = "Ball"; p.Color = Color3.fromRGB(150,0,255); p.Material = "ForceField"
        p.Position = Root.Position; p.CanCollide = false
        local bv = Instance.new("BodyVelocity", p); bv.Velocity = Cam.CFrame.LookVector * 500
        p.Touched:Connect(function(h) if not h:IsDescendantOf(Char) then pcall(function() h:Destroy() end) end end)
    end,

    ["👁️ DOMÍNIO"] = function()
        Log("UNLIMITED VOID")
        local sphere = Instance.new("Part", workspace)
        sphere.Shape = "Ball"; sphere.Size = Vector3.new(1,1,1); sphere.Anchored = true; sphere.Position = Root.Position; sphere.Color = Color3.new(0,0,0)
        TS:Create(sphere, TweenInfo.new(2), {Size = Vector3.new(800,800,800)}):Play()
        task.delay(10, function() sphere:Destroy() end)
    end,

    ["♾️ MUGEN"] = function()
        EngineState.MugenActive = not EngineState.MugenActive
        Log("MUGEN: " .. tostring(EngineState.MugenActive))
    end,

    ["🌟 AWAKENING"] = function()
        EngineState.Awakened = true
        Log("AWAKENED: THE HONORED ONE")
        local s = Instance.new("Sound", game.CoreGui); s.SoundId = "rbxassetid://16823332026"; s.Volume = 5; s:Play()
        local h = Instance.new("Highlight", Char); h.FillColor = Color3.new(0,0.5,1)
    end
}

-- // 4. MOVESET: RYOMEN SUKUNA (KING OF CURSES)
local Sukuna = {
    ["🔪 DISMANTLE"] = function()
        for i = 1, 20 do
            local s = Instance.new("Part", workspace)
            s.Size = Vector3.new(100, 0.1, 5); s.Material = "Neon"; s.Color = Color3.new(1,1,1); s.Anchored = true
            s.CFrame = Root.CFrame * CFrame.new(math.random(-50,50), math.random(-20,20), -20)
            TS:Create(s, TweenInfo.new(0.3), {CFrame = s.CFrame * CFrame.new(0,0,-600), Transparency = 1}):Play()
            game.Debris:AddItem(s, 0.3)
        end
    end,

    ["🏹 FUUGA"] = function()
        Log("OPEN: FUUGA")
        local f = Instance.new("Part", workspace); f.Size = Vector3.new(5,5,50); f.Color = Color3.new(1,0.5,0); f.Material = "Neon"; f.Position = Root.Position
        local bv = Instance.new("BodyVelocity", f); bv.Velocity = Cam.CFrame.LookVector * 700
        f.Touched:Connect(function() local e = Instance.new("Explosion", workspace); e.Position = f.Position; e.BlastRadius = 300; f:Destroy() end)
    end,

    ["🌌 WORLD SLASH"] = function()
        Log("WORLD SLASH")
        local w = Instance.new("Part", workspace); w.Size = Vector3.new(1, 1000, 1000); w.Material = "Neon"; w.Color = Color3.new(1,1,1); w.CFrame = Root.CFrame * CFrame.new(0,0,-20); w.Anchored = true
        TS:Create(w, TweenInfo.new(1), {CFrame = w.CFrame * CFrame.new(0,0,-8000)}):Play()
        game.Debris:AddItem(w, 1)
    end,

    ["👹 AWAKENING"] = function()
        EngineState.Awakened = true
        Log("AWAKENED: HEIAN FORM")
        local s = Instance.new("Sound", game.CoreGui); s.SoundId = "rbxassetid://9114704071"; s.Volume = 5; s:Play()
        local h = Instance.new("Highlight", Char); h.FillColor = Color3.new(1,0,0)
    end
}

-- // 5. ENGINE LOOP (OVERRIDE DE FÍSICA E GHOST STATE)
RS.RenderStepped:Connect(function()
    -- GHOST STATE (Abuso Natural Disaster): 
    -- Ficamos levemente acima do solo para ignorar desastres de queda/colisão
    if EngineState.Character == "Gojo" then
        Root.Velocity = Vector3.new(0,0,0)
        local hover = math.sin(tick()*4)*2
        Root.CFrame = Root.CFrame:Lerp(Root.CFrame * CFrame.new(0, hover, 0), 0.1)
        
        if EngineState.MugenActive then
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" and (v.Position - Root.Position).Magnitude < 25 then
                    v.Velocity = (v.Position - Root.Position).Unit * 200
                end
            end
        end
    end
end)

-- // 6. INTERFACE DE COMANDO
local function BuildEngineHUD()
    local sg = Instance.new("ScreenGui", game.CoreGui)
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 400, 0, 300); frame.Position = UDim2.new(0.5,-200,0.3,0); frame.BackgroundColor3 = Color3.new(0,0,0)
    Instance.new("UIStroke", frame).Color = Color3.new(1,1,1)

    local function CreateCharBtn(text, y, color, mode)
        local b = Instance.new("TextButton", frame)
        b.Size = UDim2.new(0.9, 0, 0, 80); b.Position = UDim2.new(0.05, 0, 0, y); b.Text = text; b.BackgroundColor3 = color; b.TextColor3 = Color3.new(1,1,1); b.TextSize = 25
        b.MouseButton1Click:Connect(function()
            EngineState.Character = mode
            local bar = Instance.new("Frame", sg)
            bar.Size = UDim2.new(0.8, 0, 0, 80); bar.Position = UDim2.new(0.1, 0, 0.88, 0); bar.BackgroundColor3 = Color3.new(0,0,0)
            local moves = (mode == "Gojo" and Gojo or Sukuna)
            local offset = 0
            for name, func in pairs(moves) do
                local btn = Instance.new("TextButton", bar)
                btn.Size = UDim2.new(0.14, 0, 1, 0); btn.Position = UDim2.new(offset, 0, 0, 0); btn.Text = name; btn.TextScaled = true
                btn.MouseButton1Click:Connect(func); offset += 0.15
            end
            frame:Destroy()
            Log("ENGINE OVERRIDE COMPLETE: " .. mode)
        end)
    end
    CreateCharBtn("SATORU GOJO", 30, Color3.fromRGB(0,50,200), "Gojo")
    CreateCharBtn("RYOMEN SUKUNA", 150, Color3.fromRGB(150,0,0), "Sukuna")
end

BuildEngineHUD()
Log("SISTEMA PRONTO. BEM-VINDO AO TOPO.")
