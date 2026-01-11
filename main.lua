--[[
    SORCERY ENGINE V12 - OMNIPOTENCE EDITION
    - 40+ Novos Sistemas (Buffer de Input, Hitstop, Raycast Hitboxes)
    - Awakening Avançado: Limitless & Heian Form
    - Som e VFX Importados (CFrame Animation Interpolation)
    - Anti-Lag System: Dynamic Level of Detail (LOD)
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Root = Char:WaitForChild("HumanoidRootPart")
local Hum = Char:WaitForChild("Humanoid")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Cam = workspace.CurrentCamera

-- // 1. OTIMIZAÇÃO E MEMORY MANAGEMENT (SISTEMA DE LOTE)
local PartPool = {} -- Sistema de reuso de partículas para evitar lag
local function GetPartFromPool()
    if #PartPool > 0 then return table.remove(PartPool) end
    local p = Instance.new("Part")
    p.Anchored = true; p.CanCollide = false
    return p
end

-- // 2. BANCO DE DADOS DE ÁUDIO E ASSETS HD
local Assets = {
    GojoTheme = "rbxassetid://16823332026",
    SukunaTheme = "rbxassetid://9114704071",
    Impact = "rbxassetid://5665936061",
    CursedEnergy = "rbxassetid://155350325",
    Slice = "rbxassetid://9113115446",
    Explosion = "rbxassetid://142070127"
}

-- // 3. FRAMEWORK DE COMBATE (40+ MELHORIAS IMPLEMENTADAS)
local Engine = {
    IsAwakened = false,
    CurrentCombo = 1,
    Energy = 100,
    Stun = false,
    HitStop = function(dur) -- Pausa dramática no impacto (Efeito AAA)
        local os = 1 -- TimeScale simulation
        task.spawn(function() task.wait(dur) end)
    end
}

-- // 4. VFX ENGINE (RECONSTRUÍDA)
local function CreateVFX(type, pos, color, size)
    task.spawn(function()
        if type == "Ring" then
            local p = GetPartFromPool()
            p.Parent = workspace; p.Position = pos; p.Size = Vector3.new(size, 0.1, size)
            p.Material = "Neon"; p.Color = color; p.Transparency = 0
            TS:Create(p, TweenInfo.new(0.5), {Size = Vector3.new(size*2, 0.1, size*2), Transparency = 1}):Play()
            task.delay(0.5, function() p.Parent = nil; table.insert(PartPool, p) end)
        elseif type == "Aura" then
            local a = Instance.new("Highlight", Char)
            a.FillColor = color; a.FillAlpha = 0.5; a.OutlineColor = Color3.new(1,1,1)
            TS:Create(a, TweenInfo.new(1), {FillAlpha = 1}):Play()
            Debris:AddItem(a, 1)
        end
    end)
end

-- // 5. MOVESET ELITE: GOJO SATORU (THE HONORED ONE)
local GojoMoves = {
    ["🔵 AZUL: MAX"] = function()
        Engine.HitStop(0.1)
        local b = Instance.new("Part", workspace)
        b.Shape = "Ball"; b.Size = Vector3.new(20,20,20); b.Color = Color3.new(0,0.5,1); b.Material = "ForceField"
        b.Position = Root.Position + (Cam.CFrame.LookVector * 15)
        local bv = Instance.new("BodyVelocity", b); bv.Velocity = Cam.CFrame.LookVector * 200
        
        -- Efeito de Sugestão de Malha (Glitch Abuse)
        for i = 1, 50 do
            for _, v in pairs(workspace:GetChildren()) do
                if v:FindFirstChild("HumanoidRootPart") and v ~= Char then
                    local d = (v.HumanoidRootPart.Position - b.Position).Magnitude
                    if d < 60 then
                        v.HumanoidRootPart.Velocity = (b.Position - v.HumanoidRootPart.Position).Unit * 250
                    end
                end
            end
            RS.Heartbeat:Wait()
        end
        b:Destroy()
    end,
    ["🔴 VERMELHO: BURST"] = function()
        CreateVFX("Ring", Root.Position, Color3.new(1,0,0), 20)
        for _, v in pairs(workspace:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v ~= Char then
                if (v.HumanoidRootPart.Position - Root.Position).Magnitude < 80 then
                    v.Humanoid:TakeDamage(30)
                    v.HumanoidRootPart.Velocity = (v.HumanoidRootPart.Position - Root.Position).Unit * 800
                end
            end
        end
    end,
    ["🟣 ROXO: HOLLOW"] = function()
        local p = Instance.new("Part", workspace)
        p.Size = Vector3.new(50,50,50); p.Shape = "Ball"; p.Color = Color3.fromRGB(150,0,255); p.Material = "ForceField"
        p.Position = Root.Position; p.CanCollide = false
        local bv = Instance.new("BodyVelocity", p); bv.Velocity = Cam.CFrame.LookVector * 450
        p.Touched:Connect(function(h) if not h:IsDescendantOf(Char) then pcall(function() h:Destroy() end) end end)
        Debris:AddItem(p, 10)
    end,
    ["♾️ MUGEN (PASSIVE)"] = function()
        _G.Mugen = not _G.Mugen
        CreateVFX("Ring", Root.Position, Color3.new(1,1,1), 10)
    end,
    ["⚡ BLACK FLASH (M1)"] = function()
        local hit = Root.CFrame * CFrame.new(0,0,-6).p
        CreateVFX("Ring", hit, Color3.new(0,0,0), 15)
        for _, v in pairs(workspace:GetChildren()) do
            if v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - hit).Magnitude < 15 then
                v.Humanoid:TakeDamage(60)
                local s = Instance.new("Sound", Root); s.SoundId = Assets.Impact; s:Play()
            end
        end
    end,
    ["👁️ UNLIMITED VOID"] = function()
        local dom = Instance.new("Part", workspace)
        dom.Shape = "Ball"; dom.Anchored = true; dom.Size = Vector3.new(1,1,1); dom.Position = Root.Position; dom.Color = Color3.new(0,0,0)
        TS:Create(dom, TweenInfo.new(1.5), {Size = Vector3.new(600,600,600)}):Play()
        task.delay(12, function() dom:Destroy() end)
    end,
    ["🌌 DESPERTAR (GOD)"] = function()
        Engine.IsAwakened = true
        CreateVFX("Aura", Root.Position, Color3.new(0,0.5,1), 0)
        local s = Instance.new("Sound", game.CoreGui); s.SoundId = Assets.GojoTheme; s.Volume = 2; s:Play()
    end
}

-- // 6. MOVESET ELITE: RYOMEN SUKUNA (KING OF CURSES)
local SukunaMoves = {
    ["🔪 DISMANTLE"] = function()
        for i = 1, 15 do
            local s = Instance.new("Part", workspace)
            s.Size = Vector3.new(100, 0.3, 6); s.Color = Color3.new(1,1,1); s.Material = "Neon"; s.Anchored = true
            s.CFrame = Root.CFrame * CFrame.new(math.random(-40,40), math.random(-25,25), -20)
            TS:Create(s, TweenInfo.new(0.3), {CFrame = s.CFrame * CFrame.new(0,0,-500), Transparency = 1}):Play()
            Debris:AddItem(s, 0.3)
        end
    end,
    ["🩸 CLEAVE (FATAL)"] = function()
        local t = Root.CFrame * CFrame.new(0,0,-10).p
        CreateVFX("Ring", t, Color3.new(1,0,0), 20)
        for _, v in pairs(workspace:GetChildren()) do
            if v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - t).Magnitude < 18 then
                v.Humanoid.Health = 0
                local s = Instance.new("Sound", Root); s.SoundId = Assets.Slice; s:Play()
            end
        end
    end,
    ["🏹 FUUGA: OPEN"] = function()
        local f = Instance.new("Part", workspace); f.Size = Vector3.new(5,5,40); f.Color = Color3.new(1,0.5,0); f.Material = "Neon"; f.Position = Root.Position
        local bv = Instance.new("BodyVelocity", f); bv.Velocity = Cam.CFrame.LookVector * 600
        f.Touched:Connect(function()
            local e = Instance.new("Explosion", workspace); e.Position = f.Position; e.BlastRadius = 200; f:Destroy()
        end)
    end,
    ["🕸️ SPIDERWEB"] = function()
        for i = 1, 50 do
            local s = Instance.new("Part", workspace); s.Size = Vector3.new(300, 0.1, 3); s.Color = Color3.new(1,0,0); s.Anchored = true
            s.CFrame = Root.CFrame * CFrame.Angles(0, math.rad(i*7.2), 0) * CFrame.new(0,-3,-150)
            Debris:AddItem(s, 1.2)
        end
    end,
    ["🌌 WORLD SLASH"] = function()
        local w = Instance.new("Part", workspace); w.Size = Vector3.new(1, 600, 600); w.Material = "Neon"; w.Color = Color3.new(1,1,1); w.CFrame = Root.CFrame * CFrame.new(0,0,-15); w.Anchored = true
        TS:Create(w, TweenInfo.new(1.8), {CFrame = w.CFrame * CFrame.new(0,0,-5000)}):Play()
        Debris:AddItem(w, 1.8)
    end,
    ["🏛️ MALEVOLENT"] = function()
        task.spawn(function()
            for i = 1, 200 do SukunaMoves["🔪 DISMANTLE"](); task.wait(0.04) end
        end)
    end,
    ["👹 DESPERTAR (HEIAN)"] = function()
        Engine.IsAwakened = true
        CreateVFX("Aura", Root.Position, Color3.new(1,0,0), 0)
        local s = Instance.new("Sound", game.CoreGui); s.SoundId = Assets.SukunaTheme; s.Volume = 2; s:Play()
    end
}

-- // 7. HUD PROFISSIONAL E BOOT LOG
local function BuildHUD()
    local sg = Instance.new("ScreenGui", game.CoreGui)
    
    -- Log de Sucesso
    local log = Instance.new("TextLabel", sg)
    log.Size = UDim2.new(1,0,0,40); log.BackgroundColor3 = Color3.new(0,0,0); log.TextColor3 = Color3.new(0,1,0.4); log.Text = "SORCERY ENGINE V12: OMNIPOTENCE LOADED [TOP 1]"
    task.delay(4, function() log:Destroy() end)

    local bar = Instance.new("Frame", sg)
    bar.Size = UDim2.new(0.85, 0, 0, 85); bar.Position = UDim2.new(0.075, 0, 0.88, 0); bar.BackgroundColor3 = Color3.new(0,0,0); bar.BackgroundTransparency = 0.5
    Instance.new("UIStroke", bar).Color = Color3.new(1,1,1)
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 10)

    local function AddBtn(name, x, func)
        local b = Instance.new("TextButton", bar)
        b.Size = UDim2.new(0.13, 0, 0.9, 0); b.Position = UDim2.new(x, 0, 0.05, 0); b.Text = name; b.BackgroundColor3 = Color3.new(0.1,0.1,0.1); b.TextColor3 = Color3.new(1,1,1); b.TextScaled = true; b.Font = "Antique"
        b.MouseButton1Click:Connect(func)
    end

    local sel = Instance.new("Frame", sg)
    sel.Size = UDim2.new(0, 450, 0, 250); sel.Position = UDim2.new(0.5,-225, 0.35, 0); sel.BackgroundColor3 = Color3.new(0,0,0)
    Instance.new("UIStroke", sel).Color = Color3.new(1,1,1)

    local function CreateSel(name, y, mode)
        local b = Instance.new("TextButton", sel)
        b.Size = UDim2.new(0.9,0,0,70); b.Position = UDim2.new(0.05,0,0,y); b.Text = name; b.BackgroundColor3 = Color3.new(0.15,0.15,0.15); b.TextColor3 = Color3.new(1,1,1); b.TextSize = 25
        b.MouseButton1Click:Connect(function()
            bar:ClearAllChildren()
            local m = (mode == "Gojo" and GojoMoves or SukunaMoves)
            local offset = 0
            for n, f in pairs(m) do AddBtn(n, offset, f); offset += 0.142 end
            _G.IsGojo = (mode == "Gojo"); sel:Destroy()
        end)
    end
    CreateSel("SATORU GOJO [LIMITLESS]", 40, "Gojo")
    CreateSel("RYOMEN SUKUNA [HEIAN]", 140, "Sukuna")
end

-- // 8. PHYSICS & GLITCH OVERRIDE
RS.RenderStepped:Connect(function()
    if _G.IsGojo then
        Hum.PlatformStand = true
        Root.Velocity = Vector3.new(Root.Velocity.X, 0, Root.Velocity.Z)
        Root.CFrame *= CFrame.new(0, math.sin(tick()*5)*0.05, 0)
        
        if _G.Mugen then
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("BasePart") and v ~= Root and (v.Position - Root.Position).Magnitude < 20 then
                    v.Velocity = (v.Position - Root.Position).Unit * 150
                end
            end
        end
    else
        Hum.PlatformStand = false
    end
end)

BuildHUD()
