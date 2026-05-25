# Instrucciones — PRANK Electronics

**Proyecto:** Robot Paralelo de Rehabilitación de Tobillo — PCB Principal
**Estándar:** nguyen-v KiCAD Template + FDA/ISO 13485
**KiCAD:** 8.0 | **Fecha:** 2026-04-25

---

## ¿Qué se creó?

Se generaron **7 archivos** de documentación y herramientas para el diseño electrónico del PRANK:

| Archivo | Tipo | Descripción |
|---------|------|-------------|
| `SKILL.md` | Guía técnica | Referencia completa KiCAD para dispositivos médicos: motor control, sensor interface, safety circuits, PCB stack-up, workflow |
| `Design_Checklist_IPC_A600.md` | Checklist | Lista exhaustiva IPC-A-600 Class 3: traces, vias, DRC/ERC, sourcing, motor control, sensor, power, manufacturing, sign-offs |
| `IEC60601_Compliance.md` | Cumplimiento | Documentación de cumplimiento IEC 60601-1: aislamiento, seguridad eléctrica, EMC (emisiones + inmunidad), plan de pruebas |
| `Risk_Analysis_FMEA.md` | FMEA | Análisis de riesgos completo: 24 modos de falla en motor control, sensor interface y power supply. Alineado FDA 21 CFR 820.30 |
| `BOM_Template.csv` | Lista de materiales | 20 componentes reales con números de parte Digi-Key, costos, estado RoHS/REACH, ciclo de vida y lead times |
| `create_project_structure.sh` | Script bash | Crea automáticamente la estructura de carpetas nguyen-v, .gitignore KiCAD, README y archivo .kicad_pro base |
| `INSTRUCCIONES_ES.md` | Este archivo | Guía en español de todo lo creado y pasos siguientes |

**Costo total estimado de componentes (prototipo):** ~$80 USD por PCB (sin ensamble)

---

## Estructura de Carpetas (Híbrida: nguyen-v + FDA Medical)

Después de ejecutar el script, la estructura quedará así:

```
PRANK_electronics/
├── PRANK_electronics.kicad_pro     ← Proyecto (net classes PWR_MOTOR, PWR_LOGIC, GND)
├── PRANK_electronics.kicad_dru     ← Design rules separado (nguyen-v style, 4L medical)
├── PRANK_electronics.kicad_pcb     ← Layout PCB
│
├── 01_SCHEMATIC/                   ← Esquemáticos jerárquicos
│   ├── Block Diagram.kicad_sch     ← Diagrama de bloques del sistema
│   ├── Project Architecture.kicad_sch
│   ├── Power - Sequencing.kicad_sch
│   ├── Revision History.kicad_sch  ← Control de cambios
│   ├── Motor Control.kicad_sch     ← DRV8833, freewheeling, sense
│   ├── Sensor Interface.kicad_sch  ← ADC, filtros, TVS
│   └── Safety Circuits.kicad_sch   ← Watchdog, e-stop, fuse
│
├── Manufacturing/                  ← nguyen-v nativo
│   ├── Assembly/ibom/              ← HTML BOM interactivo
│   └── Fabrication/Gerbers/        ← Gerbers + drill Excellon
│
├── lib/                            ← nguyen-v nativo
│   ├── lib_sym/                    ← Símbolos KiCAD custom
│   ├── lib_fp/                     ← Footprints custom (.pretty)
│   └── 3d_models/                  ← STEP / WRL
│
├── Images/                         ← Renders PCB, fotos prototipo
├── Computations/                   ← Cálculos: power budget, filtros RC, BOM costos
├── Templates/                      ← KDT_Template.kicad_wks (nguyen-v)
├── STEP_BLENDER/                   ← Exportes 3D para equipo mecánico
├── DXF_SVG/                        ← Exportes para CAD del enclosure
│
├── 06_VALIDATION/                  ← PRANK/FDA (no existe en nguyen-v)
│   ├── DRC_reports/
│   ├── ERC_reports/
│   └── test_records/
│
└── DOCS/                           ← Compliance y guías
    ├── SKILL.md
    ├── Design_Checklist_IPC_A600.md
    ├── IEC60601_Compliance.md
    ├── Risk_Analysis_FMEA.md
    ├── BOM_Template.csv
    └── INSTRUCCIONES_ES.md
```

### ¿Qué viene de dónde?
| Carpeta | Origen | Por qué |
|---------|--------|---------|
| `Manufacturing/Assembly/ibom` | nguyen-v | iBOM para ensamble manual fácil |
| `lib/lib_sym + lib_fp + 3d_models` | nguyen-v | Convención KiCAD estándar |
| `Computations/` | nguyen-v | Cálculos de diseño versionados |
| `Templates/` | nguyen-v | Hojas de título estandarizadas |
| `.kicad_dru` separado | nguyen-v | Design rules portables y versionables |
| Sheets jerárquicos en `01_SCHEMATIC/` | nguyen-v adaptado | Navegación profesional |
| `06_VALIDATION/` | PRANK | Obligatorio FDA 21 CFR 820.30 |
| `DOCS/` con FMEA y compliance | PRANK | Design History File (DHF) |

---

## Pasos de Instalación

### Opción 1 — Crear estructura en el directorio actual
```bash
cd ~/PRANK/electronics
bash create_project_structure.sh
```

### Opción 2 — Crear estructura en otro directorio
```bash
bash ~/PRANK/electronics/create_project_structure.sh /ruta/deseada
```

### Opción 3 — Instalación manual
Si prefieres hacerlo a mano:
```bash
cd ~/PRANK/electronics
mkdir -p 01_SCHEMATIC/symbols 01_SCHEMATIC/hierarchy
mkdir -p 02_PCB/footprints 02_PCB/3D_models
mkdir -p 03_LIBRARIES/PRANK.pretty 03_LIBRARIES/PRANK_3D
mkdir -p 04_DOCUMENTATION/{schematic_PDF,design_notes,datasheets}
mkdir -p 05_MANUFACTURING/{gerbers,drill_files,pick_and_place,BOM}
mkdir -p 06_VALIDATION/{DRC_reports,ERC_reports,test_records}
mkdir -p DOCS
```

---

## Pasos Siguientes

### 0. Descargar templates de nguyen-v (una sola vez)
Los archivos `.kicad_wks` (hojas de título) vienen del repositorio original:
```bash
# Descargar los 2 archivos de hoja de título
curl -L "https://raw.githubusercontent.com/nguyen-v/KiCAD_Templates/master/KDT_Hierarchical/Templates/KDT_Template.kicad_wks" \
     -o Templates/KDT_Template.kicad_wks

curl -L "https://raw.githubusercontent.com/nguyen-v/KiCAD_Templates/master/KDT_Hierarchical/Templates/KDT_Template_Fab.kicad_wks" \
     -o Templates/KDT_Template_Fab.kicad_wks
```
O clona el repo y copia manualmente de `KDT_Hierarchical/Templates/`.

### 1. Configurar KiCAD 8.0
- Abrir KiCAD 8.0
- `File → Open Project` → seleccionar `PRANK_electronics.kicad_pro`
- Cargar design rules: `Board Setup → Import → PRANK_electronics.kicad_dru`
- Las net classes `PWR_MOTOR`, `PWR_LOGIC` y `GND` ya están configuradas
- Asignar hoja de título: `File → Page Settings → Browse → Templates/KDT_Template.kicad_wks`

### 2. Esquemático (01_SCHEMATIC/)
Orden recomendado de diseño:
1. **Power distribution** — entrada 12 V, LDO 5 V, LDO 3.3 V, fuse, protección
2. **MCU (STM32F407)** — configuración de pines, cristal 8 MHz, decoupling
3. **Motor control (DRV8833)** — H-bridge, sense resistors, diodos freewheeling
4. **Sensor interface** — filtros RC, TVS, I²C pull-ups
5. **Safety circuits** — watchdog, e-stop dual channel

### 3. PCB Layout (02_PCB/)
Seguir `DOCS/Design_Checklist_IPC_A600.md` en orden:
1. Importar netlist del esquemático
2. Definir contorno de PCB (Edge.Cuts)
3. Colocar componentes críticos: DRV8833, STM32, conectores primero
4. Rutar potencia (L3), luego señales (L1), luego motor (L4)
5. Agregar vías térmicas bajo DRV8833
6. Llenar GND en L2 (sin islas)
7. Ejecutar DRC → corregir → exportar reporte

### 4. Validación (06_VALIDATION/)
- [ ] ERC limpio → guardar en `06_VALIDATION/ERC_reports/`
- [ ] DRC limpio → guardar en `06_VALIDATION/DRC_reports/`
- [ ] Completar `DOCS/Design_Checklist_IPC_A600.md` con firma
- [ ] Revisar `DOCS/Risk_Analysis_FMEA.md` → actualizar estado de mitigaciones
- [ ] Completar `DOCS/IEC60601_Compliance.md` → documentar pruebas físicas

### 5. Fabricación (05_MANUFACTURING/)
```
KiCAD PCB Editor → File → Fabrication Outputs → Gerbers
  ✓ F.Cu, B.Cu, In1.Cu, In2.Cu
  ✓ F.Mask, B.Mask
  ✓ F.Silkscreen, B.Silkscreen
  ✓ Edge.Cuts
  ✓ Drill file (Excellon, métrico)
  ✓ Component placement (Pick & Place CSV)
```
Subir a JLCPCB / PCBWay → 4 capas, 1.6 mm, HASL Pb-free, IPC-A-600 Class 3

---

## Documentación FDA Requerida

Para cumplir **FDA 21 CFR 820.30**, el Design History File (DHF) debe incluir:

| Documento | Estado | Archivo |
|-----------|--------|---------|
| Design input requirements | ☐ Por crear | `04_DOCUMENTATION/design_notes/` |
| Schematic PDF (firmado) | ☐ Al terminar layout | `04_DOCUMENTATION/schematic_PDF/` |
| Design Checklist firmado | ☐ Al terminar layout | `DOCS/Design_Checklist_IPC_A600.md` |
| FMEA completa (todos firmados) | ☐ En proceso | `DOCS/Risk_Analysis_FMEA.md` |
| IEC 60601-1 test report | ☐ Post-prototipo | `06_VALIDATION/test_records/` |
| EMC compliance report | ☐ Post-prototipo | `06_VALIDATION/test_records/` |
| BOM con aprobación | ☐ Al finalizar | `05_MANUFACTURING/BOM/` |
| Certificado adaptador externo | ☐ Al seleccionar proveedor | `04_DOCUMENTATION/` |
| Software validation (IEC 62304) | ☐ Paralelo al hardware | Repo de firmware |

---

## Checklist Rápido de Arranque

- [ ] Ejecutar `bash create_project_structure.sh`
- [ ] Abrir `02_PCB/PRANK_electronics.kicad_pro` en KiCAD 8.0
- [ ] Revisar `DOCS/SKILL.md` (guía de diseño)
- [ ] Descargar datasheets de componentes → guardar en `04_DOCUMENTATION/datasheets/`
- [ ] Crear primer esquemático en `01_SCHEMATIC/`
- [ ] Actualizar `DOCS/BOM_Template.csv` con cantidades reales
- [ ] Completar `DOCS/Risk_Analysis_FMEA.md` con firmas del equipo
- [ ] Hacer primer commit git con esta estructura base

---

## Recursos Útiles

| Recurso | URL |
|---------|-----|
| KiCAD 8.0 Documentation | https://docs.kicad.org |
| DRV8833 Datasheet | https://www.ti.com/lit/ds/symlink/drv8833.pdf |
| STM32F407 Reference Manual | https://www.st.com/resource/en/reference_manual/rm0090.pdf |
| IPC-2221B (PCB design) | Disponible en IPC.org (membresía) |
| IEC 60601-1 Summary | https://www.medicaldesignbriefs.com/iec-60601-1 |
| FDA Design Controls Guidance | https://www.fda.gov/media/116573/download |
| JLCPCB 4-Layer Calculator | https://jlcpcb.com/capabilities/pcb-capabilities |
| Digi-Key BOM Manager | https://www.digikey.com/en/mylists |

---

## FAQs

**¿Por qué 4 capas y no 2?**
Con 4 capas, el plano GND sólido en L2 reduce drásticamente las emisiones EMI del PWM del motor (16-20 kHz y sus armónicas). En 2 capas, es muy difícil pasar EMC para un dispositivo médico. El costo adicional es ~$20/PCB en prototipo y justificado para cumplir IEC 60601-1-2.

**¿Por qué DRV8833 y no L298N?**
El L298N es obsoleto, disipa 5-7 W en calor (eficiencia ~70%), y no tiene protección térmica. El DRV8833 tiene eficiencia >95%, protección térmica integrada, encapsulado SMD compacto, y control de corriente (sense resistors). Para un dispositivo médico, la confiabilidad del DRV8833 es superior.

**¿Cuánto cuesta fabricar 10 prototipos?**
Aproximado:
- PCB (10 piezas, JLCPCB): ~$35 USD
- Componentes (1 prototipo): ~$80 USD
- Ensamble manual (sin SMT profesional): tiempo de equipo
- Total para 1 prototipo funcional: ~$115-150 USD

**¿Puedo usar Altium en vez de KiCAD?**
Sí. La estructura de carpetas y documentación es agnóstica al EDA. Si migras de Altium:
- Los Gerbers son compatibles (formato estándar)
- El BOM CSV funciona en ambas plataformas
- Los checklists aplican igual
- KiCAD 8.0 puede importar proyectos Altium (File → Import → Altium)

**¿Es suficiente con el adaptador externo para cumplir IEC 60601-1?**
Sí, para SELV (< 60 VDC). El adaptador externo debe estar certificado IEC 60601-1 (2MOPP). Pide el certificado al proveedor y archívalo en el DHF. La PCB solo necesita cumplir los requisitos de SELV (sin aislamiento de red interna).

---

## Soporte

Para problemas con esta documentación o el diseño:
- Revisar `DOCS/SKILL.md` — sección relevante
- Verificar `DOCS/Design_Checklist_IPC_A600.md` — sección correspondiente
- KiCAD Forum: https://forum.kicad.info
- Abrir issue en el repositorio del proyecto

---

*Generado para: Robot Paralelo de Rehabilitación de Tobillo (PRANK) — Electrónica Principal*
*Estándar: nguyen-v Template + FDA 21 CFR 820.30 + ISO 13485 + IEC 60601-1*
