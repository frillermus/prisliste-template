# Prisliste og virksomhedsværktøjer

Dansk prisliste med administrationspanel, varekatalog, medarbejderkonti og værktøjer til den daglige drift af en virksomhed.

## Kom i gang

1. Udgiv `index.html` via GitHub Pages eller en anden statisk webserver.
2. Første gang oprettes administratorens konto.
3. I **Administration** kan administratoren ændre virksomhedsoplysninger, udseende, rabatregler, visning af priser og varekatalog.
4. Under **Medarbejdere** oprettes konti og tildeles adgang til relevante funktioner.
5. Åbn `virksomhedsvaerktojer.html` for at bruge økonomioversigt, kundeopgaver, udgiftsregistrering og kundeoversigt.

## Virksomhedsværktøjer

- **Økonomioversigt:** månedens gemte overslag, registrerede udgifter, et enkelt resultatoverslag og åbne opgaver.
- **Kundeopgaver:** registrér kunde, kontaktoplysninger, køretøj eller emne, reference, dato, forventet pris, status og interne noter.
- **Udgifter:** kategorisér udgifter til eksempelvis materialer, værktøj, leje, markedsføring og transport.
- **Kunder:** søg i kunder fra gemte overslag og opgaver.
- **CSV-eksport:** hent en regnearksvenlig oversigt over overslag, udgifter og kundeopgaver.

Værktøjerne bruger samme webadresse som prislisten, så de kan læse prislistens overslag. Udgifter og kundeopgaver tilføjes i virksomhedsværktøjernes egne visninger.

## Medarbejderadgang

Administrator kan give medarbejdere adgang til prislisten, overslag, historik, rabat, vagtregistrering, vagtoversigt, medarbejderadministration og virksomhedsindstillinger. Giv kun de rettigheder, medarbejderen har brug for.

## Valgfri Supabase

Supabase kan bruges til login og deling af indstillinger og overslag. Kør `supabase-shared-setup.sql` i Supabase SQL-editoren, og udfyld derefter både `SUPABASE_URL` og `SUPABASE_PUBLISHABLE_KEY` i `index.html`. Brug aldrig en service-role- eller hemmelig nøgle i browseren.

Supabase-konti oprettes gennem Supabase Authentication. Individuel medarbejderadministration og de lokale virksomhedsværktøjer kræver server-side funktioner, før de kan deles sikkert mellem brugere/enheder.

## Bemærkninger

- Uden Supabase bruges lokal konto og lokal lagring i browseren. De lokale medarbejderkonti er beregnet til en enkelt installation og giver ikke serverhåndhævet sikkerhed.
- Økonomioversigtens resultat er beregnet ud fra gemte overslag minus registrerede udgifter; det er ikke et regnskab eller en skatteopgørelse.
- Historiske poster bør sikkerhedskopieres, før browserdata slettes.
