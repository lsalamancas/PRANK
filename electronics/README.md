# PRANK Electronics — Main PCB

**Robot Paralelo de Rehabilitación de Tobillo**
Motor control + sensor interface board for ankle rehabilitation.

## Standards
- FDA 21 CFR 820.30 — Design Controls
- ISO 13485:2016 — Quality Management
- IEC 60601-1 — Electrical Safety
- IPC-A-600 Class 3 — PCB Acceptance
- IPC-2221 — PCB Design Guidelines

## Stack
- MCU: STM32F407VGT6 (ARM Cortex-M4, 168 MHz)
- Motor Driver: DRV8833 Dual H-Bridge
- Power: 12 V input → 5 V + 3.3 V LDOs
- PCB: 4-layer FR4 1.6 mm, HASL Pb-free

## Folder Structure (Hybrid: nguyen-v + FDA extensions)
```
├── 01_SCHEMATIC/        Hierarchical schematic sheets
├── Manufacturing/       Gerbers, BOM, P&P, iBOM (nguyen-v)
│   ├── Assembly/ibom
│   └── Fabrication/Gerbers
├── lib/                 Symbols, footprints, 3D models (nguyen-v)
│   ├── lib_sym/
│   ├── lib_fp/
│   └── 3d_models/
├── Images/              Board renders, screenshots (nguyen-v)
├── Computations/        Excel/Python design calculations (nguyen-v)
├── Templates/           KiCAD worksheet templates (nguyen-v)
├── STEP_BLENDER/        3D exports (nguyen-v)
├── DXF_SVG/             Mechanical exports (nguyen-v)
├── 06_VALIDATION/       DRC/ERC reports, test records (FDA)
└── DOCS/                Compliance, FMEA, checklists (FDA)
```

## Quick Start
1. `bash create_project_structure.sh` (if not already run)
2. Open `PRANK_electronics.kicad_pro` in KiCAD 8.0
3. Load design rules: Board Setup → Import → `PRANK_electronics.kicad_dru`
4. Replace `Templates/*.kicad_wks` with nguyen-v originals
5. See `DOCS/SKILL.md` for design guidelines
