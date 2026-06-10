# Plan Gráfico — NEXXO C2 (holo.com.co)

> Plan de prompts y especificaciones del material gráfico para cada pestaña del sitio.
> Estética: **Sovereign Meridian**. Generado para alimentar un modelo de imagen (Midjourney / Flux / Ideogram / DALL·E) o como brief para un ilustrador.

**Cómo usar este documento**
1. Lee el **Sistema Visual Global** (abajo). El bloque `ESTILO BASE` se antepone a *todos* los prompts.
2. Ve a la pestaña que vas a trabajar. Cada imagen trae: ruta de archivo, ubicación, tipo, dimensiones/aspecto, **prompt (en inglés)** y notas de "evitar".
3. Los prompts están en **inglés** a propósito: los modelos de imagen rinden mejor así. La estructura y notas van en español.
4. Tras generar, optimiza (ver **Convenciones Técnicas**): exporta a **WebP/AVIF** al tamaño de render, no a 1024² para mostrar a 220px.

---

## 1. Sistema Visual Global

### Filosofía (Sovereign Meridian)
Certeza localizada. *La precisión es belleza.* Cada marca existe porque fue "medida", no decorada. Composición **radial y axial a la vez**: arcos/anillos (el bucle de percepción) + retículas/ejes (la permanencia geográfica). Mucho espacio negativo = "el silencio antes de la señal". El oro **ubica, no adorna**.

### Paleta — SOLO 5 colores
| Rol | Hex | Uso |
|-----|-----|-----|
| Negro | `#000000` | Fondo modo oscuro, contraste máximo |
| Azul marino | `#001F3F` | Fondo dominante, superficie soberana |
| Dorado | `#D4AF37` | **Único acento cromático** — meridiano, arco, punto crítico |
| Gris claro | `#E7E7E5` | Superficies neutras, fondos claros |
| Blanco | `#FFFFFF` | Texto sobre oscuro, zonas de alto contraste |

> **Regla de oro:** el dorado aparece poco y con intención (localiza el punto clave). Ante la duda, quita color.

### `ESTILO BASE` — anteponer a TODOS los prompts
```
Sovereign Meridian visual system — Colombian sovereign defense technology.
Deep near-black and navy ground (#000000 / #001F3F), champagne gold (#D4AF37) as the
ONLY chromatic accent, used sparingly to locate the critical point — not to decorate.
Light grey (#E7E7E5) and white only for neutral surfaces and text.
Geometric precision: meridian arcs, concentric rings, radial grids, graticule lines,
coordinate/MGRS-style notation, tiny clinical annotations at the margins.
Authoritative, restrained, clinical. Vast negative space. Cinematic low-key lighting.
Looks like a master navigator's chart at dawn: functional at a glance, finer craftsmanship
the longer it is studied. Photoreal where photographic, precise vector where schematic.
```

### `EVITAR` (negative prompt — global)
```
no rainbow / multicolor, no generic teal sci-fi glow, no neon, no purple, no green UI,
no emojis, no cartoon, no clutter, no busy backgrounds, no lens flare overload,
no gibberish text / fake letterforms, no real military unit insignia or real flags rendered
literally, no identifiable real persons' faces, no real classified locations or coordinates,
no gore, no weapons pointed at people, no low-res, no watermark, no stock-photo cheesiness.
```

### Principios de composición
- **Punto focal único** marcado en oro; todo lo demás radia desde él.
- **Profundidad por capas**: niebla/atmósfera, no saturación.
- Si hay UI/pantallas: tipografía mono, retícula, esquinas con marcadores de coordenada.
- Personas: representativas y genéricas (no rostros reconocibles, sin insignias reales).

### Nota de uso responsable
Es material de marketing de una plataforma de **mando y control**. Mantener el foco en la **tecnología y la profesionalidad**; nada de violencia gráfica, ni datos/ubicaciones clasificadas reales, ni simbología que imite emblemas reales de unidades. Para escenas con personal, usar la marca de agua conceptual del sitio: *“datos simulados · no clasificado”* cuando se muestren tableros.

---

## 2. Convenciones Técnicas

| Tipo de slot | Aspecto | Tamaño de export | Formato |
|---|---|---|---|
| Hero / poster de video | 16:9 | 1920×1080 (poster) · video ≤1.5 MB | WebP/AVIF · MP4 h264 960–1280px crf 30–34 |
| Thumbnail de módulo (bento) | 3:2 / cuadrado | 880×600 (2× de su render) | WebP q80 |
| Imagen de sección (statement / forces) | 4:3 / 3:2 | 1200–1600 px lado mayor | WebP q80 |
| Mockup de UI (pantallas de app) | según pantalla | 2× del render | WebP q82 |
| Portada de lectura (readings) | 16:9 | 1200×675 | WebP q78 |
| Iconos / símbolos | vector | — | SVG |

- **Nombrado:** `seccion-tema-variante.webp` (ej. `radar-tactical-map-operations.webp`).
- **og:image / share:** 1200×630 PNG.
- Optimiza siempre: el sitio ya migró sus imágenes a WebP (−89% de peso). No subir PNG gigantes para mostrarlos pequeños.
- `width`/`height` explícitos en el HTML + `loading="lazy"` bajo el pliegue.

---

## 3. INDEX — Home (`index.html`)

### 3.1 `assets/holo-c2-poster.webp` + `assets/Holo_C2-opt.mp4` — Hero (fondo)
- **Ubicación:** fondo del hero, a ~18% de opacidad detrás del titular y la consola IOC.
- **Tipo/formato:** poster WebP 1920×1080 + video MP4 loop (silencioso, sutil).
- **Prompt (EN):**
  > `[ESTILO BASE]` Aerial-abstract tactical map of Colombia rendered as a Sovereign Meridian chart: dark navy terrain with faint graticule grid, glowing gold meridian arcs and concentric scan rings sweeping slowly, scattered gold coordinate nodes connected by thin dashed data links, MGRS tick marks at the edges. Calm, vast, authoritative. Subtle parallax depth, volumetric haze. Motion (for the video): a slow radial radar sweep and gentle node pulses. No literal map labels.
- **Evitar:** mapas Google-style, colores políticos por país, texto legible.
- **Notas:** mantener legible el texto blanco/oscuro encima → contraste bajo y centro despejado.

### 3.2 Thumbnails de módulo (bento) — 6 imágenes
Plantilla común. **Aspecto 3:2, 880×600, WebP.** Cada una = una “captura/render” evocativa del módulo sobre navy, con UI mono y un acento dorado.

| Archivo | Módulo | Prompt específico (EN) — anteponer `[ESTILO BASE]` + plantilla |
|---|---|---|
| `radar-dashboard.webp` | RADAR | `Tactical C2 dashboard UI on near-black: a stylized map of Colombia with gold asset tracks (land/sea/air), MGRS readouts, a side telemetry panel, one selected asset glowing gold. Clinical, dense but ordered.` |
| `iris-mobile.webp` | IRIS | `Rugged military smartphone held in a gloved hand, field app UI on screen: MGRS grid, fuel/ammo telemetry bars, a quick SITREP button. Dawn field, shallow depth, gold accents on the UI only.` |
| `nexxo-chat.webp` | NEXXO Chat | `Secure messaging interface on dark navy: end-to-end encrypted channel, mono timestamps, an inline AI assistant suggestion, a small gold lock glyph. Calm, enterprise-grade, sovereign.` |
| `memora-docs.webp` | Memora | `Classified document management UI: dark interface with security-level chips, an audit trail timeline, smart search bar, a gold "CLASSIFIED" marker used once. Institutional, precise.` |
| `holo-ai.webp` | HOLO AI | `Abstract multi-agent reasoning visualization: a gold central node with orbiting agent nodes fusing intel streams (lines converging), course-of-action branches. Schematic, elegant, navy ground.` |
| `prisma-edge.webp` | PRISMA EDGE | `Ruggedized tactical edge device (ARM compute box) studio render on navy: matte black casing, OLED status display showing mono telemetry, military connectors, a single gold indicator LED. Product-hero lighting.` |
- **Evitar (todas):** UI con texto real legible, logos reales, colores fuera de paleta.

### 3.3 `assets/statement-soldier-civilian.webp` — Sección “El comandante decide”
- **Tipo/aspecto:** foto documental, 3:2, 1200–1600 px.
- **Prompt (EN):**
  > `[ESTILO BASE]` Documentary photograph: a Colombian military officer (back/profile, face not identifiable, no readable insignia) coordinating support to civilians during a humanitarian operation at dawn. Muted desaturated tones leaning navy, a single warm gold highlight from sunrise. Dignified, human, restrained. Cinematic, shallow depth of field.
- **Evitar:** rostros reconocibles, insignias reales, escena de combate, banderas literales.

### 3.4 Forces — 3 imágenes (“Diseñado para las Tres Fuerzas”)
**Aspecto 4:3, 1200 px, WebP/JPEG.** Una por Fuerza, mismo tratamiento (desaturado navy + 1 respiro de oro).

| Archivo | Fuerza | Prompt (EN) — + `[ESTILO BASE]` |
|---|---|---|
| `forces-army-terrestrial.webp` | Ejército Nacional | `Land operations command post at dawn, antennas and a tactical tablet on a field table showing a map; terrain stretching into haze. Desaturated navy palette, one gold sunrise accent. No identifiable faces/insignia.` |
| `navy-force.webp` (reemplazar `.jpeg`) | Armada Nacional | `Riverine/coastal patrol vessel silhouette on calm water at blue hour, a faint radar sweep overlay, gold horizon line. Sovereign, quiet, vast negative space.` |
| `air-mission-track.svg` (o `.webp`) | Fuerza Aeroespacial | `Schematic mission-track diagram: a gold flight path arc over a navy graticule of Colombian airspace, waypoint coordinate markers, altitude annotations in mono. Vector, clean, precise.` |

---

## 4. RADAR (`radar.html`)
### 4.1 `assets/radar-tactical-map-operations.webp` — Hero / dashboard principal
- **Tipo/aspecto:** render de UI, 16:9, 1920×1080.
- **Prompt (EN):**
  > `[ESTILO BASE]` Full RADAR tactical dashboard: a dark map of Colombia as a Common Operational Picture, multi-domain asset tracks in muted steel with the SELECTED asset and its track in gold, left rail with unit list and latency readouts, top bar with a live UTC clock and a "LIVE" chip, MGRS graticule, scanning sweep. Dense, authoritative, perfectly aligned. Watermark "DATOS SIMULADOS · NO CLASIFICADO" small in a corner.
- **Evitar:** posiciones reales de unidades, texto fino legible falso.
- **Extra sugerido:** `radar-3d-layers.webp` — vista 3D de capas tácticas apiladas (la “mesa” de capas) en navy/oro, para la sección “Dominando el Teatro de Operaciones”.

---

## 5. IRIS + PRISMA EDGE (`iris.html`)
### 5.1 `assets/iris-field-mobile.webp`
- **Tipo:** foto/render de campo, 3:2.
- **Prompt (EN):**
  > `[ESTILO BASE]` Soldier in the field at dawn using a rugged smartphone (IRIS app), gloved hands, screen showing MGRS grid + telemetry, antenna in soft background. Face not identifiable, no real insignia. Desaturated navy, single gold UI accent. Cinematic, gritty but clean.
### 5.2 `assets/iris-prisma-device.webp`
- **Tipo:** product render, fondo navy, 3:2 / cuadrado.
- **Prompt (EN):**
  > `[ESTILO BASE]` Studio product render of a ruggedized tactical handheld/edge device: matte black, OLED display with mono telemetry, military-grade connectors and rubber bumpers, MIL-STD look. Dramatic single-source light, navy seamless background, one gold status LED. Catalog-grade.
- **Evitar:** marcas reales, puertos USB de consumo, estética “gadget” de consumo.

---

## 6. NEXXO Chat (`chat.html`)
### 6.1 `assets/chat-soldier-field.webp` — hero/escena
- **Prompt (EN):** `[ESTILO BASE]` Soldier composing a secure message on a rugged device in a low-light command tent, screen glow on face hidden, encrypted-channel UI with a gold lock glyph. Calm, secure, sovereign. No identifiable face/insignia.
### 6.2 `assets/chat-threat-bg.webp` — fondo de sección
- **Prompt (EN):** `[ESTILO BASE]` Abstract dark "threat surface" texture: navy field with faint signal-interception lines, intercepted-but-blocked comms motif, a single gold shield node deflecting a probe. Subtle, low contrast (background use).
### 6.3 Mockups de pantalla `assets/nexxo-chat-screen-1..8.webp`
- **Tipo:** UI mockups verticales (móvil) o paneles, 2× del render, WebP.
- **Plantilla de prompt (EN):**
  > `[ESTILO BASE]` Clean mobile UI mockup of a sovereign secure-messaging app on near-black: top bar with channel name + gold E2E-encryption lock, message bubbles in grey, mono timestamps, an AI-assistant suggestion card, bottom composer. One gold accent per screen. Crisp, enterprise, no readable sensitive text (use lorem-style placeholders).
- **Variantes por pantalla (1→8):** 1) lista de canales · 2) chat 1:1 cifrado · 3) sala de coordinación de grupo · 4) tarjeta de asistente IA · 5) compartir ubicación MGRS · 6) llamada/secure voice · 7) ajustes de seguridad/claves · 8) estado de entrega/auditoría.
- **Reemplazar:** `assets/935a6cb1-…png` (nombre temporal) → renombrar a `nexxo-chat-hero.webp` con un prompt de hero compuesto (varias pantallas en perspectiva sobre navy).

---

## 7. Memora (`memora.html`)
### 7.1 `assets/memora-classified-interface.webp`
- **Prompt (EN):** `[ESTILO BASE]` Classified document management dashboard on dark navy: security-level chips (placeholder labels), audit-trail timeline, granular access controls, smart search, one gold "CLASSIFIED" marker. Institutional, dense, ordered.
### 7.2 `assets/memora-officer-reviewing.webp`
- **Prompt (EN):** `[ESTILO BASE]` Officer reviewing documents on a secure terminal in a low-light office, over-the-shoulder, face not identifiable, screen showing the Memora UI. Desaturated navy, gold screen accent. Professional, calm.
### 7.3 `assets/memora-pki-cac-signature.webp`
- **Prompt (EN):** `[ESTILO BASE]` Close-up of a hand inserting a smartcard (CAC/PKI) into a reader beside a keyboard, gold authentication glyph confirming digital signature on screen. Macro, shallow depth, navy palette, single gold accent. No real names/logos.

---

## 8. HOLO AI (`ai.html`) — **sin imágenes hoy; necesita set completo**
### 8.1 `assets/ai-hero.webp` — hero
- **Prompt (EN):** `[ESTILO BASE]` Abstract sovereign multi-agent intelligence: a gold core surrounded by concentric rings of agent nodes fusing HUMINT/SIGINT/GEOINT streams into converging gold lines, branching into course-of-action paths. Schematic + cinematic, vast navy space, MGRS margin notations. Elegant, not busy.
### 8.2 `assets/ai-coa.webp` — Generación de Cursos de Acción
- **Prompt (EN):** `[ESTILO BASE]` Decision-tree diagram of military courses of action (COA-A/B/C as placeholders): branching gold paths from a single situation node, probability/risk annotations in mono, the recommended branch glowing gold. Clean schematic on navy.
### 8.3 `assets/ai-fusion.webp` — Fusión de inteligencia
- **Prompt (EN):** `[ESTILO BASE]` Intel fusion visualization: three muted input streams (human, signal, geospatial icons) merging into one coherent gold picture over a faint map graticule. Layered, restrained, sovereign.
- **Notas:** ai.html puede reutilizar la **paleta del diagrama sunburst** del home para coherencia.

---

## 9. Lecturas (`readings.html`) — **reemplazar imágenes externas (Medium)**
Hoy usa URLs de `miro.medium.com` (dependencia externa + posible problema de derechos). Crear **portadas propias**.
- **Tipo:** portada editorial 16:9, 1200×675, WebP.
- **Plantilla de prompt (EN):**
  > `[ESTILO BASE]` Editorial cover, abstract and conceptual, for a defense-tech article titled "<TEMA>": a single strong Sovereign Meridian metaphor (e.g., a gold meridian arc over navy, a coordinate constellation, a radial scan), generous negative space for an overlaid title, no literal photo of the topic. Magazine-grade, restrained.
- **Variantes temáticas sugeridas:** soberanía tecnológica · ciclo OODA · IA en defensa · ciberseguridad · doctrina conjunta · disuasión. (1 portada por artículo; mantener el mismo lenguaje para que la grilla se vea como una colección.)
- **Acción técnica:** descargar/generar localmente y servir desde `assets/readings/` (no enlazar a Medium).

---

## 10. Activos transversales (todas las páginas)
- **Logos** (`assets/banners/banner_blue.svg`, `icon_golden.svg`, `icon_blue.svg`): **ya existen** y son oficiales — **no regenerar**, usar los SVG provistos.
- **`og:image` por página** (1200×630): versión compuesta = logo HOLO + título de la sección sobre navy con un arco dorado. Plantilla:
  > `[ESTILO BASE]` Social share card 1200x630: HOLO wordmark top-left, large condensed title "<PÁGINA>", a single gold meridian arc, MGRS tick marks, navy ground. Clean, balanced for text overlay.
- **Favicon / app icons:** usar los existentes.
- **Texturas reutilizables:** `assets/tex/grain.png` (grano sutil) y `assets/tex/graticule.svg` (retícula) para fondos de sección, en vez de generar fondos pesados.

---

## 11. Lista de verificación por imagen
- [ ] Solo paleta de 5 colores; el oro aparece poco y "ubica".
- [ ] Espacio negativo suficiente; centro despejado si lleva texto encima.
- [ ] Sin texto legible falso, sin insignias/banderas reales, sin rostros reconocibles.
- [ ] Exportada a WebP/AVIF al tamaño de render real (no 1024² para 220px).
- [ ] `width`/`height` + `loading="lazy"` en el HTML (bajo el pliegue).
- [ ] Coherente con las hermanas de su grilla (módulos, fuerzas, lecturas).
- [ ] Marca de agua "DATOS SIMULADOS · NO CLASIFICADO" en cualquier tablero/COP.

---

*Prioridad sugerida:* (1) `ai.html` (no tiene imágenes) → (2) `readings.html` (quitar dependencia externa) → (3) refinar hero del home y dashboards de RADAR → (4) mockups de chat/memora/iris.
