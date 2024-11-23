CREATE TABLE sites (
       id BIGSERIAL NOT NULL PRIMARY KEY,
       name VARCHAR(255) UNIQUE
);

CREATE TABLE parameters (
       id BIGSERIAL NOT NULL PRIMARY KEY,
       name VARCHAR(255) UNIQUE
);

CREATE TABLE site_parameters (
       site_id BIGINT REFERENCES sites(id),
       parameter_id BIGINT REFERENCES parameters(id),
       UNIQUE(site_id, parameter_id)
);
