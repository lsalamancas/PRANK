#!/usr/bin/env bash
# PRANK Electronics — KiCAD Project Structure (Hybrid)
# nguyen-v KDT_Hierarchical best practices + FDA/ISO 13485 medical extensions
# Usage: bash create_project_structure.sh [target_dir]

set -euo pipefail

TARGET="${1:-.}"
PROJECT="PRANK_electronics"

echo "=================================================="
echo "  PRANK KiCAD Hybrid Structure Generator"
echo "  nguyen-v KDT + FDA/ISO 13485 extensions"
echo "  Target: $TARGET"
echo "=================================================="

# ── Folder tree ──────────────────────────────────────
# nguyen-v originals: Manufacturing, lib, Images, Computations, Templates, STEP_BLENDER, DXF_SVG
# PRANK additions:    01_SCHEMATIC, 06_VALIDATION, DOCS
declare -a DIRS=(
    # nguyen-v native
    "Manufacturing/Assembly/ibom"
    "Manufacturing/Fabrication/Gerbers"
    "lib/3d_models"
    "lib/lib_fp"
    "lib/lib_sym"
    "Images"
    "Computations"
    "Templates"
    "STEP_BLENDER"
    "DXF_SVG"
    # PRANK medical extensions
    "01_SCHEMATIC"
    "06_VALIDATION/DRC_reports"
    "06_VALIDATION/ERC_reports"
    "06_VALIDATION/test_records"
    "DOCS"
)

for dir in "${DIRS[@]}"; do
    mkdir -p "$TARGET/$dir"
    echo "  [+] $dir"
done

# ── .gitignore (nguyen-v base + KiCAD 8 additions) ──
cat > "$TARGET/.gitignore" << 'GITIGNORE'
# nguyen-v originals
*-backups
#auto_saved_files#
*.xml
*.lib
*.lck
*.bak
*.kicad_sch-bak
fp-info-cache

# KiCAD 8 additions
*.kicad_pcb-bak
*.kicad_prl
*.kicad_pro.lock

# OS
.DS_Store
Thumbs.db
*.Zone.Identifier

# Python cache
__pycache__/
*.pyc

# Manufacturing outputs — regenerate from source
Manufacturing/Fabrication/Gerbers/*.gbr
Manufacturing/Fabrication/Gerbers/*.gbl
Manufacturing/Fabrication/Gerbers/*.gtl
Manufacturing/Fabrication/Gerbers/*.drl
GITIGNORE

echo "  [+] .gitignore"

# ── Design rules .kicad_dru (4-layer medical, IPC-2221) ──
# Adapted from nguyen-v PCBWay 6-layer → 4-layer IPC-A-600 Class 3
cat > "$TARGET/${PROJECT}.kicad_dru" << 'DRU'
(version 1)

# PRANK Electronics — Design Rules
# 4-layer FR4 1.6mm | IPC-A-600 Class 3 | IEC 60601-1 | IPC-2221
# Adapted from nguyen-v KDT_Hierarchical (PCBWay 6-layer)

(rule "Min clearance - signal"
    (constraint clearance (min 0.15mm))
    (condition "A.NetClass == 'Default' && B.NetClass == 'Default'")
)

(rule "Min clearance - motor power"
    (constraint clearance (min 0.5mm))
    (condition "A.NetClass == 'PWR_MOTOR' || B.NetClass == 'PWR_MOTOR'")
)

(rule "Min trace width - signal"
    (constraint track_width (min 0.15mm))
    (condition "A.NetClass == 'Default'")
)

(rule "Min trace width - logic power"
    (constraint track_width (min 0.35mm))
    (condition "A.NetClass == 'PWR_LOGIC'")
)

(rule "Min trace width - motor"
    (constraint track_width (min 0.6mm))
    (condition "A.NetClass == 'PWR_MOTOR'")
)

(rule "Via - standard"
    (constraint via_diameter (min 0.6mm))
    (constraint hole_size (min 0.3mm))
)

(rule "Via - thermal (DRV8833 pad)"
    (constraint via_diameter (min 0.5mm))
    (constraint hole_size (min 0.25mm))
)

(rule "Annular ring"
    (constraint annular_width (min 0.15mm))
)

(rule "Hole to hole clearance"
    (constraint hole_to_hole (min 0.25mm))
)

(rule "Edge clearance"
    (constraint edge_clearance (min 0.3mm))
)

(rule "Silkscreen text"
    (constraint text_thickness (min 0.15mm))
    (constraint text_height (min 0.8mm))
)

(rule "Courtyard clearance"
    (constraint courtyard_clearance (min 0.25mm))
)
DRU

echo "  [+] ${PROJECT}.kicad_dru"

# ── KiCAD project file (nguyen-v structure + PRANK net classes) ──
cat > "$TARGET/${PROJECT}.kicad_pro" << 'KICAD_PRO'
{
  "board": {
    "design_settings": {
      "defaults": {
        "copper_line_width": 0.25,
        "copper_text_size_h": 1.5,
        "copper_text_size_v": 1.5,
        "copper_text_thickness": 0.3
      },
      "rules": {
        "min_clearance": 0.15,
        "min_copper_edge_clearance": 0.3,
        "min_hole_clearance": 0.25,
        "min_hole_to_hole": 0.25,
        "min_through_hole_diameter": 0.3,
        "min_track_width": 0.15,
        "min_via_annular_width": 0.15,
        "min_via_diameter": 0.6,
        "use_height_for_length_calcs": true
      },
      "track_widths": [ 0.15, 0.25, 0.35, 0.5, 0.6, 1.0, 1.5 ],
      "via_dimensions": [
        { "diameter": 0.6,  "drill": 0.3 },
        { "diameter": 0.8,  "drill": 0.4 }
      ]
    }
  },
  "net_settings": {
    "classes": [
      {
        "clearance": 0.15,
        "name": "Default",
        "track_width": 0.25,
        "via_diameter": 0.6,
        "via_drill": 0.3,
        "wire_width": 6
      },
      {
        "clearance": 0.5,
        "name": "PWR_MOTOR",
        "track_width": 0.6,
        "via_diameter": 0.8,
        "via_drill": 0.4,
        "wire_width": 6
      },
      {
        "clearance": 0.2,
        "name": "PWR_LOGIC",
        "track_width": 0.35,
        "via_diameter": 0.6,
        "via_drill": 0.3,
        "wire_width": 6
      },
      {
        "clearance": 0.15,
        "name": "GND",
        "track_width": 0.5,
        "via_diameter": 0.6,
        "via_drill": 0.3,
        "wire_width": 24
      }
    ],
    "netclass_patterns": [
      { "netclass": "PWR_MOTOR", "pattern": "VM*"     },
      { "netclass": "PWR_MOTOR", "pattern": "MOTOR*"  },
      { "netclass": "PWR_LOGIC", "pattern": "+3.3V"   },
      { "netclass": "PWR_LOGIC", "pattern": "+5V"     },
      { "netclass": "GND",       "pattern": "GND"     }
    ]
  },
  "schematic": {
    "drawing": {
      "default_bus_thickness": 12,
      "default_junction_size": 40,
      "default_line_thickness": 6,
      "default_text_size": 50,
      "default_wire_thickness": 6
    }
  },
  "text_variables": {
    "COMPANY":   "PRANK Team",
    "DESIGNER":  "",
    "REVISION":  "A",
    "PROJECT":   "Robot Paralelo de Rehabilitación de Tobillo",
    "STANDARD":  "IPC-A-600 Class 3 | IEC 60601-1 | FDA 21 CFR 820.30",
    "FABRICATOR":"PCBWay / JLCPCB",
    "STACKUP":   "4L FR4 1.6mm HASL Pb-free"
  }
}
KICAD_PRO

echo "  [+] ${PROJECT}.kicad_pro"

# ── Hierarchical schematic stubs (nguyen-v style) ────
# These are minimal valid .kicad_sch files — open in KiCAD to populate

for sheet in \
    "Block Diagram" \
    "Project Architecture" \
    "Power - Sequencing" \
    "Revision History" \
    "Motor Control" \
    "Sensor Interface" \
    "Safety Circuits"; do

    cat > "$TARGET/01_SCHEMATIC/${sheet}.kicad_sch" << SCH
(kicad_sch (version 20231120) (generator eeschema)
  (paper "A3")
  (title_block
    (title "${sheet} — PRANK Electronics")
    (company "\${COMPANY}")
    (rev "\${REVISION}")
    (comment 1 "\${STANDARD}")
  )
  (lib_symbols)
  (sheet_instances
    (path "/" (page "1"))
  )
)
SCH
    echo "  [+] 01_SCHEMATIC/${sheet}.kicad_sch"
done

# ── KiCAD worksheet templates (nguyen-v Templates/) ──
# Placeholder — replace with actual .kicad_wks from nguyen-v repo
touch "$TARGET/Templates/KDT_Template.kicad_wks"
touch "$TARGET/Templates/KDT_Template_Fab.kicad_wks"
echo "  [+] Templates/ (placeholders — replace with nguyen-v .kicad_wks)"

# ── README ───────────────────────────────────────────
cat > "$TARGET/README.md" << 'README'
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
README

echo "  [+] README.md"

# ── .gitkeep for empty dirs ──────────────────────────
for dir in Images Computations STEP_BLENDER DXF_SVG "06_VALIDATION/test_records" DOCS; do
    touch "$TARGET/$dir/.gitkeep"
done

# ── Copy DOCS files if running from electronics root ─
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOC_FILES=(
    "SKILL.md"
    "Design_Checklist_IPC_A600.md"
    "IEC60601_Compliance.md"
    "Risk_Analysis_FMEA.md"
    "BOM_Template.csv"
    "INSTRUCCIONES_ES.md"
)
echo ""
echo "  [i] Copying DOCS files..."
for f in "${DOC_FILES[@]}"; do
    if [[ -f "$SCRIPT_DIR/$f" && "$SCRIPT_DIR" != "$TARGET" ]]; then
        cp "$SCRIPT_DIR/$f" "$TARGET/DOCS/$f"
        echo "  [>] $f → DOCS/"
    elif [[ -f "$SCRIPT_DIR/$f" ]]; then
        cp "$SCRIPT_DIR/$f" "$TARGET/DOCS/$f" 2>/dev/null || true
    fi
done

echo ""
echo "=================================================="
echo "  Estructura creada exitosamente!"
echo ""
echo "  IMPORTANTE: Reemplazar Templates/*.kicad_wks"
echo "  con los originales de nguyen-v:"
echo "  https://github.com/nguyen-v/KiCAD_Templates"
echo ""
echo "  Próximos pasos:"
echo "  1. KiCAD 8.0 → Open → PRANK_electronics.kicad_pro"
echo "  2. Board Setup → Import → PRANK_electronics.kicad_dru"
echo "  3. Empezar esquemático en 01_SCHEMATIC/"
echo "  4. Ver DOCS/SKILL.md para reglas de diseño"
echo "=================================================="
