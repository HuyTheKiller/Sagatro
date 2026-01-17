-- Fusion mechanic from Fusion Jokers, modified to only allow fusions in a run with story mode enabled
SagaFusion = {}
SagaFusion.fusions = {
	{ jokers = {
		{ name = "j_sgt_white_rabbit", carry_stat = "chips", extra_stat = true },
		{ name = "j_sgt_eat_me", carry_stat = nil, extra_stat = false }
	}, result_joker = "j_sgt_kid_gloves_and_fan", cost = 8 },
	{ jokers = {
		{ name = "j_sgt_mouse", carry_stat = nil, extra_stat = false },
		{ name = "j_splash", carry_stat = nil, extra_stat = false }
	}, result_joker = "j_sgt_dodo_bird", cost = 9 },
}

function add_saga_fusion(joker1, carry_stat1, extra1, joker2, carry_stat2, extra2, result_joker, cost, merged_stat, merge_stat1, merge_stat2, merge_extra)
	for _, v in ipairs(SagaFusion.fusions) do
		if v.jokers[1].name == joker1
		or v.jokers[2].name == joker2
		or v.result_joker == result_joker then
			return
		end
	end
	table.insert(SagaFusion.fusions,
		{ jokers = {
			{ name = joker1, carry_stat = carry_stat1, extra_stat = extra1, merge_stat = merge_stat1 },
			{ name = joker2, carry_stat = carry_stat2, extra_stat = extra2, merge_stat = merge_stat2 }
		}, result_joker = result_joker, cost = cost, merged_stat = merged_stat, merge_extra = merge_extra })
end

function remove_saga_fusion(result_joker)
	for i, v in ipairs(SagaFusion.fusions) do
		if v.result_joker == result_joker then
			table.remove(SagaFusion.fusions, i)
		end
	end
end

local function has_joker(val, start_pos)
	if not start_pos then
		start_pos = 0
	end
	for i, v in ipairs(G.jokers.cards) do
		if v.ability.set == 'Joker' and v.config.center_key == val and i > start_pos then
			return i
		end
	end
	return -1
end

function Card:can_fuse_saga()
	for _, fusion in ipairs(G.GAME.fusion_table or {}) do
		if G.GAME.dollars - G.GAME.bankrupt_at >= to_big(fusion.cost) then
			local found_me = false
			local all_jokers = true
			for _, joker in ipairs(fusion.jokers) do
				if fusion.jokers[1].name == fusion.jokers[2].name then
					if #SMODS.find_card(joker.name) > 1 then
						return true
					else
						return false
					end
				end
				if not next(SMODS.find_card(joker.name)) then
					all_jokers = false
				end
				if joker.name == self.config.center_key then
					found_me = true
				end
			end
			if found_me and all_jokers then
				return true
			end
		end
	end
  return false
end

function Card:get_saga_fusion()
	for _, fusion in ipairs(G.GAME.fusion_table or {}) do
		for _, joker in ipairs(fusion.jokers) do
			if joker.name == self.config.center_key then
				return fusion
			end
		end
	end
    return nil
end


function Card:fuse_saga()
	G.CONTROLLER.locks.selling_card = true
    stop_use()
    local area = self.area
    G.CONTROLLER:save_cardarea_focus('jokers')

    if self.children.use_button then self.children.use_button:remove(); self.children.use_button = nil end
    if self.children.sell_button then self.children.sell_button:remove(); self.children.sell_button = nil end

	local my_pos = has_joker(self.config.center_key)

	local edition = nil
	if self.edition then
		edition = self.edition
	end

	local chosen_fusion = nil
	local joker_pos = {}
	local found_me = false
	for _, fusion in ipairs(G.GAME.fusion_table or {}) do
		joker_pos = {}
		found_me = false
		for _, joker in ipairs(fusion.jokers) do
			if fusion.jokers[1].name == fusion.jokers[2].name then
				if #SMODS.find_card(joker.name) > 1 and #joker_pos == 0 then
					local first_pos = has_joker(joker.name)
					table.insert(joker_pos, {pos = first_pos, joker = joker})
					table.insert(joker_pos, {pos = has_joker(joker.name, first_pos), joker = joker})
				end
			elseif next(SMODS.find_card(joker.name)) then
				table.insert(joker_pos, {pos = has_joker(joker.name), joker = joker})
			end
			if joker.name == self.config.center_key then
				found_me = true
			end
		end

		if #joker_pos == #fusion.jokers and found_me then
			chosen_fusion = fusion
			break
		end
	end

	if chosen_fusion ~= nil then
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function()
			play_sound("sgt_page_scratch", 1, 1.25)
			for _, pos in ipairs(joker_pos) do
				if not edition and G.jokers.cards[pos.pos].edition then
					edition = G.jokers.cards[pos.pos].edition
				end
				G.jokers.cards[pos.pos]:juice_up(0.3, 0.4)
			end
			return true
		end}))
		delay(0.2)
		G.E_MANAGER:add_event(Event({trigger = 'immediate',func = function()
			ease_dollars(-chosen_fusion.cost)
			local j_fusion = create_card('Joker', G.jokers, nil, nil, nil, nil, chosen_fusion.result_joker, nil)
			if edition and not j_fusion.edition then
				j_fusion.edition = edition
			end
			table.sort(joker_pos, function (a, b)
				return a.pos > b.pos
			end)
			for index, pos in ipairs(joker_pos) do
				local isPrimary = false
				if G.jokers.cards[pos.pos] == self then
					isPrimary = true
				end
				for k,_ in pairs(SMODS.Stickers) do
					if G.jokers.cards[pos.pos].ability[k] then
						-- if string.find(k, "gemslot") then
						-- 	local gemExists = false
						-- 	for k1, _ in pairs(j_fusion.ability) do
						-- 		if string.find(k1, "gemslot") then
						-- 				gemExists = true
						-- 		end
						-- 	end
						-- 	if isPrimary then
						-- 		j_fusion.ability[k] = true
						-- 	end
						-- else
							j_fusion:add_sticker(k, true)
						--end
					end
				end
				local check_joker = pos.joker
				if check_joker.carry_stat then
					if check_joker.extra_stat then
						j_fusion.ability.extra[check_joker.carry_stat] = G.jokers.cards[pos.pos].ability.extra[check_joker.carry_stat]
					else
						j_fusion.ability[check_joker.carry_stat] = G.jokers.cards[pos.pos].ability[check_joker.carry_stat]
					end
				end
				if check_joker.merge_stat then
					if chosen_fusion.merge_extra then
						if check_joker.extra_stat then
							j_fusion.ability.extra[chosen_fusion.merged_stat] = j_fusion.ability.extra[chosen_fusion.merged_stat] + G.jokers.cards[pos.pos].ability.extra[check_joker.merge_stat]
						else
							j_fusion.ability.extra[chosen_fusion.merged_stat] = j_fusion.ability.extra[chosen_fusion.merged_stat] + G.jokers.cards[pos.pos].ability[check_joker.merge_stat]
						end
					else
						if check_joker.extra_stat then
							j_fusion.ability[chosen_fusion.merged_stat] = j_fusion.ability[chosen_fusion.merged_stat] + G.jokers.cards[pos.pos].ability.extra[check_joker.merge_stat]
						else
							j_fusion.ability[chosen_fusion.merged_stat] = j_fusion.ability[chosen_fusion.merged_stat] + G.jokers.cards[pos.pos].ability[check_joker.merge_stat]
						end
					end
				end
				--G.jokers.cards[pos]:start_dissolve({G.C.GOLD})
				G.jokers.cards[pos.pos]:remove()
			end

			delay(0.3)

			j_fusion:add_to_deck()
			G.jokers:emplace(j_fusion)
			play_sound("sgt_page_flip", 1, 1.25)
			Sagatro.update_inactive_state(true)

			delay(0.1)
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3, blocking = false,
			func = function()
				G.E_MANAGER:add_event(Event({trigger = 'immediate',
				func = function()
					G.E_MANAGER:add_event(Event({trigger = 'immediate',
					func = function()
						G.CONTROLLER.locks.selling_card = nil
						G.CONTROLLER:recall_cardarea_focus(area == G.jokers and 'jokers' or 'consumeables')
					return true
					end}))
				return true
				end}))
			return true
			end}))
			return true
		end}))
	end

	G.CONTROLLER.locks.selling_card = nil
	G.CONTROLLER:recall_cardarea_focus('jokers')
end

G.FUNCS.fuse_saga = function(e)
    local card = e.config.ref_table
    card:fuse_saga()
end

G.FUNCS.can_fuse_saga = function(e)
    if e.config.ref_table:can_fuse_saga() then
        e.config.colour = G.C.RARITY[4]
        e.config.button = 'fuse_saga'
    else
      	e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      	e.config.button = nil
    end
  end

local use_and_sell_buttonsref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
	local retval = use_and_sell_buttonsref(card)

	if card.area and card.area.config.type == 'joker' and card.ability.set == 'Joker' and card.ability.saga_fusion then
		local fuse =
		{n=G.UIT.C, config={align = "cr"}, nodes={

		  {n=G.UIT.C, config={ref_table = card, align = "cr",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.GOLD, one_press = true, button = 'sell_card', func = 'can_fuse_saga'}, nodes={
			{n=G.UIT.B, config = {w=0.1,h=0.6}},
			{n=G.UIT.C, config={align = "tm"}, nodes={
				{n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
					{n=G.UIT.T, config={text = localize('b_join'),colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true}}
				}},
				{n=G.UIT.R, config={align = "cm"}, nodes={
					{n=G.UIT.T, config={text = localize('$'),colour = G.C.WHITE, scale = 0.4, shadow = true}},
					{n=G.UIT.T, config={ref_table = card, ref_value = 'saga_fusion_cost',colour = G.C.WHITE, scale = 0.55, shadow = true}}
				}}
			}}
		  }}
		}}
		retval.nodes[1].nodes[2].nodes = retval.nodes[1].nodes[2].nodes or {}
		table.insert(retval.nodes[1].nodes[2].nodes, fuse)
		return retval
	end

	return retval
end

local gsr = Game.start_run
function Game:start_run(args)
	gsr(self, args)
	if not args.savetext then
		G.GAME.story_mode = Sagatro.config.DisableOtherJokers
		if G.GAME.story_mode then
			G.GAME.sgt_lenient_score = Sagatro.config.LenientScore
		end
		if G.GAME.modifiers.ortalab_only then
			G.GAME.story_mode = false
		end
		if args.challenge then
			G.GAME.story_mode = false
			if args.challenge.key == "c_sgt_ragnarok" then
				G.GAME.round_resets.blind_choices.Small = G.GAME.round_resets.blind_choices.Boss
				G.GAME.round_resets.blind_choices.Big = get_new_boss()
				G.GAME.round_resets.blind_choices.Boss = Sagatro.get_new_showdown()
				G.GAME.modifiers.scaling = 10
				G.GAME.modifiers.sgt_ragnarok_challenge_text = nil
			elseif args.challenge.key == "c_sgt_inversion" then
				Sagatro.inverse()
			end
		end
		if not G.GAME.story_mode and Sagatro.config.DisableSagatroItems then
			G.GAME.modifiers.sgt_disable_sagatro_items = true
		end
		G.GAME.perishable_already_active = G.GAME.modifiers.enable_perishables_in_shop -- used by Adam
		G.GAME.no_boss_reward_already_active = (G.GAME.modifiers.no_blind_reward or {}).Boss -- used by Jubjub Bird
		if Sagatro.debug then
			G.GAME.dollars = to_big(250)
			SMODS.change_free_rerolls(1e10)
		end
	end
	if G.GAME.story_mode then
		Sagatro.update_HUD()
	end
	G.GAME.fusion_table = G.GAME.story_mode and SagaFusion.fusions or {}
	-- Change colour in story mode, but the hook is over here, I just want to save space
	G.C.BLIND.Small = G.GAME.story_mode and Sagatro.badge_colour or HEX("50846e")
	G.C.BLIND.Big = G.GAME.story_mode and Sagatro.badge_colour or HEX("50846e")
	if Sagatro.debug then
		sendInfoMessage("Welcome to Sagatro debug mode! Make sure you have DebugPlus installed! Type 'eval Sagatro.help()' for more info. ", "Sagatro")
	end
	ease_background_colour_blind(G.STATE)
	G.E_MANAGER:add_event(Event({func = function()
        if Sagatro.storyline_check("alice_in_mirrorworld") then
            Sagatro.update_inactive_state()
        end
		if G.GAME.sgt_lenient_score and G.GAME.round == 0 then
			G.FUNCS.lenient_score_tooltip()
		end
    return true end}))
end