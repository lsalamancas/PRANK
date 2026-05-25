# IEC 60601-1 Compliance Documentation — PRANK Electronics

**Project:** Robot Paralelo de Rehabilitación de Tobillo — Main PCB
**Standard:** IEC 60601-1:2005 + Amendment 1 (2012)
**Applied Parts Classification:** Type B (no patient electrical connection)
**Device Classification:** Class I (protective earth)
**Revision:** A | Date: __________ | Engineer: __________

---

## 1. Isolation & Creepage Requirements

### 1.1 Means of Protection (MOOP / MOPP)
Per IEC 60601-1 clause 8.8:

| Protection Path | Class | Min Creepage | Min Clearance | Applied | Status |
|----------------|-------|-------------|--------------|---------|--------|
| Mains → patient | 2 MOPP | 8.0 mm | 4.0 mm | N/A | N/A |
| Mains → accessible | 2 MOPP | 4.0 mm | 2.5 mm | N/A | N/A |
| Motor supply → signal GND | 1 MOOP | 1.5 mm | 1.0 mm | ____ mm | ☐ |
| SELV → operator | 1 MOOP | 1.0 mm | 0.5 mm | 0.5 mm | ☐ |

> **Note:** PRANK operates on SELV (≤ 42.4 V peak). Mains isolation is handled by the external power adapter (must be IEC 60601-1 certified — document supplier certification).

### 1.2 IEC 60664-1 Pollution Degree
- **Pollution Degree 2** (normal indoor industrial environment)
- Minimum creepage for 12 V, PD2, overvoltage category II: **0.5 mm**
- Applied design margin: 3× → **1.5 mm** between motor supply and signal traces

---

## 2. Power Supply Safety

### 2.1 External Power Adapter Requirements
- Must carry IEC 60601-1 / UL 60601-1 certification
- Output: SELV, ≤ 12 VDC, current-limited at ≤ 8 A
- Connector: medical-grade locking (e.g., Kycon KPPX-2P)
- Certification to document in DHF: _________________________________

### 2.2 On-Board Protection
| Protection | Device | Rating | Status |
|-----------|--------|--------|--------|
| Over-current (input) | Littelfuse RXEF075 polyfuse | 6 A trip | ☐ |
| Reverse polarity | P-MOSFET + Schottky | 12 V / 8 A | ☐ |
| Over-voltage transient | TVS on power input | 15 V clamp | ☐ |
| Thermal shutdown (software) | NTC + MCU | 80 °C trip | ☐ |
| Thermal shutdown (hardware) | DRV8833 internal | 150 °C (TJ) | ☐ |

### 2.3 SELV Boundary
- All exposed conductors and test points: SELV (< 60 VDC / 42.4 V peak AC)
- Isolation from mains: achieved by certified external adapter
- SELV boundary clearly marked on PCB silkscreen

---

## 3. Mechanical & Environmental Conditions

### 3.1 Operating Conditions (IEC 60601-1 clause 6.8)
| Parameter | Standard Requirement | PRANK Specification |
|-----------|---------------------|-------------------|
| Ambient temperature | +10 to +40 °C | +15 to +35 °C |
| Relative humidity | 30–75% | 30–75% |
| Atmospheric pressure | 700–1060 hPa | 800–1060 hPa |
| Altitude | ≤ 2000 m | ≤ 1500 m |

### 3.2 Transport & Storage (IEC 60601-1 clause 6.8.2)
| Parameter | Requirement |
|-----------|------------|
| Temperature | -25 to +70 °C |
| Humidity | 10–90% non-condensing |
| Drop test | Per IEC 60601-1 if portable |

### 3.3 Ingress Protection
- Enclosure target: **IP21** minimum (drip-proof)
- PCB conformal coating: Acrylic (AR) over assembled board
- Conformal coating: do not coat connectors, test points, or adjustment trimmers

---

## 4. Electrical Safety

### 4.1 Protective Earth
- Enclosure connected to PE via ≥ 1.5 mm² green/yellow wire
- PE continuity resistance: < 0.1 Ω (measured per IEC 60601-1 clause 8.6.4)
- PE connection point: M4 stud, verified torque 1.2 Nm

### 4.2 Leakage Current Limits (IEC 60601-1 clause 8.7)
| Type | Normal Condition | Single Fault |
|------|-----------------|-------------|
| Earth leakage | < 500 μA | < 1000 μA |
| Touch current | < 100 μA | < 500 μA |
| Patient leakage | N/A (Type B, no patient contact) | N/A |

### 4.3 Dielectric Strength (IEC 60601-1 clause 8.8.3)
- Applied test voltage: 1500 VAC for 60 s (MOOP, reinforced insulation)
- Test between: motor supply and accessible metal parts
- Pass criterion: no breakdown, no flashover, leakage < 5 mA

---

## 5. EMC Requirements (IEC 60601-1-2:2014 Ed.4)

### 5.1 Emissions
| Test | Standard | Limit (Class B) | Pre-compliance target |
|------|----------|-----------------|----------------------|
| Conducted emissions | CISPR 11 | 66–56 dBμV (0.15–30 MHz) | ≤ 56 dBμV | ☐ |
| Radiated emissions | CISPR 11 | 30 dBμV/m @ 10 m (30–1000 MHz) | ≤ 28 dBμV/m | ☐ |

**Mitigation on PCB:**
- 4-layer stack with solid GND plane (L2) reduces radiated emissions
- Motor PWM frequency: 16–20 kHz (fundamental outside conducted band)
- Common-mode choke on motor lines: recommended if radiated pre-comp fails
- Input power filter: 10 μH + 100 nF + 10 μF π-filter at power entry

### 5.2 Immunity (IEC 60601-1-2 Table 4 — Professional Healthcare)
| Phenomenon | Standard | Test Level | Performance Criterion |
|-----------|----------|------------|----------------------|
| ESD | IEC 61000-4-2 | ±8 kV contact, ±15 kV air | B |
| Radiated RF | IEC 61000-4-3 | 10 V/m, 80–2700 MHz | A |
| EFT/Burst | IEC 61000-4-4 | ±2 kV power, ±1 kV signal | A |
| Surge | IEC 61000-4-5 | ±1 kV DM, ±2 kV CM | B |
| Conducted RF | IEC 61000-4-6 | 3 Vrms, 0.15–80 MHz | A |
| Power freq. magnetic | IEC 61000-4-8 | 30 A/m | A |
| Voltage dips | IEC 61000-4-11 | 0%, 40%, 70% dips | B/C |

**Performance Criteria:**
- A: Normal performance during test
- B: Temporary degradation, self-recovers
- C: Temporary loss, requires operator intervention (acceptable for rehabilitation)

---

## 6. Risk Analysis (Summary — See FMEA for Detail)

### 6.1 Applicable Hazards (IEC 60601-1 clause 4.2)
| Hazard | Mitigation | Risk Level Post-Mitigation |
|--------|-----------|--------------------------|
| Excessive motor torque | Current sense + software limit | Low |
| Motor runaway | Watchdog + hardware e-stop | Low |
| Electric shock (operator) | SELV, fuse, PE | Low |
| Overheating (DRV8833) | NTC monitoring, thermal shutdown | Low |
| EMI causing wrong movement | Immunity per IEC 60601-1-2 | Low |
| Software failure → unsafe motion | Watchdog timer, dual e-stop | Low |

### 6.2 Risk Acceptability Criteria
Per ISO 14971: residual risk ALARP — all hazards reduced to Low or Negligible.

---

## 7. Component Selection (Medical-Grade)

| Category | Requirement | Applied |
|----------|------------|---------|
| Capacitors | AEC-Q200 or equivalent reliability | X7R ≥ 10 V margin | ☐ |
| Resistors | AEC-Q200, 1% tolerance | Vishay / Yageo | ☐ |
| IC (U1 DRV8833) | Industrial temp range (-40 to +125 °C) | PWPR package | ☐ |
| IC (U2 STM32F407) | Industrial grade (-40 to +85 °C) | VGT6 package | ☐ |
| Connectors | IEC 60601-1 compliant, locking | Kycon / Molex medical | ☐ |
| Fuse | UL 248 listed | Littelfuse RXEF | ☐ |
| Solder | IPC J-STD-006, SAC305 Pb-free | SAC305 | ☐ |

---

## 8. Testing & Validation Plan

| Test | Standard | Lab / Tool | Scheduled Date | Result |
|------|----------|-----------|---------------|--------|
| Dielectric strength | IEC 60601-1 §8.8.3 | Hi-pot tester | | ☐ |
| Earth continuity | IEC 60601-1 §8.6.4 | Milliohmmeter | | ☐ |
| Leakage current | IEC 60601-1 §8.7 | Safety analyzer | | ☐ |
| EMC pre-compliance | CISPR 11 / IEC 61000-4-x | LISN + spectrum analyzer | | ☐ |
| Thermal (burn-in) | 48 h @ 40 °C, 75% RH | Environmental chamber | | ☐ |
| Functional safety | Motor torque limits | Torque sensor fixture | | ☐ |
| Watchdog test | 500 ms timeout | Oscilloscope + debugger | | ☐ |
| E-stop test | Dual-channel | Manual test procedure | | ☐ |

---

## 9. Compliance Documentation Checklist

### Required for DHF (FDA 21 CFR 820.30)
- [ ] IEC 60601-1 test report (or pre-compliance + risk justification)
- [ ] IEC 60601-1-2 EMC test report
- [ ] External power adapter 60601-1 certificate
- [ ] ISO 14971 risk management file (links to FMEA)
- [ ] Component qualification records
- [ ] PCB manufacturing specification (IPC-A-600 Class 3)
- [ ] Solder process qualification (IPC J-STD-001)
- [ ] Design review records (signed checklists)
- [ ] Software validation documentation (IEC 62304)
- [ ] Traceability matrix: requirements → design → test

**DHF Document Number:** ___________________________
**Approval:** _________________________ Date: _________
