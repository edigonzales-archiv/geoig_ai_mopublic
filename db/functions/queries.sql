WITH bb AS (
SELECT a.tid, a.gem_bfs, a.art,
  CASE
    WHEN b.gueltigereintrag IS NULL THEN b.datum1
    ELSE b.gueltigereintrag
  END AS stand_am,
  CASE
    WHEN a.qualitaet IS NULL THEN 0
    ELSE a.qualitaet
  END AS qualitaet, a.geometrie
FROM av_avdpool_ch.bodenbedeckung_boflaeche a, av_avdpool_ch.bodenbedeckung_bbnachfuehrung b
WHERE a.gem_bfs = 2601
AND b.gem_bfs = 2601
AND a.entstehung = b.tid
), 

gebnr AS (
SELECT gebaeudenummer_von, gwr_egid, gem_bfs
FROM av_avdpool_ch.bodenbedeckung_gebaeudenummer
WHERE gem_bfs = 2601
),

-- Struktur und Inhalt lcsurface-Tabelle.
-- bb.tid ist eigentlich nicht notwendig. Aber es wird fuer das Herstellen der Relation 
-- der lcsurface_postext-Tabelle zur lcsurface-Tabelle verwendet.

-- *******Row_number ersetzen mit sequence

lc AS (
SELECT row_number() OVER (ORDER BY bb.tid) AS t_id, bb.tid, bb.qualitaet, bb.art, gebnr.gwr_egid,
       to_timestamp(bb.stand_am, 'YYYYMMDD')::timestamp without time zone  as stand_am,
       bb.gem_bfs, bb.geometrie
FROM bb LEFT JOIN gebnr ON bb.tid = gebnr.gebaeudenummer_von
), 

-- lcsurface_postext-Tabelle
-- lcpos.a.objektname_von = lc.bb.tid
lcpostext AS (
SELECT c.t_id, row_number() OVER (ORDER BY a.tid) AS t_id, a.objektname_von, 1::integer as typ, a.name,
       b.pos, b.ori,
       CASE 
         WHEN b.hali IS NULL
         THEN 1
         ELSE b.hali
       END as hali,
       CASE 
         WHEN b.vali IS NULL
         THEN 2
          ELSE b.vali
       END as vali,
       a.gem_bfs
FROM av_avdpool_ch.bodenbedeckung_objektname a, av_avdpool_ch.bodenbedeckung_objektnamepos b, lc c
WHERE a.gem_bfs = 2601
AND b.gem_bfs = 2601
AND a.tid = b.objektnamepos_von
AND a.objektname_von = c.tid
)

SELECT *
FROM lcpostext



/*
-- Nochmals CTE mit sequence t_id und alter tid
-- dann CTE mit pos_text
-- und anschliessend 2x insert into.
INSERT INTO av_mopublic_export.land_cover_lcsurface (t_id, quality, type, regbl_egid, state_of, fosnr, geometry)
SELECT row_number() OVER (ORDER BY bb.tid) AS t_id, bb.qualitaet as quality, bb.art as type, 
       gebnr.gwr_egid as regbl_egid, to_timestamp(bb.stand_am, 'YYYYMMDD')::timestamp without time zone  as state_of, 
       bb.gem_bfs as bfsnr, bb.geometrie as geometry
FROM bb LEFT JOIN gebnr ON bb.tid = gebnr.gebaeudenummer_von;





INSERT INTO av_mopublic_export.land_cover_lcsurface (t_id, quality, type, regbl_egid, state_of, fosnr, geometry)
SELECT row_number() OVER (ORDER BY bb.tid) AS t_id, bb.qualitaet as quality, bb.art as type, 
       gebnr.gwr_egid as regbl_egid, to_timestamp(bb.stand_am, 'YYYYMMDD')::timestamp without time zone  as state_of, 
       bb.gem_bfs as bfsnr, bb.geometrie as geometry
FROM bb LEFT JOIN gebnr ON bb.tid = gebnr.gebaeudenummer_von


SELECT *
FROM bb;


*/
