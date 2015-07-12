DELETE FROM av_mopublic.fixpunktekategorie__lfp WHERE bfsnr = ?;

INSERT INTO av_mopublic.fixpunktekategorie__lfp(tid, kategorie, nbident, nummer, geometrie, lagegen, hoehegeom, hoehegen, punktzeichen, stand_am, bfsnr)
--SELECT tid, b.designation_d as kategorie, nbident, nummer,  ST_SetSRID(ST_MakePoint(ST_X(geometrie), ST_Y(geometrie), hoehegeom), 21781) as geometrie, lagegen, hoehegeom, hoehegen, punktzeichen, to_date(a.stand_am, 'YYYYMMDD') as stand_am, bfsnr
SELECT tid, b.designation_d as kategorie, nbident, nummer,
CASE WHEN hoehegeom IS NULL
THEN
  ST_SetSRID(ST_Force_3d(ST_PointFromText('POINT(' || ST_X(geometrie) || ' ' || ST_Y(geometrie) || ')')), 21781)
ELSE
  ST_SetSRID(ST_Force_3d(ST_MakePoint(ST_X(geometrie), ST_Y(geometrie), hoehegeom)), 21781)
END as geometrie,
lagegen, hoehegeom, hoehegen, punktzeichen, to_date(a.stand_am, 'YYYYMMDD') as stand_am, bfsnr
FROM
(
  SELECT a.tid, 0 as kategorie, a.nbident, nummer, geometrie, lagegen, hoehegeom, hoehegen, b.designation_d as punktzeichen,
    CASE
      WHEN c.gueltigereintrag IS NULL THEN c.datum1
      ELSE c.gueltigereintrag
    END AS stand_am,
  a.gem_bfs as bfsnr
  FROM av_avdpool_ch.fixpunktekategorie1_lfp1 as a, av_mopublic_meta.mark_type as b, av_avdpool_ch.fixpunktekategorie1_lfp1nachfuehrung as c
  WHERE a.gem_bfs = ?
  AND c.gem_bfs = ?
  AND a.entstehung = c.tid
  AND a.punktzeichen = b.code
UNION ALL
  SELECT a.tid, 1 as kategorie, a.nbident, nummer, geometrie, lagegen, hoehegeom, hoehegen, b.designation_d as punktzeichen,
    CASE
      WHEN c.gueltigereintrag IS NULL THEN c.datum1
      ELSE c.gueltigereintrag
    END AS stand_am,
  a.gem_bfs as bfsnr
  FROM av_avdpool_ch.fixpunktekategorie1_hfp1 as a, av_mopublic_meta.mark_type as b, av_avdpool_ch.fixpunktekategorie1_hfp1nachfuehrung as c
  WHERE a.gem_bfs = ?
  AND c.gem_bfs = ?
  AND a.entstehung = c.tid
  AND 8 = b.code
UNION ALL
  SELECT a.tid, 2 as kategorie, a.nbident, nummer, geometrie, lagegen, hoehegeom, hoehegen, b.designation_d as punktzeichen,
    CASE
      WHEN c.gueltigereintrag IS NULL THEN c.datum1
      ELSE c.gueltigereintrag
    END AS stand_am,
  a.gem_bfs as bfsnr
  FROM av_avdpool_ch.fixpunktekategorie2_lfp2 as a, av_mopublic_meta.mark_type as b, av_avdpool_ch.fixpunktekategorie2_lfp2nachfuehrung as c
  WHERE a.gem_bfs = ?
  AND c.gem_bfs = ?
  AND a.entstehung = c.tid
  AND a.punktzeichen = b.code
UNION ALL
  SELECT a.tid, 3 as kategorie, a.nbident, nummer, geometrie, lagegen, hoehegeom, hoehegen, b.designation_d as punktzeichen,
    CASE
      WHEN c.gueltigereintrag IS NULL THEN c.datum1
      ELSE c.gueltigereintrag
    END AS stand_am,
  a.gem_bfs as bfsnr
  FROM av_avdpool_ch.fixpunktekategorie2_hfp2 as a, av_mopublic_meta.mark_type as b, av_avdpool_ch.fixpunktekategorie2_hfp2nachfuehrung as c
  WHERE a.gem_bfs = ?
  AND c.gem_bfs = ?
  AND a.entstehung = c.tid
  AND 8 = b.code
UNION ALL
  SELECT a.tid, 4 as kategorie, a.nbident, nummer, geometrie, lagegen, hoehegeom, hoehegen, b.designation_d as punktzeichen,
    CASE
      WHEN c.gueltigereintrag IS NULL THEN c.datum1
      ELSE c.gueltigereintrag
    END AS stand_am,
  a.gem_bfs as bfsnr
  FROM av_avdpool_ch.fixpunktekategorie3_lfp3 as a, av_mopublic_meta.mark_type as b, av_avdpool_ch.fixpunktekategorie3_lfp3nachfuehrung as c
  WHERE a.gem_bfs = ?
  AND c.gem_bfs = ?
  AND a.entstehung = c.tid
  AND a.punktzeichen = b.code
UNION ALL
  SELECT a.tid, 5 as kategorie, a.nbident, nummer, geometrie, lagegen, hoehegeom, hoehegen, b.designation_d as punktzeichen,
    CASE
      WHEN c.gueltigereintrag IS NULL THEN c.datum1
      ELSE c.gueltigereintrag
    END AS stand_am,
  a.gem_bfs as bfsnr
  FROM av_avdpool_ch.fixpunktekategorie3_hfp3 as a, av_mopublic_meta.mark_type as b, av_avdpool_ch.fixpunktekategorie3_hfp3nachfuehrung as c
  WHERE a.gem_bfs = ?
  AND c.gem_bfs = ?
  AND a.entstehung = c.tid
  AND 8 = b.code
) as a, av_mopublic_meta.control_point_category as b
WHERE a.kategorie = b.code;
