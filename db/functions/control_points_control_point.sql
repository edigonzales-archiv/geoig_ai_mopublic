CREATE OR REPLACE FUNCTION av_mopublic_export.fnsomefunc(numtimes integer, msg text)
  RETURNS text AS
$$
DECLARE
  strresult text;
BEGIN
  strresult := '';
  IF numtimes > 0 THEN
    FOR i IN 1 .. numtimes LOOP
      strresult := strresult || msg || E'\r\n';
    END LOOP;
  END IF;
  RETURN strresult;
END;
$$
LANGUAGE 'plpgsql';
