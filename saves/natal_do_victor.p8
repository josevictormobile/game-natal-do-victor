pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
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

-- variaveis de status
game_over = false
gift_fall = false
santa_jump = false
jump_height = 95
santa_speed = 2
score = 0
hp = 3

function _init()
    cls()
    -- carregar os sprites
    load_sprites()
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

function _update()
	check_collision()
    check_gift_delivery()
    update_santa()
    update_houses()
    update_birds()
    update_gifts()
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
    for i = 1, #houses do
        if check_hitbox_collision(santa_p, houses[i]) then
            hp -= 1
            if hp == 0 then
                game_over = true
            end
        end
    end
    for i = 1, #birds do
        if check_hitbox_collision(santa_p, birds[i]) then
            hp -= 1
            if hp == 0 then
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

function background_draw()
    rectfill(0, 118, 127, 127, 7) -- um retれけngulo azul para o cれたu
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

function _draw()
    if game_over then 
        cls()
        print("game over! score: " .. score, 40, 60, 7)
    else
        cls() -- limpa a tela
        background_draw()
       	load_sprites() -- atualizar os sprites na tela
        print("score:" .. score .."\nhp:" .. hp, 4, 4, 7) -- exibir a pontuacao na tela
	end
end

__gfx__
00000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000078800000707700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700008880000774470000000000000000000060006000055000000000000000000000000000000000000000000000000000000000000000000000000000
00077000008770000744447000808000000000000006060000555500000000000000000000000000000000000000000000000000000000000000000000000000
000770000088700074444447000e0000060006000066600006666660000000000000000000000000000000000000000000000000000000000000000000000000
00700700008870007443344700b8b000006060000a00000066666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000008880000443344000b8b000066600000000000000999900000000000000000000000000000000000000000000000000000000000000000000000000
00000000008080000443344000b8b000a00000000000000000000000500000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000007880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000877000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000887000040004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000040887040004400480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000004488040044004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000004448440044004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000004444440400440040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
