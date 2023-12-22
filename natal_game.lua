function start_values()
    -- variaveis de status
    game_over = false
    gift_fall = false
    santa_jumping = false
    jump_height = 85
    santa_speed = 2
    scenario_speed = 1
    score = 0
    hp = 4
    menu_fase = true
    menu_items = {"Jogar", "Reiniciar", "Instrucoes"}
    selected_item = 1
    birds_number = 2
    santa_falling = false
    santa_sleigh = true
    ufo_speed = 6
    first_press = true
    star_x = 120
    star_y = 0
    star_speed = 3
    release_ufo = true
    left_gift_x = -10
    instrucoes_fase = false
    release_wiseman_staff = false
    staff_rolling = false
    santa_with_staff = false
    staff_charge = 0

    -- definicao dos sprites
    spr_santa = 19
    spr_house = 2
    spr_renas = 20
    spr_gift = 3
    spr_bird = 4
    spr_ufo = 6
    spr_gnome = 56
    spr_candy_cane = 26
    spr_wiseman_staff = 42
    spr_staff_power = 43
    spr_egg = 44

    -- hitboxes
    renas_p = {x = 68, y = 110, w = 8, h = 8}
    gift = {x = -8, y = -8, w = 3, h = 5}
    santa_p = {x = 60, y = 110, w = 8, h = 8}
    houses = {
        { x = 120, y = 110, w = 8, h = 8 },
        { x = 180, y = 110, w = 8, h = 8  },
        { x = 240, y = 110, w = 8, h = 8  },
        { x = 160, y = 110, w = 8, h = 8  }
    }
    birds = {
        {x = 120, y = 50, w = 6, h = 4 },
        {x = 180, y = 90, w = 6, h = 4 },
        {x = 235, y = 50, w = 6, h = 4 },
        {x = 249, y = 60, w = 6, h = 4 },
        {x = 233, y = 05, w = 6, h = 4 },
        {x = 257, y = 110, w = 6, h = 4 },
        {x = 239, y = 90, w = 6, h = 4 }
    }
    floor = {x = 0, y = 115, w = 127, h = 17}
    ufo = {x = -10, y = -10, w = 2, h = 2}
    gnomes = {
        {x = 60, y = 110, w = 8, h = 8},
        {x = 20, y = 110, w = 8, h = 8}
    }
    wiseman_staff = {x = -10, y = -10, w = 6, h = 6}
    staff_power = {x = -10, y = -10, w = 5, h = 5}
    egg = {x = -10, y = -10, w = 5, h = 5}
end

function _init()
    cls()
    start_values()
    load_sprites()
end

function _update()
    if menu_fase or game_over or instrucoes_fase then
        update_menu()
    else
        check_collision()
        check_gift_delivery()
        update_santa()
        update_houses()
        update_birds()
        update_gifts()
        santa_collision_animation()
        update_speed()
        update_reindeers()
        check_santa_reindeer_collision()
        update_ufo()
        update_wiseman_staff()
        check_collision_wiseman_staff()
        update_staff_power()
        check_collision_staff_power()
        update_egg()
    end
end

function _draw()
    if menu_fase then
        cls()
        spr(spr_candy_cane, 20, 10, 1, 1)
        print(" natal do victor", 30, 10, 7)
        spr(spr_candy_cane, 100, 10, 1, 1)
        background_menu_draw()
        menu()
    elseif game_over then 
        cls()
        print("game over! score: " .. score, 30, 10, 7)
        menu()
    elseif instrucoes_fase then
        cls()
        print("★ evite colidir (⬇️⬅️➡️)", 10, 10, 7)
        print("★ entregue os presentes (x)", 10, 20, 7)
        print("★ entregas erradas custam \n    pontos", 10, 30, 7)
        print("★ se estiver sem treno\n    pule com ⬆️", 10, 50, 7)
        print("★ pule na rena para voar\n    pela ultima vez", 10, 70, 7)
        print("★ pegue o cajado e use (o)", 10, 90, 7)
        menu_footer()
    else
        cls() -- limpa a tela
        background_draw()
       	load_sprites() -- atualizar os sprites na tela
        if (hp == 4) print("score:" .. score .."\nhp: ♥ ♥ ♥ ♥", 4, 4, 7)
        if (hp == 3) print("score:" .. score .."\nhp: ♥ ♥ ♥", 4, 4, 7)
        if (hp == 2) print("score:" .. score .."\nhp: ♥ ♥ ", 4, 4, 7)
        if (hp == 1) print("score:" .. score .."\nhp: ♥", 4, 4, 7)
        --print("time:" .. flr(time()), 4, 24, 7)
        if (staff_charge == 2) print("mana:  ◆ ◆ ", 4, 17, 7)
        if (staff_charge == 1) print("mana: ◆", 4, 17, 7)
	end
end

function load_sprites()
    -- definir os sprites
    spr(spr_santa, santa_p.x, santa_p.y, 1, 1)
    spr(spr_renas, renas_p.x, renas_p.y, 1, 1)
    spr(spr_gift, gift.x, gift.y, 1, 1)
    spr(spr_ufo, ufo.x, ufo.y, 1, 1)
    spr(spr_wiseman_staff, wiseman_staff.x, wiseman_staff.y, 1, 1)
    spr(spr_staff_power, staff_power.x, staff_power.y, 1, 1)
    spr(spr_egg, egg.x, egg.y, 1, 1)
    for i = 1, #houses do
        spr(spr_house, houses[i].x, houses[i].y, 1, 1)
    end
    for i = 1, #birds do
        spr(spr_bird, birds[i].x, birds[i].y, 1, 1)
    end
end

function background_draw()
    rectfill(0, 118, 127, 127, 7) -- um retangulo branco para o chao com neve
    -- Desenhar a Ursa Maior
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

function background_menu_draw()
    rectfill(0, 118, 127, 127, 7) -- chão nevado
    
    -- Desenhar Papai Noel e renas
    for i=1, #gnomes do
        spr(spr_gnome, gnomes[i].x, gnomes[i].y, 1, 1) -- Sprite dos Gnomos
        spr(spr_gift, left_gift_x, 110, 1, 1)
        gnomes[i].x+=1
        if gnomes[i].x > 125 then
            gnomes[i].x = -flr(rnd(100 + 1))
        end
        if gnomes[2].x == 75 then
            left_gift_x=75
        end
        if gnomes[1].x == 75 then
            left_gift_x=-10
        end
    end
    -- spr(spr_ufo, 100, 30, 1, 1)

    -- Desenhar o Cruzeiro do Sul
    pset(40, 20, 7)  -- Ponto 1
    pset(50, 30, 7)  -- Ponto 2
    pset(60, 20, 7)  -- Ponto 3
    pset(50, 40, 7)  -- Ponto 4

    -- Desenhar a Ursa Maior
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

    -- Simulação de estrela cadente
    pset(star_x, star_y, 7) -- Desenhar a estrela

    -- Movimentar a estrela diagonalmente
    star_x = star_x - star_speed
    star_y = star_y + star_speed

    -- Verificar se a estrela saiu da tela, reiniciar sua posição
    max_star_position = flr(rnd(10000 + 1)) + 150
    if star_x > max_star_position or star_y > max_star_position then
        star_x = 120
        star_y = 0
    end
end

function menu()
    for i = 1, #menu_items do
        if i == selected_item then
            spr(spr_gift, 20, 26 + i * 10,1,1)
            print(" " .. menu_items[i], 30, 30 + i * 10, 7)
        else
            --spr(spr_gift, 25, 30 + i * 10,1,1)
            print(menu_items[i], 30, 30 + i * 10, 7)
        end
    end
end

function menu_footer()
    for i = 1, #menu_items do
        if i == selected_item then
            spr(spr_gift, 20, 86 + i * 10,1,1)
            print(" " .. menu_items[i], 30, 90 + i * 10, 7)
        else
            --spr(spr_gift, 25, 30 + i * 10,1,1)
            print(menu_items[i], 30, 90 + i * 10, 7)
        end
    end
end

function update_menu()
    -- if menu_fase or game_over then
        if (btnp(2)) selected_item = selected_item - 1
        if (btnp(3)) selected_item = selected_item + 1
        
        if selected_item < 1 then
            selected_item = 3 -- Se ficar menor que 1, volta para a última opção
        elseif selected_item > 3 then
            selected_item = 1 -- Se ficar maior que 3, volta para a primeira opção
        end

        if btnp(5) then 
            if selected_item == 1 then --Jogar
                start_values()
                menu_fase = false
                game_over = false
                instrucoes_fase = false
            elseif selected_item == 2 then --Reiniciar
                menu_fase = true
                game_over = false
                instrucoes_fase = false
            elseif selected_item == 3 then --Instrucoes
                menu_fase = false
                game_over = false
                instrucoes_fase = true
            end  
        end
    --end
end

function update_santa()
    if santa_sleigh and not menu_fase then
        if btn(0) and santa_p.x > -2 then
            santa_p.x -= santa_speed
            renas_p.x -= santa_speed
        end
        if btn(1) and santa_p.x < 120 then
            santa_p.x += santa_speed
            renas_p.x += santa_speed
        end
        if btn(2) and santa_p.y > -2 then
            santa_p.y -= santa_speed
            renas_p.y -= santa_speed
        end
        if btn(3) and santa_p.y < 110 then
            santa_p.y += santa_speed
            renas_p.y += santa_speed
        end
        if btnp(5) and not gift_fall then
            gift.x = santa_p.x
            gift.y = santa_p.y
            gift_fall = true
        end
        if btnp(4) and santa_with_staff and hp > 1 then
            staff_power.x = santa_p.x
            staff_power.y = santa_p.y
            staff_charge -= 1
            if(staff_charge==0) then
                santa_with_staff = false
                spr_santa = 19
            end
        end
    elseif santa_falling then
        spr_santa = 1
        santa_p.y += 1
        
        if santa_p.y >=110 then
            santa_falling = false
            if santa_p.y > 110 then
                santa_p.y = 110
            end
        end
    else
        --renas_p.x += santa_speed
        if btn(0) and santa_p.x > -2 then
            santa_p.x -= santa_speed
        end
        if btn(1) and santa_p.x < 120 then
            santa_p.x += santa_speed
        end
        if btnp(2) then
            santa_jumping = true
        end
        if santa_jumping then
            santa_p.y -= 2
        end
        if santa_p.y <= jump_height then
            santa_jumping = false
            santa_falling = true
        end
    end
end

function update_gifts()
    if gift_fall then
        gift.x -= scenario_speed
        gift.y += (scenario_speed*2)
    else
        gift.x -= scenario_speed
    end
end

function update_houses()
    new_house_position = flr(rnd(100 + 1)) + 150
    for i = 1, #houses do
        houses[i].x -= scenario_speed
        if houses[i].x < -8 then
            houses[i].x = new_house_position
        end
    end
end

function update_birds()
    if score==5 and birds_number<3 then
        birds_number = 3
    elseif score==10 and birds_number<4 then
        birds_number = 4
    elseif score==15 and birds_number<5 then
        birds_number = 5
    elseif score==20 and birds_number<6 then
        birds_number = 6
    elseif score==25 and birds_number<7 then
        birds_number = 7
    end
    for i = 1, birds_number do
        birds[i].x -= (scenario_speed * 2)
        if birds[i].x < -8 then
            birds[i].x = 240
            birds[i].y = rnd(108)
        end
    end
end

function update_reindeers()
    if not santa_sleigh then
        renas_p.x += santa_speed
        if renas_p.x > 127 then
            renas_p.x = -8
            renas_p.y = 105
        end
    end
end

function update_ufo()
    if (((score + 1) % 46) == 0) then
        release_ufo = true
    end
    if release_ufo then
        ufo.x -= ufo_speed
        if ufo.x < -10 then
            ufo.x = flr(rnd(100 + 1)) + 150
            ufo.y = rnd(108)
        end
    end
end

function update_wiseman_staff()
    if (((flr(time()) + 1) % 5) == 0) and not santa_with_staff then
        release_wiseman_staff = true
    end
    if release_wiseman_staff and not staff_rolling then
        wiseman_staff.x = 75
        wiseman_staff.y = 110
        staff_rolling = true
    end
    if staff_rolling then
        wiseman_staff.x -= scenario_speed
        if wiseman_staff.x < -10 then
            staff_rolling = false
            release_wiseman_staff = false
        end
    end
end

function update_staff_power()
    staff_power.x += 2
end

function update_egg()
    egg.y += 2
end

function update_speed()
    if score==20 and scenario_speed==1 then
        scenario_speed = 1.2
    elseif score==30 and scenario_speed==1.6 then
        scenario_speed = 1.4
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
    if not santa_collision then
        for i = 1, #houses do
            if check_hitbox_collision(santa_p, houses[i]) then
                set_santa_collision()
            end
        end
        for i = 1, #birds do
            if check_hitbox_collision(santa_p, birds[i]) then
                set_santa_collision()
            end
        end
        if check_hitbox_collision(santa_p, ufo) then
            set_santa_collision()
        end
    end
end

function set_santa_collision()
    santa_collision = true
    collision_timer = 
    {first = time() + 0.3, 
     second = time() + 0.6, 
     third = time() + 0.9, 
     fourth = time() + 1.2}
     hp -= 1
     if hp == 1 then
        santa_sleigh = false
        santa_falling = true
     elseif hp <=0 then
        game_over = true
     end
end

function santa_collision_animation()
    if santa_collision then
        if time() > collision_timer.third then
            -- Restaura a cor do Papai Noel  
            santa_sprite_color_change(true)
            santa_collision = false
        elseif time() > collision_timer.second then
            -- Muda a cor do Papai Noel  
            santa_sprite_color_change(false)
        elseif time() > collision_timer.first then
            -- Restaura a cor do Papai Noel 
            santa_sprite_color_change(true)
        else
            -- Muda a cor do Papai Noel 
            santa_sprite_color_change(false)
        end
    end
end

function santa_sprite_color_change(normal)
    if santa_sleigh and normal then
        if santa_with_staff then
            spr_santa = 38
        else
            spr_santa = 19
        end
        --spr_renas = 20
    elseif santa_sleigh and not normal then
        if santa_with_staff then
            spr_santa = 54
        else
            spr_santa = 10
        end
        --spr_renas = 11
    elseif not santa_sleigh and normal then
        spr_santa = 1
    elseif not santa_sleigh and not normal then
        spr_santa = 0
    end
end

function check_gift_delivery()
    for i = 1, #houses do
        if check_hitbox_collision(gift,houses[i]) then
            score += 1
            gift.x = -8
            gift.y = -8
            gift_fall = false
        end
    end
    if gift_fall and gift.y >= 110 then --check_hitbox_collision(gift,floor)
        if score > 0 then
            score -= 1
        end
        gift_fall = false
    end
end

function check_santa_reindeer_collision()
    if not santa_sleigh and check_hitbox_collision(santa_p, renas_p) then
        santa_sleigh = true
        spr_santa = 24
        spr_renas = 25
    end
end

function check_collision_wiseman_staff()
    if santa_sleigh and hp > 1 and check_hitbox_collision(santa_p, wiseman_staff) then
        santa_with_staff = true
        staff_charge = 2
        spr_santa = 38
        wiseman_staff.x = -10
        wiseman_staff.y = -10
    end
end

function check_collision_staff_power()
    for i = 1, #birds do
        if check_hitbox_collision(staff_power, birds[i]) then
            egg.x = birds[i].x
            egg.y = birds[i].y
            birds[i].x = -10
        end
    end
    if check_hitbox_collision(staff_power, ufo) then
        release_ufo = false
        ufo.x = -12
    end
end