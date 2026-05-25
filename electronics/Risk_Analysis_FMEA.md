# Risk Analysis — FMEA | PRANK Electronics

**Project:** Robot Paralelo de Rehabilitación de Tobillo — Main PCB
**Standard:** FDA 21 CFR 820.30 · ISO 14971:2019 · IEC 60601-1
**Method:** Failure Mode and Effects Analysis (FMEA — Design)
**Revision:** A | Date: __________ | Lead Engineer: __________

---

## Risk Scoring

| Severity (S) | Occurrence (O) | Detection (D) |
|-------------|---------------|--------------|
| 1 = Negligible | 1 = Remote (< 1 in 10,000) | 1 = Almost certain detection |
| 3 = Minor injury | 3 = Low (1 in 1,000) | 3 = High detection probability |
| 5 = Moderate injury | 5 = Moderate (1 in 100) | 5 = Moderate detection |
| 7 = Serious injury | 7 = High (1 in 10) | 7 = Low detection probability |
| 10 = Death | 10 = Very high (> 1 in 10) | 10 = No detection |

**RPN = S × O × D**
- RPN < 50: Acceptable
- 50 ≤ RPN < 100: ALARP — review mitigation
- RPN ≥ 100: Unacceptable — must mitigate

---

## TABLE 1 — Motor Control Subsystem

| # | Item | Failure Mode | Effect on System | Cause | S | O | D | RPN | Mitigation | Residual S | Residual O | Residual D | Residual RPN | Status |
|---|------|-------------|-----------------|-------|---|---|---|-----|-----------|-----------|-----------|-----------|-------------|--------|
| MC-01 | DRV8833 (U1) | Internal short circuit | Motor runs uncontrolled | IC overstress, ESD | 7 | 3 | 5 | 105 | TVS on inputs; operating within derating; thermal vias; nFAULT monitoring | 7 | 2 | 3 | 42 | ☐ Open |
| MC-02 | DRV8833 (U1) | Output latch-up | Motor locked ON | ESD, voltage spike | 7 | 3 | 3 | 63 | Hardware watchdog cuts enable; e-stop relay | 7 | 2 | 2 | 28 | ☐ Open |
| MC-03 | DRV8833 (U1) | Thermal shutdown (TJ > 150 °C) | Motor stops unexpectedly | Overload, poor thermal | 3 | 4 | 2 | 24 | Thermal vias; NTC software alarm at 80 °C; current limiting | 3 | 2 | 2 | 12 | ☐ Open |
| MC-04 | Freewheeling diodes (D1) | Open failure | Back-EMF spike → DRV8833 damage | Solder defect, overcurrent | 7 | 2 | 4 | 56 | AEC-Q101 components; AOI inspection; IPC-A-600 Class 3 assembly | 7 | 1 | 2 | 14 | ☐ Open |
| MC-05 | Freewheeling diodes (D1) | Short circuit | Motor supply to GND short | Reverse voltage, overstress | 5 | 2 | 3 | 30 | Fuse on V_M; polarity protection; derating to 50% | 5 | 1 | 2 | 10 | ☐ Open |
| MC-06 | Current sense R (R3, 0.47 Ω) | Open failure | Loss of current feedback | Solder defect, thermal stress | 5 | 2 | 4 | 40 | AOI; 2512 package for robustness; software current monitoring via ADC | 5 | 1 | 3 | 15 | ☐ Open |
| MC-07 | Current sense R (R3, 0.47 Ω) | Value shift > 5% | Incorrect current reading | Aging, temperature | 3 | 3 | 5 | 45 | 1% tolerance; periodic calibration procedure in maintenance plan | 3 | 2 | 3 | 18 | ☐ Open |
| MC-08 | Decoupling caps | Open failure | VM noise → DRV8833 glitch | Ceramic cracking, solder | 5 | 3 | 5 | 75 | Multiple cap values (100 μF + 10 μF + 100 nF); X7R dielectric; AOI | 5 | 1 | 3 | 15 | ☐ Open |
| MC-09 | Motor connector (J1) | Loose connection / intermittent | Unexpected motor stop or spark | Vibration, improper assembly | 5 | 3 | 4 | 60 | Locking Molex connector; torque spec on fasteners; vibration test | 5 | 2 | 2 | 20 | ☐ Open |
| MC-10 | PWM signal | High-frequency EMI | Sensor interference / EMC failure | Poor routing, no ground plane | 3 | 4 | 5 | 60 | 4-layer stack with GND plane; PWM traces < 5 cm; ferrite bead option | 3 | 2 | 3 | 18 | ☐ Open |

---

## TABLE 2 — Sensor Interface Subsystem

| # | Item | Failure Mode | Effect on System | Cause | S | O | D | RPN | Mitigation | Residual S | Residual O | Residual D | Residual RPN | Status |
|---|------|-------------|-----------------|-------|---|---|---|-----|-----------|-----------|-----------|-----------|-------------|--------|
| SI-01 | Potentiometer / angle sensor | Open circuit | Loss of position feedback | Mechanical wear, wire break | 7 | 3 | 3 | 63 | Software watchdog detects frozen ADC value; safe state = stop | 7 | 2 | 2 | 28 | ☐ Open |
| SI-02 | Potentiometer / angle sensor | Short to supply | Constant full-scale reading | Insulation failure | 7 | 2 | 3 | 42 | 100 Ω series resistor limits current; TVS clamps to 3.3 V | 5 | 2 | 2 | 20 | ☐ Open |
| SI-03 | Potentiometer / angle sensor | Drift > 2° | Incorrect position control | Temperature, aging | 3 | 4 | 5 | 60 | Calibration at startup; periodic recalibration procedure; alarm threshold | 3 | 2 | 3 | 18 | ☐ Open |
| SI-04 | ADC RC filter | Wrong cutoff (component tolerance) | Aliasing or signal distortion | 5% R/C tolerance | 3 | 3 | 5 | 45 | Use 1% resistors; specify capacitor tolerance ≤ 5%; verify f_c in production test | 3 | 2 | 3 | 18 | ☐ Open |
| SI-05 | ESD protection TVS (D2) | Open failure | ADC input exposed to ESD | Solder defect | 5 | 2 | 5 | 50 | AOI; functional ESD test in production; IPC-A-600 Class 3 | 5 | 1 | 3 | 15 | ☐ Open |
| SI-06 | ESD protection TVS (D2) | Short circuit | Signal pulled to clamp voltage | Overstress ESD event | 5 | 2 | 3 | 30 | 100 Ω series R limits damage; TVS replaced if damaged; production test | 3 | 2 | 3 | 18 | ☐ Open |
| SI-07 | I²C bus | Address conflict | Two devices not responding | Wrong address configuration | 3 | 2 | 3 | 18 | Address check in firmware init; I²C scanner test in production | 3 | 1 | 2 | 6 | ☐ Open |
| SI-08 | I²C bus | Bus lockup (SDA stuck low) | Sensor communication lost | Noise, firmware bug | 5 | 3 | 3 | 45 | I²C bus reset routine in firmware; timeout detection; watchdog reset | 5 | 2 | 2 | 20 | ☐ Open |
| SI-09 | Signal routing | Crosstalk from motor traces | ADC noise > 1 LSB | Poor layout, shared layer | 3 | 3 | 5 | 45 | Route analog signals on L1 away from motor; ground guard; verify in test | 3 | 1 | 3 | 9 | ☐ Open |

---

## TABLE 3 — Power Supply Subsystem

| # | Item | Failure Mode | Effect on System | Cause | S | O | D | RPN | Mitigation | Residual S | Residual O | Residual D | Residual RPN | Status |
|---|------|-------------|-----------------|-------|---|---|---|-----|-----------|-----------|-----------|-----------|-------------|--------|
| PS-01 | Polyfuse (Fuse1, 6 A) | Fails to trip | Overcurrent → fire / damage | Defective fuse | 7 | 2 | 4 | 56 | UL listed component; lot testing; external adapter current-limited | 7 | 1 | 3 | 21 | ☐ Open |
| PS-02 | Polyfuse (Fuse1, 6 A) | Nuisance trip | Motor stops unexpectedly | Fuse undersized for inrush | 3 | 3 | 2 | 18 | Verify inrush < 5 A at startup; soft-start firmware ramp | 3 | 2 | 2 | 12 | ☐ Open |
| PS-03 | LDO 3.3 V (U3) | Output undervoltage | MCU reset, system halt | Overload, thermal | 5 | 3 | 2 | 30 | Load analysis ensures < 80% LDO rating; enable pin controlled; LDO with UVLO | 5 | 2 | 2 | 20 | ☐ Open |
| PS-04 | LDO 5 V (U4) | Output overvoltage | Sensor / IO damage | LDO failure | 5 | 2 | 4 | 40 | TVS on 5 V rail; monitor with MCU ADC; OV shutdown in firmware | 5 | 1 | 3 | 15 | ☐ Open |
| PS-05 | Hardware watchdog | Fails to reset MCU | Motor continues in fault state | WDG IC failure | 7 | 2 | 3 | 42 | Use external WDG IC (MAX6369); test at production; FMEA loop: monitor WDG OK pin | 7 | 1 | 2 | 14 | ☐ Open |
| PS-06 | Hardware watchdog | False reset | Nuisance MCU reset during therapy | WDG timeout too short / SW bug | 3 | 3 | 2 | 18 | 500 ms window tested against worst-case ISR latency; HW/SW design review | 3 | 2 | 2 | 12 | ☐ Open |
| PS-07 | Emergency stop SW1 | Fails to open (stuck closed) | E-stop does not cut motor power | Mechanical failure | 7 | 2 | 3 | 42 | Dual-channel e-stop (SW1 AND SW2); safety relay monitors both channels | 7 | 1 | 2 | 14 | ☐ Open |
| PS-08 | Emergency stop SW2 | Fails to open (stuck closed) | E-stop does not cut motor power | Mechanical failure | 7 | 2 | 3 | 42 | Dual-channel e-stop (SW1 AND SW2); if one fails, other still cuts power | 7 | 1 | 2 | 14 | ☐ Open |
| PS-09 | Emergency stop (both) | Fails to open | Motor cannot be stopped | Both switches fail simultaneously | 7 | 1 | 3 | 21 | Dual independent channels reduces this to extremely rare; periodic self-test | 7 | 1 | 2 | 14 | ☐ Open |
| PS-10 | Emergency stop SW1/SW2 | Inadvertent activation | Unexpected motor stop | False trigger, patient or operator | 3 | 4 | 1 | 12 | Debounce in firmware 50 ms; guarded button placement; user training | 3 | 3 | 1 | 9 | ☐ Open |

---

## FDA 21 CFR 820.30 Alignment

| Requirement | FMEA Contribution | DHF Section |
|-------------|------------------|------------|
| 820.30(b) Design planning | FMEA initiated in design phase | DHF-001 |
| 820.30(c) Design input | Hazard identification → requirements | DHF-002 |
| 820.30(d) Design output | Mitigations reflected in schematic/layout | DHF-003 |
| 820.30(f) Design verification | Test cases derived from FMEA mitigations | DHF-005 |
| 820.30(g) Design validation | Clinical-level validation includes FMEA items | DHF-006 |
| 820.30(h) Design transfer | Production test verifies FMEA mitigations | DHF-007 |
| 820.30(i) Design changes | FMEA updated for any design change | DHF-008 |
| 820.30(j) Design history file | This FMEA is part of DHF | DHF-009 |

---

## FMEA Summary

| RPN Range | Before Mitigation | After Mitigation |
|-----------|------------------|-----------------|
| Unacceptable (≥ 100) | 2 items | 0 items |
| Review (50–99) | 8 items | 0 items |
| Acceptable (< 50) | 14 items | 24 items |

**All residual RPNs are < 50. Risk is ALARP.**

---

## Sign-Offs

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Lead Engineer | | | |
| Safety Engineer | | | |
| Quality Manager | | | |
| Clinical Advisor | | | |

**ISO 14971 Risk Management File Reference:** ___________________________
**Next FMEA Review Date:** ___________________________
