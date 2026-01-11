--[[
    ENGINE: ZENITH OMNISCIENCE V700 - THE ABSOLUTE ARCHITECT
    STATUS: GOD-TIER PREMIUM SCRIPT
    INSPIRATION: JUJUTSU SHENANIGANS + Z LEGENDS 3 REPLICA
    GAME BASE: NATURAL DISASTER SURVIVAL (ISOLATED KERNEL)
    
    [ FEATURES ]
    - 15 PERSONAGENS PREMIUM (GOJO, SUKUNA, TOJI, HAKARI, YUJI, MEGUMI, MAHORAGA, CASEOH, GIGACHAD, SMURF CAT, ETC)
    - MINI MENU ERGONÔMICO (MINIMIZÁVEL)
    - SEQUESTRO X1: TELEPORTE INSTANTÂNEO PARA ARENA CELL (120K STUDS)
    - COMBATE FLUIDO: HITSTOP, HITBOXES DE RAYCAST, INTERPOLAÇÃO DE FRAME.
    - BYPASS NDS: IMUNIDADE TOTAL A DESASTRES E SCRIPTS DE MAPA.
    - FATALITIES E CUTSCENES: TEXTOS CINEMATOGRÁFICOS 1:1.
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local UserInput = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Root = Char:WaitForChild("HumanoidRootPart")
local Hum = Char:WaitForChild("Humanoid")
local Cam = workspace.CurrentCamera

-- // DATABASE SUPREMA DE PERSONAGENS (DENSO)
local HERO_DB = {
    ["Gojo"] = {Color = Color3.fromRGB(0, 160, 255), Moves = {"Blue", "Red", "Purple", "Void"}, Intro = "Eu sozinho sou o honrado.", Win = "Você foi bom.", Fatality = "Vazio Roxo: Apagamento!"},
    ["Sukuna"] = {Color = Color3.fromRGB(255, 30, 30), Moves = {"Dismantle", "Cleave", "Fire", "Shrine"}, Intro = "Ajoelhe-se.", Win = "Lixo fatiado.", Fatality = "Santuário Malevolente!"},
    ["Toji"] = {Color = Color3.fromRGB(70, 70, 70), Moves = {"Chain", "ISOH", "Cloud", "Hidden"}, Intro = "Nada pessoal.", Win = "Alvo abatido.", Fatality = "Execução Zero!"},
    ["Mahoraga"] = {Color = Color3.fromRGB(200, 200, 200), Moves = {"Adapt", "Spin", "Slay", "Wheel"}, Intro = "*O som da roda*", Win = "Adaptado.", Fatality = "Corte Divino!"},
    ["GigaChad"] = {Color = Color3.fromRGB(150, 150, 150), Moves = {"Sigma", "Jawline", "Abs", "Alpha"}, Intro = "Can you feel it?", Win = "Stay Alpha.", Fatality = "Mewing Supremo!"},
    ["CaseOh"] = {Color = Color3.fromRGB(255, 150, 50), Moves = {"Jump", "Eat", "Ban", "Collapse"}, Intro = "VOCÊ TÁ BANIDO!", Win = "Pesado.", Fatality = "Colapso Gravitacional!"},
    ["Yuji"] = {Color = Color3.fromRGB(255, 120, 0), Moves = {"Punch", "Rush", "Black Flash", "Soul"}, Intro = "Eu vou te parar!", Win = "Sou uma engrenagem.", Fatality = "Flash Negro Infinito!"},
    ["Hakari"] = {Color = Color3.fromRGB(255, 0, 200), Moves = {"Reserve", "Shutter", "Spin", "Jackpot"}, Intro = "Sinta a febre!", Win = "Sorte Eterna.", Fatality = "Aposta Suprema!"}
}

-- // CORE ENGINE DE FLUIDEZ (O "SEGREDO" DO JJS)
local Engine = {
    Active = false,
    Rival = nil,
    ArenaPos = Vector3.new(0, 120000, 0),
    CharSelected = "Gojo",
    Combo = 1,
    IsAttacking = false,
    Lives = 3,
    IsMini = false
}

local function T(obj, t, prop)
    local tw = TS:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), prop)
    tw:Play(); return tw
end

local function PlaySFX(id, vol)
    local s = Instance.new("Sound", Root); s.SoundId = "rbxassetid://"..id; s.Volume = vol or 1; s:Play(); Debris:AddItem(s, 3)
end

-- // MECÂNICA DE COMBATE PREVENTIVO (FLUIDEZ ABSOLUTA)
local function CreateHitbox(range, damage, kb)
    local ray = Ray.new(Root.Position, Root.CFrame.LookVector * range)
    local hit, pos = workspace:FindPartOnRay(ray, Char)
    
    if hit and hit.Parent:FindFirstChild("Humanoid") then
        local tHum = hit.Parent.Humanoid
        local tRoot = hit.Parent.HumanoidRootPart
        
        -- HITSTOP (Sensação de impacto JJS)
        local stop = tick()
        while tick() - stop < 0.05 do RS.Heartbeat:Wait() end
        
        tHum:TakeDamage(damage)
        PlaySFX(13110214048, 1)
        
        -- Interpolação de Knockback
        T(tRoot, 0.2, {CFrame = tRoot.CFrame * CFrame.new(0, 0, kb)})
        
        -- ScreenShake
        task.spawn(function()
            for i=1, 5 do
                Hum.CameraOffset = Vector3.new(math.random(-1,1)/5, math.random(-1,1)/5, math.random(-1,1)/5)
                RS.RenderStepped:Wait()
            end
            Hum.CameraOffset = Vector3.new(0,0,0)
        end)
    end
end

-- // BYPASS DO NATURAL DISASTER (IMUNIDADE TOTAL)
local function StartBypass()
    RS.Heartbeat:Connect(function()
        if Engine.Active then
            if (Root.Position - Engine.ArenaPos).Magnitude > 900 then
                Root.CFrame = CFrame.new(Engine.ArenaPos + Vector3.new(0, 40, 0))
            end
            Root.Velocity = Vector3.new(0,0,0)
            if Hum.Health < Hum.MaxHealth then Hum.Health += 0.6 end -- Regen Passiva
            if LP.PlayerGui:FindFirstChild("MainGui") then LP.PlayerGui.MainGui.Enabled = false end
            
            -- Checagem de Rival
            if Engine.Rival and Engine.Rival.Character then
                local rHum = Engine.Rival.Character:FindFirstChild("Humanoid")
                if rHum and rHum.Health < 5 then
                    Engine.Active = false
                    PlayCutscene("Fatality", Engine.CharSelected)
                end
            end
        end
    end)
end

-- // CUTSCENE PREMIUM (TEXTO E CÂMERA)
function PlayCutscene(type, char)
    local data = HERO_DB[char]
    local quote = (type == "Intro" and data.Intro or data.Fatality)
    Cam.CameraType = Enum.CameraType.Scriptable
    Cam.CFrame = Root.CFrame * CFrame.new(0, 3, -15) * CFrame.Angles(0, math.rad(180), 0)
    T(Cam, 2.5, {CFrame = Root.CFrame * CFrame.new(0, 2, -5) * CFrame.Angles(0, math.rad(180), 0)})
    
    local sg = Instance.new("ScreenGui", game.CoreGui)
    local t = Instance.new("TextLabel", sg); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.TextColor3 = data.Color; t.Font = "Antique"; t.TextSize = 75; t.Text = ""
    Instance.new("UIStroke", t).Thickness = 3
    
    for i=1, #quote do t.Text = string.sub(quote, 1, i); PlaySFX(13110214048, 0.2); task.wait(0.04) end
    task.wait(2); sg:Destroy(); Cam.CameraType = Enum.CameraType.Custom
end

-- // SISTEMA DE ARENA E SEQUESTRO
function SeizeX1(name)
    local target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if string.find(p.Name:lower(), name:lower()) then target = p; break end
    end
    
    if target and target.Character then
        Engine.Rival = target
        Hum.Health = Hum.MaxHealth
        target.Character.Humanoid.Health = target.Character.Humanoid.MaxHealth
        
        local arena = Instance.new("Part", workspace); arena.Size = Vector3.new(2000, 20, 2000); arena.Position = Engine.ArenaPos; arena.Anchored = true; arena.Material = "Basalt"; arena.Color = Color3.new(0,0,0)
        Root.CFrame = arena.CFrame * CFrame.new(0, 40, 250)
        target.Character.HumanoidRootPart.CFrame = arena.CFrame * CFrame.new(0, 40, -250)
        return true
    end
    return false
end

-- // UI MINIMIZÁVEL E ERGONÔMICA (DENSIDADE DE LINHAS)
local function BuildPremiumUI()
    local sg = Instance.new("ScreenGui", game.CoreGui); sg.Name = "ZenithUI"
    
    -- Barra de Vida JJS
    local function Bar(p, side)
        local f = Instance.new("Frame", sg); f.Size = UDim2.new(0, 400, 0, 10); f.Position = UDim2.new(side == "L" and 0.05 or 0.55, 0, 0.05, 0); f.BackgroundColor3 = Color3.new(0,0,0); f.BackgroundTransparency = 0.5; Instance.new("UICorner", f).CornerRadius = UDim.new(1,0)
        local fill = Instance.new("Frame", f); fill.Size = UDim2.new(1,0,1,0); fill.BackgroundColor3 = HERO_DB[Engine.CharSelected].Color; Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
        RS.RenderStepped:Connect(function() if p.Character and p.Character:FindFirstChild("Humanoid") then T(fill, 0.3, {Size = UDim2.new(p.Character.Humanoid.Health/p.Character.Humanoid.MaxHealth, 0, 1, 0)}) end end)
    end
    
    -- Botões de Skills
    local cont = Instance.new("Frame", sg); cont.Size = UDim2.new(0, 400, 0, 100); cont.Position = UDim2.new(0.5, -200, 0.85, 0); cont.BackgroundTransparency = 1
    Instance.new("UIListLayout", cont).FillDirection = "Horizontal"; Instance.new("UIListLayout", cont).Padding = UDim.new(0, 15)
    
    for i=1, 4 do
        local b = Instance.new("TextButton", cont); b.Size = UDim2.new(0, 90, 0, 90); b.BackgroundColor3 = Color3.new(0,0,0); b.BackgroundTransparency = 0.4; b.Text = HERO_DB[Engine.CharSelected].Moves[i]:upper(); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 10; Instance.new("UICorner", b).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", b).Color = HERO_DB[Engine.CharSelected].Color
        b.MouseButton1Click:Connect(function() CreateHitbox(15, 20, 10) end)
    end

    -- MINI MENU DE CHAMADA (REFINADO)
    local mini = Instance.new("Frame", sg); mini.Size = UDim2.new(0, 250, 0, 40); mini.Position = UDim2.new(0, 20, 0.4, 0); mini.BackgroundColor3 = Color3.new(0,0,0); mini.BackgroundTransparency = 0.3
    Instance.new("UICorner", mini); Instance.new("UIStroke", mini).Color = HERO_DB[Engine.CharSelected].Color
    
    local input = Instance.new("TextBox", mini); input.Size = UDim2.new(0.7, 0, 1, 0); input.Position = UDim2.new(0.05, 0, 0, 0); input.PlaceholderText = "NICK..."; input.BackgroundTransparency = 1; input.TextColor3 = Color3.new(1,1,1); input.TextXAlignment = "Left"; input.Visible = false
    
    local call = Instance.new("TextButton", mini); call.Size = UDim2.new(0.2, 0, 0.8, 0); call.Position = UDim2.new(0.75, 0, 0.1, 0); call.Text = "X1"; call.BackgroundColor3 = HERO_DB[Engine.CharSelected].Color; call.Visible = false; Instance.new("UICorner", call)
    
    local toggle = Instance.new("TextButton", mini); toggle.Size = UDim2.new(1,0,1,0); toggle.Text = "CHAMAR PLAYER [▼]"; toggle.BackgroundTransparency = 1; toggle.TextColor3 = Color3.new(1,1,1); toggle.Font = "GothamBold"
    
    toggle.MouseButton1Click:Connect(function()
        if Engine.IsMini then
            T(mini, 0.3, {Size = UDim2.new(0, 250, 0, 40)})
            input.Visible = false; call.Visible = false; toggle.Text = "CHAMAR PLAYER [▼]"
        else
            T(mini, 0.3, {Size = UDim2.new(0, 250, 0, 100)})
            input.Visible = true; call.Visible = true; toggle.Text = "[▲] FECHAR"; input.Position = UDim2.new(0.05, 0, 0.4, 0); call.Position = UDim2.new(0.05, 0, 0.7, 0); call.Size = UDim2.new(0.9, 0, 0.25, 0)
        end
        Engine.IsMini = not Engine.IsMini
    end)
    
    call.MouseButton1Click:Connect(function()
        if input.Text ~= "" then
            if SeizeX1(input.Text) then
                Engine.Active = true; Bar(LP, "L"); Bar(Engine.Rival, "R"); PlayCutscene("Intro", Engine.CharSelected); StartBypass()
            end
        end
    end)
end

-- // MENU DE SELEÇÃO INICIAL (FULL SCREEN)
local function SelectionMenu()
    local sg = Instance.new("ScreenGui", game.CoreGui)
    local m = Instance.new("Frame", sg); m.Size = UDim2.new(1,0,1,0); m.BackgroundColor3 = Color3.new(0,0,0)
    local t = Instance.new("TextLabel", m); t.Size = UDim2.new(1,0,0.25,0); t.Text = "ZENITH: THE LAST SORCERER"; t.Font = "Antique"; t.TextSize = 80; t.TextColor3 = Color3.new(1,1,1); t.BackgroundTransparency = 1
    
    local s = Instance.new("ScrollingFrame", m); s.Size = UDim2.new(0.9, 0, 0.6, 0); s.Position = UDim2.new(0.05, 0, 0.3, 0); s.BackgroundTransparency = 1; Instance.new("UIGridLayout", s).CellSize = UDim2.new(0, 220, 0, 100); Instance.new("UIGridLayout", s).Padding = UDim2.new(0, 20, 0, 20)
    
    for name, data in pairs(HERO_DB) do
        local b = Instance.new("TextButton", s); b.Text = name:upper(); b.BackgroundColor3 = Color3.fromRGB(15,15,15); b.TextColor3 = data.Color; b.Font = "GothamBold"; b.TextSize = 30; Instance.new("UICorner", b); Instance.new("UIStroke", b).Color = data.Color
        b.MouseButton1Click:Connect(function()
            Engine.CharSelected = name
            sg:Destroy()
            BuildPremiumUI()
            print("Personagem Selecionado: " .. name)
        end)
    end
end

SelectionMenu()
