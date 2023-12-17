pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
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
    menu_items = {"jogar", "reiniciar"}
    selected_item = 1
    birds_number = 2
    santa_falling = false
    santa_sleigh = true
    ufo_speed = 8

    -- definicao dos sprites
    spr_santa = 19
    spr_house = 2
    spr_renas = 20
    spr_gift = 3
    spr_bird = 4
    spr_ufo = 6

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
    santa_collision_animation()
    update_speed()
    update_reindeers()
    check_santa_reindeer_collision()
    update_ufo()
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
        if (hp == 4) print("score:" .. score .."\nhp: ♥ ♥ ♥ ♥", 4, 4, 7)
        if (hp == 3) print("score:" .. score .."\nhp: ♥ ♥ ♥", 4, 4, 7)
        if (hp == 2) print("score:" .. score .."\nhp: ♥ ♥ ", 4, 4, 7)
        if (hp == 1) print("score:" .. score .."\nhp: ♥", 4, 4, 7)
	end
end

function load_sprites()
    -- definir os sprites
    spr(spr_santa, santa_p.x, santa_p.y, 1, 1)
    spr(spr_renas, renas_p.x, renas_p.y, 1, 1)
    spr(spr_gift, gift.x, gift.y, 1, 1)
    spr(spr_ufo, ufo.x, ufo.y, 1, 1)
    for i = 1, #houses do
        spr(spr_house, houses[i].x, houses[i].y, 1, 1)
    end
    for i = 1, #birds do
        spr(spr_bird, birds[i].x, birds[i].y, 1, 1)
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
            if selected_item == 1 then --jogar
                start_values()
                menu_fase = false
                game_over = false
            elseif selected_item == 2 then --reiniciar
                menu_fase = true
                game_over = false
            end 
        end
    end
end

function update_santa()
    if santa_sleigh then
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
        if btn(5) and not gift_fall then
            gift.x = santa_p.x
            gift.y = santa_p.y
            gift_fall = true
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
    if score > 46 then
        ufo.x -= ufo_speed
        if ufo.x < -10 then
            ufo.x = flr(rnd(100 + 1)) + 150
            ufo.y = rnd(108)
        end
    end
end

function update_speed()
    if score==20 and scenario_speed==1 then
        scenario_speed = 1.2
    elseif score==30 and scenario_speed==1.6 then
        scenario_speed = 1.4
    end
end

function check_hitbox_collision(hitbox1, hitbox2)
    -- calcula os limites dos retれけngulos
    local left1, right1, up1, down1 = hitbox1.x, hitbox1.x + hitbox1.w, hitbox1.y, hitbox1.y + hitbox1.h
    local left2, right2, up2, down2 = hitbox2.x, hitbox2.x + hitbox2.w, hitbox2.y, hitbox2.y + hitbox2.h

    -- verifica a colisれこo entre os retれけngulos
    if right1 >= left2 and left1 <= right2 and down1 >= up2 and up1 <= down2 then
        return true  -- hれく colisれこo
    else
        return false  -- nれこo hれく colisれこo
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
            -- restaura a cor do papai noel  
            santa_sprite_color_change(true)
            santa_collision = false
        elseif time() > collision_timer.second then
            -- muda a cor do papai noel  
            santa_sprite_color_change(false)
        elseif time() > collision_timer.first then
            -- restaura a cor do papai noel 
            santa_sprite_color_change(true)
        else
            -- muda a cor do papai noel 
            santa_sprite_color_change(false)
        end
    end
end

function santa_sprite_color_change(normal)
    if santa_sleigh and normal then
        spr_santa = 19
        spr_renas = 20
    elseif santa_sleigh and not normal then
        spr_santa = 10
        spr_renas = 11
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
    if gift_fall and check_hitbox_collision(gift,floor) then
        score -= 1
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
__gfx__
00000000000000000700000000000000000000000000000000000000000000000000000000000000072200000000000000000000000000000000000000000000
07220000078800000707700000000000000000000000000000000000000000000000000000000000002220000000000000000000000000000000000000000000
00222000008880000774470000000000000000000060006000055000000000000000000000000000002770000000000000000000000000000000000000000000
00277000008770000744447000808000000000000006060000555500000000000000000000000000002270000800080000000000000000000000000000000000
002270000088700074444447000e0000060006000066600006666660000000000000000000000000802270800088008200000000000000000000000000000000
00227000008870007443344700b8b000006060000a00000066666666000000000000000000000000088220800880088000000000000000000000000000000000
00222000008880000443344000b8b000066600000000000000999900000000000000000000000000088828800880088000000000000000000000000000000000
00202000008080000443344000b8b000a00000000000000000000000000000000000000000000000088888808008800800000000000000000000000000000000
00000000000000000000000007880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000888000000000000000000000000000000000000788000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000877000000000000000000000000000000000000088840400000000000000000000000000000000000000000000000000000000
00000000000000000000000000887000040004000000000000000000000000000087744000000000000000000000000000000000000000000000000000000000
00000000000000000000000040887040004400480000000000000000000000004088744800000000000000000000000000000000000000000000000000000000
00000000000000000000000004488040044004400000000000000000000000000488440000000000000000000000000000000000000000000000000000000000
00000000000000000000000004448440044004400000000000000000000000000444840000000000000000000000000000000000000000000000000000000000
00000000000000000000000004444440400440040000000000000000000000000400040000000000000000000000000000000000000000000000000000000000
