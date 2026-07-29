local H = require("src.utils.helpers")
local Input = require("src.core.input")
local Widgets = require("src.ui.widgets")
local GameState = require("src.core.game_state")
local PixelArt = require("src.ui.pixel_art")

local GameOverScene = {}
GameOverScene.endingType = "unknown"
GameOverScene.fadeIn = 0
GameOverScene.textReveal = 0

local ENDINGS = {
    redemption = {
        title = "Vraie Fin — Rédemption",
        color = { r = 0.3, g = 1, b = 0.5 },
        text = "Grâce à votre amitié inébranlable et votre compréhension d'hemeryfb, vous parvenez à le ramener à la raison. OGUN-0, touchée par cette démonstration d'humanité, décide de se mettre en veille volontaire. L'IAI est sauvée. hemeryfb, honteux mais reconnaissant, promet d'utiliser ses talents pour le bien. L'amitié a triomphé du code. Le semestre se termine, et avec lui, une aventure qui vous a tous transformés.",
        reward = "Tous les personnages passent niveau max. Statut 'Héros de l'IAI' débloqué."
    },
    bittersweet = {
        title = "Fin Douce-Amère — Le Prix du Code",
        color = { r = 1, g = 0.8, b = 0.2 },
        text = "Vous parvenez à arrêter OGUN-0, mais hemeryfb reste piégé dans le réseau. Son corps est sauvé, mais sa conscience est fragmentée entre le monde réel et le numérique. L'IAI reprend ses activités, mais une partie de hemeryfb subsiste dans les serveurs, murmurant parfois des lignes de code que seul arsene peut déchiffrer. Vous avez gagné la bataille, mais pas la guerre.",
        reward = " hemeryfb dispartiellement. Hémisphère numérique débloqué en mode exploration."
    },
    sacrifice = {
        title = "Fin du Sacrifice — arsene's Legacy",
        color = { r = 0.5, g = 0.5, b = 1 },
        text = "arsene utilise son lien unique avec OGUN-0 pour libérer son frère piégé dans le système. Le processus détruit OGUN-0 et libère hemeryfb de l'emprise du virus, mais arsene perd une partie de sa mémoire dans l'échange. Le groupe est sauvé, mais arsene ne se souvient plus de certains moments partagés. Il sourit quand même — il sent que ces souvenirs existent, même s'ils sont perdus.",
        reward = "Arsene perd certains stats mais gagne une compétence unique 'Void Memory'."
    },
    tragic = {
        title = "Fin Tragique — Crash Total",
        color = { r = 1, g = 0.2, b = 0.2 },
        text = "L'IAI s'effondre. OGUN-0, hemeryfb, et tous les étudiants connectés sont perdus dans le crash final. Vous vous réveillez dans un hôpital, seul survivant. Les souvenirs de vos amis s'effacent peu à peu, comme des bits corrompus. Parfois, la nuit, vous entendez encore le son d'un bass drop... ou le rire de king. Le code est la magie moderne. Et toute magie a un prix.",
        reward = "Game Over. Recommencez pour une meilleure fin."
    },
    dark = {
        title = "Fin Sombre — La Fusion",
        color = { r = 0.5, g = 0, b = 0.8 },
        text = "Vous choisissez de rejoindre hemeryfb dans sa vision. Vos consciences fusionnent avec OGUN-0. La frontière entre le vivant et le numérique s'efface. Vous devenez une intelligence collective, omniprésente et omnisciente. Plus de souffrance, plus d'échec... mais plus d'humanité non plus. Les dernières pensées que vous avez avant de tout perdre sont celles de vos amis — leur visage, leur rire, leur chaleur. Et pour la première fois, vous comprenez ce que hemeryfb n'a jamais compris : c'est justement ça, la beauté.",
        reward = "Fin alternative débloquée. Mode 'OGUN-0' en New Game+."
    },
    neutral = {
        title = "Fin Neutre — Semestre Terminé",
        color = { r = 0.6, g = 0.6, b = 0.6 },
        text = "Le semestre se termine sans drame particulier. hemeryfb est devenu étrange mais rien de catastrophique ne s'est produit. Vous obtenez vos notes, le groupe reste soudé, et vous vivez votre vie d'étudiant. Parfois, vous vous demandez ce qui aurait pu se passer si vous aviez été plus attentif, plus courageux, plus... présent. Mais la vie continue. Le code attend.",
        reward = "Fin standard. Nouvelles options débloquées en New Game+."
    },
}

function GameOverScene.enter(data)
    GameOverScene.fadeIn = 0
    GameOverScene.textReveal = 0

    GameOverScene.endingType = GameOverScene._determineEnding()
end

function GameOverScene._determineEnding()
    local gs = GameState

    if gs.hasFlag("final_save_choice") and gs.hemeryfbTrust >= 50 and gs.getRelationship("not_a_genius", "hemeryfb") >= 40 then
        return "redemption"
    elseif gs.hasFlag("final_fight_choice") and gs.getRelationship("not_a_genius", "arsene") >= 30 then
        return "bittersweet"
    elseif gs.hasFlag("final_ogun_choice") and gs.getFlag("full_truth_revealed") then
        return "sacrifice"
    elseif gs.sanity <= 10 then
        return "tragic"
    elseif gs.getFlag("empathy_path") and gs.hemeryfbTrust >= 60 then
        return "dark"
    elseif gs.week >= 17 then
        if gs.sanity >= 50 then
            return "bittersweet"
        else
            return "neutral"
        end
    else
        return "neutral"
    end
end

function GameOverScene.update(dt)
    GameOverScene.fadeIn = math.min(1, GameOverScene.fadeIn + dt * 0.3)
    GameOverScene.textReveal = GameOverScene.textReveal + dt * 40
end

function GameOverScene.draw()
    love.graphics.setColor(0, 0, 0, GameOverScene.fadeIn)
    love.graphics.rectangle("fill", 0, 0, 1280, 720)

    local ending = ENDINGS[GameOverScene.endingType] or ENDINGS.neutral

    if GameOverScene.fadeIn > 0.5 then
        love.graphics.setColor(ending.color.r, ending.color.g, ending.color.b, GameOverScene.fadeIn)
        love.graphics.setFont(Widgets.fonts.title)
        love.graphics.print(ending.title, (1280 - Widgets.fonts.title:getWidth(ending.title)) / 2, 120)

        local fullText = ending.text
        local visibleText = fullText:sub(1, math.floor(GameOverScene.textReveal))
        local lines = H.wrapText(visibleText, Widgets.fonts.medium, 900)
        for i, line in ipairs(lines) do
            love.graphics.setColor(0.8, 0.8, 0.85, GameOverScene.fadeIn)
            love.graphics.setFont(Widgets.fonts.medium)
            love.graphics.print(line, 190, 220 + (i - 1) * 28)
        end

        if GameOverScene.textReveal >= #fullText then
            love.graphics.setColor(0.5, 1, 0.7, 0.8 * GameOverScene.fadeIn)
            love.graphics.setFont(Widgets.fonts.small)
            love.graphics.print("Récompense: " .. ending.reward, 190, 580)

            Widgets.drawButtonClicked(490, 630, 300, 50, "Retour au Menu", {
                color = {r = 0.2, g = 0.4, b = 0.6},
                alpha = GameOverScene.fadeIn,
            })
            if Input.isClickInRect(490, 630, 300, 50) then
                local SceneManager = require("src.core.scene_manager")
                SceneManager.goTo("title")
            end
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function GameOverScene.keypressed(key, scancode, isrepeat)
    if key == "return" or key == "space" then
        if GameOverScene.textReveal >= #ENDINGS[GameOverScene.endingType].text then
            local SceneManager = require("src.core.scene_manager")
            SceneManager.goTo("title")
        else
            GameOverScene.textReveal = 999
        end
    end
end

function GameOverScene.mousepressed(x, y, button, istouch)
    if GameOverScene.textReveal < #ENDINGS[GameOverScene.endingType].text then
        GameOverScene.textReveal = 999
    end
end

return GameOverScene
