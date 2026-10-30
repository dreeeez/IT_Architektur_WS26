# 5. Bausteinsicht

<!-- arc42-Hilfe:
INHALT: Statische Zerlegung des Systems in Bausteine (Module, Komponenten, Subsysteme, Schichten, ...)
und deren Abhängigkeiten. Gehört in jede Architekturdoku, sie ist der „Grundrissplan“.
MOTIVATION: Überblick über den Code durch Abstraktion, ohne zu viele Implementierungsdetails.
FORM: Hierarchie aus Whiteboxen und Blackboxen.
Ebene 1 = Whitebox des Gesamtsystems + Blackbox-Beschreibungen der enthaltenen Bausteine.
Ebene 2 = zoomt in einige Bausteine der Ebene 1, usw.
Mehr: https://docs.arc42.org/section-5/
-->

## 5.1 Whitebox Gesamtsystem (Ebene 1)

<!-- arc42-Hilfe:
Whitebox-Template:
- Übersichtsdiagramm
- Begründung der Zerlegung
- Blackbox-Beschreibungen der enthaltenen Bausteine: entweder kompakt als Tabelle (Name,
  Verantwortung) oder je Baustein ein Unterkapitel nach Blackbox-Template (s. u.)
- optional: wichtige Schnittstellen
Blackbox-Template: Zweck/Verantwortung, Schnittstelle(n), optional Qualitäts-/Leistungsmerkmale,
Ablageort/Dateien, erfüllte Anforderungen, offene Punkte/Risiken.
-->

**Übersichtsdiagramm:**

**Begründung:**

**Enthaltene Bausteine:**

| Baustein | Verantwortung |
|---|---|
| | |

## 5.2 Ebene 2

<!-- arc42-Hilfe:
Innerer Aufbau EINIGER Bausteine aus Ebene 1 als Whitebox. Relevanz vor Vollständigkeit:
wichtige, überraschende, riskante, komplexe oder volatile Bausteine skizzieren. Normale, einfache
oder standardisierte Teile weglassen.
-->
