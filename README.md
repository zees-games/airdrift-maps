# airdrift-maps

The bunny-hop and surf maps for [Airdrift](https://github.com/zees-games/game-airdrift), imported from community maps. (This repository was called g2gfast-maps until 2026-11-11.)

Every map is somebody else's work, made for the genre years ago and imported so it can be played again. Each one is credited below and on screen when a server changes to it. If you made one of these maps and want it credited differently or taken down, open an issue and it will be done.

Combat surf maps (deathmatch to fight on, not a course to time) live in fc-surf-dm-maps instead.

## Why the maps are not in the game

A player joining a server downloads only the map that is running. Each map is published as its own signed pack, `gamemann/<map id>`, and the game fetches the one it needs on a map change. Keeping the maps here means a map can be added, fixed or withdrawn without a game release, and a clone of the game stays small.

## Layout

| Path | Contents |
| --- | --- |
| `maps/<id>/<id>.json` | The map manifest the importer produced |
| `maps/<id>/<id>.bin` | Geometry |
| `maps/<id>/textures/` | Textures and their `.import` markers |
| `worlds/` | The shared importer's output |
| `maps.json` | Every map with author and source page |
| `licence.json` | Licence record per map |
| `tools/g2gmaps` | The command line tool (below) |

Zone data (starts, finishes, stages) stays in game-airdrift under `maps/zones/`, because it is gameplay the game defines.

## Using it

```bash
# Link the game's maps/imported to this repository's maps/ for development.
tools/g2gmaps link

# Check every spawn and teleport destination lands in playable space (CI runs this).
tools/check_playable.py

# Rewrite maps.json after adding or removing a map (credits come from the game's zones files).
tools/g2gmaps manifest

# Mirror every published map from the content origin into mirror/, each file checked
# against its hash (and its signature with --pub). Needs only Python 3.
tools/g2gmaps fetch --pub path/to/content.pub
```

`tools/g2gmaps publish --key path/to/content.key` signs every map as `gamemann/<id>` into `dist/`. It runs through the game's `tools/publish_maps.sh`, so it needs Godot and the game checked out beside this repository with `link` done.

Releasing is a tag: `git tag v1.x.y && git push --tags`. `.github/workflows/release.yml` imports the maps and attaches one pack zip per map.

## The collection

Every published map belongs to the collection `gamemann/airdrift-maps`. A server that lists `gamemann/airdrift-maps/*` gets all of them, and new maps on its next start. The old id `gamemann/g2gfast-maps/*` still works as an alias until 2027-03-01. Change server map lists to the new id before then.

## Credits

Maps are GameBanana uploads. They are published under the credited-community-map exception in `licence.json`, with this credit, the source link and a removal offer. Where a source page states a licence it is shown, otherwise the page does not forbid sharing or porting. Extra credits (textures, skyboxes, testers) are listed with the author. The repository's own tooling is MIT, by TMC.

| Map | Author | Source | Licence |
| --- | --- | --- | --- |
| `bhop_amor` | roma | https://gamebanana.com/mods/124424 | CC BY-NC-ND 4.0 |
| `bhop_ananas` | serz | https://gamebanana.com/mods/124428 | None stated on the source page |
| `bhop_angst` | Proxychains | https://gamebanana.com/mods/303411 | CC BY-NC-ND 4.0 |
| `bhop_arcane_v2` | Panzerhandschuh (Panzer); v2 edit uploaded by 'roger haha lol' | https://gamebanana.com/mods/124462 | None stated on the source page |
| `bhop_atmosphere` | ampbhop | https://gamebanana.com/mods/124486 | CC BY-NC-ND 4.0 |
| `bhop_aztec` | Teho-Killeri (mapper), with Touch (design) and Veikko (textures) | https://gamebanana.com/mods/124514 | None stated on the source page |
| `bhop_badges` | badges (Badgeslol) | https://gamebanana.com/mods/124524 | None stated on the source page |
| `bhop_badges2` | Badgeslol | https://gamebanana.com/mods/124525 | None stated on the source page |
| `bhop_badges_mini` | GumPum | https://gamebanana.com/mods/124526 | None stated on the source page |
| `bhop_crash_egypt` | FireWavezZ and Ghost1302672 | https://gamebanana.com/mods/124748 | None stated on the source page |
| `bhop_depot` | ballz of steel | https://gamebanana.com/mods/124816 | CC BY-NC-ND 4.0 |
| `bhop_eazy` | 31K4L | https://gamebanana.com/mods/124913 | None stated on the source page |
| `bhop_eazy_v2` | 31K4L | https://gamebanana.com/mods/124915 | None stated on the source page |
| `bhop_elate` | biql | https://gamebanana.com/mods/124933 | None stated on the source page |
| `bhop_epiphany` | wet | https://gamebanana.com/mods/124957 | CC BY-NC-ND 4.0 |
| `bhop_evolve` | Zyper | https://gamebanana.com/mods/124971 | None stated on the source page |
| `bhop_exanimo` | WorldspawN, Drouzefa | https://gamebanana.com/mods/369680 | CC BY-NC-ND 4.0 |
| `bhop_exodus` | Aoki | https://gamebanana.com/mods/124977 | None stated on the source page |
| `bhop_forgotten` | sexy but not trying.. | https://gamebanana.com/mods/125063 | CC BY-NC-ND 4.0 |
| `bhop_freakin` | FreAkin | https://gamebanana.com/mods/125076 | CC BY-NC-ND 4.0 |
| `bhop_frotinity2` | FlowBhop (stages 1 and 6), Kotzilla (2), muhamadnjak (3), Sonia_ (4), Linirin (5, 7), ampbhop (8) | https://gamebanana.com/mods/125089 | None stated on the source page |
| `bhop_fur` | Fur (TheFur) | https://gamebanana.com/mods/125103 | None stated on the source page |
| `bhop_fury` | Dotty | https://gamebanana.com/mods/125105 | CC BY-NC-ND 4.0 |
| `bhop_fury_2` | Dotty | https://gamebanana.com/mods/125106 | None stated on the source page |
| `bhop_grove` | Tony Montana | https://gamebanana.com/mods/125167 | None stated on the source page |
| `bhop_hellish_dream_css` | Sonia_ | https://gamebanana.com/mods/125200 | CC BY-NC-ND 4.0 |
| `bhop_interloper` | Tony Montana | https://gamebanana.com/mods/125285 | None stated on the source page |
| `bhop_japan` | Tony Montana | https://gamebanana.com/mods/125304 | None stated on the source page |
| `bhop_lego2` | Tony Montana (tmontana) | https://gamebanana.com/mods/125408 | None stated on the source page |
| `bhop_lego3` | tmontana | https://gamebanana.com/mods/125409 | None stated on the source page |
| `bhop_monster_jam` | monster jam and Aoki | https://gamebanana.com/mods/125558 | None stated on the source page |
| `bhop_nature` | BLENDIE | https://gamebanana.com/mods/125590 | None stated on the source page |
| `bhop_null_fix` | Tony Montana | https://gamebanana.com/mods/125638 | CC BY-NC-ND 4.0 |
| `bhop_ocean` | Tony Montana (tmontana) | https://gamebanana.com/mods/125646 | None stated on the source page |
| `bhop_overthinker` | Proxychains | https://gamebanana.com/mods/125694 | None stated on the source page |
| `bhop_pandora2_fix` | Sonia_ (map); skybox Mr.Who; textures Wolves Hero and Sonia_; original bhop_pandora video/advice tmontana | https://gamebanana.com/mods/125705 | None stated on the source page |
| `bhop_pharma` | frostiee_ | https://gamebanana.com/mods/125728 | CC BY-NC-ND 4.0 |
| `bhop_pit` | Roady | https://gamebanana.com/mods/453100 | None stated on the source page |
| `bhop_platformer_fxd` | DroN (SWM\|DroN) | https://gamebanana.com/mods/125494 | None stated on the source page |
| `bhop_sqee` | sQee, QuiSt, KorYouZ, lólmarcel, dawn, Ray-on.NoOb, nairda | https://gamebanana.com/mods/126077 | None stated on the source page |
| `bhop_strength_v2` | BLENDIE | https://gamebanana.com/mods/126122 | CC BY-NC-ND 4.0 |
| `bhop_supernova` | Sonia_ (map design) and Benchmarked (gameplay); skybox Mr.Who; textures TopHATTwaffle and Sonia_; testers Juked, tricksterr, plar, samurai; Subnautica models by Unknown Worlds Entertainment | https://gamebanana.com/mods/313046 | None stated on the source page |
| `bhop_tesquo_v2` | george (GeorgeRulesLOL); 'Made a stage': Jagg | https://gamebanana.com/mods/126185 | None stated on the source page |
| `bhop_toroux` | toroux | https://gamebanana.com/mods/126232 | CC BY-NC-ND 4.0 |
| `bhop_training_fun` | Soapy Soap | https://gamebanana.com/mods/126237 | CC BY-NC-ND 4.0 |
| `bhop_tranquility` | Nallieheai | https://gamebanana.com/mods/126240 | CC BY-NC-ND 4.0 |
| `bhop_underground_crypt` | Yaznee | https://gamebanana.com/mods/126281 | None stated on the source page |
| `bunnyhop_pro` | win32 | https://gamebanana.com/mods/126426 | None stated on the source page |
| `buses_from_hell_fixed` | siXMan | https://gamebanana.com/mods/127607 | None stated on the source page |
| `kz_bhop_badg3s` | Badgeslol | https://gamebanana.com/mods/126445 | None stated on the source page |
| `kz_bhop_lucid` | Ghost1246511 | https://gamebanana.com/mods/126473 | None stated on the source page |
| `kz_bhop_yonkoma` | Aoki | https://gamebanana.com/mods/126499 | None stated on the source page |
| `surf_animals` | Razer, AmstaFF, Frizzlehead9, Robsonfire, Ton!x, Silverlol, Hellraisedsurfer, Nitro | https://gamebanana.com/mods/121629 | None stated on the source page |
| `surf_aquaflow` | NvC_DmN_CH | https://gamebanana.com/mods/137715 | None stated on the source page |
| `surf_arcade` | maz64 (maz) | https://gamebanana.com/mods/137716 | None stated on the source page |
| `surf_beginner` | Kiiru | https://gamebanana.com/mods/121714 | None stated on the source page |
| `surf_beginner2` | Kiiru | https://gamebanana.com/mods/137722 | None stated on the source page |
| `surf_eclipse` | Paper-Cut | https://gamebanana.com/mods/121976 | None stated on the source page |
| `surf_ember` | Skar | https://gamebanana.com/mods/122002 | CC BY-NC-ND 4.0 |
| `surf_greensway` | NvC_DmN_CH | https://gamebanana.com/mods/137798 | None stated on the source page |
| `surf_hologram` | Chent | https://gamebanana.com/mods/525468 | CC BY-NC-ND 4.0 |
| `surf_interference` | NvC_DmN_CH | https://gamebanana.com/mods/137815 | None stated on the source page |
| `surf_intro` | Chent | https://gamebanana.com/mods/524245 | CC BY-NC-ND 4.0 |
| `surf_kitsune` | Arblarg | https://gamebanana.com/mods/122382 | None stated on the source page |
| `surf_life_of_duck` | SKAR | https://gamebanana.com/mods/122432 | None stated on the source page |
| `surf_lithium` | copy-mark and jesuswashomeless | https://gamebanana.com/mods/122444 | CC BY-NC-ND 4.0 |
| `surf_lithium2` | copy-mark | https://gamebanana.com/mods/122445 | CC BY-NC-ND 4.0 |
| `surf_lore` | target practice | https://gamebanana.com/mods/122463 | None stated on the source page |
| `surf_lt_omnific` | nyro (lead), qr, checkem | https://gamebanana.com/mods/122470 | None stated on the source page |
| `surf_lt_unicorn` | nyro | https://gamebanana.com/mods/122471 | None stated on the source page |
| `surf_mesa` | Arblarg | https://gamebanana.com/mods/122542 | None stated on the source page |
| `surf_omnibus` | SKAR | https://gamebanana.com/mods/122673 | None stated on the source page |
| `surf_quilavar` | Rapsodia, finished by Helix | https://gamebanana.com/mods/122802 | None stated on the source page |
| `surf_rookie` | Kiiru, Sacred91, Zeedz, Retarded brother | https://gamebanana.com/mods/122860 | None stated on the source page |
| `surf_stonework3` | Mr.Cow | https://gamebanana.com/mods/123058 | None stated on the source page |
| `surf_stonework4` | Mr.Cow | https://gamebanana.com/mods/123059 | CC BY-NC-ND 4.0 |
| `surf_summit` | Juxtapo and Phurix | https://gamebanana.com/mods/137705 | None stated on the source page |
| `surf_vegetables` | JacktheStripper, Jamz, Silverlol, Rapsodia, Coley, Skittles, Shahzam, Komaokc, Lody Blakody, Kb.Uni.Namer, Electric, Robsonfire, Machine, Hellraisedsurfer, G-Flow | https://gamebanana.com/mods/123222 | None stated on the source page |
| `surf_year3000` | ArchAngel | https://gamebanana.com/mods/123298 | None stated on the source page |

If you made one of these maps and want it removed, open an issue at https://github.com/zees-games/airdrift-maps/issues.
