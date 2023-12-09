function start_values()
    -- variaveis de status
    game_over = false
    gift_fall = false
    santa_jump = false
    jump_height = 95
    santa_speed = 2
    score = 0
    hp = 3
    menu_fase = true
    menu_items = {"Jogar", "Reiniciar"}
    selected_item = 1

    -- definicao dos sprites
    spr_santa = 19
    spr_house = 2
    spr_renas = 20
    spr_gift = 3
    spr_bird = 4

    -- hitboxes
    renas_p = {x = 68, y = 110, w = 8, h = 8}
    gift_p = {x = -8, y = -8}
    santa_p = {x = 60, y = 110, w = 8, h = 8}
    houses = {
        { x = 120, y = 110, w = 8, h = 8 },
        { x = 180, y = 110, w = 8, h = 8  },
        { x = 240, y = 110, w = 8, h = 8  },
        { x = 160, y = 110, w = 8, h = 8  }
    }
    birds = {
        {x = 120, y = 50, w = 8, h = 8 },
        {x = 180, y = 90, w = 8, h = 8 }
    }
end

function _init()
    cls()
    start_values()
    load_sprites()
end

function _update()
	check_collision()
    check_gift_delivery()
    update_menu()
    update_santa()
    update_houses()
    update_birds()
    update_gifts()
end

function _draw()
    if menu_fase then
        cls()
        print("natal do victor", 30, 10, 7)
        background_draw()
        menu()
    elseif game_over then 
        cls()
        print("game over! score: " .. score, 30, 10, 7)
        menu()
    else
        cls() -- limpa a tela
        background_draw()
       	load_sprites() -- atualizar os sprites na tela
        print("score:" .. score .."\nhp:" .. hp, 4, 4, 7) -- exibir a pontuacao na tela
	end
end

function background_draw()
    rectfill(0, 118, 127, 127, 7) -- um retangulo branco para o chao com neve
    pset(10, 78, 7)
    pset(21, 12, 7)
    pset(43, 78, 7)
    pset(46, 49, 7)
    pset(94, 18, 7)
    pset(15, 10, 7)
    pset(87, 45, 7)
    pset(89, 90, 7)
    pset(102, 51, 7)
    pset(47, 35, 7)
end

function menu()
    for i = 1, #menu_items do
        if i == selected_item then
            print("-> " .. menu_items[i], 30, 30 + i * 10, 7)
        else
            print(menu_items[i], 30, 30 + i * 10, 7)
        end
    end
end

function load_sprites()
    -- definir os sprites
    spr(spr_santa, santa_p.x, santa_p.y, 1, 1)
    spr(spr_renas, renas_p.x, renas_p.y, 1, 1)
    spr(spr_gift, gift_p.x, gift_p.y, 1, 1)
    for i = 1, #houses do
        spr(spr_house, houses[i].x, houses[i].y, 1, 1)
    end
    for i = 1, #birds do
        spr(spr_bird, birds[i].x, birds[i].y, 1, 1)
    end
end

function update_menu()
    if menu_fase or game_over then
        if (btnp(2)) selected_item = selected_item - 1
        if (btnp(3)) selected_item = selected_item + 1
        
        if selected_item < 1 then
            selected_item = 2
        elseif selected_item > 2 then
            selected_item = 1
        end

        if btn(5) then 
            if selected_item == 1 then --Jogar
                start_values()
                menu_fase = false
                game_over = false
            elseif selected_item == 2 then --Reiniciar
                menu_fase = true
                game_over = false
            end 
        end
    end
end

function update_santa()
    if btn(0) then
        santa_p.x -= santa_speed
        renas_p.x -= santa_speed
    end
    if btn(1) then
        santa_p.x += santa_speed
        renas_p.x += santa_speed
    end
    if btn(2) then
        santa_p.y -= santa_speed
        renas_p.y -= santa_speed
    end
    if btn(3) then
        santa_p.y += santa_speed
        renas_p.y += santa_speed
    end
    if btn(5) then
        gift_p.x = santa_p.x
        gift_p.y = santa_p.y
        gift_fall = true
    end
end

function update_gifts()
    if gift_fall then
        gift_p.x -= 1
        gift_p.y += 2
    end
end

function update_houses()
    for i = 1, #houses do
        houses[i].x -= 1
        if houses[i].x < -8 then
            houses[i].x = 240
        end
    end
end

function update_birds()
    for i = 1, #birds do
        birds[i].x -= 2
        if birds[i].x < -8 then
            birds[i].x = 240
            birds[i].y = rnd(108)
        end
    end
end

function check_hitbox_collision(hitbox1, hitbox2)
    -- Calcula os limites dos retângulos
    local left1, right1, up1, down1 = hitbox1.x, hitbox1.x + hitbox1.w, hitbox1.y, hitbox1.y + hitbox1.h
    local left2, right2, up2, down2 = hitbox2.x, hitbox2.x + hitbox2.w, hitbox2.y, hitbox2.y + hitbox2.h

    -- Verifica a colisão entre os retângulos
    if right1 >= left2 and left1 <= right2 and down1 >= up2 and up1 <= down2 then
        return true  -- Há colisão
    else
        return false  -- Não há colisão
    end
end

function check_collision()
    for i = 1, #houses do
        if check_hitbox_collision(santa_p, houses[i]) then
            hp -= 1
            if hp <= 0 then
                game_over = true
            end
        end
    end
    for i = 1, #birds do
        if check_hitbox_collision(santa_p, birds[i]) then
            hp -= 1
            if hp <= 0 then
                game_over = true
            end
        end
    end
end

function check_gift_delivery()
    for i = 1, #houses do
        if gift_p.x >= houses[i].x and gift_p.x <= houses[i].x + 8
        and gift_p.y == houses[i].y then
            score += 1
        end
    end
end