# Reusable models

Create one reusable `.tscn` per model. Store new models in the category folders below; the numbered scenes in this folder are the existing starter kit and remain in place to avoid breaking references.

- `buildings/`: building shells and variants by use.
- `modular/`: wall, roof, stair, door, window, foundation, and structural pieces.
- `props/`: non-character objects by environment or gameplay role.

Prefer composition from shared modules over dozens of nearly identical files. Give each scene a meaningful origin and scale in meters. Include collision on solid gameplay objects; omit it for nonblocking visual detail and label that choice in the asset catalog.
