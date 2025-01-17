-- <=> NULL SAFE COMPARISON
-- Note: needs casts in some circumstances
CREATE OR REPLACE FUNCTION _null_safe_cmp(anyelement, anyelement)
RETURNS boolean AS '
  SELECT NOT ($1 IS DISTINCT FROM $2)
' IMMUTABLE LANGUAGE SQL;

CREATE OPERATOR <=> (
  PROCEDURE = _null_safe_cmp,
  LEFTARG = anyelement,
  RIGHTARG = anyelement
);

-- &&
-- XXX: MySQL version has wacky null behaviour 
CREATE FUNCTION _and(boolean, boolean)
RETURNS boolean AS $$
  SELECT $1 AND $2
$$ IMMUTABLE STRICT LANGUAGE SQL;

CREATE OPERATOR && (
  leftarg = boolean,
  rightarg = boolean,
  procedure = _and,
  commutator = &&
);

-- ||
-- XXX: MySQL version has wacky null behaviour 
-- This replaces the SQL standard || concatenation operator
CREATE FUNCTION _or(boolean, boolean)
RETURNS boolean AS $$
  SELECT $1 OR $2
$$ IMMUTABLE STRICT LANGUAGE SQL;

CREATE OPERATOR || (
  leftarg = boolean,
  rightarg = boolean,
  procedure = _or,
  commutator = || 
);

-- str + str
-- string concat
CREATE FUNCTION _str_concat(text, text)
RETURNS text AS $$
  SELECT $1 || $2
$$ IMMUTABLE STRICT LANGUAGE SQL;

CREATE OPERATOR + (
  leftarg = text,
  rightarg = text,
  procedure = _str_concat,
  commutator = +
);

