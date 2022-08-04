
local j = nil
local nemici = 10
local teams = {
    {name = "nemici", model = "g_m_m_chicold_01", weapon = "WEAPON_ASSAULTRIFLE"},
    {name = "boss", model = "g_m_m_armboss_01", weapon ="WEAPON_ASSAULTSHOTGUN"}, 
    
}
for i=1, #teams, 1 do 
    AddRelationshipGroup(teams[i].name)
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
            for i = 1, #locations, 1 do
                loc = posizioni[i]
                DrawMarker(
                    loc.marker,
                    loc.pos.x,
                    loc.pos.y,
                    loc.pos.z-0.75,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    loc.scale,
                    loc.scale,
                    loc.scale,
                    loc.rgba[1],
                    loc.rgba[2],
                    loc.rgba[3],
                    loc.rgba[4],
                    false,
                    true,
                    2,
                    nil,
                    nil,
                    false
                )
                if loc.submarker ~= nil then DrawMarker(
                    loc.submarker.marker,loc.pos.x,loc.pos.y,loc.submarker.posz,
                    0.0,0.0,0.0,0.0,0.0,0.0,
                    loc.scale/2,loc.scale/2,loc.scale/2,
                    loc.rgba[1],loc.rgba[2],loc.rgba[3],loc.rgba[4],
                    false,true,2,nil,nil,false) end
                local playerCoord = GetEntityCoords(PlayerPedId(), false)
                local locVector = vector3(loc.pos.x, loc.pos.y, loc.pos.z)
                if Vdist2(playerCoord, locVector) < loc.scale*1.12 and GetVehiclePedIsIn(PlayerPedId(), false) == 0 then    
                    notifica("~r~# sei stato avvistato, preparati all' assalto in arrivo...") 
                    wait(2000)
                    local persTot = tonumber(nemici)
                    for i=1,persTot, 1 do 
                        j = math.random(1,#teams) 
                        local ped = GetHashKey(teams[j].model)
                        RequestModel(ped)
                        while not HasModelLoaded(ped) do 
                            Citizen.Wait(1)
                        end
                        local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1))) --spawna sul player, in alternativa indicare coordinate  es: (local x,y,z = 100, 200, 1)--
                        newPed = CreatePed(4 , ped, x+math.random(-persTot,persTot),y+math.random(-persTot,persTot) , z , 0.0 , false, true)
                        SetPedCombatAttributes(newPed, 0, true) 
                        SetPedCombatAttributes(newPed, 5, true) 
                        SetPedCombatAttributes(newPed, 46, true) 
                        SetPedFleeAttributes(newPed, 0, true) 
                        SetPedRelationshipGroupHash(newPed, GetHashKey(teams[j].name)) 
                        SetRelationshipBetweenGroups(5, GetHashKey(teams[1].name), GetHashKey(teams[2].name)) 
                        if teams[j].name == "nemici" then
                            SetRelationshipBetweenGroups(5, GetHashKey(teams[j].name), GetHashKey("PLAYER"))
                            SetPedAccuracy(newPed, 80) 
                        else 
                            SetRelationshipBetweenGroups(5, GetHashKey(teams[j].name), GetHashKey("PLAYER"))
                            SetPedAccuracy(newPed, 90)
                            SetPedArmour(newPed, 100)
                            SetPedMaxHealth(newPed, 500) 
                        end
                        TaskStartScenarioInPlace(newPed, "WORLD_HUMAN_SMOKING", 0, true)
                        GiveWeaponToPed(newPed, GetHashKey(teams[j].weapon), 2000, true, false)
                        SetPedArmour(newPed, 100)
                        SetPedMaxHealth(newPed, 100)
                    end
                end
            end
        end
    end
)
