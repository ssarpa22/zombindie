# Prototipo de terror de supervivencia

## Idea

Juego indie de terror de supervivencia en primera persona, con estética 3D de baja fidelidad inspirada en el terror de comienzos de los 2000. La identidad, los personajes, los escenarios y los recursos serán originales.

## Objetivo del primer prototipo

Crear una demo de 10 a 15 minutos en una clínica pequeña durante un apagón. El jugador explora, administra la linterna y pocos recursos, evita o enfrenta a un zombi y encuentra la salida.

## Bucle de juego

Explorar → encontrar recursos o pistas → decidir si evitar o enfrentar una amenaza → abrir una ruta → llegar a un lugar seguro.

## Alcance inicial

- Movimiento y cámara en primera persona.
- Una clínica compacta con pasillo y algunas salas.
- Linterna con batería limitada y sonido ambiental.
- Un zombi que reacciona a la vista y al ruido.
- Poca munición y un objeto de curación.
- Un objetivo simple para habilitar la salida.

## Fuera del primer prototipo

Mundo abierto, historia completa, varios tipos de enemigos, fabricación y sistemas complejos de inventario.

## Prototipo actual

La primera escena contiene recepción, un pasillo y salas laterales con puertas interactivas, mosaicos de piso, texturas pixeladas y detalles de deterioro. Las ventanas dejan entrar luz lunar direccional y sombras sobre el piso; afuera hay un claro con bosque, niebla y luna llena. La iluminación interior parpadea de forma irregular, el movimiento de cámara tiene una oscilación corporal sutil y el techo se solapa con las paredes para cerrar las rendijas.

### Controles

- WASD: moverse.
- Mouse: mirar.
- E: abrir o cerrar puertas que tengas enfrente.
- F: encender o apagar la linterna.
- Escape: soltar el mouse; clic para volver a capturarlo.

El escenario usa modelos geométricos y texturas generadas dentro del proyecto; no requiere paquetes de pago ni recursos externos.

### Abrir y ejecutar

1. Instalar Godot 4.x.
2. En Godot, importar el archivo `project.godot` de esta carpeta.
3. Presionar F6 o F5 para ejecutar la escena.

También se puede editar el código en VS Code; Godot se usa para ejecutar y visualizar el juego.

## Decisiones provisionales

- Plataforma inicial: PC.
- Motor: Godot 4, renderer Compatibility (OpenGL 3.3 en escritorio).
- Prioridad de diseño: exploración tensa, recursos escasos y encuentros peligrosos.
- Estética: baja resolución y geometría sencilla; la API gráfica moderna no determina el estilo visual.

DirectX 7 no se usará como renderer inicial: es una API antigua y haría más difícil abrir, probar y distribuir el prototipo en equipos actuales. Compatibility apunta a hardware modesto mediante una API gráfica con soporte vigente. Los requisitos reales se comprobarán cuando tengamos una compilación para probar en distintos equipos.
