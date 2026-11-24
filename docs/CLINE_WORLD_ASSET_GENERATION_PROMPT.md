# Cline prompt: Zombindie world asset library

Copy the prompt below into Cline while the `zombindie` repository is open.

---

## PROMPT

Work directly in the current Zombindie repository. Build a substantial, organized, reusable 3D asset and entity library using Godot 4.7-native scenes and code. The goal is for the developer to assemble and edit the world in Godot without requiring Blender for the first production pass.

### Project context

- Engine: Godot 4.7.
- Renderer: `gl_compatibility`; use features supported by this renderer and target modest PCs.
- Art direction: low-poly, muted, worn, grounded survival horror with the restrained geometry and material detail of a late-1990s/early-2000s console game. Use original designs. Do not copy copyrighted characters, logos, or recognizable locations.
- Existing world: `Main.tscn` instances `WorldEditable.tscn`. The world uses low-poly geometry, a forest, a hospital, roads, a police station, distant locations, and a hand-authored world layout.
- Existing assets: the repository already has a first-pass model kit and a `WorldAssetLibrary.tscn`. Inspect them before adding anything. Reuse, improve, and extend them; do not overwrite or duplicate existing assets blindly.
- The active gameplay prototype currently keeps infected disabled. Keep new infected scenes dormant and do not spawn them or turn them on.
- The developer wants to drag, place, move, duplicate, remove, and modify individual assets in Godot's Scene tree and Inspector. Do not hide the useful asset content solely inside a runtime generator.

### First: inspect and preserve

1. Read the project tree, `project.godot`, `Main.tscn`, `WorldEditable.tscn`, `WorldLayout.tscn`, `forest_world.gd`, existing asset scenes, entity scripts, and Git status.
2. Preserve all user changes. Do not reset, revert, clean, or overwrite unrelated files.
3. Find the existing naming, scale, collision, material, and scene conventions. Reuse them where sound.
4. Report any existing broken references discovered, and fix only those that block this asset-library work.

### Required folder structure

Use the existing folders and extend them consistently:

```text
assets/
  models/
    buildings/
      residential/ commercial/ civic/ industrial/ medical/
      education/ religious/ hospitality/
    modular/
      walls/ roofs/ stairs/ windows/ doors/ foundations/ structural/
    props/
      urban/ industrial/ medical/ hospital/ interior/
      forest/ natural/ survival/
  entities/
    characters/ npcs/ infected/ animals/ interactive/ loot/
  scenes/
    buildings/ props/ entities/ biomes/ world/
  materials/
    palettes/ surfaces/ decals/
  textures/
    surfaces/ decals/
  data/catalogs/
```

Keep reusable source models under `models/`, assembled drag-and-drop prefabs under `scenes/`, behaviors under `entities/`, and shared materials/textures in their own folders. Do not place the reusable asset library into the playable map as one giant object. Build an `AssetLibrary.tscn` showroom with organized category groups and a manageable display layout, while keeping every asset available as an individual `.tscn` scene in the FileSystem dock.

### Asset authoring constraints

- Build models with native Godot meshes and typed GDScript: `BoxMesh`, `CylinderMesh`, `PrismMesh`, `PlaneMesh`, `ArrayMesh` only when needed, `MeshInstance3D`, and simple reusable scripts/resources.
- Do not add Blender-only files, external packages, online assets, or network downloads.
- Do not create one mesh per decorative leaf or bolt. Keep geometry modest and recognizable. Use shared materials and repeated modules.
- Every asset must have a predictable real-world scale in meters, a useful origin/pivot, a descriptive scene root, readable child names, and consistent forward orientation.
- Solid gameplay assets must include a sensible `StaticBody3D` and collision shape. Use simple collision approximations, not high-detail mesh collisions. Visual-only details should be nonblocking and explicitly marked as such in the catalog.
- For modular pieces, give dimensions and connector conventions in the catalog so pieces align cleanly on a 1 m grid or documented module size.
- Avoid all assets being the same box with only a different name. Vary silhouette, roof profile, entry, window pattern, attached details, damage state, and footprint. Keep variants art-directed and deterministic.
- Use shared `.tres` materials from `assets/materials/`. Provide muted material palettes for painted metal, rust, concrete, brick, wood, glass, tile, asphalt, dirt, gravel, grass, foliage, cloth, and medical plastics. Materials are placeholders; do not invent a 100-texture atlas as part of this task.
- Use collision layers/masks that do not interfere with player, interaction, or camera raycasts. Document each layer convention.
- Add short descriptions and metadata: stable asset ID, category, tags, footprint, collision type, visual-only status, and intended placement.

### Minimum content targets

Treat these as a minimum complete first library, not as permission to stop after adding a few generic props. Aim for at least 280 distinct reusable entries across individual models and intentionally varied assembled variants. Use modular composition to reach building variety without copying the same shell under many names.

#### A. Modular architecture kit: at least 40 pieces

Create separate editable scenes for:

- Walls: `Wall_1x1`, `Wall_2x1`, `Wall_4x1`, corner, interior partition, foundation wall, damaged wall, half wall, retaining wall.
- Openings: solid wall, hospital window opening, apartment window opening, industrial window opening, door opening, double-door opening, boarded window, broken window frame, shopfront glazing.
- Doors: hospital interior door, security door, apartment door, garage roller door, double entrance door, damaged/boarded door, sewer hatch.
- Roofs: flat roof, parapet edge, low pitched roof, ridge/corner/side pieces, corrugated industrial roof, damaged roof section, awning/canopy.
- Floors and foundations: slab, tiled interior floor, sidewalk curb, raised foundation, floor edge, stair landing.
- Stairs: short interior stairs, long stairs, concrete steps, metal fire escape, ladder, handrail, railing segment.
- Exterior pieces: chimney, porch, balcony, fire escape landing, loading dock, downpipe, gutter, support column, lintel.

Provide modular lengths and pivots so pieces snap together. Include collision with proper gaps for doors, windows, stairs, and walkable floors.

#### B. Buildings: at least 100 distinct assembled variants

Create original, low-poly building prefabs with editor-visible component structure. Cover at least:

- Small single-story home, damaged cottage, rural farmhouse, two-story home, duplex, row house, apartment block, small apartment building, larger apartment facade, abandoned rental house.
- Corner store, grocery store, supermarket, diner, gas station shop, motel, hotel, roadside motel, office, bank shell, pharmacy, hardware store, warehouse, storage building.
- Hospital main block, clinic annex, ambulance bay, medical outbuilding, school, classroom wing, gym hall, police station, police substation, holding-cell block, fire station, church, small chapel, municipal office, ranger station.
- Factory, machine shop, garage, auto repair workshop, loading depot, cold storage warehouse, water-pumping station, power substation, bus terminal, highway service station, roadside checkpoint, maintenance shed.

Reach the target through meaningful modular combinations and authored variations: different footprints, roof shapes, window layouts, entries, porches, awnings, damage states, and material assignments. Use deterministic seeds only for intentional decorative variation. Each assembled building must be its own `.tscn`, have named subgroups such as `Structure`, `Roof`, `Openings`, `Interior`, `Collision`, and remain editable in the Godot editor.

#### C. Urban and road props: at least 60 assets

Include street lamps, wall lamps, benches, trash bins, mailboxes, phone booths, utility poles, power transformers, traffic lights, road signs, warning signs, bus shelters, hydrants, bollards, jersey barriers, construction barriers, traffic cones, dumpsters, street drains, storm grates, manhole covers, sewer access hatches, fire escapes, railings, gates, fences, curb modules, road markers, broken street furniture, and abandoned vehicles represented with original low-poly meshes.

Provide fence families: wood picket, farm rail, chain-link, concrete perimeter, damaged chain-link, barbed-wire-topped wall, gate, broken fence section, and corner/junction pieces. Make segments tile without gaps and provide matching collision.

#### D. Industrial and survival props: at least 50 assets

Include barrels, fuel drums, gas canisters, generators, portable generators, transformers, pipes, elbows, joints, valves, ducts, vents, tanks, pumps, compressors, crates, pallets, metal cabinets, toolboxes, ladders, cable reels, electrical boxes, battery boxes, emergency lights, traffic barricades, work lights, lockers, and maintenance carts.

#### E. Hospital and interior props: at least 50 assets

Include hospital bed, gurney, stretcher, wheelchair, bedside table, examination table, privacy screen, IV stand, medical cabinet, filing cabinet, locker, reception desk, office desk, chair, waiting bench, shelf, supply cart, medicine cabinet, sink, wall-mounted dispenser, medical monitor, oxygen cylinder, laundry hamper, waste bin, rolling cart, broken ceiling fixture, wall clock, shelving unit, door signage, and modular room fixtures.

Separate movable and fixed props. Give movable items a `RigidBody3D` only if they are intended to move physically; otherwise use `StaticBody3D` and simple collision.

#### F. Forest, natural, and roadside assets: at least 30 assets

Include conifer tree variants, dead tree, snapped tree, fallen log, stump, roots, shrubs, low and tall grass clumps, rocks, boulders, rock outcrops, mossy stone, roadside ditch segment, dry creek bed, bridge module, culvert mouth, trail sign, rusted sign, ranger marker, broken fence, and forest debris clusters.

Keep tree silhouettes efficient and suitable for `MultiMesh` use. Provide a reusable tree scene as well as individual display variants. Do not use collision on each leaf; use a trunk capsule/box only where appropriate.

#### G. Entities and interactive scenes

Organize reusable entity scenes for the player appearance preview, trader/survivor archetypes, animals, loot pickup visuals, doors, containers, generators, beds/rest spots, switches, light fixtures, world documents, sewer hatches, and gates. Include typed scripts, stable IDs, collision, and interaction hooks where gameplay requires them. Keep zombies/infected as dormant model/entity prototypes only; do not spawn them or re-enable them.

### Asset catalog and showroom

- Add an editable Godot-native catalog at `assets/data/catalogs/` describing every asset and scene path.
- Use stable IDs and unique names; validate that every catalog path exists.
- Include category, subcategory, display name, size/footprint, tags, collision policy, interaction type, module dimensions, and placeholder-material family.
- Build `AssetLibrary.tscn` as a showroom with category folders and clearly named individual instances spaced for inspection. The showroom is for browsing and copying; do not instance the entire showroom into `WorldEditable.tscn`.
- Add a concise README with instructions for opening the library, instancing an asset, editing its materials/collision, and adding a new catalog entry.

### Performance and maintainability

- Reuse mesh and material resources where practical; avoid per-frame allocation and hundreds of unnecessary lights.
- Keep compatibility with `gl_compatibility`.
- Use `MultiMesh` only for repeated noninteractive scenery where appropriate; individual buildings, doors, furniture, and gameplay props must stay as editable scene nodes.
- Do not bake all geometry into one opaque mesh or one huge packed scene.
- Do not change the current map, survival systems, UI, weather, active world scale, or gameplay balance as a side effect.
- Keep existing assets and their paths stable. Do not delete or move the current first-pass kit.
- Use typed GDScript and avoid duplicate constants/variables, unsafe inferred types, and unsupported renderer properties.

### Validation requirements

1. Run Godot 4.7 headless editor parsing and resource scanning.
2. Load every generated scene from the catalog in a validation pass. Verify each scene root, mesh resources, materials, stable ID, and required collision node.
3. Open/load `AssetLibrary.tscn` headlessly and run the current `Main.tscn` briefly to ensure the new assets did not break the game.
4. Report exact counts by category and list any intentional visual-only assets that do not have collision.
5. Do not claim that the asset set is visually polished without inspecting it in Godot's 3D viewport. If visual verification is unavailable, state that.
6. Review Git status and diff; preserve unrelated changes.

Do not commit or push. Leave the work in the local repository. Do not stop after writing a plan: implement the folders, scenes, materials, catalog, showcase, and validation now.

---
