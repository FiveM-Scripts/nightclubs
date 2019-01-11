IsPlayerNearClub = false

function CreateDj(dj) 
      if dj == "solomun" then
            model = "csb_sol"
      elseif dj == "dixon" then
            model = "csb_dix"
      end

      RequestModel(model)
      while not HasModelLoaded(model) do
            Wait(10)
      end

      local ped = CreatePed(26, model, -1604.664, -3012.583, -79.9999, 268.9422, false, false)
      SetEntityHeading(ped, 268.9422)
      SetBlockingOfNonTemporaryEvents(ped, true)
      SetModelAsNoLongerNeeded(model) 

      return ped     
end

function CleanUpInterior(interiorID)
      for k,v in pairs(interiorsProps) do
            if IsInteriorPropEnabled(interiorID, v) then
                  DisableInteriorProp(interiorID, v)
                  Wait(10)
            end
      end

      ReleaseScriptAudioBank()
      Wait(200)
      RefreshInterior(interiorID)
      UnpinInterior(interiorID)
end

function PrepareClubInterior(interiorID)
      for k,v in pairs(interiorsProps) do
            if not IsInteriorPropEnabled(interiorID, v) then
                  EnableInteriorProp(interiorID, v)
                  Wait(20)
            end
      end

      if DoesEntityExist(dj) then
            DeleteEntity(dj)
      end

      RequestScriptAudioBank("DLC_BATTLE/BTL_CLUB_OPEN_TRANSITION_CROWD", false, -1)
      SetAmbientZoneState("IZ_ba_dlc_int_01_ba_Int_01_main_area", 0, 0)
      Wait(100)
      RefreshInterior(interiorID)
end

function TaskEnterNightClubGarage()
      if not IsPedInAnyVehicle(playerPed, false) then
            SetEntityCoords(playerPed, -1628.12, -2995.87, -78.1438-1.0)
      else
            SetPedCoordsKeepVehicle(playerPed, -1628.12, -2995.87, -78.1438-1.0)
      end

      if IsScreenFadedOut() then
            DoScreenFadeIn(200)
            Wait(250)
      end
end

Citizen.CreateThread(function()
      DoScreenFadeIn(100)
      RequestIpl("ba_case7_dixon")
      for k,v in pairs(locations) do
            local ix,iy,iz = table.unpack(v["markin"])
            local blip = AddBlipForCoord(ix,iy,iz)
            SetBlipSprite(blip, 614)
            SetBlipNameFromTextFile(blip, "CLUB_QUICK_GPS")
      end
      
      while true do
            Wait(5)
            playerPed = PlayerPedId()
            coords = GetEntityCoords(playerPed)

            if not IsEntityDead(playerPed) then
                  for k,v in pairs(locations) do
                        local ix,iy,iz = table.unpack(v["markin"])
                        local gix, giy, giz = table.unpack(v["garage_in"])
                        local gox, goy, goz = table.unpack(v["garage_out"])
                        local ox, oy, oz = table.unpack(v["markout"])

                        if GetDistanceBetweenCoords(coords, gix, giy, giz, true) < 50.5999 then
                              DrawMarker(1, gix, giy, giz-1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 238, 227, 79, 200, 0, 0, 2, 0, 0, 0, 0)
                        end

                        if GetDistanceBetweenCoords(coords, gox, goy, goz, true) < 2.0 then
                              if not IsScreenFadedOut() then
                                    DoScreenFadeOut(200)
                                    Wait(250)

                                    if success then
                                          if not IsPedInAnyVehicle(playerPed, false) then
                                                SetEntityCoords(playerPed, vec3.x, vec3.y, vec3.z-1.0)
                                          else
                                                SetPedCoordsKeepVehicle(playerPed, vec3.x, vec3.y, vec3.z-1.0)
                                          end

                                          Wait(250)
                                          DoScreenFadeIn(300)
                                    end
                              end
                        end


                        if GetDistanceBetweenCoords(coords, gix, giy, giz, true) < 2.0 then
                              local _, vector = GetNthClosestVehicleNode(coords.x, coords.y, coords.z, math.random(20, 180), 0, 0, 0)
                              success, vec3 = GetSafeCoordForPed(coords.x, coords.y, coords.z, false, 28)                              
                              
                              if not IsScreenFadedOut() then
                                    DoScreenFadeOut(200)
                                    Wait(300)
                                    TaskEnterNightClubGarage()
                              end
                        end                        
                  
                        if GetDistanceBetweenCoords(coords, ix, iy, iz, true) < 50.5999 then
                              DrawMarker(1, ix,iy,iz-1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 238, 227, 79, 200, 0, 0, 2, 0, 0, 0, 0)
                        end

                        if GetDistanceBetweenCoords(coords, ox, oy, oz, true) < 10.0 then
                              DrawMarker(1, ox, oy, oz-1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 238, 227, 79, 200, 0, 0, 2, 0, 0, 0, 0)
                        end                        


                        if GetDistanceBetweenCoords(coords, ox, oy, oz, true) < 2.0 then
                              if not IsScreenFadedOut() then
                                    DoScreenFadeOut(200)
                                    Wait(250)
                                    CleanUpInterior()
                                    if success then
                                          SetEntityCoords(playerPed, vec3.x, vec3.y, vec3.z-1.0)
                                          Wait(250)
                                          DoScreenFadeIn(300)
                                    end   
                              end
                        end

                        if GetDistanceBetweenCoords(coords, ix, iy, iz, true) < 1.0 then
                              if not IsScreenFadedOut() then
                                    local _, vector = GetNthClosestVehicleNode(coords.x, coords.y, coords.z, math.random(20, 180), 0, 0, 0)
                                    success, vec3 = GetSafeCoordForPed(coords.x, coords.y, coords.z, false, 28)
                                    
                                    DoScreenFadeOut(300)
                                    Wait(350)
                              end

                              interiorID = GetInteriorAtCoordsWithType(-1604.664, -3012.583, -79.9999, "ba_dlc_int_01_ba")
                              if IsValidInterior(interiorID) then
                                    LoadInterior(interiorID)
                                    if IsInteriorReady(interiorID) then
                                          PrepareClubInterior(interiorID)

                                          if not DoesEntityExist(dj) then
                                                dj = CreateDj(current_dj)
                                          end

                                          SetEntityCoords(playerPed,-1591.4850, -3013.6070, -80.0060, 1, false, 0, 1)     
                                          SetEntityHeading(playerPed, 74.0804)

                                          SetGameplayCamRelativeHeading(12.1322)
                                          SetGameplayCamRelativePitch(-3.2652, 1065353216)

                                          DoScreenFadeIn(300)
                                          Wait(350)
                                          StartAudioScene("DLC_Ba_NightClub_Scene")
                                          PlaySoundFrontend(-1, "club_crowd_transition", "dlc_btl_club_open_transition_crowd_sounds", true)
                                    end
                              end
                        end
                  end
            end
      end
end)