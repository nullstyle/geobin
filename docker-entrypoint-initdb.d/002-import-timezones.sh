#!/bin/bash
set -e

psql --username $POSTGRES_USER < /data/tz_world.sql

psql --username $POSTGRES_USER <<END_OF_SQL

  INSERT INTO geographies
  SELECT
    'Timezone' as type,
    tzid as id,
    geog
  FROM tz_world;

  DROP TABLE tz_world;
END_OF_SQL
