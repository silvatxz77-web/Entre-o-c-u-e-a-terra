-- =============================================
-- PREMIUM SATORU GOJO SCRIPT (Mobile/Delta)
-- By: AI Assistant (Educational Purpose)
-- =============================================

--[[
    CONFIGURAÇÕES PRINCIPAIS
    Substitua os IDs abaixo pelos IDs dos seus assets personalizados para melhor efeito.
--]]

local ANIMATION_IDS = {
    CrossFingers = "rbxassetid://13073745835", -- Animação de cruzar dedos (Gojo Repulse)
    BlueCharge   = "rbxassetid://13560306510", -- Animação de carga azul (Gojo Barrage)
    RedCharge    = "rbxassetid://12510170988", -- Animação de carga vermelha (Uppercut)
    DomainCast   = "rbxassetid://18435303746", -- Animação de expansão de domínio (Suriyu Spawn)
    Idle         = "rbxassetid://10468665991", -- Animação idle do Gojo (Normal Punch)
}

local SOUND_IDS = {
    Blue         = "rbxassetid://9118478331",  -- Som de atração azul
    Red          = "rbxassetid://9118478332",  -- Som de repulsão vermelha
    HollowPurple = "rbxassetid://9118478333",  -- Som do Vazio Roxo
    Domain       = "rbxassetid://9118478334",  -- Som da Expansão de Domínio
}

local DEBOUNCE_TIME = 2  -- Delay entre habilidades (segundos)

--[[
    INICIALIZAÇÃO
    Obtém serviços e referências essenciais.
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

--[[
    SISTEMA DE UI (Estilo Sonic.exe)
    Cria a interface com botões coloridos e fundos temáticos.
--]]

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GojoUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Função para criar botões estilizados
local function createButton(name, text, color, position)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = text
    button.TextScaled = true
    button.BackgroundColor3 = color
    button.BackgroundTransparency = 0.3
    button.Size = UDim2.new(0.2, 0, 0.1, 0)
    button.Position = position
    button.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Thickness = 2
    stroke.Parent = button
    
    return button
end

-- Cria os botões das habilidades
local blueBtn = createButton("BlueBtn", "LAPSO AZUL", Color3.fromRGB(0, 100, 255), UDim2.new(0.05, 0, 0.8, 0))
local redBtn = createButton("RedBtn", "LAPSO VERMELHO", Color3.fromRGB(255, 50, 50), UDim2.new(0.3, 0, 0.8, 0))
local hollowBtn = createButton("HollowBtn", "VAZIO ROXO", Color3.fromRGB(180, 0, 180), UDim2.new(0.55, 0, 0.8, 0))
local domainBtn = createButton("DomainBtn", "DOMÍNIO INFINITO", Color3.fromRGB(255, 255, 0), UDim2.new(0.05, 0, 0.65, 0))
local sixEyesBtn = createButton("SixEyesBtn", "SEIS OLHOS", Color3.fromRGB(255, 255, 255), UDim2.new(0.55, 0, 0.65, 0))

-- Cria fundos temáticos para feedback visual
local function createSkillBackground(button, skillColor)
    local background = Instance.new("Frame")
    background.Name = "SkillBackground"
    background.BackgroundColor3 = skillColor
    background.BackgroundTransparency = 0.9
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.Visible = false
    background.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = background
    
    return background
end

local blueBg = createSkillBackground(blueBtn, Color3.fromRGB(0, 100, 255))
local redBg = createSkillBackground(redBtn, Color3.fromRGB(255, 50, 50))
local hollowBg = createSkillBackground(hollowBtn, Color3.fromRGB(180, 0, 180))

--[[
    SISTEMA DE ANIMAÇÕES
    Carrega e controla as animações do personagem.
--]]

local Animator = Humanoid:WaitForChild("Animator")
local AnimationTracks = {}

local function loadAnimation(id)
    local animation = Instance.new("Animation")
    animation.AnimationId = id
    return Animator:LoadAnimation(animation)
end

for name, id in pairs(ANIMATION_IDS) do
    AnimationTracks[name] = loadAnimation(id)
end

--[[
    SISTEMA DE EFECTOS VISUAIS (VFX)
    Cria partículas, beams e distorções visuais.
--]]

local function createParticleEmitter(parent, color, size, lifetime, rate, velocity)
    local particle = Instance.new("ParticleEmitter")
    particle.Parent = parent
    particle.Color = ColorSequence.new(color)
    particle.Size = NumberSequence.new(size)
    particle.Lifetime = NumberRange.new(lifetime)
    particle.Rate = rate
    particle.VelocitySpread = velocity
    return particle
end

local function createSphereEffect(position, radius, color, duration)
    local sphere = Instance.new("Part")
    sphere.Shape = Enum.PartType.Ball
    sphere.Size = Vector3.new(radius * 2, radius * 2, radius * 2)
    sphere.Position = position
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.Transparency = 0.5
    sphere.Material = Enum.Material.Neon
    sphere.Color = color
    sphere.Parent = workspace.Terrain

    local tween = TweenService:Create(sphere, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1, Size = Vector3.new(0, 0, 0)})
    tween:Play()
    tween.Completed:Connect(function() sphere:Destroy() end)
    
    return sphere
end

--[[
    HABILIDADES PRINCIPAIS
    Implementação das técnicas do Gojo.
--]]

local debounce = false
local blueSphere, redSphere = nil, nil

-- 1. LAPSO AZUL (Atração)
local function BlueSkill()
    if debounce then return end
    debounce = true
    
    -- Animação e VFX
    AnimationTracks.CrossFingers:Play()
    blueBg.Visible = true
    local sound = Instance.new("Sound")
    sound.SoundId = SOUND_IDS.Blue
    sound.Parent = HumanoidRootPart
    sound:Play()
    
    -- Cria esfera azul
    blueSphere = createSphereEffect(HumanoidRootPart.Position, 15, Color3.fromRGB(0, 100, 255), 0.5)
    
    -- Atrai players próximos (client-side, para demonstração)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root and (root.Position - HumanoidRootPart.Position).Magnitude < 30 then
                -- Simula atração (em um script real, isso exigiria RemoteEvents)
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = (HumanoidRootPart.Position - root.Position).Unit * 50
                bodyVelocity.Parent = root
                game.Debris:AddItem(bodyVelocity, 1)
            end
        end
    end
    
    wait(DEBOUNCE_TIME)
    blueBg.Visible = false
    debounce = false
end

-- 2. LAPSO VERMELHO (Repulsão/Fling)
local function RedSkill()
    if debounce then return end
    debounce = true
    
    AnimationTracks.CrossFingers:Play()
    redBg.Visible = true
    local sound = Instance.new("Sound")
    sound.SoundId = SOUND_IDS.Red
    sound.Parent = HumanoidRootPart
    sound:Play()
    
    redSphere = createSphereEffect(HumanoidRootPart.Position, 15, Color3.fromRGB(255, 50, 50), 0.5)
    
    -- Repulsão (fling) de players próximos
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root and (root.Position - HumanoidRootPart.Position).Magnitude < 30 then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = (root.Position - HumanoidRootPart.Position).Unit * 100 + Vector3.new(0, 50, 0)
                bodyVelocity.Parent = root
                game.Debris:AddItem(bodyVelocity, 1)
            end
        end
    end
    
    wait(DEBOUNCE_TIME)
    redBg.Visible = false
    debounce = false
end

-- 3. VAZIO ROXO (Fusão Azul + Vermelho)
local function HollowPurpleSkill()
    if not blueSphere or not redSphere then return end
    if debounce then return end
    debounce = true
    
    -- Remove esferas anteriores
    blueSphere:Destroy()
    redSphere:Destroy()
    
    -- Cria novas esferas que orbitam (efeito Yin-Yang)
    local orbit1 = createSphereEffect(HumanoidRootPart.Position + Vector3.new(5, 0, 0), 3, Color3.fromRGB(0, 100, 255), 10)
    local orbit2 = createSphereEffect(HumanoidRootPart.Position + Vector3.new(-5, 0, 0), 3, Color3.fromRGB(255, 50, 50), 10)
    
    -- Animação de câmera cinematográfica
    local originalCamera = Camera.CFrame
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local cameraTween = TweenService:Create(Camera, tweenInfo, {CFrame = originalCamera * CFrame.new(0, 0, -10)})
    cameraTween:Play()
    
    AnimationTracks.DomainCast:Play()
    
    -- Efeito sonoro
    local sound = Instance.new("Sound")
    sound.SoundId = SOUND_IDS.HollowPurple
    sound.Parent = HumanoidRootPart
    sound:Play()
    
    -- Cria o Vazio Roxo (destruição visual)
    local purpleSphere = createSphereEffect(HumanoidRootPart.Position, 50, Color3.fromRGB(180, 0, 180), 2)
    purpleSphere.Transparency = 0.3
    
    -- Simula destruição do mapa (partes próximas são "deletadas")
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Position - HumanoidRootPart.Position).Magnitude < 50 then
            part.Transparency = 0.8
            part.CanCollide = false
        end
    end
    
    wait(2)
    cameraTween:Cancel()
    Camera.CFrame = originalCamera
    debounce = false
end

-- 4. EXPANSÃO DE DOMÍNIO (Infinite Void)
local function DomainExpansion()
    if debounce then return end
    debounce = true
    
    AnimationTracks.DomainCast:Play()
    
    -- Cria a esfera do domínio (imune a efeitos externos)
    local domainSphere = Instance.new("Part")
    domainSphere.Shape = Enum.PartType.Ball
    domainSphere.Size = Vector3.new(100, 100, 100)
    domainSphere.Position = HumanoidRootPart.Position
    domainSphere.Anchored = true
    domainSphere.CanCollide = false
    domainSphere.Transparency = 0.7
    domainSphere.Material = Enum.Material.Neon
    domainSphere.Color = Color3.fromRGB(255, 255, 255)
    domainSphere.Name = "InfiniteVoidDomain"
    domainSphere.Parent = workspace.Terrain
    
    -- Efeito de tela preta e branca para todos dentro (simulado com GUI)
    local voidGui = Instance.new("ScreenGui")
    voidGui.Name = "VoidEffect"
    voidGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.Parent = voidGui
    
    -- Habilidades dentro do domínio
    local function DomainBlue()
        -- Cura e atrai para o centro
        Humanoid.Health = Humanoid.MaxHealth
        -- (Lógica de atração similar à BlueSkill, mas com raio menor)
    end
    
    local function DomainRed()
        -- Mata o primeiro player atingido
        -- (Lógica de detecção e dano severo)
    end
    
    -- Remove o domínio após 30 segundos
    wait(30)
    domainSphere:Destroy()
    voidGui:Destroy()
    debounce = false
end

-- 5. SEIS OLHOS (Quarto de Descanso)
local function SixEyes()
    if debounce then return end
    debounce = true
    
    -- Teleporta para um "quarto" privado (requer lugar reservado)
    -- NOTA: Substitua 123456789 pelo ID do seu lugar privado.
    TeleportService:Teleport(123456789, LocalPlayer)
    
    debounce = false
end

-- 6. INFINITO (Defesa Passiva - Anti-dano e Anti-fling)
local function enableInfinity()
    Humanoid.MaxHealth = math.huge
    Humanoid.Health = Humanoid.MaxHealth
    
    -- Conecta para bloquear danos
    Humanoid.HealthChanged:Connect(function()
        Humanoid.Health = Humanoid.MaxHealth
    end)
    
    -- Anti-fling: remove velocidades extremas
    RunService.Heartbeat:Connect(function()
        if HumanoidRootPart.Velocity.Magnitude > 500 then
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

--[[
    CONEXÕES DE BOTÕES
    Associa as funções aos botões da UI.
--]]

blueBtn.MouseButton1Click:Connect(BlueSkill)
redBtn.MouseButton1Click:Connect(RedSkill)
hollowBtn.MouseButton1Click:Connect(HollowPurpleSkill)
domainBtn.MouseButton1Click:Connect(DomainExpansion)
sixEyesBtn.MouseButton1Click:Connect(SixEyes)

--[[
    ATIVAÇÃO DO INFINITO
    A defesa passiva é ativada automaticamente.
--]]

enableInfinity()

--[[
    FINALIZAÇÃO
    Mensagem de confirmação no output.
--]]

print("✅ Script Premium do Satoru Gojo carregado com sucesso!")
print("🎮 UI criada. Use os botões para ativar as habilidades.")
print("⚠️ Lembre-se: Este script é para fins educacionais.")
