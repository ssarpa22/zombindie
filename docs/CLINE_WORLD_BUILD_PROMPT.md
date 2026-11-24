# Cline Prompt: Build the Zombindie World

Copy the prompt below into Cline with the Zombindie repository open.

---

## PROMPT

Work directly in the current local Zombindie repository. Design and implement a coherent, explorable, editable survival-horror world that expands the existing project. Do the work in the repository; do not stop after writing a plan. The result should be a world the developer can inspect and edit in Godot, not a black-box runtime-only generator.

### Project intent

Zombindie is a first-person, grounded survival-horror game inspired by the restrained atmosphere and environmental storytelling of late-1990s/early-2000s horror games. It should feel plausible, lonely, and navigable. Keep the current gameplay focus on exploration and survival; infected/zombie gameplay is intentionally dormant for now. Do not activate, spawn, or make the world depend on zombies.

The world should be a compact rural region that feels broad through sightlines, route choices, landmarks, and meaningful destinations. Prefer controlled, readable scale over multiplying the current map footprint without regard for traversal time, frame rate, or editing workload.

### 1. Inspect before editing

1. Read `project.godot`, the active main scene, current editable world scenes, world layout/configuration scripts, player movement and camera code, map UI, weather/time systems, asset catalogs, generated assets, and Git status.
2. Inspect the in-progress asset library and use its actual scenes and paths. Do not assume that another asset-generation task has completed; adapt to what exists at execution time.
3. Trace scene references and identify which scene is the real world entry point. Preserve that architecture where practical.
4. Record existing bugs or broken references relevant to world construction. Fix blockers encountered while implementing this task, without broad unrelated rewrites.
5. Preserve all user and in-progress Cline changes. Never reset, clean, revert, overwrite, or mass-rename files. Avoid duplicate assets and duplicate world systems.

### 2. Establish a coherent region and story context

Create a small rural district with a clear reason for its places and roads to exist together. Use the existing project lore where present; extend it consistently rather than replacing it. The regional layout should include, as supported by available assets:

- A small town center with a general store or supermarket, a few homes or apartments, service businesses, and recognizable civic buildings.
- A hospital or medical complex with a plausible service entrance, parking/loading access, and a road connection to town.
- A police station with a vehicle entrance, parking or yard, and a defensible perimeter.
- A residential edge that transitions naturally into fields or woodland.
- A large, dense forest zone with clear edges, interior clearings, trails, rocks, fallen timber, and occasional landmarks.
- A primary paved or damaged road connecting the district, plus secondary dirt/gravel roads, driveways, footpaths, and service access routes where appropriate.
- Optional distant or gated destinations such as a motel, gas station, workshop, school, church, industrial yard, drainage channel, or highway junction. Add them only when they serve navigation, lore, or exploration and can be supported by project assets.

Give each area a distinct visual identity and a plausible function. Do not scatter unrelated points of interest without road logic. Establish a short environmental narrative through evacuation traces, blocked routes, emergency notices, abandoned vehicles, utility failures, supply caches, and changes in lighting. Keep these clues diegetic and restrained; do not fill every surface with exposition.

### 3. Build the map in editable sectors

Organize the world into clearly named, reusable Godot scenes or parent nodes, such as town center, residential edge, hospital grounds, police station grounds, forest sectors, and road network. Match the existing project architecture instead of forcing these exact names.

- Keep reusable source assets separate from placed instances.
- Give every placed sector a useful root and descriptive child/node names.
- Use scenes, inherited scenes, packed scenes, or clearly grouped nodes that the developer can move, duplicate, hide, or delete in the editor.
- Keep important layout and world-generation parameters in a clearly named, editable Godot resource or configuration file. Include an Inspector-friendly description of what the main values control.
- If procedural placement is used, make it deterministic with a seed and expose the seed and key controls. Keep essential landmarks and road topology authored and stable. Do not make the entire world disappear into opaque generation code.
- Use explicit bounds and stable coordinates. Avoid hard-coded placement scattered across unrelated scripts.
- Do not add a second competing world entry point or replace the current one without tracing and updating all references safely.

### 4. Enforce natural placement rules

Treat roads, lots, buildings, forests, and paths as connected systems with placement constraints:

- Roads and driveable paths must remain clear of trees, rocks, props, buildings, and collision clutter. Put vegetation on verges with a visible shoulder, not on the usable surface.
- Buildings must sit on plausible, reasonably level lots, face an accessible street or path, have entrances that connect to walkable space, and avoid overlapping adjacent buildings.
- Driveways and service routes must connect to the road network. Do not place a service entrance behind an impassable wall or terrain edge.
- Cluster trees into forest masses and natural edges. Leave believable clearings, road corridors, sightline breaks, and walkable trails. Avoid uniformly random tree scatter and repeated grid patterns.
- Place rocks, logs, debris, fences, and signs where terrain and context support them. Keep gameplay routes and doorways clear unless an intentional, passable obstruction is designed.
- Avoid floating props, buried structures, z-fighting surfaces, holes, intersecting collision shapes, and abrupt terrain steps. Use gentle transitions where terrain meets roads and lots.
- Define a clear playable boundary using terrain, cliffs, water, fencing, dense impassable vegetation, or designed blocked routes. The player must never walk or fall into an unintended void.
- Make occlusion and collision behavior consistent with what the player sees. Ensure no invisible walls block intended routes and no missing collision lets the player pass through solid structures.

### 5. Make exploration readable and meaningful

- Create a route hierarchy: one or two primary connectors, secondary streets/service roads, and narrow footpaths or forest trails.
- Use landmarks visible from a distance—building silhouettes, a water tower, radio mast, distinctive roof, emergency beacon, or controlled light sources—to help the player orient themselves. Reuse existing assets where possible.
- Keep important destinations distinguishable by silhouette, lighting, signage, and approach path. Do not use excessive bright lights that destroy the night-horror mood.
- Provide multiple useful route choices where feasible, with tradeoffs such as exposure, distance, cover, or elevation, rather than a maze of decorative dead ends.
- Ensure the player can understand the local geography from the authored aerial map without rendering a screenshot of the 3D world. Draw roads, building footprints or icons, forest regions, landmarks, boundaries, and the live player marker from world-layout data.
- Keep the map's scale, orientation, and player marker aligned with the actual world coordinates. Add a simple legend and readable labels. If a map already exists, extend it instead of duplicating it.
- Provide concise in-world signs and road markings where they improve orientation. Ensure labels do not reveal information the player has not discovered if the project has fog-of-war or discovery logic.

### 6. Support the survival loop without zombie dependency

Give the landscape places and objects that support the current survival systems:

- Add plausible, sparse opportunities for water, food, first aid, warmth, rest, light, and basic tools, using existing item definitions where available.
- Separate relatively sheltered locations from exposed routes and dangerous environmental conditions. Let weather, time of day, temperature, visibility, and terrain influence route choices where those systems already exist.
- Use abandoned vehicles, barricades, damaged utilities, emergency lighting, storage areas, and signs of hurried evacuation as context and possible exploration cues. Do not silently invent new inventory or survival mechanics if a compatible system already exists.
- Avoid placing guaranteed high-value supplies everywhere. Distribution should support exploration and resource scarcity without requiring combat.
- Keep all enemy/infected actors dormant. Do not add active attacks, spawners, or enemy-dependent progression.

### 7. Atmosphere, day/night, weather, and comfort or threat

Integrate with the existing clock and weather systems. Do not create competing clocks, global environments, or weather managers.

- Make the cycle of day and night affect ambient light and existing lights coherently, with transitions that do not pop or cause severe performance spikes.
- Respect the project's weather definitions, including clear night, fog, overcast, rain, snow, and wind if implemented. Weather should change visibility and mood consistently; do not add a weather name whose appearance contradicts its definition.
- Use local lights sparingly and intentionally: emergency lamps, windows, street lamps, beacons, and interior lights should create navigational cues and believable pockets of shelter.
- Establish comfortable places through shelter, warmth, visibility, or quiet. Establish exposed or threatening places through distance, low visibility, wind, cold, darkness, and poor cover. Keep these effects compatible with existing gameplay values.
- Avoid expensive real-time shadow lights across the whole open world. Reuse existing lighting and quality settings; prioritize baked, unlit, or inexpensive forms where appropriate for the compatibility renderer and target PCs.
- Maintain the established retro low-poly visual direction. Use shared materials/palettes and restrained variation rather than many unique expensive materials.

### 8. World scale and performance

Build for the project's actual target hardware and renderer. Large-feeling world does not mean one enormous always-active scene.

- Inspect actual player speed, available world footprint, fog/view distance, and map scale before setting distances. Keep travel times intentional and communicate scale consistently.
- Divide the world into manageable sectors. Use the project's existing visibility/streaming strategy if one exists; do not add overlapping systems. If safe scene streaming is not currently practical, use simple distance-based visibility or sector activation with conservative defaults and no gameplay-state loss.
- Reuse meshes, materials, and packed scenes. Avoid duplicating unique geometry or creating a separate heavy material for every instance.
- Keep collision simple and only where it supports traversal or interaction. Avoid per-prop complex collision and excessive physics bodies.
- Avoid runtime construction of thousands of individual nodes where MultiMesh or a compact reusable scene is more appropriate. Keep editor-authored landmarks individually editable.
- Use sensible view distances, fog, and level-of-detail transitions consistent with existing settings. Prevent visible hard pop-in and maintain clear landmark silhouettes.
- Avoid per-frame scans of all world objects, expensive global ray tests, unnecessary shader complexity, and excessive shadow-casting lights.
- Do not trade away useful navigation or visible world context for a crude camera cone culling feature. Use Godot visibility/occlusion tools only when compatible with the scene setup and verify the player cannot see content disappear incorrectly.

### 9. Integration and implementation requirements

- Use the installed Godot version and syntax already used in the repository. Confirm actual project version and renderer settings before choosing APIs.
- Prefer native editable Godot scenes and resources with stable relative `res://` references. Do not require Blender, external downloads, or paid assets for the first pass.
- Reuse asset catalog conventions and place new files in the established folder structure. Keep source models, assembled prefabs, world sectors, materials, textures, and data in their correct categories.
- Preserve existing scene ownership and editability. World-specific placements belong in world/sector scenes, not in shared reusable source models.
- Use descriptive names and consistent scale/origin conventions. Avoid vague names like `Node3D2`, `BoxMesh17`, or `NewScene`.
- Add or update the aerial map from the same world-layout data used for placement, so the rendered level and map cannot drift apart.
- Add a small editor-friendly world overview or test scene if needed to inspect sectors and routes, while preserving the actual game entry scene.
- Do not change unrelated UI, player controls, inventory, or save formats unless a small integration change is required for the world to function. Preserve compatibility with existing saves where relevant.

### 10. Validation before finishing

Perform concrete checks, not just a visual code review:

1. Run Godot's headless editor/import check using the executable available on this machine, and report the exact command and result.
2. Load the active main scene and every new or modified world sector/prefab without parse errors or missing resources.
3. Check script parser errors, invalid node paths, duplicate identifiers, invalid property assignments, and broken scene/resource references.
4. Validate world-layout data for duplicate/overlapping building footprints, roads obstructed by props or trees, objects outside bounds, disconnected required destinations, and invalid map coordinates. Provide an automated validation script if it fits existing project conventions.
5. Check that the player spawn is on safe walkable ground, can reach the required core destinations, cannot fall outside the intended boundary, and does not spawn inside geometry.
6. Inspect the aerial map and confirm the player marker tracks the player in the same coordinate system and the roads/landmarks match the actual layout.
7. Check for severe performance pitfalls: excessive unique meshes/materials, unbounded scene trees, too many shadowed lights, too many active collision bodies, and duplicated full-world processing.
8. If GUI/visual testing is available, inspect the world in Godot and verify daylight, nighttime, weather states, route legibility, and obvious placement issues. If it is not available, state that limitation and complete all headless checks.
9. Review `git diff` and `git status`. Preserve unrelated user changes and do not stage, commit, push, or publish unless explicitly requested.

### Completion report

At the end, summarize the implemented sectors, major destinations and routes, assets reused or added, map integration, survival/environment integration, performance measures, files changed, validation commands and results, and any remaining limitations. Do not claim visual or runtime checks that were not performed. If a requirement cannot be completed because of a concrete project constraint, complete the independent work, explain the specific blocker, and leave a clear next step.

## END PROMPT
