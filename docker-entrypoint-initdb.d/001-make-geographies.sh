#!/bin/bash
set -e

psql --username $POSTGRES_USER <<END_OF_SQL
  CREATE EXTENSION postgis;

  CREATE UNLOGGED TABLE geographies (
    type  varchar(255)            NOT NULL,
    id    varchar(255)            NOT NULL,
    geog  geography(Polygon,4326) NOT NULL
  );

  CREATE INDEX type_id_idx ON geographies (type, id);
  CREATE INDEX geog_idx ON geographies USING gist (geog);

END_OF_SQL
