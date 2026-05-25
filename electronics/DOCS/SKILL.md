---
name: kicad-medical-device
description: Design FDA-compliant medical device PCBs in KiCAD 8.0 following nguyen-v template — PRANK Ankle Rehabilitation Robot
---

# KiCAD Medical Device Design — PRANK Electronics

## Project Context
**Robot Paralelo de Rehabilitación de Tobillo (PRANK)**
Motor control + sensor interface PCB for ankle rehabilitation.
Standards: FDA 21 CFR 820.30 · ISO 13485 · IEC 60601-1 · IPC-A-600 · IPC-2221

---

## 1. Repository Structure (Hybrid: nguyen-v + FDA Medical)

Estructura híbrida: carpetas nativas de nguyen-v KDT_Hierarchical + extensiones médicas FDA/ISO 13485.

```
PRANK_electronics/
├── PRANK_electronics.kicad_pro       ← Proyecto KiCAD (net classes, text vars)
├── PRANK_electronics.kicad_dru       ← Design rules SEPARADO (nguyen-v style)
├── PRANK_electronics.kicad_pcb       ← PCB layout
│
├── 01_SCHEMATIC/                     ← Esquemáticos jerárquicos (nguyen-v style)
│   ├── Block Diagram.kicad_sch
│   ├── Project Architecture.kicad_sch
│   ├── Power - Sequencing.kicad_sch
│   ├── Revision History.kicad_sch
│   ├── Motor Control.kicad_sch
│   ├── Sensor Interface.kicad_sch
│   └── Safety Circuits.kicad_sch
│
├── Manufacturing/                    ← nguyen-v nativo
│   ├── Assembly/
│   │   └── ibom/                     ← Interactive HTML BOM
│   └── Fabrication/
│       └── Gerbers/                  ← Todos los Gerbers + drill
│
├── lib/                              ← nguyen-v nativo
│   ├── lib_sym/                      ← Símbolos KiCAD personalizados
│   ├── lib_fp/                       ← Footprints personalizados (.pretty)
│   └── 3d_models/                    ← Modelos STEP / WRL
│
├── Images/                           ← nguyen-v: renders PCB, fotos prototipo
├── Computations/                     ← nguyen-v: cálculos (Excel, Python, PDF)
├── Templates/                        ← nguyen-v: KDT_Template.kicad_wks
├── STEP_BLENDER/                     ← nguyen-v: exportes 3D para mecánica
├── DXF_SVG/                          ← nguyen-v: exportes para enclosure CAD
│
├── 06_VALIDATION/                    ← PRANK/FDA: no existe en nguyen-v
│   ├── DRC_reports/
│   ├── ERC_reports/
│   └── test_records/
│
└── DOCS/                             ← PRANK/FDA: compliance docs
    ├── SKILL.md
    ├── Design_Checklist_IPC_A600.md
    ├── IEC60601_Compliance.md
    ├── Risk_Analysis_FMEA.md
    └── BOM_Template.csv
```

### Por qué esta estructura híbrida
| Elemento | Origen | Razón |
|----------|--------|-------|
| `01_SCHEMATIC/` con sheets jerárquicos | nguyen-v adaptado | Revisión profesional, navegación clara |
| `.kicad_dru` separado | nguyen-v | Portabilidad, versionable en git |
| `Manufacturing/Assembly/ibom` | nguyen-v | iBOM para ensamble manual |
| `lib/lib_sym + lib_fp + 3d_models` | nguyen-v | Convención KiCAD estándar |
| `Computations/` | nguyen-v | Cálculos de diseño (power budget, filtros) |
| `06_VALIDATION/` | PRANK | Obligatorio FDA 21 CFR 820.30 |
| `DOCS/` con FMEA y compliance | PRANK | DHF documentado |

---

## 2. Motor Control Design

### IC: DRV8833 Dual H-Bridge (Texas Instruments)
- V_M: 2.7–10.8 V, I_peak: 1.5 A/channel (2 A peak)
- PWM frequency: **16–20 kHz** (above audible, below switching losses)
- Control modes: IN1/IN2 per channel — use fast-decay for rehabilitation torque control

### Freewheeling Diodes — 1N4007
- Placed across each motor terminal to GND and V_M
- Rating: 1 A / 1000 V (well-derated for 10.8 V motor supply)
- Placement: < 5 mm from DRV8833 pins, short traces

### Current Sense
- R_sense = **0.47 Ω** (1%, 1 W power rating)
- Voltage at 1.5 A: 705 mV — within DRV8833 sense amplifier range
- Package: 2512 for thermal dissipation

### Decoupling Strategy
| Cap | Value | Location |
|-----|-------|----------|
| C_bulk | 100 μF electrolytic | Motor supply bulk, near connector |
| C_mid | 10 μF ceramic X7R | DRV8833 VM pin |
| C_bypass | 100 nF ceramic X7R | DRV8833 VCP/VINT pins |

### Layout Rules
- Keep motor current loop area < 1 cm²
- Separate motor GND from signal GND — join at single star point
- Pour copper on bottom layer under DRV8833 for thermal relief

---

## 3. Sensor Interface Design

### ADC Input RC Filter
- Cutoff = Fs / 5, where Fs = MCU ADC sample rate
- For Fs = 10 kHz → f_c = 2 kHz
- R = 7.9 kΩ (use 8.2 kΩ std), C = 10 nF → f_c ≈ 1.94 kHz

### ESD Protection
- TVS diode on each analog input (e.g., PRTR5V0U2X or PESD5V0S1BA)
- Series resistor: **100 Ω** between connector and TVS to limit surge current
- TVS clamping voltage < 3.3 V to protect MCU ADC

### Decoupling
- 1 μF + 100 nF per ADC channel, placed at MCU pin

### I²C Bus
- Pull-ups: 4.7 kΩ to 3.3 V (standard mode / fast mode)
- Add 100 pF filter cap if bus > 30 cm

---

## 4. Safety Circuits

### Watchdog Timer
- Hardware watchdog: **500 ms** timeout (independent of MCU)
- IC: MAX6369 or STM32F4 internal IWDG
- On timeout: de-assert motor enable, assert FAULT signal

### Emergency Stop — Dual Channel
- SW1 + SW2: series N.O. contacts (IEC 60947-5-1 Category 1)
- Both must open to trigger e-stop
- Latching relay or safety relay (e.g., Pilz PNOZ) downstream
- E-stop loop monitored by MCU GPIO with interrupt

### Over-Current Protection
- **6 A resettable polyfuse** (Littelfuse RXEF series) on motor supply input
- Trips within 1 s at 2× rated current
- Add 100 nF across fuse to suppress transients

### Thermal Shutdown
- DRV8833 internal thermal shutdown: 150 °C (TJ)
- Add NTC thermistor (10 kΩ @ 25 °C, B=3435) on PCB surface near DRV8833
- MCU monitors NTC → software shutdown at **80 °C** PCB surface temp
- Alert threshold: 70 °C

---

## 5. PCB Stack-Up (4-Layer FR4)

| Layer | Name | Function |
|-------|------|----------|
| L1 (Top) | Signal | Components, fine signal traces |
| L2 | GND | Solid ground plane |
| L3 | Power | 5 V / 3.3 V planes |
| L4 (Bottom) | Signal | High-current traces, motor lines |

**Material:** FR4, Tg ≥ 130 °C
**Thickness:** 1.6 mm
**Copper weight:** 1 oz outer / 1 oz inner (upgrade to 2 oz L4 for motor current)
**Finish:** HASL Pb-free (RoHS compliant)
**Solder mask:** Green LPI both sides
**Silkscreen:** White, both sides

### Design Rules (KiCAD Constraints)
```
Min trace width:       0.15 mm  (signal)
Motor power traces:    0.5 mm minimum (1 A = 0.3 mm, 2 A = 0.5 mm @ 10 °C rise)
Min clearance:         0.15 mm (signal-to-signal)
Motor HV clearance:    0.5 mm (V_M lines)
Min via drill:         0.3 mm
Min via pad:           0.6 mm
Annular ring:          0.15 mm minimum
Courtyard expansion:   0.25 mm
```

---

## 6. KiCAD 8.0 Workflow

### Design Rules Configuration
1. Open `.kicad_pro` → Board Setup → Constraints
2. Import design rules from `02_PCB/design_rules.kicad_dru`
3. Assign net classes: `PWR_MOTOR`, `PWR_LOGIC`, `SIGNAL`, `GND`

### DRC / ERC Checklist
- Run ERC (Schematic Editor → Inspect → Electrical Rules Checker)
- Resolve all errors before layout
- Run DRC (PCB Editor → Inspect → Design Rules Checker)
- Export DRC report to `06_VALIDATION/DRC_reports/`

### Manufacturing Output (KiCAD Fabrication Toolkit)
```
File → Fabrication Outputs → Gerbers
  - All copper layers (F.Cu, B.Cu, In1.Cu, In2.Cu)
  - F.Mask, B.Mask
  - F.Silkscreen, B.Silkscreen
  - Edge.Cuts
  - Drill file (Excellon format, metric)
  - Component placement (Pick & Place CSV)
  - BOM (export via scripting console)
```

---

## 7. Regulatory Standards Reference

| Standard | Scope | Key Requirement |
|----------|-------|-----------------|
| FDA 21 CFR 820.30 | Design controls | DHF, traceability, verification |
| ISO 13485:2016 | QMS | Design & development planning |
| IEC 60601-1:2005+A1 | Electrical safety | 2MOOP/2MOPP isolation |
| IEC 60601-1-2 | EMC | Emissions class B, immunity |
| IPC-A-600 Class 3 | PCB acceptance | No shorts, no lifted pads |
| IPC-2221 | PCB design | Trace sizing, clearance tables |
| IEC 62133 | Battery safety | If Li-ion used |

---

## 8. KiCAD Scripting Snippets

### Export BOM via PCB Console
```python
import pcbnew
board = pcbnew.GetBoard()
components = {fp.GetReference(): fp.GetValue() for fp in board.GetFootprints()}
```

### Set Net Class via Python
```python
netclass = pcbnew.NETCLASSPTR("PWR_MOTOR")
netclass.SetTrackWidth(pcbnew.FromMM(0.5))
netclass.SetClearance(pcbnew.FromMM(0.5))
board.GetDesignSettings().GetNetClasses().Add(netclass)
```
