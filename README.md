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

## Base de desarrollo actual

La escena principal conecta el mundo, el jugador, `WeatherSystem` y un `GameSession` que coordina los sistemas de supervivencia, inventario, progresión, objetivos, descubrimiento, guardado, construcción y HUD. Los subsistemas viven en archivos separados dentro de `systems/`, `entities/` y `ui/`.

## Prototipo actual

La primera escena contiene recepción, un pasillo y salas laterales con puertas interactivas, mosaicos de piso, texturas pixeladas y detalles de deterioro. Una extensión conectada agrega cuatro consultorios en 100 m² y un segundo piso transitable con escalera al fondo del pasillo. La salida de emergencia tiene una abertura entre la barricada y conduce a un camino de tierra que cruza un bosque nocturno de 300 m de radio hasta una comisaría abandonada. Las ventanas dejan entrar luz lunar direccional y sombras sobre el piso. La iluminación interior parpadea de forma irregular y el movimiento de cámara tiene una oscilación corporal sutil.

### Controles

- WASD: moverse.
- Shift: sprintar.
- Mouse: mirar.
- E: abrir o cerrar puertas que tengas enfrente.
- F: encender o apagar la linterna.
- V: activar o desactivar vuelo sin colisiones.
- Con vuelo activo, Espacio sube y C baja.
- Escape: soltar el mouse; clic para volver a capturarlo.
- Clic izquierdo: golpe cuerpo a cuerpo.
- 1: usar agua; 2: comer; H: usar venda o botiquín.
- I: abrir la mochila; B: construir una barricada si llevás 3 tablas y 1 chatarra.
- F5: guardar; F9: cargar.
- F6: abrir/cerrar el selector de clima; G avanza el clima. Con el selector abierto, 1–6 eligen un modo.

### Interfaz y presentación

- La ventana inicia en 1920 × 1080, en modo ventana; la resolución y el modo de pantalla siguen disponibles en Opciones.
- El HUD compacto muestra estado, sector, hora/clima y objetivo con paneles retractables y accesos rápidos inferiores; la mochila separa suministros, medicina y materiales, informa el peso y permite usar consumibles.
- La pausa ofrece reanudar, guía, guardar, cargar y volver al menú. Los registros encontrados se muestran en una ventana de lectura.
- El menú principal, la pausa, la guía y el selector de clima comparten una presentación de alto contraste; las opciones están agrupadas por pantalla, sonido, cámara y reasignación de teclas.

### Sistemas jugables conectados

- Necesidades de hambre, sed, aguante y temperatura, además de salud, heridas e infección.
- Mochila con peso que reduce la velocidad cuando se acerca al límite.
- Saqueo de agua, comida, vendas, botiquín, tablas y chatarra.
- Infectados caminantes y corredores con visión, oído, investigación de ruidos, persecución, obstáculos y ataques; eventos ambientales pueden atraer más, con un límite activo.
- Combate cuerpo a cuerpo, muerte de infectados, experiencia y habilidades.
- Misión de recuperar el botiquín y llegar a la comisaría; mapa con coordenadas y lugares descubiertos.
- Ciclo día/noche de 30 minutos, seis climas seleccionables y comerciantes con un intercambio de comida por medicina.
- Barricadas construibles, partida guardada en `user://zombindie_save.cfg` y HUD de estado.
- Lugares de descanso en la clínica y la comisaría; al utilizarse recuperan aguante y heridas mientras hace pasar seis horas de juego, con un periodo de recuperación antes de volver a usarlos.
- Notas ambientales de la clínica y la comisaría que se pueden leer desde el mundo y muestran su contenido en el HUD.
- 2.000 ubicaciones de detalles del bosque procesadas en seis lotes de MultiMesh.

### Prueba automatizada

En Godot, se puede abrir y ejecutar `weather_smoke_test.tscn` para recorrer los seis climas y probar saqueo, consumibles, comercio, misión, combate, construcción y guardado/carga. También se puede ejecutar desde una terminal con:

```powershell
godot --headless --path . res://weather_smoke_test.tscn
```

Para jugar, ejecutar `Main.tscn` con F6 o F5 desde el editor, o iniciar el proyecto con `godot --path .`.

### Límites pendientes

- El mundo actual es una sola región circular de bosque con clínica y comisaría; todavía no hay streaming de chunks, biomas adicionales ni interiores generados.
- Los infectados usan navegación directa con desvío local, no un grafo de navegación completo. Los eventos agregan infectados cerca del jugador y están limitados a ocho activos.
- El combate actual es cuerpo a cuerpo; no hay armas de fuego, munición, hitboxes por extremidad ni animaciones.
- La construcción permite colocar barricadas; todavía no hay sistema de reparación, deterioro ni estaciones de fabricación.
- La comerciante Elena ofrece un único intercambio. Facciones, relaciones, diálogos ramificados y comercio general quedan pendientes.
- El guardado conserva posición, necesidades, mochila, progresión, misión, lugares conocidos y hora del mundo; aún no serializa infectados, botín del mapa ni barricadas colocadas.
- Los ruidos modifican la percepción de los infectados y notifican eventos en pantalla, pero todavía no hay recursos de audio integrados.

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
