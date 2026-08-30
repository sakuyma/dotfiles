return function()
    gamemode_toggle = function()
        local game_mode = (hl.get_config("animations.enabled") == false)

        if game_mode then
            hl.exec_cmd("hyprctl reload")
            hl.exec_cmd("notify-send 'Gamemode' 'Disabled' -u 'low'")
            return
        end

        hl.config({
            general = {
                gaps_in = 0,
                gaps_out = 0, -- Disable gaps
                border_size = 0,
            },

            animations = {
                enabled = false, -- Disable animations
            },

            -- Disable blur, shadow and window rounding
            decoration = {
                shadow = { enabled = false },
                blur = { enabled = false },
                rounding = 0,
            },
            hl.exec_cmd("notify-send 'Gamemode' 'Enabled' -u 'low'")

        })
    end

    decorations = {
        animations = {
            toggle = function()
                local animations = (hl.get_config("animations.enabled") == false)
                if animations then
                    hl.config({
                        animations = {
                            enabled = true, -- Enable animations
                        },
                    })
                    hl.exec_cmd("notify-send 'Animations' 'Enabled' -u 'low'")
                    return
                end

                hl.config({
                    animations = {
                        enabled = false, -- Disable animations
                    },
                })
                hl.exec_cmd("notify-send 'Animations' 'Disabled' -u 'low'")
            end,

            enable = function()
                hl.config({
                    animations = {
                        enabled = true,
                    },
                })
                hl.exec_cmd("notify-send 'Animations' 'Enabled' -u 'low'")
            end,

            disable = function()
                hl.config({
                    animations = {
                        enabled = false,
                    },
                })
                hl.exec_cmd("notify-send 'Animations' 'Disabled' -u 'low'")
            end
        },

        blur = {
            toggle = function()
                local blur = (hl.get_config("decoration.blur.enabled") == false)
                if blur then
                    hl.config({
                        decoration = {
                            blur = { enabled = true },
                        },
                    })
                    hl.exec_cmd("notify-send 'Blur' 'Enabled' -u 'low'")
                    return
                end

                hl.config({
                    decoration = {
                        blur = { enabled = false },
                    },
                })
                hl.exec_cmd("notify-send 'Blur' 'Disabled' -u 'low'")
            end,

            enable = function()
                hl.config({
                    decoration = {
                        blur = { enabled = true },
                    },
                })
                hl.exec_cmd("notify-send 'Blur' 'Enabled' -u 'low'")
            end,

            disable = function()
                hl.config({
                    decoration = {
                        blur = { enabled = false },
                    },
                })
                hl.exec_cmd("notify-send 'Blur' 'Disabled' -u 'low'")
            end
        },

        shadow = {
            toggle = function()
                local shadow = (hl.get_config("decoration.shadow.enabled") == false)
                if shadow then
                    hl.config({
                        decoration = {
                            shadow = { enabled = true },
                        },
                    })
                    hl.exec_cmd("notify-send 'Shadow' 'Enabled' -u 'low'")
                    return
                end

                hl.config({
                    decoration = {
                        shadow = { enabled = false },
                    },
                })
                hl.exec_cmd("notify-send 'Shadow' 'Disabled' -u 'low'")
            end,

            enable = function()
                hl.config({
                    decoration = {
                        shadow = { enabled = true },
                    },
                })
                hl.exec_cmd("notify-send 'Shadow' 'Enabled' -u 'low'")
            end,

            disable = function()
                hl.config({
                    decoration = {
                        shadow = { enabled = false },
                    },
                })
                hl.exec_cmd("notify-send 'Shadow' 'Disabled' -u 'low'")
            end
        },

        gaps = {
            toggle = function()
                -- Get the actual value from the table
                local gaps_in_config = hl.get_config("general.gaps_in")
                local gaps_out_config = hl.get_config("general.gaps_out")

                -- Extract the actual integer values
                local gaps_in = gaps_in_config and gaps_in_config.int or 0
                local gaps_out = gaps_out_config and gaps_out_config.int or 0

                local gaps_enabled = (gaps_in > 0 or gaps_out > 0)

                if gaps_enabled then
                    -- Disable gaps
                    hl.config({
                        general = {
                            gaps_in = 0,
                            gaps_out = 0,
                        },
                    })
                    hl.exec_cmd("notify-send 'Gaps' 'Disabled' -u 'low'")
                    return
                end

                -- Enable gaps
                hl.exec_cmd("hyprctl reload")
                hl.exec_cmd("notify-send 'Gaps' 'Enabled' -u 'low'")
            end,

            enable = function()
                hl.exec_cmd("hyprctl reload")
                hl.exec_cmd("notify-send 'Gaps' 'Enabled' -u 'low'")
            end,

            disable = function()
                hl.config({
                    general = {
                        gaps_in = 0,
                        gaps_out = 0,
                    },
                })
                hl.exec_cmd("notify-send 'Gaps' 'Disabled' -u 'low'")
            end
        },

        rounding = {
            toggle = function()
                local rounding = (hl.get_config("decoration.rounding") == 0)
                if rounding then
                    hl.exec_cmd("hyprctl reload")
                    hl.exec_cmd("notify-send 'Rounding' 'Enabled' -u 'low'")
                    return
                end

                hl.config({
                    decoration = {
                        rounding = 0,
                    },
                })
                hl.exec_cmd("notify-send 'Rounding' 'Disabled' -u 'low'")
            end,

            enable = function()
                hl.exec_cmd("hyprctl reload")
                hl.exec_cmd("notify-send 'Rounding' 'Enabled' -u 'low'")
            end,

            disable = function()
                hl.config({
                    decoration = {
                        rounding = 0,
                    },
                })
                hl.exec_cmd("notify-send 'Rounding' 'Disabled' -u 'low'")
            end
        },

        border = {
            toggle = function()
                local border = (hl.get_config("general.border_size") == 0)
                if border then
                    hl.exec_cmd("hyprctl reload")
                    hl.exec_cmd("notify-send 'Border' 'Enabled' -u 'low'")
                    return
                end

                hl.config({
                    general = {
                        border_size = 0,
                    },
                })
                hl.exec_cmd("notify-send 'Border' 'Disabled' -u 'low'")
            end,

            enable = function()
                hl.exec_cmd("hyprctl reload")
                hl.exec_cmd("notify-send 'Border' 'Enabled' -u 'low'")
            end,

            disable = function()
                hl.config({
                    general = {
                        border_size = 0,
                    },
                })
                hl.exec_cmd("notify-send 'Border' 'Disabled' -u 'low'")
            end
        },

        opacity = {
            toggle = function()
                local opacity = (hl.get_config("decoration.opacity") == 1.0)
                if opacity then
                    hl.config({
                        hl.exec_cmd("hyprctl reload")
                    })
                    hl.exec_cmd("notify-send 'Opacity' 'Reduced' -u 'low'")
                    return
                end

                hl.config({
                    decoration = {
                        opacity = 1.0,
                    },
                })
                hl.exec_cmd("notify-send 'Opacity' 'Full' -u 'low'")
            end,

            enable = function()
                hl.config({
                    decoration = {
                        opacity = 1.0,
                    },
                })
                hl.exec_cmd("notify-send 'Opacity' 'Full' -u 'low'")
            end,

            disable = function()
                hl.config({
                    decoration = {
                        opacity = 0.85,
                    },
                })
                hl.exec_cmd("notify-send 'Opacity' 'Reduced' -u 'low'")
            end
        }
    }


    -- animations_toggle = function()
    --     local animations = (hl.get_config("animations.enabled") == false)
    --     if animations then
    --         hl.config({
    --             animations = {
    --                 enabled = true, -- Enable animations
    --             },
    --         })
    --         hl.exec_cmd("notify-send 'Animations' 'Disabled' -u 'low'")
    --         return
    --     end
    --
    --     hl.config({
    --         animations = {
    --             enabled = false, -- Disable animations
    --         },
    --         hl.exec_cmd("notify-send 'Animations' 'Enabled' -u 'low'")
    --     })
    -- end
end
