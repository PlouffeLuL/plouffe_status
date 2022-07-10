local Utils = exports.plouffe_lib:Get("Utils")
local Callback = exports.plouffe_lib:Get("Callback")
local isDead = false
local doingYoga = false

local beds = {
    pillbox = {
        {model = 1631638868, coords = vec3(309.353638, -577.378296, 42.841770)},
        {model = 1631638868, coords = vec3(307.717072, -581.745544, 42.841770)},
        {model = 1631638868, coords = vec3(311.057465, -582.961304, 42.841770)},
        {model = 1631638868, coords = vec3(313.929718, -579.043823, 42.841770)},
        {model = 1631638868, coords = vec3(314.465454, -584.201721, 42.841770)},
        {model = 1631638868, coords = vec3(317.670563, -585.368347, 42.841770)},
        {model = 1631638868, coords = vec3(319.411957, -581.039246, 42.841770)},
        {model = 1631638868, coords = vec3(322.616882, -587.168518, 42.841770)},
        {model = 1631638868, coords = vec3(324.262848, -582.800903, 42.841770)}
    },

    paleto = {
        {model = 2117668672, coords = vec3(-258.734863, 6330.063965, 31.989470)},
        {model = 2117668672, coords = vec3(-256.419678, 6327.828125, 31.989470)},
        {model = 2117668672, coords = vec3(-262.456238, 6326.499023, 31.989470)},
        {model = 2117668672, coords = vec3(-260.113403, 6324.201172, 31.989470)},
        {model = 2117668672, coords = vec3(-257.729095, 6321.816895, 31.989470)}
    }
}

local cache = {
    ped = PlayerPedId()
}

local boneLabels = {
    {name = 'SKEL_ROOT', bone = 0x0, label = ''},
    {name = 'SKEL_Pelvis', bone = 0x2E28, label = 'Bassin'},
    {name = 'SKEL_L_Thigh', bone = 0xE39F, label = 'Cuisse gauche'},
    {name = 'SKEL_L_Calf', bone = 0xF9BB, label = 'Mollet gauche'},
    {name = 'SKEL_L_Foot', bone = 0x3779, label = 'Pied gauche'},
    {name = 'SKEL_L_Toe0', bone = 0x83C, label = 'Pied gauche'},
    {name = 'EO_L_Foot', bone = 0x84C5, label = 'Pied gauche'},
    {name = 'EO_L_Toe', bone = 0x68BD, label = 'Pied gauche'},
    {name = 'IK_L_Foot', bone = 0xFEDD, label = 'Pied gauche'},
    {name = 'PH_L_Foot', bone = 0xE175, label = 'Pied gauche'},
    {name = 'MH_L_Knee', bone = 0xB3FE, label = 'Genou gauche'},
    {name = 'SKEL_R_Thigh', bone = 0xCA72, label = 'Cuisse droit'},
    {name = 'SKEL_R_Calf', bone = 0x9000, label = 'Mollet droit'},
    {name = 'SKEL_R_Foot', bone = 0xCC4D, label = 'Pied droit'},
    {name = 'SKEL_R_Toe0', bone = 0x512D, label = 'Pied droit'},
    {name = 'EO_R_Foot', bone = 0x1096, label = 'Pied droit'},
    {name = 'EO_R_Toe', bone = 0x7163, label = 'Pied droit'},
    {name = 'IK_R_Foot', bone = 0x8AAE, label = 'Pied droit'},
    {name = 'PH_R_Foot', bone = 0x60E6, label = 'Pied droit'},
    {name = 'MH_R_Knee', bone = 0x3FCF, label = 'Genou droit'},
    {name = 'RB_L_ThighRoll', bone = 0x5C57, label = 'Cuisse gauche'},
    {name = 'RB_R_ThighRoll', bone = 0x192A, label = 'Cuisse droit'},
    {name = 'SKEL_Spine_Root', bone = 0xE0FD, label = 'Haut du corp'},
    {name = 'SKEL_Spine0', bone = 0x5C01, label = 'Haut du corp'},
    {name = 'SKEL_Spine1', bone = 0x60F0, label = 'Haut du corp'},
    {name = 'SKEL_Spine2', bone = 0x60F1, label = 'Haut du corp'},
    {name = 'SKEL_Spine3', bone = 0x60F2, label = 'Haut du corp'},
    {name = 'SKEL_L_Clavicle', bone = 0xFCD9, label = 'Dos'},
    {name = 'SKEL_L_UpperArm', bone = 0xB1C5, label = 'Bras gauche'},
    {name = 'SKEL_L_Forearm', bone = 0xEEEB, label = 'Avant bras gauche'},
    {name = 'SKEL_L_Hand', bone = 0x49D9, label = 'Main gauche'},
    {name = 'SKEL_L_Finger00', bone = 0x67F2, label = 'Main gauche'},
    {name = 'SKEL_L_Finger01', bone = 0xFF9, label = 'Main gauche'},
    {name = 'SKEL_L_Finger02', bone = 0xFFA, label = 'Main gauche'},
    {name = 'SKEL_L_Finger10', bone = 0x67F3, label = 'Main gauche'},
    {name = 'SKEL_L_Finger11', bone = 0x1049, label = 'Main gauche'},
    {name = 'SKEL_L_Finger12', bone = 0x104A, label = 'Main gauche'},
    {name = 'SKEL_L_Finger20', bone = 0x67F4, label = 'Main gauche'},
    {name = 'SKEL_L_Finger21', bone = 0x1059, label = 'Main gauche'},
    {name = 'SKEL_L_Finger22', bone = 0x105A, label = 'Main gauche'},
    {name = 'SKEL_L_Finger30', bone = 0x67F5, label = 'Main gauche'},
    {name = 'SKEL_L_Finger31', bone = 0x1029, label = 'Main gauche'},
    {name = 'SKEL_L_Finger32', bone = 0x102A, label = 'Main gauche'},
    {name = 'SKEL_L_Finger40', bone = 0x67F6, label = 'Main gauche'},
    {name = 'SKEL_L_Finger41', bone = 0x1039, label = 'Main gauche'},
    {name = 'SKEL_L_Finger42', bone = 0x103A, label = 'Main gauche'},
    {name = 'PH_L_Hand', bone = 0xEB95, label = 'Main gauche'},
    {name = 'IK_L_Hand', bone = 0x8CBD, label = 'Main gauche'},
    {name = 'RB_L_ForeArmRoll', bone = 0xEE4F, label = 'Avant bras gauche'},
    {name = 'RB_L_ArmRoll', bone = 0x1470, label = 'Bras gauche'},
    {name = 'MH_L_Elbow', bone = 0x58B7, label = 'Coude gauche'},
    {name = 'SKEL_R_Clavicle', bone = 0x29D2, label = 'Dos'},
    {name = 'SKEL_R_UpperArm', bone = 0x9D4D, label = 'Bras droit'},
    {name = 'SKEL_R_Forearm', bone = 0x6E5C, label = 'Avant bras droit'},
    {name = 'SKEL_R_Hand', bone = 0xDEAD, label = 'Main droite'},
    {name = 'SKEL_R_Finger00', bone = 0xE5F2, label = 'Main droite'},
    {name = 'SKEL_R_Finger01', bone = 0xFA10, label = 'Main droite'},
    {name = 'SKEL_R_Finger02', bone = 0xFA11, label = 'Main droite'},
    {name = 'SKEL_R_Finger10', bone = 0xE5F3, label = 'Main droite'},
    {name = 'SKEL_R_Finger11', bone = 0xFA60, label = 'Main droite'},
    {name = 'SKEL_R_Finger12', bone = 0xFA61, label = 'Main droite'},
    {name = 'SKEL_R_Finger20', bone = 0xE5F4, label = 'Main droite'},
    {name = 'SKEL_R_Finger21', bone = 0xFA70, label = 'Main droite'},
    {name = 'SKEL_R_Finger22', bone = 0xFA71, label = 'Main droite'},
    {name = 'SKEL_R_Finger30', bone = 0xE5F5, label = 'Main droite'},
    {name = 'SKEL_R_Finger31', bone = 0xFA40, label = 'Main droite'},
    {name = 'SKEL_R_Finger32', bone = 0xFA41, label = 'Main droite'},
    {name = 'SKEL_R_Finger40', bone = 0xE5F6, label = 'Main droite'},
    {name = 'SKEL_R_Finger41', bone = 0xFA50, label = 'Main droite'},
    {name = 'SKEL_R_Finger42', bone = 0xFA51, label = 'Main droite'},
    {name = 'PH_R_Hand', bone = 0x6F06, label = 'Main droite'},
    {name = 'IK_R_Hand', bone = 0x188E, label = 'Main droite'},
    {name = 'RB_R_ForeArmRoll', bone = 0xAB22, label = 'Avant bras droit'},
    {name = 'RB_R_ArmRoll', bone = 0x90FF, label = 'Avant bras droit'},
    {name = 'MH_R_Elbow', bone = 0xBB0, label = 'Coude droit'},
    {name = 'SKEL_Neck_1', bone = 0x9995, label = 'Cou'},
    {name = 'SKEL_Head', bone = 0x796E, label = 'Tête'},
    {name = 'IK_Head', bone = 0x322C, label = 'Tête'},
    {name = 'FACIAL_facialRoot', bone = 0xFE2C, label = 'Tête'},
    {name = 'FB_L_Brow_Out_000', bone = 0xE3DB, label = 'Tête'},
    {name = 'FB_L_Lid_Upper_000', bone = 0xB2B6, label = 'Tête'},
    {name = 'FB_L_Eye_000', bone = 0x62AC, label = 'Tête'},
    {name = 'FB_L_CheekBone_000', bone = 0x542E, label = 'Tête'},
    {name = 'FB_L_Lip_Corner_000', bone = 0x74AC, label = 'Tête'},
    {name = 'FB_R_Lid_Upper_000', bone = 0xAA10, label = 'Tête'},
    {name = 'FB_R_Eye_000', bone = 0x6B52, label = 'Tête'},
    {name = 'FB_R_CheekBone_000', bone = 0x4B88, label = 'Tête'},
    {name = 'FB_R_Brow_Out_000', bone = 0x54C, label = 'Tête'},
    {name = 'FB_R_Lip_Corner_000', bone = 0x2BA6, label = 'Tête'},
    {name = 'FB_Brow_Centre_000', bone = 0x9149, label = 'Tête'},
    {name = 'FB_UpperLipRoot_000', bone = 0x4ED2, label = 'Tête'},
    {name = 'FB_UpperLip_000', bone = 0xF18F, label = 'Tête'},
    {name = 'FB_L_Lip_Top_000', bone = 0x4F37, label = 'Tête'},
    {name = 'FB_R_Lip_Top_000', bone = 0x4537, label = 'Tête'},
    {name = 'FB_Jaw_000', bone = 0xB4A0, label = 'Tête'},
    {name = 'FB_LowerLipRoot_000', bone = 0x4324, label = 'Tête'},
    {name = 'FB_LowerLip_000', bone = 0x508F, label = 'Tête'},
    {name = 'FB_L_Lip_Bot_000', bone = 0xB93B, label = 'Tête'},
    {name = 'FB_R_Lip_Bot_000', bone = 0xC33B, label = 'Tête'},
    {name = 'FB_Tongue_000', bone = 0xB987, label = 'Tête'},
    {name = 'RB_Neck_1', bone = 0x8B93, label = 'Cou'},
    {name = 'SPR_L_Breast', bone = 0xFC8E, label = 'Torse'},
    {name = 'SPR_R_Breast', bone = 0x885F, label = 'Torse'},
    {name = 'IK_Root', bone = 0xDD1C, label = 'IK_Root ??'},
    {name = 'SKEL_Neck_2', bone = 0x5FD4, label = 'Cou'},
    {name = 'SKEL_Pelvis1', bone = 0xD003, label = 'Bassin'},
    {name = 'SKEL_PelvisRoot', bone = 0x45FC, label = 'Bassin'},
    {name = 'SKEL_SADDLE', bone = 0x9524, label = 'Bassin'},
    {name = 'MH_L_CalfBack', bone = 0x1013, label = 'Mollet gauche'},
    {name = 'MH_L_ThighBack', bone = 0x600D, label = 'Cuisse gauche'},
    {name = 'SM_L_Skirt', bone = 0xC419, label = 'SM_L_Skirt ??'},
    {name = 'MH_R_CalfBack', bone = 0xB013, label = 'Mollet droit'},
    {name = 'MH_R_ThighBack', bone = 0x51A3, label = 'Cuisse droite'},
    {name = 'SM_R_Skirt', bone = 0x7712, label = 'SM_R_Skirt ??'},
    {name = 'SM_M_BackSkirtRoll', bone = 0xDBB, label = 'SM_M_BackSkirtRoll'},
    {name = 'SM_L_BackSkirtRoll', bone = 0x40B2, label = 'SM_L_BackSkirtRoll'},
    {name = 'SM_R_BackSkirtRoll', bone = 0xC141, label = 'SM_R_BackSkirtRoll'},
    {name = 'SM_M_FrontSkirtRoll', bone = 0xCDBB, label = 'SM_M_FrontSkirtRoll'},
    {name = 'SM_L_FrontSkirtRoll', bone = 0x9B69, label = 'SM_L_FrontSkirtRoll'},
    {name = 'SM_R_FrontSkirtRoll', bone = 0x86F1, label = 'SM_R_FrontSkirtRoll'},
    {name = 'SM_CockNBalls_ROOT', bone = 0xC67D, label = 'Pinis'},
    {name = 'SM_CockNBalls', bone = 0x9D34, label = 'Pinis'},
    {name = 'MH_L_Finger00', bone = 0x8C63, label = 'Main gauche'},
    {name = 'MH_L_FingerBulge00', bone = 0x5FB8, label = 'Main gauche'},
    {name = 'MH_L_Finger10', bone = 0x8C53, label = 'Main gauche'},
    {name = 'MH_L_FingerTop00', bone = 0xA244, label = 'Main gauche'},
    {name = 'MH_L_HandSide', bone = 0xC78A, label = 'Main gauche'},
    {name = 'MH_Watch', bone = 0x2738, label = 'MH_Watch ??'},
    {name = 'MH_L_Sleeve', bone = 0x933C, label = 'Main gauche'},
    {name = 'MH_R_Finger00', bone = 0x2C63, label = 'Main droite'},
    {name = 'MH_R_FingerBulge00', bone = 0x69B8, label = 'Main droite'},
    {name = 'MH_R_Finger10', bone = 0x2C53, label = 'Main droite'},
    {name = 'MH_R_FingerTop00', bone = 0xEF4B, label = 'Main droite'},
    {name = 'MH_R_HandSide', bone = 0x68FB, label = 'Main droite'},
    {name = 'MH_R_Sleeve', bone = 0x92DC, label = 'Main droite'},
    {name = 'FACIAL_jaw', bone = 0xB21, label = 'Tête'},
    {name = 'FACIAL_underChin', bone = 0x8A95, label = 'Tête'},
    {name = 'FACIAL_L_underChin', bone = 0x234E, label = 'Tête'},
    {name = 'FACIAL_chin', bone = 0xB578, label = 'Tête'},
    {name = 'FACIAL_chinSkinBottom', bone = 0x98BC, label = 'Tête'},
    {name = 'FACIAL_L_chinSkinBottom', bone = 0x3E8F, label = 'Tête'},
    {name = 'FACIAL_R_chinSkinBottom', bone = 0x9E8F, label = 'Tête'},
    {name = 'FACIAL_tongueA', bone = 0x4A7C, label = 'Tête'},
    {name = 'FACIAL_tongueB', bone = 0x4A7D, label = 'Tête'},
    {name = 'FACIAL_tongueC', bone = 0x4A7E, label = 'Tête'},
    {name = 'FACIAL_tongueD', bone = 0x4A7F, label = 'Tête'},
    {name = 'FACIAL_tongueE', bone = 0x4A80, label = 'Tête'},
    {name = 'FACIAL_L_tongueE', bone = 0x35F2, label = 'Tête'},
    {name = 'FACIAL_R_tongueE', bone = 0x2FF2, label = 'Tête'},
    {name = 'FACIAL_L_tongueD', bone = 0x35F1, label = 'Tête'},
    {name = 'FACIAL_R_tongueD', bone = 0x2FF1, label = 'Tête'},
    {name = 'FACIAL_L_tongueC', bone = 0x35F0, label = 'Tête'},
    {name = 'FACIAL_R_tongueC', bone = 0x2FF0, label = 'Tête'},
    {name = 'FACIAL_L_tongueB', bone = 0x35EF, label = 'Tête'},
    {name = 'FACIAL_R_tongueB', bone = 0x2FEF, label = 'Tête'},
    {name = 'FACIAL_L_tongueA', bone = 0x35EE, label = 'Tête'},
    {name = 'FACIAL_R_tongueA', bone = 0x2FEE, label = 'Tête'},
    {name = 'FACIAL_chinSkinTop', bone = 0x7226, label = 'Tête'},
    {name = 'FACIAL_L_chinSkinTop', bone = 0x3EB3, label = 'Tête'},
    {name = 'FACIAL_chinSkinMid', bone = 0x899A, label = 'Tête'},
    {name = 'FACIAL_L_chinSkinMid', bone = 0x4427, label = 'Tête'},
    {name = 'FACIAL_L_chinSide', bone = 0x4A5E, label = 'Tête'},
    {name = 'FACIAL_R_chinSkinMid', bone = 0xF5AF, label = 'Tête'},
    {name = 'FACIAL_R_chinSkinTop', bone = 0xF03B, label = 'Tête'},
    {name = 'FACIAL_R_chinSide', bone = 0xAA5E, label = 'Tête'},
    {name = 'FACIAL_R_underChin', bone = 0x2BF4, label = 'Tête'},
    {name = 'FACIAL_L_lipLowerSDK', bone = 0xB9E1, label = 'Tête'},
    {name = 'FACIAL_L_lipLowerAnalog', bone = 0x244A, label = 'Tête'},
    {name = 'FACIAL_L_lipLowerThicknessV', bone = 0xC749, label = 'Tête'},
    {name = 'FACIAL_L_lipLowerThicknessH', bone = 0xC67B, label = 'Tête'},
    {name = 'FACIAL_lipLowerSDK', bone = 0x7285, label = 'Tête'},
    {name = 'FACIAL_lipLowerAnalog', bone = 0xD97B, label = 'Tête'},
    {name = 'FACIAL_lipLowerThicknessV', bone = 0xC5BB, label = 'Tête'},
    {name = 'FACIAL_lipLowerThicknessH', bone = 0xC5ED, label = 'Tête'},
    {name = 'FACIAL_R_lipLowerSDK', bone = 0xA034, label = 'Tête'},
    {name = 'FACIAL_R_lipLowerAnalog', bone = 0xC2D9, label = 'Tête'},
    {name = 'FACIAL_R_lipLowerThicknessV', bone = 0xC6E9, label = 'Tête'},
    {name = 'FACIAL_R_lipLowerThicknessH', bone = 0xC6DB, label = 'Tête'},
    {name = 'FACIAL_nose', bone = 0x20F1, label = 'Tête'},
    {name = 'FACIAL_L_nostril', bone = 0x7322, label = 'Tête'},
    {name = 'FACIAL_L_nostrilThickness', bone = 0xC15F, label = 'Tête'},
    {name = 'FACIAL_noseLower', bone = 0xE05A, label = 'Tête'},
    {name = 'FACIAL_L_noseLowerThickness', bone = 0x79D5, label = 'Tête'},
    {name = 'FACIAL_R_noseLowerThickness', bone = 0x7975, label = 'Tête'},
    {name = 'FACIAL_noseTip', bone = 0x6A60, label = 'Tête'},
    {name = 'FACIAL_R_nostril', bone = 0x7922, label = 'Tête'},
    {name = 'FACIAL_R_nostrilThickness', bone = 0x36FF, label = 'Tête'},
    {name = 'FACIAL_noseUpper', bone = 0xA04F, label = 'Tête'},
    {name = 'FACIAL_L_noseUpper', bone = 0x1FB8, label = 'Tête'},
    {name = 'FACIAL_noseBridge', bone = 0x9BA3, label = 'Tête'},
    {name = 'FACIAL_L_nasolabialFurrow', bone = 0x5ACA, label = 'Tête'},
    {name = 'FACIAL_L_nasolabialBulge', bone = 0xCD78, label = 'Tête'},
    {name = 'FACIAL_L_cheekLower', bone = 0x6907, label = 'Tête'},
    {name = 'FACIAL_L_cheekLowerBulge1', bone = 0xE3FB, label = 'Tête'},
    {name = 'FACIAL_L_cheekLowerBulge2', bone = 0xE3FC, label = 'Tête'},
    {name = 'FACIAL_L_cheekInner', bone = 0xE7AB, label = 'Tête'},
    {name = 'FACIAL_L_cheekOuter', bone = 0x8161, label = 'Tête'},
    {name = 'FACIAL_L_eyesackLower', bone = 0x771B, label = 'Tête'},
    {name = 'FACIAL_L_eyeball', bone = 0x1744, label = 'Tête'},
    {name = 'FACIAL_L_eyelidLower', bone = 0x998C, label = 'Tête'},
    {name = 'FACIAL_L_eyelidLowerOuterSDK', bone = 0xFE4C, label = 'Tête'},
    {name = 'FACIAL_L_eyelidLowerOuterAnalog', bone = 0xB9AA, label = 'Tête'},
    {name = 'FACIAL_L_eyelashLowerOuter', bone = 0xD7F6, label = 'Tête'},
    {name = 'FACIAL_L_eyelidLowerInnerSDK', bone = 0xF151, label = 'Tête'},
    {name = 'FACIAL_L_eyelidLowerInnerAnalog', bone = 0x8242, label = 'Tête'},
    {name = 'FACIAL_L_eyelashLowerInner', bone = 0x4CCF, label = 'Tête'},
    {name = 'FACIAL_L_eyelidUpper', bone = 0x97C1, label = 'Tête'},
    {name = 'FACIAL_L_eyelidUpperOuterSDK', bone = 0xAF15, label = 'Tête'},
    {name = 'FACIAL_L_eyelidUpperOuterAnalog', bone = 0x67FA, label = 'Tête'},
    {name = 'FACIAL_L_eyelashUpperOuter', bone = 0x27B7, label = 'Tête'},
    {name = 'FACIAL_L_eyelidUpperInnerSDK', bone = 0xD341, label = 'Tête'},
    {name = 'FACIAL_L_eyelidUpperInnerAnalog', bone = 0xF092, label = 'Tête'},
    {name = 'FACIAL_L_eyelashUpperInner', bone = 0x9B1F, label = 'Tête'},
    {name = 'FACIAL_L_eyesackUpperOuterBulge', bone = 0xA559, label = 'Tête'},
    {name = 'FACIAL_L_eyesackUpperInnerBulge', bone = 0x2F2A, label = 'Tête'},
    {name = 'FACIAL_L_eyesackUpperOuterFurrow', bone = 0xC597, label = 'Tête'},
    {name = 'FACIAL_L_eyesackUpperInnerFurrow', bone = 0x52A7, label = 'Tête'},
    {name = 'FACIAL_forehead', bone = 0x9218, label = 'Tête'},
    {name = 'FACIAL_L_foreheadInner', bone = 0x843, label = 'Tête'},
    {name = 'FACIAL_L_foreheadInnerBulge', bone = 0x767C, label = 'Tête'},
    {name = 'FACIAL_L_foreheadOuter', bone = 0x8DCB, label = 'Tête'},
    {name = 'FACIAL_skull', bone = 0x4221, label = 'Tête'},
    {name = 'FACIAL_foreheadUpper', bone = 0xF7D6, label = 'Tête'},
    {name = 'FACIAL_L_foreheadUpperInner', bone = 0xCF13, label = 'Tête'},
    {name = 'FACIAL_L_foreheadUpperOuter', bone = 0x509B, label = 'Tête'},
    {name = 'FACIAL_R_foreheadUpperInner', bone = 0xCEF3, label = 'Tête'},
    {name = 'FACIAL_R_foreheadUpperOuter', bone = 0x507B, label = 'Tête'},
    {name = 'FACIAL_L_temple', bone = 0xAF79, label = 'Tête'},
    {name = 'FACIAL_L_ear', bone = 0x19DD, label = 'Tête'},
    {name = 'FACIAL_L_earLower', bone = 0x6031, label = 'Tête'},
    {name = 'FACIAL_L_masseter', bone = 0x2810, label = 'Tête'},
    {name = 'FACIAL_L_jawRecess', bone = 0x9C7A, label = 'Tête'},
    {name = 'FACIAL_L_cheekOuterSkin', bone = 0x14A5, label = 'Tête'},
    {name = 'FACIAL_R_cheekLower', bone = 0xF367, label = 'Tête'},
    {name = 'FACIAL_R_cheekLowerBulge1', bone = 0x599B, label = 'Tête'},
    {name = 'FACIAL_R_cheekLowerBulge2', bone = 0x599C, label = 'Tête'},
    {name = 'FACIAL_R_masseter', bone = 0x810, label = 'Tête'},
    {name = 'FACIAL_R_jawRecess', bone = 0x93D4, label = 'Tête'},
    {name = 'FACIAL_R_ear', bone = 0x1137, label = 'Tête'},
    {name = 'FACIAL_R_earLower', bone = 0x8031, label = 'Tête'},
    {name = 'FACIAL_R_eyesackLower', bone = 0x777B, label = 'Tête'},
    {name = 'FACIAL_R_nasolabialBulge', bone = 0xD61E, label = 'Tête'},
    {name = 'FACIAL_R_cheekOuter', bone = 0xD32, label = 'Tête'},
    {name = 'FACIAL_R_cheekInner', bone = 0x737C, label = 'Tête'},
    {name = 'FACIAL_R_noseUpper', bone = 0x1CD6, label = 'Tête'},
    {name = 'FACIAL_R_foreheadInner', bone = 0xE43, label = 'Tête'},
    {name = 'FACIAL_R_foreheadInnerBulge', bone = 0x769C, label = 'Tête'},
    {name = 'FACIAL_R_foreheadOuter', bone = 0x8FCB, label = 'Tête'},
    {name = 'FACIAL_R_cheekOuterSkin', bone = 0xB334, label = 'Tête'},
    {name = 'FACIAL_R_eyesackUpperInnerFurrow', bone = 0x9FAE, label = 'Tête'},
    {name = 'FACIAL_R_eyesackUpperOuterFurrow', bone = 0x140F, label = 'Tête'},
    {name = 'FACIAL_R_eyesackUpperInnerBulge', bone = 0xA359, label = 'Tête'},
    {name = 'FACIAL_R_eyesackUpperOuterBulge', bone = 0x1AF9, label = 'Tête'},
    {name = 'FACIAL_R_nasolabialFurrow', bone = 0x2CAA, label = 'Tête'},
    {name = 'FACIAL_R_temple', bone = 0xAF19, label = 'Tête'},
    {name = 'FACIAL_R_eyeball', bone = 0x1944, label = 'Tête'},
    {name = 'FACIAL_R_eyelidUpper', bone = 0x7E14, label = 'Tête'},
    {name = 'FACIAL_R_eyelidUpperOuterSDK', bone = 0xB115, label = 'Tête'},
    {name = 'FACIAL_R_eyelidUpperOuterAnalog', bone = 0xF25A, label = 'Tête'},
    {name = 'FACIAL_R_eyelashUpperOuter', bone = 0xE0A, label = 'Tête'},
    {name = 'FACIAL_R_eyelidUpperInnerSDK', bone = 0xD541, label = 'Tête'},
    {name = 'FACIAL_R_eyelidUpperInnerAnalog', bone = 0x7C63, label = 'Tête'},
    {name = 'FACIAL_R_eyelashUpperInner', bone = 0x8172, label = 'Tête'},
    {name = 'FACIAL_R_eyelidLower', bone = 0x7FDF, label = 'Tête'},
    {name = 'FACIAL_R_eyelidLowerOuterSDK', bone = 0x1BD, label = 'Tête'},
    {name = 'FACIAL_R_eyelidLowerOuterAnalog', bone = 0x457B, label = 'Tête'},
    {name = 'FACIAL_R_eyelashLowerOuter', bone = 0xBE49, label = 'Tête'},
    {name = 'FACIAL_R_eyelidLowerInnerSDK', bone = 0xF351, label = 'Tête'},
    {name = 'FACIAL_R_eyelidLowerInnerAnalog', bone = 0xE13, label = 'Tête'},
    {name = 'FACIAL_R_eyelashLowerInner', bone = 0x3322, label = 'Tête'},
    {name = 'FACIAL_L_lipUpperSDK', bone = 0x8F30, label = 'Tête'},
    {name = 'FACIAL_L_lipUpperAnalog', bone = 0xB1CF, label = 'Tête'},
    {name = 'FACIAL_L_lipUpperThicknessH', bone = 0x37CE, label = 'Tête'},
    {name = 'FACIAL_L_lipUpperThicknessV', bone = 0x38BC, label = 'Tête'},
    {name = 'FACIAL_lipUpperSDK', bone = 0x1774, label = 'Tête'},
    {name = 'FACIAL_lipUpperAnalog', bone = 0xE064, label = 'Tête'},
    {name = 'FACIAL_lipUpperThicknessH', bone = 0x7993, label = 'Tête'},
    {name = 'FACIAL_lipUpperThicknessV', bone = 0x7981, label = 'Tête'},
    {name = 'FACIAL_L_lipCornerSDK', bone = 0xB1C, label = 'Tête'},
    {name = 'FACIAL_L_lipCornerAnalog', bone = 0xE568, label = 'Tête'},
    {name = 'FACIAL_L_lipCornerThicknessUpper', bone = 0x7BC, label = 'Tête'},
    {name = 'FACIAL_L_lipCornerThicknessLower', bone = 0xDD42, label = 'Tête'},
    {name = 'FACIAL_R_lipUpperSDK', bone = 0x7583, label = 'Tête'},
    {name = 'FACIAL_R_lipUpperAnalog', bone = 0x51CF, label = 'Tête'},
    {name = 'FACIAL_R_lipUpperThicknessH', bone = 0x382E, label = 'Tête'},
    {name = 'FACIAL_R_lipUpperThicknessV', bone = 0x385C, label = 'Tête'},
    {name = 'FACIAL_R_lipCornerSDK', bone = 0xB3C, label = 'Tête'},
    {name = 'FACIAL_R_lipCornerAnalog', bone = 0xEE0E, label = 'Tête'},
    {name = 'FACIAL_R_lipCornerThicknessUpper', bone = 0x54C3, label = 'Tête'},
    {name = 'FACIAL_R_lipCornerThicknessLower', bone = 0x2BBA, label = 'Tête'},
    -- Nope section
    {name = 'MH_MulletRoot', bone = 0x3E73, label = 'Tête'},
    {name = 'MH_MulletScaler', bone = 0xA1C2, label = 'Tête'},
    {name = 'MH_Hair_Scale', bone = 0xC664, label = 'Tête'},
    {name = 'MH_Hair_Crown', bone = 0x1675, label = 'Tête'},
    {name = 'SM_Torch', bone = 0x8D6, label = 'Tête'},
    {name = 'FX_Light', bone = 0x8959, label = 'Tête'},
    {name = 'FX_Light_Scale', bone = 0x5038, label = 'Tête'},
    {name = 'FX_Light_Switch', bone = 0xE18E, label = 'Tête'},
    {name = 'BagRoot', bone = 0xAD09, label = 'Tête'},
    {name = 'BagPivotROOT', bone = 0xB836, label = 'Tête'},
    {name = 'BagPivot', bone = 0x4D11, label = 'Tête'},
    {name = 'BagBody', bone = 0xAB6D, label = 'Tête'},
    {name = 'BagBone_R', bone = 0x937, label = 'Tête'},
    {name = 'BagBone_L', bone = 0x991, label = 'Tête'},
    {name = 'SM_LifeSaver_Front', bone = 0x9420, label = 'Tête'},
    {name = 'SM_R_Pouches_ROOT', bone = 0x2962, label = 'Tête'},
    {name = 'SM_R_Pouches', bone = 0x4141, label = 'Tête'},
    {name = 'SM_L_Pouches_ROOT', bone = 0x2A02, label = 'Tête'},
    {name = 'SM_L_Pouches', bone = 0x4B41, label = 'Tête'},
    {name = 'SM_Suit_Back_Flapper', bone = 0xDA2D, label = 'Tête'},
    {name = 'SPR_CopRadio', bone = 0x8245, label = 'Tête'},
    {name = 'SM_LifeSaver_Back', bone = 0x2127, label = 'Tête'},
    {name = 'MH_BlushSlider', bone = 0xA0CE, label = 'Tête'},
    {name = 'SKEL_Tail_01', bone = 0x347, label = 'Tête'},
    {name = 'SKEL_Tail_02', bone = 0x348, label = 'Tête'},
    {name = 'MH_L_Concertina_B', bone = 0xC988, label = 'Tête'},
    {name = 'MH_L_Concertina_A', bone = 0xC987, label = 'Tête'},
    {name = 'MH_R_Concertina_B', bone = 0xC8E8, label = 'Tête'},
    {name = 'MH_R_Concertina_A', bone = 0xC8E7, label = 'Tête'},
    {name = 'MH_L_ShoulderBladeRoot', bone = 0x8711, label = 'Tête'},
    {name = 'MH_L_ShoulderBlade', bone = 0x4EAF, label = 'Tête'},
    {name = 'MH_R_ShoulderBladeRoot', bone = 0x3A0A, label = 'Tête'},
    {name = 'MH_R_ShoulderBlade', bone = 0x54AF, label = 'Tête'},
    {name = 'FB_R_Ear_000', bone = 0x6CDF, label = 'Tête'},
    {name = 'SPR_R_Ear', bone = 0x63B6, label = 'Tête'},
    {name = 'FB_L_Ear_000', bone = 0x6439, label = 'Tête'},
    {name = 'SPR_L_Ear', bone = 0x5B10, label = 'Tête'},
    {name = 'FB_TongueA_000', bone = 0x4206, label = 'Tête'},
    {name = 'FB_TongueB_000', bone = 0x4207, label = 'Tête'},
    {name = 'FB_TongueC_000', bone = 0x4208, label = 'Tête'},
    {name = 'SKEL_L_Toe1', bone = 0x1D6B, label = 'Tête'},
    {name = 'SKEL_R_Toe1', bone = 0xB23F, label = 'Tête'},
    {name = 'SKEL_Tail_03', bone = 0x349, label = 'Tête'},
    {name = 'SKEL_Tail_04', bone = 0x34A, label = 'Tête'},
    {name = 'SKEL_Tail_05', bone = 0x34B, label = 'Tête'},
    {name = 'SPR_Gonads_ROOT', bone = 0xBFDE, label = 'Tête'},
    {name = 'SPR_Gonads', bone = 0x1C00, label = 'Tête'},
    {name = 'FB_L_Brow_Out_001', bone = 0xE3DB, label = 'Tête'},
    {name = 'FB_L_Lid_Upper_001', bone = 0xB2B6, label = 'Tête'},
    {name = 'FB_L_Eye_001', bone = 0x62AC, label = 'Tête'},
    {name = 'FB_L_CheekBone_001', bone = 0x542E, label = 'Tête'},
    {name = 'FB_L_Lip_Corner_001', bone = 0x74AC, label = 'Tête'},
    {name = 'FB_R_Lid_Upper_001', bone = 0xAA10, label = 'Tête'},
    {name = 'FB_R_Eye_001', bone = 0x6B52, label = 'Tête'},
    {name = 'FB_R_CheekBone_001', bone = 0x4B88, label = 'Tête'},
    {name = 'FB_R_Brow_Out_001', bone = 0x54C, label = 'Tête'},
    {name = 'FB_R_Lip_Corner_001', bone = 0x2BA6, label = 'Tête'},
    {name = 'FB_Brow_Centre_001', bone = 0x9149, label = 'Tête'},
    {name = 'FB_UpperLipRoot_001', bone = 0x4ED2, label = 'Tête'},
    {name = 'FB_UpperLip_001', bone = 0xF18F, label = 'Tête'},
    {name = 'FB_L_Lip_Top_001', bone = 0x4F37, label = 'Tête'},
    {name = 'FB_R_Lip_Top_001', bone = 0x4537, label = 'Tête'},
    {name = 'FB_Jaw_001', bone = 0xB4A0, label = 'Tête'},
    {name = 'FB_LowerLipRoot_001', bone = 0x4324, label = 'Tête'},
    {name = 'FB_LowerLip_001', bone = 0x508F, label = 'Tête'},
    {name = 'FB_L_Lip_Bot_001', bone = 0xB93B, label = 'Tête'},
    {name = 'FB_R_Lip_Bot_001', bone = 0xC33B, label = 'Tête'},
    {name = 'FB_Tongue_001', bone = 0xB987, label = 'Tête'}
}

local seatsAnim = {
    ["-1"] = {dict = "veh@std@ds@idle_duck", anim = "sit"},
    ["0"] = {dict = "veh@std@ps@idle_duck", anim = "sit"},
    ["1"] = {dict = "veh@std@rps@idle_duck", anim = "sit"},
    ["2"] = {dict = "veh@std@rps@idle_duck", anim = "sit"},
    ["3"] = {dict = "veh@std@rps@idle_duck", anim = "sit"},
    ["4"] = {dict = "veh@std@rps@idle_duck", anim = "sit"},
    ["5"] = {dict = "veh@std@rps@idle_duck", anim = "sit"},
    ["6"] = {dict = "veh@std@rps@idle_duck", anim = "sit"},
    ["7"] = {dict = "veh@std@rps@idle_duck", anim = "sit"},
    ["8"] = {dict = "veh@std@rps@idle_duck", anim = "sit"},
    ["9"] = {dict = "veh@std@rps@idle_duck", anim = "sit"},
    ["10"] = {dict = "veh@std@rps@idle_duck", anim = "sit"},
    ["11"] = {dict = "veh@std@rps@idle_duck", anim = "sit"},
    ["12"] = {dict = "veh@std@rps@idle_duck", anim = "sit"},
    ["13"] = {dict = "veh@std@rps@idle_duck", anim = "sit"},
    ["14"] = {dict = "veh@std@rps@idle_duck", anim = "sit"},
    ["15"] = {dict = "veh@std@rps@idle_duck", anim = "sit"},
    ["16"] = {dict = "veh@std@rps@idle_duck", anim = "sit"},
    ["default"] = {dict = "dead", anim = "dead_a"}
}

local consumables = setmetatable({
    food ={
        anim = {dict = "mp_player_inteat@burger", clip = "mp_player_int_eat_burger"},
        megaburger = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_cs_burger_01",
            pos = {x = 0.0, y = 0.0, z = 0.0},
            rot = {x = 0.0, y = 0.0, z = 0.0}
        },
        cheeseburger = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_cs_burger_01",
            pos = {x = 0.0, y = 0.0, z = 0.0},
            rot = {x = 0.0, y = 0.0, z = 0.0}
        },
        burger = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_cs_burger_01",
            pos = {x = 0.0, y = 0.0, z = 0.0},
            rot = {x = 0.0, y = 0.0, z = 0.0}
        },
        fries = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_food_bs_chips",
            pos = {x = 0.08, y = 0.0, z = 0.0},
            rot = {x = -20.0, y = -90.0, z = 90.0}
        },
        poutine = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_food_bs_chips",
            pos = {x = 0.08, y = 0.0, z = 0.0},
            rot = {x = -20.0, y = -90.0, z = 90.0}
        },
        sandwich = {
            data = {
                {key = "Hunger", value = 200}
            },
            bone = 60309,
            model = "prop_sandwich_01",
            pos = {x = 0.0, y = 0.0, z = 0.0},
            rot = {x = 0.0, y = 0.0, z = 0.0}
        },
        chocolate = {
            data = {
                {key = "Hunger", value = 150}
            },
            bone = 60309,
            model = "ng_proc_food_ornge1a",
            pos = {x = 0.0, y = 0.0, z = 0.0},
            rot = {x = 0.0, y = 0.0, z = 0.0}
        },
        chipscheese = {
            data = {
                {key = "Hunger", value = 150}
            },
            bone = 60309,
            model = "v_ret_ml_chips4",
            pos = {x = 0.0, y = 0.0, z = 0.0},
            rot = {x = 0.0, y = 0.0, z = 0.0}
        },
        chipshabanero = {
            data = {
                {key = "Hunger", value = 150}
            },
            bone = 60309,
            model = "v_ret_ml_chips2",
            pos = {x = 0.0, y = 0.0, z = 0.0},
            rot = {x = 0.0, y = 0.0, z = 0.0}
        },
        chipsribs = {
            data = {
                {key = "Hunger", value = 150}
            },
            bone = 60309,
            model = "v_ret_ml_chips1",
            pos = {x = 0.0, y = 0.0, z = 0.0},
            rot = {x = 0.0, y = 0.0, z = 0.0}
        },
        chipssalt = {
            data = {
                {key = "Hunger", value = 150}
            },
            bone = 60309,
            model = "v_ret_ml_chips3",
            pos = {x = 0.0, y = 0.0, z = 0.0},
            rot = {x = 0.0, y = 0.0, z = 0.0}
        },

        chicken_bucket = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_cs_burger_01",
            pos = {x = 0.0, y = 0.0, z = 0.0},
            rot = {x = 0.0, y = 0.0, z = 0.0}
        },
        chicken_popcorn = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_cs_burger_01",
            pos = {x = 0.0, y = 0.0, z = 0.0},
            rot = {x = 0.0, y = 0.0, z = 0.0}
        },
        chicken_rings = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_cs_burger_01",
            pos = {x = 0.0, y = 0.0, z = 0.0},
            rot = {x = 0.0, y = 0.0, z = 0.0}
        },
        cluckin_fries = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_food_bs_chips",
            pos = {x = 0.08, y = 0.0, z = 0.0},
            rot = {x = -20.0, y = -90.0, z = 90.0}
        },

        hotdog = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_cs_hotdog_01",
            pos = {x = 0.0, y = 0.0, z = -0.01},
            rot = {x = 0.0, y = 0.0, z = 90.0}
        },
        hotdog_michigan = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_cs_hotdog_01",
            pos = {x = 0.0, y = 0.0, z = -0.01},
            rot = {x = 0.0, y = 0.0, z = 90.0}
        },
        sousmarin = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_sandwich_01",
            pos = {x = 0.0, y = 0.0, z = -0.01},
            rot = {x = 0.0, y = 0.0, z = 90.0}
        },
        poutine_bacon = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_food_cb_chips",
            pos = {x = 0.08, y = 0.0, z = 0.0},
            rot = {x =  -20.0, y = -90.0, z = 90.0}
        },
        rondelle_dognion = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_food_cb_chips",
            pos = {x = 0.08, y = 0.0, z = 0.0},
            rot = {x = -20.0, y = -90.0, z = 90.0}
        },

        tacos = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_taco_01",
            pos = {x = 0.0, y = 0.0, z = -0.01},
            rot = {x = 0.0, y = 0.0, z = 90.0}
        },
        quesadillas = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_taco_01",
            pos = {x = 0.0, y = 0.0, z = -0.01},
            rot = {x = 0.0, y = 0.0, z = 90.0}
        },
        burritos = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_taco_01",
            pos = {x = 0.0, y = 0.0, z = -0.01},
            rot = {x = 0.0, y = 0.0, z = 90.0}
        },
        tortas = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_taco_01",
            pos = {x = 0.0, y = 0.0, z = -0.01},
            rot = {x = 0.0, y = 0.0, z = 90.0}
        },
        nachos = {
            data = {
                {key = "Hunger", value = 450}
            },
            bone = 60309,
            model = "prop_taco_01",
            pos = {x = 0.0, y = 0.0, z = -0.01},
            rot = {x = 0.0, y = 0.0, z = 90.0}
        },
    },

    drinks = {
        anim = {dict = "amb@world_human_drinking@coffee@male@idle_a", clip = "idle_c"},
        sevenup = {
            data = {
                {key = "Thirst", value = 450}
            },
            bone = 28422,
            model = "prop_food_bs_juice01",
            pos = {x = 0.0, y = 0.0, z = -0.10},
            rot = {x = 0.0, y = 0.0, z = 90.0}
        },
        pepsi = {
            data = {
                {key = "Thirst", value = 450}
            },
            bone = 28422,
            model = "prop_food_bs_juice03",
            pos = {x = 0.0, y = 0.0, z = -0.10},
            rot = {x = 0.0, y = 0.0, z = 90.0}
        },
        diet_pepsi = {
            data = {
                {key = "Thirst", value = 450}
            },
            bone = 28422,
            model = "prop_food_cb_juice01",
            pos = {x = 0.0, y = 0.0, z = -0.10},
            rot = {x = 0.0, y = 0.0, z = 90.0}
        },
        root_beer = {
            data = {
                {key = "Thirst", value = 450}
            },
            bone = 28422,
            model = "prop_food_bs_juice01",
            pos = {x = 0.0, y = 0.0, z = -0.10},
            rot = {x = 0.0, y = 0.0, z = 90.0}
        },
        ice_tea = {
            data = {
                {key = "Thirst", value = 450}
            },
            bone = 28422,
            model = "prop_food_bs_juice01",
            pos = {x = 0.0, y = 0.0, z = -0.10},
            rot = {x = 0.0, y = 0.0, z = 90.0}
        },
        cluckin_drink = {
            data = {
                {key = "Thirst", value = 450}
            },
            bone = 28422,
            model = "prop_food_bs_juice01",
            pos = {x = 0.0, y = 0.0, z = -0.10},
            rot = {x = 0.0, y = 0.0, z = 90.0}
        },
        soda = {
            data = {
                {key = "Thirst", value = 450}
            },
            bone = 28422,
            model = "prop_ld_can_01",
            pos = {x = 0.02, y = 0.0, z = -0.0},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        drpepper = {
            data = {
                {key = "Thirst", value = 450}
            },
            bone = 28422,
            model = "prop_ecola_can",
            pos = {x = 0.02, y = 0.0, z = -0.0},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        limonade = {
            data = {
                {key = "Thirst", value = 450}
            },
            bone = 28422,
            model = "prop_ld_can_01",
            pos = {x = 0.02, y = 0.0, z = -0.0},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        energy = {
            data = {
                {key = "Thirst", value = 450},
                {key = "Fatigue", value = -300}
            },
            bone = 28422,
            model = "prop_energy_drink",
            pos = {x = 0.02, y = 0.0, z = -0.0},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        jusfruit = {
            data = {
                {key = "Thirst", value = 450}
            },
            bone = 28422,
            model = "prop_energy_drink",
            pos = {x = 0.02, y = 0.0, z = -0.0},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        water = {
            data = {
                {key = "Thirst", value = 250}
            },
            bone = 28422,
            model = "prop_ld_flow_bottle",
            pos = {x = 0.02, y = 0.0, z = -0.0},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        milk = {
            data = {
                {key = "Thirst", value = 250},
                {key = "Drunk", value = -150}
            },
            bone = 28422,
            model = "prop_cs_milk_01",
            pos = {x = 0.02, y = 0.0, z = -0.0},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        coffe = {
            data = {
                {key = "Thirst", value = 100},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = -100}
            },
            bone = 28422,
            model = "prop_fib_coffee",
            pos = {x = 0.02, y = 0.0, z = -0.0},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        }
    },

    alchool = {
        anim = {dict = "amb@world_human_drinking@coffee@male@idle_a", clip = "idle_c"},
        beer = {
            data = {
                {key = "Drunk", value = 100},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_cs_beer_bot_02",
            pos = {x = 0.02, y = 0.0, z = -0.02},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        grand_cru = {
            data = {
                {key = "Drunk", value = 600},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_champ_01a",
            pos = {x = 0.0, y = 0.0, z = -0.18},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        jager = {
            data = {
                {key = "Drunk", value = 600},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_bottle_brandy",
            pos = {x = 0.0, y = 0.0, z = -0.18},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        vodka = {
            data = {
                {key = "Drunk", value = 500},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_vodka_bottle",
            pos = {x = 0.0, y = 0.0, z = -0.35},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        rhum = {
            data = {
                {key = "Drunk", value = 600},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_rum_bottle",
            pos = {x = 0.0, y = 0.0, z = -0.20},
            rot = {x = 0.0, y = 0.0, z = 250.0}
        },
        whisky = {
            data = {
                {key = "Drunk", value = 600},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_whiskey_bottle",
            pos = {x = 0.0, y = 0.0, z = -0.20},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        tequila = {
            data = {
                {key = "Drunk", value = 600},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_tequila_bottle",
            pos = {x = 0.02, y = 0.0, z = -0.25},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        martini = {
            data = {
                {key = "Drunk", value = 450},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_vodka_bottle",
            pos = {x = 0.02, y = 0.0, z = -0.25},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },

        jagerbomb = {
            data = {
                {key = "Drunk", value = 150},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_drink_whisky",
            pos = {x = 0.02, y = 0.0, z = -0.05},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        golem = {
            data = {
                {key = "Drunk", value = 125},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_tequsunrise",
            pos = {x = 0.02, y = 0.0, z = -0.08},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        whiskycoca = {
            data = {
                {key = "Drunk", value = 135},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_drink_whisky",
            pos = {x = 0.02, y = 0.0, z = -0.05},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        vodkaenergy = {
            data = {
                {key = "Drunk", value = 135},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_drink_whisky",
            pos = {x = 0.02, y = 0.0, z = -0.05},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        vodkafruit = {
            data = {
                {key = "Drunk", value = 135},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_pinacolada",
            pos = {x = 0.02, y = 0.0, z = -0.12},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        teqpaf = {
            data = {
                {key = "Drunk", value = 135},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_daiquiri",
            pos = {x = 0.02, y = 0.0, z = -0.15},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        rhumcoca = {
            data = {
                {key = "Drunk", value = 135},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_drink_whisky",
            pos = {x = 0.02, y = 0.0, z = -0.05},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        mojito = {
            data = {
                {key = "Drunk", value = 135},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_daiquiri",
            pos = {x = 0.02, y = 0.0, z = -0.15},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
        jagercerbere = {
            data = {
                {key = "Drunk", value = 135},
                {key = "Stress", value = -100},
                {key = "Fatigue", value = 50}
            },
            bone = 28422,
            model = "prop_daiquiri",
            pos = {x = 0.02, y = 0.0, z = -0.15},
            rot = {x = 0.0, y = 0.0, z = 275.0}
        },
    }
},{
    __call = function(self, type, item)
        return self[type].anim, self[type][item]
    end
})

local timeOfDead = 0
local giveupDelay = 1000 * 60 * 10
local respawnDelay = 1000 * 60 * 15

local uiShown = false

local last_stress_blur = 0

local tickInterval = {min = 10000, max = 30000}

local lastInjurie = 0
local injurieInterval = 1000 * 5

local Await = Citizen.Await

local GetPedLastDamageBone = GetPedLastDamageBone
local SetPedMovementClipset = SetPedMovementClipset
local ApplyDamageToPed = ApplyDamageToPed
local GetGameTimer = GetGameTimer
local PlayerPedId = PlayerPedId
local IsPedDeadOrDying = IsPedDeadOrDying
local NetworkResurrectLocalPlayer = NetworkResurrectLocalPlayer
local GetEntityCoords = GetEntityCoords
local GetEntityHeading = GetEntityHeading
local DisableControlAction = DisableControlAction
local TaskPlayAnim = TaskPlayAnim

local SetFlash = SetFlash
local ShakeGameplayCam = ShakeGameplayCam
local GetPedArmour = GetPedArmour

local SetTimecycleModifier = SetTimecycleModifier
local SetTimecycleModifierStrength = SetTimecycleModifierStrength
local ClearTimecycleModifier = ClearTimecycleModifier

function Status:Start()
    LocalPlayer.state.dead = false

    self.Injuries = setmetatable(self.Injuries, {
        __newindex = function(this, k, v)
            rawset(this, k, v)

            if #this == 1 then
                self:HandleInjuries()
            end
        end,

        __call = function(this,...)
            for k,v in pairs(this) do
                this[k] = nil
            end
        end
    })

    self:HandleInjuries()

    self:RegisterEvents()

    self:ExportZones()

    CreateThread(self.Thread)
    CreateThread(self.Tick)
end

function Status:ExportZones()
    for k,v in pairs (self.Zones) do
        local isRegistered, reason = exports.plouffe_lib:Register(v)

    end
end

function Status:RegisterEvents()
    AddEventHandler('entityDamaged', self.EntityDamaged)
    AddEventHandler("plouffe_status:on_zone", self.OnZone)

    AddEventHandler("plouffe_status:respawn:hospital", self.Respawn)
    AddEventHandler("plouffe_status:respawn:giveup", self.GiveUp)

    AddStateBagChangeHandler("cuffed", ("player:%s"):format(GetPlayerServerId(PlayerId())), function(bagName,key,value,reserved,replicated)
        if value and uiShown then
            uiShown = false

            SetNuiFocus(uiShown, uiShown)
            SendNUIMessage({show = uiShown})
        end
    end)

    AddStateBagChangeHandler("dead", ("player:%s"):format(GetPlayerServerId(PlayerId())), function(bagName,key,value,reserved,replicated)
        if value and uiShown then
            uiShown = false

            SetNuiFocus(uiShown, uiShown)
            SendNUIMessage({show = uiShown})
        end
    end)

    Callback:RegisterClientCallback("plouffe_status:revive", self.Revive)
    Callback:RegisterClientCallback("plouffe_status:heal", self.Heal)
    Callback:RegisterClientCallback("plouffe_status:setStatus", self.setStatus)
end

function Status.setStatus(cb, data)
    Status.Set(data.key, data.val)
    cb(Status.Current.status)
end

function Status.OnZone(params)
    Status[params.fnc](Status, params)
end

---@param boneid integer boneid to search for
---@return string label the bone label found
function Status:GetBoneLabel(boneid)
    local searchIndex = GetPedBoneIndex(cache.ped, boneid)

    for k,v in pairs(boneLabels) do
        local index = GetPedBoneIndex(cache.ped, v.bone)
        if index == searchIndex then
            return v.label
        end
    end

    return "Inconnue"
end

---@param weapon string weapon causing damage
---@param bone string ped bone damage
function Status:NewInjurie(weapon,bone)
    local data = self.DamageData[weapon]
    local time = GetGameTimer()

    if time - lastInjurie < injurieInterval then
        return
    end

    if not data then
        return
    end

    if data.ragdoll then
        SetPedToRagdoll(cache.ped, data.ragdoll, data.ragdoll, 0, true, true, true)
    end

    if not data.bleed then
        return
    end

    lastInjurie = time

    Status.Injuries[#Status.Injuries + 1] = {
        id = #Status.Injuries + 1,
        bleed = data.bleed,
        bandage = 0,
        infection = 0,
        health = 100,
        projectile = data.projectile or 0,
        infected = false,
        boneId = bone,
        bone = self:GetBoneLabel(bone)
    }

    Utils:AssureAnimSet("move_m@injured")
    SetPedMovementClipset(cache.ped, "move_m@injured",  "move_m@injured", true)
end

---@param victim integer
---@param culprit integer
---@param weapon integer
---@param baseDamage number
function Status.EntityDamaged(victim, culprit, weapon, baseDamage)
    if cache.ped ~= victim then
        return
    end

    if GetPedArmour(cache.ped) > 0 then
        return
    end

    local _, bone = GetPedLastDamageBone(cache.ped)

    Status:NewInjurie(weapon, bone)
end

---@return boolean isBleeding if the player is bleeding
---@return boolean ifInfected if the player as infection
function Status:InjuriesTick()
    local isBleeding, isInfected = false, false
    local time = GetGameTimer()

    for k,v in pairs(self.Injuries) do
        v.update = v.update or 0

        local intervall = math.random(tickInterval.min, tickInterval.max)
        local letUpdate = time - v.update > intervall

        if letUpdate then
            v.update = time

            local pedDamage = 0
            local injurieDamage = (v.bleed + v.projectile)

            v.bandage = v.bandage - injurieDamage > 0 and v.bandage - injurieDamage or 0

            if v.infection > 0 then
                isInfected = true
                pedDamage += v.infection
            end

            if v.bandage <= 0 then
                isBleeding = true
                pedDamage += injurieDamage

                v.health = v.health - injurieDamage > 0 and v.health - injurieDamage or 0
            end

            if v.health <= 0 then
                v.infection += 1
            end

            if pedDamage > 0 then
                ApplyDamageToPed(cache.ped, pedDamage, false)
            end
        end
    end

    return isBleeding, isInfected
end

function Status:HandleInjuries()
    CreateThread(function()
        while #self.Injuries > 0 and not LocalPlayer.state.dead do
            local isBleeding, isInfected = self:InjuriesTick()

            if isBleeding then
                Utils:Notify("Vous perdez du sang suite a vos blessures")
            end

            if isInfected then
                Utils:Notify("Vous avez des plaie infecter")
            end

            Wait(1000)
        end

        if #self.Injuries > 0 then
            self.Injuries()
        end
    end)
end

function Status.Thread()
    while true do
        cache.ped = PlayerPedId()

        if IsPedDeadOrDying(cache.ped) and not LocalPlayer.state.dead then
            Utils:FadeOut(1000, true)
            Status.IsDead()
        end

        Wait(500)
    end
end

function Status.GetCurrentSeat(vehicle)
    for i = -1, 16 do
        local pedInSeat = GetPedInVehicleSeat(vehicle, i)

        if pedInSeat == cache.ped then
            return i
        end
    end
end

function Status.GetDeathAnim(seat)
    seat = tostring(seat)
    return seat and seatsAnim[seat] or seatsAnim.default
end

function Status.IsDead()
    if isDead then
        return
    end

    exports.npwd:setPhoneDisabled(true)

    isDead = true

    LocalPlayer.state.dead = true

    timeOfDead = GetGameTimer()

    Status:UpdateHud()

    CreateThread(function()
        TriggerServerEvent("plouffe_status:setPlayerDead", Status.auth, isDead)
        Utils:AssureAnim("dead", true)

        while isDead do
            Wait(0)

            local currentVehicle = GetVehiclePedIsIn(cache.ped, false)
            local seat = false

            if currentVehicle ~= 0 then
                seat = Status.GetCurrentSeat(currentVehicle)
            end

            local animData = Status.GetDeathAnim(seat)

            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 32, true) -- W
            DisableControlAction(0, 34, true) -- A
            DisableControlAction(0, 31, true) -- S
            DisableControlAction(0, 30, true) -- D
            DisableControlAction(0, 45, true) -- Reload
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 44, true) -- Cover
            DisableControlAction(0, 37, true) -- Select Weapon
            DisableControlAction(0, 23, true) -- Also 'enter'?
            DisableControlAction(0, 288,  true) -- Disable phone
            DisableControlAction(0, 289, true) -- Inventory
            DisableControlAction(0, 170, true) -- Animations
            DisableControlAction(0, 167, true) -- Job
            DisableControlAction(0, 73, true) -- Disable clearing animation
            DisableControlAction(2, 199, true) -- Disable pause screen
            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle
            DisableControlAction(2, 36, true) -- Disable going stealth
            DisableControlAction(2, 21, true) -- Disable run 2
            DisableControlAction(0, 21, true) -- Disable run
            DisableControlAction(0, 47, true)  -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true)  -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle

            if IsPedDeadOrDying(cache.ped) then
                local pedCoords = GetEntityCoords(cache.ped)
                local pedHeading = GetEntityHeading(cache.ped)

                NetworkResurrectLocalPlayer(pedCoords.x, pedCoords.y, pedCoords.z, pedHeading, true, false)

                cache.ped = PlayerPedId()

                if seat ~= false then
                    Wait(500)
                    local init = GetGameTimer()

                    TaskWarpPedIntoVehicle(cache.ped, currentVehicle, seat)

                    while not IsPedInAnyVehicle(cache.ped) and GetGameTimer() - init < 5000 do
                        Wait(0)
                    end
                end
            end

            if not HasAnimDictLoaded(animData.dict) then
                Utils:AssureAnim(animData.dict, true)
            end

            if not IsEntityPlayingAnim(cache.ped, animData.dict, animData.anim, 3) then
                TaskPlayAnim(cache.ped, animData.dict, animData.anim, -1, -1, -1, 1, 0,  false, false, false)
            end
        end

        for k,v in pairs(seatsAnim) do
            RemoveAnimDict(v.dict)
        end

        local dict = "mini@cpr@char_b@cpr_str"
        local anim = "cpr_success"
        local animSet = "move_m@injured"
        local timer = 0

        Utils:AssureAnim(dict)
        TaskPlayAnim(cache.ped, dict, anim, 3.0, 2.0, 22000, 1, 0, false, false, false)

        Utils:AssureAnimSet(animSet)
        SetPedMovementClipset(cache.ped, animSet,  animSet, true)

        while timer <= 3000 do
            timer = timer + 1
            Wait(0)
            DisableControlAction(0, 73, true) -- Disable
        end

        LocalPlayer.state.dead = false
        exports.npwd:setPhoneDisabled(false)
        TriggerServerEvent("plouffe_status:setPlayerDead", Status.auth, isDead)
    end)

    Utils:FadeIn(5000)
end

---@return number value new status value
function Status.Hunger(tick)
    local value = Status.Current.status.Hunger
    local percent = (value / 1000) * 100

    if percent < 10 then
        SetFlash(0, 0, 500, 7000, 500)
        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.02)

        if percent <= 1 then
            ApplyDamageToPed(cache.ped, 1, false)
        end
    end

    if tick > 6000 then
        value = value - 1 > 0 and value - 1 or 0
    end

    return value
end

---@return number value new status value
function Status.Thirst(tick)
    local value = Status.Current.status.Thirst
    local percent = (value / 1000) * 100

    if percent < 10 then
        SetFlash(0, 0, 500, 7000, 500)
        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.02)

        if percent <= 1 then
            ApplyDamageToPed(cache.ped, 1, false)
        end
    end

    if tick > 6000 then
        value = value - 1 > 0 and value - 1 or 0
    end

    return value
end

---@return number value new status value
function Status.Stress(tick)
    local value = Status.Current.status.Stress
    local percent = (value / 1000) * 100
    local time = GetGameTimer()

    if percent >= 25 and time - last_stress_blur >= 30000 then
        last_stress_blur = time
        Utils:Blur(1000)
    elseif percent >= 35 and time - last_stress_blur >= 25000 then
        last_stress_blur = time
        Utils:Blur(2000)
    elseif percent >= 45 and time - last_stress_blur >= 20000 then
        last_stress_blur = time
        Utils:Blur(3000)
    elseif percent >= 65 and time - last_stress_blur >= 15000 then
        last_stress_blur = time
        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.2)
        Utils:Blur(4000)
    elseif percent >= 85 and time - last_stress_blur >= 8000 then
        last_stress_blur = time
        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.5)
        Utils:Blur(5000)
    end

    if tick > 4000 then
        value = value + 0.2 < 1000 and value + 0.2 or 1000
    end

    return value
end

---@return number value new status value
function Status.Fatigue(tick)
    local value = Status.Current.status.Fatigue

    if tick > 6000 then
        value = value + 0.1 < 1000 and value + 0.1 or 1000
    end

    return value
end

---@return number value new status value
function Status.Drunk(tick)
    local value = Status.Current.status.Drunk

    if tick > 3000 then
        value = value - 25 > 0 and value - 25 or 0
    end

    return value
end

---@return number value new status value
function Status.Drug(tick)
    local value = Status.Current.status.Drug

    if tick > 3000 then
        value = value - 25 > 0 and value - 25 or 0
    end

    return value
end

---@return number value new status value
function Status.Armour(tick)
    return GetPedArmour(cache.ped)
end

---@return number value new status value
function Status.Health(tick)
    return GetEntityHealth(cache.ped)
end

function Status.Tick()
    local last_server_update = GetGameTimer()
    local last_status_tick = GetGameTimer()

    while true do
        local time = GetGameTimer()
        local tick = time - last_status_tick

        if tick > 6001 then
            last_status_tick = time

            if time - last_server_update > (1000 * 60 * 2) then
                last_server_update = time
                TriggerServerEvent("plouffe_status:updateStatus", Status.auth, Status.Current.status)
            end
        end

        for k,v in pairs(Status.Current.status) do
            Status.Current.status[k] = Status[k](tick)
        end

        Status.UpdateHud()

        Wait(1000)
    end
end

function Status.Get(key, percent)
    local value = Status.Current.status[key]

    if not percent then
        return Status.Current.status[key]
    end

    local pct = (value / 1000) * 100
    return pct
end
exports("Get", Status.Get)

function Status.Set(key,val)
    Status.Current.status[key] = val < 1000 and val > 0 and val or Status.Current.status[key]
end
exports("Set", Status.Set)

function Status.Add(key,val)
    Status.Current.status[key] = Status.Current.status[key] + val < 1000 and Status.Current.status[key] + val or 1000
end
exports("Add", Status.Add)

function Status.Remove(key,val)
    Status.Current.status[key] = Status.Current.status[key] - val > 0 and Status.Current.status[key] - val or 0
end
exports("Remove", Status.Remove)

function Status.UpdateHud()
    local current = Status.Current.status

    local data = {
        hunger = math.floor((current.Hunger / 1000) * 100),
        thirst = math.floor((current.Thirst / 1000) * 100),
        stress = math.floor((current.Stress / 1000) * 100),
        fatigue = math.floor((current.Fatigue / 1000) * 100),
        drunk = math.floor((current.Drunk / 1000) * 100),
        drug = math.floor((current.Drug / 1000) * 100),
        health = isDead and 0 or math.floor(((GetEntityHealth(cache.ped) - 100) / 100) * 100),
        armor = math.floor((GetPedArmour(cache.ped) / 100) * 100)
    }

    exports.ooc_hud:Update(data)
end

function Status.GetUsableBed(zone)
    for k,v in pairs(beds[zone]) do
        local playerFound, distance = Utils:GetClosestPlayer(v.coords)
        if not playerFound or (playerFound and distance > 2) then
            return k
        end
    end
end

function Status:BedCare(params, time)
    local index = Status.GetUsableBed(params.zone)

    if not index then
        return Utils:Notify("Il n'y a pas de lit de disponible pour l'instant")
    end

    local bed = beds[params.zone][index]
    local bedEntity = GetClosestObjectOfType(bed.coords.x, bed.coords.y, bed.coords.z, 1.0, bed.model, false, false, false)

    if not DoesEntityExist(bedEntity) then
        local c = vector3(323.1305847168, -584.53424072266, 44.184097290039)
        SetEntityCoords(cache.ped, c.x, c.y, c.z)
        Wait(2000)
        return self:BedCare(params, time)
    end

    local coords = GetOffsetFromEntityInWorldCoords(bedEntity, 0.0, 0.0, 0.2)
    local heading = GetEntityHeading(bedEntity)


    Utils:FadeOut(3000, true)

    local onBed = true

    if Status.Current.status.Hunger < 100 then
        Status.Current.status.Hunger = 100
    end

    if Status.Current.status.Thirst < 100 then
        Status.Current.status.Thirst = 100
    end

    if not isDead then
        Utils:AssureAnim("dead", true)

        CreateThread(function()
            while onBed do
                Wait(0)

                DisableControlAction(0, 24, true) -- Attack
                DisableControlAction(0, 257, true) -- Attack 2
                DisableControlAction(0, 263, true) -- Melee Attack 1
                DisableControlAction(0, 32, true) -- W
                DisableControlAction(0, 34, true) -- A
                DisableControlAction(0, 31, true) -- S
                DisableControlAction(0, 30, true) -- D
                DisableControlAction(0, 45, true) -- Reload
                DisableControlAction(0, 22, true) -- Jump
                DisableControlAction(0, 44, true) -- Cover
                DisableControlAction(0, 37, true) -- Select Weapon
                DisableControlAction(0, 23, true) -- Also 'enter'?
                DisableControlAction(0, 288,  true) -- Disable phone
                DisableControlAction(0, 289, true) -- Inventory
                DisableControlAction(0, 170, true) -- Animations
                DisableControlAction(0, 167, true) -- Job
                DisableControlAction(0, 73, true) -- Disable clearing animation
                DisableControlAction(2, 199, true) -- Disable pause screen
                DisableControlAction(0, 59, true) -- Disable steering in vehicle
                DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
                DisableControlAction(0, 72, true) -- Disable reversing in vehicle
                DisableControlAction(2, 36, true) -- Disable going stealth
                DisableControlAction(2, 21, true) -- Disable run 2
                DisableControlAction(0, 21, true) -- Disable run
                DisableControlAction(0, 47, true)  -- Disable weapon
                DisableControlAction(0, 264, true) -- Disable melee
                DisableControlAction(0, 257, true) -- Disable melee
                DisableControlAction(0, 140, true) -- Disable melee
                DisableControlAction(0, 141, true) -- Disable melee
                DisableControlAction(0, 142, true) -- Disable melee
                DisableControlAction(0, 143, true) -- Disable melee
                DisableControlAction(0, 75, true)  -- Disable exit vehicle
                DisableControlAction(27, 75, true) -- Disable exit vehicle

                if not HasAnimDictLoaded("dead") then
                    Utils:AssureAnim("dead", true)
                end

                TaskPlayAnim(cache.ped, "dead", "dead_a", 1.0, 1.0, 1000, 1, 0,  false, false, false)
            end

            Wait(200)

            ClearPedTasks(cache.ped)

            RemoveAnimDict("Dead")
        end)
    end

    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z)
    SetEntityHeading(cache.ped, heading - 180)

    Utils:FadeIn(3000,true)

    TriggerServerEvent("plouffe_status:payForCare", Status.auth)

    Utils:ProgressCircle({
        duration = time or 60000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            combat = true
        }
    })

    self.Injuries()

    onBed = false

    isDead = false

    SetEntityHealth(cache.ped, GetEntityMaxHealth(cache.ped))
end

function Status:DoYoga(params)
    doingYoga = not doingYoga

    if not doingYoga then
        return 
    end

    -- exports.plouffe_lib:ChangeZoneLabel(params.zone, "Faire du yoga")
    CreateThread(function ()
        local ped = PlayerPedId()
        while not isDead and doingYoga do
            Wait(100)
            if not IsPedActiveInScenario(ped) then
                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_YOGA", 0, true)
            end

            Status.Current.status.Stress -= 1

            if Status.Current.status.Stress < 0 then
                doingYoga = false
                Status.Current.status.Stress = 0
            end
        end
        ClearPedTasks(ped)
    end)
end

RegisterNUICallback("close", function(cb)
    uiShown = false
    SetNuiFocus(false, false)

    if not Status.promise then
        return
    end

    Status.promise:resolve()
end)

RegisterNUICallback("selected", function(injuryId)
    uiShown = false
    SetNuiFocus(uiShown, uiShown)

    if not Status.promise then
        return
    end

    Status.promise:resolve(injuryId.id)
end)

function Status.Ui()
    if isDead or LocalPlayer.state.cuffed then
        return
    end

    if #Status.Injuries < 1 then
        return Utils:Notify("Vous n'avez pas de blessure en ce moment")
    end

    uiShown = not uiShown

    SetNuiFocus(uiShown, uiShown)
    SendNUIMessage({show = uiShown, injuries = Status.Injuries})
end
exports("OpenUi", Status.OpenUi)
RegisterCommand("showInjuries", Status.Ui)

function Status.AddBandage(data)
    local item = Status.Items[data.name]
    local id = nil

    if not item then
        return
    end

    if #Status.Injuries > 0 then
        Status.promise = promise.new()

        uiShown = true

        SetNuiFocus(uiShown, uiShown)
        SendNUIMessage({show = uiShown, injuries = Status.Injuries})

        id = Await(Status.promise)

        if not id then
            return
        end
    end


    if IsPedArmed(cache.ped, 1) or IsPedArmed(cache.ped, 4) then
        SetCurrentPedWeapon(cache.ped, joaat("WEAPON_UNARMED"), true)
        Wait(2000)
    end

    local finished = Utils:ProgressCircle({
        duration = item.time,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        },
        anim = {
            dict = 'missheistdockssetup1clipboard@idle_a',
            clip = 'idle_a'
        },
        prop = {
            model = `prop_ld_health_pack`,
            pos = vec3(-0.0, -0.0, -0.02),
            rot = vec3(0.0, 50.0, 0.0)
        }
    })

    if not finished then
        return
    end

    Status.HealthItem(item, id)

    TriggerServerEvent("plouffe_status:removeItem", data.name, 1)
end
exports("AddBandage", Status.AddBandage)

function Status.HealthItem(item, id)
    if item.health then
        Status.AddHealth(item.health)
    end

    if not id then
        return
    end

    if item.bandage then
        Status.Injuries[id].bandage = Status.Injuries[id].bandage + item.bandage <= 100 and Status.Injuries[id].bandage + item.bandage or 100
    end

    if item.cleanInfection then
        Status.Injuries[id].infection = 0
        Status.Injuries[id].health = 100
        Status.Injuries[id].infected = false
    end
end

function Status.AddHealth(data)
    CreateThread(function()
        local value = data.amount
        local delay = data.delay

        while not isDead and value > 0 do
            Wait(delay)
            value -= 1

            local health = GetEntityHealth(cache.ped)

            if (health - 100) < 100 then
                health += 1
                SetEntityHealth(cache.ped, health)
            end
        end
    end)
end

function Status.GiveUp()
    local time = GetGameTimer()
    local timePassed = time - timeOfDead

    if timePassed >= respawnDelay then
        TriggerServerEvent("ooc_core:wipeinventory")
        Status:BedCare({zone = "pillbox"}, 60000 * 5)
    else
        local txt = ("Vous devez attendre encore %s minutes"):format(math.ceil((respawnDelay - timePassed) / 60000))
        Utils:Notify(txt)
    end
end

function Status.Respawn()
    local time = GetGameTimer()
    local timePassed = time - timeOfDead

    if timePassed >= giveupDelay then
        Status:BedCare({zone = "pillbox"}, 60000 * 5)
    else
        local txt = ("Vous devez attendre encore %s minutes"):format(math.ceil((giveupDelay - timePassed) / 60000))
        Utils:Notify(txt)
    end
end

function Status.Revive(cb)
    isDead = false
    cb()
end

function Status.Heal(cb)
    isDead = false

    SetEntityHealth(cache.ped, 200)
    AddArmourToPed(cache.ped, 100)

    Status.Current.status.Hunger = 1000
    Status.Current.status.Thirst = 1000
    Status.Current.status.Stress = 0
    Status.Current.status.Fatigue = 0
    Status.Current.status.Drunk = 0

    cb(Status.Current.status)
end

function Status.UseConsumbale(type, data)
    if Status.Specific[data.name] then
        return Status.Specific[data.name](Status.Specific, data)
    end

    local anim, prop = consumables(type, data.name)

    local finished = Utils:ProgressCircle{
        duration = 5000,
        position = "bottom",
        useWhileDead = false,
        canCancel = true,
        anim = anim,
        prop = prop,
        disable = {
            combat = true
        }
    }

    if not finished then
        return
    end

    TriggerServerEvent("plouffe_status:removeItem", data.name, 1)

    for k,v in pairs(prop.data) do
        local current = Status.Current.status[v.key] + v.value

        if current < 0 then
            current = 0
        elseif current > 1000 then
            current = 1000
        end

        Status.Current.status[v.key] = current

        if Status.Visual[v.key] then
            Status.Visual[v.key](Status.Visual, data.name)
        end
    end
end
exports("UseConsumbale", Status.UseConsumbale)

function Status.UseSpecific(name,...)
    Status.Specific[name](Status.Specific, ...)
end
exports("UseSpecific", Status.UseSpecific)

function Status.Visual:Drunk(item)
    if self.active then
        return
    end

    self.active = true

    SetTimecycleModifier("BikerFilter")

    local current = 0
    local target = Status.Current.status.Drunk / 1000

    CreateThread(function()
        while current < target do
            current = current + 0.02
            SetTimecycleModifierStrength(current)
            Wait(1000)
        end

        while Status.Current.status.Drunk > 0 do
            Wait(1000)
            SetTimecycleModifierStrength(Status.Current.status.Drunk / 1000)
        end

        ClearTimecycleModifier()

        self.active = false
    end)
end

function Status.Specific:cigar(data)
    local time = GetGameTimer()

    if self.lastSmoke and time - self.lastSmoke < 60000 then
        return Utils:Notify("Fumé n'est pas la solution a tout")
    end

    self.lastSmoke = time

    TriggerServerEvent("plouffe_status:removeItem", data.name, 1)

    if IsPedArmed(cache.ped, 1) or IsPedArmed(cache.ped, 4) then
        SetCurrentPedWeapon(cache.ped, joaat("WEAPON_UNARMED"), true)
        Wait(2000)
    end

    ExecuteCommand("e cigar")
    Status.Remove("Stress", 200)
end

function Status.Specific:cigarette(data)
    local time = GetGameTimer()

    if self.lastSmoke and time - self.lastSmoke < 60000 then
        return Utils:Notify("Fumé n'est pas la solution a tout")
    end

    self.lastSmoke = time

    TriggerServerEvent("plouffe_status:removeItem", data.name, 1)

    if IsPedArmed(cache.ped, 1) or IsPedArmed(cache.ped, 4) then
        SetCurrentPedWeapon(cache.ped, joaat("WEAPON_UNARMED"), true)
        Wait(2000)
    end

    ExecuteCommand("e smoke")
    Status.Remove("Stress", 100)
end

function Status.Specific:bong(data)
    local time = GetGameTimer()

    if Utils:GetItemCount("weed") < 1 then
        return Utils:Notify("Vous avez besoin de weed pour utiliser avec le bong")
    end

    TriggerServerEvent("plouffe_status:removeItem", "weed", 1)

    if IsPedArmed(cache.ped, 1) or IsPedArmed(cache.ped, 4) then
        SetCurrentPedWeapon(cache.ped, joaat("WEAPON_UNARMED"), true)
        Wait(2000)
    end

    ExecuteCommand("e bong")
    Wait(10000)
    ExecuteCommand("e c")

    Status.Add("Drug", 100)

    if self.lastWeed and time - self.lastWeed < 60000 then
        return Utils:Notify("La drogue n'est pas la solution a tout")
    end

    self.lastWeed = time

    Status.Remove("Stress", 200)
    Status.AddHealth({delay = 1000, amount = 15})
end

function Status.Specific:paille(data)
    if Utils:GetItemCount("coke") < 1 then
        return Utils:Notify("Vous avez besoin de coke pour utiliser avec la paille")
    end

    local finished = Utils:ProgressCircle({
        duration = 2500,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        },
        anim = {
            dict = 'switch@trevor@trev_smoking_meth',
            clip = 'trev_smoking_meth_loop',
        },
        prop = {
            bone = 28422,
            model = `h4_prop_h4_coke_tube_01`,
            pos = vec3(-0.0, -0.0, -0.02),
            rot = vec3(0.0, 50.0, 0.0)
        }
    })

    if not finished then
        return
    end

    TriggerServerEvent("plouffe_status:removeItem", "coke", 1)

    Status.Add("Drug", 150)

    if self.CokeActive then
        return
    end

    self.CokeActive = true

    local player = PlayerId()
    local init = GetGameTimer()

    local modifierStrength = 0
    local isSpeedBoost = false

    local lastRandi = 0

    CreateThread(function()
        SetTimecycleModifier("BikerFilter")
        local time = GetGameTimer()

        while time - init < 60000 and not isDead do
            time = GetGameTimer()

            if time - lastRandi > 5000 then
                local percent = (Status.Current.status.Drug / 1000) * 100
                local randi = math.random(1,100)
                local isUnlucky = percent > randi

                if isUnlucky then
                    SetPedToRagdoll(cache.ped, 500, 500, 0, 0, 0, 0)
                end

                lastRandi = time
            end

            if modifierStrength <= 0.7 and not isSpeedBoost then
                modifierStrength += 0.001

                if modifierStrength >= 0.7 then
                    SetRunSprintMultiplierForPlayer(player, 1.49)
                    isSpeedBoost = true

                    Status.Add("Drug", 50)
                    Status.Add("Fatigue", 100)
                end
            elseif isSpeedBoost then
                modifierStrength -= 0.001
                ResetPlayerStamina(player)

                if modifierStrength <= 0 then
                    isSpeedBoost = false
                    SetRunSprintMultiplierForPlayer(player, 1.0)
                end
            end

            Wait(0)

            SetTimecycleModifierStrength(modifierStrength)
        end

        ClearTimecycleModifier()
        SetRunSprintMultiplierForPlayer(player, 1.0)

        self.CokeActive = false
    end)
end

function Status.Specific:methpipe(data)
    if Utils:GetItemCount("meth") < 1 then
        return Utils:Notify("Vous avez besoin de meth pour utiliser avec la pipe")
    end

    local finished = Utils:ProgressCircle({
        duration = 2500,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        },
        anim = {
            dict = 'switch@trevor@trev_smoking_meth',
            clip = 'trev_smoking_meth_loop',
        },
        prop = {
            bone = 28422,
            model = `prop_cs_meth_pipe`,
            pos = vec3(-0.0, -0.0, -0.02),
            rot = vec3(0.0, 50.0, 0.0)
        }
    })

    if not finished then
        return
    end

    TriggerServerEvent("plouffe_status:removeItem", "meth", 1)

    Status.Add("Drug", 150)

    if self.MethActive then
        return
    end

    self.MethActive = true

    SetPedCanRagdoll(PlayerPedId(), false)

    CreateThread(function()
        local init = GetGameTimer()

        while GetGameTimer() - init < 45000 and not isDead do
            Wait(1000)
            Status.Add("Drug", 10)
        end

        SetPedCanRagdoll(PlayerPedId(), true)

        self.MethActive = false
    end)
end

function Status.Specific:oxy(data)
    local finished = Utils:ProgressCircle({
        duration = 2500,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        },
        anim = {
            dict = 'mp_suicide',
            clip = 'pill_fp',
        },
        prop = {
            bone = 28422,
            model = `prop_cs_pills`,
            pos = vec3(0.12, 0.0, -0.035),
            rot = vec3(270.0, 0.0, 0.0)
        }
    })

    if not finished then
        return
    end

    TriggerServerEvent("plouffe_status:removeItem", data.name, 1)

    if self.OxyActive then
        return
    end

    self.OxyActive = true

    CreateThread(function()
        local amount = 25

        while amount > 0 and not isDead do
            Wait(1000)

            amount -= 1

            Status.Add("Drug", 10)

            AddArmourToPed(cache.ped, 1)
        end

        self.OxyActive = false
    end)
end

function Status.Specific:weed(slot)
    local finished = exports.ox_lib:progressCircle({
        duration = 10000,
        useWhileDead = false,
        canCancel = true,
        anim = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            clip = "machinic_loop_mechandplayer"
        },
        disable = {
            move = true,
            car = true,
            combat = true,
        }
    })

    if not finished then
        return
    end

    TriggerServerEvent("plouffe_status:rollWeed", Status.auth, slot)
end
