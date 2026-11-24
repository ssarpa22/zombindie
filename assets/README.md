# Zombindie asset library

This folder is the permanent home for reusable game assets. Keep reusable source models separate from placed world instances.

- `models/`: reusable meshes and primitive-built model scenes. New content goes into the named category folders; the numbered scenes in the root are the existing first-pass kit and must not be moved without checking references.
- `entities/`: reusable actors and interactive objects with their scripts, collision, and behavior.
- `scenes/`: assembled, placeable prefabs made from models, such as a complete house, room, prop cluster, or biome set.
- `materials/`: editable Godot material resources and shared palettes.
- `textures/`: source texture images and decals, organized by use.
- `data/catalogs/`: editable indexes and metadata for assets.

Model scenes should have a clear root, descriptive child names, reasonable origins, collision shapes appropriate to gameplay, and no hard-coded world coordinates. Place instances in `WorldEditable.tscn`, not in this reusable library.
