--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.9
-- Dumped by pg_dump version 9.5.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: access_rights; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE access_rights (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    token_id integer NOT NULL,
    "right" text NOT NULL,
    camera_id integer,
    grantor_id integer,
    status integer DEFAULT 1 NOT NULL,
    snapshot_id integer,
    account_id integer,
    scope character varying(100)
);


--
-- Name: access_rights_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE access_rights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_rights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE access_rights_id_seq OWNED BY access_rights.id;


--
-- Name: sq_access_tokens; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_access_tokens
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE access_tokens (
    id integer DEFAULT nextval('sq_access_tokens'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_revoked boolean NOT NULL,
    user_id integer,
    client_id integer,
    request text NOT NULL,
    refresh text,
    grantor_id integer
);


--
-- Name: add_ons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE add_ons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: add_ons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE add_ons (
    id integer DEFAULT nextval('add_ons_id_seq'::regclass) NOT NULL,
    user_id integer NOT NULL,
    add_ons_name text NOT NULL,
    period text NOT NULL,
    add_ons_start_date timestamp with time zone NOT NULL,
    add_ons_end_date timestamp with time zone NOT NULL,
    status boolean NOT NULL,
    price double precision NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    exid text NOT NULL,
    invoice_item_id text NOT NULL
);


--
-- Name: apps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE apps (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    local_recording boolean DEFAULT false NOT NULL,
    cloud_recording boolean DEFAULT false NOT NULL,
    motion_detection boolean DEFAULT false NOT NULL,
    watermark boolean DEFAULT false NOT NULL
);


--
-- Name: apps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE apps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: apps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE apps_id_seq OWNED BY apps.id;


--
-- Name: archives; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE archives (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    exid text NOT NULL,
    title text NOT NULL,
    from_date timestamp with time zone NOT NULL,
    to_date timestamp with time zone NOT NULL,
    status integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    requested_by integer NOT NULL,
    embed_time boolean,
    public boolean,
    frames integer DEFAULT 0
);


--
-- Name: archive_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE archive_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: archive_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE archive_id_seq OWNED BY archives.id;


--
-- Name: billing; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE billing (
    id integer NOT NULL,
    user_id integer NOT NULL,
    timelapse integer,
    snapmail integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: billing_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE billing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: billing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE billing_id_seq OWNED BY billing.id;


--
-- Name: camera_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE camera_activities (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    access_token_id integer,
    action text NOT NULL,
    done_at timestamp with time zone NOT NULL,
    ip inet,
    extra json,
    camera_exid text,
    name text
);


--
-- Name: camera_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE camera_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: camera_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE camera_activities_id_seq OWNED BY camera_activities.id;


--
-- Name: camera_endpoints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE camera_endpoints (
    id integer NOT NULL,
    camera_id integer,
    scheme text NOT NULL,
    host text NOT NULL,
    port integer NOT NULL
);


--
-- Name: camera_endpoints_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE camera_endpoints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: camera_endpoints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE camera_endpoints_id_seq OWNED BY camera_endpoints.id;


--
-- Name: camera_share_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE camera_share_requests (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    user_id integer NOT NULL,
    key character varying(100) NOT NULL,
    email character varying(250) NOT NULL,
    status integer NOT NULL,
    rights character varying(1000) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    message text
);


--
-- Name: camera_share_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE camera_share_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: camera_share_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE camera_share_requests_id_seq OWNED BY camera_share_requests.id;


--
-- Name: camera_shares; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE camera_shares (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    user_id integer NOT NULL,
    sharer_id integer,
    kind character varying(50) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    message text
);


--
-- Name: camera_shares_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE camera_shares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: camera_shares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE camera_shares_id_seq OWNED BY camera_shares.id;


--
-- Name: sq_streams; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_streams
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cameras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cameras (
    id integer DEFAULT nextval('sq_streams'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    exid text NOT NULL,
    owner_id integer NOT NULL,
    is_public boolean NOT NULL,
    config json NOT NULL,
    name text NOT NULL,
    last_polled_at timestamp with time zone DEFAULT now(),
    is_online boolean,
    timezone text,
    last_online_at timestamp with time zone DEFAULT now(),
    location geography(Point,4326),
    mac_address macaddr,
    model_id integer,
    discoverable boolean DEFAULT false NOT NULL,
    thumbnail_url text,
    is_online_email_owner_notification boolean DEFAULT false NOT NULL
);


--
-- Name: sq_clients; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_clients
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE clients (
    id integer DEFAULT nextval('sq_clients'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    api_id text NOT NULL,
    callback_uris text[],
    api_key text,
    name text,
    settings text
);


--
-- Name: cloud_recordings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cloud_recordings (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    frequency integer NOT NULL,
    storage_duration integer NOT NULL,
    schedule json,
    status text
);


--
-- Name: cloud_recordings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cloud_recordings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cloud_recordings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cloud_recordings_id_seq OWNED BY cloud_recordings.id;


--
-- Name: sq_countries; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_countries
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE countries (
    id integer DEFAULT nextval('sq_countries'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    iso3166_a2 text NOT NULL,
    name text NOT NULL
);


--
-- Name: licences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE licences (
    id integer NOT NULL,
    user_id integer NOT NULL,
    description text NOT NULL,
    total_cameras integer NOT NULL,
    storage integer NOT NULL,
    amount double precision,
    paid boolean DEFAULT false NOT NULL,
    vat boolean DEFAULT false NOT NULL,
    vat_number integer,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    cancel_licence boolean DEFAULT false NOT NULL,
    subscription_id text,
    auto_renew boolean DEFAULT false NOT NULL,
    auto_renew_at timestamp with time zone
);


--
-- Name: licences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE licences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: licences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE licences_id_seq OWNED BY licences.id;


--
-- Name: motion_detections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE motion_detections (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    frequency integer,
    "minPosition" integer,
    step integer,
    min integer,
    threshold integer,
    schedule json,
    enabled boolean DEFAULT false,
    alert_email boolean DEFAULT false,
    alert_interval_min integer,
    sensitivity integer,
    x1 integer,
    y1 integer,
    x2 integer,
    y2 integer,
    emails text[]
);


--
-- Name: motion_detections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE motion_detections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: motion_detections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE motion_detections_id_seq OWNED BY motion_detections.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


--
-- Name: snapshot_counts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE snapshot_counts (
    count_id text NOT NULL,
    count integer
);


--
-- Name: snapshot_extractors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE snapshot_extractors (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    from_date timestamp with time zone NOT NULL,
    to_date timestamp with time zone NOT NULL,
    "interval" integer NOT NULL,
    schedule json NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    notes text,
    created_at timestamp with time zone NOT NULL,
    update_at timestamp with time zone
);


--
-- Name: snapshot_extractors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE snapshot_extractors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snapshot_extractors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE snapshot_extractors_id_seq OWNED BY snapshot_extractors.id;


--
-- Name: snapshot_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE snapshot_reports (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    report_date timestamp with time zone NOT NULL,
    snapshot_count integer NOT NULL
);


--
-- Name: snapshot_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE snapshot_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snapshot_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE snapshot_reports_id_seq OWNED BY snapshot_reports.id;


--
-- Name: snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE snapshots (
    snapshot_id text NOT NULL,
    camera_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    notes text,
    is_public boolean DEFAULT false,
    motionlevel integer
);


--
-- Name: sq_access_tokens_streams_rights; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_access_tokens_streams_rights
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sq_devices; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_devices
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sq_firmwares; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_firmwares
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sq_users; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_users
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sq_vendors; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_vendors
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer DEFAULT nextval('sq_users'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    firstname text NOT NULL,
    lastname text NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    country_id integer,
    confirmed_at timestamp with time zone,
    email text NOT NULL,
    reset_token text,
    token_expires_at timestamp without time zone,
    api_id text,
    api_key text,
    stripe_customer_id text,
    last_login_at timestamp with time zone,
    vat_number text,
    payment_method integer DEFAULT 0,
    insight_id text
);


--
-- Name: vendor_models; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE vendor_models (
    id integer DEFAULT nextval('sq_firmwares'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    vendor_id integer NOT NULL,
    name text NOT NULL,
    config json NOT NULL,
    exid text DEFAULT ''::text NOT NULL,
    jpg_url text DEFAULT ''::text NOT NULL,
    h264_url text DEFAULT ''::text NOT NULL,
    mjpg_url text DEFAULT ''::text NOT NULL,
    shape text DEFAULT ''::text,
    resolution text DEFAULT ''::text,
    official_url text DEFAULT ''::text,
    audio_url text DEFAULT ''::text,
    more_info text DEFAULT ''::text,
    poe boolean DEFAULT false NOT NULL,
    wifi boolean DEFAULT false NOT NULL,
    onvif boolean DEFAULT false NOT NULL,
    psia boolean DEFAULT false NOT NULL,
    ptz boolean DEFAULT false NOT NULL,
    infrared boolean DEFAULT false NOT NULL,
    varifocal boolean DEFAULT false NOT NULL,
    sd_card boolean DEFAULT false NOT NULL,
    upnp boolean DEFAULT false NOT NULL,
    audio_io boolean DEFAULT false NOT NULL,
    discontinued boolean DEFAULT false NOT NULL,
    username text,
    password text
);


--
-- Name: vendors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE vendors (
    id integer DEFAULT nextval('sq_vendors'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    exid text NOT NULL,
    known_macs text[] NOT NULL,
    name text NOT NULL
);


--
-- Name: webhooks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE webhooks (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    user_id integer NOT NULL,
    url text NOT NULL,
    exid text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE webhooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE webhooks_id_seq OWNED BY webhooks.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_rights ALTER COLUMN id SET DEFAULT nextval('access_rights_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY apps ALTER COLUMN id SET DEFAULT nextval('apps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY archives ALTER COLUMN id SET DEFAULT nextval('archive_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY billing ALTER COLUMN id SET DEFAULT nextval('billing_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY camera_activities ALTER COLUMN id SET DEFAULT nextval('camera_activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY camera_endpoints ALTER COLUMN id SET DEFAULT nextval('camera_endpoints_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY camera_share_requests ALTER COLUMN id SET DEFAULT nextval('camera_share_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY camera_shares ALTER COLUMN id SET DEFAULT nextval('camera_shares_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cloud_recordings ALTER COLUMN id SET DEFAULT nextval('cloud_recordings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY licences ALTER COLUMN id SET DEFAULT nextval('licences_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY motion_detections ALTER COLUMN id SET DEFAULT nextval('motion_detections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapshot_extractors ALTER COLUMN id SET DEFAULT nextval('snapshot_extractors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapshot_reports ALTER COLUMN id SET DEFAULT nextval('snapshot_reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY webhooks ALTER COLUMN id SET DEFAULT nextval('webhooks_id_seq'::regclass);


--
-- Name: access_rights_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_rights
    ADD CONSTRAINT access_rights_pkey PRIMARY KEY (id);


--
-- Name: add_ons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY add_ons
    ADD CONSTRAINT add_ons_pkey PRIMARY KEY (id);


--
-- Name: apps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY apps
    ADD CONSTRAINT apps_pkey PRIMARY KEY (id);


--
-- Name: archives_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY archives
    ADD CONSTRAINT archives_pkey PRIMARY KEY (id);


--
-- Name: billing_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY billing
    ADD CONSTRAINT billing_pkey PRIMARY KEY (id);


--
-- Name: camera_endpoints_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY camera_endpoints
    ADD CONSTRAINT camera_endpoints_pkey PRIMARY KEY (id);


--
-- Name: camera_share_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY camera_share_requests
    ADD CONSTRAINT camera_share_requests_pkey PRIMARY KEY (id);


--
-- Name: camera_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY camera_shares
    ADD CONSTRAINT camera_shares_pkey PRIMARY KEY (id);


--
-- Name: cloud_recordings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cloud_recordings
    ADD CONSTRAINT cloud_recordings_pkey PRIMARY KEY (id);


--
-- Name: licences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY licences
    ADD CONSTRAINT licences_pkey PRIMARY KEY (id);


--
-- Name: motion_detections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY motion_detections
    ADD CONSTRAINT motion_detections_pkey PRIMARY KEY (id);


--
-- Name: pk_access_tokens; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_tokens
    ADD CONSTRAINT pk_access_tokens PRIMARY KEY (id);


--
-- Name: pk_clients; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clients
    ADD CONSTRAINT pk_clients PRIMARY KEY (id);


--
-- Name: pk_countries; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT pk_countries PRIMARY KEY (id);


--
-- Name: pk_firmwares; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vendor_models
    ADD CONSTRAINT pk_firmwares PRIMARY KEY (id);


--
-- Name: pk_streams; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cameras
    ADD CONSTRAINT pk_streams PRIMARY KEY (id);


--
-- Name: pk_users; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT pk_users PRIMARY KEY (id);


--
-- Name: pk_vendors; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vendors
    ADD CONSTRAINT pk_vendors PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: snapshot_counts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapshot_counts
    ADD CONSTRAINT snapshot_counts_pkey PRIMARY KEY (count_id);


--
-- Name: snapshot_extractors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapshot_extractors
    ADD CONSTRAINT snapshot_extractors_pkey PRIMARY KEY (id);


--
-- Name: snapshot_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapshot_reports
    ADD CONSTRAINT snapshot_reports_pkey PRIMARY KEY (id);


--
-- Name: snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapshots
    ADD CONSTRAINT snapshots_pkey PRIMARY KEY (snapshot_id);


--
-- Name: webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY webhooks
    ADD CONSTRAINT webhooks_pkey PRIMARY KEY (id);


--
-- Name: access_rights_camera_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX access_rights_camera_id_index ON access_rights USING btree (camera_id);


--
-- Name: access_rights_token_id_camera_id_right_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX access_rights_token_id_camera_id_right_index ON access_rights USING btree (token_id, camera_id, "right");


--
-- Name: access_rights_token_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX access_rights_token_id_index ON access_rights USING btree (token_id);


--
-- Name: camera_activities_camera_id_done_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX camera_activities_camera_id_done_at_index ON camera_activities USING btree (camera_id, done_at);


--
-- Name: camera_endpoints_camera_id_scheme_host_port_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX camera_endpoints_camera_id_scheme_host_port_index ON camera_endpoints USING btree (camera_id, scheme, host, port);


--
-- Name: camera_share_requests_camera_id_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX camera_share_requests_camera_id_email_index ON camera_share_requests USING btree (camera_id, email);


--
-- Name: camera_share_requests_key_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX camera_share_requests_key_index ON camera_share_requests USING btree (key);


--
-- Name: camera_shares_camera_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX camera_shares_camera_id_index ON camera_shares USING btree (camera_id);


--
-- Name: camera_shares_camera_id_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX camera_shares_camera_id_user_id_index ON camera_shares USING btree (camera_id, user_id);


--
-- Name: camera_shares_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX camera_shares_user_id_index ON camera_shares USING btree (user_id);


--
-- Name: cameras_exid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX cameras_exid_index ON cameras USING btree (exid);


--
-- Name: cameras_mac_address_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cameras_mac_address_index ON cameras USING btree (mac_address);


--
-- Name: cloud_recordings_camera_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX cloud_recordings_camera_id_index ON cloud_recordings USING btree (camera_id);


--
-- Name: country_code_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX country_code_unique_index ON countries USING btree (iso3166_a2);


--
-- Name: ix_access_tokens_grantee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_access_tokens_grantee_id ON access_tokens USING btree (client_id);


--
-- Name: ix_access_tokens_grantor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_access_tokens_grantor_id ON access_tokens USING btree (user_id);


--
-- Name: ix_firmwares_vendor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_firmwares_vendor_id ON vendor_models USING btree (vendor_id);


--
-- Name: ix_streams_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_streams_owner_id ON cameras USING btree (owner_id);


--
-- Name: ix_users_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_users_country_id ON users USING btree (country_id);


--
-- Name: snapshot_reports_report_date_camera_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX snapshot_reports_report_date_camera_id_index ON snapshot_reports USING btree (report_date, camera_id);


--
-- Name: user_email_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX user_email_unique_index ON users USING btree (email);


--
-- Name: user_username_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX user_username_unique_index ON users USING btree (username);


--
-- Name: licences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY licences
    ADD CONSTRAINT licences_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: snapshot_extractors_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapshot_extractors
    ADD CONSTRAINT snapshot_extractors_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES cameras(id);


--
-- Name: snapshot_reports_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapshot_reports
    ADD CONSTRAINT snapshot_reports_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES cameras(id);


--
-- Name: snapshots_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapshots
    ADD CONSTRAINT snapshots_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES cameras(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO "schema_migrations" (version) VALUES (20160616160229), (20160712101523), (20160720125939), (20160727112052), (20160830055709);

