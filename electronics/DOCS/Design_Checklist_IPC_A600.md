# Design Checklist — IPC-A-600 Class 2/3 | PRANK Electronics

**Project:** Robot Paralelo de Rehabilitación de Tobillo — Main PCB
**Standard:** IPC-A-600J Class 3 (Medical/High-Reliability)
**KiCAD Version:** 8.0
**Revision:** A | Date: __________ | Engineer: __________

---

## SECTION 1 — Trace & Spacing Requirements

### 1.1 Trace Width (IPC-2221 Table 6-1)
| Net Class | Min Width | Required Width | Verified | Notes |
|-----------|-----------|---------------|----------|-------|
| Signal (< 0.5 A) | 0.15 mm | 0.15 mm | ☐ | |
| Logic power (1 A) | 0.30 mm | 0.35 mm | ☐ | 3.3 V / 5 V rails |
| Motor current (2 A) | 0.50 mm | 0.60 mm | ☐ | V_M to DRV8833 |
| Motor current (6 A fuse) | 1.20 mm | 1.50 mm | ☐ | Input power trace |

### 1.2 Clearance (IPC-2221 Table 6-4, Internal)
| Voltage | Min Clearance | Applied | Verified |
|---------|--------------|---------|---------|
| < 15 V (B1 coated) | 0.10 mm | 0.15 mm | ☐ |
| 15–30 V (B1 coated) | 0.10 mm | 0.15 mm | ☐ |
| Motor supply (≤ 12 V) | 0.15 mm | 0.50 mm | ☐ |

### 1.3 Creepage & Clearance (IEC 60664-1, IEC 60601-1)
| Path | Min Creepage | Min Air | Applied | Verified |
|------|-------------|---------|---------|---------|
| Mains to SELV | 4.0 mm | 2.5 mm | N/A | ☐ |
| Motor supply to signal | 1.5 mm | 1.0 mm | ______ | ☐ |

---

## SECTION 2 — Via Requirements

| Parameter | IPC Min | Design Value | Verified |
|-----------|---------|-------------|---------|
| Drill diameter | 0.20 mm | 0.30 mm | ☐ |
| Pad diameter | drill × 1.8 | 0.60 mm | ☐ |
| Annular ring (outer) | 0.05 mm | 0.15 mm | ☐ |
| Annular ring (inner) | 0.025 mm | 0.10 mm | ☐ |
| Via-to-trace clearance | 0.15 mm | 0.15 mm | ☐ |
| Via-to-via clearance | 0.15 mm | 0.20 mm | ☐ |
| Thermal via (DRV8833) | — | 0.3 mm drill, array | ☐ |

---

## SECTION 3 — DRC / ERC Validation

### 3.1 ERC (Schematic)
- [ ] Zero unconnected pins (excluding intentional NC)
- [ ] Zero power pin conflicts
- [ ] All PWR_FLAG symbols placed on power nets
- [ ] Bus labels consistent across hierarchy
- [ ] All components have correct footprint assignment
- [ ] ERC report exported to `06_VALIDATION/ERC_reports/ERC_RevA.txt`

### 3.2 DRC (PCB Layout)
- [ ] Zero clearance violations
- [ ] Zero unrouted connections
- [ ] Zero courtyard overlaps
- [ ] Zero silkscreen-over-pad violations
- [ ] Board outline (Edge.Cuts) closed and valid
- [ ] 3D model check — no component collisions
- [ ] DRC report exported to `06_VALIDATION/DRC_reports/DRC_RevA.txt`

### 3.3 Net Inspection
- [ ] Motor GND and signal GND joined at single star point only
- [ ] PWR_MOTOR net class assigned to all motor traces
- [ ] No signal traces on motor supply layer (L4)

---

## SECTION 4 — Component Sourcing

### 4.1 Digi-Key Approved Sourcing
| Reference | Part | Digi-Key PN | Lifecycle | Verified |
|-----------|------|-------------|-----------|---------|
| U1 | DRV8833PWPR | 296-28940-1-ND | Active | ☐ |
| U2 | STM32F407VGT6 | 497-11172-ND | Active | ☐ |
| U3 | ADP3338AKCZ-3.3 | ADP3338AKCZ-3.3R7CT-ND | Active | ☐ |
| D1 | 1N4007 | 1N4007DICT-ND | Active | ☐ |
| D2 | PRTR5V0U2X | 568-4078-1-ND | Active | ☐ |
| Fuse1 | RXEF075 | F2885CT-ND | Active | ☐ |

- [ ] All parts checked for RoHS compliance
- [ ] All parts checked for REACH compliance
- [ ] No parts in last-time-buy or obsolete status
- [ ] Alternate source identified for single-source components
- [ ] Lead time < 12 weeks for all components (or safety stock plan)

---

## SECTION 5 — Motor Control Verification

### 5.1 DRV8833 Circuit
- [ ] VM decoupling: 100 μF + 10 μF within 5 mm
- [ ] Bypass caps: 100 nF on VCP and VINT pins
- [ ] AISEN/BISEN connected through 0.47 Ω sense resistors to GND
- [ ] nFAULT pin pulled up to 3.3 V via 10 kΩ, connected to MCU GPIO
- [ ] nSLEEP pin connected to MCU GPIO (motor enable control)
- [ ] 1N4007 diodes: one per motor terminal (4 total), < 5 mm from IC
- [ ] PWM traces: 50 Ω controlled impedance if > 5 cm
- [ ] Thermal vias under DRV8833 exposed pad (3×3 array, 0.3 mm drill)

### 5.2 PWM Verification
- [ ] PWM frequency set to 16–20 kHz in firmware (not layout — document reference)
- [ ] Deadtime inserted between high/low side transitions
- [ ] Motor protection: fault detection routine in MCU firmware

---

## SECTION 6 — Sensor Interface Verification

### 6.1 Potentiometer / Analog Input
- [ ] RC filter placed at each ADC input (f_c = Fs/5)
- [ ] R = 8.2 kΩ, C = 10 nF → f_c ≈ 1.94 kHz
- [ ] TVS + 100 Ω series resistor on each input before MCU
- [ ] 1 μF + 100 nF decoupling at MCU VDDA pin
- [ ] Analog traces routed away from motor switching traces
- [ ] Guard ring around sensitive analog section

### 6.2 I²C / Digital Sensors
- [ ] Pull-up resistors: 4.7 kΩ on SDA and SCL
- [ ] 100 pF filter cap if bus length > 30 cm
- [ ] Address conflicts checked (no duplicate I²C addresses)

---

## SECTION 7 — Power Distribution

- [ ] 6 A resettable fuse on main power input (before any branching)
- [ ] Reverse polarity protection (P-MOSFET or Schottky)
- [ ] Bulk capacitor: 100 μF at power input
- [ ] LDO 5 V: output decoupling 22 μF + 100 nF
- [ ] LDO 3.3 V: output decoupling 10 μF + 100 nF
- [ ] Power LED indicator with 470 Ω current-limiting resistor
- [ ] Power planes on L3 — no stitching vias through power island
- [ ] Inrush current < 1 A at startup (soft-start or NTC thermistor)

---

## SECTION 8 — Manufacturing Files

### 8.1 Gerber Files
- [ ] F.Cu (Top copper)
- [ ] In1.Cu (GND plane)
- [ ] In2.Cu (Power plane)
- [ ] B.Cu (Bottom copper)
- [ ] F.Mask / B.Mask
- [ ] F.Silkscreen / B.Silkscreen
- [ ] Edge.Cuts
- [ ] Gerbers verified in Gerber viewer (KiCAD or Gerbv)

### 8.2 Drill Files
- [ ] Excellon format, metric units
- [ ] Separate files: plated (PTH) and non-plated (NPTH)
- [ ] Drill report generated and reviewed

### 8.3 BOM
- [ ] BOM exported from KiCAD (all fields populated)
- [ ] BOM_Template.csv updated with actual Digi-Key part numbers
- [ ] DNP (Do Not Place) components clearly marked
- [ ] Total component cost calculated

### 8.4 Pick & Place
- [ ] Component placement CSV exported
- [ ] Top and bottom side files separate
- [ ] Reference designator orientation matches footprint

---

## SECTION 9 — Design Review Sign-Offs

| Review Stage | Reviewer | Date | Signature | Pass/Fail |
|-------------|---------|------|-----------|-----------|
| Schematic review | | | | |
| Layout review | | | | |
| DRC/ERC clear | | | | |
| BOM approval | | | | |
| Manufacturing file review | | | | |
| Safety/compliance review | | | | |
| Final design freeze | | | | |

**Design History File (DHF) reference:** ___________________________

---

*This checklist must be completed and archived in the Design History File per FDA 21 CFR 820.30(j).*
