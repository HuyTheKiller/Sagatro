local porcelain = {
    key = "pm_bad_end_1",
    reset_on_startup = Sagatro.debug,
    unlock_condition = function(self, args)
        if args.type == "pm_bad_end_1" then
            return true
        end
    end
}

local blindness = {
    key = "pm_bad_end_2",
    reset_on_startup = Sagatro.debug,
    unlock_condition = function(self, args)
        if args.type == "pm_bad_end_2" then
            return true
        end
    end
}

local platinum = {
    key = "pm_normal_end_1",
    reset_on_startup = Sagatro.debug,
    unlock_condition = function(self, args)
        if args.type == "pm_normal_end_1" then
            return true
        end
    end
}

local dawn = {
    key = "pm_normal_end_2",
    reset_on_startup = Sagatro.debug,
    unlock_condition = function(self, args)
        if args.type == "pm_normal_end_2" then
            return true
        end
    end
}

local little_goody_2_shoes = {
    key = "pm_normal_end_3",
    reset_on_startup = Sagatro.debug,
    unlock_condition = function(self, args)
        if args.type == "pm_normal_end_3" then
            return true
        end
    end
}

local witching_hour = {
    key = "pm_unknown_end_1",
    reset_on_startup = Sagatro.debug,
    unlock_condition = function(self, args)
        if args.type == "pm_unknown_end_1" then
            return true
        end
    end
}

local shattered_delusion = {
    key = "pm_unknown_end_2",
    reset_on_startup = Sagatro.debug,
    unlock_condition = function(self, args)
        if args.type == "pm_unknown_end_2" then
            return true
        end
    end
}

local achievement_table = {
    porcelain,
    blindness,
    platinum,
    dawn,
    little_goody_2_shoes,
    witching_hour,
    shattered_delusion,
}

for _, v in ipairs(achievement_table) do
    SMODS.Achievement(v)
end