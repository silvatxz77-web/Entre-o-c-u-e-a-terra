--[[
    ZENITH OMNI-ARCHITECT V12 (FINAL REFINEMENT)
    Especialista em Delta Mobile - Performance Estável
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- Proteção de Inicialização
local Char = LP.Character or LP.CharacterAdded:Wait()
local Root = Char:WaitForChild("HumanoidRootPart")
local Hum = Char:WaitForChild("Humanoid")

-- // DATABASE PREMIUM (10 PERSONAGENS REFINADOS)
local DB = {
    ["Gojo Satoru"] = {Col = Color3.fromRGB(0, 160, 255), Skills = {"Azul", "Vermelho", "Roxo", "Vazio"}},
    ["Sukuna"] = {Col = Color3.fromRGB(255, 30, 30), Skills = {"Corte", "Clivar", "Fogo", "Santuário"}},
    ["Toji"] = {Col = Color3.fromRGB(80, 80, 80), Skills = {"Corrente", "ISOH", "Nuvem", "Killer"}},
    ["Mahoraga"] = {Col = Color3.fromRGB(240, 240, 240), Skills = {"Girar", "Cortar", "Adaptar", "Roda"}},
    ["Hakari"] = {Col = Color3.fromRGB(255, 0, 180), Skills = {"Bola", "Trava", "Giro", "Jackpot"}},
    ["CaseOh"] = {Col = Color3.fromRGB(255, 140, 50), Skills = {"Lanche", "Pulo", "Lego", "Ban"}},
    ["GigaChad"] = {Col = Color3.fromRGB(150, 150, 150), Skills = {"Olhar", "Mandíbula", "Pose", "Alpha"}},
    ["Smurf Cat"] = {Col = Color3.fromRGB(0, 120, 255), Skills = {"Live", "Love", "Lie", "Mushroom"}},
    ["Skibidi"] = {Col = Color3.fromRGB(130, 130, 130), Skills = {"Flush", "Bop", "Dop", "Laser"}},
    ["Peter Griffin"] = {Col = Color3.fromRGB(0, 255, 100), Skills = {"Frango", "Soco", "Cerveja", "Risada"}}
}

local State = {Active = false, Char = "Gojo Satoru", G_Meter = 0, ArenaPos = Vector3.new(0, 900000, 0)}

-- // FUNÇÃO DE TWEEN RÁPIDA
local function Move(obj, prop, t)
    TS:Create(obj, TweenInfo.new(t or 0.3, Enum.EasingStyle.Quart), prop):Play()
end

-- // HUD ESTILO SHENANIGANS (TRANSPARENTE E CONFORTÁVEL)
local function BuildHUD(charName)
    local data = DB[charName]
    local sg = Instance.new("ScreenGui", game.CoreGui)
    
    -- Barra de Vida Superior (Slim)
    local hf = Instance.new("Frame", sg); hf.Size = UDim2.new(0, 400, 0, 6); hf.Position = UDim2.new(0.5, -200, 0.05, 0); hf.BackgroundColor3 = Color3.new(0,0,0); hf.BackgroundTransparency = 0.6
    local fill = Instance.new("Frame", hf); fill.Size = UDim2.new(1,0,1,0); fill.BackgroundColor3 = data.Col; Instance.new("UICorner", fill)
    RS.RenderStepped:Connect(function() fill.Size = UDim2.new(Hum.Health/Hum.MaxHealth, 0, 1, 0) end)

    -- Container de Skills (Botões Transparentes)
    local sc = Instance.new("Frame", sg); sc.Size = UDim2.new(0, 400, 0, 90); sc.Position = UDim2.new(0.5, -200, 0.85, 0); sc.BackgroundTransparency = 1
    local layout = Instance.new("UIListLayout", sc); layout.FillDirection = "Horizontal"; layout.Padding = UDim.new(0, 10); layout.HorizontalAlignment = "Center"

    for i=1, 4 do
        local b = Instance.new("TextButton", sc); b.Size = UDim2.new(0, 80, 0, 80); b.BackgroundColor3 = Color3.new(0,0,0); b.BackgroundTransparency = 0.7; b.Text = data.Skills[i]; b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"; b.TextSize = 10; Instance.new("UICorner", b, {CornerRadius = UDim.new(1,0)})
        local stroke = Instance.new("UIStroke", b); stroke.Color = data.Col; stroke.Thickness = 1.5
    end

    -- Menu de Chamada (Mini e Confortável)
    local mini = Instance.new("Frame", sg); mini.Size = UDim2.new(0, 160, 0, 30); mini.Position = UDim2.new(0, 20, 0.45, 0); mini.BackgroundColor3 = Color3.new(0,0,0); mini.BackgroundTransparency = 0.6; Instance.new("UICorner", mini)
    local toggle = Instance.new("TextButton", mini); toggle.Size = UDim2.new(1,0,1,0); toggle.Text = "X1 MENU [V]"; toggle.TextColor3 = Color3.new(1,1,1); toggle.BackgroundTransparency = 1; toggle.Font = "Gotham"
    
    local content = Instance.new("Frame", mini); content.Size = UDim2.new(1,0,0,80); content.Position = UDim2.new(0,0,1,5); content.Visible = false; content.BackgroundTransparency = 1
    local inp = Instance.new("TextBox", content); inp.Size = UDim2.new(1,0,0.5,0); inp.PlaceholderText = "NICK..."; inp.BackgroundColor3 = Color3.new(0,0,0); inp.BackgroundTransparency = 0.5; inp.TextColor3 = Color3.new(1,1,1)
    local go = Instance.new("TextButton", content); go.Size = UDim2.new(1,0,0.4,0); go.Position = UDim2.new(0,0,0.6,0); go.Text = "PULL PLAYER"; go.BackgroundColor3 = data.Col; go.TextColor3 = Color3.new(1,1,1)

    toggle.MouseButton1Click:Connect(function()
        content.Visible = not content.Visible
        toggle.Text = content.Visible and "CLOSE [^]" or "X1 MENU [V]"
    end)
    
    go.MouseButton1Click:Connect(function()
        local target = nil
        for _, p in pairs(Players:GetPlayers()) do if string.find(p.Name:lower(), inp.Text:lower()) then target = p break end end
        if target and target.Character then
            State.Active = true
            Root.CFrame = CFrame.new(State.ArenaPos + Vector3.new(0,50,0))
            target.Character.HumanoidRootPart.CFrame = CFrame.new(State.ArenaPos + Vector3.new(0,50,10))
            -- Bypass Anti-Morte NDS
            task.spawn(function()
                while State.Active do
                    Root.Velocity = Vector3.new(0,0,0)
                    if (Root.Position - State.ArenaPos).Magnitude > 1000 then Root.CFrame = CFrame.new(State.ArenaPos) end
                    RS.Heartbeat:Wait()
                end
            end)
        end
    end)
end

-- // SELECIONADOR INICIAL (SIMPLICIDADE E CONFORTO)
local function CreateSelector()
    local sg = Instance.new("ScreenGui", game.CoreGui)
    local main = Instance.new("Frame", sg); main.Size = UDim2.new(1,0,1,0); main.BackgroundColor3 = Color3.new(0,0,0)
    local title = Instance.new("TextLabel", main); title.Size = UDim2.new(1,0,0.2,0); title.Text = "ZENITH FINAL"; title.Font = "Antique"; title.TextSize = 60; title.TextColor3 = Color3.new(1,1,1); title.BackgroundTransparency = 1
    
    local scroll = Instance.new("ScrollingFrame", main); scroll.Size = UDim2.new(0.9,0,0.7,0); scroll.Position = UDim2.new(0.05,0,0.25,0); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0,0,2,0)
    local grid = Instance.new("UIGridLayout", scroll); grid.CellSize = UDim2.new(0, 180, 0, 70); grid.Padding = UDim2.new(0,10,0,10)

    for name, data in pairs(DB) do
        local b = Instance.new("TextButton", scroll); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(20,20,20); b.TextColor3 = data.Col; b.Font = "GothamBold"; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            State.Char = name
            sg:Destroy()
            BuildHUD(name)
        end)
    end
end

-- Execução Imediata
CreateSelector()
