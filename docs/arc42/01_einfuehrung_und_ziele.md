# 1. Einführung und Ziele

<!-- arc42-Hilfe:
Beschreibt die wesentlichen Anforderungen und treibenden Kräfte: Geschäftsziele, wesentliche Aufgabenstellungen,
funktionale Anforderungen, Qualitätsziele für die Architektur, relevante Stakeholder und deren Erwartungshaltung.
Mehr: https://docs.arc42.org/section-1/
-->

**Architekturauftrag:** Aus unzuverlässigen Zulieferdaten einen verlässlichen Pass machen, der jedem genau das zeigt, was er sehen darf, und das noch in vielen Jahren.

## 1.1 Aufgabenstellung

### Was ist VoltPass?

VoltPass erstellt und verwaltet die digitalen Batteriepässe der VoltCell GmbH. Ab dem 18.02.2027 braucht jede neue E-Bike-Batterie und jede Industriebatterie über 2 kWh einen solchen Pass, ohne ihn darf VoltCell sie in der EU nicht mehr verkaufen.

Der Pass zeigt Rohstoffherkunft, CO₂-Fußabdruck, Zustand und Recycling. Die Daten kommen größtenteils von Zulieferern, sind uneinheitlich und ändern sich über die Lebensdauer der Batterie. VoltPass sammelt sie ein, lässt sie von einer KI auslesen und von Menschen freigeben. Anschließend stellt es den Pass über einen QR-Code bereit, für jede Rolle in dem Umfang, der ihr zusteht.

### Hauptfunktionen

| ID | Use Case | Beschreibung |
|---|---|---|
| | **Daten einsammeln** | |
| F-01 | Zulieferdaten einreichen | Zulieferer liefern Daten von sich aus oder auf Anfrage per Schnittstelle, Datei-Upload oder Browser-Formular. |
| F-02 | Daten extrahieren | Eine KI liest Passfelder aus Datenblättern aus und liefert jeden Wert als Vorschlag mit Fundstelle und Konfidenz. |
| F-03 | Daten prüfen und freigeben | Datenverantwortliche prüfen jeden Wert an seiner Quelle, Werte mit niedriger Konfidenz werden zuerst angezeigt. Sie geben frei, korrigieren oder fragen beim Zulieferer nach. |
| | **Pass ausgeben** | |
| F-04 | Pass veröffentlichen | Das ERP meldet jede gefertigte Batterie, VoltPass vergibt Kennung und QR-Code. Nach Freigabe aller Pflichtfelder wird der Pass veröffentlicht und im EU-Register gemeldet. |
| F-05 | Pass abrufen | Der Pass ist abrufbar: • per QR-Code ohne Anmeldung mit den öffentlichen Angaben • angemeldet mit den Feldern der eigenen Rolle • maschinenlesbar für Behörden |
| F-06 | Zugang verwalten | Werkstätten, Recycler und Aufbereiter sehen erweiterte Daten erst nach Freischaltung. Dafür weisen sie nach, dass sie ein Fachbetrieb sind, Compliance schaltet sie frei und kann den Zugang wieder entziehen. |
| | **Pass begleiten** | |
| F-07 | Zustand nachtragen | Werkstätten tragen Zustandsdaten wie den State of Health nach, jeweils als neue Version. |
| F-08 | Änderungen nachweisen | Jede Änderung ist mit Person, Zeitpunkt und Quelle belegt, frühere Stände bleiben einsehbar. |
| F-09 | Angaben korrigieren | Ein Datenblatt gilt oft für viele Batterien. Ist es falsch oder veraltet, werden nach erneuter Freigabe alle Pässe aktualisiert, die darauf beruhen. |
| F-10 | An Treuhänder übergeben | Ein unabhängiger Treuhänder erhält laufend eine Kopie aller Pässe samt Historie. Im Fall einer Insolvenz oder Geschäftsaufgabe von VoltCell führt der QR-Code zu ihm. |
| F-11 | Pass abschließen | Nach dem Recycling erlischt der Pass. Wird die Batterie umgenutzt oder wiederaufgearbeitet, erstellt der Aufbereiter einen neuen Pass mit neuer Kennung, VoltPass verknüpft den alten damit. |

### Kernprobleme

| ID | Kernproblem | Beschreibung |
|---|---|---|
| H-1 | Unzuverlässige Zulieferdaten | Die Daten kommen von vielen Zulieferern in unterschiedlichen Formaten und sind teils lückenhaft oder fehlerhaft. In den Pass dürfen sie nur geprüft. |
| H-2 | Gestufter Zugriff | Die Batterieverordnung legt drei Zugriffsstufen fest. Jede Rolle darf nur ihre Felder sehen und ändern. |
| H-3 | Langlebiger QR-Code | Der aufgedruckte QR-Code muss mindestens 10 Jahre zum Pass führen, auch wenn es VoltCell nicht mehr gibt. |
| H-4 | Nachweis trotz Datenschutz | Jede Änderung muss belegbar bleiben, obwohl die Historie personenbezogene Daten enthält. |
| H-5 | Massenhafte Korrekturen | Fehler in einem Datenblatt betreffen tausende Pässe gleichzeitig und müssen trotzdem nachvollziehbar korrigiert werden. |

## 1.2 Qualitätsziele

Die Ziele sind nach Priorität geordnet und orientieren sich am Qualitätsmodell ISO/IEC 25010.

| ID | Qualitätsziel | Motivation |
|---|---|---|
| QZ-1 | Verlässliche Passdaten | Der Pass ist ein rechtlich relevantes Dokument. Jeder Wert ist belegt und von einem Menschen freigegeben, auch wenn KI oder Zulieferer Fehler machen. |
| QZ-2 | Langfristige Erreichbarkeit | Der QR-Code ist aufgedruckt und nicht änderbar. Er führt über die gesamte Lebensdauer der Batterie zum richtigen Pass, auch wenn es VoltCell nicht mehr gibt. |
| QZ-3 | Rollengerechter Zugriff | Jede Rolle sieht und ändert nur die Felder, die ihr zustehen. |
| QZ-4 | Lückenlose Nachweisbarkeit | Für jede Angabe ist belegbar, wer sie wann aus welcher Quelle geändert hat. Die Historie lässt sich nicht manipulieren. |
| QZ-5 | Änderbarkeit | Neue Datenfelder, Rollen, regulatorische Anforderungen und KI-Dienste müssen ohne grundlegenden Umbau des Systems integriert werden können. |

## 1.3 Stakeholder

| ID | Rolle | Erwartung |
|---|---|---|
| SH-01 | Geschäftsführung | Marktzugang ab 18.02.2027 sichern, überschaubare Betriebskosten |
| SH-02 | Compliance und<br>Datenschutz | • Rechtssicherer, DSGVO-konformer Pass • Prüfbare Historie • Entscheidet über Zugänge |
| SH-03 | Datenverantwortliche | Daten prüfen und freigeben, unplausible KI-Werte schnell erkennen |
| SH-04 | Produktion | Eindeutige Kennung je Batterie rechtzeitig vor dem Druck des QR-Etiketts |
| SH-05 | IT-Betrieb | Über 10+ Jahre mit verbreiteter, langfristig gepflegter Technik betreibbar, Ausfälle früh erkennen |
| SH-06 | Architektur- und Entwicklungsteam | • Nachvollziehbare Entscheidungen • Klare Bausteine und Schnittstellen • Prüfbare Qualitätsziele • Machbarer Prototyp bis 01/2027 |
| SH-07 | Zulieferer | Daten per Schnittstelle oder ohne eigene IT per Browser liefern |
| SH-08 | Endkunde | Öffentliche Angaben per QR-Code ohne Anmeldung auf dem Smartphone abrufen |
| SH-09 | Werkstatt | Reparatur- und Zustandsdaten lesen, Zustand nachtragen |
| SH-10 | Recycler und<br>Aufbereiter | Demontage- und Materialdaten lesen, Recycling oder neuen Pass melden |
| SH-11 | Behörden und<br>Prüfstellen | Marktaufsicht, notifizierte Stellen, EU-Kommission: alle Daten einschließlich Historie einsehen |
| SH-12 | Treuhänder | Datenkopie in offenem Format, um bei Wegfall von VoltCell zu übernehmen |
