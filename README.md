# pf_blackmarket

A modern blackmarket system for FiveM servers built by [Patchflow](https://patchflow.md/). Players purchase illegal goods from NPC dealers that relocate on a configurable schedule.

## Features

- **Modern UI** — Clean React + Mantine interface with cart-based purchasing
- **Multiple Stores** — Configure independent blackmarket locations with unique inventories and categories
- **NPC Dealers** — Peds spawn at configurable locations with ox_target interaction
- **Dealer Relocation** — Peds automatically move to new locations on a cron schedule (30m to daily)
- **Payment Types** — Support for cash (inventory item) and bank (framework) payments
- **Cart Validation** — Full server-side validation of items, quantities, pricing, weight, and proximity
- **Multi-Framework** — Supports ESX and QBX with automatic detection
- **Localization** — Full locale support via ox_lib (English and Danish included)
- **Discord & ox_lib Logging** — Log purchases and failures to Discord webhooks and/or ox_lib logger
- **Type-safe Lua** — LuaLS annotations throughout with enums and constants

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_inventory](https://github.com/overextended/ox_inventory)

## Installation

1. Download the latest release
2. Place `pf_blackmarket` in your resources folder
3. Add `ensure pf_blackmarket` to your server.cfg (after dependencies)
4. Configure `config/config.cl.lua` and `config/config.sv.lua`
5. Restart your server

## Configuration

### Client Config

```lua
-- config/config.cl.lua
{
  ImageUrl = "nui://ox_inventory/web/images/",

  Stores = {
    downtown = {
      PaymentType = PaymentType.BANK,       -- CASH or BANK
      CashItem = "money",                   -- Item used for cash payments
      RelocationSchedule = CronSchedule.EVERY_30_MINUTES,
      Peds = {
        {
          model = "g_m_m_chiboss_01",
          scenario = "WORLD_HUMAN_STAND_IMPATIENT",
          possibleLocations = {
            vector4(-133.48, -673.64, 48.23, 71.55),
          },
        },
      },
      Categories = {
        weapons = {
          label = "Weapons",
          icon = "fas fa-gun",
          items = {
            { name = "WEAPON_PISTOL", label = "Pistol", price = 5000, maxAmount = 1 },
          },
        },
        materials = {
          label = "Materials",
          icon = "fas fa-box",
          items = {
            { name = "iron", label = "Iron", price = 100, maxAmount = 50 },
          },
        },
      },
    },
  },
}
```

### Server Config

```lua
-- config/config.sv.lua
{
  DiscordWebhook = "",              -- Discord webhook URL for logging

  Logging = {
    Enabled = true,
    UseOxLogger = true,             -- Log via ox_lib logger
    UseDiscordWebhook = true,       -- Log via Discord webhook
  },
}
```

## Usage

1. Players approach a blackmarket NPC dealer
2. Interact via ox_target to open the shop UI
3. Browse categories, add items to cart
4. Purchase items — payment is deducted and items are added to inventory
5. If inventory is full, the transaction is rolled back and payment refunded

## UI Source

UI source code is not included. The built UI is bundled in `web/dist/`.

## Links

- [Patchflow](https://patchflow.md/)
- [Support & Issues](https://patchflow.md/)
- [Docs](https://docs.patchflow.md/PFBlackmarket)

## License

Copyright Patchflow. All rights reserved.
