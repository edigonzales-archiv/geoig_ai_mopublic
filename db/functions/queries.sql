WITH lfp1 AS (
SELECT a.tid, 0 as kategorie, a.nbident, nummer, geometrie, lagegen, hoehegeom, hoehegen,
  CASE 
    WHEN a.punktzeichen IS NULL THEN 7
    ELSE a.punktzeichen
  END as punktzeichen, 
  CASE 
    WHEN b.gueltigereintrag IS NULL THEN b.datum1
    ELSE b.gueltigereintrag
  END AS stand_am,
a.gem_bfs as bfsnr
FROM av_avdpool_ch.fixpunktekategorie1_lfp1 as a, 
     av_avdpool_ch.fixpunktekategorie1_lfp1nachfuehrung as b
WHERE a.gem_bfs = 2601 
AND b.gem_bfs = 2601 
AND a.entstehung = b.tid
),
lfp2 AS (
SELECT a.tid, 2 as kategorie, a.nbident, nummer, geometrie, lagegen, hoehegeom, hoehegen,
  CASE 
    WHEN a.punktzeichen IS NULL THEN 7
    ELSE a.punktzeichen
  END as punktzeichen, 
  CASE 
    WHEN b.gueltigereintrag IS NULL THEN b.datum1
    ELSE b.gueltigereintrag
  END AS stand_am,
a.gem_bfs as bfsnr
FROM av_avdpool_ch.fixpunktekategorie2_lfp2 as a, 
     av_avdpool_ch.fixpunktekategorie2_lfp2nachfuehrung as b
WHERE a.gem_bfs = 2601 
AND b.gem_bfs = 2601 
AND a.entstehung = b.tid
),
lfp3 AS (
SELECT a.tid, 4 as kategorie, a.nbident, nummer, geometrie, lagegen, hoehegeom, hoehegen,
  CASE 
    WHEN a.punktzeichen IS NULL THEN 7
    ELSE a.punktzeichen
  END as punktzeichen, 
  CASE 
    WHEN b.gueltigereintrag IS NULL THEN b.datum1
    ELSE b.gueltigereintrag
  END AS stand_am,
a.gem_bfs as bfsnr
FROM av_avdpool_ch.fixpunktekategorie3_lfp3 as a, 
     av_avdpool_ch.fixpunktekategorie3_lfp3nachfuehrung as b
WHERE a.gem_bfs = 2601 
AND b.gem_bfs = 2601 
AND a.entstehung = b.tid
),
hfp1 AS (
SELECT a.tid, 1 as kategorie, a.nbident, nummer, geometrie, lagegen, hoehegeom, hoehegen, 8 as punktzeichen, 
  CASE 
    WHEN b.gueltigereintrag IS NULL THEN b.datum1
    ELSE b.gueltigereintrag
  END AS stand_am,
a.gem_bfs as bfsnr
FROM av_avdpool_ch.fixpunktekategorie1_hfp1 as a, 
     av_avdpool_ch.fixpunktekategorie1_hfp1nachfuehrung as b
WHERE a.gem_bfs = 2601 
AND b.gem_bfs = 2601 
AND a.entstehung = b.tid
),
hfp2 AS (
SELECT a.tid, 3 as kategorie, a.nbident, nummer, geometrie, lagegen, hoehegeom, hoehegen, 8 as punktzeichen, 
  CASE 
    WHEN b.gueltigereintrag IS NULL THEN b.datum1
    ELSE b.gueltigereintrag
  END AS stand_am,
a.gem_bfs as bfsnr
FROM av_avdpool_ch.fixpunktekategorie2_hfp2 as a, 
     av_avdpool_ch.fixpunktekategorie2_hfp2nachfuehrung as b
WHERE a.gem_bfs = 2601 
AND b.gem_bfs = 2601 
AND a.entstehung = b.tid
),
hfp3 AS (
SELECT a.tid, 5 as kategorie, a.nbident, nummer, geometrie, lagegen, hoehegeom, hoehegen, 8 as punktzeichen, 
  CASE 
    WHEN b.gueltigereintrag IS NULL THEN b.datum1
    ELSE b.gueltigereintrag
  END AS stand_am,
a.gem_bfs as bfsnr
FROM av_avdpool_ch.fixpunktekategorie3_hfp3 as a, 
     av_avdpool_ch.fixpunktekategorie3_hfp3nachfuehrung as b
WHERE a.gem_bfs = 2601 
AND b.gem_bfs = 2601 
AND a.entstehung = b.tid
)

INSERT INTO av_mopublic_export.control_points_control_point (t_id, category, identnd, anumber, plan_accuracy, geom_alt,
       alt_accuracy, mark, state_of, fosnr, geometry)
SELECT row_number() OVER (ORDER BY tid) AS t_id, kategorie as category, nbident as identnd, nummer as anumber, 
       lagegen as plan_accuracy, hoehegeom as geom_alt, hoehegen as alt_accuracy, punktzeichen as mark, to_timestamp(stand_am, 'YYYYMMDD') as state_of,
       bfsnr as fosnr, geometrie as geometry
FROM
(
 SELECT * FROM lfp1
 UNION ALL
 SELECT * FROM lfp2
 UNION ALL
 SELECT * FROM lfp3
 UNION ALL
 SELECT * FROM hfp1
 UNION ALL
 SELECT * FROM hfp2
 UNION ALL
 SELECT * FROM hfp3
) as foo

