SELECT g.*, h.gwr_egid
FROM
(
 SELECT b.tid, b.geometrie as geometrie, d.designation_d as qualitaetsstandard, c.designation_d AS art, to_date(b.stand_am, 'YYYYMMDD') as stand_am, b.gem_bfs AS bfsnr
 FROM av_mopublic_meta.qualitystandard_type d, av_mopublic_meta.lcs_type c,
 (
  SELECT a.tid, a.gem_bfs, a.art,
                CASE
                    WHEN b.gueltigereintrag IS NULL THEN b.datum1
		    ELSE b.gueltigereintrag
                END AS stand_am,
                CASE
                    WHEN qualitaet IS NULL THEN 0
                    ELSE qualitaet
                END AS qualitaet, geometrie
  FROM av_avdpool_ch.bodenbedeckung_boflaeche a, av_avdpool_ch.bodenbedeckung_bbnachfuehrung b
  WHERE a.gem_bfs = ?
  AND b.gem_bfs = ?
  AND a.entstehung = b.tid
 ) b
 WHERE b.art::double precision = c.code AND b.qualitaet::double precision = d.code
) as g
LEFT JOIN
(
 SELECT *
 FROM av_avdpool_ch.bodenbedeckung_gebaeudenummer
 WHERE gem_bfs = ?
) as h ON h.gebaeudenummer_von = g.tid;



SELECT a.tid, a.objektname_von as bbtext_von, c.designation_e AS typ, a.name AS nummer_name, b.pos, b.ori,
 CASE WHEN b.hali IS NULL
  THEN 1
  ELSE b.hali
 END as hali,
 CASE WHEN b.vali IS NULL
  THEN 2
  ELSE b.vali
 END as vali,
 a.gem_bfs AS bfsnr, ST_X(b.pos) AS y, ST_Y(b.pos) AS x, (100::double precision - b.ori) * 0.9::double precision AS rot,
 CASE WHEN b.hali_txt IS NULL
  THEN 'Center'
  ELSE b.hali_txt
 END as hali_txt,
 CASE WHEN b.vali_txt IS NULL
  THEN 'Half'
  ELSE b.vali_txt
 END as vali_txt
FROM av_avdpool_ch.bodenbedeckung_objektname a, av_avdpool_ch.bodenbedeckung_objektnamepos b, av_mopublic_meta.text_type c
WHERE a.gem_bfs = ? AND b.gem_bfs = ? AND a.tid::text = b.objektnamepos_von::text AND 1::double precision = c.code;
