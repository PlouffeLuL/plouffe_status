Status = {
    Injuries = {}
}

Status.Items = {
    gauze = {
        time = 10000,
        bandage = 20
    },

    bandage = {
        time = 10000,
        bandage = 50
    },

    medikit = {
        time = 10000,
        bandage = 100,
        health = {amount = 50, delay = 2000},
        cleanInfection = true
    },

    ifak = {
        time = 10000,
        bandage = 50,
        health = {amount = 25, delay = 500}
    }
}

Status.Zones = {
    pillbox_hospital_checkin = {
        name = "pillbox_hospital_checkin",
        coords = vector3(312.23944091797, -592.82098388672, 43.284107208252),
        distance = 2.0,
        isZone = true,
        label = "Vous faire soigner",
        params = {fnc = "BedCare", zone = "pillbox"},
        keyMap = {
            key = "E",
            event = "plouffe_status:on_zone"
        },
        ped = {
            model = "s_m_m_doctor_01",
            coords = vector3(311.67858886719, -594.22351074219, 43.284042358398),
            heading = 340.35900878906
        }
    },

    paleto_hospital_checkin = {
        name = "paleto_hospital_checkin",
        coords = vector3(-251.8360748291, 6334.12109375, 32.42716217041),
        distance = 2.0,
        isZone = true,
        label = "Vous faire soigner",
        params = {fnc = "BedCare", zone = "paleto"},
        keyMap = {
            key = "E",
            event = "plouffe_status:on_zone"
        },
        ped = {
            model = "s_m_m_doctor_01",
            coords = vector3(-251.9094543457, 6335.3901367188, 32.42716217041),
            heading = 176.05290222168
        }
    },

    yoga_mirro_park = {
        name = "yoga_mirro_park",
        coords = {
            vector3(1161.2955322266, -453.13421630859, 67.01123046875),
            vector3(1162.6180419922, -448.52575683594, 67.011589050293),
            vector3(1168.4868164063, -450.16204833984, 67.01123046875),
            vector3(1167.2419433594, -454.49331665039, 67.018089294434)
        },
        zMax = 72.0,
        zMin = 65.0,
        distance = 2.0,
        isZone = true,
        label = "Faire du yoga",
        params = {fnc = "DoYoga", zone = "yoga_mirro_park"},
        keyMap = {
            key = "E",
            event = "plouffe_status:on_zone"
        }
    }
}

Status.DamageData = {
    weapon_unarmed = {},

    weapon_bat = {ragdoll = 2000},
    weapon_golfclub = {ragdoll = 2000},
    weapon_poolcue = {ragdoll = 2000},
    weapon_flashlight = {ragdoll = 1000},
    weapon_crowbar = {ragdoll = 1000},
    weapon_hammer = {ragdoll = 1000},
    weapon_knuckle = {ragdoll = 1000},
    weapon_nightstick = {ragdoll = 1000},
    weapon_wrench = {ragdoll = 1000},

    weapon_dagger = {bleed = 5},
    weapon_bottle = {bleed = 5},
    weapon_hatchet = {bleed = 5},
    weapon_knife = {bleed = 5},
    weapon_machete = {bleed = 5},
    weapon_switchblade = {bleed = 5},
    weapon_battleaxe = {bleed = 5},
    weapon_stone_hatchet = {bleed = 5},

    weapon_pistol = {bleed = 1, projectile = 1},
    weapon_pistol_mk2 = {bleed = 1, projectile = 1},
    weapon_combatpistol = {bleed = 1, projectile = 1},
    weapon_snspistol = {bleed = 1, projectile = 1},
    weapon_snspistol_mk2 = {bleed = 1, projectile = 1},
    weapon_vintagepistol = {bleed = 1, projectile = 1},
    weapon_ceramicpistol = {bleed = 1, projectile = 1},
    weapon_gadgetpistol = {bleed = 1, projectile = 1},
    weapon_pistol50 = {bleed = 1, projectile = 1},
    weapon_heavypistol = {bleed = 1, projectile = 1},
    weapon_marksmanpistol = {bleed = 1, projectile = 1},
    weapon_revolver = {bleed = 1, projectile = 1},
    weapon_revolver_mk2 = {bleed = 1, projectile = 1},
    weapon_doubleaction = {bleed = 1, projectile = 1},
    weapon_navyrevolver = {bleed = 1, projectile = 1},
    WEAPON_GLOCK19X2 = {bleed = 1, projectile = 1},
    WEAPON_BROWNING = {bleed = 1, projectile = 1},
    WEAPON_DP9 = {bleed = 1, projectile = 1},
    WEAPON_DEAGLE = {bleed = 1, projectile = 1},

    weapon_appistol = {bleed = 2, projectile = 1},
    weapon_microsmg = {bleed = 2, projectile = 1},
    weapon_machinepistol = {bleed = 2, projectile = 1},
    weapon_minismg = {bleed = 2, projectile = 1},
    weapon_smg = {bleed = 2, projectile = 1},
    weapon_smg_mk2 = {bleed = 2, projectile = 1},
    weapon_assaultsmg = {bleed = 2, projectile = 1},
    weapon_combatpdw = {bleed = 2, projectile = 1},
    weapon_compactrifle = {bleed = 2, projectile = 1},
    weapon_gusenberg = {bleed = 2, projectile = 1},
    WEAPON_MPX = {bleed = 2, projectile = 1},
    WEAPON_GLOCK18C = {bleed = 2, projectile = 1},
    WEAPON_P90FM = {bleed = 2, projectile = 1},
    WEAPON_DRACO = {bleed = 2, projectile = 1},
    WEAPON_SCORPIONEVO = {bleed = 2, projectile = 1},
    WEAPON_AKS74U = {bleed = 2, projectile = 1},
    WEAPON_MP9A = {bleed = 2, projectile = 1},

    WEAPON_ASVAL = {bleed = 3, projectile = 1},
    WEAPON_MK47FM = {bleed = 3, projectile = 1},
    WEAPON_MCXSPEAR = {bleed = 3, projectile = 1},
    WEAPON_AKM = {bleed = 3, projectile = 1},
    WEAPON_MDR = {bleed = 3, projectile = 1},
    WEAPON_SR25 = {bleed = 3, projectile = 1},
    WEAPON_50BEOWULF = {bleed = 3, projectile = 1},
    WEAPON_SCAR17FM = {bleed = 3, projectile = 1},
    WEAPON_M4A1FM = {bleed = 3, projectile = 1},
    weapon_assaultrifle = {bleed = 3, projectile = 1},
    weapon_assaultrifle_mk2 = {bleed = 3, projectile = 1},
    weapon_carbinerifle = {bleed = 3, projectile = 1},
    weapon_carbinerifle_mk2 = {bleed = 3, projectile = 1},
    weapon_advancedrifle = {bleed = 3, projectile = 1},
    weapon_specialcarbine = {bleed = 3, projectile = 1},
    weapon_specialcarbine_mk2 = {bleed = 3, projectile = 1},
    weapon_bullpuprifle = {bleed = 3, projectile = 1},
    weapon_bullpuprifle_mk2 = {bleed = 3, projectile = 1},
    weapon_militaryrifle = {bleed = 3, projectile = 1},

    weapon_pumpshotgun = {bleed = 3, projectile = 1},
    weapon_pumpshotgun_mk2 = {bleed = 3, projectile = 1},
    weapon_sawnoffshotgun = {bleed = 3, projectile = 1},
    weapon_assaultshotgun = {bleed = 3, projectile = 1},
    weapon_bullpupshotgun = {bleed = 3, projectile = 1},
    weapon_heavyshotgun = {bleed = 3, projectile = 1},
    weapon_dbshotgun = {bleed = 3, projectile = 1},
    weapon_autoshotgun = {bleed = 3, projectile = 1},
    weapon_combatshotgun = {bleed = 3, projectile = 1},

    weapon_mg = {bleed = 3, projectile = 1},
    weapon_combatmg = {bleed = 3, projectile = 1},
    weapon_combatmg_mk2 = {bleed = 3, projectile = 1},

    weapon_musket = {bleed = 3, projectile = 1},
    weapon_sniperrifle = {bleed = 3, projectile = 1},
    weapon_heavysniper = {bleed = 3, projectile = 1},
    weapon_heavysniper_mk2 = {bleed = 3, projectile = 1},
    weapon_marksmanrifle = {bleed = 3, projectile = 1},
    weapon_marksmanrifle_mk2 = {bleed = 3, projectile = 1},
    weapon_remotesniper = {bleed = 3, projectile = 1},
    weapon_assaultsniper = {bleed = 3, projectile = 1},

    weapon_minigun = {bleed = 2, projectile = 1}
}

local data = {}

for k,v in pairs(Status.DamageData) do
    local index = joaat(k)

    data[index] = v
    data[index].name = k

    Status.DamageData = data
end