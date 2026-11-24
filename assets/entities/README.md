# Entities

Entities are reusable world actors or interactive objects, not static mesh-only building blocks. Keep the visual scene, behavior script, collision, and interaction contract together where practical.

- `characters/`: player body and future wearable/appearance components.
- `npcs/`: survivor and trader archetypes.
- `infected/`: dormant prototype assets only while the project keeps infected disabled.
- `animals/`: wildlife and ambient creatures.
- `interactive/`: doors, containers, switches, beds, hatches, generators, and world devices.
- `loot/`: pickup scenes and item world representations.

Do not spawn dormant content automatically. Use typed scripts, stable IDs, and explicit collision layers/masks.
