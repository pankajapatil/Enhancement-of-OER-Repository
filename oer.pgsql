--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.13
-- Dumped by pg_dump version 9.5.13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: plpythonu; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: dspace
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpythonu;


ALTER PROCEDURAL LANGUAGE plpythonu OWNER TO dspace;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: export(); Type: FUNCTION; Schema: public; Owner: dspace
--

CREATE FUNCTION public.export() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE

BEGIN

copy(select dspace_object_id,text_value from metadatavalue where metadata_field_id = 63) to '/home/abc/Downloads/postgre/metadata.csv';perform model();
return null;
END
$$;


ALTER FUNCTION public.export() OWNER TO dspace;

--
-- Name: export_handle(); Type: FUNCTION; Schema: public; Owner: dspace
--

CREATE FUNCTION public.export_handle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE

BEGIN

    copy (select handle,resource_id from handle where resource_id IS NOT NULL) to '/home/abc/Downloads/postgre/handle.csv';return null;

END
$$;


ALTER FUNCTION public.export_handle() OWNER TO dspace;

--
-- Name: getnextid(character varying); Type: FUNCTION; Schema: public; Owner: dspace
--

CREATE FUNCTION public.getnextid(character varying) RETURNS integer
    LANGUAGE sql
    AS $_$SELECT CAST (nextval($1 || '_seq') AS INTEGER) AS RESULT;$_$;


ALTER FUNCTION public.getnextid(character varying) OWNER TO dspace;

--
-- Name: helloworld(); Type: FUNCTION; Schema: public; Owner: dspace
--

CREATE FUNCTION public.helloworld() RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
copy (select *from metadatavalue where metadata_field_id = 63) to '/home/abc/Downloads/postgre/metadata.csv';
end
$$;


ALTER FUNCTION public.helloworld() OWNER TO dspace;

--
-- Name: model(); Type: FUNCTION; Schema: public; Owner: dspace
--

CREATE FUNCTION public.model() RETURNS void
    LANGUAGE plpythonu
    AS $$
import subprocess
subprocess.call(['/usr/bin/python', '/home/abc/Downloads/postgre/model.py'])
$$;


ALTER FUNCTION public.model() OWNER TO dspace;

--
-- Name: pyth(); Type: FUNCTION; Schema: public; Owner: dspace
--

CREATE FUNCTION public.pyth() RETURNS trigger
    LANGUAGE plpythonu
    AS $$7
import subprocess
subprocess.call(['/usr/bin/python', '/home/prasad/Downloads/postgre/trig.py'])
$$;


ALTER FUNCTION public.pyth() OWNER TO dspace;

--
-- Name: recommend1(character varying); Type: FUNCTION; Schema: public; Owner: dspace
--

CREATE FUNCTION public.recommend1(username character varying) RETURNS integer
    LANGUAGE plpythonu
    AS $$
 import subprocess
 subprocess.call(['/usr/bin/python', '/home/dspace/Downloads/postgre/recommender.py',username])
$$;


ALTER FUNCTION public.recommend1(username character varying) OWNER TO dspace;

--
-- Name: test(); Type: FUNCTION; Schema: public; Owner: dspace
--

CREATE FUNCTION public.test() RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
perform * from metadatavalue where metadata_field_id = 63;
end
$$;


ALTER FUNCTION public.test() OWNER TO dspace;

--
-- Name: test1(); Type: FUNCTION; Schema: public; Owner: dspace
--

CREATE FUNCTION public.test1() RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
perform * from metadatavalue where metadata_field_id = 63;
end
$$;


ALTER FUNCTION public.test1() OWNER TO dspace;

--
-- Name: test2(); Type: FUNCTION; Schema: public; Owner: dspace
--

CREATE FUNCTION public.test2() RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
perform * from metadatavalue where metadata_field_id = 63;   return 10;   end
$$;


ALTER FUNCTION public.test2() OWNER TO dspace;

--
-- Name: wordcloud(); Type: FUNCTION; Schema: public; Owner: dspace
--

CREATE FUNCTION public.wordcloud() RETURNS integer
    LANGUAGE plpythonu
    AS $$
 import subprocess
 subprocess.call(['/usr/bin/python', '/home/dspace/Downloads/postgre/wordcloud.py'])
$$;


ALTER FUNCTION public.wordcloud() OWNER TO dspace;

--
-- Name: wordcloud(character varying); Type: FUNCTION; Schema: public; Owner: dspace
--

CREATE FUNCTION public.wordcloud(username character varying) RETURNS integer
    LANGUAGE plpythonu
    AS $$
 import subprocess
 subprocess.call(['/usr/bin/python', '/home/abc/Downloads/postgre/wordcloud.py',username])
$$;


ALTER FUNCTION public.wordcloud(username character varying) OWNER TO dspace;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bitstream; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.bitstream (
    bitstream_id integer,
    bitstream_format_id integer,
    checksum character varying(64),
    checksum_algorithm character varying(32),
    internal_id character varying(256),
    deleted boolean,
    store_number integer,
    sequence_id integer,
    size_bytes bigint,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL
);


ALTER TABLE public.bitstream OWNER TO dspace;

--
-- Name: bitstreamformatregistry; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.bitstreamformatregistry (
    bitstream_format_id integer NOT NULL,
    mimetype character varying(256),
    short_description character varying(128),
    description text,
    support_level integer,
    internal boolean
);


ALTER TABLE public.bitstreamformatregistry OWNER TO dspace;

--
-- Name: bitstreamformatregistry_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.bitstreamformatregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bitstreamformatregistry_seq OWNER TO dspace;

--
-- Name: bundle; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.bundle (
    bundle_id integer,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    primary_bitstream_id uuid
);


ALTER TABLE public.bundle OWNER TO dspace;

--
-- Name: bundle2bitstream; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.bundle2bitstream (
    bitstream_order_legacy integer,
    bundle_id uuid NOT NULL,
    bitstream_id uuid NOT NULL,
    bitstream_order integer NOT NULL
);


ALTER TABLE public.bundle2bitstream OWNER TO dspace;

--
-- Name: checksum_history; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.checksum_history (
    check_id bigint NOT NULL,
    process_start_date timestamp without time zone,
    process_end_date timestamp without time zone,
    checksum_expected character varying,
    checksum_calculated character varying,
    result character varying,
    bitstream_id uuid
);


ALTER TABLE public.checksum_history OWNER TO dspace;

--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.checksum_history_check_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.checksum_history_check_id_seq OWNER TO dspace;

--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dspace
--

ALTER SEQUENCE public.checksum_history_check_id_seq OWNED BY public.checksum_history.check_id;


--
-- Name: checksum_results; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.checksum_results (
    result_code character varying NOT NULL,
    result_description character varying
);


ALTER TABLE public.checksum_results OWNER TO dspace;

--
-- Name: collection; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.collection (
    collection_id integer,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    workflow_step_1 uuid,
    workflow_step_2 uuid,
    workflow_step_3 uuid,
    submitter uuid,
    template_item_id uuid,
    logo_bitstream_id uuid,
    admin uuid
);


ALTER TABLE public.collection OWNER TO dspace;

--
-- Name: collection2item; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.collection2item (
    collection_id uuid NOT NULL,
    item_id uuid NOT NULL
);


ALTER TABLE public.collection2item OWNER TO dspace;

--
-- Name: community; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.community (
    community_id integer,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    admin uuid,
    logo_bitstream_id uuid
);


ALTER TABLE public.community OWNER TO dspace;

--
-- Name: community2collection; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.community2collection (
    collection_id uuid NOT NULL,
    community_id uuid NOT NULL
);


ALTER TABLE public.community2collection OWNER TO dspace;

--
-- Name: community2community; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.community2community (
    parent_comm_id uuid NOT NULL,
    child_comm_id uuid NOT NULL
);


ALTER TABLE public.community2community OWNER TO dspace;

--
-- Name: course; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.course (
    uuid uuid,
    euuid uuid,
    cuuid uuid
);


ALTER TABLE public.course OWNER TO dspace;

--
-- Name: course_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.course_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.course_seq OWNER TO dspace;

--
-- Name: courses; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.courses (
    euuid uuid,
    cuuid uuid
);


ALTER TABLE public.courses OWNER TO dspace;

--
-- Name: doi; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.doi (
    doi_id integer NOT NULL,
    doi character varying(256),
    resource_type_id integer,
    resource_id integer,
    status integer,
    dspace_object uuid
);


ALTER TABLE public.doi OWNER TO dspace;

--
-- Name: doi_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.doi_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doi_seq OWNER TO dspace;

--
-- Name: dspaceobject; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.dspaceobject (
    uuid uuid NOT NULL
);


ALTER TABLE public.dspaceobject OWNER TO dspace;

--
-- Name: eperson; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.eperson (
    eperson_id integer,
    email character varying(64),
    password character varying(128),
    can_log_in boolean,
    require_certificate boolean,
    self_registered boolean,
    last_active timestamp without time zone,
    sub_frequency integer,
    netid character varying(64),
    salt character varying(32),
    digest_algorithm character varying(16),
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL
);


ALTER TABLE public.eperson OWNER TO dspace;

--
-- Name: epersongroup; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.epersongroup (
    eperson_group_id integer,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    permanent boolean DEFAULT false,
    name character varying(250)
);


ALTER TABLE public.epersongroup OWNER TO dspace;

--
-- Name: epersongroup2eperson; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.epersongroup2eperson (
    eperson_group_id uuid NOT NULL,
    eperson_id uuid NOT NULL
);


ALTER TABLE public.epersongroup2eperson OWNER TO dspace;

--
-- Name: epersongroup2workspaceitem; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.epersongroup2workspaceitem (
    workspace_item_id integer NOT NULL,
    eperson_group_id uuid NOT NULL
);


ALTER TABLE public.epersongroup2workspaceitem OWNER TO dspace;

--
-- Name: fileextension; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.fileextension (
    file_extension_id integer NOT NULL,
    bitstream_format_id integer,
    extension character varying(16)
);


ALTER TABLE public.fileextension OWNER TO dspace;

--
-- Name: fileextension_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.fileextension_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fileextension_seq OWNER TO dspace;

--
-- Name: group2group; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.group2group (
    parent_id uuid NOT NULL,
    child_id uuid NOT NULL
);


ALTER TABLE public.group2group OWNER TO dspace;

--
-- Name: group2groupcache; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.group2groupcache (
    parent_id uuid NOT NULL,
    child_id uuid NOT NULL
);


ALTER TABLE public.group2groupcache OWNER TO dspace;

--
-- Name: handle; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.handle (
    handle_id integer NOT NULL,
    handle character varying(256),
    resource_type_id integer,
    resource_legacy_id integer,
    resource_id uuid
);


ALTER TABLE public.handle OWNER TO dspace;

--
-- Name: handle_id_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.handle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.handle_id_seq OWNER TO dspace;

--
-- Name: handle_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.handle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.handle_seq OWNER TO dspace;

--
-- Name: harvested_collection; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.harvested_collection (
    harvest_type integer,
    oai_source character varying,
    oai_set_id character varying,
    harvest_message character varying,
    metadata_config_id character varying,
    harvest_status integer,
    harvest_start_time timestamp with time zone,
    last_harvested timestamp with time zone,
    id integer NOT NULL,
    collection_id uuid
);


ALTER TABLE public.harvested_collection OWNER TO dspace;

--
-- Name: harvested_collection_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.harvested_collection_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.harvested_collection_seq OWNER TO dspace;

--
-- Name: harvested_item; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.harvested_item (
    last_harvested timestamp with time zone,
    oai_id character varying,
    id integer NOT NULL,
    item_id uuid
);


ALTER TABLE public.harvested_item OWNER TO dspace;

--
-- Name: harvested_item_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.harvested_item_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.harvested_item_seq OWNER TO dspace;

--
-- Name: history_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.history_seq OWNER TO dspace;

--
-- Name: item; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.item (
    item_id integer,
    in_archive boolean,
    withdrawn boolean,
    last_modified timestamp with time zone,
    discoverable boolean,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    submitter_id uuid,
    owning_collection uuid
);


ALTER TABLE public.item OWNER TO dspace;

--
-- Name: item2bundle; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.item2bundle (
    bundle_id uuid NOT NULL,
    item_id uuid NOT NULL
);


ALTER TABLE public.item2bundle OWNER TO dspace;

--
-- Name: metadatafieldregistry_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.metadatafieldregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metadatafieldregistry_seq OWNER TO dspace;

--
-- Name: metadatafieldregistry; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.metadatafieldregistry (
    metadata_field_id integer DEFAULT nextval('public.metadatafieldregistry_seq'::regclass) NOT NULL,
    metadata_schema_id integer NOT NULL,
    element character varying(64),
    qualifier character varying(64),
    scope_note text
);


ALTER TABLE public.metadatafieldregistry OWNER TO dspace;

--
-- Name: metadataschemaregistry_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.metadataschemaregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metadataschemaregistry_seq OWNER TO dspace;

--
-- Name: metadataschemaregistry; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.metadataschemaregistry (
    metadata_schema_id integer DEFAULT nextval('public.metadataschemaregistry_seq'::regclass) NOT NULL,
    namespace character varying(256),
    short_id character varying(32)
);


ALTER TABLE public.metadataschemaregistry OWNER TO dspace;

--
-- Name: metadatavalue_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.metadatavalue_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metadatavalue_seq OWNER TO dspace;

--
-- Name: metadatavalue; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.metadatavalue (
    metadata_value_id integer DEFAULT nextval('public.metadatavalue_seq'::regclass) NOT NULL,
    metadata_field_id integer,
    text_value text,
    text_lang character varying(24),
    place integer,
    authority character varying(100),
    confidence integer DEFAULT '-1'::integer,
    dspace_object_id uuid
);


ALTER TABLE public.metadatavalue OWNER TO dspace;

--
-- Name: most_recent_checksum; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.most_recent_checksum (
    to_be_processed boolean NOT NULL,
    expected_checksum character varying NOT NULL,
    current_checksum character varying NOT NULL,
    last_process_start_date timestamp without time zone NOT NULL,
    last_process_end_date timestamp without time zone NOT NULL,
    checksum_algorithm character varying NOT NULL,
    matched_prev_checksum boolean NOT NULL,
    result character varying,
    bitstream_id uuid
);


ALTER TABLE public.most_recent_checksum OWNER TO dspace;

--
-- Name: mycourse; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.mycourse (
    course_id integer NOT NULL,
    eperson_id uuid,
    collection_id uuid
);


ALTER TABLE public.mycourse OWNER TO dspace;

--
-- Name: mycourses; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.mycourses (
    id integer,
    euuid uuid,
    cuuid uuid
);


ALTER TABLE public.mycourses OWNER TO dspace;

--
-- Name: rating; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.rating (
    rating_id integer NOT NULL,
    eperson_id uuid,
    item_id uuid,
    rating_value integer
);


ALTER TABLE public.rating OWNER TO dspace;

--
-- Name: rating_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.rating_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rating_seq OWNER TO dspace;

--
-- Name: registrationdata; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.registrationdata (
    registrationdata_id integer NOT NULL,
    email character varying(64),
    token character varying(48),
    expires timestamp without time zone
);


ALTER TABLE public.registrationdata OWNER TO dspace;

--
-- Name: registrationdata_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.registrationdata_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.registrationdata_seq OWNER TO dspace;

--
-- Name: requestitem; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.requestitem (
    requestitem_id integer NOT NULL,
    token character varying(48),
    allfiles boolean,
    request_email character varying(64),
    request_name character varying(64),
    request_date timestamp without time zone,
    accept_request boolean,
    decision_date timestamp without time zone,
    expires timestamp without time zone,
    request_message text,
    item_id uuid,
    bitstream_id uuid
);


ALTER TABLE public.requestitem OWNER TO dspace;

--
-- Name: requestitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.requestitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.requestitem_seq OWNER TO dspace;

--
-- Name: resourcepolicy; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.resourcepolicy (
    policy_id integer NOT NULL,
    resource_type_id integer,
    resource_id integer,
    action_id integer,
    start_date date,
    end_date date,
    rpname character varying(30),
    rptype character varying(30),
    rpdescription text,
    eperson_id uuid,
    epersongroup_id uuid,
    dspace_object uuid
);


ALTER TABLE public.resourcepolicy OWNER TO dspace;

--
-- Name: resourcepolicy_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.resourcepolicy_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resourcepolicy_seq OWNER TO dspace;

--
-- Name: schema_version; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.schema_version (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.schema_version OWNER TO dspace;

--
-- Name: site; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.site (
    uuid uuid NOT NULL
);


ALTER TABLE public.site OWNER TO dspace;

--
-- Name: subscription; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.subscription (
    subscription_id integer NOT NULL,
    eperson_id uuid,
    collection_id uuid
);


ALTER TABLE public.subscription OWNER TO dspace;

--
-- Name: subscription_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.subscription_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscription_seq OWNER TO dspace;

--
-- Name: tasklistitem; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.tasklistitem (
    tasklist_id integer NOT NULL,
    workflow_id integer,
    eperson_id uuid
);


ALTER TABLE public.tasklistitem OWNER TO dspace;

--
-- Name: tasklistitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.tasklistitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tasklistitem_seq OWNER TO dspace;

--
-- Name: versionhistory; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.versionhistory (
    versionhistory_id integer NOT NULL
);


ALTER TABLE public.versionhistory OWNER TO dspace;

--
-- Name: versionhistory_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.versionhistory_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.versionhistory_seq OWNER TO dspace;

--
-- Name: versionitem; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.versionitem (
    versionitem_id integer NOT NULL,
    version_number integer,
    version_date timestamp without time zone,
    version_summary character varying(255),
    versionhistory_id integer,
    eperson_id uuid,
    item_id uuid
);


ALTER TABLE public.versionitem OWNER TO dspace;

--
-- Name: versionitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.versionitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.versionitem_seq OWNER TO dspace;

--
-- Name: webapp; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.webapp (
    webapp_id integer NOT NULL,
    appname character varying(32),
    url character varying,
    started timestamp without time zone,
    isui integer
);


ALTER TABLE public.webapp OWNER TO dspace;

--
-- Name: webapp_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.webapp_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.webapp_seq OWNER TO dspace;

--
-- Name: workflowitem; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.workflowitem (
    workflow_id integer NOT NULL,
    state integer,
    multiple_titles boolean,
    published_before boolean,
    multiple_files boolean,
    item_id uuid,
    collection_id uuid,
    owner uuid
);


ALTER TABLE public.workflowitem OWNER TO dspace;

--
-- Name: workflowitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.workflowitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflowitem_seq OWNER TO dspace;

--
-- Name: workspaceitem; Type: TABLE; Schema: public; Owner: dspace
--

CREATE TABLE public.workspaceitem (
    workspace_item_id integer NOT NULL,
    multiple_titles boolean,
    published_before boolean,
    multiple_files boolean,
    stage_reached integer,
    page_reached integer,
    item_id uuid,
    collection_id uuid
);


ALTER TABLE public.workspaceitem OWNER TO dspace;

--
-- Name: workspaceitem_seq; Type: SEQUENCE; Schema: public; Owner: dspace
--

CREATE SEQUENCE public.workspaceitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workspaceitem_seq OWNER TO dspace;

--
-- Name: check_id; Type: DEFAULT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_history ALTER COLUMN check_id SET DEFAULT nextval('public.checksum_history_check_id_seq'::regclass);


--
-- Data for Name: bitstream; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.bitstream (bitstream_id, bitstream_format_id, checksum, checksum_algorithm, internal_id, deleted, store_number, sequence_id, size_bytes, uuid) FROM stdin;
\N	4	021cc825ad6e5b932552e1ae0d7f3fbb	MD5	69548580102260957534518934826834710058	f	0	1	7242822	0b3af3ef-fc2c-4942-96b1-d2254e99201c
\N	1	9db2f21e29d2f17bdb71d6c1ed111cea	MD5	108930713624041893687887730404901841511	f	0	1	69047	b3ac2a4b-5443-4f61-be3b-a4f5760d7710
\N	6	1511d2d9bd65f776fed2e4a4ae6fcc03	MD5	46645433681533529486744164531732883369	f	0	1	15592	7c48b00e-ddab-4a40-af07-8e9fc6a651d9
\N	4	021cc825ad6e5b932552e1ae0d7f3fbb	MD5	139781921548168246987373025446492888052	f	0	1	7242822	0b6a3f7f-6ad7-4dbe-b300-1bb8ee8ee2a2
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	21986617884653596215324289144157402349	f	0	2	1748	81a5ac06-022e-4b3e-a464-217ab669c7f3
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	22909154553467081453681933096378016490	f	0	2	1748	08d106a8-1ffc-42e2-9345-cdbbf5e25640
\N	1	3a12cf2e193f45ebdc521e7ef09deaf9	MD5	116308546795635120891330490335218539593	f	0	1	5712029	13f9a2f9-b4e5-4366-bad1-83b82634d5a5
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	19116251241500804991639953385058418224	f	0	2	1748	b80d21bb-4aae-4ee3-824a-3f95395252d7
\N	1	3a12cf2e193f45ebdc521e7ef09deaf9	MD5	15878560760087780220337152337488382946	f	0	1	5712029	0c9082e8-8c4b-4ce0-bc2d-e739c9e814fa
\N	6	1511d2d9bd65f776fed2e4a4ae6fcc03	MD5	109543849340616575086838304814137632070	f	0	1	15592	b0fd981f-85b2-46f0-a1a6-8670732577d9
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	164905527986006353117252129267714037635	f	0	2	1748	9da1785d-55d1-4e50-9df7-737c1c584855
\N	1	ceb8da5aecfdc2c1b745520cd0a1a768	MD5	88692017543482056681686007780450104289	f	0	1	31967	64fee389-1491-49e9-870c-88e74ef32a14
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	53766928786294126090516622516376476801	f	0	2	1748	c9fb30a3-6e29-48f4-836e-8241805c086d
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	53282759050296286077904246282925124146	f	0	2	1748	bade7c98-10b6-4843-b443-44b6ed5acb04
\N	4	aa829cd04ff93d856eb0618d3627bb7e	MD5	125814457974086708433405074019511760179	f	0	1	11471769	ba7ce28a-f9aa-4ea8-99f1-75accb03e87c
\N	6	1511d2d9bd65f776fed2e4a4ae6fcc03	MD5	43347023845596311212395591881739869454	f	0	1	15592	fb4f2a26-b5b1-4757-8e79-b786f0e8a46b
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	35445626449555767940456478524957455589	f	0	2	1748	b44dbb4d-a1cc-4a6b-98d5-fa739a1e083c
\N	1	ceb8da5aecfdc2c1b745520cd0a1a768	MD5	62850234643999735226562946718099541979	f	0	1	31967	ca06fc2d-47e4-40c1-9909-6e527521c4ba
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	87829405384563040952336820844463411739	f	0	2	1748	dbb996cf-0122-4e78-bf03-6f8c2322638c
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	102064085697487159342659310417357646509	f	0	2	1748	827bffbd-a853-4955-a0ef-f285241bedfc
\N	1	3a12cf2e193f45ebdc521e7ef09deaf9	MD5	153658368561748267131441463098755637905	f	0	1	5712029	15d4b547-ef7e-46ac-bee2-0977938520d4
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	90702234151778935350647807835759117578	f	0	2	1748	f1ca61cf-b4fb-4d99-9b01-c6154bd04085
\N	1	ceb8da5aecfdc2c1b745520cd0a1a768	MD5	59036144948041093575479650536514459793	f	0	1	31967	b5677909-694d-4b69-bdaa-66f81f894c1b
\N	6	1511d2d9bd65f776fed2e4a4ae6fcc03	MD5	84427509089119204991561462975483434682	f	0	1	15592	5a4943d5-155f-4ba9-ac21-a1c42db7624b
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	63148606143811135337368003897205720732	f	0	2	1748	5e355026-895b-4bdc-8fed-14d4779fc8aa
\N	4	9859ebf66f1789efeeea3ca5bfaa69cc	MD5	98526643508174943087127835679124275396	f	0	1	10417121	8c99d017-1503-4dfd-8066-0f5dc8ace132
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	45114692212032704043206156176595824958	f	0	2	1748	cf56643a-2485-499f-96e4-08970d0b625f
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	59331657978123849004233773813059048450	f	0	2	1748	d4c1d98f-325c-45fa-b57b-16fcac56d5a5
\N	4	3fbcb5bffd6d7e868b61fb0872070cb0	MD5	144824387463713458507317052480904035691	f	0	1	769842	ceedb68a-7731-43e3-96d0-ebed5acb3241
\N	6	1511d2d9bd65f776fed2e4a4ae6fcc03	MD5	33122280429744205175929442001696131653	f	0	1	15592	62864ee6-212d-4336-aa23-10b53876c33f
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	84554179573953004377073560034886008502	f	0	2	1748	ae3cb1cb-0353-47a8-800c-0d9eb3347f42
\N	6	e1bd128fee06d68a34948d686efc6373	MD5	43824736263275240766793361188172283675	f	0	1	48	f4c6f687-6237-4363-8242-9d64a1c519ef
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	117255779281243937620326650183795248093	f	0	2	1748	481daa37-0f1d-4fba-ba2a-091e703471d0
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	117494053076008856300344726757613772833	f	0	2	1748	4c513e51-f52d-4655-acef-a93cec34fedb
\N	6	1511d2d9bd65f776fed2e4a4ae6fcc03	MD5	147405473035875627135856097262473345088	f	0	1	15592	864216a8-2cc4-4796-bd22-b14eb1b71e85
\N	6	1511d2d9bd65f776fed2e4a4ae6fcc03	MD5	150782703981127904396024507176083473237	f	0	1	15592	27faba85-6cd4-4258-afd0-0ad4e8c60ee3
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	128118218698006014400200418317933780692	f	0	2	1748	bce59918-0051-4f67-af90-a9c05e36efd8
\N	6	1511d2d9bd65f776fed2e4a4ae6fcc03	MD5	43695210223768915680950480743200251861	f	0	1	15592	2522b4b7-99b8-48fb-9206-d658e4672baa
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	52369035902567471924380986693216196030	f	0	2	1748	288c7b7f-5138-40cf-8922-3fcc9521b868
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	92513995279826966924572863479257380375	f	0	2	1748	6daaa47a-986c-42f5-ae59-b49fd3ca5c19
\N	6	1511d2d9bd65f776fed2e4a4ae6fcc03	MD5	158634854805645313346011110595119334720	f	0	1	15592	b60be1f9-c245-49d4-8fbb-aa98ef07c01e
\N	4	8da5f569bdf7a51b5ff69d06c2e842ed	MD5	89254978548454678500020631850789003818	f	0	1	329047	b8362c84-61d5-4c54-9b93-6903dc7af6c3
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	701618631278530019790975305201911715	f	0	2	1748	993c2eda-5a7e-4c77-b845-a8fbc12b782a
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	26438660648762732166525099219801210595	f	0	2	1748	b71d3b0c-7bbd-4413-bea7-7d9cd8aaf50a
\N	4	0d30657a09d7dcc2aed6bbcce856e7e8	MD5	95982618136435240214398945163030954422	f	0	1	61085	f73aec6a-8837-4fbd-bdc7-a5cac842a210
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	20315523288278738460167562629783109640	f	0	2	1748	1c315c05-38b9-4642-be4b-e2d231bb1169
\N	4	0d30657a09d7dcc2aed6bbcce856e7e8	MD5	168086989154769857022829937827506813673	f	0	1	61085	06c28b52-5b08-4aac-b946-7db8e024b91a
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	74749574512246586560379426835219214865	f	0	2	1748	58311eb7-934a-4410-bae3-b8371355d96b
\N	16	ad7683dc0b0cd15e9b54bbac31330c74	MD5	63233600029411561841306274365651410667	f	0	1	69947	51dd5697-85ee-43f1-bcf3-ccbe02cf84e1
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	76947192894481653916823823098809796135	f	0	2	1748	d73be20c-529c-4c77-9b21-365090f576c2
\N	4	00a376d460e83aad438fcf167be79d40	MD5	51502685829070282873006161843914105312	f	0	1	85097	aef9672a-a17e-4448-8163-46185e0daa6b
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	13271469910819310112655453114313086159	f	0	2	1748	02e23fc3-0aad-4f54-a65c-b19cc9bf2ecb
\N	16	c35e5b1c8ffb59c16c28ca35fabfc90a	MD5	86163336123384241977194370509796912625	f	0	1	515866	050db052-de7e-48b1-90c7-3498e746d313
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	110373859061514031869686096114649466198	f	0	2	1748	453c6c0c-2699-4fec-b0f9-5a2752bd330d
\N	6	1511d2d9bd65f776fed2e4a4ae6fcc03	MD5	55473162155199547033285955518136228574	f	0	1	15592	495f0e71-7700-4890-9620-ea230a0af6fa
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	134561649296045381191225235209143862635	f	0	2	1748	429a7a03-d91e-486a-ba01-e393fc4a6dde
\N	4	0d30657a09d7dcc2aed6bbcce856e7e8	MD5	133366648318431601739221496678965090360	f	0	1	61085	7109a357-c47f-4b04-a2a7-fee0c0b92f6d
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	164424163321304162908178411589431862825	f	0	2	1748	2634c301-12e5-418e-9fbb-ab0b9561aafc
\N	1	e5e2fd8de78f14866c5c9bf4db157c99	MD5	101401187509409036490438171798270826098	f	0	1	3169	aed10948-cd76-49b8-8e67-ba356412c132
\N	1	9db2f21e29d2f17bdb71d6c1ed111cea	MD5	12709486375003327004698063061731053729	f	0	1	69047	60b58afa-a7ce-4ca2-91ad-607fbc0264c0
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	117090391582614057134045430322882840301	f	0	2	1748	6234b407-7244-4b13-b9d8-9652ce66a0ca
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	4374141691859944995277305964968588216	f	0	2	1748	375184f3-d51d-4536-9f46-833aa8e2ec1e
\N	4	00a376d460e83aad438fcf167be79d40	MD5	79556182898326434844881479042504036924	f	0	1	85097	c7d9baf3-edb7-42d9-b3cd-d32eba23954c
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	94652848795164960392875173808563856520	f	0	2	1748	617a3a58-26b1-4992-bb50-0a484bfedadf
\N	4	021cc825ad6e5b932552e1ae0d7f3fbb	MD5	73154989693018827740789126395660208732	f	0	1	7242822	5bf01747-4b30-4677-9ae5-8cf781e37adf
\N	16	d03d39d1bd1463ca6c82442772aca31a	MD5	27534966046795270309471382430970900669	f	0	1	972	bf8d7f49-ab53-4056-bcde-3fa29c87b9a4
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	73513613028290632634731282032374211531	f	0	2	1748	bc67c574-d6d7-42f3-be29-a557a17bac5b
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	152898981116379804251991151376392590976	f	0	2	1748	71a60c46-7112-449c-a1f2-3fc619e67787
\.


--
-- Data for Name: bitstreamformatregistry; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.bitstreamformatregistry (bitstream_format_id, mimetype, short_description, description, support_level, internal) FROM stdin;
1	application/octet-stream	Unknown	Unknown data format	0	f
2	text/plain; charset=utf-8	License	Item-specific license agreed upon to submission	1	t
3	text/html; charset=utf-8	CC License	Item-specific Creative Commons license agreed upon to submission	1	t
4	application/pdf	Adobe PDF	Adobe Portable Document Format	1	f
5	text/xml	XML	Extensible Markup Language	1	f
6	text/plain	Text	Plain Text	1	f
7	text/html	HTML	Hypertext Markup Language	1	f
8	text/css	CSS	Cascading Style Sheets	1	f
9	application/msword	Microsoft Word	Microsoft Word	1	f
10	application/vnd.openxmlformats-officedocument.wordprocessingml.document	Microsoft Word XML	Microsoft Word XML	1	f
11	application/vnd.ms-powerpoint	Microsoft Powerpoint	Microsoft Powerpoint	1	f
12	application/vnd.openxmlformats-officedocument.presentationml.presentation	Microsoft Powerpoint XML	Microsoft Powerpoint XML	1	f
13	application/vnd.ms-excel	Microsoft Excel	Microsoft Excel	1	f
14	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	Microsoft Excel XML	Microsoft Excel XML	1	f
15	application/marc	MARC	Machine-Readable Cataloging records	1	f
16	image/jpeg	JPEG	Joint Photographic Experts Group/JPEG File Interchange Format (JFIF)	1	f
17	image/gif	GIF	Graphics Interchange Format	1	f
18	image/png	image/png	Portable Network Graphics	1	f
19	image/tiff	TIFF	Tag Image File Format	1	f
20	audio/x-aiff	AIFF	Audio Interchange File Format	1	f
21	audio/basic	audio/basic	Basic Audio	1	f
22	audio/x-wav	WAV	Broadcase Wave Format	1	f
23	video/mpeg	MPEG	Moving Picture Experts Group	1	f
24	text/richtext	RTF	Rich Text Format	1	f
25	application/vnd.visio	Microsoft Visio	Microsoft Visio	1	f
26	application/x-filemaker	FMP3	Filemaker Pro	1	f
27	image/x-ms-bmp	BMP	Microsoft Windows bitmap	1	f
28	application/x-photoshop	Photoshop	Photoshop	1	f
29	application/postscript	Postscript	Postscript Files	1	f
30	video/quicktime	Video Quicktime	Video Quicktime	1	f
31	audio/x-mpeg	MPEG Audio	MPEG Audio	1	f
32	application/vnd.ms-project	Microsoft Project	Microsoft Project	1	f
33	application/mathematica	Mathematica	Mathematica Notebook	1	f
34	application/x-latex	LateX	LaTeX document	1	f
35	application/x-tex	TeX	Tex/LateX document	1	f
36	application/x-dvi	TeX dvi	TeX dvi format	1	f
37	application/sgml	SGML	SGML application (RFC 1874)	1	f
38	application/wordperfect5.1	WordPerfect	WordPerfect 5.1 document	1	f
39	audio/x-pn-realaudio	RealAudio	RealAudio file	1	f
40	image/x-photo-cd	Photo CD	Kodak Photo CD image	1	f
41	application/vnd.oasis.opendocument.text	OpenDocument Text	OpenDocument Text	1	f
42	application/vnd.oasis.opendocument.text-template	OpenDocument Text Template	OpenDocument Text Template	1	f
43	application/vnd.oasis.opendocument.text-web	OpenDocument HTML Template	OpenDocument HTML Template	1	f
44	application/vnd.oasis.opendocument.text-master	OpenDocument Master Document	OpenDocument Master Document	1	f
45	application/vnd.oasis.opendocument.graphics	OpenDocument Drawing	OpenDocument Drawing	1	f
46	application/vnd.oasis.opendocument.graphics-template	OpenDocument Drawing Template	OpenDocument Drawing Template	1	f
47	application/vnd.oasis.opendocument.presentation	OpenDocument Presentation	OpenDocument Presentation	1	f
48	application/vnd.oasis.opendocument.presentation-template	OpenDocument Presentation Template	OpenDocument Presentation Template	1	f
49	application/vnd.oasis.opendocument.spreadsheet	OpenDocument Spreadsheet	OpenDocument Spreadsheet	1	f
50	application/vnd.oasis.opendocument.spreadsheet-template	OpenDocument Spreadsheet Template	OpenDocument Spreadsheet Template	1	f
51	application/vnd.oasis.opendocument.chart	OpenDocument Chart	OpenDocument Chart	1	f
52	application/vnd.oasis.opendocument.formula	OpenDocument Formula	OpenDocument Formula	1	f
53	application/vnd.oasis.opendocument.database	OpenDocument Database	OpenDocument Database	1	f
54	application/vnd.oasis.opendocument.image	OpenDocument Image	OpenDocument Image	1	f
55	application/vnd.openofficeorg.extension	OpenOffice.org extension	OpenOffice.org extension (since OOo 2.1)	1	f
56	application/vnd.sun.xml.writer	Writer 6.0 documents	Writer 6.0 documents	1	f
57	application/vnd.sun.xml.writer.template	Writer 6.0 templates	Writer 6.0 templates	1	f
58	application/vnd.sun.xml.calc	Calc 6.0 spreadsheets	Calc 6.0 spreadsheets	1	f
59	application/vnd.sun.xml.calc.template	Calc 6.0 templates	Calc 6.0 templates	1	f
60	application/vnd.sun.xml.draw	Draw 6.0 documents	Draw 6.0 documents	1	f
61	application/vnd.sun.xml.draw.template	Draw 6.0 templates	Draw 6.0 templates	1	f
62	application/vnd.sun.xml.impress	Impress 6.0 presentations	Impress 6.0 presentations	1	f
63	application/vnd.sun.xml.impress.template	Impress 6.0 templates	Impress 6.0 templates	1	f
64	application/vnd.sun.xml.writer.global	Writer 6.0 global documents	Writer 6.0 global documents	1	f
65	application/vnd.sun.xml.math	Math 6.0 documents	Math 6.0 documents	1	f
66	application/vnd.stardivision.writer	StarWriter 5.x documents	StarWriter 5.x documents	1	f
67	application/vnd.stardivision.writer-global	StarWriter 5.x global documents	StarWriter 5.x global documents	1	f
68	application/vnd.stardivision.calc	StarCalc 5.x spreadsheets	StarCalc 5.x spreadsheets	1	f
69	application/vnd.stardivision.draw	StarDraw 5.x documents	StarDraw 5.x documents	1	f
70	application/vnd.stardivision.impress	StarImpress 5.x presentations	StarImpress 5.x presentations	1	f
71	application/vnd.stardivision.impress-packed	StarImpress Packed 5.x files	StarImpress Packed 5.x files	1	f
72	application/vnd.stardivision.math	StarMath 5.x documents	StarMath 5.x documents	1	f
73	application/vnd.stardivision.chart	StarChart 5.x documents	StarChart 5.x documents	1	f
74	application/vnd.stardivision.mail	StarMail 5.x mail files	StarMail 5.x mail files	1	f
75	application/rdf+xml; charset=utf-8	RDF XML	RDF serialized in XML	1	f
76	application/epub+zip	EPUB	Electronic publishing	1	f
\.


--
-- Name: bitstreamformatregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.bitstreamformatregistry_seq', 76, true);


--
-- Data for Name: bundle; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.bundle (bundle_id, uuid, primary_bitstream_id) FROM stdin;
\N	f4af25dc-153f-4958-a515-1cdf352d30e6	\N
\N	495be94e-1eef-4a2e-9ed6-05efa3f2667a	\N
\N	2ea7c2a4-41d5-4115-9afa-ce1a849cc6e5	\N
\N	0fd12cd1-fb9f-4355-bf1d-9f95d42ecef5	\N
\N	a1fce771-5353-4398-924c-045ed36e55c4	0c9082e8-8c4b-4ce0-bc2d-e739c9e814fa
\N	4ae07e0e-4ddd-4d82-aab7-72ab37f67174	\N
\N	f49fd40d-fcf2-4815-9f24-083b794b4bd5	\N
\N	97b30dc1-de2c-4da2-a4c7-954ceb243951	\N
\N	65bad344-2707-457e-b1ba-bee570972b87	\N
\N	8cc9da0c-2cee-418c-8cd2-d4065adbdbf7	\N
\N	a93055cd-3253-4f73-bc2a-5b9b944afbe7	\N
\N	454bff8d-6deb-48ba-97f1-70c8a160b5c6	\N
\N	1f036576-773c-4d03-9127-b4bba2eca4d5	\N
\N	8570e079-3966-4d74-af6d-1cd038b7dad9	\N
\N	97af0899-be0a-427a-9c11-6a02776d0830	\N
\N	66e6f832-c292-402a-ad47-ee06ff5c9f87	\N
\N	a23a2a91-cd8d-4f0b-867d-c73e55c0598c	\N
\N	f99b4579-1283-4026-8ff8-6f78dc0d2805	\N
\N	f1a0e28e-b69d-419e-9649-43ca88e6bafa	\N
\N	cdc0ef88-260d-461a-9c2e-494e93909912	\N
\N	762771f7-2ebd-466f-9760-39375d35f186	\N
\N	7ea26c6a-9885-47f0-9995-38f0aed9cd91	\N
\N	87f81a7c-1224-4b6e-8017-8cae299f6988	\N
\N	07c4f7ff-069a-4fde-8620-aa70b4156f54	\N
\N	7439b012-2aac-42f1-b73d-d249a9d64e40	\N
\N	96ff33e7-2956-48ea-af67-2f5366ae3191	\N
\N	c0079563-57d3-4efc-a576-e6ea19f5a8d7	\N
\N	dcaae3de-8a3c-4f5f-adad-32b869c47f74	\N
\N	815fed71-ea32-4bf7-8b87-137ce9894d24	\N
\N	ff92dae9-5899-4088-8459-af661f0dd874	\N
\N	32fdc0cb-eb32-405e-bb25-3b6fbdd584e1	\N
\N	d50a4391-97bd-443b-8a35-b8f3558509ae	\N
\N	9d4327b4-82d3-41c6-b291-43a7e13133f3	\N
\N	7dd0e346-25c3-461f-b02e-2b3f853abe00	\N
\N	a1f8f03a-1fae-43c9-b85d-5edd6742876d	\N
\N	b2b82808-7008-4b71-b3f0-c2def986c957	\N
\N	bf1beb12-c719-4a7e-997e-dc13d5534198	\N
\N	7ef63ce2-b0cc-47c2-97c7-74c9cf2c927f	\N
\N	8331723c-d2b7-4274-a3f0-ab6c8c782fcb	\N
\N	6f4f1048-3377-42ca-bce0-70923275a958	\N
\N	ebe553b5-6c77-4f47-b14f-c55fcfbb243f	\N
\N	8aede5fb-4458-414d-ac6b-fe62210c70f8	\N
\N	19727d4e-ea29-4695-ba0f-ef42a24e7d2b	\N
\N	076a0596-b1d7-4db4-a5f0-b8cf8ff524df	\N
\N	b59b4e13-6b97-4759-9d11-d6f4f0044cce	\N
\N	b961e9d0-2b79-4802-843e-05b3b929c1a3	\N
\N	1ec8dff4-d4ff-42c3-a9e6-54744d5bc6f8	\N
\N	36d8c81e-90c2-43cc-b881-78122115f2e1	\N
\N	f4de32b9-043d-4b0f-b400-86fa3df1fb01	\N
\N	d2896b5f-1280-4fcd-8a57-3709f3ddb817	\N
\N	da8c4a2a-1001-45f6-a3ea-33abedf18e74	\N
\N	fd787dfc-ee8f-4463-a69d-fad1db917bdd	\N
\N	48616940-8e7c-44d1-9ca7-1fb58dc561d0	\N
\N	f91fbf0e-92c9-4ceb-b35c-748bfd9e277f	\N
\N	3d5c95b0-1727-45a0-b0c5-a3835e80ef6c	\N
\N	87b2bbe8-4dc4-4f1f-9abb-c04562fb4feb	\N
\N	482e7f8c-7687-46c3-826d-fd1939ea3bbc	\N
\N	97622e69-6bb7-4f81-bc71-5de1ab7aa10e	\N
\N	670e9a5a-7cb8-40f1-a42e-71207489aa2b	\N
\N	7ab42eaa-6ee8-4ffb-bc49-b48e71f893ea	\N
\N	28bebfa8-ac05-442e-aac5-10e1ee16ab40	\N
\N	552b54d4-5c5b-4c2a-be8b-d6f342103e8d	\N
\N	b9e1bdac-f069-4a5f-bf4e-dcaaa909dee8	\N
\N	271a2f04-3526-4d6f-86e5-5bd3f616576d	\N
\N	e545724e-fb31-44a6-8266-91cf0dac072f	\N
\N	d4a63d5c-7c0d-44f2-b105-882cdb6d9c09	\N
\.


--
-- Data for Name: bundle2bitstream; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.bundle2bitstream (bitstream_order_legacy, bundle_id, bitstream_id, bitstream_order) FROM stdin;
\N	f4af25dc-153f-4958-a515-1cdf352d30e6	0b3af3ef-fc2c-4942-96b1-d2254e99201c	0
\N	495be94e-1eef-4a2e-9ed6-05efa3f2667a	b3ac2a4b-5443-4f61-be3b-a4f5760d7710	0
\N	2ea7c2a4-41d5-4115-9afa-ce1a849cc6e5	13f9a2f9-b4e5-4366-bad1-83b82634d5a5	0
\N	0fd12cd1-fb9f-4355-bf1d-9f95d42ecef5	b80d21bb-4aae-4ee3-824a-3f95395252d7	0
\N	a1fce771-5353-4398-924c-045ed36e55c4	0c9082e8-8c4b-4ce0-bc2d-e739c9e814fa	0
\N	4ae07e0e-4ddd-4d82-aab7-72ab37f67174	9da1785d-55d1-4e50-9df7-737c1c584855	0
\N	f49fd40d-fcf2-4815-9f24-083b794b4bd5	64fee389-1491-49e9-870c-88e74ef32a14	0
\N	97b30dc1-de2c-4da2-a4c7-954ceb243951	bade7c98-10b6-4843-b443-44b6ed5acb04	0
\N	65bad344-2707-457e-b1ba-bee570972b87	ba7ce28a-f9aa-4ea8-99f1-75accb03e87c	0
\N	8cc9da0c-2cee-418c-8cd2-d4065adbdbf7	b44dbb4d-a1cc-4a6b-98d5-fa739a1e083c	0
\N	a93055cd-3253-4f73-bc2a-5b9b944afbe7	ca06fc2d-47e4-40c1-9909-6e527521c4ba	0
\N	454bff8d-6deb-48ba-97f1-70c8a160b5c6	dbb996cf-0122-4e78-bf03-6f8c2322638c	0
\N	1f036576-773c-4d03-9127-b4bba2eca4d5	15d4b547-ef7e-46ac-bee2-0977938520d4	0
\N	8570e079-3966-4d74-af6d-1cd038b7dad9	f1ca61cf-b4fb-4d99-9b01-c6154bd04085	0
\N	97af0899-be0a-427a-9c11-6a02776d0830	b5677909-694d-4b69-bdaa-66f81f894c1b	0
\N	66e6f832-c292-402a-ad47-ee06ff5c9f87	5e355026-895b-4bdc-8fed-14d4779fc8aa	0
\N	a23a2a91-cd8d-4f0b-867d-c73e55c0598c	8c99d017-1503-4dfd-8066-0f5dc8ace132	0
\N	f99b4579-1283-4026-8ff8-6f78dc0d2805	d4c1d98f-325c-45fa-b57b-16fcac56d5a5	0
\N	f1a0e28e-b69d-419e-9649-43ca88e6bafa	ceedb68a-7731-43e3-96d0-ebed5acb3241	0
\N	cdc0ef88-260d-461a-9c2e-494e93909912	ae3cb1cb-0353-47a8-800c-0d9eb3347f42	0
\N	762771f7-2ebd-466f-9760-39375d35f186	f4c6f687-6237-4363-8242-9d64a1c519ef	0
\N	7ea26c6a-9885-47f0-9995-38f0aed9cd91	4c513e51-f52d-4655-acef-a93cec34fedb	0
\N	87f81a7c-1224-4b6e-8017-8cae299f6988	864216a8-2cc4-4796-bd22-b14eb1b71e85	0
\N	07c4f7ff-069a-4fde-8620-aa70b4156f54	bce59918-0051-4f67-af90-a9c05e36efd8	0
\N	7439b012-2aac-42f1-b73d-d249a9d64e40	2522b4b7-99b8-48fb-9206-d658e4672baa	0
\N	96ff33e7-2956-48ea-af67-2f5366ae3191	6daaa47a-986c-42f5-ae59-b49fd3ca5c19	0
\N	c0079563-57d3-4efc-a576-e6ea19f5a8d7	b60be1f9-c245-49d4-8fbb-aa98ef07c01e	0
\N	dcaae3de-8a3c-4f5f-adad-32b869c47f74	993c2eda-5a7e-4c77-b845-a8fbc12b782a	0
\N	815fed71-ea32-4bf7-8b87-137ce9894d24	7c48b00e-ddab-4a40-af07-8e9fc6a651d9	0
\N	ff92dae9-5899-4088-8459-af661f0dd874	08d106a8-1ffc-42e2-9345-cdbbf5e25640	0
\N	32fdc0cb-eb32-405e-bb25-3b6fbdd584e1	b0fd981f-85b2-46f0-a1a6-8670732577d9	0
\N	d50a4391-97bd-443b-8a35-b8f3558509ae	c9fb30a3-6e29-48f4-836e-8241805c086d	0
\N	9d4327b4-82d3-41c6-b291-43a7e13133f3	fb4f2a26-b5b1-4757-8e79-b786f0e8a46b	0
\N	7dd0e346-25c3-461f-b02e-2b3f853abe00	827bffbd-a853-4955-a0ef-f285241bedfc	0
\N	a1f8f03a-1fae-43c9-b85d-5edd6742876d	5a4943d5-155f-4ba9-ac21-a1c42db7624b	0
\N	b2b82808-7008-4b71-b3f0-c2def986c957	cf56643a-2485-499f-96e4-08970d0b625f	0
\N	bf1beb12-c719-4a7e-997e-dc13d5534198	62864ee6-212d-4336-aa23-10b53876c33f	0
\N	7ef63ce2-b0cc-47c2-97c7-74c9cf2c927f	481daa37-0f1d-4fba-ba2a-091e703471d0	0
\N	8331723c-d2b7-4274-a3f0-ab6c8c782fcb	27faba85-6cd4-4258-afd0-0ad4e8c60ee3	0
\N	6f4f1048-3377-42ca-bce0-70923275a958	288c7b7f-5138-40cf-8922-3fcc9521b868	0
\N	ebe553b5-6c77-4f47-b14f-c55fcfbb243f	b8362c84-61d5-4c54-9b93-6903dc7af6c3	0
\N	8aede5fb-4458-414d-ac6b-fe62210c70f8	b71d3b0c-7bbd-4413-bea7-7d9cd8aaf50a	0
\N	19727d4e-ea29-4695-ba0f-ef42a24e7d2b	f73aec6a-8837-4fbd-bdc7-a5cac842a210	0
\N	076a0596-b1d7-4db4-a5f0-b8cf8ff524df	1c315c05-38b9-4642-be4b-e2d231bb1169	0
\N	b59b4e13-6b97-4759-9d11-d6f4f0044cce	06c28b52-5b08-4aac-b946-7db8e024b91a	0
\N	b961e9d0-2b79-4802-843e-05b3b929c1a3	58311eb7-934a-4410-bae3-b8371355d96b	0
\N	1ec8dff4-d4ff-42c3-a9e6-54744d5bc6f8	7109a357-c47f-4b04-a2a7-fee0c0b92f6d	0
\N	36d8c81e-90c2-43cc-b881-78122115f2e1	2634c301-12e5-418e-9fbb-ab0b9561aafc	0
\N	f4de32b9-043d-4b0f-b400-86fa3df1fb01	60b58afa-a7ce-4ca2-91ad-607fbc0264c0	0
\N	d2896b5f-1280-4fcd-8a57-3709f3ddb817	6234b407-7244-4b13-b9d8-9652ce66a0ca	0
\N	da8c4a2a-1001-45f6-a3ea-33abedf18e74	c7d9baf3-edb7-42d9-b3cd-d32eba23954c	0
\N	fd787dfc-ee8f-4463-a69d-fad1db917bdd	617a3a58-26b1-4992-bb50-0a484bfedadf	0
\N	48616940-8e7c-44d1-9ca7-1fb58dc561d0	bf8d7f49-ab53-4056-bcde-3fa29c87b9a4	0
\N	f91fbf0e-92c9-4ceb-b35c-748bfd9e277f	bc67c574-d6d7-42f3-be29-a557a17bac5b	0
\N	3d5c95b0-1727-45a0-b0c5-a3835e80ef6c	51dd5697-85ee-43f1-bcf3-ccbe02cf84e1	0
\N	87b2bbe8-4dc4-4f1f-9abb-c04562fb4feb	d73be20c-529c-4c77-9b21-365090f576c2	0
\N	482e7f8c-7687-46c3-826d-fd1939ea3bbc	aef9672a-a17e-4448-8163-46185e0daa6b	0
\N	97622e69-6bb7-4f81-bc71-5de1ab7aa10e	02e23fc3-0aad-4f54-a65c-b19cc9bf2ecb	0
\N	670e9a5a-7cb8-40f1-a42e-71207489aa2b	050db052-de7e-48b1-90c7-3498e746d313	0
\N	7ab42eaa-6ee8-4ffb-bc49-b48e71f893ea	453c6c0c-2699-4fec-b0f9-5a2752bd330d	0
\N	28bebfa8-ac05-442e-aac5-10e1ee16ab40	495f0e71-7700-4890-9620-ea230a0af6fa	0
\N	552b54d4-5c5b-4c2a-be8b-d6f342103e8d	429a7a03-d91e-486a-ba01-e393fc4a6dde	0
\N	b9e1bdac-f069-4a5f-bf4e-dcaaa909dee8	aed10948-cd76-49b8-8e67-ba356412c132	0
\N	271a2f04-3526-4d6f-86e5-5bd3f616576d	375184f3-d51d-4536-9f46-833aa8e2ec1e	0
\N	e545724e-fb31-44a6-8266-91cf0dac072f	5bf01747-4b30-4677-9ae5-8cf781e37adf	0
\N	d4a63d5c-7c0d-44f2-b105-882cdb6d9c09	71a60c46-7112-449c-a1f2-3fc619e67787	0
\.


--
-- Data for Name: checksum_history; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.checksum_history (check_id, process_start_date, process_end_date, checksum_expected, checksum_calculated, result, bitstream_id) FROM stdin;
\.


--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.checksum_history_check_id_seq', 1, false);


--
-- Data for Name: checksum_results; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.checksum_results (result_code, result_description) FROM stdin;
INVALID_HISTORY	Install of the cheksum checking code do not consider this history as valid
BITSTREAM_NOT_FOUND	The bitstream could not be found
CHECKSUM_MATCH	Current checksum matched previous checksum
CHECKSUM_NO_MATCH	Current checksum does not match previous checksum
CHECKSUM_PREV_NOT_FOUND	Previous checksum was not found: no comparison possible
BITSTREAM_INFO_NOT_FOUND	Bitstream info not found
CHECKSUM_ALGORITHM_INVALID	Invalid checksum algorithm
BITSTREAM_NOT_PROCESSED	Bitstream marked to_be_processed=false
BITSTREAM_MARKED_DELETED	Bitstream marked deleted in bitstream table
\.


--
-- Data for Name: collection; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.collection (collection_id, uuid, workflow_step_1, workflow_step_2, workflow_step_3, submitter, template_item_id, logo_bitstream_id, admin) FROM stdin;
\N	b7b1b7e1-3a94-439e-ade7-f9ef898e272f	\N	\N	\N	77bfc801-e14b-4722-b5f2-23e1bea38444	\N	\N	\N
\N	e1e182b9-a464-49c6-89a9-7453f23404bd	\N	\N	\N	910cd60d-b619-4a3c-a4da-65e3d2486a05	\N	\N	\N
\N	9f445d1d-8fa5-47d5-8d32-e8b860e61328	\N	\N	\N	f42e991a-539b-4958-9b31-943990b49e3c	\N	\N	\N
\N	216554d5-e1c6-4975-be5d-16a435fdbdae	\N	\N	\N	56973b4f-8b45-492b-b89c-2fa51b1126d7	\N	\N	\N
\N	f7019f5a-44ba-4a31-a105-b20cc4c20ae1	\N	\N	\N	d09cba3a-461b-4c6b-9c82-8b23ca6ac64e	\N	\N	\N
\N	38da3b9e-b576-4d9f-907c-ace9b09861c4	\N	\N	\N	bb963c9f-808b-482e-85d7-1a719936c404	\N	\N	\N
\N	fedb15df-f01e-40c5-816e-30aa1e8c6667	\N	\N	\N	1cc4d7b9-08ca-48cf-a63f-bb6e8ab40703	\N	\N	\N
\N	b85a9096-4fb2-4d61-a9ff-de5ddbc122cc	\N	\N	\N	2bcbb4bb-1b0c-43ae-9ed0-d4027bd1f9ab	\N	\N	\N
\N	54bab732-de98-4acc-b69f-8738383c06d2	\N	\N	\N	8122dbec-aaa3-45d2-b3f3-d526bdafd332	\N	\N	\N
\N	9ecd6365-9d96-49bb-a656-c2ccab8653e2	\N	\N	\N	f4e3955f-89f4-4169-8f63-ba561e510f51	\N	\N	\N
\N	ab76a5ce-1b6e-429a-87d5-404757fa848c	\N	\N	\N	9827a165-99c8-4b82-ac73-53f919703a4c	\N	\N	\N
\N	8c7e552a-5797-4dd1-a35b-85a265feeb3f	\N	\N	\N	0f0ad925-a61d-41a8-accc-4579e9666128	\N	\N	\N
\.


--
-- Data for Name: collection2item; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.collection2item (collection_id, item_id) FROM stdin;
f7019f5a-44ba-4a31-a105-b20cc4c20ae1	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
f7019f5a-44ba-4a31-a105-b20cc4c20ae1	fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d
f7019f5a-44ba-4a31-a105-b20cc4c20ae1	a8b94f7f-986d-479b-80a4-a7b528984380
f7019f5a-44ba-4a31-a105-b20cc4c20ae1	a54bbc7b-59eb-4a38-849a-e43ef1b8304a
f7019f5a-44ba-4a31-a105-b20cc4c20ae1	2499711d-8cf0-476d-9534-fe00f0475658
38da3b9e-b576-4d9f-907c-ace9b09861c4	45d8b4dc-5da5-46af-a643-3143b6af9f13
38da3b9e-b576-4d9f-907c-ace9b09861c4	a8be8fdd-3a54-4e70-aa5c-56e24e9e403b
38da3b9e-b576-4d9f-907c-ace9b09861c4	c39ad818-307a-4c7a-9672-4e8e85c0d624
38da3b9e-b576-4d9f-907c-ace9b09861c4	3da62806-eab4-4e50-85f7-c27836c44a3b
fedb15df-f01e-40c5-816e-30aa1e8c6667	53894fe9-2e5a-4cc0-a1a6-0fda50fcae49
fedb15df-f01e-40c5-816e-30aa1e8c6667	75e52dde-8992-4237-9b42-7004977bd3d7
fedb15df-f01e-40c5-816e-30aa1e8c6667	89010e0b-74f4-43f9-be0d-f6b83045feb7
fedb15df-f01e-40c5-816e-30aa1e8c6667	fa1c2a6a-f594-4746-934c-f901c60f2d5a
fedb15df-f01e-40c5-816e-30aa1e8c6667	c636ac62-1683-4b64-a42c-c38fc57c0f89
b85a9096-4fb2-4d61-a9ff-de5ddbc122cc	ea6298eb-c495-43f0-9b47-81ee583acee5
b85a9096-4fb2-4d61-a9ff-de5ddbc122cc	0a4bcc97-9ec2-4dae-b11c-2d868623cb49
b85a9096-4fb2-4d61-a9ff-de5ddbc122cc	2badb32c-192a-457f-8eee-9aa548441cf4
b85a9096-4fb2-4d61-a9ff-de5ddbc122cc	aebacdd7-f06c-45a0-9854-9e12f2103902
b85a9096-4fb2-4d61-a9ff-de5ddbc122cc	24d6bdce-432d-481f-8417-f1b9fca3c745
54bab732-de98-4acc-b69f-8738383c06d2	8c6e25d5-1d1f-47fb-9888-894e04e4592c
54bab732-de98-4acc-b69f-8738383c06d2	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
54bab732-de98-4acc-b69f-8738383c06d2	f9b95515-f187-44dc-b2f7-62ec48ac88ce
54bab732-de98-4acc-b69f-8738383c06d2	530d1403-ff34-485d-8ee4-3f186f019bf7
9ecd6365-9d96-49bb-a656-c2ccab8653e2	15fb5a68-0e00-485f-96e8-c10a3dab8007
9ecd6365-9d96-49bb-a656-c2ccab8653e2	c8ac9256-7951-49b1-ae86-a41be7894406
9ecd6365-9d96-49bb-a656-c2ccab8653e2	a7396fa7-6c95-4712-a053-22f60d852f70
ab76a5ce-1b6e-429a-87d5-404757fa848c	1965ac82-4792-45e1-961a-1de7b843fc2f
ab76a5ce-1b6e-429a-87d5-404757fa848c	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
8c7e552a-5797-4dd1-a35b-85a265feeb3f	320ddf01-74b8-435e-953d-adfa64de928f
9f445d1d-8fa5-47d5-8d32-e8b860e61328	731f6403-66f6-46ee-bcdd-e69ed3618535
9f445d1d-8fa5-47d5-8d32-e8b860e61328	7e598b76-abda-4c64-852c-f7c048e85857
8c7e552a-5797-4dd1-a35b-85a265feeb3f	836d9050-ffc1-4dbe-a43d-fe7adbbd51fe
\.


--
-- Data for Name: community; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.community (community_id, uuid, admin, logo_bitstream_id) FROM stdin;
\N	e41ee777-daa9-4ad9-98a5-13425d1b23ed	\N	\N
\N	ba4336ee-0563-4b0b-84ea-d4d4fc99485e	\N	\N
\N	12a6f2d6-4eae-47c9-8bf4-54cf02c01335	\N	\N
\N	ddbcf1bb-b3eb-4a76-8936-912786ddbe79	\N	\N
\N	0d605059-7875-4b76-b70e-c49dc73c3dbe	\N	\N
\N	91ce1543-4a74-4c94-88dd-07986a7a676b	\N	\N
\.


--
-- Data for Name: community2collection; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.community2collection (collection_id, community_id) FROM stdin;
b7b1b7e1-3a94-439e-ade7-f9ef898e272f	e41ee777-daa9-4ad9-98a5-13425d1b23ed
e1e182b9-a464-49c6-89a9-7453f23404bd	e41ee777-daa9-4ad9-98a5-13425d1b23ed
9f445d1d-8fa5-47d5-8d32-e8b860e61328	ba4336ee-0563-4b0b-84ea-d4d4fc99485e
216554d5-e1c6-4975-be5d-16a435fdbdae	ba4336ee-0563-4b0b-84ea-d4d4fc99485e
f7019f5a-44ba-4a31-a105-b20cc4c20ae1	12a6f2d6-4eae-47c9-8bf4-54cf02c01335
38da3b9e-b576-4d9f-907c-ace9b09861c4	12a6f2d6-4eae-47c9-8bf4-54cf02c01335
fedb15df-f01e-40c5-816e-30aa1e8c6667	12a6f2d6-4eae-47c9-8bf4-54cf02c01335
b85a9096-4fb2-4d61-a9ff-de5ddbc122cc	12a6f2d6-4eae-47c9-8bf4-54cf02c01335
54bab732-de98-4acc-b69f-8738383c06d2	0d605059-7875-4b76-b70e-c49dc73c3dbe
9ecd6365-9d96-49bb-a656-c2ccab8653e2	0d605059-7875-4b76-b70e-c49dc73c3dbe
ab76a5ce-1b6e-429a-87d5-404757fa848c	0d605059-7875-4b76-b70e-c49dc73c3dbe
8c7e552a-5797-4dd1-a35b-85a265feeb3f	91ce1543-4a74-4c94-88dd-07986a7a676b
\.


--
-- Data for Name: community2community; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.community2community (parent_comm_id, child_comm_id) FROM stdin;
\.


--
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.course (uuid, euuid, cuuid) FROM stdin;
a5c0ce99-3434-468a-8352-25c746d78795	45b7341c-6031-4c5c-8383-7414a82fd8f0	9f445d1d-8fa5-47d5-8d32-e8b860e61328
6ba2845d-7b08-48ff-97f6-c54237814daf	45b7341c-6031-4c5c-8383-7414a82fd8f0	e1e182b9-a464-49c6-89a9-7453f23404bd
f143d054-0224-46af-8397-afc11c16003e	45b7341c-6031-4c5c-8383-7414a82fd8f0	9f445d1d-8fa5-47d5-8d32-e8b860e61328
\.


--
-- Name: course_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.course_seq', 1, false);


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.courses (euuid, cuuid) FROM stdin;
\.


--
-- Data for Name: doi; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.doi (doi_id, doi, resource_type_id, resource_id, status, dspace_object) FROM stdin;
\.


--
-- Name: doi_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.doi_seq', 1, false);


--
-- Data for Name: dspaceobject; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.dspaceobject (uuid) FROM stdin;
bf48e1de-50a2-4ae9-b1e5-456b09575be9
fb1abb97-cb7a-4f92-977a-d23e9effaecf
abc8a8a2-3228-4384-bb0e-7a7ffa931bd7
36781c80-74f3-427f-8569-d55321306d74
e41ee777-daa9-4ad9-98a5-13425d1b23ed
b7b1b7e1-3a94-439e-ade7-f9ef898e272f
77bfc801-e14b-4722-b5f2-23e1bea38444
e1e182b9-a464-49c6-89a9-7453f23404bd
910cd60d-b619-4a3c-a4da-65e3d2486a05
45b7341c-6031-4c5c-8383-7414a82fd8f0
ba4336ee-0563-4b0b-84ea-d4d4fc99485e
9f445d1d-8fa5-47d5-8d32-e8b860e61328
f42e991a-539b-4958-9b31-943990b49e3c
a5c0ce99-3434-468a-8352-25c746d78795
6ba2845d-7b08-48ff-97f6-c54237814daf
f143d054-0224-46af-8397-afc11c16003e
216554d5-e1c6-4975-be5d-16a435fdbdae
56973b4f-8b45-492b-b89c-2fa51b1126d7
7d72e5b6-7704-476f-9d38-8d5f261016c7
f4af25dc-153f-4958-a515-1cdf352d30e6
0b3af3ef-fc2c-4942-96b1-d2254e99201c
2c8bc593-9707-4c60-a079-792175fad7c2
e555b73c-4e0c-453a-bc10-e1509fa18348
495be94e-1eef-4a2e-9ed6-05efa3f2667a
b3ac2a4b-5443-4f61-be3b-a4f5760d7710
29805781-fa7a-438a-a500-7e4be2bf776c
0b6a3f7f-6ad7-4dbe-b300-1bb8ee8ee2a2
81a5ac06-022e-4b3e-a464-217ab669c7f3
12a6f2d6-4eae-47c9-8bf4-54cf02c01335
f7019f5a-44ba-4a31-a105-b20cc4c20ae1
d09cba3a-461b-4c6b-9c82-8b23ca6ac64e
3ba398cb-0399-41b2-98b7-2ed4220e4fa8
2ea7c2a4-41d5-4115-9afa-ce1a849cc6e5
13f9a2f9-b4e5-4366-bad1-83b82634d5a5
0fd12cd1-fb9f-4355-bf1d-9f95d42ecef5
b80d21bb-4aae-4ee3-824a-3f95395252d7
fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d
a1fce771-5353-4398-924c-045ed36e55c4
0c9082e8-8c4b-4ce0-bc2d-e739c9e814fa
4ae07e0e-4ddd-4d82-aab7-72ab37f67174
9da1785d-55d1-4e50-9df7-737c1c584855
a8b94f7f-986d-479b-80a4-a7b528984380
f49fd40d-fcf2-4815-9f24-083b794b4bd5
64fee389-1491-49e9-870c-88e74ef32a14
97b30dc1-de2c-4da2-a4c7-954ceb243951
bade7c98-10b6-4843-b443-44b6ed5acb04
a54bbc7b-59eb-4a38-849a-e43ef1b8304a
65bad344-2707-457e-b1ba-bee570972b87
ba7ce28a-f9aa-4ea8-99f1-75accb03e87c
8cc9da0c-2cee-418c-8cd2-d4065adbdbf7
b44dbb4d-a1cc-4a6b-98d5-fa739a1e083c
2499711d-8cf0-476d-9534-fe00f0475658
a93055cd-3253-4f73-bc2a-5b9b944afbe7
ca06fc2d-47e4-40c1-9909-6e527521c4ba
454bff8d-6deb-48ba-97f1-70c8a160b5c6
dbb996cf-0122-4e78-bf03-6f8c2322638c
38da3b9e-b576-4d9f-907c-ace9b09861c4
bb963c9f-808b-482e-85d7-1a719936c404
45d8b4dc-5da5-46af-a643-3143b6af9f13
1f036576-773c-4d03-9127-b4bba2eca4d5
15d4b547-ef7e-46ac-bee2-0977938520d4
8570e079-3966-4d74-af6d-1cd038b7dad9
f1ca61cf-b4fb-4d99-9b01-c6154bd04085
a8be8fdd-3a54-4e70-aa5c-56e24e9e403b
97af0899-be0a-427a-9c11-6a02776d0830
b5677909-694d-4b69-bdaa-66f81f894c1b
66e6f832-c292-402a-ad47-ee06ff5c9f87
5e355026-895b-4bdc-8fed-14d4779fc8aa
c39ad818-307a-4c7a-9672-4e8e85c0d624
a23a2a91-cd8d-4f0b-867d-c73e55c0598c
8c99d017-1503-4dfd-8066-0f5dc8ace132
f99b4579-1283-4026-8ff8-6f78dc0d2805
d4c1d98f-325c-45fa-b57b-16fcac56d5a5
3da62806-eab4-4e50-85f7-c27836c44a3b
f1a0e28e-b69d-419e-9649-43ca88e6bafa
ceedb68a-7731-43e3-96d0-ebed5acb3241
cdc0ef88-260d-461a-9c2e-494e93909912
ae3cb1cb-0353-47a8-800c-0d9eb3347f42
fedb15df-f01e-40c5-816e-30aa1e8c6667
1cc4d7b9-08ca-48cf-a63f-bb6e8ab40703
53894fe9-2e5a-4cc0-a1a6-0fda50fcae49
762771f7-2ebd-466f-9760-39375d35f186
f4c6f687-6237-4363-8242-9d64a1c519ef
7ea26c6a-9885-47f0-9995-38f0aed9cd91
4c513e51-f52d-4655-acef-a93cec34fedb
75e52dde-8992-4237-9b42-7004977bd3d7
87f81a7c-1224-4b6e-8017-8cae299f6988
864216a8-2cc4-4796-bd22-b14eb1b71e85
07c4f7ff-069a-4fde-8620-aa70b4156f54
bce59918-0051-4f67-af90-a9c05e36efd8
89010e0b-74f4-43f9-be0d-f6b83045feb7
7439b012-2aac-42f1-b73d-d249a9d64e40
2522b4b7-99b8-48fb-9206-d658e4672baa
96ff33e7-2956-48ea-af67-2f5366ae3191
6daaa47a-986c-42f5-ae59-b49fd3ca5c19
fa1c2a6a-f594-4746-934c-f901c60f2d5a
c0079563-57d3-4efc-a576-e6ea19f5a8d7
b60be1f9-c245-49d4-8fbb-aa98ef07c01e
dcaae3de-8a3c-4f5f-adad-32b869c47f74
993c2eda-5a7e-4c77-b845-a8fbc12b782a
c636ac62-1683-4b64-a42c-c38fc57c0f89
815fed71-ea32-4bf7-8b87-137ce9894d24
7c48b00e-ddab-4a40-af07-8e9fc6a651d9
ff92dae9-5899-4088-8459-af661f0dd874
08d106a8-1ffc-42e2-9345-cdbbf5e25640
b85a9096-4fb2-4d61-a9ff-de5ddbc122cc
2bcbb4bb-1b0c-43ae-9ed0-d4027bd1f9ab
ea6298eb-c495-43f0-9b47-81ee583acee5
32fdc0cb-eb32-405e-bb25-3b6fbdd584e1
b0fd981f-85b2-46f0-a1a6-8670732577d9
d50a4391-97bd-443b-8a35-b8f3558509ae
c9fb30a3-6e29-48f4-836e-8241805c086d
0a4bcc97-9ec2-4dae-b11c-2d868623cb49
9d4327b4-82d3-41c6-b291-43a7e13133f3
fb4f2a26-b5b1-4757-8e79-b786f0e8a46b
7dd0e346-25c3-461f-b02e-2b3f853abe00
827bffbd-a853-4955-a0ef-f285241bedfc
2badb32c-192a-457f-8eee-9aa548441cf4
a1f8f03a-1fae-43c9-b85d-5edd6742876d
5a4943d5-155f-4ba9-ac21-a1c42db7624b
b2b82808-7008-4b71-b3f0-c2def986c957
cf56643a-2485-499f-96e4-08970d0b625f
aebacdd7-f06c-45a0-9854-9e12f2103902
bf1beb12-c719-4a7e-997e-dc13d5534198
62864ee6-212d-4336-aa23-10b53876c33f
7ef63ce2-b0cc-47c2-97c7-74c9cf2c927f
481daa37-0f1d-4fba-ba2a-091e703471d0
24d6bdce-432d-481f-8417-f1b9fca3c745
8331723c-d2b7-4274-a3f0-ab6c8c782fcb
27faba85-6cd4-4258-afd0-0ad4e8c60ee3
6f4f1048-3377-42ca-bce0-70923275a958
288c7b7f-5138-40cf-8922-3fcc9521b868
ddbcf1bb-b3eb-4a76-8936-912786ddbe79
0d605059-7875-4b76-b70e-c49dc73c3dbe
54bab732-de98-4acc-b69f-8738383c06d2
8122dbec-aaa3-45d2-b3f3-d526bdafd332
8c6e25d5-1d1f-47fb-9888-894e04e4592c
ebe553b5-6c77-4f47-b14f-c55fcfbb243f
b8362c84-61d5-4c54-9b93-6903dc7af6c3
8aede5fb-4458-414d-ac6b-fe62210c70f8
b71d3b0c-7bbd-4413-bea7-7d9cd8aaf50a
7e3b76e4-dffe-42b2-9860-ffc46eb37d11
19727d4e-ea29-4695-ba0f-ef42a24e7d2b
f73aec6a-8837-4fbd-bdc7-a5cac842a210
076a0596-b1d7-4db4-a5f0-b8cf8ff524df
1c315c05-38b9-4642-be4b-e2d231bb1169
f9b95515-f187-44dc-b2f7-62ec48ac88ce
b59b4e13-6b97-4759-9d11-d6f4f0044cce
06c28b52-5b08-4aac-b946-7db8e024b91a
b961e9d0-2b79-4802-843e-05b3b929c1a3
58311eb7-934a-4410-bae3-b8371355d96b
530d1403-ff34-485d-8ee4-3f186f019bf7
1ec8dff4-d4ff-42c3-a9e6-54744d5bc6f8
7109a357-c47f-4b04-a2a7-fee0c0b92f6d
36d8c81e-90c2-43cc-b881-78122115f2e1
2634c301-12e5-418e-9fbb-ab0b9561aafc
9ecd6365-9d96-49bb-a656-c2ccab8653e2
f4e3955f-89f4-4169-8f63-ba561e510f51
15fb5a68-0e00-485f-96e8-c10a3dab8007
f4de32b9-043d-4b0f-b400-86fa3df1fb01
60b58afa-a7ce-4ca2-91ad-607fbc0264c0
d2896b5f-1280-4fcd-8a57-3709f3ddb817
6234b407-7244-4b13-b9d8-9652ce66a0ca
c8ac9256-7951-49b1-ae86-a41be7894406
da8c4a2a-1001-45f6-a3ea-33abedf18e74
c7d9baf3-edb7-42d9-b3cd-d32eba23954c
fd787dfc-ee8f-4463-a69d-fad1db917bdd
617a3a58-26b1-4992-bb50-0a484bfedadf
a7396fa7-6c95-4712-a053-22f60d852f70
48616940-8e7c-44d1-9ca7-1fb58dc561d0
bf8d7f49-ab53-4056-bcde-3fa29c87b9a4
f91fbf0e-92c9-4ceb-b35c-748bfd9e277f
bc67c574-d6d7-42f3-be29-a557a17bac5b
ab76a5ce-1b6e-429a-87d5-404757fa848c
9827a165-99c8-4b82-ac73-53f919703a4c
1965ac82-4792-45e1-961a-1de7b843fc2f
3d5c95b0-1727-45a0-b0c5-a3835e80ef6c
51dd5697-85ee-43f1-bcf3-ccbe02cf84e1
87b2bbe8-4dc4-4f1f-9abb-c04562fb4feb
d73be20c-529c-4c77-9b21-365090f576c2
2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
482e7f8c-7687-46c3-826d-fd1939ea3bbc
aef9672a-a17e-4448-8163-46185e0daa6b
97622e69-6bb7-4f81-bc71-5de1ab7aa10e
02e23fc3-0aad-4f54-a65c-b19cc9bf2ecb
91ce1543-4a74-4c94-88dd-07986a7a676b
8c7e552a-5797-4dd1-a35b-85a265feeb3f
0f0ad925-a61d-41a8-accc-4579e9666128
320ddf01-74b8-435e-953d-adfa64de928f
670e9a5a-7cb8-40f1-a42e-71207489aa2b
050db052-de7e-48b1-90c7-3498e746d313
7ab42eaa-6ee8-4ffb-bc49-b48e71f893ea
453c6c0c-2699-4fec-b0f9-5a2752bd330d
c60dc41d-0a57-4cb9-8023-26f096e32efb
202b3483-3fec-47ac-a4f3-3274a4049977
731f6403-66f6-46ee-bcdd-e69ed3618535
28bebfa8-ac05-442e-aac5-10e1ee16ab40
495f0e71-7700-4890-9620-ea230a0af6fa
552b54d4-5c5b-4c2a-be8b-d6f342103e8d
429a7a03-d91e-486a-ba01-e393fc4a6dde
7e598b76-abda-4c64-852c-f7c048e85857
b9e1bdac-f069-4a5f-bf4e-dcaaa909dee8
aed10948-cd76-49b8-8e67-ba356412c132
271a2f04-3526-4d6f-86e5-5bd3f616576d
375184f3-d51d-4536-9f46-833aa8e2ec1e
8a1952f5-fbf7-4888-9d3c-e15c9e738991
836d9050-ffc1-4dbe-a43d-fe7adbbd51fe
e545724e-fb31-44a6-8266-91cf0dac072f
5bf01747-4b30-4677-9ae5-8cf781e37adf
d4a63d5c-7c0d-44f2-b105-882cdb6d9c09
71a60c46-7112-449c-a1f2-3fc619e67787
\.


--
-- Data for Name: eperson; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.eperson (eperson_id, email, password, can_log_in, require_certificate, self_registered, last_active, sub_frequency, netid, salt, digest_algorithm, uuid) FROM stdin;
\N	mudrasahu1997@gmail.com	7a911e9babb47f04d09611580826ce9dc9f12bbae702bc928905ca23662ae6e62ee425c94d7244585c7ced3f7504e663e0632152e63356c1896e3726ffbd3610	t	f	f	2018-07-12 14:50:33.496	\N	\N	3262d07f447c0f8d6aded4ddd05877fd	SHA-512	36781c80-74f3-427f-8569-d55321306d74
\N	abc@localhost	736c9cd74542557c0ad9ae75c060915516621c89e0a1c6cc2eec00edade5038539db4a9a31ef61698df3e5b2465287a494b3347bcc44a600b33f2fc3a5e21c0a	t	f	f	2018-07-12 14:52:20.423	\N	\N	3c90dead0ce7faac91bfbbdd69d89e5b	SHA-512	45b7341c-6031-4c5c-8383-7414a82fd8f0
\.


--
-- Data for Name: epersongroup; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.epersongroup (eperson_group_id, uuid, permanent, name) FROM stdin;
\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	t	Anonymous
\N	fb1abb97-cb7a-4f92-977a-d23e9effaecf	t	Administrator
\N	77bfc801-e14b-4722-b5f2-23e1bea38444	f	COLLECTION_b7b1b7e1-3a94-439e-ade7-f9ef898e272f_SUBMIT
\N	910cd60d-b619-4a3c-a4da-65e3d2486a05	f	COLLECTION_e1e182b9-a464-49c6-89a9-7453f23404bd_SUBMIT
\N	f42e991a-539b-4958-9b31-943990b49e3c	f	COLLECTION_9f445d1d-8fa5-47d5-8d32-e8b860e61328_SUBMIT
\N	56973b4f-8b45-492b-b89c-2fa51b1126d7	f	COLLECTION_216554d5-e1c6-4975-be5d-16a435fdbdae_SUBMIT
\N	d09cba3a-461b-4c6b-9c82-8b23ca6ac64e	f	COLLECTION_f7019f5a-44ba-4a31-a105-b20cc4c20ae1_SUBMIT
\N	bb963c9f-808b-482e-85d7-1a719936c404	f	COLLECTION_38da3b9e-b576-4d9f-907c-ace9b09861c4_SUBMIT
\N	1cc4d7b9-08ca-48cf-a63f-bb6e8ab40703	f	COLLECTION_fedb15df-f01e-40c5-816e-30aa1e8c6667_SUBMIT
\N	2bcbb4bb-1b0c-43ae-9ed0-d4027bd1f9ab	f	COLLECTION_b85a9096-4fb2-4d61-a9ff-de5ddbc122cc_SUBMIT
\N	8122dbec-aaa3-45d2-b3f3-d526bdafd332	f	COLLECTION_54bab732-de98-4acc-b69f-8738383c06d2_SUBMIT
\N	f4e3955f-89f4-4169-8f63-ba561e510f51	f	COLLECTION_9ecd6365-9d96-49bb-a656-c2ccab8653e2_SUBMIT
\N	9827a165-99c8-4b82-ac73-53f919703a4c	f	COLLECTION_ab76a5ce-1b6e-429a-87d5-404757fa848c_SUBMIT
\N	0f0ad925-a61d-41a8-accc-4579e9666128	f	COLLECTION_8c7e552a-5797-4dd1-a35b-85a265feeb3f_SUBMIT
\.


--
-- Data for Name: epersongroup2eperson; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.epersongroup2eperson (eperson_group_id, eperson_id) FROM stdin;
fb1abb97-cb7a-4f92-977a-d23e9effaecf	36781c80-74f3-427f-8569-d55321306d74
\.


--
-- Data for Name: epersongroup2workspaceitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.epersongroup2workspaceitem (workspace_item_id, eperson_group_id) FROM stdin;
\.


--
-- Data for Name: fileextension; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.fileextension (file_extension_id, bitstream_format_id, extension) FROM stdin;
1	4	pdf
2	5	xml
3	6	txt
4	6	asc
5	7	htm
6	7	html
7	8	css
8	9	doc
9	10	docx
10	11	ppt
11	12	pptx
12	13	xls
13	14	xlsx
14	16	jpeg
15	16	jpg
16	17	gif
17	18	png
18	19	tiff
19	19	tif
20	20	aiff
21	20	aif
22	20	aifc
23	21	au
24	21	snd
25	22	wav
26	23	mpeg
27	23	mpg
28	23	mpe
29	24	rtf
30	25	vsd
31	26	fm
32	27	bmp
33	28	psd
34	28	pdd
35	29	ps
36	29	eps
37	29	ai
38	30	mov
39	30	qt
40	31	mpa
41	31	abs
42	31	mpega
43	32	mpp
44	32	mpx
45	32	mpd
46	33	ma
47	34	latex
48	35	tex
49	36	dvi
50	37	sgm
51	37	sgml
52	38	wpd
53	39	ra
54	39	ram
55	40	pcd
56	41	odt
57	42	ott
58	43	oth
59	44	odm
60	45	odg
61	46	otg
62	47	odp
63	48	otp
64	49	ods
65	50	ots
66	51	odc
67	52	odf
68	53	odb
69	54	odi
70	55	oxt
71	56	sxw
72	57	stw
73	58	sxc
74	59	stc
75	60	sxd
76	61	std
77	62	sxi
78	63	sti
79	64	sxg
80	65	sxm
81	66	sdw
82	67	sgl
83	68	sdc
84	69	sda
85	70	sdd
86	71	sdp
87	72	smf
88	73	sds
89	74	sdm
90	75	rdf
91	76	epub
\.


--
-- Name: fileextension_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.fileextension_seq', 91, true);


--
-- Data for Name: group2group; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.group2group (parent_id, child_id) FROM stdin;
\.


--
-- Data for Name: group2groupcache; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.group2groupcache (parent_id, child_id) FROM stdin;
\.


--
-- Data for Name: handle; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.handle (handle_id, handle, resource_type_id, resource_legacy_id, resource_id) FROM stdin;
1	123456789/0	5	\N	abc8a8a2-3228-4384-bb0e-7a7ffa931bd7
2	123456789/1	4	\N	e41ee777-daa9-4ad9-98a5-13425d1b23ed
3	123456789/2	3	\N	b7b1b7e1-3a94-439e-ade7-f9ef898e272f
4	123456789/3	3	\N	e1e182b9-a464-49c6-89a9-7453f23404bd
5	123456789/4	4	\N	ba4336ee-0563-4b0b-84ea-d4d4fc99485e
6	123456789/5	3	\N	9f445d1d-8fa5-47d5-8d32-e8b860e61328
7	123456789/6	3	\N	216554d5-e1c6-4975-be5d-16a435fdbdae
9	123456789/8	4	\N	12a6f2d6-4eae-47c9-8bf4-54cf02c01335
10	123456789/9	3	\N	f7019f5a-44ba-4a31-a105-b20cc4c20ae1
11	123456789/10	2	\N	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
12	123456789/11	2	\N	fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d
13	123456789/12	2	\N	a8b94f7f-986d-479b-80a4-a7b528984380
14	123456789/13	2	\N	a54bbc7b-59eb-4a38-849a-e43ef1b8304a
15	123456789/14	2	\N	2499711d-8cf0-476d-9534-fe00f0475658
16	123456789/15	3	\N	38da3b9e-b576-4d9f-907c-ace9b09861c4
17	123456789/16	2	\N	45d8b4dc-5da5-46af-a643-3143b6af9f13
18	123456789/17	2	\N	a8be8fdd-3a54-4e70-aa5c-56e24e9e403b
19	123456789/18	2	\N	c39ad818-307a-4c7a-9672-4e8e85c0d624
20	123456789/19	2	\N	3da62806-eab4-4e50-85f7-c27836c44a3b
21	123456789/20	3	\N	fedb15df-f01e-40c5-816e-30aa1e8c6667
22	123456789/21	2	\N	53894fe9-2e5a-4cc0-a1a6-0fda50fcae49
23	123456789/22	2	\N	75e52dde-8992-4237-9b42-7004977bd3d7
24	123456789/23	2	\N	89010e0b-74f4-43f9-be0d-f6b83045feb7
25	123456789/24	2	\N	fa1c2a6a-f594-4746-934c-f901c60f2d5a
26	123456789/25	2	\N	c636ac62-1683-4b64-a42c-c38fc57c0f89
27	123456789/26	3	\N	b85a9096-4fb2-4d61-a9ff-de5ddbc122cc
28	123456789/27	2	\N	ea6298eb-c495-43f0-9b47-81ee583acee5
29	123456789/28	2	\N	0a4bcc97-9ec2-4dae-b11c-2d868623cb49
30	123456789/29	2	\N	2badb32c-192a-457f-8eee-9aa548441cf4
31	123456789/30	2	\N	aebacdd7-f06c-45a0-9854-9e12f2103902
32	123456789/31	2	\N	24d6bdce-432d-481f-8417-f1b9fca3c745
33	123456789/32	4	\N	ddbcf1bb-b3eb-4a76-8936-912786ddbe79
34	123456789/33	3	\N	\N
35	123456789/34	4	\N	0d605059-7875-4b76-b70e-c49dc73c3dbe
36	123456789/35	3	\N	54bab732-de98-4acc-b69f-8738383c06d2
37	123456789/36	2	\N	8c6e25d5-1d1f-47fb-9888-894e04e4592c
38	123456789/37	2	\N	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
39	123456789/38	2	\N	f9b95515-f187-44dc-b2f7-62ec48ac88ce
40	123456789/39	2	\N	530d1403-ff34-485d-8ee4-3f186f019bf7
41	123456789/40	3	\N	9ecd6365-9d96-49bb-a656-c2ccab8653e2
42	123456789/41	2	\N	15fb5a68-0e00-485f-96e8-c10a3dab8007
43	123456789/42	2	\N	c8ac9256-7951-49b1-ae86-a41be7894406
44	123456789/43	2	\N	a7396fa7-6c95-4712-a053-22f60d852f70
45	123456789/44	3	\N	ab76a5ce-1b6e-429a-87d5-404757fa848c
46	123456789/45	2	\N	1965ac82-4792-45e1-961a-1de7b843fc2f
47	123456789/46	2	\N	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
48	123456789/47	4	\N	91ce1543-4a74-4c94-88dd-07986a7a676b
49	123456789/48	3	\N	8c7e552a-5797-4dd1-a35b-85a265feeb3f
50	123456789/49	2	\N	320ddf01-74b8-435e-953d-adfa64de928f
8	123456789/7	2	\N	\N
51	123456789/50	2	\N	731f6403-66f6-46ee-bcdd-e69ed3618535
52	123456789/51	2	\N	7e598b76-abda-4c64-852c-f7c048e85857
55	123456789/54	2	\N	836d9050-ffc1-4dbe-a43d-fe7adbbd51fe
\.


--
-- Name: handle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.handle_id_seq', 55, true);


--
-- Name: handle_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.handle_seq', 54, true);


--
-- Data for Name: harvested_collection; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.harvested_collection (harvest_type, oai_source, oai_set_id, harvest_message, metadata_config_id, harvest_status, harvest_start_time, last_harvested, id, collection_id) FROM stdin;
\.


--
-- Name: harvested_collection_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.harvested_collection_seq', 1, false);


--
-- Data for Name: harvested_item; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.harvested_item (last_harvested, oai_id, id, item_id) FROM stdin;
\.


--
-- Name: harvested_item_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.harvested_item_seq', 1, false);


--
-- Name: history_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.history_seq', 1, false);


--
-- Data for Name: item; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.item (item_id, in_archive, withdrawn, last_modified, discoverable, uuid, submitter_id, owning_collection) FROM stdin;
\N	t	f	2018-06-22 11:25:03.028+05:30	t	a7396fa7-6c95-4712-a053-22f60d852f70	36781c80-74f3-427f-8569-d55321306d74	9ecd6365-9d96-49bb-a656-c2ccab8653e2
\N	t	f	2018-06-22 11:14:35.071+05:30	t	7e3b76e4-dffe-42b2-9860-ffc46eb37d11	36781c80-74f3-427f-8569-d55321306d74	54bab732-de98-4acc-b69f-8738383c06d2
\N	t	f	2018-06-21 22:50:55.917+05:30	t	53894fe9-2e5a-4cc0-a1a6-0fda50fcae49	36781c80-74f3-427f-8569-d55321306d74	fedb15df-f01e-40c5-816e-30aa1e8c6667
\N	t	f	2018-06-21 23:04:14.559+05:30	t	c636ac62-1683-4b64-a42c-c38fc57c0f89	36781c80-74f3-427f-8569-d55321306d74	fedb15df-f01e-40c5-816e-30aa1e8c6667
\N	t	f	2018-06-21 23:36:35.322+05:30	t	0a4bcc97-9ec2-4dae-b11c-2d868623cb49	36781c80-74f3-427f-8569-d55321306d74	b85a9096-4fb2-4d61-a9ff-de5ddbc122cc
\N	t	f	2018-06-21 23:00:22.161+05:30	t	89010e0b-74f4-43f9-be0d-f6b83045feb7	36781c80-74f3-427f-8569-d55321306d74	fedb15df-f01e-40c5-816e-30aa1e8c6667
\N	t	f	2018-06-21 22:24:09.446+05:30	t	a8b94f7f-986d-479b-80a4-a7b528984380	36781c80-74f3-427f-8569-d55321306d74	f7019f5a-44ba-4a31-a105-b20cc4c20ae1
\N	t	f	2018-06-25 11:25:57.666+05:30	t	7e598b76-abda-4c64-852c-f7c048e85857	36781c80-74f3-427f-8569-d55321306d74	9f445d1d-8fa5-47d5-8d32-e8b860e61328
\N	t	f	2018-06-21 22:39:28.179+05:30	t	c39ad818-307a-4c7a-9672-4e8e85c0d624	36781c80-74f3-427f-8569-d55321306d74	38da3b9e-b576-4d9f-907c-ace9b09861c4
\N	t	f	2018-06-21 22:14:42.195+05:30	t	3ba398cb-0399-41b2-98b7-2ed4220e4fa8	36781c80-74f3-427f-8569-d55321306d74	f7019f5a-44ba-4a31-a105-b20cc4c20ae1
\N	t	f	2018-06-21 23:40:58.892+05:30	t	aebacdd7-f06c-45a0-9854-9e12f2103902	36781c80-74f3-427f-8569-d55321306d74	b85a9096-4fb2-4d61-a9ff-de5ddbc122cc
\N	f	f	2018-06-20 11:55:10.869+05:30	t	7d72e5b6-7704-476f-9d38-8d5f261016c7	36781c80-74f3-427f-8569-d55321306d74	\N
\N	t	f	2018-06-21 22:35:13.865+05:30	t	45d8b4dc-5da5-46af-a643-3143b6af9f13	36781c80-74f3-427f-8569-d55321306d74	38da3b9e-b576-4d9f-907c-ace9b09861c4
\N	t	f	2018-06-22 11:35:20.253+05:30	t	320ddf01-74b8-435e-953d-adfa64de928f	36781c80-74f3-427f-8569-d55321306d74	8c7e552a-5797-4dd1-a35b-85a265feeb3f
\N	f	f	2018-06-20 12:08:40.71+05:30	t	2c8bc593-9707-4c60-a079-792175fad7c2	36781c80-74f3-427f-8569-d55321306d74	\N
\N	t	f	2018-06-21 22:57:35.878+05:30	t	75e52dde-8992-4237-9b42-7004977bd3d7	36781c80-74f3-427f-8569-d55321306d74	fedb15df-f01e-40c5-816e-30aa1e8c6667
\N	f	f	2018-06-20 12:09:25.104+05:30	t	e555b73c-4e0c-453a-bc10-e1509fa18348	36781c80-74f3-427f-8569-d55321306d74	\N
\N	t	f	2018-06-21 22:27:01.445+05:30	t	a54bbc7b-59eb-4a38-849a-e43ef1b8304a	36781c80-74f3-427f-8569-d55321306d74	f7019f5a-44ba-4a31-a105-b20cc4c20ae1
\N	t	f	2018-06-22 11:23:17.435+05:30	t	c8ac9256-7951-49b1-ae86-a41be7894406	36781c80-74f3-427f-8569-d55321306d74	9ecd6365-9d96-49bb-a656-c2ccab8653e2
\N	f	f	2018-06-20 12:13:03.565+05:30	t	29805781-fa7a-438a-a500-7e4be2bf776c	36781c80-74f3-427f-8569-d55321306d74	\N
\N	t	f	2018-06-21 23:34:55.212+05:30	t	ea6298eb-c495-43f0-9b47-81ee583acee5	36781c80-74f3-427f-8569-d55321306d74	b85a9096-4fb2-4d61-a9ff-de5ddbc122cc
\N	t	f	2018-06-21 22:19:42.417+05:30	t	fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d	36781c80-74f3-427f-8569-d55321306d74	f7019f5a-44ba-4a31-a105-b20cc4c20ae1
\N	t	f	2018-06-22 11:18:27.778+05:30	t	530d1403-ff34-485d-8ee4-3f186f019bf7	36781c80-74f3-427f-8569-d55321306d74	54bab732-de98-4acc-b69f-8738383c06d2
\N	t	f	2018-06-21 22:42:13.73+05:30	t	3da62806-eab4-4e50-85f7-c27836c44a3b	36781c80-74f3-427f-8569-d55321306d74	38da3b9e-b576-4d9f-907c-ace9b09861c4
\N	t	f	2018-06-22 11:11:49.022+05:30	t	8c6e25d5-1d1f-47fb-9888-894e04e4592c	36781c80-74f3-427f-8569-d55321306d74	54bab732-de98-4acc-b69f-8738383c06d2
\N	t	f	2018-06-21 23:02:10.013+05:30	t	fa1c2a6a-f594-4746-934c-f901c60f2d5a	36781c80-74f3-427f-8569-d55321306d74	fedb15df-f01e-40c5-816e-30aa1e8c6667
\N	t	f	2018-06-21 23:38:47.146+05:30	t	2badb32c-192a-457f-8eee-9aa548441cf4	36781c80-74f3-427f-8569-d55321306d74	b85a9096-4fb2-4d61-a9ff-de5ddbc122cc
\N	f	f	2018-06-22 11:59:02.909+05:30	t	c60dc41d-0a57-4cb9-8023-26f096e32efb	36781c80-74f3-427f-8569-d55321306d74	\N
\N	t	f	2018-06-22 11:16:29.015+05:30	t	f9b95515-f187-44dc-b2f7-62ec48ac88ce	36781c80-74f3-427f-8569-d55321306d74	54bab732-de98-4acc-b69f-8738383c06d2
\N	t	f	2018-06-21 23:42:58.651+05:30	t	24d6bdce-432d-481f-8417-f1b9fca3c745	36781c80-74f3-427f-8569-d55321306d74	b85a9096-4fb2-4d61-a9ff-de5ddbc122cc
\N	t	f	2018-06-22 12:42:31.883+05:30	t	731f6403-66f6-46ee-bcdd-e69ed3618535	36781c80-74f3-427f-8569-d55321306d74	9f445d1d-8fa5-47d5-8d32-e8b860e61328
\N	t	f	2018-06-22 11:30:56.436+05:30	t	1965ac82-4792-45e1-961a-1de7b843fc2f	36781c80-74f3-427f-8569-d55321306d74	ab76a5ce-1b6e-429a-87d5-404757fa848c
\N	t	f	2018-06-21 22:30:00.488+05:30	t	2499711d-8cf0-476d-9534-fe00f0475658	36781c80-74f3-427f-8569-d55321306d74	f7019f5a-44ba-4a31-a105-b20cc4c20ae1
\N	t	f	2018-06-22 11:32:16.072+05:30	t	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0	36781c80-74f3-427f-8569-d55321306d74	ab76a5ce-1b6e-429a-87d5-404757fa848c
\N	t	f	2018-06-21 22:37:42.698+05:30	t	a8be8fdd-3a54-4e70-aa5c-56e24e9e403b	36781c80-74f3-427f-8569-d55321306d74	38da3b9e-b576-4d9f-907c-ace9b09861c4
\N	f	f	2018-06-22 11:59:52.243+05:30	t	202b3483-3fec-47ac-a4f3-3274a4049977	36781c80-74f3-427f-8569-d55321306d74	\N
\N	f	f	2018-06-29 15:07:42.283+05:30	t	8a1952f5-fbf7-4888-9d3c-e15c9e738991	36781c80-74f3-427f-8569-d55321306d74	\N
\N	t	f	2018-06-22 11:20:59.786+05:30	t	15fb5a68-0e00-485f-96e8-c10a3dab8007	36781c80-74f3-427f-8569-d55321306d74	9ecd6365-9d96-49bb-a656-c2ccab8653e2
\N	t	f	2018-07-02 15:08:31.365+05:30	t	836d9050-ffc1-4dbe-a43d-fe7adbbd51fe	36781c80-74f3-427f-8569-d55321306d74	8c7e552a-5797-4dd1-a35b-85a265feeb3f
\.


--
-- Data for Name: item2bundle; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.item2bundle (bundle_id, item_id) FROM stdin;
f4af25dc-153f-4958-a515-1cdf352d30e6	7d72e5b6-7704-476f-9d38-8d5f261016c7
495be94e-1eef-4a2e-9ed6-05efa3f2667a	e555b73c-4e0c-453a-bc10-e1509fa18348
2ea7c2a4-41d5-4115-9afa-ce1a849cc6e5	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
0fd12cd1-fb9f-4355-bf1d-9f95d42ecef5	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
a1fce771-5353-4398-924c-045ed36e55c4	fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d
4ae07e0e-4ddd-4d82-aab7-72ab37f67174	fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d
f49fd40d-fcf2-4815-9f24-083b794b4bd5	a8b94f7f-986d-479b-80a4-a7b528984380
97b30dc1-de2c-4da2-a4c7-954ceb243951	a8b94f7f-986d-479b-80a4-a7b528984380
65bad344-2707-457e-b1ba-bee570972b87	a54bbc7b-59eb-4a38-849a-e43ef1b8304a
8cc9da0c-2cee-418c-8cd2-d4065adbdbf7	a54bbc7b-59eb-4a38-849a-e43ef1b8304a
a93055cd-3253-4f73-bc2a-5b9b944afbe7	2499711d-8cf0-476d-9534-fe00f0475658
454bff8d-6deb-48ba-97f1-70c8a160b5c6	2499711d-8cf0-476d-9534-fe00f0475658
1f036576-773c-4d03-9127-b4bba2eca4d5	45d8b4dc-5da5-46af-a643-3143b6af9f13
8570e079-3966-4d74-af6d-1cd038b7dad9	45d8b4dc-5da5-46af-a643-3143b6af9f13
97af0899-be0a-427a-9c11-6a02776d0830	a8be8fdd-3a54-4e70-aa5c-56e24e9e403b
66e6f832-c292-402a-ad47-ee06ff5c9f87	a8be8fdd-3a54-4e70-aa5c-56e24e9e403b
a23a2a91-cd8d-4f0b-867d-c73e55c0598c	c39ad818-307a-4c7a-9672-4e8e85c0d624
f99b4579-1283-4026-8ff8-6f78dc0d2805	c39ad818-307a-4c7a-9672-4e8e85c0d624
f1a0e28e-b69d-419e-9649-43ca88e6bafa	3da62806-eab4-4e50-85f7-c27836c44a3b
cdc0ef88-260d-461a-9c2e-494e93909912	3da62806-eab4-4e50-85f7-c27836c44a3b
762771f7-2ebd-466f-9760-39375d35f186	53894fe9-2e5a-4cc0-a1a6-0fda50fcae49
7ea26c6a-9885-47f0-9995-38f0aed9cd91	53894fe9-2e5a-4cc0-a1a6-0fda50fcae49
87f81a7c-1224-4b6e-8017-8cae299f6988	75e52dde-8992-4237-9b42-7004977bd3d7
07c4f7ff-069a-4fde-8620-aa70b4156f54	75e52dde-8992-4237-9b42-7004977bd3d7
7439b012-2aac-42f1-b73d-d249a9d64e40	89010e0b-74f4-43f9-be0d-f6b83045feb7
96ff33e7-2956-48ea-af67-2f5366ae3191	89010e0b-74f4-43f9-be0d-f6b83045feb7
c0079563-57d3-4efc-a576-e6ea19f5a8d7	fa1c2a6a-f594-4746-934c-f901c60f2d5a
dcaae3de-8a3c-4f5f-adad-32b869c47f74	fa1c2a6a-f594-4746-934c-f901c60f2d5a
815fed71-ea32-4bf7-8b87-137ce9894d24	c636ac62-1683-4b64-a42c-c38fc57c0f89
ff92dae9-5899-4088-8459-af661f0dd874	c636ac62-1683-4b64-a42c-c38fc57c0f89
32fdc0cb-eb32-405e-bb25-3b6fbdd584e1	ea6298eb-c495-43f0-9b47-81ee583acee5
d50a4391-97bd-443b-8a35-b8f3558509ae	ea6298eb-c495-43f0-9b47-81ee583acee5
9d4327b4-82d3-41c6-b291-43a7e13133f3	0a4bcc97-9ec2-4dae-b11c-2d868623cb49
7dd0e346-25c3-461f-b02e-2b3f853abe00	0a4bcc97-9ec2-4dae-b11c-2d868623cb49
a1f8f03a-1fae-43c9-b85d-5edd6742876d	2badb32c-192a-457f-8eee-9aa548441cf4
b2b82808-7008-4b71-b3f0-c2def986c957	2badb32c-192a-457f-8eee-9aa548441cf4
bf1beb12-c719-4a7e-997e-dc13d5534198	aebacdd7-f06c-45a0-9854-9e12f2103902
7ef63ce2-b0cc-47c2-97c7-74c9cf2c927f	aebacdd7-f06c-45a0-9854-9e12f2103902
8331723c-d2b7-4274-a3f0-ab6c8c782fcb	24d6bdce-432d-481f-8417-f1b9fca3c745
6f4f1048-3377-42ca-bce0-70923275a958	24d6bdce-432d-481f-8417-f1b9fca3c745
ebe553b5-6c77-4f47-b14f-c55fcfbb243f	8c6e25d5-1d1f-47fb-9888-894e04e4592c
8aede5fb-4458-414d-ac6b-fe62210c70f8	8c6e25d5-1d1f-47fb-9888-894e04e4592c
19727d4e-ea29-4695-ba0f-ef42a24e7d2b	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
076a0596-b1d7-4db4-a5f0-b8cf8ff524df	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
b59b4e13-6b97-4759-9d11-d6f4f0044cce	f9b95515-f187-44dc-b2f7-62ec48ac88ce
b961e9d0-2b79-4802-843e-05b3b929c1a3	f9b95515-f187-44dc-b2f7-62ec48ac88ce
1ec8dff4-d4ff-42c3-a9e6-54744d5bc6f8	530d1403-ff34-485d-8ee4-3f186f019bf7
36d8c81e-90c2-43cc-b881-78122115f2e1	530d1403-ff34-485d-8ee4-3f186f019bf7
f4de32b9-043d-4b0f-b400-86fa3df1fb01	15fb5a68-0e00-485f-96e8-c10a3dab8007
d2896b5f-1280-4fcd-8a57-3709f3ddb817	15fb5a68-0e00-485f-96e8-c10a3dab8007
da8c4a2a-1001-45f6-a3ea-33abedf18e74	c8ac9256-7951-49b1-ae86-a41be7894406
fd787dfc-ee8f-4463-a69d-fad1db917bdd	c8ac9256-7951-49b1-ae86-a41be7894406
48616940-8e7c-44d1-9ca7-1fb58dc561d0	a7396fa7-6c95-4712-a053-22f60d852f70
f91fbf0e-92c9-4ceb-b35c-748bfd9e277f	a7396fa7-6c95-4712-a053-22f60d852f70
3d5c95b0-1727-45a0-b0c5-a3835e80ef6c	1965ac82-4792-45e1-961a-1de7b843fc2f
87b2bbe8-4dc4-4f1f-9abb-c04562fb4feb	1965ac82-4792-45e1-961a-1de7b843fc2f
482e7f8c-7687-46c3-826d-fd1939ea3bbc	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
97622e69-6bb7-4f81-bc71-5de1ab7aa10e	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
670e9a5a-7cb8-40f1-a42e-71207489aa2b	320ddf01-74b8-435e-953d-adfa64de928f
7ab42eaa-6ee8-4ffb-bc49-b48e71f893ea	320ddf01-74b8-435e-953d-adfa64de928f
28bebfa8-ac05-442e-aac5-10e1ee16ab40	731f6403-66f6-46ee-bcdd-e69ed3618535
552b54d4-5c5b-4c2a-be8b-d6f342103e8d	731f6403-66f6-46ee-bcdd-e69ed3618535
b9e1bdac-f069-4a5f-bf4e-dcaaa909dee8	7e598b76-abda-4c64-852c-f7c048e85857
271a2f04-3526-4d6f-86e5-5bd3f616576d	7e598b76-abda-4c64-852c-f7c048e85857
e545724e-fb31-44a6-8266-91cf0dac072f	836d9050-ffc1-4dbe-a43d-fe7adbbd51fe
d4a63d5c-7c0d-44f2-b105-882cdb6d9c09	836d9050-ffc1-4dbe-a43d-fe7adbbd51fe
\.


--
-- Data for Name: metadatafieldregistry; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.metadatafieldregistry (metadata_field_id, metadata_schema_id, element, qualifier, scope_note) FROM stdin;
1	2	firstname	\N	\N
2	2	lastname	\N	\N
3	2	phone	\N	\N
4	2	language	\N	\N
5	1	provenance	\N	\N
6	1	rights	license	\N
7	1	contributor	\N	A person, organization, or service responsible for the content of the resource.  Catch-all for unspecified contributors.
8	1	contributor	advisor	Use primarily for thesis advisor.
9	1	contributor	author	\N
10	1	contributor	editor	\N
11	1	contributor	illustrator	\N
12	1	contributor	other	\N
13	1	coverage	spatial	Spatial characteristics of content.
14	1	coverage	temporal	Temporal characteristics of content.
15	1	creator	\N	Do not use; only for harvested metadata.
16	1	date	\N	Use qualified form if possible.
17	1	date	accessioned	Date DSpace takes possession of item.
18	1	date	available	Date or date range item became available to the public.
19	1	date	copyright	Date of copyright.
20	1	date	created	Date of creation or manufacture of intellectual content if different from date.issued.
21	1	date	issued	Date of publication or distribution.
22	1	date	submitted	Recommend for theses/dissertations.
23	1	identifier	\N	Catch-all for unambiguous identifiers not defined by\n    qualified form; use identifier.other for a known identifier common\n    to a local collection instead of unqualified form.
24	1	identifier	citation	Human-readable, standard bibliographic citation \n    of non-DSpace format of this item
25	1	identifier	govdoc	A government document number
26	1	identifier	isbn	International Standard Book Number
27	1	identifier	issn	International Standard Serial Number
28	1	identifier	sici	Serial Item and Contribution Identifier
29	1	identifier	ismn	International Standard Music Number
30	1	identifier	other	A known identifier type common to a local collection.
31	1	identifier	uri	Uniform Resource Identifier
32	1	description	\N	Catch-all for any description not defined by qualifiers.
33	1	description	abstract	Abstract or summary.
34	1	description	provenance	The history of custody of the item since its creation, including any changes successive custodians made to it.
35	1	description	sponsorship	Information about sponsoring agencies, individuals, or\n    contractual arrangements for the item.
36	1	description	statementofresponsibility	To preserve statement of responsibility from MARC records.
37	1	description	tableofcontents	A table of contents for a given item.
38	1	description	uri	Uniform Resource Identifier pointing to description of\n    this item.
39	1	format	\N	Catch-all for any format information not defined by qualifiers.
40	1	format	extent	Size or duration.
41	1	format	medium	Physical medium.
42	1	format	mimetype	Registered MIME type identifiers.
43	1	language	\N	Catch-all for non-ISO forms of the language of the\n    item, accommodating harvested values.
44	1	language	iso	Current ISO standard for language of intellectual content, including country codes (e.g. "en_US").
45	1	publisher	\N	Entity responsible for publication, distribution, or imprint.
46	1	relation	\N	Catch-all for references to other related items.
47	1	relation	isformatof	References additional physical form.
48	1	relation	ispartof	References physically or logically containing item.
49	1	relation	ispartofseries	Series name and number within that series, if available.
50	1	relation	haspart	References physically or logically contained item.
51	1	relation	isversionof	References earlier version.
52	1	relation	hasversion	References later version.
53	1	relation	isbasedon	References source.
54	1	relation	isreferencedby	Pointed to by referenced resource.
55	1	relation	requires	Referenced resource is required to support function,\n    delivery, or coherence of item.
56	1	relation	replaces	References preceeding item.
57	1	relation	isreplacedby	References succeeding item.
58	1	relation	uri	References Uniform Resource Identifier for related item.
59	1	rights	\N	Terms governing use and reproduction.
60	1	rights	uri	References terms governing use and reproduction.
61	1	source	\N	Do not use; only for harvested metadata.
62	1	source	uri	Do not use; only for harvested metadata.
63	1	subject	\N	Uncontrolled index term.
64	1	subject	classification	Catch-all for value from local classification system;\n    global classification systems will receive specific qualifier
65	1	subject	ddc	Dewey Decimal Classification Number
66	1	subject	lcc	Library of Congress Classification Number
67	1	subject	lcsh	Library of Congress Subject Headings
68	1	subject	mesh	MEdical Subject Headings
69	1	subject	other	Local controlled vocabulary; global vocabularies will receive specific qualifier.
70	1	title	\N	Title statement/title proper.
71	1	title	alternative	Varying (or substitute) form of title proper appearing in item,\n    e.g. abbreviation or translation
72	1	type	\N	Nature or genre of content.
73	3	abstract	\N	A summary of the resource.
74	3	accessRights	\N	Information about who can access the resource or an indication of its security status. May include information regarding access or restrictions based on privacy, security, or other policies.
75	3	accrualMethod	\N	The method by which items are added to a collection.
76	3	accrualPeriodicity	\N	The frequency with which items are added to a collection.
77	3	accrualPolicy	\N	The policy governing the addition of items to a collection.
78	3	alternative	\N	An alternative name for the resource.
79	3	audience	\N	A class of entity for whom the resource is intended or useful.
80	3	available	\N	Date (often a range) that the resource became or will become available.
81	3	bibliographicCitation	\N	Recommended practice is to include sufficient bibliographic detail to identify the resource as unambiguously as possible.
82	3	conformsTo	\N	An established standard to which the described resource conforms.
83	3	contributor	\N	An entity responsible for making contributions to the resource. Examples of a Contributor include a person, an organization, or a service.
84	3	coverage	\N	The spatial or temporal topic of the resource, the spatial applicability of the resource, or the jurisdiction under which the resource is relevant.
85	3	created	\N	Date of creation of the resource.
86	3	creator	\N	An entity primarily responsible for making the resource.
87	3	date	\N	A point or period of time associated with an event in the lifecycle of the resource.
88	3	dateAccepted	\N	Date of acceptance of the resource.
89	3	dateCopyrighted	\N	Date of copyright.
90	3	dateSubmitted	\N	Date of submission of the resource.
91	3	description	\N	An account of the resource.
92	3	educationLevel	\N	A class of entity, defined in terms of progression through an educational or training context, for which the described resource is intended.
93	3	extent	\N	The size or duration of the resource.
94	3	format	\N	The file format, physical medium, or dimensions of the resource.
95	3	hasFormat	\N	A related resource that is substantially the same as the pre-existing described resource, but in another format.
96	3	hasPart	\N	A related resource that is included either physically or logically in the described resource.
97	3	hasVersion	\N	A related resource that is a version, edition, or adaptation of the described resource.
98	3	identifier	\N	An unambiguous reference to the resource within a given context.
99	3	instructionalMethod	\N	A process, used to engender knowledge, attitudes and skills, that the described resource is designed to support.
100	3	isFormatOf	\N	A related resource that is substantially the same as the described resource, but in another format.
101	3	isPartOf	\N	A related resource in which the described resource is physically or logically included.
102	3	isReferencedBy	\N	A related resource that references, cites, or otherwise points to the described resource.
103	3	isReplacedBy	\N	A related resource that supplants, displaces, or supersedes the described resource.
104	3	isRequiredBy	\N	A related resource that requires the described resource to support its function, delivery, or coherence.
105	3	issued	\N	Date of formal issuance (e.g., publication) of the resource.
106	3	isVersionOf	\N	A related resource of which the described resource is a version, edition, or adaptation.
107	3	language	\N	A language of the resource.
108	3	license	\N	A legal document giving official permission to do something with the resource.
109	3	mediator	\N	An entity that mediates access to the resource and for whom the resource is intended or useful.
110	3	medium	\N	The material or physical carrier of the resource.
111	3	modified	\N	Date on which the resource was changed.
112	3	provenance	\N	A statement of any changes in ownership and custody of the resource since its creation that are significant for its authenticity, integrity, and interpretation.
113	3	publisher	\N	An entity responsible for making the resource available.
114	3	references	\N	A related resource that is referenced, cited, or otherwise pointed to by the described resource.
115	3	relation	\N	A related resource.
116	3	replaces	\N	A related resource that is supplanted, displaced, or superseded by the described resource.
117	3	requires	\N	A related resource that is required by the described resource to support its function, delivery, or coherence.
118	3	rights	\N	Information about rights held in and over the resource.
119	3	rightsHolder	\N	A person or organization owning or managing rights over the resource.
120	3	source	\N	A related resource from which the described resource is derived.
121	3	spatial	\N	Spatial characteristics of the resource.
122	3	subject	\N	The topic of the resource.
123	3	tableOfContents	\N	A list of subunits of the resource.
124	3	temporal	\N	Temporal characteristics of the resource.
125	3	title	\N	A name given to the resource.
126	3	type	\N	The nature or genre of the resource.
127	3	valid	\N	Date (often a range) of validity of a resource.
128	1	date	updated	The last time the item was updated via the SWORD interface
129	1	description	version	The Peer Reviewed status of an item
130	1	identifier	slug	a uri supplied via the sword slug header, as a suggested uri for the item
131	1	language	rfc3066	the rfc3066 form of the language for the item
132	1	rights	holder	The owner of the copyright
\.


--
-- Name: metadatafieldregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.metadatafieldregistry_seq', 132, true);


--
-- Data for Name: metadataschemaregistry; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.metadataschemaregistry (metadata_schema_id, namespace, short_id) FROM stdin;
1	http://dublincore.org/documents/dcmi-terms/	dc
2	http://dspace.org/eperson	eperson
3	http://purl.org/dc/terms/	dcterms
4	http://dspace.org/namespace/local/	local
\.


--
-- Name: metadataschemaregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.metadataschemaregistry_seq', 4, true);


--
-- Data for Name: metadatavalue; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.metadatavalue (metadata_value_id, metadata_field_id, text_value, text_lang, place, authority, confidence, dspace_object_id) FROM stdin;
537	70	ORIGINAL	\N	1	\N	-1	ebe553b5-6c77-4f47-b14f-c55fcfbb243f
99	32	Take computer science courses online for free from top universities worldwide. Browse computer science MOOCS in a variety of disciplines and enroll now.Enroll in the latest computer science courses covering important topics in artificial intelligence, cyber security, software engineering, and big data. Add a portfolio of programming skills or get an overview of the field with Harvard University’s Introduction to Computer Science, a free course that you can start today.	\N	0	\N	-1	12a6f2d6-4eae-47c9-8bf4-54cf02c01335
6	70	Untitled	\N	0	\N	-1	b7b1b7e1-3a94-439e-ade7-f9ef898e272f
7	1	Mudra	\N	0	\N	-1	36781c80-74f3-427f-8569-d55321306d74
8	2	Sahu	\N	0	\N	-1	36781c80-74f3-427f-8569-d55321306d74
9	3		\N	0	\N	-1	36781c80-74f3-427f-8569-d55321306d74
10	4	en	\N	0	\N	-1	36781c80-74f3-427f-8569-d55321306d74
11	70	dspace	\N	0	\N	-1	e41ee777-daa9-4ad9-98a5-13425d1b23ed
12	33	testing	\N	0	\N	-1	e41ee777-daa9-4ad9-98a5-13425d1b23ed
14	70	dspace1	\N	0	\N	-1	e1e182b9-a464-49c6-89a9-7453f23404bd
15	33	testing1	\N	0	\N	-1	e1e182b9-a464-49c6-89a9-7453f23404bd
16	32		\N	0	\N	-1	e1e182b9-a464-49c6-89a9-7453f23404bd
17	59		\N	0	\N	-1	e1e182b9-a464-49c6-89a9-7453f23404bd
18	37		\N	0	\N	-1	e1e182b9-a464-49c6-89a9-7453f23404bd
19	5		\N	0	\N	-1	e1e182b9-a464-49c6-89a9-7453f23404bd
23	1	Mudra	\N	0	\N	-1	45b7341c-6031-4c5c-8383-7414a82fd8f0
24	2	Sahu	\N	0	\N	-1	45b7341c-6031-4c5c-8383-7414a82fd8f0
25	3		\N	0	\N	-1	45b7341c-6031-4c5c-8383-7414a82fd8f0
26	4	en	\N	0	\N	-1	45b7341c-6031-4c5c-8383-7414a82fd8f0
27	70	computer science	\N	0	\N	-1	ba4336ee-0563-4b0b-84ea-d4d4fc99485e
28	33	cs	\N	0	\N	-1	ba4336ee-0563-4b0b-84ea-d4d4fc99485e
85	70	quality control.pdf	\N	0	\N	-1	0b6a3f7f-6ad7-4dbe-b300-1bb8ee8ee2a2
59	9	mudra, sahu	\N	0	\N	-1	7d72e5b6-7704-476f-9d38-8d5f261016c7
60	70	abc	en_US	0	\N	-1	7d72e5b6-7704-476f-9d38-8d5f261016c7
61	71	xyz	en_US	0	\N	-1	7d72e5b6-7704-476f-9d38-8d5f261016c7
62	21	2018-07-11	\N	0	\N	-1	7d72e5b6-7704-476f-9d38-8d5f261016c7
36	70	cs1	\N	0	\N	-1	9f445d1d-8fa5-47d5-8d32-e8b860e61328
37	33	twstq11	\N	0	\N	-1	9f445d1d-8fa5-47d5-8d32-e8b860e61328
63	63	weqeqwe	en_US	0	\N	-1	7d72e5b6-7704-476f-9d38-8d5f261016c7
64	63	dqw	en_US	1	\N	-1	7d72e5b6-7704-476f-9d38-8d5f261016c7
65	70	ORIGINAL	\N	1	\N	-1	f4af25dc-153f-4958-a515-1cdf352d30e6
86	61	/home/dspace/upload/quality control.pdf	\N	0	\N	-1	0b6a3f7f-6ad7-4dbe-b300-1bb8ee8ee2a2
66	70	quality control.pdf	\N	0	\N	-1	0b3af3ef-fc2c-4942-96b1-d2254e99201c
67	61	/home/dspace/upload/quality control.pdf	\N	0	\N	-1	0b3af3ef-fc2c-4942-96b1-d2254e99201c
68	32		\N	0	\N	-1	0b3af3ef-fc2c-4942-96b1-d2254e99201c
45	70	cs2	\N	0	\N	-1	216554d5-e1c6-4975-be5d-16a435fdbdae
46	33	cs2desc	\N	0	\N	-1	216554d5-e1c6-4975-be5d-16a435fdbdae
69	9	12312, 4134	\N	0	\N	-1	e555b73c-4e0c-453a-bc10-e1509fa18348
70	70	item	en_US	0	\N	-1	e555b73c-4e0c-453a-bc10-e1509fa18348
71	71	item1	en_US	0	\N	-1	e555b73c-4e0c-453a-bc10-e1509fa18348
72	21	2018-07-12	\N	0	\N	-1	e555b73c-4e0c-453a-bc10-e1509fa18348
73	63	item2	en_US	0	\N	-1	e555b73c-4e0c-453a-bc10-e1509fa18348
74	70	ORIGINAL	\N	1	\N	-1	495be94e-1eef-4a2e-9ed6-05efa3f2667a
75	70	Jumanji.1995.720p.BrRip.x264.BOKUTOX.YIFY.srt	\N	0	\N	-1	b3ac2a4b-5443-4f61-be3b-a4f5760d7710
76	61	/home/dspace/upload/Jumanji.1995.720p.BrRip.x264.BOKUTOX.YIFY.srt	\N	0	\N	-1	b3ac2a4b-5443-4f61-be3b-a4f5760d7710
77	32		\N	0	\N	-1	b3ac2a4b-5443-4f61-be3b-a4f5760d7710
87	32		\N	0	\N	-1	0b6a3f7f-6ad7-4dbe-b300-1bb8ee8ee2a2
89	70	license.txt	\N	0	\N	-1	81a5ac06-022e-4b3e-a464-217ab669c7f3
90	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	81a5ac06-022e-4b3e-a464-217ab669c7f3
97	70	computer science	\N	0	\N	-1	12a6f2d6-4eae-47c9-8bf4-54cf02c01335
98	33	Computer Programming | Android Development | Apache Spark | App Development | Azure | C++ | HTML | Java | JavaScript | Python | R Programming | SQL | Artificial Intelligence | Blockchain & Cryptography | Cloud Computing | Cybersecurity | Databases | Front End Web Development | Hadoop | Information Technology | Linux | Machine Learning | Matlab | Mobile Development | Relational Databases | Robotics | T-SQL | Web Development	\N	0	\N	-1	12a6f2d6-4eae-47c9-8bf4-54cf02c01335
132	9	Tony W K Fung	\N	0	\N	-1	fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d
133	70	Object-oriented programming basics	en_US	0	\N	-1	fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d
137	70	ORIGINAL	\N	1	\N	-1	a1fce771-5353-4398-924c-045ed36e55c4
138	70	1.parse.csv	\N	0	\N	-1	0c9082e8-8c4b-4ce0-bc2d-e739c9e814fa
139	61	/home/dspace/upload/1.parse.csv	\N	0	\N	-1	0c9082e8-8c4b-4ce0-bc2d-e739c9e814fa
170	9	Smith	\N	0	\N	-1	a54bbc7b-59eb-4a38-849a-e43ef1b8304a
171	70	Branching and Loops	en_US	0	\N	-1	a54bbc7b-59eb-4a38-849a-e43ef1b8304a
173	63	break, continue ,return	en_US	0	\N	-1	a54bbc7b-59eb-4a38-849a-e43ef1b8304a
174	33	The Java programming language supports three branching statements: The break statement; The continue statement; The return statement.	en_US	0	\N	-1	a54bbc7b-59eb-4a38-849a-e43ef1b8304a
188	9	Leo P M Fan	\N	0	\N	-1	2499711d-8cf0-476d-9534-fe00f0475658
107	70	Introduction to Java Programming – Part 1	\N	0	\N	-1	f7019f5a-44ba-4a31-a105-b20cc4c20ae1
108	33	Learn the fundamental elements of Java programming and data abstraction.	\N	0	\N	-1	f7019f5a-44ba-4a31-a105-b20cc4c20ae1
109	32	his Java course will provide you with a strong understanding of basic Java programming elements and data abstraction using problem representation and the object-oriented framework. As the saying goes, “A picture is worth a thousand words.” This course will use sample objects such as photos or images to illustrate some important concepts to enhance understanding and retention. You will learn to write procedural programs using variables, arrays, control statements, loops, recursion, data abstraction and objects in an integrated development environment.	\N	0	\N	-1	f7019f5a-44ba-4a31-a105-b20cc4c20ae1
189	70	Problem solving	en_US	0	\N	-1	2499711d-8cf0-476d-9534-fe00f0475658
110	9	Ting-Chuen, Pong	\N	0	\N	-1	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
111	70	Primitive data types and arithmetic expressions	en_US	0	\N	-1	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
113	45	Leo P M Fan	en_US	0	\N	-1	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
204	18	2018-06-21T17:00:00Z	\N	0	\N	-1	2499711d-8cf0-476d-9534-fe00f0475658
205	21	2018-02-10	\N	0	\N	-1	2499711d-8cf0-476d-9534-fe00f0475658
193	70	ORIGINAL	\N	1	\N	-1	a93055cd-3253-4f73-bc2a-5b9b944afbe7
117	70	ORIGINAL	\N	1	\N	-1	2ea7c2a4-41d5-4115-9afa-ce1a849cc6e5
118	70	1.parse.csv	\N	0	\N	-1	13f9a2f9-b4e5-4366-bad1-83b82634d5a5
119	61	/home/dspace/upload/1.parse.csv	\N	0	\N	-1	13f9a2f9-b4e5-4366-bad1-83b82634d5a5
120	63	variables, arrays, control statements, loops, recursion, data abstraction and objects in an integrated development	en_US	0	\N	-1	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
121	33	Primitive types are the most basic data types available within the Java language. There are 8: boolean , byte , char , short , int , long , float and double .	en_US	0	\N	-1	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
122	32	To define a data type, we need only specify the values and the set of operations on those values. This information is summarized in the table below for Java’s int, double, boolean, and char data types. These data types are similar to the basic data types found in many programming languages. For int and double, the operations are familiar arithmetic operations; for boolean, they are familiar logical operations.	en_US	0	\N	-1	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
123	70	LICENSE	\N	1	\N	-1	0fd12cd1-fb9f-4355-bf1d-9f95d42ecef5
124	70	license.txt	\N	0	\N	-1	b80d21bb-4aae-4ee3-824a-3f95395252d7
125	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	b80d21bb-4aae-4ee3-824a-3f95395252d7
126	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T16:44:40Z\nNo. of bitstreams: 1\n1.parse.csv: 5712029 bytes, checksum: 3a12cf2e193f45ebdc521e7ef09deaf9 (MD5)	en	0	\N	-1	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
127	31	http://10.130.9.111/jspui/handle/123456789/10	\N	0	\N	-1	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
194	70	jquery.js	\N	0	\N	-1	ca06fc2d-47e4-40c1-9909-6e527521c4ba
195	61	/home/dspace/upload/jquery.js	\N	0	\N	-1	ca06fc2d-47e4-40c1-9909-6e527521c4ba
131	34	Made available in DSpace on 2018-06-21T16:44:40Z (GMT). No. of bitstreams: 1\n1.parse.csv: 5712029 bytes, checksum: 3a12cf2e193f45ebdc521e7ef09deaf9 (MD5)\n  Previous issue date: 2018-02-11	en	1	\N	-1	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
128	17	2018-06-21T16:44:40Z	\N	0	\N	-1	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
129	18	2018-06-21T16:44:40Z	\N	0	\N	-1	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
130	21	2018-02-11	\N	0	\N	-1	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
196	63	problem , task, difficult, approch,easy	en_US	0	\N	-1	2499711d-8cf0-476d-9534-fe00f0475658
197	33	Take a “real-life” problem and abstract out the pertinent aspects necessary to solve it in an algorithmic manner.	en_US	0	\N	-1	2499711d-8cf0-476d-9534-fe00f0475658
198	70	LICENSE	\N	1	\N	-1	454bff8d-6deb-48ba-97f1-70c8a160b5c6
248	70	LICENSE	\N	1	\N	-1	66e6f832-c292-402a-ad47-ee06ff5c9f87
199	70	license.txt	\N	0	\N	-1	dbb996cf-0122-4e78-bf03-6f8c2322638c
200	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	dbb996cf-0122-4e78-bf03-6f8c2322638c
201	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T17:00:00Z\nNo. of bitstreams: 1\njquery.js: 31967 bytes, checksum: ceb8da5aecfdc2c1b745520cd0a1a768 (MD5)	en	0	\N	-1	2499711d-8cf0-476d-9534-fe00f0475658
202	31	http://10.130.9.111/jspui/handle/123456789/14	\N	0	\N	-1	2499711d-8cf0-476d-9534-fe00f0475658
243	70	ORIGINAL	\N	1	\N	-1	97af0899-be0a-427a-9c11-6a02776d0830
206	34	Made available in DSpace on 2018-06-21T17:00:00Z (GMT). No. of bitstreams: 1\njquery.js: 31967 bytes, checksum: ceb8da5aecfdc2c1b745520cd0a1a768 (MD5)\n  Previous issue date: 2018-02-10	en	1	\N	-1	2499711d-8cf0-476d-9534-fe00f0475658
203	17	2018-06-21T17:00:00Z	\N	0	\N	-1	2499711d-8cf0-476d-9534-fe00f0475658
538	70	edited_0801CS151045_BE_CS_Mudra_Sahu.pdf	\N	0	\N	-1	b8362c84-61d5-4c54-9b93-6903dc7af6c3
238	9	Smith	\N	0	\N	-1	a8be8fdd-3a54-4e70-aa5c-56e24e9e403b
239	70	File I/O	en_US	0	\N	-1	a8be8fdd-3a54-4e70-aa5c-56e24e9e403b
539	61	/home/dspace/upload/edited_0801CS151045_BE_CS_Mudra_Sahu.pdf	\N	0	\N	-1	b8362c84-61d5-4c54-9b93-6903dc7af6c3
540	32		\N	0	\N	-1	b8362c84-61d5-4c54-9b93-6903dc7af6c3
244	70	jquery.js	\N	0	\N	-1	b5677909-694d-4b69-bdaa-66f81f894c1b
245	61	/home/dspace/upload/jquery.js	\N	0	\N	-1	b5677909-694d-4b69-bdaa-66f81f894c1b
246	63	Input Output Stream file read write	en_US	0	\N	-1	a8be8fdd-3a54-4e70-aa5c-56e24e9e403b
247	33	Java I/O (Input and Output) is used to process the input and produce the output. Java uses the concept of stream to make I/O operation fast. The java.io package contains all the classes required for input and output operations. We can perform file handling in java by Java I/O API.	en_US	0	\N	-1	a8be8fdd-3a54-4e70-aa5c-56e24e9e403b
541	70	LICENSE	\N	1	\N	-1	8aede5fb-4458-414d-ac6b-fe62210c70f8
249	70	license.txt	\N	0	\N	-1	5e355026-895b-4bdc-8fed-14d4779fc8aa
250	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	5e355026-895b-4bdc-8fed-14d4779fc8aa
251	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T17:07:42Z\nNo. of bitstreams: 1\njquery.js: 31967 bytes, checksum: ceb8da5aecfdc2c1b745520cd0a1a768 (MD5)	en	0	\N	-1	a8be8fdd-3a54-4e70-aa5c-56e24e9e403b
252	31	http://10.130.9.111/jspui/handle/123456789/17	\N	0	\N	-1	a8be8fdd-3a54-4e70-aa5c-56e24e9e403b
542	70	license.txt	\N	0	\N	-1	b71d3b0c-7bbd-4413-bea7-7d9cd8aaf50a
140	63	inheritance, data binding, polymorphism	en_US	0	\N	-1	fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d
141	33	Object Oriented Programming is a paradigm that provides many concepts such as inheritance, data binding, polymorphism etc. The programming paradigm where everything is represented as an object is known as truly object-oriented programming language	en_US	0	\N	-1	fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d
142	70	LICENSE	\N	1	\N	-1	4ae07e0e-4ddd-4d82-aab7-72ab37f67174
543	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	b71d3b0c-7bbd-4413-bea7-7d9cd8aaf50a
143	70	license.txt	\N	0	\N	-1	9da1785d-55d1-4e50-9df7-737c1c584855
144	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	9da1785d-55d1-4e50-9df7-737c1c584855
145	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T16:49:42Z\nNo. of bitstreams: 1\n1.parse.csv: 5712029 bytes, checksum: 3a12cf2e193f45ebdc521e7ef09deaf9 (MD5)	en	0	\N	-1	fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d
146	31	http://10.130.9.111/jspui/handle/123456789/11	\N	0	\N	-1	fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d
150	34	Made available in DSpace on 2018-06-21T16:49:42Z (GMT). No. of bitstreams: 1\n1.parse.csv: 5712029 bytes, checksum: 3a12cf2e193f45ebdc521e7ef09deaf9 (MD5)\n  Previous issue date: 2018-05-11	en	1	\N	-1	fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d
147	17	2018-06-21T16:49:42Z	\N	0	\N	-1	fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d
148	18	2018-06-21T16:49:42Z	\N	0	\N	-1	fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d
149	21	2018-05-11	\N	0	\N	-1	fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d
151	9	Leo P M Fan	\N	0	\N	-1	a8b94f7f-986d-479b-80a4-a7b528984380
152	70	Arrays	en_US	0	\N	-1	a8b94f7f-986d-479b-80a4-a7b528984380
223	70	ORIGINAL	\N	1	\N	-1	1f036576-773c-4d03-9127-b4bba2eca4d5
156	70	ORIGINAL	\N	1	\N	-1	f49fd40d-fcf2-4815-9f24-083b794b4bd5
157	70	jquery.js	\N	0	\N	-1	64fee389-1491-49e9-870c-88e74ef32a14
158	61	/home/dspace/upload/jquery.js	\N	0	\N	-1	64fee389-1491-49e9-870c-88e74ef32a14
159	63	fixed-size ,collection, data structure	en_US	0	\N	-1	a8b94f7f-986d-479b-80a4-a7b528984380
160	33	Java provides a data structure, the array, which stores a fixed-size sequential collection of elements of the same type.	en_US	0	\N	-1	a8b94f7f-986d-479b-80a4-a7b528984380
161	70	LICENSE	\N	1	\N	-1	97b30dc1-de2c-4da2-a4c7-954ceb243951
224	70	1.parse.csv	\N	0	\N	-1	15d4b547-ef7e-46ac-bee2-0977938520d4
162	70	license.txt	\N	0	\N	-1	bade7c98-10b6-4843-b443-44b6ed5acb04
163	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	bade7c98-10b6-4843-b443-44b6ed5acb04
164	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T16:54:09Z\nNo. of bitstreams: 1\njquery.js: 31967 bytes, checksum: ceb8da5aecfdc2c1b745520cd0a1a768 (MD5)	en	0	\N	-1	a8b94f7f-986d-479b-80a4-a7b528984380
165	31	http://10.130.9.111/jspui/handle/123456789/12	\N	0	\N	-1	a8b94f7f-986d-479b-80a4-a7b528984380
225	61	/home/dspace/upload/1.parse.csv	\N	0	\N	-1	15d4b547-ef7e-46ac-bee2-0977938520d4
169	34	Made available in DSpace on 2018-06-21T16:54:09Z (GMT). No. of bitstreams: 1\njquery.js: 31967 bytes, checksum: ceb8da5aecfdc2c1b745520cd0a1a768 (MD5)\n  Previous issue date: 2017-01-11	en	1	\N	-1	a8b94f7f-986d-479b-80a4-a7b528984380
166	17	2018-06-21T16:54:09Z	\N	0	\N	-1	a8b94f7f-986d-479b-80a4-a7b528984380
167	18	2018-06-21T16:54:09Z	\N	0	\N	-1	a8b94f7f-986d-479b-80a4-a7b528984380
168	21	2017-01-11	\N	0	\N	-1	a8b94f7f-986d-479b-80a4-a7b528984380
214	70	Introduction to Java Programming – Part 2	\N	0	\N	-1	38da3b9e-b576-4d9f-907c-ace9b09861c4
215	33	The first MOOC to teach the fundamental elements of Java programming and data abstraction.	\N	0	\N	-1	38da3b9e-b576-4d9f-907c-ace9b09861c4
216	32	This Java course will provide you with a strong understanding of basic Java programming elements and data abstraction using problem representation and the object-oriented framework. As the saying goes, “A picture is worth a thousand words.” This course will use sample objects such as photos or images to illustrate some important concepts to enhance understanding and retention. You will learn to write procedural programs using variables, arrays, control statements, loops, recursion, data abstraction and objects in an integrated development environment.	\N	0	\N	-1	38da3b9e-b576-4d9f-907c-ace9b09861c4
217	9	Ting-Chuen Pong	\N	0	\N	-1	45d8b4dc-5da5-46af-a643-3143b6af9f13
218	70	String manipulation	en_US	0	\N	-1	45d8b4dc-5da5-46af-a643-3143b6af9f13
230	70	license.txt	\N	0	\N	-1	f1ca61cf-b4fb-4d99-9b01-c6154bd04085
226	63	string, substring ,index,truncate ,array,characters	en_US	0	\N	-1	45d8b4dc-5da5-46af-a643-3143b6af9f13
227	33	String is a Final class; i.e once created the value cannot be altered. Thus String objects are called immutable. The Java Virtual Machine(JVM) creates a memory location especially for Strings called String Constant Pool.	en_US	0	\N	-1	45d8b4dc-5da5-46af-a643-3143b6af9f13
228	32	Strings, which are widely used in Java programming, are a sequence of characters. In Java programming language, strings are treated as objects. The Java platform provides the String class to create and manipulate strings.	en_US	0	\N	-1	45d8b4dc-5da5-46af-a643-3143b6af9f13
229	70	LICENSE	\N	1	\N	-1	8570e079-3966-4d74-af6d-1cd038b7dad9
231	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	f1ca61cf-b4fb-4d99-9b01-c6154bd04085
232	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T17:05:13Z\nNo. of bitstreams: 1\n1.parse.csv: 5712029 bytes, checksum: 3a12cf2e193f45ebdc521e7ef09deaf9 (MD5)	en	0	\N	-1	45d8b4dc-5da5-46af-a643-3143b6af9f13
233	31	http://10.130.9.111/jspui/handle/123456789/16	\N	0	\N	-1	45d8b4dc-5da5-46af-a643-3143b6af9f13
278	63	List ADT, Stack ADT, Queue ADT.	en_US	0	\N	-1	3da62806-eab4-4e50-85f7-c27836c44a3b
279	33	The definition of ADT only mentions what operations are to be performed but not how these operations will be implemented. It does not specify how data will be organized in memory and what algorithms will be used for implementing the operations. It is called “abstract” because it gives an implementation independent view. The process of providing only the essentials and hiding the details is known as abstraction.	en_US	0	\N	-1	3da62806-eab4-4e50-85f7-c27836c44a3b
280	32	Abstract Data type (ADT) is a type (or class) for objects whose behavior is defined by a set of value and a set of operations.	en_US	0	\N	-1	3da62806-eab4-4e50-85f7-c27836c44a3b
237	34	Made available in DSpace on 2018-06-21T17:05:13Z (GMT). No. of bitstreams: 1\n1.parse.csv: 5712029 bytes, checksum: 3a12cf2e193f45ebdc521e7ef09deaf9 (MD5)\n  Previous issue date: 2018-09-11	en	1	\N	-1	45d8b4dc-5da5-46af-a643-3143b6af9f13
234	17	2018-06-21T17:05:13Z	\N	0	\N	-1	45d8b4dc-5da5-46af-a643-3143b6af9f13
235	18	2018-06-21T17:05:13Z	\N	0	\N	-1	45d8b4dc-5da5-46af-a643-3143b6af9f13
281	70	ORIGINAL	\N	1	\N	-1	f1a0e28e-b69d-419e-9649-43ca88e6bafa
175	70	ORIGINAL	\N	1	\N	-1	65bad344-2707-457e-b1ba-bee570972b87
236	21	2018-09-11	\N	0	\N	-1	45d8b4dc-5da5-46af-a643-3143b6af9f13
176	70	quality control.pdf	\N	0	\N	-1	ba7ce28a-f9aa-4ea8-99f1-75accb03e87c
177	61	/home/dspace/upload/quality control.pdf	\N	0	\N	-1	ba7ce28a-f9aa-4ea8-99f1-75accb03e87c
178	32		\N	0	\N	-1	ba7ce28a-f9aa-4ea8-99f1-75accb03e87c
179	70	LICENSE	\N	1	\N	-1	8cc9da0c-2cee-418c-8cd2-d4065adbdbf7
180	70	license.txt	\N	0	\N	-1	b44dbb4d-a1cc-4a6b-98d5-fa739a1e083c
181	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	b44dbb4d-a1cc-4a6b-98d5-fa739a1e083c
182	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T16:57:01Z\nNo. of bitstreams: 1\nquality control.pdf: 11471769 bytes, checksum: aa829cd04ff93d856eb0618d3627bb7e (MD5)	en	0	\N	-1	a54bbc7b-59eb-4a38-849a-e43ef1b8304a
183	31	http://10.130.9.111/jspui/handle/123456789/13	\N	0	\N	-1	a54bbc7b-59eb-4a38-849a-e43ef1b8304a
256	34	Made available in DSpace on 2018-06-21T17:07:42Z (GMT). No. of bitstreams: 1\njquery.js: 31967 bytes, checksum: ceb8da5aecfdc2c1b745520cd0a1a768 (MD5)\n  Previous issue date: 2018-02-22	en	1	\N	-1	a8be8fdd-3a54-4e70-aa5c-56e24e9e403b
253	17	2018-06-21T17:07:42Z	\N	0	\N	-1	a8be8fdd-3a54-4e70-aa5c-56e24e9e403b
254	18	2018-06-21T17:07:42Z	\N	0	\N	-1	a8be8fdd-3a54-4e70-aa5c-56e24e9e403b
187	34	Made available in DSpace on 2018-06-21T16:57:01Z (GMT). No. of bitstreams: 1\nquality control.pdf: 11471769 bytes, checksum: aa829cd04ff93d856eb0618d3627bb7e (MD5)\n  Previous issue date: 2018-04-11	en	1	\N	-1	a54bbc7b-59eb-4a38-849a-e43ef1b8304a
184	17	2018-06-21T16:57:01Z	\N	0	\N	-1	a54bbc7b-59eb-4a38-849a-e43ef1b8304a
185	18	2018-06-21T16:57:01Z	\N	0	\N	-1	a54bbc7b-59eb-4a38-849a-e43ef1b8304a
186	21	2018-04-11	\N	0	\N	-1	a54bbc7b-59eb-4a38-849a-e43ef1b8304a
255	21	2018-02-22	\N	0	\N	-1	a8be8fdd-3a54-4e70-aa5c-56e24e9e403b
544	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-22T05:41:48Z\nNo. of bitstreams: 1\nedited_0801CS151045_BE_CS_Mudra_Sahu.pdf: 329047 bytes, checksum: 8da5f569bdf7a51b5ff69d06c2e842ed (MD5)	en	0	\N	-1	8c6e25d5-1d1f-47fb-9888-894e04e4592c
257	9	Smith	\N	0	\N	-1	c39ad818-307a-4c7a-9672-4e8e85c0d624
258	70	Recursion	en_US	0	\N	-1	c39ad818-307a-4c7a-9672-4e8e85c0d624
260	63	fibonacci series, armstrong number, prime number, palindrome number, factorial number, bubble sort, selection sort	en_US	0	\N	-1	c39ad818-307a-4c7a-9672-4e8e85c0d624
261	33	A method that calls itself is known as a recursive method. And, this technique is known as recursion	en_US	0	\N	-1	c39ad818-307a-4c7a-9672-4e8e85c0d624
262	70	ORIGINAL	\N	1	\N	-1	a23a2a91-cd8d-4f0b-867d-c73e55c0598c
285	70	LICENSE	\N	1	\N	-1	cdc0ef88-260d-461a-9c2e-494e93909912
263	70	unit 3 IP.pdf	\N	0	\N	-1	8c99d017-1503-4dfd-8066-0f5dc8ace132
264	61	/home/dspace/upload/unit 3 IP.pdf	\N	0	\N	-1	8c99d017-1503-4dfd-8066-0f5dc8ace132
265	32		\N	0	\N	-1	8c99d017-1503-4dfd-8066-0f5dc8ace132
266	70	LICENSE	\N	1	\N	-1	f99b4579-1283-4026-8ff8-6f78dc0d2805
267	70	license.txt	\N	0	\N	-1	d4c1d98f-325c-45fa-b57b-16fcac56d5a5
268	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	d4c1d98f-325c-45fa-b57b-16fcac56d5a5
269	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T17:09:27Z\nNo. of bitstreams: 1\nunit 3 IP.pdf: 10417121 bytes, checksum: 9859ebf66f1789efeeea3ca5bfaa69cc (MD5)	en	0	\N	-1	c39ad818-307a-4c7a-9672-4e8e85c0d624
270	31	http://10.130.9.111/jspui/handle/123456789/18	\N	0	\N	-1	c39ad818-307a-4c7a-9672-4e8e85c0d624
286	70	license.txt	\N	0	\N	-1	ae3cb1cb-0353-47a8-800c-0d9eb3347f42
287	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	ae3cb1cb-0353-47a8-800c-0d9eb3347f42
274	34	Made available in DSpace on 2018-06-21T17:09:27Z (GMT). No. of bitstreams: 1\nunit 3 IP.pdf: 10417121 bytes, checksum: 9859ebf66f1789efeeea3ca5bfaa69cc (MD5)\n  Previous issue date: 2018-08-22	en	1	\N	-1	c39ad818-307a-4c7a-9672-4e8e85c0d624
271	17	2018-06-21T17:09:27Z	\N	0	\N	-1	c39ad818-307a-4c7a-9672-4e8e85c0d624
272	18	2018-06-21T17:09:27Z	\N	0	\N	-1	c39ad818-307a-4c7a-9672-4e8e85c0d624
273	21	2018-08-22	\N	0	\N	-1	c39ad818-307a-4c7a-9672-4e8e85c0d624
275	9	Smith	\N	0	\N	-1	3da62806-eab4-4e50-85f7-c27836c44a3b
276	70	Abstract data types	en_US	0	\N	-1	3da62806-eab4-4e50-85f7-c27836c44a3b
545	31	http://10.130.9.111/jspui/handle/123456789/36	\N	0	\N	-1	8c6e25d5-1d1f-47fb-9888-894e04e4592c
282	70	lec38.pdf	\N	0	\N	-1	ceedb68a-7731-43e3-96d0-ebed5acb3241
283	61	/home/dspace/upload/lec38.pdf	\N	0	\N	-1	ceedb68a-7731-43e3-96d0-ebed5acb3241
284	32		\N	0	\N	-1	ceedb68a-7731-43e3-96d0-ebed5acb3241
288	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T17:12:13Z\nNo. of bitstreams: 1\nlec38.pdf: 769842 bytes, checksum: 3fbcb5bffd6d7e868b61fb0872070cb0 (MD5)	en	0	\N	-1	3da62806-eab4-4e50-85f7-c27836c44a3b
289	31	http://10.130.9.111/jspui/handle/123456789/19	\N	0	\N	-1	3da62806-eab4-4e50-85f7-c27836c44a3b
304	9	john guttag	\N	0	\N	-1	53894fe9-2e5a-4cc0-a1a6-0fda50fcae49
305	70	Installing and Using Python	en_US	0	\N	-1	53894fe9-2e5a-4cc0-a1a6-0fda50fcae49
293	34	Made available in DSpace on 2018-06-21T17:12:13Z (GMT). No. of bitstreams: 1\nlec38.pdf: 769842 bytes, checksum: 3fbcb5bffd6d7e868b61fb0872070cb0 (MD5)\n  Previous issue date: 2018-05-22	en	1	\N	-1	3da62806-eab4-4e50-85f7-c27836c44a3b
290	17	2018-06-21T17:12:13Z	\N	0	\N	-1	3da62806-eab4-4e50-85f7-c27836c44a3b
291	18	2018-06-21T17:12:13Z	\N	0	\N	-1	3da62806-eab4-4e50-85f7-c27836c44a3b
292	21	2018-05-22	\N	0	\N	-1	3da62806-eab4-4e50-85f7-c27836c44a3b
301	70	Introduction to Computer Science and Programming Using Python	\N	0	\N	-1	fedb15df-f01e-40c5-816e-30aa1e8c6667
302	33	This course is the first of a two-course sequence: Introduction to Computer Science and Programming Using Python, and Introduction to Computational Thinking and Data Science	\N	0	\N	-1	fedb15df-f01e-40c5-816e-30aa1e8c6667
303	32	designed to help people with no prior exposure to computer science or programming learn to think computationally and write programs to tackle useful problems. Some of the people taking the two courses will use them as a stepping stone to more advanced computer science courses, but for many it will be their first and last computer science courses	\N	0	\N	-1	fedb15df-f01e-40c5-816e-30aa1e8c6667
307	63	Text Editor Eben Upton and the RaspBerry Pi  Python Code Playground	en_US	0	\N	-1	53894fe9-2e5a-4cc0-a1a6-0fda50fcae49
308	32	In this module you will set things up so you can write Python programs. Not all activities in this module are required for this class so please read the "Using Python in this Class" material for details.	en_US	0	\N	-1	53894fe9-2e5a-4cc0-a1a6-0fda50fcae49
309	70	ORIGINAL	\N	1	\N	-1	762771f7-2ebd-466f-9760-39375d35f186
310	70	greedy2 (1).txt	\N	0	\N	-1	f4c6f687-6237-4363-8242-9d64a1c519ef
311	61	/home/dspace/upload/greedy2 (1).txt	\N	0	\N	-1	f4c6f687-6237-4363-8242-9d64a1c519ef
312	32		\N	0	\N	-1	f4c6f687-6237-4363-8242-9d64a1c519ef
313	70	LICENSE	\N	1	\N	-1	7ea26c6a-9885-47f0-9995-38f0aed9cd91
344	33	A function is a block of organized, reusable code that is used to perform a single, related action. Functions provide better modularity for your application and a high degree of code reusing. As you already know, Python gives you many built-in functions like print(), etc.	en_US	0	\N	-1	89010e0b-74f4-43f9-be0d-f6b83045feb7
314	70	license.txt	\N	0	\N	-1	4c513e51-f52d-4655-acef-a93cec34fedb
315	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	4c513e51-f52d-4655-acef-a93cec34fedb
316	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T17:20:55Z\nNo. of bitstreams: 1\ngreedy2 (1).txt: 48 bytes, checksum: e1bd128fee06d68a34948d686efc6373 (MD5)	en	0	\N	-1	53894fe9-2e5a-4cc0-a1a6-0fda50fcae49
317	31	http://10.130.9.111/jspui/handle/123456789/21	\N	0	\N	-1	53894fe9-2e5a-4cc0-a1a6-0fda50fcae49
345	70	ORIGINAL	\N	1	\N	-1	7439b012-2aac-42f1-b73d-d249a9d64e40
321	34	Made available in DSpace on 2018-06-21T17:20:55Z (GMT). No. of bitstreams: 1\ngreedy2 (1).txt: 48 bytes, checksum: e1bd128fee06d68a34948d686efc6373 (MD5)\n  Previous issue date: 2018-04-14	en	1	\N	-1	53894fe9-2e5a-4cc0-a1a6-0fda50fcae49
318	17	2018-06-21T17:20:55Z	\N	0	\N	-1	53894fe9-2e5a-4cc0-a1a6-0fda50fcae49
319	18	2018-06-21T17:20:55Z	\N	0	\N	-1	53894fe9-2e5a-4cc0-a1a6-0fda50fcae49
320	21	2018-04-14	\N	0	\N	-1	53894fe9-2e5a-4cc0-a1a6-0fda50fcae49
322	9	john guttag	\N	0	\N	-1	75e52dde-8992-4237-9b42-7004977bd3d7
323	70	Variables and Expressions	en_US	0	\N	-1	75e52dde-8992-4237-9b42-7004977bd3d7
355	18	2018-06-21T17:30:21Z	\N	0	\N	-1	89010e0b-74f4-43f9-be0d-f6b83045feb7
325	63	Values types names  keywords Operators and operands	en_US	0	\N	-1	75e52dde-8992-4237-9b42-7004977bd3d7
326	33	An expression is a combination of values, variables, operators, and calls to functions. Expressions need to be evaluated. If you ask Python to print an expression, the interpreter evaluates the expression and displays the result.	en_US	0	\N	-1	75e52dde-8992-4237-9b42-7004977bd3d7
327	70	ORIGINAL	\N	1	\N	-1	87f81a7c-1224-4b6e-8017-8cae299f6988
356	21	2018-05-13	\N	0	\N	-1	89010e0b-74f4-43f9-be0d-f6b83045feb7
346	70	wordcloud.txt	\N	0	\N	-1	2522b4b7-99b8-48fb-9206-d658e4672baa
328	70	wordcloud.txt	\N	0	\N	-1	864216a8-2cc4-4796-bd22-b14eb1b71e85
329	61	/home/dspace/upload/wordcloud.txt	\N	0	\N	-1	864216a8-2cc4-4796-bd22-b14eb1b71e85
330	32		\N	0	\N	-1	864216a8-2cc4-4796-bd22-b14eb1b71e85
331	70	LICENSE	\N	1	\N	-1	07c4f7ff-069a-4fde-8620-aa70b4156f54
347	61	/home/dspace/upload/wordcloud.txt	\N	0	\N	-1	2522b4b7-99b8-48fb-9206-d658e4672baa
332	70	license.txt	\N	0	\N	-1	bce59918-0051-4f67-af90-a9c05e36efd8
333	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	bce59918-0051-4f67-af90-a9c05e36efd8
334	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T17:27:35Z\nNo. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)	en	0	\N	-1	75e52dde-8992-4237-9b42-7004977bd3d7
335	31	http://10.130.9.111/jspui/handle/123456789/22	\N	0	\N	-1	75e52dde-8992-4237-9b42-7004977bd3d7
348	32		\N	0	\N	-1	2522b4b7-99b8-48fb-9206-d658e4672baa
349	70	LICENSE	\N	1	\N	-1	96ff33e7-2956-48ea-af67-2f5366ae3191
339	34	Made available in DSpace on 2018-06-21T17:27:35Z (GMT). No. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)\n  Previous issue date: 2018-04-13	en	1	\N	-1	75e52dde-8992-4237-9b42-7004977bd3d7
336	17	2018-06-21T17:27:35Z	\N	0	\N	-1	75e52dde-8992-4237-9b42-7004977bd3d7
337	18	2018-06-21T17:27:35Z	\N	0	\N	-1	75e52dde-8992-4237-9b42-7004977bd3d7
338	21	2018-04-13	\N	0	\N	-1	75e52dde-8992-4237-9b42-7004977bd3d7
340	9	john guttag	\N	0	\N	-1	89010e0b-74f4-43f9-be0d-f6b83045feb7
341	70	Functions	en_US	0	\N	-1	89010e0b-74f4-43f9-be0d-f6b83045feb7
343	63	block, control,  statements, return type, arguments, parameters	en_US	0	\N	-1	89010e0b-74f4-43f9-be0d-f6b83045feb7
350	70	license.txt	\N	0	\N	-1	6daaa47a-986c-42f5-ae59-b49fd3ca5c19
351	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	6daaa47a-986c-42f5-ae59-b49fd3ca5c19
352	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T17:30:21Z\nNo. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)	en	0	\N	-1	89010e0b-74f4-43f9-be0d-f6b83045feb7
353	31	http://10.130.9.111/jspui/handle/123456789/23	\N	0	\N	-1	89010e0b-74f4-43f9-be0d-f6b83045feb7
361	63	for , while ,do while , break , continue	en_US	0	\N	-1	fa1c2a6a-f594-4746-934c-f901c60f2d5a
362	33	Loops and iteration complete our four basic programming patterns. Loops are the way we tell Python to do something over and over. Loops are the way we build programs that stay with a problem until the problem is solved.	en_US	0	\N	-1	fa1c2a6a-f594-4746-934c-f901c60f2d5a
357	34	Made available in DSpace on 2018-06-21T17:30:21Z (GMT). No. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)\n  Previous issue date: 2018-05-13	en	1	\N	-1	89010e0b-74f4-43f9-be0d-f6b83045feb7
354	17	2018-06-21T17:30:21Z	\N	0	\N	-1	89010e0b-74f4-43f9-be0d-f6b83045feb7
358	9	john guttag	\N	0	\N	-1	fa1c2a6a-f594-4746-934c-f901c60f2d5a
359	70	Loops and Iteration	en_US	0	\N	-1	fa1c2a6a-f594-4746-934c-f901c60f2d5a
363	70	ORIGINAL	\N	1	\N	-1	c0079563-57d3-4efc-a576-e6ea19f5a8d7
367	70	LICENSE	\N	1	\N	-1	dcaae3de-8a3c-4f5f-adad-32b869c47f74
364	70	wordcloud.txt	\N	0	\N	-1	b60be1f9-c245-49d4-8fbb-aa98ef07c01e
365	61	/home/dspace/upload/wordcloud.txt	\N	0	\N	-1	b60be1f9-c245-49d4-8fbb-aa98ef07c01e
366	32		\N	0	\N	-1	b60be1f9-c245-49d4-8fbb-aa98ef07c01e
368	70	license.txt	\N	0	\N	-1	993c2eda-5a7e-4c77-b845-a8fbc12b782a
369	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	993c2eda-5a7e-4c77-b845-a8fbc12b782a
370	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T17:32:09Z\nNo. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)	en	0	\N	-1	fa1c2a6a-f594-4746-934c-f901c60f2d5a
371	31	http://10.130.9.111/jspui/handle/123456789/24	\N	0	\N	-1	fa1c2a6a-f594-4746-934c-f901c60f2d5a
548	21	2017-01-01	\N	0	\N	-1	8c6e25d5-1d1f-47fb-9888-894e04e4592c
402	33	Machine learning is the science of getting computers to act without being explicitly programmed.	\N	0	\N	-1	b85a9096-4fb2-4d61-a9ff-de5ddbc122cc
403	32	This course provides a broad introduction to machine learning, datamining, and statistical pattern recognition. Topics include: (i) Supervised learning (parametric/non-parametric algorithms, support vector machines, kernels, neural networks). (ii) Unsupervised learning (clustering, dimensionality reduction, recommender systems, deep learning). (iii) Best practices in machine learning (bias/variance theory; innovation process in machine learning and AI). The course will also draw from numerous case studies and applications, so that you'll also learn how to apply learning algorithms to building smart robots (perception, control), text understanding (web search, anti-spam), computer vision, medical informatics, audio, database mining, and other areas.	\N	0	\N	-1	b85a9096-4fb2-4d61-a9ff-de5ddbc122cc
375	34	Made available in DSpace on 2018-06-21T17:32:09Z (GMT). No. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)\n  Previous issue date: 2018-06-13	en	1	\N	-1	fa1c2a6a-f594-4746-934c-f901c60f2d5a
372	17	2018-06-21T17:32:09Z	\N	0	\N	-1	fa1c2a6a-f594-4746-934c-f901c60f2d5a
373	18	2018-06-21T17:32:09Z	\N	0	\N	-1	fa1c2a6a-f594-4746-934c-f901c60f2d5a
374	21	2018-06-13	\N	0	\N	-1	fa1c2a6a-f594-4746-934c-f901c60f2d5a
549	34	Made available in DSpace on 2018-06-22T05:41:48Z (GMT). No. of bitstreams: 1\nedited_0801CS151045_BE_CS_Mudra_Sahu.pdf: 329047 bytes, checksum: 8da5f569bdf7a51b5ff69d06c2e842ed (MD5)\n  Previous issue date: 2017-01-01	en	1	\N	-1	8c6e25d5-1d1f-47fb-9888-894e04e4592c
376	9	john guttag	\N	0	\N	-1	c636ac62-1683-4b64-a42c-c38fc57c0f89
377	70	Conditional Code	en_US	0	\N	-1	c636ac62-1683-4b64-a42c-c38fc57c0f89
379	63	if , else if ,else ,break, true , false ,	en_US	0	\N	-1	c636ac62-1683-4b64-a42c-c38fc57c0f89
380	33	In this section we move from sequential code that simply runs one line of code after another to conditional code where some steps are skipped. It is a very simple concept - but it is how computer software makes "choices".	en_US	0	\N	-1	c636ac62-1683-4b64-a42c-c38fc57c0f89
381	70	ORIGINAL	\N	1	\N	-1	815fed71-ea32-4bf7-8b87-137ce9894d24
546	17	2018-06-22T05:41:48Z	\N	0	\N	-1	8c6e25d5-1d1f-47fb-9888-894e04e4592c
404	9	Andrew Ng	\N	0	\N	-1	ea6298eb-c495-43f0-9b47-81ee583acee5
382	70	wordcloud.txt	\N	0	\N	-1	7c48b00e-ddab-4a40-af07-8e9fc6a651d9
383	61	/home/dspace/upload/wordcloud.txt	\N	0	\N	-1	7c48b00e-ddab-4a40-af07-8e9fc6a651d9
384	32		\N	0	\N	-1	7c48b00e-ddab-4a40-af07-8e9fc6a651d9
385	70	LICENSE	\N	1	\N	-1	ff92dae9-5899-4088-8459-af661f0dd874
405	70	Introduction to ML	en_US	0	\N	-1	ea6298eb-c495-43f0-9b47-81ee583acee5
422	9	Andrew Ng	\N	0	\N	-1	0a4bcc97-9ec2-4dae-b11c-2d868623cb49
386	70	license.txt	\N	0	\N	-1	08d106a8-1ffc-42e2-9345-cdbbf5e25640
387	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	08d106a8-1ffc-42e2-9345-cdbbf5e25640
388	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T17:34:14Z\nNo. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)	en	0	\N	-1	c636ac62-1683-4b64-a42c-c38fc57c0f89
389	31	http://10.130.9.111/jspui/handle/123456789/25	\N	0	\N	-1	c636ac62-1683-4b64-a42c-c38fc57c0f89
407	63	Supervised Learning, Unsupervised Learning	en_US	0	\N	-1	ea6298eb-c495-43f0-9b47-81ee583acee5
393	34	Made available in DSpace on 2018-06-21T17:34:14Z (GMT). No. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)\n  Previous issue date: 2018-03-13	en	1	\N	-1	c636ac62-1683-4b64-a42c-c38fc57c0f89
390	17	2018-06-21T17:34:14Z	\N	0	\N	-1	c636ac62-1683-4b64-a42c-c38fc57c0f89
391	18	2018-06-21T17:34:14Z	\N	0	\N	-1	c636ac62-1683-4b64-a42c-c38fc57c0f89
392	21	2018-03-13	\N	0	\N	-1	c636ac62-1683-4b64-a42c-c38fc57c0f89
408	33	Welcome to Machine Learning! In this module, we introduce the core idea of teaching a computer to learn concepts using data—without being explicitly programmed. The Course Wiki is under construction. Please visit the resources tab for the most complete and up-to-date information.	en_US	0	\N	-1	ea6298eb-c495-43f0-9b47-81ee583acee5
413	70	LICENSE	\N	1	\N	-1	d50a4391-97bd-443b-8a35-b8f3558509ae
423	70	Linear Regression with One Variable	en_US	0	\N	-1	0a4bcc97-9ec2-4dae-b11c-2d868623cb49
414	70	license.txt	\N	0	\N	-1	c9fb30a3-6e29-48f4-836e-8241805c086d
401	70	Machine Learning	\N	0	\N	-1	b85a9096-4fb2-4d61-a9ff-de5ddbc122cc
409	70	ORIGINAL	\N	1	\N	-1	32fdc0cb-eb32-405e-bb25-3b6fbdd584e1
415	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	c9fb30a3-6e29-48f4-836e-8241805c086d
410	70	wordcloud.txt	\N	0	\N	-1	b0fd981f-85b2-46f0-a1a6-8670732577d9
411	61	/home/dspace/upload/wordcloud.txt	\N	0	\N	-1	b0fd981f-85b2-46f0-a1a6-8670732577d9
412	32		\N	0	\N	-1	b0fd981f-85b2-46f0-a1a6-8670732577d9
416	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T18:04:54Z\nNo. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)	en	0	\N	-1	ea6298eb-c495-43f0-9b47-81ee583acee5
417	31	http://10.130.9.111/jspui/handle/123456789/27	\N	0	\N	-1	ea6298eb-c495-43f0-9b47-81ee583acee5
425	63	Model Representation, Cost Function, Gradient Descent	en_US	0	\N	-1	0a4bcc97-9ec2-4dae-b11c-2d868623cb49
421	34	Made available in DSpace on 2018-06-21T18:04:54Z (GMT). No. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)\n  Previous issue date: 2018-04-23	en	1	\N	-1	ea6298eb-c495-43f0-9b47-81ee583acee5
418	17	2018-06-21T18:04:54Z	\N	0	\N	-1	ea6298eb-c495-43f0-9b47-81ee583acee5
419	18	2018-06-21T18:04:54Z	\N	0	\N	-1	ea6298eb-c495-43f0-9b47-81ee583acee5
420	21	2018-04-23	\N	0	\N	-1	ea6298eb-c495-43f0-9b47-81ee583acee5
426	33	Linear regression predicts a real-valued output based on an input value. We discuss the application of linear regression to housing price prediction, present the notion of a cost function, and introduce the gradient descent method for learning.	en_US	0	\N	-1	0a4bcc97-9ec2-4dae-b11c-2d868623cb49
427	70	ORIGINAL	\N	1	\N	-1	9d4327b4-82d3-41c6-b291-43a7e13133f3
430	32		\N	0	\N	-1	fb4f2a26-b5b1-4757-8e79-b786f0e8a46b
428	70	wordcloud.txt	\N	0	\N	-1	fb4f2a26-b5b1-4757-8e79-b786f0e8a46b
429	61	/home/dspace/upload/wordcloud.txt	\N	0	\N	-1	fb4f2a26-b5b1-4757-8e79-b786f0e8a46b
431	70	LICENSE	\N	1	\N	-1	7dd0e346-25c3-461f-b02e-2b3f853abe00
432	70	license.txt	\N	0	\N	-1	827bffbd-a853-4955-a0ef-f285241bedfc
433	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	827bffbd-a853-4955-a0ef-f285241bedfc
493	34	Made available in DSpace on 2018-06-21T18:12:58Z (GMT). No. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)\n  Previous issue date: 2018-06-25	en	1	\N	-1	24d6bdce-432d-481f-8417-f1b9fca3c745
434	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T18:06:35Z\nNo. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)	en	0	\N	-1	0a4bcc97-9ec2-4dae-b11c-2d868623cb49
435	31	http://10.130.9.111/jspui/handle/123456789/28	\N	0	\N	-1	0a4bcc97-9ec2-4dae-b11c-2d868623cb49
466	32		\N	0	\N	-1	62864ee6-212d-4336-aa23-10b53876c33f
439	34	Made available in DSpace on 2018-06-21T18:06:35Z (GMT). No. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)\n  Previous issue date: 2018-04-23	en	1	\N	-1	0a4bcc97-9ec2-4dae-b11c-2d868623cb49
436	17	2018-06-21T18:06:35Z	\N	0	\N	-1	0a4bcc97-9ec2-4dae-b11c-2d868623cb49
437	18	2018-06-21T18:06:35Z	\N	0	\N	-1	0a4bcc97-9ec2-4dae-b11c-2d868623cb49
438	21	2018-04-23	\N	0	\N	-1	0a4bcc97-9ec2-4dae-b11c-2d868623cb49
547	18	2018-06-22T05:41:48Z	\N	0	\N	-1	8c6e25d5-1d1f-47fb-9888-894e04e4592c
440	9	Andrew Ng	\N	0	\N	-1	2badb32c-192a-457f-8eee-9aa548441cf4
441	70	Linear Algebra Review	en_US	0	\N	-1	2badb32c-192a-457f-8eee-9aa548441cf4
467	70	LICENSE	\N	1	\N	-1	7ef63ce2-b0cc-47c2-97c7-74c9cf2c927f
443	63	Matrices and Vectors, Addition and Scalar Multiplication, , Matrix Vector Multiplication,  Inverse and Transpose	en_US	0	\N	-1	2badb32c-192a-457f-8eee-9aa548441cf4
444	33	This optional module provides a refresher on linear algebra concepts. Basic understanding of linear algebra is necessary for the rest of the course, especially as we begin to cover models with multiple variables.	en_US	0	\N	-1	2badb32c-192a-457f-8eee-9aa548441cf4
445	70	ORIGINAL	\N	1	\N	-1	a1f8f03a-1fae-43c9-b85d-5edd6742876d
446	70	wordcloud.txt	\N	0	\N	-1	5a4943d5-155f-4ba9-ac21-a1c42db7624b
447	61	/home/dspace/upload/wordcloud.txt	\N	0	\N	-1	5a4943d5-155f-4ba9-ac21-a1c42db7624b
448	32		\N	0	\N	-1	5a4943d5-155f-4ba9-ac21-a1c42db7624b
449	70	LICENSE	\N	1	\N	-1	b2b82808-7008-4b71-b3f0-c2def986c957
480	33	Logistic regression is a method for classifying data into discrete outcomes. For example, we might use logistic regression to classify an email as spam or not spam. In this module, we introduce the notion of classification, the cost function for logistic regression, and the application of logistic regression to multi-class classification.	en_US	0	\N	-1	24d6bdce-432d-481f-8417-f1b9fca3c745
450	70	license.txt	\N	0	\N	-1	cf56643a-2485-499f-96e4-08970d0b625f
451	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	cf56643a-2485-499f-96e4-08970d0b625f
452	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T18:08:46Z\nNo. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)	en	0	\N	-1	2badb32c-192a-457f-8eee-9aa548441cf4
453	31	http://10.130.9.111/jspui/handle/123456789/29	\N	0	\N	-1	2badb32c-192a-457f-8eee-9aa548441cf4
468	70	license.txt	\N	0	\N	-1	481daa37-0f1d-4fba-ba2a-091e703471d0
469	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	481daa37-0f1d-4fba-ba2a-091e703471d0
457	34	Made available in DSpace on 2018-06-21T18:08:46Z (GMT). No. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)\n  Previous issue date: 2018-05-23	en	1	\N	-1	2badb32c-192a-457f-8eee-9aa548441cf4
454	17	2018-06-21T18:08:46Z	\N	0	\N	-1	2badb32c-192a-457f-8eee-9aa548441cf4
455	18	2018-06-21T18:08:46Z	\N	0	\N	-1	2badb32c-192a-457f-8eee-9aa548441cf4
456	21	2018-05-23	\N	0	\N	-1	2badb32c-192a-457f-8eee-9aa548441cf4
458	9	Andrew Ng	\N	0	\N	-1	aebacdd7-f06c-45a0-9854-9e12f2103902
459	70	Linear Regression with Multiple Variables	en_US	0	\N	-1	aebacdd7-f06c-45a0-9854-9e12f2103902
481	70	ORIGINAL	\N	1	\N	-1	8331723c-d2b7-4274-a3f0-ab6c8c782fcb
461	63	Multiple Features, Gradient Descent ,  Feature Scaling, Features and Polynomial Regression	en_US	0	\N	-1	aebacdd7-f06c-45a0-9854-9e12f2103902
462	33	What if your input has more than one value? In this module, we show how linear regression can be extended to accommodate multiple input features. We also discuss best practices for implementing linear regression.	en_US	0	\N	-1	aebacdd7-f06c-45a0-9854-9e12f2103902
463	70	ORIGINAL	\N	1	\N	-1	bf1beb12-c719-4a7e-997e-dc13d5534198
470	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T18:10:58Z\nNo. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)	en	0	\N	-1	aebacdd7-f06c-45a0-9854-9e12f2103902
464	70	wordcloud.txt	\N	0	\N	-1	62864ee6-212d-4336-aa23-10b53876c33f
465	61	/home/dspace/upload/wordcloud.txt	\N	0	\N	-1	62864ee6-212d-4336-aa23-10b53876c33f
471	31	http://10.130.9.111/jspui/handle/123456789/30	\N	0	\N	-1	aebacdd7-f06c-45a0-9854-9e12f2103902
485	70	LICENSE	\N	1	\N	-1	6f4f1048-3377-42ca-bce0-70923275a958
475	34	Made available in DSpace on 2018-06-21T18:10:58Z (GMT). No. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)\n  Previous issue date: 2018-06-24	en	1	\N	-1	aebacdd7-f06c-45a0-9854-9e12f2103902
472	17	2018-06-21T18:10:58Z	\N	0	\N	-1	aebacdd7-f06c-45a0-9854-9e12f2103902
473	18	2018-06-21T18:10:58Z	\N	0	\N	-1	aebacdd7-f06c-45a0-9854-9e12f2103902
474	21	2018-06-24	\N	0	\N	-1	aebacdd7-f06c-45a0-9854-9e12f2103902
476	9	Andrew Ng	\N	0	\N	-1	24d6bdce-432d-481f-8417-f1b9fca3c745
477	70	Logistic Regression	en_US	0	\N	-1	24d6bdce-432d-481f-8417-f1b9fca3c745
479	63	Hypothesis Representation, Decision Boundary, Cost Function, Simplified Cost Function and Gradient Descent	en_US	0	\N	-1	24d6bdce-432d-481f-8417-f1b9fca3c745
482	70	wordcloud.txt	\N	0	\N	-1	27faba85-6cd4-4258-afd0-0ad4e8c60ee3
483	61	/home/dspace/upload/wordcloud.txt	\N	0	\N	-1	27faba85-6cd4-4258-afd0-0ad4e8c60ee3
484	32		\N	0	\N	-1	27faba85-6cd4-4258-afd0-0ad4e8c60ee3
550	9	Peter, Linz	\N	0	\N	-1	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
551	70	Flat -2	en_US	0	\N	-1	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
486	70	license.txt	\N	0	\N	-1	288c7b7f-5138-40cf-8922-3fcc9521b868
487	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	288c7b7f-5138-40cf-8922-3fcc9521b868
488	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-21T18:12:58Z\nNo. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)	en	0	\N	-1	24d6bdce-432d-481f-8417-f1b9fca3c745
489	31	http://10.130.9.111/jspui/handle/123456789/31	\N	0	\N	-1	24d6bdce-432d-481f-8417-f1b9fca3c745
490	17	2018-06-21T18:12:58Z	\N	0	\N	-1	24d6bdce-432d-481f-8417-f1b9fca3c745
491	18	2018-06-21T18:12:58Z	\N	0	\N	-1	24d6bdce-432d-481f-8417-f1b9fca3c745
492	21	2018-06-25	\N	0	\N	-1	24d6bdce-432d-481f-8417-f1b9fca3c745
494	70	Java	\N	0	\N	-1	ddbcf1bb-b3eb-4a76-8936-912786ddbe79
495	33	test 2	\N	0	\N	-1	ddbcf1bb-b3eb-4a76-8936-912786ddbe79
559	63	introduction_flat	en_US	0	\N	-1	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
560	63	continute	en_US	1	\N	-1	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
561	63	regular expression	en_US	2	\N	-1	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
562	63	regular language	en_US	3	\N	-1	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
563	70	ORIGINAL	\N	1	\N	-1	19727d4e-ea29-4695-ba0f-ef42a24e7d2b
587	70	marksheet10.pdf	\N	0	\N	-1	06c28b52-5b08-4aac-b946-7db8e024b91a
564	70	marksheet10.pdf	\N	0	\N	-1	f73aec6a-8837-4fbd-bdc7-a5cac842a210
565	61	/home/dspace/upload/marksheet10.pdf	\N	0	\N	-1	f73aec6a-8837-4fbd-bdc7-a5cac842a210
566	32		\N	0	\N	-1	f73aec6a-8837-4fbd-bdc7-a5cac842a210
567	70	LICENSE	\N	1	\N	-1	076a0596-b1d7-4db4-a5f0-b8cf8ff524df
588	61	/home/dspace/upload/marksheet10.pdf	\N	0	\N	-1	06c28b52-5b08-4aac-b946-7db8e024b91a
568	70	license.txt	\N	0	\N	-1	1c315c05-38b9-4642-be4b-e2d231bb1169
569	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	1c315c05-38b9-4642-be4b-e2d231bb1169
570	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-22T05:44:34Z\nNo. of bitstreams: 1\nmarksheet10.pdf: 61085 bytes, checksum: 0d30657a09d7dcc2aed6bbcce856e7e8 (MD5)	en	0	\N	-1	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
512	70	CS	\N	0	\N	-1	0d605059-7875-4b76-b70e-c49dc73c3dbe
513	33	subjects of cse	\N	0	\N	-1	0d605059-7875-4b76-b70e-c49dc73c3dbe
571	31	http://10.130.9.111/jspui/handle/123456789/37	\N	0	\N	-1	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
589	32		\N	0	\N	-1	06c28b52-5b08-4aac-b946-7db8e024b91a
590	70	LICENSE	\N	1	\N	-1	b961e9d0-2b79-4802-843e-05b3b929c1a3
575	34	Made available in DSpace on 2018-06-22T05:44:34Z (GMT). No. of bitstreams: 1\nmarksheet10.pdf: 61085 bytes, checksum: 0d30657a09d7dcc2aed6bbcce856e7e8 (MD5)\n  Previous issue date: 2017-01-02	en	1	\N	-1	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
572	17	2018-06-22T05:44:34Z	\N	0	\N	-1	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
573	18	2018-06-22T05:44:34Z	\N	0	\N	-1	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
574	21	2017-01-02	\N	0	\N	-1	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
521	70	Formal Language and Automata Theory	\N	0	\N	-1	54bab732-de98-4acc-b69f-8738383c06d2
522	33		\N	0	\N	-1	54bab732-de98-4acc-b69f-8738383c06d2
523	9	Peter, Linz	\N	0	\N	-1	8c6e25d5-1d1f-47fb-9888-894e04e4592c
524	70	Flat -1	en_US	0	\N	-1	8c6e25d5-1d1f-47fb-9888-894e04e4592c
578	9	Peter, Linz	\N	0	\N	-1	f9b95515-f187-44dc-b2f7-62ec48ac88ce
579	70	Flat -3	en_US	0	\N	-1	f9b95515-f187-44dc-b2f7-62ec48ac88ce
609	70	marksheet10.pdf	\N	0	\N	-1	7109a357-c47f-4b04-a2a7-fee0c0b92f6d
532	63	language	en_US	0	\N	-1	8c6e25d5-1d1f-47fb-9888-894e04e4592c
533	63	symbol	en_US	1	\N	-1	8c6e25d5-1d1f-47fb-9888-894e04e4592c
534	63	alphabet	en_US	2	\N	-1	8c6e25d5-1d1f-47fb-9888-894e04e4592c
535	63	flat	en_US	3	\N	-1	8c6e25d5-1d1f-47fb-9888-894e04e4592c
536	63	introduction	en_US	4	\N	-1	8c6e25d5-1d1f-47fb-9888-894e04e4592c
583	63	finiteautomata	en_US	0	\N	-1	f9b95515-f187-44dc-b2f7-62ec48ac88ce
584	63	regular expressions	en_US	1	\N	-1	f9b95515-f187-44dc-b2f7-62ec48ac88ce
585	63	pumping lemma	en_US	2	\N	-1	f9b95515-f187-44dc-b2f7-62ec48ac88ce
586	70	ORIGINAL	\N	1	\N	-1	b59b4e13-6b97-4759-9d11-d6f4f0044cce
610	61	/home/dspace/upload/marksheet10.pdf	\N	0	\N	-1	7109a357-c47f-4b04-a2a7-fee0c0b92f6d
591	70	license.txt	\N	0	\N	-1	58311eb7-934a-4410-bae3-b8371355d96b
592	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	58311eb7-934a-4410-bae3-b8371355d96b
593	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-22T05:46:28Z\nNo. of bitstreams: 1\nmarksheet10.pdf: 61085 bytes, checksum: 0d30657a09d7dcc2aed6bbcce856e7e8 (MD5)	en	0	\N	-1	f9b95515-f187-44dc-b2f7-62ec48ac88ce
594	31	http://10.130.9.111/jspui/handle/123456789/38	\N	0	\N	-1	f9b95515-f187-44dc-b2f7-62ec48ac88ce
598	34	Made available in DSpace on 2018-06-22T05:46:28Z (GMT). No. of bitstreams: 1\nmarksheet10.pdf: 61085 bytes, checksum: 0d30657a09d7dcc2aed6bbcce856e7e8 (MD5)\n  Previous issue date: 2017-01-03	en	1	\N	-1	f9b95515-f187-44dc-b2f7-62ec48ac88ce
595	17	2018-06-22T05:46:28Z	\N	0	\N	-1	f9b95515-f187-44dc-b2f7-62ec48ac88ce
596	18	2018-06-22T05:46:28Z	\N	0	\N	-1	f9b95515-f187-44dc-b2f7-62ec48ac88ce
597	21	2017-01-03	\N	0	\N	-1	f9b95515-f187-44dc-b2f7-62ec48ac88ce
599	9	Peter, Linz	\N	0	\N	-1	530d1403-ff34-485d-8ee4-3f186f019bf7
600	70	Flat -4	en_US	0	\N	-1	530d1403-ff34-485d-8ee4-3f186f019bf7
604	63	context free grammar	en_US	0	\N	-1	530d1403-ff34-485d-8ee4-3f186f019bf7
605	63	CFG	en_US	1	\N	-1	530d1403-ff34-485d-8ee4-3f186f019bf7
606	63	parsing	en_US	2	\N	-1	530d1403-ff34-485d-8ee4-3f186f019bf7
607	63	chomsky normal form	en_US	3	\N	-1	530d1403-ff34-485d-8ee4-3f186f019bf7
608	70	ORIGINAL	\N	1	\N	-1	1ec8dff4-d4ff-42c3-a9e6-54744d5bc6f8
613	70	license.txt	\N	0	\N	-1	2634c301-12e5-418e-9fbb-ab0b9561aafc
614	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	2634c301-12e5-418e-9fbb-ab0b9561aafc
611	32		\N	0	\N	-1	7109a357-c47f-4b04-a2a7-fee0c0b92f6d
612	70	LICENSE	\N	1	\N	-1	36d8c81e-90c2-43cc-b881-78122115f2e1
615	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-22T05:48:27Z\nNo. of bitstreams: 1\nmarksheet10.pdf: 61085 bytes, checksum: 0d30657a09d7dcc2aed6bbcce856e7e8 (MD5)	en	0	\N	-1	530d1403-ff34-485d-8ee4-3f186f019bf7
616	31	http://10.130.9.111/jspui/handle/123456789/39	\N	0	\N	-1	530d1403-ff34-485d-8ee4-3f186f019bf7
620	34	Made available in DSpace on 2018-06-22T05:48:27Z (GMT). No. of bitstreams: 1\nmarksheet10.pdf: 61085 bytes, checksum: 0d30657a09d7dcc2aed6bbcce856e7e8 (MD5)\n  Previous issue date: 2017-01-05	en	1	\N	-1	530d1403-ff34-485d-8ee4-3f186f019bf7
617	17	2018-06-22T05:48:27Z	\N	0	\N	-1	530d1403-ff34-485d-8ee4-3f186f019bf7
618	18	2018-06-22T05:48:27Z	\N	0	\N	-1	530d1403-ff34-485d-8ee4-3f186f019bf7
619	21	2017-01-05	\N	0	\N	-1	530d1403-ff34-485d-8ee4-3f186f019bf7
657	63	introduction_CD	en_US	0	\N	-1	c8ac9256-7951-49b1-ae86-a41be7894406
658	63	continute	en_US	1	\N	-1	c8ac9256-7951-49b1-ae86-a41be7894406
659	63	low level program	en_US	2	\N	-1	c8ac9256-7951-49b1-ae86-a41be7894406
660	63	object code	en_US	3	\N	-1	c8ac9256-7951-49b1-ae86-a41be7894406
661	70	ORIGINAL	\N	1	\N	-1	da8c4a2a-1001-45f6-a3ea-33abedf18e74
628	70	Compiler Design	\N	0	\N	-1	9ecd6365-9d96-49bb-a656-c2ccab8653e2
629	33	CD	\N	0	\N	-1	9ecd6365-9d96-49bb-a656-c2ccab8653e2
630	9	Aho, Ullman	\N	0	\N	-1	15fb5a68-0e00-485f-96e8-c10a3dab8007
631	70	CD -1	en_US	0	\N	-1	15fb5a68-0e00-485f-96e8-c10a3dab8007
674	9	Aho, Ullman	\N	0	\N	-1	a7396fa7-6c95-4712-a053-22f60d852f70
675	70	CD -3	en_US	0	\N	-1	a7396fa7-6c95-4712-a053-22f60d852f70
635	63	introduction_CD	en_US	0	\N	-1	15fb5a68-0e00-485f-96e8-c10a3dab8007
636	63	compiler design	en_US	1	\N	-1	15fb5a68-0e00-485f-96e8-c10a3dab8007
637	63	assembler	en_US	2	\N	-1	15fb5a68-0e00-485f-96e8-c10a3dab8007
638	63	program execution	en_US	3	\N	-1	15fb5a68-0e00-485f-96e8-c10a3dab8007
639	70	ORIGINAL	\N	1	\N	-1	f4de32b9-043d-4b0f-b400-86fa3df1fb01
640	70	Jumanji.1995.720p.BrRip.x264.BOKUTOX.YIFY.srt	\N	0	\N	-1	60b58afa-a7ce-4ca2-91ad-607fbc0264c0
641	61	/home/dspace/upload/Jumanji.1995.720p.BrRip.x264.BOKUTOX.YIFY.srt	\N	0	\N	-1	60b58afa-a7ce-4ca2-91ad-607fbc0264c0
642	32		\N	0	\N	-1	60b58afa-a7ce-4ca2-91ad-607fbc0264c0
643	70	LICENSE	\N	1	\N	-1	d2896b5f-1280-4fcd-8a57-3709f3ddb817
662	70	marksheet12.pdf	\N	0	\N	-1	c7d9baf3-edb7-42d9-b3cd-d32eba23954c
663	61	/home/dspace/upload/marksheet12.pdf	\N	0	\N	-1	c7d9baf3-edb7-42d9-b3cd-d32eba23954c
644	70	license.txt	\N	0	\N	-1	6234b407-7244-4b13-b9d8-9652ce66a0ca
645	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	6234b407-7244-4b13-b9d8-9652ce66a0ca
646	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-22T05:50:59Z\nNo. of bitstreams: 1\nJumanji.1995.720p.BrRip.x264.BOKUTOX.YIFY.srt: 69047 bytes, checksum: 9db2f21e29d2f17bdb71d6c1ed111cea (MD5)	en	0	\N	-1	15fb5a68-0e00-485f-96e8-c10a3dab8007
647	31	http://10.130.9.111/jspui/handle/123456789/41	\N	0	\N	-1	15fb5a68-0e00-485f-96e8-c10a3dab8007
664	32		\N	0	\N	-1	c7d9baf3-edb7-42d9-b3cd-d32eba23954c
651	34	Made available in DSpace on 2018-06-22T05:50:59Z (GMT). No. of bitstreams: 1\nJumanji.1995.720p.BrRip.x264.BOKUTOX.YIFY.srt: 69047 bytes, checksum: 9db2f21e29d2f17bdb71d6c1ed111cea (MD5)\n  Previous issue date: 2017-02-03	en	1	\N	-1	15fb5a68-0e00-485f-96e8-c10a3dab8007
648	17	2018-06-22T05:50:59Z	\N	0	\N	-1	15fb5a68-0e00-485f-96e8-c10a3dab8007
649	18	2018-06-22T05:50:59Z	\N	0	\N	-1	15fb5a68-0e00-485f-96e8-c10a3dab8007
650	21	2017-02-03	\N	0	\N	-1	15fb5a68-0e00-485f-96e8-c10a3dab8007
652	9	Aho, Ullman	\N	0	\N	-1	c8ac9256-7951-49b1-ae86-a41be7894406
653	70	CD -2	en_US	0	\N	-1	c8ac9256-7951-49b1-ae86-a41be7894406
665	70	LICENSE	\N	1	\N	-1	fd787dfc-ee8f-4463-a69d-fad1db917bdd
687	70	LICENSE	\N	1	\N	-1	f91fbf0e-92c9-4ceb-b35c-748bfd9e277f
666	70	license.txt	\N	0	\N	-1	617a3a58-26b1-4992-bb50-0a484bfedadf
667	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	617a3a58-26b1-4992-bb50-0a484bfedadf
668	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-22T05:53:17Z\nNo. of bitstreams: 1\nmarksheet12.pdf: 85097 bytes, checksum: 00a376d460e83aad438fcf167be79d40 (MD5)	en	0	\N	-1	c8ac9256-7951-49b1-ae86-a41be7894406
669	31	http://10.130.9.111/jspui/handle/123456789/42	\N	0	\N	-1	c8ac9256-7951-49b1-ae86-a41be7894406
673	34	Made available in DSpace on 2018-06-22T05:53:17Z (GMT). No. of bitstreams: 1\nmarksheet12.pdf: 85097 bytes, checksum: 00a376d460e83aad438fcf167be79d40 (MD5)\n  Previous issue date: 2017-02-04	en	1	\N	-1	c8ac9256-7951-49b1-ae86-a41be7894406
670	17	2018-06-22T05:53:17Z	\N	0	\N	-1	c8ac9256-7951-49b1-ae86-a41be7894406
671	18	2018-06-22T05:53:17Z	\N	0	\N	-1	c8ac9256-7951-49b1-ae86-a41be7894406
672	21	2017-02-04	\N	0	\N	-1	c8ac9256-7951-49b1-ae86-a41be7894406
679	63	parsing	en_US	0	\N	-1	a7396fa7-6c95-4712-a053-22f60d852f70
680	63	chomsky normal form	en_US	1	\N	-1	a7396fa7-6c95-4712-a053-22f60d852f70
681	63	CFG	en_US	2	\N	-1	a7396fa7-6c95-4712-a053-22f60d852f70
682	63	context free grammar	en_US	3	\N	-1	a7396fa7-6c95-4712-a053-22f60d852f70
683	70	ORIGINAL	\N	1	\N	-1	48616940-8e7c-44d1-9ca7-1fb58dc561d0
684	70	mudra1.jpg	\N	0	\N	-1	bf8d7f49-ab53-4056-bcde-3fa29c87b9a4
685	61	/home/dspace/upload/mudra1.jpg	\N	0	\N	-1	bf8d7f49-ab53-4056-bcde-3fa29c87b9a4
686	32		\N	0	\N	-1	bf8d7f49-ab53-4056-bcde-3fa29c87b9a4
688	70	license.txt	\N	0	\N	-1	bc67c574-d6d7-42f3-be29-a557a17bac5b
689	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	bc67c574-d6d7-42f3-be29-a557a17bac5b
690	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-22T05:55:02Z\nNo. of bitstreams: 1\nmudra1.jpg: 972 bytes, checksum: d03d39d1bd1463ca6c82442772aca31a (MD5)	en	0	\N	-1	a7396fa7-6c95-4712-a053-22f60d852f70
691	31	http://10.130.9.111/jspui/handle/123456789/43	\N	0	\N	-1	a7396fa7-6c95-4712-a053-22f60d852f70
695	34	Made available in DSpace on 2018-06-22T05:55:02Z (GMT). No. of bitstreams: 1\nmudra1.jpg: 972 bytes, checksum: d03d39d1bd1463ca6c82442772aca31a (MD5)\n  Previous issue date: 2017-02-06	en	1	\N	-1	a7396fa7-6c95-4712-a053-22f60d852f70
692	17	2018-06-22T05:55:02Z	\N	0	\N	-1	a7396fa7-6c95-4712-a053-22f60d852f70
693	18	2018-06-22T05:55:02Z	\N	0	\N	-1	a7396fa7-6c95-4712-a053-22f60d852f70
694	21	2017-02-06	\N	0	\N	-1	a7396fa7-6c95-4712-a053-22f60d852f70
735	63	differentiation	en_US	3	\N	-1	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
736	70	ORIGINAL	\N	1	\N	-1	482e7f8c-7687-46c3-826d-fd1939ea3bbc
767	63	minima	en_US	2	\N	-1	320ddf01-74b8-435e-953d-adfa64de928f
768	63	maxima	en_US	3	\N	-1	320ddf01-74b8-435e-953d-adfa64de928f
703	70	Machine Learning	\N	0	\N	-1	ab76a5ce-1b6e-429a-87d5-404757fa848c
704	33	ML	\N	0	\N	-1	ab76a5ce-1b6e-429a-87d5-404757fa848c
705	9	Prasad, Vladmir	\N	0	\N	-1	1965ac82-4792-45e1-961a-1de7b843fc2f
706	70	ML -1	en_US	0	\N	-1	1965ac82-4792-45e1-961a-1de7b843fc2f
737	70	marksheet12.pdf	\N	0	\N	-1	aef9672a-a17e-4448-8163-46185e0daa6b
738	61	/home/dspace/upload/marksheet12.pdf	\N	0	\N	-1	aef9672a-a17e-4448-8163-46185e0daa6b
710	63	introduction_ML	en_US	0	\N	-1	1965ac82-4792-45e1-961a-1de7b843fc2f
711	63	model	en_US	1	\N	-1	1965ac82-4792-45e1-961a-1de7b843fc2f
712	63	testing data	en_US	2	\N	-1	1965ac82-4792-45e1-961a-1de7b843fc2f
713	63	training data	en_US	3	\N	-1	1965ac82-4792-45e1-961a-1de7b843fc2f
714	70	ORIGINAL	\N	1	\N	-1	3d5c95b0-1727-45a0-b0c5-a3835e80ef6c
739	32		\N	0	\N	-1	aef9672a-a17e-4448-8163-46185e0daa6b
715	70	mudra 8.jpg	\N	0	\N	-1	51dd5697-85ee-43f1-bcf3-ccbe02cf84e1
716	61	/home/dspace/upload/mudra 8.jpg	\N	0	\N	-1	51dd5697-85ee-43f1-bcf3-ccbe02cf84e1
717	32		\N	0	\N	-1	51dd5697-85ee-43f1-bcf3-ccbe02cf84e1
718	70	LICENSE	\N	1	\N	-1	87b2bbe8-4dc4-4f1f-9abb-c04562fb4feb
740	70	LICENSE	\N	1	\N	-1	97622e69-6bb7-4f81-bc71-5de1ab7aa10e
719	70	license.txt	\N	0	\N	-1	d73be20c-529c-4c77-9b21-365090f576c2
720	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	d73be20c-529c-4c77-9b21-365090f576c2
721	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-22T06:00:56Z\nNo. of bitstreams: 1\nmudra 8.jpg: 69947 bytes, checksum: ad7683dc0b0cd15e9b54bbac31330c74 (MD5)	en	0	\N	-1	1965ac82-4792-45e1-961a-1de7b843fc2f
722	31	http://10.130.9.111/jspui/handle/123456789/45	\N	0	\N	-1	1965ac82-4792-45e1-961a-1de7b843fc2f
769	70	ORIGINAL	\N	1	\N	-1	670e9a5a-7cb8-40f1-a42e-71207489aa2b
726	34	Made available in DSpace on 2018-06-22T06:00:56Z (GMT). No. of bitstreams: 1\nmudra 8.jpg: 69947 bytes, checksum: ad7683dc0b0cd15e9b54bbac31330c74 (MD5)\n  Previous issue date: 2017-04-23	en	1	\N	-1	1965ac82-4792-45e1-961a-1de7b843fc2f
723	17	2018-06-22T06:00:56Z	\N	0	\N	-1	1965ac82-4792-45e1-961a-1de7b843fc2f
724	18	2018-06-22T06:00:56Z	\N	0	\N	-1	1965ac82-4792-45e1-961a-1de7b843fc2f
725	21	2017-04-23	\N	0	\N	-1	1965ac82-4792-45e1-961a-1de7b843fc2f
727	9	Prasad, Vladmir	\N	0	\N	-1	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
728	70	ML -2	en_US	0	\N	-1	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
732	63	gradient descent	en_US	0	\N	-1	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
733	63	local maxima	en_US	1	\N	-1	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
734	63	local minima	en_US	2	\N	-1	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
741	70	license.txt	\N	0	\N	-1	02e23fc3-0aad-4f54-a65c-b19cc9bf2ecb
742	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	02e23fc3-0aad-4f54-a65c-b19cc9bf2ecb
743	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-22T06:02:15Z\nNo. of bitstreams: 1\nmarksheet12.pdf: 85097 bytes, checksum: 00a376d460e83aad438fcf167be79d40 (MD5)	en	0	\N	-1	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
744	31	http://10.130.9.111/jspui/handle/123456789/46	\N	0	\N	-1	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
758	70	Basic Math	\N	0	\N	-1	8c7e552a-5797-4dd1-a35b-85a265feeb3f
759	33	some basics	\N	0	\N	-1	8c7e552a-5797-4dd1-a35b-85a265feeb3f
748	34	Made available in DSpace on 2018-06-22T06:02:15Z (GMT). No. of bitstreams: 1\nmarksheet12.pdf: 85097 bytes, checksum: 00a376d460e83aad438fcf167be79d40 (MD5)\n  Previous issue date: 2017-05-17	en	1	\N	-1	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
745	17	2018-06-22T06:02:15Z	\N	0	\N	-1	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
746	18	2018-06-22T06:02:15Z	\N	0	\N	-1	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
747	21	2017-05-17	\N	0	\N	-1	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
749	70	Mathematics	\N	0	\N	-1	91ce1543-4a74-4c94-88dd-07986a7a676b
750	33	maths	\N	0	\N	-1	91ce1543-4a74-4c94-88dd-07986a7a676b
760	9	Ramanujan, Srinivas	\N	0	\N	-1	320ddf01-74b8-435e-953d-adfa64de928f
761	70	Math -1	en_US	0	\N	-1	320ddf01-74b8-435e-953d-adfa64de928f
774	70	license.txt	\N	0	\N	-1	453c6c0c-2699-4fec-b0f9-5a2752bd330d
775	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	453c6c0c-2699-4fec-b0f9-5a2752bd330d
765	63	introduction_MATH	en_US	0	\N	-1	320ddf01-74b8-435e-953d-adfa64de928f
766	63	differentiation	en_US	1	\N	-1	320ddf01-74b8-435e-953d-adfa64de928f
770	70	mudra 10.jpg	\N	0	\N	-1	050db052-de7e-48b1-90c7-3498e746d313
771	61	/home/dspace/upload/mudra 10.jpg	\N	0	\N	-1	050db052-de7e-48b1-90c7-3498e746d313
772	32		\N	0	\N	-1	050db052-de7e-48b1-90c7-3498e746d313
773	70	LICENSE	\N	1	\N	-1	7ab42eaa-6ee8-4ffb-bc49-b48e71f893ea
776	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-22T06:05:20Z\nNo. of bitstreams: 1\nmudra 10.jpg: 515866 bytes, checksum: c35e5b1c8ffb59c16c28ca35fabfc90a (MD5)	en	0	\N	-1	320ddf01-74b8-435e-953d-adfa64de928f
777	31	http://10.130.9.111/jspui/handle/123456789/49	\N	0	\N	-1	320ddf01-74b8-435e-953d-adfa64de928f
781	34	Made available in DSpace on 2018-06-22T06:05:20Z (GMT). No. of bitstreams: 1\nmudra 10.jpg: 515866 bytes, checksum: c35e5b1c8ffb59c16c28ca35fabfc90a (MD5)\n  Previous issue date: 2017-04-23	en	1	\N	-1	320ddf01-74b8-435e-953d-adfa64de928f
778	17	2018-06-22T06:05:20Z	\N	0	\N	-1	320ddf01-74b8-435e-953d-adfa64de928f
779	18	2018-06-22T06:05:20Z	\N	0	\N	-1	320ddf01-74b8-435e-953d-adfa64de928f
780	21	2017-04-23	\N	0	\N	-1	320ddf01-74b8-435e-953d-adfa64de928f
790	9	mudra	\N	0	\N	-1	731f6403-66f6-46ee-bcdd-e69ed3618535
791	70	abc	en_US	0	\N	-1	731f6403-66f6-46ee-bcdd-e69ed3618535
793	70	ORIGINAL	\N	1	\N	-1	28bebfa8-ac05-442e-aac5-10e1ee16ab40
822	70	ms	en_US	0	\N	-1	8a1952f5-fbf7-4888-9d3c-e15c9e738991
794	70	wordcloud.txt	\N	0	\N	-1	495f0e71-7700-4890-9620-ea230a0af6fa
795	61	/home/dspace/upload/wordcloud.txt	\N	0	\N	-1	495f0e71-7700-4890-9620-ea230a0af6fa
796	32		\N	0	\N	-1	495f0e71-7700-4890-9620-ea230a0af6fa
797	70	LICENSE	\N	1	\N	-1	552b54d4-5c5b-4c2a-be8b-d6f342103e8d
823	21	2018-08-12	\N	0	\N	-1	8a1952f5-fbf7-4888-9d3c-e15c9e738991
798	70	license.txt	\N	0	\N	-1	429a7a03-d91e-486a-ba01-e393fc4a6dde
799	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	429a7a03-d91e-486a-ba01-e393fc4a6dde
800	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-22T07:12:31Z\nNo. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)	en	0	\N	-1	731f6403-66f6-46ee-bcdd-e69ed3618535
801	31	http://10.130.9.111/jspui/handle/123456789/50	\N	0	\N	-1	731f6403-66f6-46ee-bcdd-e69ed3618535
824	9	hello, world	\N	0	\N	-1	836d9050-ffc1-4dbe-a43d-fe7adbbd51fe
805	34	Made available in DSpace on 2018-06-22T07:12:31Z (GMT). No. of bitstreams: 1\nwordcloud.txt: 15592 bytes, checksum: 1511d2d9bd65f776fed2e4a4ae6fcc03 (MD5)\n  Previous issue date: 2018-02-11	en	1	\N	-1	731f6403-66f6-46ee-bcdd-e69ed3618535
802	17	2018-06-22T07:12:31Z	\N	0	\N	-1	731f6403-66f6-46ee-bcdd-e69ed3618535
803	18	2018-06-22T07:12:31Z	\N	0	\N	-1	731f6403-66f6-46ee-bcdd-e69ed3618535
804	21	2018-02-11	\N	0	\N	-1	731f6403-66f6-46ee-bcdd-e69ed3618535
806	9	asxa	\N	0	\N	-1	7e598b76-abda-4c64-852c-f7c048e85857
807	70	asdas	en_US	0	\N	-1	7e598b76-abda-4c64-852c-f7c048e85857
825	70	hello world	en_US	0	\N	-1	836d9050-ffc1-4dbe-a43d-fe7adbbd51fe
809	70	ORIGINAL	\N	1	\N	-1	b9e1bdac-f069-4a5f-bf4e-dcaaa909dee8
810	70	RecommendServlet.java	\N	0	\N	-1	aed10948-cd76-49b8-8e67-ba356412c132
811	61	/home/dspace/upload/RecommendServlet.java	\N	0	\N	-1	aed10948-cd76-49b8-8e67-ba356412c132
812	32		\N	0	\N	-1	aed10948-cd76-49b8-8e67-ba356412c132
813	70	LICENSE	\N	1	\N	-1	271a2f04-3526-4d6f-86e5-5bd3f616576d
814	70	license.txt	\N	0	\N	-1	375184f3-d51d-4536-9f46-833aa8e2ec1e
815	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	375184f3-d51d-4536-9f46-833aa8e2ec1e
816	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-06-25T05:55:55Z\nNo. of bitstreams: 1\nRecommendServlet.java: 3169 bytes, checksum: e5e2fd8de78f14866c5c9bf4db157c99 (MD5)	en	0	\N	-1	7e598b76-abda-4c64-852c-f7c048e85857
817	31	http://10.130.9.111/jspui/handle/123456789/51	\N	0	\N	-1	7e598b76-abda-4c64-852c-f7c048e85857
827	63	now	en_US	0	\N	-1	836d9050-ffc1-4dbe-a43d-fe7adbbd51fe
828	63	then	en_US	1	\N	-1	836d9050-ffc1-4dbe-a43d-fe7adbbd51fe
821	34	Made available in DSpace on 2018-06-25T05:55:56Z (GMT). No. of bitstreams: 1\nRecommendServlet.java: 3169 bytes, checksum: e5e2fd8de78f14866c5c9bf4db157c99 (MD5)\n  Previous issue date: 2017-02-11	en	1	\N	-1	7e598b76-abda-4c64-852c-f7c048e85857
818	17	2018-06-25T05:55:56Z	\N	0	\N	-1	7e598b76-abda-4c64-852c-f7c048e85857
819	18	2018-06-25T05:55:56Z	\N	0	\N	-1	7e598b76-abda-4c64-852c-f7c048e85857
820	21	2017-02-11	\N	0	\N	-1	7e598b76-abda-4c64-852c-f7c048e85857
829	70	ORIGINAL	\N	1	\N	-1	e545724e-fb31-44a6-8266-91cf0dac072f
852	70	license.txt	\N	0	\N	-1	71a60c46-7112-449c-a1f2-3fc619e67787
830	70	quality control.pdf	\N	0	\N	-1	5bf01747-4b30-4677-9ae5-8cf781e37adf
831	61	/home/dspace/upload/quality control.pdf	\N	0	\N	-1	5bf01747-4b30-4677-9ae5-8cf781e37adf
832	32		\N	0	\N	-1	5bf01747-4b30-4677-9ae5-8cf781e37adf
853	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	71a60c46-7112-449c-a1f2-3fc619e67787
854	34	Submitted by Mudra Sahu (mudrasahu1997@gmail.com) on 2018-07-02T09:38:26Z\nNo. of bitstreams: 1\nquality control.pdf: 7242822 bytes, checksum: 021cc825ad6e5b932552e1ae0d7f3fbb (MD5)	en	0	\N	-1	836d9050-ffc1-4dbe-a43d-fe7adbbd51fe
855	31	http://10.130.9.111/jspui/handle/123456789/54	\N	0	\N	-1	836d9050-ffc1-4dbe-a43d-fe7adbbd51fe
851	70	LICENSE	\N	1	\N	-1	d4a63d5c-7c0d-44f2-b105-882cdb6d9c09
859	34	Made available in DSpace on 2018-07-02T09:38:26Z (GMT). No. of bitstreams: 1\nquality control.pdf: 7242822 bytes, checksum: 021cc825ad6e5b932552e1ae0d7f3fbb (MD5)\n  Previous issue date: 2018-06-23	en	1	\N	-1	836d9050-ffc1-4dbe-a43d-fe7adbbd51fe
856	17	2018-07-02T09:38:26Z	\N	0	\N	-1	836d9050-ffc1-4dbe-a43d-fe7adbbd51fe
857	18	2018-07-02T09:38:26Z	\N	0	\N	-1	836d9050-ffc1-4dbe-a43d-fe7adbbd51fe
858	21	2018-06-23	\N	0	\N	-1	836d9050-ffc1-4dbe-a43d-fe7adbbd51fe
\.


--
-- Name: metadatavalue_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.metadatavalue_seq', 859, true);


--
-- Data for Name: most_recent_checksum; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.most_recent_checksum (to_be_processed, expected_checksum, current_checksum, last_process_start_date, last_process_end_date, checksum_algorithm, matched_prev_checksum, result, bitstream_id) FROM stdin;
\.


--
-- Data for Name: mycourse; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.mycourse (course_id, eperson_id, collection_id) FROM stdin;
17	45b7341c-6031-4c5c-8383-7414a82fd8f0	216554d5-e1c6-4975-be5d-16a435fdbdae
18	45b7341c-6031-4c5c-8383-7414a82fd8f0	9f445d1d-8fa5-47d5-8d32-e8b860e61328
22	45b7341c-6031-4c5c-8383-7414a82fd8f0	e1e182b9-a464-49c6-89a9-7453f23404bd
24	36781c80-74f3-427f-8569-d55321306d74	54bab732-de98-4acc-b69f-8738383c06d2
27	36781c80-74f3-427f-8569-d55321306d74	9f445d1d-8fa5-47d5-8d32-e8b860e61328
\.


--
-- Data for Name: mycourses; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.mycourses (id, euuid, cuuid) FROM stdin;
\.


--
-- Data for Name: rating; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.rating (rating_id, eperson_id, item_id, rating_value) FROM stdin;
46	36781c80-74f3-427f-8569-d55321306d74	7e598b76-abda-4c64-852c-f7c048e85857	3
47	36781c80-74f3-427f-8569-d55321306d74	24d6bdce-432d-481f-8417-f1b9fca3c745	4
48	36781c80-74f3-427f-8569-d55321306d74	7e3b76e4-dffe-42b2-9860-ffc46eb37d11	4
49	36781c80-74f3-427f-8569-d55321306d74	f9b95515-f187-44dc-b2f7-62ec48ac88ce	4
50	36781c80-74f3-427f-8569-d55321306d74	530d1403-ff34-485d-8ee4-3f186f019bf7	4
51	36781c80-74f3-427f-8569-d55321306d74	c636ac62-1683-4b64-a42c-c38fc57c0f89	4
52	36781c80-74f3-427f-8569-d55321306d74	fa1c2a6a-f594-4746-934c-f901c60f2d5a	3
53	36781c80-74f3-427f-8569-d55321306d74	731f6403-66f6-46ee-bcdd-e69ed3618535	3
54	\N	7e598b76-abda-4c64-852c-f7c048e85857	3
\.


--
-- Name: rating_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.rating_seq', 54, true);


--
-- Data for Name: registrationdata; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.registrationdata (registrationdata_id, email, token, expires) FROM stdin;
1	hkjh	7122b9138339467b4ddb78bf88eaa2e8	\N
2	mudrasahu11@gmail.com	6f5e86f8594f4ed0790f26864ddfada9	\N
3	mudra.sahu@rediffmail.com	22a84ac88c523820b8681087d4c7b103	\N
4		7153655efe476fbb223fd8bb66c9803d	\N
5	mudrasahu@gmail.com	a87a3b9f51e72bde29f76676430aa600	\N
6	n130888@rguktn.ac.in	e65b75dbab0f0a48e1a7612e16d7b0ab	\N
7	prasadbudithi98@gmail.om	6365703666b302d0bd5bc62c2823b109	\N
8	prasadbudithi98@gmail.com	1a7185726576293bccecd3f27a3048ad	\N
9	mudra.sahu10@gmail.com	6ce6190a2b134a05a928b81eae43a836	\N
10	mudra@localhost	42c20144da3e91e9a3f7ed1822d62803	\N
11	abc@localhost	8e4a4cfa824aeafdffb46501f126ef8a	\N
\.


--
-- Name: registrationdata_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.registrationdata_seq', 11, true);


--
-- Data for Name: requestitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.requestitem (requestitem_id, token, allfiles, request_email, request_name, request_date, accept_request, decision_date, expires, request_message, item_id, bitstream_id) FROM stdin;
\.


--
-- Name: requestitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.requestitem_seq', 1, false);


--
-- Data for Name: resourcepolicy; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.resourcepolicy (policy_id, resource_type_id, resource_id, action_id, start_date, end_date, rpname, rptype, rpdescription, eperson_id, epersongroup_id, dspace_object) FROM stdin;
64	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	29805781-fa7a-438a-a500-7e4be2bf776c
65	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	29805781-fa7a-438a-a500-7e4be2bf776c
3	3	\N	10	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b7b1b7e1-3a94-439e-ade7-f9ef898e272f
4	3	\N	9	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b7b1b7e1-3a94-439e-ade7-f9ef898e272f
5	3	\N	3	\N	\N	\N	\N	\N	\N	77bfc801-e14b-4722-b5f2-23e1bea38444	b7b1b7e1-3a94-439e-ade7-f9ef898e272f
2	3	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b7b1b7e1-3a94-439e-ade7-f9ef898e272f
1	4	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	e41ee777-daa9-4ad9-98a5-13425d1b23ed
66	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	29805781-fa7a-438a-a500-7e4be2bf776c
686	4	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	ddbcf1bb-b3eb-4a76-8936-912786ddbe79
67	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	29805781-fa7a-438a-a500-7e4be2bf776c
7	3	\N	10	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	e1e182b9-a464-49c6-89a9-7453f23404bd
8	3	\N	9	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	e1e182b9-a464-49c6-89a9-7453f23404bd
255	3	\N	10	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	38da3b9e-b576-4d9f-907c-ace9b09861c4
9	3	\N	3	\N	\N	\N	\N	\N	\N	910cd60d-b619-4a3c-a4da-65e3d2486a05	e1e182b9-a464-49c6-89a9-7453f23404bd
6	3	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	e1e182b9-a464-49c6-89a9-7453f23404bd
68	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	29805781-fa7a-438a-a500-7e4be2bf776c
256	3	\N	9	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	38da3b9e-b576-4d9f-907c-ace9b09861c4
1014	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	c60dc41d-0a57-4cb9-8023-26f096e32efb
257	3	\N	3	\N	\N	\N	\N	\N	\N	bb963c9f-808b-482e-85d7-1a719936c404	38da3b9e-b576-4d9f-907c-ace9b09861c4
254	3	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	38da3b9e-b576-4d9f-907c-ace9b09861c4
379	3	\N	10	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	fedb15df-f01e-40c5-816e-30aa1e8c6667
380	3	\N	9	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	fedb15df-f01e-40c5-816e-30aa1e8c6667
1084	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	8a1952f5-fbf7-4888-9d3c-e15c9e738991
381	3	\N	3	\N	\N	\N	\N	\N	\N	1cc4d7b9-08ca-48cf-a63f-bb6e8ab40703	fedb15df-f01e-40c5-816e-30aa1e8c6667
378	3	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	fedb15df-f01e-40c5-816e-30aa1e8c6667
1015	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	c60dc41d-0a57-4cb9-8023-26f096e32efb
1016	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	c60dc41d-0a57-4cb9-8023-26f096e32efb
1017	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	c60dc41d-0a57-4cb9-8023-26f096e32efb
1018	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	c60dc41d-0a57-4cb9-8023-26f096e32efb
1019	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	202b3483-3fec-47ac-a4f3-3274a4049977
1020	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	202b3483-3fec-47ac-a4f3-3274a4049977
20	4	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	ba4336ee-0563-4b0b-84ea-d4d4fc99485e
22	3	\N	10	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	9f445d1d-8fa5-47d5-8d32-e8b860e61328
23	3	\N	9	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	9f445d1d-8fa5-47d5-8d32-e8b860e61328
24	3	\N	3	\N	\N	\N	\N	\N	\N	f42e991a-539b-4958-9b31-943990b49e3c	9f445d1d-8fa5-47d5-8d32-e8b860e61328
21	3	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	9f445d1d-8fa5-47d5-8d32-e8b860e61328
696	4	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	0d605059-7875-4b76-b70e-c49dc73c3dbe
26	3	\N	10	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	216554d5-e1c6-4975-be5d-16a435fdbdae
27	3	\N	9	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	216554d5-e1c6-4975-be5d-16a435fdbdae
28	3	\N	3	\N	\N	\N	\N	\N	\N	56973b4f-8b45-492b-b89c-2fa51b1126d7	216554d5-e1c6-4975-be5d-16a435fdbdae
25	3	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	216554d5-e1c6-4975-be5d-16a435fdbdae
29	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	7d72e5b6-7704-476f-9d38-8d5f261016c7
30	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	7d72e5b6-7704-476f-9d38-8d5f261016c7
31	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	7d72e5b6-7704-476f-9d38-8d5f261016c7
698	3	\N	10	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	54bab732-de98-4acc-b69f-8738383c06d2
32	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	7d72e5b6-7704-476f-9d38-8d5f261016c7
699	3	\N	9	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	54bab732-de98-4acc-b69f-8738383c06d2
33	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	7d72e5b6-7704-476f-9d38-8d5f261016c7
700	3	\N	3	\N	\N	\N	\N	\N	\N	8122dbec-aaa3-45d2-b3f3-d526bdafd332	54bab732-de98-4acc-b69f-8738383c06d2
697	3	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	54bab732-de98-4acc-b69f-8738383c06d2
34	1	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	f4af25dc-153f-4958-a515-1cdf352d30e6
35	1	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	f4af25dc-153f-4958-a515-1cdf352d30e6
36	1	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	f4af25dc-153f-4958-a515-1cdf352d30e6
37	1	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	f4af25dc-153f-4958-a515-1cdf352d30e6
38	1	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	f4af25dc-153f-4958-a515-1cdf352d30e6
533	3	\N	10	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b85a9096-4fb2-4d61-a9ff-de5ddbc122cc
534	3	\N	9	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b85a9096-4fb2-4d61-a9ff-de5ddbc122cc
535	3	\N	3	\N	\N	\N	\N	\N	\N	2bcbb4bb-1b0c-43ae-9ed0-d4027bd1f9ab	b85a9096-4fb2-4d61-a9ff-de5ddbc122cc
532	3	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b85a9096-4fb2-4d61-a9ff-de5ddbc122cc
39	0	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	0b3af3ef-fc2c-4942-96b1-d2254e99201c
40	0	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	0b3af3ef-fc2c-4942-96b1-d2254e99201c
41	0	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	0b3af3ef-fc2c-4942-96b1-d2254e99201c
42	0	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	0b3af3ef-fc2c-4942-96b1-d2254e99201c
43	0	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	0b3af3ef-fc2c-4942-96b1-d2254e99201c
44	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	2c8bc593-9707-4c60-a079-792175fad7c2
45	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	2c8bc593-9707-4c60-a079-792175fad7c2
46	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	2c8bc593-9707-4c60-a079-792175fad7c2
47	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	2c8bc593-9707-4c60-a079-792175fad7c2
48	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	2c8bc593-9707-4c60-a079-792175fad7c2
49	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	e555b73c-4e0c-453a-bc10-e1509fa18348
50	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	e555b73c-4e0c-453a-bc10-e1509fa18348
51	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	e555b73c-4e0c-453a-bc10-e1509fa18348
52	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	e555b73c-4e0c-453a-bc10-e1509fa18348
53	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	e555b73c-4e0c-453a-bc10-e1509fa18348
54	1	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	495be94e-1eef-4a2e-9ed6-05efa3f2667a
55	1	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	495be94e-1eef-4a2e-9ed6-05efa3f2667a
56	1	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	495be94e-1eef-4a2e-9ed6-05efa3f2667a
57	1	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	495be94e-1eef-4a2e-9ed6-05efa3f2667a
58	1	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	495be94e-1eef-4a2e-9ed6-05efa3f2667a
59	0	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	b3ac2a4b-5443-4f61-be3b-a4f5760d7710
60	0	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	b3ac2a4b-5443-4f61-be3b-a4f5760d7710
61	0	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	b3ac2a4b-5443-4f61-be3b-a4f5760d7710
62	0	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	b3ac2a4b-5443-4f61-be3b-a4f5760d7710
63	0	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	b3ac2a4b-5443-4f61-be3b-a4f5760d7710
1021	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	202b3483-3fec-47ac-a4f3-3274a4049977
1085	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	8a1952f5-fbf7-4888-9d3c-e15c9e738991
159	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	fb4a1d76-ee3c-41c5-a90f-04a4cbf6ef2d
219	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	a54bbc7b-59eb-4a38-849a-e43ef1b8304a
160	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	a1fce771-5353-4398-924c-045ed36e55c4
1022	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	202b3483-3fec-47ac-a4f3-3274a4049977
161	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	0c9082e8-8c4b-4ce0-bc2d-e739c9e814fa
220	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	65bad344-2707-457e-b1ba-bee570972b87
1086	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	8a1952f5-fbf7-4888-9d3c-e15c9e738991
162	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	4ae07e0e-4ddd-4d82-aab7-72ab37f67174
96	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	0b6a3f7f-6ad7-4dbe-b300-1bb8ee8ee2a2
1087	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	8a1952f5-fbf7-4888-9d3c-e15c9e738991
163	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	9da1785d-55d1-4e50-9df7-737c1c584855
98	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	81a5ac06-022e-4b3e-a464-217ab669c7f3
221	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	ba7ce28a-f9aa-4ea8-99f1-75accb03e87c
99	4	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	12a6f2d6-4eae-47c9-8bf4-54cf02c01335
1023	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	202b3483-3fec-47ac-a4f3-3274a4049977
222	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	8cc9da0c-2cee-418c-8cd2-d4065adbdbf7
101	3	\N	10	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	f7019f5a-44ba-4a31-a105-b20cc4c20ae1
102	3	\N	9	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	f7019f5a-44ba-4a31-a105-b20cc4c20ae1
223	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b44dbb4d-a1cc-4a6b-98d5-fa739a1e083c
103	3	\N	3	\N	\N	\N	\N	\N	\N	d09cba3a-461b-4c6b-9c82-8b23ca6ac64e	f7019f5a-44ba-4a31-a105-b20cc4c20ae1
100	3	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	f7019f5a-44ba-4a31-a105-b20cc4c20ae1
343	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	c39ad818-307a-4c7a-9672-4e8e85c0d624
1088	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	36781c80-74f3-427f-8569-d55321306d74	\N	8a1952f5-fbf7-4888-9d3c-e15c9e738991
344	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	a23a2a91-cd8d-4f0b-867d-c73e55c0598c
345	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	8c99d017-1503-4dfd-8066-0f5dc8ace132
346	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	f99b4579-1283-4026-8ff8-6f78dc0d2805
283	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	45d8b4dc-5da5-46af-a643-3143b6af9f13
284	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	1f036576-773c-4d03-9127-b4bba2eca4d5
347	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	d4c1d98f-325c-45fa-b57b-16fcac56d5a5
285	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	15d4b547-ef7e-46ac-bee2-0977938520d4
286	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	8570e079-3966-4d74-af6d-1cd038b7dad9
287	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	f1ca61cf-b4fb-4d99-9b01-c6154bd04085
467	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	89010e0b-74f4-43f9-be0d-f6b83045feb7
527	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	c636ac62-1683-4b64-a42c-c38fc57c0f89
468	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	7439b012-2aac-42f1-b73d-d249a9d64e40
469	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	2522b4b7-99b8-48fb-9206-d658e4672baa
528	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	815fed71-ea32-4bf7-8b87-137ce9894d24
470	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	96ff33e7-2956-48ea-af67-2f5366ae3191
471	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	6daaa47a-986c-42f5-ae59-b49fd3ca5c19
529	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	7c48b00e-ddab-4a40-af07-8e9fc6a651d9
530	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	ff92dae9-5899-4088-8459-af661f0dd874
407	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	53894fe9-2e5a-4cc0-a1a6-0fda50fcae49
373	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	3da62806-eab4-4e50-85f7-c27836c44a3b
408	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	762771f7-2ebd-466f-9760-39375d35f186
313	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	a8be8fdd-3a54-4e70-aa5c-56e24e9e403b
374	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	f1a0e28e-b69d-419e-9649-43ca88e6bafa
314	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	97af0899-be0a-427a-9c11-6a02776d0830
315	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b5677909-694d-4b69-bdaa-66f81f894c1b
375	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	ceedb68a-7731-43e3-96d0-ebed5acb3241
316	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	66e6f832-c292-402a-ad47-ee06ff5c9f87
409	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	f4c6f687-6237-4363-8242-9d64a1c519ef
317	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	5e355026-895b-4bdc-8fed-14d4779fc8aa
376	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	cdc0ef88-260d-461a-9c2e-494e93909912
410	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	7ea26c6a-9885-47f0-9995-38f0aed9cd91
377	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	ae3cb1cb-0353-47a8-800c-0d9eb3347f42
189	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	a8b94f7f-986d-479b-80a4-a7b528984380
411	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	4c513e51-f52d-4655-acef-a93cec34fedb
190	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	f49fd40d-fcf2-4815-9f24-083b794b4bd5
191	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	64fee389-1491-49e9-870c-88e74ef32a14
129	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	3ba398cb-0399-41b2-98b7-2ed4220e4fa8
130	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	2ea7c2a4-41d5-4115-9afa-ce1a849cc6e5
192	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	97b30dc1-de2c-4da2-a4c7-954ceb243951
131	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	13f9a2f9-b4e5-4366-bad1-83b82634d5a5
132	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	0fd12cd1-fb9f-4355-bf1d-9f95d42ecef5
193	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	bade7c98-10b6-4843-b443-44b6ed5acb04
133	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b80d21bb-4aae-4ee3-824a-3f95395252d7
249	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	2499711d-8cf0-476d-9534-fe00f0475658
250	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	a93055cd-3253-4f73-bc2a-5b9b944afbe7
251	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	ca06fc2d-47e4-40c1-9909-6e527521c4ba
252	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	454bff8d-6deb-48ba-97f1-70c8a160b5c6
253	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	dbb996cf-0122-4e78-bf03-6f8c2322638c
531	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	08d106a8-1ffc-42e2-9345-cdbbf5e25640
591	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	0a4bcc97-9ec2-4dae-b11c-2d868623cb49
651	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	aebacdd7-f06c-45a0-9854-9e12f2103902
592	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	9d4327b4-82d3-41c6-b291-43a7e13133f3
593	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	fb4f2a26-b5b1-4757-8e79-b786f0e8a46b
652	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	bf1beb12-c719-4a7e-997e-dc13d5534198
437	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	75e52dde-8992-4237-9b42-7004977bd3d7
594	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	7dd0e346-25c3-461f-b02e-2b3f853abe00
438	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	87f81a7c-1224-4b6e-8017-8cae299f6988
439	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	864216a8-2cc4-4796-bd22-b14eb1b71e85
595	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	827bffbd-a853-4955-a0ef-f285241bedfc
440	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	07c4f7ff-069a-4fde-8620-aa70b4156f54
653	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	62864ee6-212d-4336-aa23-10b53876c33f
441	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	bce59918-0051-4f67-af90-a9c05e36efd8
654	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	7ef63ce2-b0cc-47c2-97c7-74c9cf2c927f
655	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	481daa37-0f1d-4fba-ba2a-091e703471d0
786	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	f9b95515-f187-44dc-b2f7-62ec48ac88ce
850	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	15fb5a68-0e00-485f-96e8-c10a3dab8007
787	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b59b4e13-6b97-4759-9d11-d6f4f0044cce
910	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	a7396fa7-6c95-4712-a053-22f60d852f70
788	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	06c28b52-5b08-4aac-b946-7db8e024b91a
851	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	f4de32b9-043d-4b0f-b400-86fa3df1fb01
561	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	ea6298eb-c495-43f0-9b47-81ee583acee5
789	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b961e9d0-2b79-4802-843e-05b3b929c1a3
562	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	32fdc0cb-eb32-405e-bb25-3b6fbdd584e1
974	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	2a6e3d3e-7b0d-443d-a8c2-740d456de4f0
563	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b0fd981f-85b2-46f0-a1a6-8670732577d9
790	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	58311eb7-934a-4410-bae3-b8371355d96b
564	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	d50a4391-97bd-443b-8a35-b8f3558509ae
726	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	8c6e25d5-1d1f-47fb-9888-894e04e4592c
565	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	c9fb30a3-6e29-48f4-836e-8241805c086d
852	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	60b58afa-a7ce-4ca2-91ad-607fbc0264c0
727	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	ebe553b5-6c77-4f47-b14f-c55fcfbb243f
911	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	48616940-8e7c-44d1-9ca7-1fb58dc561d0
728	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b8362c84-61d5-4c54-9b93-6903dc7af6c3
853	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	d2896b5f-1280-4fcd-8a57-3709f3ddb817
729	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	8aede5fb-4458-414d-ac6b-fe62210c70f8
730	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b71d3b0c-7bbd-4413-bea7-7d9cd8aaf50a
497	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	fa1c2a6a-f594-4746-934c-f901c60f2d5a
854	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	6234b407-7244-4b13-b9d8-9652ce66a0ca
498	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	c0079563-57d3-4efc-a576-e6ea19f5a8d7
912	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	bf8d7f49-ab53-4056-bcde-3fa29c87b9a4
499	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b60be1f9-c245-49d4-8fbb-aa98ef07c01e
975	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	482e7f8c-7687-46c3-826d-fd1939ea3bbc
500	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	dcaae3de-8a3c-4f5f-adad-32b869c47f74
913	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	f91fbf0e-92c9-4ceb-b35c-748bfd9e277f
501	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	993c2eda-5a7e-4c77-b845-a8fbc12b782a
914	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	bc67c574-d6d7-42f3-be29-a557a17bac5b
976	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	aef9672a-a17e-4448-8163-46185e0daa6b
977	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	97622e69-6bb7-4f81-bc71-5de1ab7aa10e
978	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	02e23fc3-0aad-4f54-a65c-b19cc9bf2ecb
979	4	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	91ce1543-4a74-4c94-88dd-07986a7a676b
981	3	\N	10	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	8c7e552a-5797-4dd1-a35b-85a265feeb3f
982	3	\N	9	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	8c7e552a-5797-4dd1-a35b-85a265feeb3f
983	3	\N	3	\N	\N	\N	\N	\N	\N	0f0ad925-a61d-41a8-accc-4579e9666128	8c7e552a-5797-4dd1-a35b-85a265feeb3f
980	3	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	8c7e552a-5797-4dd1-a35b-85a265feeb3f
621	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	2badb32c-192a-457f-8eee-9aa548441cf4
681	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	24d6bdce-432d-481f-8417-f1b9fca3c745
622	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	a1f8f03a-1fae-43c9-b85d-5edd6742876d
623	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	5a4943d5-155f-4ba9-ac21-a1c42db7624b
682	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	8331723c-d2b7-4274-a3f0-ab6c8c782fcb
624	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b2b82808-7008-4b71-b3f0-c2def986c957
625	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	cf56643a-2485-499f-96e4-08970d0b625f
683	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	27faba85-6cd4-4258-afd0-0ad4e8c60ee3
684	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	6f4f1048-3377-42ca-bce0-70923275a958
685	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	288c7b7f-5138-40cf-8922-3fcc9521b868
756	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	7e3b76e4-dffe-42b2-9860-ffc46eb37d11
757	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	19727d4e-ea29-4695-ba0f-ef42a24e7d2b
758	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	f73aec6a-8837-4fbd-bdc7-a5cac842a210
759	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	076a0596-b1d7-4db4-a5f0-b8cf8ff524df
760	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	1c315c05-38b9-4642-be4b-e2d231bb1169
816	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	530d1403-ff34-485d-8ee4-3f186f019bf7
817	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	1ec8dff4-d4ff-42c3-a9e6-54744d5bc6f8
916	3	\N	10	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	ab76a5ce-1b6e-429a-87d5-404757fa848c
818	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	7109a357-c47f-4b04-a2a7-fee0c0b92f6d
917	3	\N	9	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	ab76a5ce-1b6e-429a-87d5-404757fa848c
819	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	36d8c81e-90c2-43cc-b881-78122115f2e1
820	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	2634c301-12e5-418e-9fbb-ab0b9561aafc
918	3	\N	3	\N	\N	\N	\N	\N	\N	9827a165-99c8-4b82-ac73-53f919703a4c	ab76a5ce-1b6e-429a-87d5-404757fa848c
915	3	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	ab76a5ce-1b6e-429a-87d5-404757fa848c
822	3	\N	10	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	9ecd6365-9d96-49bb-a656-c2ccab8653e2
823	3	\N	9	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	9ecd6365-9d96-49bb-a656-c2ccab8653e2
824	3	\N	3	\N	\N	\N	\N	\N	\N	f4e3955f-89f4-4169-8f63-ba561e510f51	9ecd6365-9d96-49bb-a656-c2ccab8653e2
821	3	\N	0	\N	\N	\N	\N	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	9ecd6365-9d96-49bb-a656-c2ccab8653e2
1049	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	731f6403-66f6-46ee-bcdd-e69ed3618535
1050	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	28bebfa8-ac05-442e-aac5-10e1ee16ab40
1051	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	495f0e71-7700-4890-9620-ea230a0af6fa
1052	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	552b54d4-5c5b-4c2a-be8b-d6f342103e8d
1053	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	429a7a03-d91e-486a-ba01-e393fc4a6dde
880	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	c8ac9256-7951-49b1-ae86-a41be7894406
881	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	da8c4a2a-1001-45f6-a3ea-33abedf18e74
882	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	c7d9baf3-edb7-42d9-b3cd-d32eba23954c
883	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	fd787dfc-ee8f-4463-a69d-fad1db917bdd
884	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	617a3a58-26b1-4992-bb50-0a484bfedadf
1009	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	320ddf01-74b8-435e-953d-adfa64de928f
1010	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	670e9a5a-7cb8-40f1-a42e-71207489aa2b
1011	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	050db052-de7e-48b1-90c7-3498e746d313
1012	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	7ab42eaa-6ee8-4ffb-bc49-b48e71f893ea
1013	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	453c6c0c-2699-4fec-b0f9-5a2752bd330d
944	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	1965ac82-4792-45e1-961a-1de7b843fc2f
945	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	3d5c95b0-1727-45a0-b0c5-a3835e80ef6c
946	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	51dd5697-85ee-43f1-bcf3-ccbe02cf84e1
947	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	87b2bbe8-4dc4-4f1f-9abb-c04562fb4feb
948	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	d73be20c-529c-4c77-9b21-365090f576c2
1079	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	7e598b76-abda-4c64-852c-f7c048e85857
1080	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	b9e1bdac-f069-4a5f-bf4e-dcaaa909dee8
1081	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	aed10948-cd76-49b8-8e67-ba356412c132
1082	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	271a2f04-3526-4d6f-86e5-5bd3f616576d
1083	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	375184f3-d51d-4536-9f46-833aa8e2ec1e
1134	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	836d9050-ffc1-4dbe-a43d-fe7adbbd51fe
1135	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	e545724e-fb31-44a6-8266-91cf0dac072f
1136	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	5bf01747-4b30-4677-9ae5-8cf781e37adf
1137	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	d4a63d5c-7c0d-44f2-b105-882cdb6d9c09
1138	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	bf48e1de-50a2-4ae9-b1e5-456b09575be9	71a60c46-7112-449c-a1f2-3fc619e67787
\.


--
-- Name: resourcepolicy_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.resourcepolicy_seq', 1138, true);


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.schema_version (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	<< Flyway Baseline >>	BASELINE	<< Flyway Baseline >>	\N	dspace	2018-05-24 15:17:51.843473	0	t
2	1.1	Initial DSpace 1.1 database schema	SQL	V1.1__Initial_DSpace_1.1_database_schema.sql	1147897299	dspace	2018-05-24 15:17:52.979059	2993	t
3	1.2	Upgrade to DSpace 1.2 schema	SQL	V1.2__Upgrade_to_DSpace_1.2_schema.sql	903973515	dspace	2018-05-24 15:17:55.989721	164	t
4	1.3	Upgrade to DSpace 1.3 schema	SQL	V1.3__Upgrade_to_DSpace_1.3_schema.sql	-783235991	dspace	2018-05-24 15:17:56.179509	579	t
5	1.3.9	Drop constraint for DSpace 1 4 schema	JDBC	org.dspace.storage.rdbms.migration.V1_3_9__Drop_constraint_for_DSpace_1_4_schema	-1	dspace	2018-05-24 15:17:56.780001	15	t
6	1.4	Upgrade to DSpace 1.4 schema	SQL	V1.4__Upgrade_to_DSpace_1.4_schema.sql	-831219528	dspace	2018-05-24 15:17:56.813788	957	t
7	1.5	Upgrade to DSpace 1.5 schema	SQL	V1.5__Upgrade_to_DSpace_1.5_schema.sql	-1234304544	dspace	2018-05-24 15:17:57.793701	1885	t
8	1.5.9	Drop constraint for DSpace 1 6 schema	JDBC	org.dspace.storage.rdbms.migration.V1_5_9__Drop_constraint_for_DSpace_1_6_schema	-1	dspace	2018-05-24 15:17:59.694421	12	t
9	1.6	Upgrade to DSpace 1.6 schema	SQL	V1.6__Upgrade_to_DSpace_1.6_schema.sql	-495469766	dspace	2018-05-24 15:17:59.727781	492	t
10	1.7	Upgrade to DSpace 1.7 schema	SQL	V1.7__Upgrade_to_DSpace_1.7_schema.sql	-589640641	dspace	2018-05-24 15:18:00.239611	12	t
11	1.8	Upgrade to DSpace 1.8 schema	SQL	V1.8__Upgrade_to_DSpace_1.8_schema.sql	-171791117	dspace	2018-05-24 15:18:00.273625	14	t
12	3.0	Upgrade to DSpace 3.x schema	SQL	V3.0__Upgrade_to_DSpace_3.x_schema.sql	-1098885663	dspace	2018-05-24 15:18:00.306305	159	t
13	4.0	Upgrade to DSpace 4.x schema	SQL	V4.0__Upgrade_to_DSpace_4.x_schema.sql	1191833374	dspace	2018-05-24 15:18:00.484466	424	t
14	4.9.2015.10.26	DS-2818 registry update	SQL	V4.9_2015.10.26__DS-2818_registry_update.sql	1675451156	dspace	2018-05-24 15:18:00.929598	21	t
15	5.0.2014.08.08	DS-1945 Helpdesk Request a Copy	SQL	V5.0_2014.08.08__DS-1945_Helpdesk_Request_a_Copy.sql	-1208221648	dspace	2018-05-24 15:18:00.974073	49	t
16	5.0.2014.09.25	DS 1582 Metadata For All Objects drop constraint	JDBC	org.dspace.storage.rdbms.migration.V5_0_2014_09_25__DS_1582_Metadata_For_All_Objects_drop_constraint	-1	dspace	2018-05-24 15:18:01.041097	9	t
17	5.0.2014.09.26	DS-1582 Metadata For All Objects	SQL	V5.0_2014.09.26__DS-1582_Metadata_For_All_Objects.sql	1509433410	dspace	2018-05-24 15:18:01.074441	42	t
18	5.6.2016.08.23	DS-3097	SQL	V5.6_2016.08.23__DS-3097.sql	410632858	dspace	2018-05-24 15:18:01.141149	5	t
19	5.7.2017.04.11	DS-3563 Index metadatavalue resource type id column	SQL	V5.7_2017.04.11__DS-3563_Index_metadatavalue_resource_type_id_column.sql	912059617	dspace	2018-05-24 15:18:01.163323	68	t
20	5.7.2017.05.05	DS 3431 Add Policies for BasicWorkflow	JDBC	org.dspace.storage.rdbms.migration.V5_7_2017_05_05__DS_3431_Add_Policies_for_BasicWorkflow	-1	dspace	2018-05-24 15:18:01.252345	43	t
21	6.0.2015.03.06	DS 2701 Dso Uuid Migration	JDBC	org.dspace.storage.rdbms.migration.V6_0_2015_03_06__DS_2701_Dso_Uuid_Migration	-1	dspace	2018-05-24 15:18:01.307741	28	t
22	6.0.2015.03.07	DS-2701 Hibernate migration	SQL	V6.0_2015.03.07__DS-2701_Hibernate_migration.sql	-542830952	dspace	2018-05-24 15:18:01.35245	4594	t
23	6.0.2015.08.31	DS 2701 Hibernate Workflow Migration	JDBC	org.dspace.storage.rdbms.migration.V6_0_2015_08_31__DS_2701_Hibernate_Workflow_Migration	-1	dspace	2018-05-24 15:18:05.970887	33	t
24	6.0.2016.01.03	DS-3024	SQL	V6.0_2016.01.03__DS-3024.sql	95468273	dspace	2018-05-24 15:18:06.026851	222	t
25	6.0.2016.01.26	DS 2188 Remove DBMS Browse Tables	JDBC	org.dspace.storage.rdbms.migration.V6_0_2016_01_26__DS_2188_Remove_DBMS_Browse_Tables	-1	dspace	2018-05-24 15:18:06.271313	32	t
26	6.0.2016.02.25	DS-3004-slow-searching-as-admin	SQL	V6.0_2016.02.25__DS-3004-slow-searching-as-admin.sql	-1623115511	dspace	2018-05-24 15:18:06.326966	54	t
27	6.0.2016.04.01	DS-1955 Increase embargo reason	SQL	V6.0_2016.04.01__DS-1955_Increase_embargo_reason.sql	283892016	dspace	2018-05-24 15:18:06.404722	64	t
28	6.0.2016.04.04	DS-3086-OAI-Performance-fix	SQL	V6.0_2016.04.04__DS-3086-OAI-Performance-fix.sql	445863295	dspace	2018-05-24 15:18:06.493357	162	t
29	6.0.2016.04.14	DS-3125-fix-bundle-bitstream-delete-rights	SQL	V6.0_2016.04.14__DS-3125-fix-bundle-bitstream-delete-rights.sql	-699277527	dspace	2018-05-24 15:18:06.67169	6	t
30	6.0.2016.05.10	DS-3168-fix-requestitem item id column	SQL	V6.0_2016.05.10__DS-3168-fix-requestitem_item_id_column.sql	-1122969100	dspace	2018-05-24 15:18:06.693681	99	t
31	6.0.2016.07.21	DS-2775	SQL	V6.0_2016.07.21__DS-2775.sql	-126635374	dspace	2018-05-24 15:18:06.815997	14	t
32	6.0.2016.07.26	DS-3277 fix handle assignment	SQL	V6.0_2016.07.26__DS-3277_fix_handle_assignment.sql	-284088754	dspace	2018-05-24 15:18:06.849559	49	t
33	6.0.2016.08.23	DS-3097	SQL	V6.0_2016.08.23__DS-3097.sql	-1986377895	dspace	2018-05-24 15:18:06.916215	5	t
34	6.1.2017.01.03	DS 3431 Add Policies for BasicWorkflow	JDBC	org.dspace.storage.rdbms.migration.V6_1_2017_01_03__DS_3431_Add_Policies_for_BasicWorkflow	-1	dspace	2018-05-24 15:18:06.938602	45	t
35	6.2.2016.06.04	DS-1234	SQL	V6.2_2016.06.04__DS-1234.sql	0	dspace	2018-06-05 12:30:19.355031	456	t
36	6.2.2018.06.07	DS-1237	SQL	V6.2_2018.06.07__DS-1237.sql	-825328542	dspace	2018-06-07 16:14:39.690518	1094	t
37	6.2.2018.06.08	DS-1238	SQL	V6.2_2018.06.08__DS-1238.sql	-547683018	dspace	2018-06-08 19:23:01.060016	1239	t
38	6.2.2018.06.09	DS-1239	SQL	V6.2_2018.06.09__DS-1239.sql	1877366032	dspace	2018-06-08 22:10:25.568182	548	t
39	6.2.2018.06.11	DS-1235	SQL	V6.2_2018.06.11__DS-1235.sql	392009988	dspace	2018-06-11 12:04:10.649587	625	t
40	6.2.2018.06.21	DS-1236	SQL	V6.2_2018.06.21__DS-1236.sql	648817066	dspace	2018-06-21 11:29:02.903545	989	t
\.


--
-- Data for Name: site; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.site (uuid) FROM stdin;
abc8a8a2-3228-4384-bb0e-7a7ffa931bd7
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.subscription (subscription_id, eperson_id, collection_id) FROM stdin;
1	36781c80-74f3-427f-8569-d55321306d74	b7b1b7e1-3a94-439e-ade7-f9ef898e272f
2	45b7341c-6031-4c5c-8383-7414a82fd8f0	9f445d1d-8fa5-47d5-8d32-e8b860e61328
3	45b7341c-6031-4c5c-8383-7414a82fd8f0	b7b1b7e1-3a94-439e-ade7-f9ef898e272f
4	45b7341c-6031-4c5c-8383-7414a82fd8f0	e1e182b9-a464-49c6-89a9-7453f23404bd
5	45b7341c-6031-4c5c-8383-7414a82fd8f0	216554d5-e1c6-4975-be5d-16a435fdbdae
\.


--
-- Name: subscription_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.subscription_seq', 31, true);


--
-- Data for Name: tasklistitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.tasklistitem (tasklist_id, workflow_id, eperson_id) FROM stdin;
\.


--
-- Name: tasklistitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.tasklistitem_seq', 1, false);


--
-- Data for Name: versionhistory; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.versionhistory (versionhistory_id) FROM stdin;
\.


--
-- Name: versionhistory_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.versionhistory_seq', 1, false);


--
-- Data for Name: versionitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.versionitem (versionitem_id, version_number, version_date, version_summary, versionhistory_id, eperson_id, item_id) FROM stdin;
\.


--
-- Name: versionitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.versionitem_seq', 1, false);


--
-- Data for Name: webapp; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.webapp (webapp_id, appname, url, started, isui) FROM stdin;
1	OAI	http://10.130.9.111/xmlui	2018-05-24 15:20:22.377	0
2	REST	http://10.130.9.111/xmlui	2018-05-24 15:20:41.84	0
3	OAI	http://10.130.9.111/xmlui	2018-05-24 15:21:41.067	0
52	OAI	http://10.11.131.93/xmlui	2018-05-26 20:08:52.344	0
5	REST	http://10.130.9.111/xmlui	2018-05-24 15:22:36.784	0
6	OAI	http://10.130.9.111/xmlui	2018-05-24 15:24:49.786	0
7	JSPUI	http://10.130.9.111/xmlui	2018-05-24 15:25:31.258	1
8	REST	http://10.130.9.111/xmlui	2018-05-24 15:25:53.384	0
9	OAI	http://10.130.9.111/xmlui	2018-05-24 18:23:36.085	0
79	REST	http://10.130.9.111/jspui	2018-05-28 13:56:22.826	0
11	REST	http://10.130.9.111/xmlui	2018-05-24 18:24:33.746	0
12	OAI	http://10.130.9.111/xmlui	2018-05-24 18:58:58.569	0
13	JSPUI	http://10.130.9.111/xmlui	2018-05-24 18:59:34.461	1
14	REST	http://10.130.9.111/xmlui	2018-05-24 18:59:57.724	0
15	OAI	http://10.130.9.111/xmlui	2018-05-24 19:40:26.964	0
16	JSPUI	http://10.130.9.111/xmlui	2018-05-24 19:40:57.505	1
17	REST	http://10.130.9.111/xmlui	2018-05-24 19:41:18.031	0
18	OAI	http://10.130.9.111/xmlui	2018-05-24 20:42:02.183	0
19	JSPUI	http://10.130.9.111/xmlui	2018-05-24 20:42:40.73	1
20	REST	http://10.130.9.111/xmlui	2018-05-24 20:43:06.252	0
21	OAI	http://10.130.9.111/xmlui	2018-05-25 09:47:25.432	0
22	JSPUI	http://10.130.9.111/xmlui	2018-05-25 09:48:05.909	1
23	REST	http://10.130.9.111/xmlui	2018-05-25 09:48:35.98	0
24	OAI	http://10.130.9.111/xmlui	2018-05-25 09:57:14.142	0
25	JSPUI	http://10.130.9.111/xmlui	2018-05-25 09:57:48.122	1
26	REST	http://10.130.9.111/xmlui	2018-05-25 09:58:09.77	0
27	OAI	http://10.130.9.111/xmlui	2018-05-25 12:09:44.064	0
28	JSPUI	http://10.130.9.111/xmlui	2018-05-25 12:10:16.002	1
29	REST	http://10.130.9.111/xmlui	2018-05-25 12:10:39.255	0
30	OAI	http://10.130.9.111/xmlui	2018-05-25 12:26:56.08	0
31	JSPUI	http://10.130.9.111/xmlui	2018-05-25 12:27:35.031	1
32	REST	http://10.130.9.111/xmlui	2018-05-25 12:27:57.876	0
33	OAI	http://10.130.9.111/xmlui	2018-05-25 14:18:35.657	0
34	JSPUI	http://10.130.9.111/xmlui	2018-05-25 14:19:20.669	1
35	REST	http://10.130.9.111/xmlui	2018-05-25 14:20:06.016	0
36	OAI	http://10.130.9.111/xmlui	2018-05-26 14:02:05.892	0
54	REST	http://10.11.131.93/xmlui	2018-05-26 20:09:51.184	0
38	REST	http://10.130.9.111/xmlui	2018-05-26 14:03:06.233	0
39	OAI	http://10.130.9.111/xmlui	2018-05-26 18:55:59.58	0
40	OAI	http://10.130.9.111/xmlui	2018-05-26 19:02:35.168	0
41	JSPUI	http://10.130.9.111/xmlui	2018-05-26 19:03:05.526	1
42	REST	http://10.130.9.111/xmlui	2018-05-26 19:03:30.413	0
43	OAI	http://10.130.9.111/xmlui	2018-05-26 19:15:52.373	0
44	JSPUI	http://10.130.9.111/xmlui	2018-05-26 19:16:30.974	1
45	REST	http://10.130.9.111/xmlui	2018-05-26 19:16:57.687	0
46	OAI	http://10.130.9.111/xmlui	2018-05-26 19:46:04.683	0
55	OAI	http://10.11.131.93/xmlui	2018-05-26 22:02:44.547	0
48	REST	http://10.130.9.111/xmlui	2018-05-26 19:47:02.786	0
49	OAI	http://10.130.9.111/xmlui	2018-05-26 19:58:35.951	0
50	JSPUI	http://10.130.9.111/xmlui	2018-05-26 19:59:16.891	1
51	REST	http://10.130.9.111/xmlui	2018-05-26 19:59:42.137	0
57	REST	http://10.11.131.93/xmlui	2018-05-26 22:04:33.643	0
58	OAI	http://10.11.131.93/xmlui	2018-05-27 13:27:22.103	0
59	JSPUI	http://10.11.131.93/xmlui	2018-05-27 13:28:41.162	1
60	REST	http://10.11.131.93/xmlui	2018-05-27 13:29:22.542	0
61	OAI	http://10.11.131.93/xmlui	2018-05-27 16:17:36.769	0
62	JSPUI	http://10.11.131.93/xmlui	2018-05-27 16:18:51.379	1
63	REST	http://10.11.131.93/xmlui	2018-05-27 16:19:22.196	0
64	OAI	http://10.11.131.93/xmlui	2018-05-27 21:13:33.506	0
65	OAI	http://10.11.131.93/xmlui	2018-05-27 21:45:51.755	0
80	OAI	http://10.130.9.111/jspui	2018-05-28 15:07:15.067	0
67	REST	http://10.11.131.93/xmlui	2018-05-27 21:47:31.634	0
68	OAI	http://10.11.131.93/xmlui	2018-05-28 10:00:10.125	0
69	JSPUI	http://10.11.131.93/xmlui	2018-05-28 10:01:02.85	1
70	REST	http://10.11.131.93/xmlui	2018-05-28 10:01:28.302	0
71	OAI	http://10.130.9.111/jspui	2018-05-28 10:51:44.633	0
72	JSPUI	http://10.130.9.111/jspui	2018-05-28 10:52:29.291	1
73	REST	http://10.130.9.111/jspui	2018-05-28 10:52:53.733	0
74	OAI	http://10.130.9.111/jspui	2018-05-28 11:49:43.939	0
76	REST	http://10.130.9.111/jspui	2018-05-28 11:50:54.498	0
77	OAI	http://10.130.9.111/jspui	2018-05-28 13:55:19.103	0
78	JSPUI	http://10.130.9.111/jspui	2018-05-28 13:55:54.596	1
81	JSPUI	http://10.130.9.111/jspui	2018-05-28 15:08:22.112	1
82	REST	http://10.130.9.111/jspui	2018-05-28 15:08:51.714	0
113	OAI	http://10.130.9.111/jspui	2018-05-28 15:11:32.254	0
114	JSPUI	http://10.130.9.111/jspui	2018-05-28 15:12:51.604	1
115	REST	http://10.130.9.111/jspui	2018-05-28 15:13:29.332	0
116	OAI	http://10.130.9.111/jspui	2018-05-28 20:20:40.558	0
117	JSPUI	http://10.130.9.111/jspui	2018-05-28 20:21:15.57	1
118	REST	http://10.130.9.111/jspui	2018-05-28 20:21:38.634	0
119	OAI	http://10.130.9.111/jspui	2018-05-28 20:28:54.032	0
120	JSPUI	http://10.130.9.111/jspui	2018-05-28 20:30:12.041	1
121	REST	http://10.130.9.111/jspui	2018-05-28 20:30:48.852	0
122	OAI	http://10.130.9.111/jspui	2018-05-28 20:35:26.33	0
123	JSPUI	http://10.130.9.111/jspui	2018-05-28 20:36:07.916	1
124	REST	http://10.130.9.111/jspui	2018-05-28 20:36:30.336	0
125	OAI	http://10.130.9.111/jspui	2018-05-29 10:40:33.522	0
126	JSPUI	http://10.130.9.111/jspui	2018-05-29 10:41:29.335	1
127	REST	http://10.130.9.111/jspui	2018-05-29 10:41:51.332	0
128	OAI	http://10.130.9.111/jspui	2018-05-29 12:35:16.672	0
129	JSPUI	http://10.130.9.111/jspui	2018-05-29 12:35:55.61	1
130	REST	http://10.130.9.111/jspui	2018-05-29 12:36:18.114	0
131	OAI	http://10.130.9.111/jspui	2018-05-29 13:53:30.732	0
132	JSPUI	http://10.130.9.111/jspui	2018-05-29 13:54:17.162	1
133	REST	http://10.130.9.111/jspui	2018-05-29 13:54:40.122	0
134	OAI	http://10.130.9.111/jspui	2018-05-29 14:44:53.289	0
135	JSPUI	http://10.130.9.111/jspui	2018-05-29 14:45:43.494	1
136	REST	http://10.130.9.111/jspui	2018-05-29 14:46:06.245	0
137	OAI	http://10.130.9.111/jspui	2018-05-29 14:58:56.158	0
138	JSPUI	http://10.130.9.111/jspui	2018-05-29 14:59:29.407	1
139	REST	http://10.130.9.111/jspui	2018-05-29 14:59:51.065	0
140	OAI	http://10.130.9.111/jspui	2018-05-29 15:17:08.035	0
141	JSPUI	http://10.130.9.111/jspui	2018-05-29 15:17:39.063	1
142	REST	http://10.130.9.111/jspui	2018-05-29 15:17:57.224	0
143	OAI	http://10.130.9.111/jspui	2018-05-29 15:24:05.31	0
192	JSPUI	http://10.130.9.111/jspui	2018-06-01 16:00:41.795	1
145	REST	http://10.130.9.111/jspui	2018-05-29 15:25:15.474	0
146	OAI	http://10.130.9.111/jspui	2018-05-29 15:38:29.098	0
147	JSPUI	http://10.130.9.111/jspui	2018-05-29 15:39:00.666	1
148	REST	http://10.130.9.111/jspui	2018-05-29 15:39:19.738	0
149	OAI	http://10.130.9.111/jspui	2018-05-29 16:19:09.278	0
150	JSPUI	http://10.130.9.111/jspui	2018-05-29 16:19:42.739	1
151	REST	http://10.130.9.111/jspui	2018-05-29 16:20:03.736	0
152	OAI	http://10.130.9.111/jspui	2018-05-29 17:58:07.287	0
153	JSPUI	http://10.130.9.111/jspui	2018-05-29 17:59:10.464	1
154	REST	http://10.130.9.111/jspui	2018-05-29 17:59:33.457	0
155	OAI	http://10.130.9.111/jspui	2018-05-30 10:17:21.796	0
156	JSPUI	http://10.130.9.111/jspui	2018-05-30 10:17:55.589	1
157	REST	http://10.130.9.111/jspui	2018-05-30 10:18:24.168	0
158	OAI	http://10.130.9.111/jspui	2018-05-30 10:38:06.974	0
159	JSPUI	http://10.130.9.111/jspui	2018-05-30 10:38:40.999	1
160	REST	http://10.130.9.111/jspui	2018-05-30 10:39:02.718	0
161	OAI	http://10.130.9.111/jspui	2018-05-30 11:31:26.39	0
162	JSPUI	http://10.130.9.111/jspui	2018-05-30 11:32:10.586	1
163	REST	http://10.130.9.111/jspui	2018-05-30 11:32:31.527	0
164	OAI	http://10.130.9.111/jspui	2018-05-30 12:15:30.151	0
165	JSPUI	http://10.130.9.111/jspui	2018-05-30 12:16:04.802	1
166	REST	http://10.130.9.111/jspui	2018-05-30 12:16:27.626	0
167	OAI	http://10.130.9.111/jspui	2018-05-30 13:55:46.336	0
168	JSPUI	http://10.130.9.111/jspui	2018-05-30 13:56:34.282	1
169	REST	http://10.130.9.111/jspui	2018-05-30 13:56:55.509	0
170	OAI	http://10.130.9.111/jspui	2018-05-30 18:13:28.775	0
171	JSPUI	http://10.130.9.111/jspui	2018-05-30 18:14:01.813	1
172	REST	http://10.130.9.111/jspui	2018-05-30 18:15:04.198	0
173	OAI	http://10.130.9.111/jspui	2018-05-31 10:02:17.127	0
174	JSPUI	http://10.130.9.111/jspui	2018-05-31 10:02:51.868	1
175	REST	http://10.130.9.111/jspui	2018-05-31 10:03:26.816	0
176	OAI	http://10.130.9.111/jspui	2018-05-31 11:30:09.994	0
178	REST	http://10.130.9.111/jspui	2018-05-31 11:31:02.67	0
179	OAI	http://10.130.9.111/jspui	2018-05-31 13:34:41.093	0
180	JSPUI	http://10.130.9.111/jspui	2018-05-31 13:35:14.238	1
181	REST	http://10.130.9.111/jspui	2018-05-31 13:35:44.398	0
182	OAI	http://10.130.9.111/jspui	2018-05-31 19:54:45.777	0
183	JSPUI	http://10.130.9.111/jspui	2018-05-31 19:55:19.106	1
184	REST	http://10.130.9.111/jspui	2018-05-31 19:55:41.458	0
185	OAI	http://10.130.9.111/jspui	2018-06-01 10:06:33.801	0
186	JSPUI	http://10.130.9.111/jspui	2018-06-01 10:07:09.339	1
187	REST	http://10.130.9.111/jspui	2018-06-01 10:07:42.646	0
188	OAI	http://10.130.9.111/jspui	2018-06-01 14:01:13.066	0
189	JSPUI	http://10.130.9.111/jspui	2018-06-01 14:01:49.206	1
190	REST	http://10.130.9.111/jspui	2018-06-01 14:02:22.739	0
191	OAI	http://10.130.9.111/jspui	2018-06-01 16:00:11.892	0
193	REST	http://10.130.9.111/jspui	2018-06-01 16:00:59.871	0
194	OAI	http://10.130.9.111/jspui	2018-06-01 17:45:18.604	0
210	JSPUI	http://10.130.9.111/jspui	2018-06-02 12:02:21.898	1
196	REST	http://10.130.9.111/jspui	2018-06-01 17:46:46.551	0
197	OAI	http://10.130.9.111/jspui	2018-06-02 10:29:12.207	0
198	JSPUI	http://10.130.9.111/jspui	2018-06-02 10:29:48.72	1
199	REST	http://10.130.9.111/jspui	2018-06-02 10:30:18.039	0
200	OAI	http://10.130.9.111/jspui	2018-06-02 10:57:57.579	0
202	REST	http://10.130.9.111/jspui	2018-06-02 10:58:47.054	0
203	OAI	http://10.130.9.111/jspui	2018-06-02 11:12:05.522	0
211	REST	http://10.130.9.111/jspui	2018-06-02 12:02:41.179	0
205	REST	http://10.130.9.111/jspui	2018-06-02 11:13:04.915	0
206	OAI	http://10.130.9.111/jspui	2018-06-02 11:54:19.009	0
207	JSPUI	http://10.130.9.111/jspui	2018-06-02 11:54:51.185	1
208	REST	http://10.130.9.111/jspui	2018-06-02 11:55:09.904	0
209	OAI	http://10.130.9.111/jspui	2018-06-02 12:01:52.443	0
212	OAI	http://10.130.9.111/jspui	2018-06-02 12:16:36.365	0
213	JSPUI	http://10.130.9.111/jspui	2018-06-02 12:17:07.287	1
214	REST	http://10.130.9.111/jspui	2018-06-02 12:17:27.591	0
215	OAI	http://10.130.9.111/jspui	2018-06-02 13:57:51.808	0
216	JSPUI	http://10.130.9.111/jspui	2018-06-02 13:58:23.846	1
217	REST	http://10.130.9.111/jspui	2018-06-02 13:58:46.787	0
218	OAI	http://10.130.9.111/jspui	2018-06-02 14:23:18.177	0
221	OAI	http://10.130.9.111/jspui	2018-06-02 14:35:28.912	0
220	REST	http://10.130.9.111/jspui	2018-06-02 14:24:04.589	0
224	OAI	http://10.130.9.111/jspui	2018-06-02 15:29:21.619	0
223	REST	http://10.130.9.111/jspui	2018-06-02 14:36:14.042	0
225	JSPUI	http://10.130.9.111/jspui	2018-06-02 15:29:51.743	1
226	REST	http://10.130.9.111/jspui	2018-06-02 15:30:11.944	0
227	OAI	http://10.130.9.111/jspui	2018-06-02 15:42:14.561	0
228	JSPUI	http://10.130.9.111/jspui	2018-06-02 15:42:45.908	1
229	REST	http://10.130.9.111/jspui	2018-06-02 15:43:05.878	0
230	OAI	http://10.130.9.111/jspui	2018-06-02 15:53:23.624	0
231	JSPUI	http://10.130.9.111/jspui	2018-06-02 15:53:53.896	1
232	REST	http://10.130.9.111/jspui	2018-06-02 15:54:14.076	0
233	OAI	http://10.130.9.111/jspui	2018-06-02 16:13:25.906	0
234	JSPUI	http://10.130.9.111/jspui	2018-06-02 16:14:09.759	1
235	REST	http://10.130.9.111/jspui	2018-06-02 16:14:33.287	0
236	OAI	http://10.130.9.111/jspui	2018-06-02 16:59:20.326	0
237	JSPUI	http://10.130.9.111/jspui	2018-06-02 16:59:55.271	1
238	REST	http://10.130.9.111/jspui	2018-06-02 17:00:17.43	0
239	OAI	http://10.130.9.111/jspui	2018-06-02 17:06:47.856	0
240	JSPUI	http://10.130.9.111/jspui	2018-06-02 17:08:04.211	1
241	REST	http://10.130.9.111/jspui	2018-06-02 17:08:26.698	0
242	OAI	http://10.130.9.111/jspui	2018-06-02 19:35:12.739	0
291	JSPUI	http://10.130.9.111/jspui	2018-06-04 22:26:40.438	1
244	REST	http://10.130.9.111/jspui	2018-06-02 19:36:21.125	0
245	OAI	http://10.130.9.111/jspui	2018-06-03 09:27:13.924	0
247	REST	http://10.130.9.111/jspui	2018-06-03 09:28:17.465	0
248	OAI	http://10.130.9.111/jspui	2018-06-03 09:34:14.879	0
249	JSPUI	http://10.130.9.111/jspui	2018-06-03 09:34:44.391	1
250	REST	http://10.130.9.111/jspui	2018-06-03 09:35:01.478	0
251	OAI	http://10.130.9.111/jspui	2018-06-03 09:43:45.691	0
252	JSPUI	http://10.130.9.111/jspui	2018-06-03 09:44:15.977	1
253	REST	http://10.130.9.111/jspui	2018-06-03 09:44:34.628	0
254	OAI	http://10.130.9.111/jspui	2018-06-03 09:51:14.207	0
255	JSPUI	http://10.130.9.111/jspui	2018-06-03 09:51:44.429	1
256	REST	http://10.130.9.111/jspui	2018-06-03 09:52:04.27	0
257	OAI	http://10.130.9.111/jspui	2018-06-03 10:23:02.911	0
258	JSPUI	http://10.130.9.111/jspui	2018-06-03 10:23:43.092	1
259	REST	http://10.130.9.111/jspui	2018-06-03 10:24:03.503	0
260	OAI	http://10.130.9.111/jspui	2018-06-03 11:27:55.797	0
292	REST	http://10.130.9.111/jspui	2018-06-04 22:27:10.05	0
262	REST	http://10.130.9.111/jspui	2018-06-03 11:29:02.129	0
263	OAI	http://10.130.9.111/jspui	2018-06-03 18:01:56.53	0
264	JSPUI	http://10.130.9.111/jspui	2018-06-03 18:02:36.558	1
265	REST	http://10.130.9.111/jspui	2018-06-03 18:03:04.258	0
266	OAI	http://10.130.9.111/jspui	2018-06-04 10:07:03.138	0
267	JSPUI	http://10.130.9.111/jspui	2018-06-04 10:07:39.254	1
268	REST	http://10.130.9.111/jspui	2018-06-04 10:08:13.97	0
269	OAI	http://10.130.9.111/jspui	2018-06-04 11:11:29.128	0
270	JSPUI	http://10.130.9.111/jspui	2018-06-04 11:11:59.987	1
271	REST	http://10.130.9.111/jspui	2018-06-04 11:12:19.453	0
272	OAI	http://10.130.9.111/jspui	2018-06-04 11:22:50.079	0
274	REST	http://10.130.9.111/jspui	2018-06-04 11:23:41.887	0
275	OAI	http://10.130.9.111/jspui	2018-06-04 11:36:43.134	0
276	JSPUI	http://10.130.9.111/jspui	2018-06-04 11:37:15.399	1
277	REST	http://10.130.9.111/jspui	2018-06-04 11:37:36.638	0
278	OAI	http://10.130.9.111/jspui	2018-06-04 13:56:03.644	0
279	JSPUI	http://10.130.9.111/jspui	2018-06-04 13:56:41.788	1
280	REST	http://10.130.9.111/jspui	2018-06-04 13:57:01.575	0
281	OAI	http://10.130.9.111/jspui	2018-06-04 15:14:06.326	0
293	OAI	http://10.130.9.111/jspui	2018-06-05 09:56:33.237	0
283	REST	http://10.130.9.111/jspui	2018-06-04 15:14:55.519	0
284	OAI	http://10.130.9.111/jspui	2018-06-04 19:14:09.292	0
285	JSPUI	http://10.130.9.111/jspui	2018-06-04 19:15:12.898	1
286	REST	http://10.130.9.111/jspui	2018-06-04 19:15:37.693	0
287	OAI	http://10.130.9.111/jspui	2018-06-04 21:41:17.603	0
288	JSPUI	http://10.130.9.111/jspui	2018-06-04 21:41:51.564	1
289	REST	http://10.130.9.111/jspui	2018-06-04 21:42:18.98	0
290	OAI	http://10.130.9.111/jspui	2018-06-04 22:26:00.767	0
294	JSPUI	http://10.130.9.111/jspui	2018-06-05 09:57:19.483	1
295	REST	http://10.130.9.111/jspui	2018-06-05 09:57:42.016	0
296	OAI	http://10.130.9.111/jspui	2018-06-05 11:07:42.792	0
297	JSPUI	http://10.130.9.111/jspui	2018-06-05 11:08:14.628	1
298	REST	http://10.130.9.111/jspui	2018-06-05 11:08:37.022	0
299	OAI	http://10.130.9.111/jspui	2018-06-05 11:16:32.841	0
311	OAI	http://10.130.9.111/jspui	2018-06-05 12:30:18.018	0
301	REST	http://10.130.9.111/jspui	2018-06-05 11:18:12.005	0
302	OAI	http://10.130.9.111/jspui	2018-06-05 11:36:33.783	0
303	JSPUI	http://10.130.9.111/jspui	2018-06-05 11:49:50.351	1
304	REST	http://10.130.9.111/jspui	2018-06-05 11:50:12.832	0
305	OAI	http://10.130.9.111/jspui	2018-06-05 12:14:37.671	0
307	REST	http://10.130.9.111/jspui	2018-06-05 12:15:33.304	0
308	OAI	http://10.130.9.111/jspui	2018-06-05 12:21:21.993	0
309	JSPUI	http://10.130.9.111/jspui	2018-06-05 12:22:05.816	1
310	REST	http://10.130.9.111/jspui	2018-06-05 12:22:31.113	0
312	JSPUI	http://10.130.9.111/jspui	2018-06-05 12:30:58.501	1
313	REST	http://10.130.9.111/jspui	2018-06-05 12:31:19.776	0
314	OAI	http://10.130.9.111/jspui	2018-06-05 13:54:56.132	0
315	JSPUI	http://10.130.9.111/jspui	2018-06-05 13:55:29.581	1
316	REST	http://10.130.9.111/jspui	2018-06-05 13:55:49.939	0
317	OAI	http://10.130.9.111/jspui	2018-06-05 14:18:31.075	0
318	JSPUI	http://10.130.9.111/jspui	2018-06-05 14:19:03.13	1
319	REST	http://10.130.9.111/jspui	2018-06-05 14:19:37.767	0
320	OAI	http://10.130.9.111/jspui	2018-06-05 14:54:58.388	0
321	JSPUI	http://10.130.9.111/jspui	2018-06-05 14:55:26.408	1
322	REST	http://10.130.9.111/jspui	2018-06-05 14:55:45.156	0
323	OAI	http://10.130.9.111/jspui	2018-06-05 16:23:22.419	0
324	JSPUI	http://10.130.9.111/jspui	2018-06-05 16:23:49.368	1
325	REST	http://10.130.9.111/jspui	2018-06-05 16:24:06.092	0
326	OAI	http://10.130.9.111/jspui	2018-06-05 18:05:08.689	0
327	JSPUI	http://10.130.9.111/jspui	2018-06-05 18:05:41.781	1
328	REST	http://10.130.9.111/jspui	2018-06-05 18:06:35.089	0
329	OAI	http://10.130.9.111/jspui	2018-06-05 22:56:51.056	0
390	OAI	http://10.130.9.111/jspui	2018-06-06 15:55:28.678	0
331	REST	http://10.130.9.111/jspui	2018-06-05 22:58:12.561	0
332	OAI	http://10.130.9.111/jspui	2018-06-06 10:03:57.64	0
333	JSPUI	http://10.130.9.111/jspui	2018-06-06 10:04:35.233	1
334	REST	http://10.130.9.111/jspui	2018-06-06 10:04:59.406	0
335	OAI	http://10.130.9.111/jspui	2018-06-06 10:28:34.817	0
336	JSPUI	http://10.130.9.111/jspui	2018-06-06 10:29:06.064	1
337	REST	http://10.130.9.111/jspui	2018-06-06 10:29:25.717	0
338	OAI	http://10.130.9.111/jspui	2018-06-06 10:43:24.875	0
339	JSPUI	http://10.130.9.111/jspui	2018-06-06 10:43:56.069	1
340	REST	http://10.130.9.111/jspui	2018-06-06 10:44:17.75	0
341	OAI	http://10.130.9.111/jspui	2018-06-06 10:51:20.309	0
342	JSPUI	http://10.130.9.111/jspui	2018-06-06 10:51:52.863	1
343	REST	http://10.130.9.111/jspui	2018-06-06 10:52:18.806	0
344	OAI	http://10.130.9.111/jspui	2018-06-06 11:03:26.215	0
345	JSPUI	http://10.130.9.111/jspui	2018-06-06 11:03:59.404	1
346	REST	http://10.130.9.111/jspui	2018-06-06 11:04:18.865	0
347	OAI	http://10.130.9.111/jspui	2018-06-06 11:13:07.836	0
348	JSPUI	http://10.130.9.111/jspui	2018-06-06 11:13:36.872	1
349	REST	http://10.130.9.111/jspui	2018-06-06 11:13:54.49	0
350	OAI	http://10.130.9.111/jspui	2018-06-06 11:40:33.109	0
351	JSPUI	http://10.130.9.111/jspui	2018-06-06 11:41:05.385	1
352	REST	http://10.130.9.111/jspui	2018-06-06 11:41:25.188	0
353	OAI	http://10.130.9.111/jspui	2018-06-06 11:50:31.661	0
354	JSPUI	http://10.130.9.111/jspui	2018-06-06 11:51:01.073	1
355	REST	http://10.130.9.111/jspui	2018-06-06 11:51:18.631	0
356	OAI	http://10.130.9.111/jspui	2018-06-06 12:09:26.35	0
358	REST	http://10.130.9.111/jspui	2018-06-06 12:10:15.917	0
359	OAI	http://10.130.9.111/jspui	2018-06-06 14:23:20.18	0
360	JSPUI	http://10.130.9.111/jspui	2018-06-06 14:23:54.951	1
361	REST	http://10.130.9.111/jspui	2018-06-06 14:24:22.674	0
362	OAI	http://10.130.9.111/jspui	2018-06-06 14:40:44.881	0
363	JSPUI	http://10.130.9.111/jspui	2018-06-06 14:41:14.414	1
364	REST	http://10.130.9.111/jspui	2018-06-06 14:41:30.675	0
365	OAI	http://10.130.9.111/jspui	2018-06-06 14:52:56.254	0
391	JSPUI	http://10.130.9.111/jspui	2018-06-06 15:56:01.321	1
367	REST	http://10.130.9.111/jspui	2018-06-06 14:53:39.204	0
368	OAI	http://10.130.9.111/jspui	2018-06-06 15:18:47.167	0
369	JSPUI	http://10.130.9.111/jspui	2018-06-06 15:19:12.888	1
370	REST	http://10.130.9.111/jspui	2018-06-06 15:19:28.281	0
371	OAI	http://10.130.9.111/jspui	2018-06-06 15:23:51.188	0
372	JSPUI	http://10.130.9.111/jspui	2018-06-06 15:24:18.847	1
373	REST	http://10.130.9.111/jspui	2018-06-06 15:24:38.867	0
374	OAI	http://10.130.9.111/jspui	2018-06-06 15:29:27.522	0
376	REST	http://10.130.9.111/jspui	2018-06-06 15:30:08.962	0
377	OAI	http://10.130.9.111/jspui	2018-06-06 15:34:16.413	0
378	OAI	http://10.130.9.111/jspui	2018-06-06 15:36:22.854	0
392	REST	http://10.130.9.111/jspui	2018-06-06 15:56:24.151	0
380	REST	http://10.130.9.111/jspui	2018-06-06 15:37:05.301	0
381	OAI	http://10.130.9.111/jspui	2018-06-06 15:39:28.899	0
382	JSPUI	http://10.130.9.111/jspui	2018-06-06 15:39:56.803	1
383	REST	http://10.130.9.111/jspui	2018-06-06 15:40:14.287	0
384	OAI	http://10.130.9.111/jspui	2018-06-06 15:45:32.898	0
385	JSPUI	http://10.130.9.111/jspui	2018-06-06 15:46:00.857	1
386	REST	http://10.130.9.111/jspui	2018-06-06 15:46:18.424	0
387	OAI	http://10.130.9.111/jspui	2018-06-06 15:50:42.586	0
388	JSPUI	http://10.130.9.111/jspui	2018-06-06 15:51:12.603	1
389	REST	http://10.130.9.111/jspui	2018-06-06 15:51:32.153	0
393	OAI	http://10.130.9.111/jspui	2018-06-06 18:51:34.317	0
394	JSPUI	http://10.130.9.111/jspui	2018-06-06 18:52:14.909	1
395	REST	http://10.130.9.111/jspui	2018-06-06 18:52:36.923	0
396	OAI	http://10.130.9.111/jspui	2018-06-07 19:55:18.797	0
410	REST	http://10.130.9.111/jspui	2018-06-07 20:49:53.321	0
398	REST	http://10.130.9.111/jspui	2018-06-07 19:56:24.788	0
399	OAI	http://10.130.9.111/jspui	2018-06-07 20:13:13.821	0
400	JSPUI	http://10.130.9.111/jspui	2018-06-07 20:13:54.624	1
401	REST	http://10.130.9.111/jspui	2018-06-07 20:14:19.291	0
402	OAI	http://10.130.9.111/jspui	2018-06-07 20:24:02.961	0
403	JSPUI	http://10.130.9.111/jspui	2018-06-07 20:24:41.351	1
404	REST	http://10.130.9.111/jspui	2018-06-07 20:25:07.637	0
405	OAI	http://10.130.9.111/jspui	2018-06-07 20:33:33.365	0
406	JSPUI	http://10.130.9.111/jspui	2018-06-07 20:34:11.199	1
407	REST	http://10.130.9.111/jspui	2018-06-07 20:34:37.41	0
408	OAI	http://10.130.9.111/jspui	2018-06-07 20:48:49.215	0
409	JSPUI	http://10.130.9.111/jspui	2018-06-07 20:49:28.17	1
411	OAI	http://10.130.9.111/jspui	2018-06-07 21:40:41.105	0
412	JSPUI	http://10.130.9.111/jspui	2018-06-07 21:41:22.173	1
413	REST	http://10.130.9.111/jspui	2018-06-07 21:41:45.467	0
414	OAI	http://10.130.9.111/jspui	2018-06-07 21:50:41.101	0
415	JSPUI	http://10.130.9.111/jspui	2018-06-07 21:51:12.327	1
416	REST	http://10.130.9.111/jspui	2018-06-07 21:51:33.524	0
417	OAI	http://10.130.9.111/jspui	2018-06-07 21:58:36.529	0
418	JSPUI	http://10.130.9.111/jspui	2018-06-07 21:59:09.642	1
419	REST	http://10.130.9.111/jspui	2018-06-07 21:59:31.146	0
420	OAI	http://10.130.9.111/jspui	2018-06-07 22:04:14.763	0
421	JSPUI	http://10.130.9.111/jspui	2018-06-07 22:05:17.314	1
422	REST	http://10.130.9.111/jspui	2018-06-07 22:05:46.23	0
423	OAI	http://10.130.9.111/jspui	2018-06-08 09:53:48.822	0
424	JSPUI	http://10.130.9.111/jspui	2018-06-08 09:54:21.742	1
425	REST	http://10.130.9.111/jspui	2018-06-08 09:54:51.14	0
426	OAI	http://10.130.9.111/jspui	2018-06-08 10:39:29.647	0
427	JSPUI	http://10.130.9.111/jspui	2018-06-08 10:40:01.033	1
428	REST	http://10.130.9.111/jspui	2018-06-08 10:40:20.555	0
429	OAI	http://10.130.9.111/jspui	2018-06-08 22:10:24.56	0
430	JSPUI	http://10.130.9.111/jspui	2018-06-08 22:11:06.298	1
431	REST	http://10.130.9.111/jspui	2018-06-08 22:11:31.525	0
432	OAI	http://10.130.9.111/jspui	2018-06-08 22:35:22.856	0
433	JSPUI	http://10.130.9.111/jspui	2018-06-08 22:35:58.019	1
434	REST	http://10.130.9.111/jspui	2018-06-08 22:36:21.425	0
435	OAI	http://10.130.9.111/jspui	2018-06-08 22:44:56.532	0
488	REST	http://10.130.9.111/jspui	2018-06-10 11:19:14.915	0
437	REST	http://10.130.9.111/jspui	2018-06-08 22:45:52.32	0
438	OAI	http://10.130.9.111/jspui	2018-06-09 10:13:46.219	0
440	REST	http://10.130.9.111/jspui	2018-06-09 10:14:45.639	0
441	OAI	http://10.130.9.111/jspui	2018-06-09 10:28:51.748	0
442	JSPUI	http://10.130.9.111/jspui	2018-06-09 10:29:25.748	1
443	REST	http://10.130.9.111/jspui	2018-06-09 10:29:47.347	0
444	OAI	http://10.130.9.111/jspui	2018-06-09 10:40:30.011	0
489	OAI	http://10.130.9.111/jspui	2018-06-10 11:35:29.638	0
446	REST	http://10.130.9.111/jspui	2018-06-09 10:41:19.612	0
447	OAI	http://10.130.9.111/jspui	2018-06-09 10:51:27.96	0
448	JSPUI	http://10.130.9.111/jspui	2018-06-09 10:51:55.416	1
449	REST	http://10.130.9.111/jspui	2018-06-09 10:52:11.958	0
450	OAI	http://10.130.9.111/jspui	2018-06-09 11:01:43.496	0
451	JSPUI	http://10.130.9.111/jspui	2018-06-09 11:02:12.097	1
452	REST	http://10.130.9.111/jspui	2018-06-09 11:02:33.083	0
453	OAI	http://10.130.9.111/jspui	2018-06-09 13:20:51.766	0
455	REST	http://10.130.9.111/jspui	2018-06-09 13:22:03.953	0
456	OAI	http://10.130.9.111/jspui	2018-06-09 18:12:04.998	0
512	JSPUI	http://10.130.9.111/jspui	2018-06-11 10:22:39.944	1
458	REST	http://10.130.9.111/jspui	2018-06-09 18:13:40.149	0
459	OAI	http://10.130.9.111/jspui	2018-06-09 21:33:48.058	0
461	REST	http://10.130.9.111/jspui	2018-06-09 21:35:28.592	0
462	OAI	http://10.130.9.111/jspui	2018-06-10 09:50:13.501	0
491	REST	http://10.130.9.111/jspui	2018-06-10 11:36:41.025	0
464	REST	http://10.130.9.111/jspui	2018-06-10 09:51:05.7	0
465	OAI	http://10.130.9.111/jspui	2018-06-10 10:10:00.221	0
467	REST	http://10.130.9.111/jspui	2018-06-10 10:10:46.665	0
468	OAI	http://10.130.9.111/jspui	2018-06-10 10:16:04.396	0
469	JSPUI	http://10.130.9.111/jspui	2018-06-10 10:16:34.135	1
470	REST	http://10.130.9.111/jspui	2018-06-10 10:16:52.671	0
471	OAI	http://10.130.9.111/jspui	2018-06-10 10:33:44.334	0
492	OAI	http://10.130.9.111/jspui	2018-06-10 11:48:48.028	0
473	REST	http://10.130.9.111/jspui	2018-06-10 10:34:37.856	0
474	OAI	http://10.130.9.111/jspui	2018-06-10 10:36:35.873	0
475	JSPUI	http://10.130.9.111/jspui	2018-06-10 10:37:08.307	1
476	REST	http://10.130.9.111/jspui	2018-06-10 10:37:27.905	0
477	OAI	http://10.130.9.111/jspui	2018-06-10 10:44:59.575	0
478	JSPUI	http://10.130.9.111/jspui	2018-06-10 10:45:30.136	1
479	REST	http://10.130.9.111/jspui	2018-06-10 10:45:48.676	0
480	OAI	http://10.130.9.111/jspui	2018-06-10 10:47:43.162	0
482	REST	http://10.130.9.111/jspui	2018-06-10 10:49:00.763	0
483	OAI	http://10.130.9.111/jspui	2018-06-10 11:13:58.489	0
484	JSPUI	http://10.130.9.111/jspui	2018-06-10 11:14:32.871	1
485	REST	http://10.130.9.111/jspui	2018-06-10 11:14:54.869	0
486	OAI	http://10.130.9.111/jspui	2018-06-10 11:18:07.649	0
493	OAI	http://10.130.9.111/jspui	2018-06-10 11:52:12.22	0
494	JSPUI	http://10.130.9.111/jspui	2018-06-10 11:52:49.979	1
495	REST	http://10.130.9.111/jspui	2018-06-10 11:53:15.503	0
496	OAI	http://10.130.9.111/jspui	2018-06-10 12:41:40.23	0
497	JSPUI	http://10.130.9.111/jspui	2018-06-10 12:42:09.735	1
498	REST	http://10.130.9.111/jspui	2018-06-10 12:42:26.906	0
499	OAI	http://10.130.9.111/jspui	2018-06-10 12:49:50.619	0
500	JSPUI	http://10.130.9.111/jspui	2018-06-10 12:50:21.851	1
501	REST	http://10.130.9.111/jspui	2018-06-10 12:50:42.68	0
502	OAI	http://10.130.9.111/jspui	2018-06-10 12:58:12.762	0
503	JSPUI	http://10.130.9.111/jspui	2018-06-10 12:58:45.106	1
504	REST	http://10.130.9.111/jspui	2018-06-10 12:59:05.891	0
505	OAI	http://10.130.9.111/jspui	2018-06-10 13:05:03.178	0
506	JSPUI	http://10.130.9.111/jspui	2018-06-10 13:05:37.937	1
507	REST	http://10.130.9.111/jspui	2018-06-10 13:06:01.026	0
508	OAI	http://10.130.9.111/jspui	2018-06-11 09:57:27.109	0
509	JSPUI	http://10.130.9.111/jspui	2018-06-11 09:58:00.093	1
510	REST	http://10.130.9.111/jspui	2018-06-11 09:58:24.151	0
511	OAI	http://10.130.9.111/jspui	2018-06-11 10:22:08.38	0
513	REST	http://10.130.9.111/jspui	2018-06-11 10:22:58.011	0
514	OAI	http://10.130.9.111/jspui	2018-06-11 10:39:13.397	0
515	JSPUI	http://10.130.9.111/jspui	2018-06-11 10:39:50.041	1
516	REST	http://10.130.9.111/jspui	2018-06-11 10:40:45.585	0
517	OAI	http://10.130.9.111/jspui	2018-06-11 11:33:55.434	0
518	JSPUI	http://10.130.9.111/jspui	2018-06-11 11:34:30.921	1
519	REST	http://10.130.9.111/jspui	2018-06-11 11:34:54.87	0
520	OAI	http://10.130.9.111/jspui	2018-06-11 11:43:52.468	0
521	JSPUI	http://10.130.9.111/jspui	2018-06-11 11:44:30.6	1
522	REST	http://10.130.9.111/jspui	2018-06-11 11:44:52.751	0
523	OAI	http://10.130.9.111/jspui	2018-06-11 11:57:05.01	0
524	JSPUI	http://10.130.9.111/jspui	2018-06-11 11:57:44.064	1
525	REST	http://10.130.9.111/jspui	2018-06-11 11:58:08.582	0
526	OAI	http://10.130.9.111/jspui	2018-06-11 12:04:14.217	0
527	JSPUI	http://10.130.9.111/jspui	2018-06-11 12:04:50.516	1
528	REST	http://10.130.9.111/jspui	2018-06-11 12:05:20.79	0
529	OAI	http://10.130.9.111/jspui	2018-06-11 12:13:23.25	0
530	JSPUI	http://10.130.9.111/jspui	2018-06-11 12:13:56.419	1
531	REST	http://10.130.9.111/jspui	2018-06-11 12:14:18.804	0
532	OAI	http://10.130.9.111/jspui	2018-06-11 14:26:52.826	0
533	JSPUI	http://10.130.9.111/jspui	2018-06-11 14:27:24.839	1
534	REST	http://10.130.9.111/jspui	2018-06-11 14:27:47.516	0
535	OAI	http://10.130.9.111/jspui	2018-06-11 14:35:06.2	0
536	JSPUI	http://10.130.9.111/jspui	2018-06-11 14:35:38.124	1
537	REST	http://10.130.9.111/jspui	2018-06-11 14:36:00.26	0
538	OAI	http://10.130.9.111/jspui	2018-06-11 14:42:42.506	0
539	JSPUI	http://10.130.9.111/jspui	2018-06-11 14:43:14.967	1
540	REST	http://10.130.9.111/jspui	2018-06-11 14:43:36.309	0
541	OAI	http://10.130.9.111/jspui	2018-06-11 14:57:34.792	0
542	JSPUI	http://10.130.9.111/jspui	2018-06-11 14:58:07.325	1
543	OAI	http://10.130.9.111/jspui	2018-06-11 15:00:48.042	0
544	JSPUI	http://10.130.9.111/jspui	2018-06-11 15:01:20.172	1
545	REST	http://10.130.9.111/jspui	2018-06-11 15:01:42.568	0
546	OAI	http://10.130.9.111/jspui	2018-06-11 15:17:17.551	0
611	REST	http://10.130.9.111/jspui	2018-06-12 10:26:39.398	0
548	REST	http://10.130.9.111/jspui	2018-06-11 15:18:11.815	0
549	OAI	http://10.130.9.111/jspui	2018-06-11 15:24:46.415	0
550	JSPUI	http://10.130.9.111/jspui	2018-06-11 15:25:19.755	1
551	REST	http://10.130.9.111/jspui	2018-06-11 15:25:41.019	0
552	OAI	http://10.130.9.111/jspui	2018-06-11 15:30:49.766	0
553	JSPUI	http://10.130.9.111/jspui	2018-06-11 15:31:24.544	1
554	REST	http://10.130.9.111/jspui	2018-06-11 15:31:47.249	0
555	OAI	http://10.130.9.111/jspui	2018-06-11 15:38:35.95	0
556	JSPUI	http://10.130.9.111/jspui	2018-06-11 15:39:08.413	1
557	REST	http://10.130.9.111/jspui	2018-06-11 15:39:30.158	0
558	OAI	http://10.130.9.111/jspui	2018-06-11 15:55:25.939	0
560	REST	http://10.130.9.111/jspui	2018-06-11 15:56:25.292	0
561	OAI	http://10.130.9.111/jspui	2018-06-11 16:12:07.797	0
562	JSPUI	http://10.130.9.111/jspui	2018-06-11 16:12:40.914	1
563	REST	http://10.130.9.111/jspui	2018-06-11 16:13:02.024	0
564	OAI	http://10.130.9.111/jspui	2018-06-11 16:25:56.334	0
565	JSPUI	http://10.130.9.111/jspui	2018-06-11 16:26:30.2	1
566	REST	http://10.130.9.111/jspui	2018-06-11 16:26:52.665	0
567	OAI	http://10.130.9.111/jspui	2018-06-11 16:33:58.294	0
568	JSPUI	http://10.130.9.111/jspui	2018-06-11 16:34:29.791	1
569	REST	http://10.130.9.111/jspui	2018-06-11 16:34:50.865	0
570	OAI	http://10.130.9.111/jspui	2018-06-11 16:50:08.275	0
571	JSPUI	http://10.130.9.111/jspui	2018-06-11 16:50:55.993	1
572	REST	http://10.130.9.111/jspui	2018-06-11 16:52:20.46	0
573	OAI	http://10.130.9.111/jspui	2018-06-11 18:01:59.279	0
593	REST	http://10.130.9.111/jspui	2018-06-11 20:23:44.704	0
575	REST	http://10.130.9.111/jspui	2018-06-11 18:03:00.885	0
576	OAI	http://10.130.9.111/jspui	2018-06-11 19:17:13.335	0
577	JSPUI	http://10.130.9.111/jspui	2018-06-11 19:17:44.991	1
578	REST	http://10.130.9.111/jspui	2018-06-11 19:18:06.426	0
579	OAI	http://10.130.9.111/jspui	2018-06-11 19:25:51.816	0
580	JSPUI	http://10.130.9.111/jspui	2018-06-11 19:26:29.167	1
581	REST	http://10.130.9.111/jspui	2018-06-11 19:26:51.351	0
582	OAI	http://10.130.9.111/jspui	2018-06-11 19:34:59.803	0
583	JSPUI	http://10.130.9.111/jspui	2018-06-11 19:35:33.62	1
584	REST	http://10.130.9.111/jspui	2018-06-11 19:35:54.868	0
585	OAI	http://10.130.9.111/jspui	2018-06-11 19:42:54.965	0
587	REST	http://10.130.9.111/jspui	2018-06-11 19:43:45.91	0
588	OAI	http://10.130.9.111/jspui	2018-06-11 19:56:21.829	0
589	JSPUI	http://10.130.9.111/jspui	2018-06-11 19:56:56.806	1
590	REST	http://10.130.9.111/jspui	2018-06-11 19:57:19.383	0
591	OAI	http://10.130.9.111/jspui	2018-06-11 20:22:51.466	0
594	OAI	http://10.130.9.111/jspui	2018-06-11 20:35:05.576	0
595	JSPUI	http://10.130.9.111/jspui	2018-06-11 20:35:38.652	1
596	REST	http://10.130.9.111/jspui	2018-06-11 20:36:07.78	0
597	OAI	http://10.130.9.111/jspui	2018-06-11 20:49:42.578	0
598	JSPUI	http://10.130.9.111/jspui	2018-06-11 20:50:25.02	1
599	REST	http://10.130.9.111/jspui	2018-06-11 20:50:53.327	0
600	OAI	http://10.130.9.111/jspui	2018-06-11 21:27:28.105	0
601	JSPUI	http://10.130.9.111/jspui	2018-06-11 21:28:09.049	1
602	REST	http://10.130.9.111/jspui	2018-06-11 21:28:37.519	0
603	OAI	http://10.130.9.111/jspui	2018-06-11 21:52:33.602	0
604	JSPUI	http://10.130.9.111/jspui	2018-06-11 21:53:18.102	1
605	REST	http://10.130.9.111/jspui	2018-06-11 21:53:47.549	0
606	OAI	http://10.130.9.111/jspui	2018-06-12 10:17:13.391	0
607	JSPUI	http://10.130.9.111/jspui	2018-06-12 10:18:10.288	1
608	REST	http://10.130.9.111/jspui	2018-06-12 10:18:40.478	0
609	OAI	http://10.130.9.111/jspui	2018-06-12 10:25:51.171	0
610	JSPUI	http://10.130.9.111/jspui	2018-06-12 10:26:21.016	1
612	OAI	http://10.130.9.111/jspui	2018-06-12 10:34:13.587	0
613	JSPUI	http://10.130.9.111/jspui	2018-06-12 10:34:45.028	1
614	REST	http://10.130.9.111/jspui	2018-06-12 10:35:07.628	0
615	OAI	http://10.130.9.111/jspui	2018-06-12 10:48:19.828	0
616	JSPUI	http://10.130.9.111/jspui	2018-06-12 10:48:49.882	1
617	REST	http://10.130.9.111/jspui	2018-06-12 10:49:12.022	0
618	OAI	http://10.130.9.111/jspui	2018-06-12 11:02:44.174	0
619	JSPUI	http://10.130.9.111/jspui	2018-06-12 11:03:16.8	1
620	REST	http://10.130.9.111/jspui	2018-06-12 11:03:38.33	0
621	OAI	http://10.130.9.111/jspui	2018-06-12 11:26:04.564	0
622	JSPUI	http://10.130.9.111/jspui	2018-06-12 11:26:36.874	1
623	REST	http://10.130.9.111/jspui	2018-06-12 11:26:59.344	0
624	OAI	http://10.130.9.111/jspui	2018-06-12 11:34:08.634	0
625	JSPUI	http://10.130.9.111/jspui	2018-06-12 11:34:54.515	1
626	REST	http://10.130.9.111/jspui	2018-06-12 11:35:50.033	0
627	OAI	http://10.130.9.111/jspui	2018-06-12 11:43:23.388	0
628	JSPUI	http://10.130.9.111/jspui	2018-06-12 11:43:54.493	1
629	REST	http://10.130.9.111/jspui	2018-06-12 11:44:21.642	0
630	OAI	http://10.130.9.111/jspui	2018-06-12 11:50:22.507	0
631	JSPUI	http://10.130.9.111/jspui	2018-06-12 11:50:55.207	1
632	REST	http://10.130.9.111/jspui	2018-06-12 11:51:15.352	0
633	OAI	http://10.130.9.111/jspui	2018-06-12 11:56:56.227	0
634	JSPUI	http://10.130.9.111/jspui	2018-06-12 11:57:28.199	1
635	REST	http://10.130.9.111/jspui	2018-06-12 11:57:48.485	0
636	OAI	http://10.130.9.111/jspui	2018-06-12 12:03:30.514	0
637	JSPUI	http://10.130.9.111/jspui	2018-06-12 12:04:03.834	1
638	REST	http://10.130.9.111/jspui	2018-06-12 12:04:22.583	0
639	OAI	http://10.130.9.111/jspui	2018-06-12 12:13:16.094	0
640	JSPUI	http://10.130.9.111/jspui	2018-06-12 12:14:01.145	1
641	REST	http://10.130.9.111/jspui	2018-06-12 12:14:25.797	0
642	OAI	http://10.130.9.111/jspui	2018-06-12 12:30:34.569	0
643	JSPUI	http://10.130.9.111/jspui	2018-06-12 12:31:04.636	1
644	REST	http://10.130.9.111/jspui	2018-06-12 12:31:23.137	0
645	OAI	http://10.130.9.111/jspui	2018-06-12 14:03:51.92	0
646	JSPUI	http://10.130.9.111/jspui	2018-06-12 14:04:19.585	1
647	OAI	http://10.130.9.111/jspui	2018-06-12 14:06:58.117	0
689	REST	http://10.130.9.111/jspui	2018-06-12 16:42:07.375	0
649	REST	http://10.130.9.111/jspui	2018-06-12 14:07:45.758	0
650	OAI	http://10.130.9.111/jspui	2018-06-12 14:30:21.093	0
651	JSPUI	http://10.130.9.111/jspui	2018-06-12 14:30:51.747	1
652	REST	http://10.130.9.111/jspui	2018-06-12 14:31:11.435	0
653	OAI	http://10.130.9.111/jspui	2018-06-12 14:41:38.077	0
654	JSPUI	http://10.130.9.111/jspui	2018-06-12 14:42:05.917	1
655	REST	http://10.130.9.111/jspui	2018-06-12 14:42:23.158	0
656	OAI	http://10.130.9.111/jspui	2018-06-12 15:02:14.033	0
657	JSPUI	http://10.130.9.111/jspui	2018-06-12 15:02:48.306	1
658	REST	http://10.130.9.111/jspui	2018-06-12 15:03:08.57	0
659	OAI	http://10.130.9.111/jspui	2018-06-12 15:11:03.247	0
660	JSPUI	http://10.130.9.111/jspui	2018-06-12 15:11:33.086	1
661	REST	http://10.130.9.111/jspui	2018-06-12 15:11:51.573	0
662	OAI	http://10.130.9.111/jspui	2018-06-12 15:18:51.551	0
663	JSPUI	http://10.130.9.111/jspui	2018-06-12 15:19:23.831	1
664	REST	http://10.130.9.111/jspui	2018-06-12 15:19:43.657	0
665	OAI	http://10.130.9.111/jspui	2018-06-12 15:28:47.202	0
666	JSPUI	http://10.130.9.111/jspui	2018-06-12 15:29:15.11	1
667	REST	http://10.130.9.111/jspui	2018-06-12 15:29:32.539	0
668	OAI	http://10.130.9.111/jspui	2018-06-12 15:50:14.328	0
669	JSPUI	http://10.130.9.111/jspui	2018-06-12 15:50:42.842	1
670	REST	http://10.130.9.111/jspui	2018-06-12 15:51:01.496	0
671	OAI	http://10.130.9.111/jspui	2018-06-12 15:54:55.512	0
673	REST	http://10.130.9.111/jspui	2018-06-12 15:55:43.123	0
674	OAI	http://10.130.9.111/jspui	2018-06-12 16:03:33.123	0
675	JSPUI	http://10.130.9.111/jspui	2018-06-12 16:04:05.28	1
676	REST	http://10.130.9.111/jspui	2018-06-12 16:04:26.498	0
677	OAI	http://10.130.9.111/jspui	2018-06-12 16:14:59.706	0
678	JSPUI	http://10.130.9.111/jspui	2018-06-12 16:15:26.828	1
679	OAI	http://10.130.9.111/jspui	2018-06-12 16:17:57.717	0
680	OAI	http://10.130.9.111/jspui	2018-06-12 16:20:28.696	0
681	OAI	http://10.130.9.111/jspui	2018-06-12 16:22:48.45	0
682	JSPUI	http://10.130.9.111/jspui	2018-06-12 16:23:16.521	1
683	REST	http://10.130.9.111/jspui	2018-06-12 16:23:34.783	0
684	OAI	http://10.130.9.111/jspui	2018-06-12 16:28:04.865	0
685	JSPUI	http://10.130.9.111/jspui	2018-06-12 16:28:35.945	1
686	REST	http://10.130.9.111/jspui	2018-06-12 16:28:55.118	0
687	OAI	http://10.130.9.111/jspui	2018-06-12 16:41:18.092	0
712	JSPUI	http://10.130.9.111/jspui	2018-06-13 14:30:02.625	1
690	OAI	http://10.130.9.111/jspui	2018-06-13 10:02:00.195	0
691	JSPUI	http://10.130.9.111/jspui	2018-06-13 10:02:33.87	1
692	REST	http://10.130.9.111/jspui	2018-06-13 10:02:58.025	0
693	OAI	http://10.130.9.111/jspui	2018-06-13 10:29:35.755	0
695	REST	http://10.130.9.111/jspui	2018-06-13 10:30:30.456	0
696	OAI	http://10.130.9.111/jspui	2018-06-13 10:43:06.887	0
697	JSPUI	http://10.130.9.111/jspui	2018-06-13 10:43:39.942	1
698	REST	http://10.130.9.111/jspui	2018-06-13 10:43:58.482	0
699	OAI	http://10.130.9.111/jspui	2018-06-13 10:50:23.81	0
700	JSPUI	http://10.130.9.111/jspui	2018-06-13 10:51:17.482	1
701	REST	http://10.130.9.111/jspui	2018-06-13 10:51:35.47	0
702	OAI	http://10.130.9.111/jspui	2018-06-13 10:57:58.398	0
703	JSPUI	http://10.130.9.111/jspui	2018-06-13 10:58:30.465	1
704	REST	http://10.130.9.111/jspui	2018-06-13 10:58:52.081	0
705	OAI	http://10.130.9.111/jspui	2018-06-13 11:08:41.141	0
707	REST	http://10.130.9.111/jspui	2018-06-13 11:09:39.685	0
708	OAI	http://10.130.9.111/jspui	2018-06-13 11:22:25.646	0
709	JSPUI	http://10.130.9.111/jspui	2018-06-13 11:22:58.342	1
710	REST	http://10.130.9.111/jspui	2018-06-13 11:23:35.665	0
711	OAI	http://10.130.9.111/jspui	2018-06-13 14:29:28.862	0
713	REST	http://10.130.9.111/jspui	2018-06-13 14:30:35.104	0
714	OAI	http://10.130.9.111/jspui	2018-06-13 14:49:30.581	0
715	JSPUI	http://10.130.9.111/jspui	2018-06-13 14:50:01.722	1
716	OAI	http://10.130.9.111/jspui	2018-06-13 14:52:37.037	0
717	OAI	http://10.130.9.111/jspui	2018-06-13 14:55:28.575	0
718	OAI	http://10.130.9.111/jspui	2018-06-13 15:00:46.438	0
719	JSPUI	http://10.130.9.111/jspui	2018-06-13 15:01:16.156	1
720	REST	http://10.130.9.111/jspui	2018-06-13 15:01:34.256	0
721	OAI	http://10.130.9.111/jspui	2018-06-13 15:19:25.799	0
722	JSPUI	http://10.130.9.111/jspui	2018-06-13 15:19:54.787	1
723	OAI	http://10.130.9.111/jspui	2018-06-13 15:24:57.994	0
724	JSPUI	http://10.130.9.111/jspui	2018-06-13 15:25:34.352	1
725	REST	http://10.130.9.111/jspui	2018-06-13 15:25:53.452	0
726	OAI	http://10.130.9.111/jspui	2018-06-13 15:33:55.279	0
786	OAI	http://10.130.9.111/jspui	2018-06-14 15:25:00.711	0
728	REST	http://10.130.9.111/jspui	2018-06-13 15:34:44.74	0
729	OAI	http://10.130.9.111/jspui	2018-06-13 16:18:36.92	0
730	JSPUI	http://10.130.9.111/jspui	2018-06-13 16:19:05.65	1
731	REST	http://10.130.9.111/jspui	2018-06-13 16:19:24.303	0
732	OAI	http://10.130.9.111/jspui	2018-06-13 16:28:22.096	0
733	JSPUI	http://10.130.9.111/jspui	2018-06-13 16:29:08.512	1
734	REST	http://10.130.9.111/jspui	2018-06-13 16:29:28.448	0
735	OAI	http://10.130.9.111/jspui	2018-06-13 16:37:20.19	0
736	JSPUI	http://10.130.9.111/jspui	2018-06-13 16:37:49.684	1
737	REST	http://10.130.9.111/jspui	2018-06-13 16:38:06.613	0
738	OAI	http://10.130.9.111/jspui	2018-06-13 16:44:26.493	0
739	JSPUI	http://10.130.9.111/jspui	2018-06-13 16:45:00.916	1
740	REST	http://10.130.9.111/jspui	2018-06-13 16:45:20.368	0
741	OAI	http://10.130.9.111/jspui	2018-06-13 19:02:32.166	0
742	JSPUI	http://10.130.9.111/jspui	2018-06-13 19:03:05.635	1
743	REST	http://10.130.9.111/jspui	2018-06-13 19:04:02.315	0
744	OAI	http://10.130.9.111/jspui	2018-06-14 10:03:32.584	0
745	JSPUI	http://10.130.9.111/jspui	2018-06-14 10:04:05.588	1
746	REST	http://10.130.9.111/jspui	2018-06-14 10:04:26.393	0
747	OAI	http://10.130.9.111/jspui	2018-06-14 10:54:47.957	0
749	REST	http://10.130.9.111/jspui	2018-06-14 10:55:39.174	0
750	OAI	http://10.130.9.111/jspui	2018-06-14 11:06:39.935	0
751	JSPUI	http://10.130.9.111/jspui	2018-06-14 11:07:10.827	1
752	REST	http://10.130.9.111/jspui	2018-06-14 11:07:30.732	0
753	OAI	http://10.130.9.111/jspui	2018-06-14 11:18:40.106	0
754	JSPUI	http://10.130.9.111/jspui	2018-06-14 11:19:23.052	1
755	REST	http://10.130.9.111/jspui	2018-06-14 11:19:41.876	0
756	OAI	http://10.130.9.111/jspui	2018-06-14 11:36:39.734	0
757	JSPUI	http://10.130.9.111/jspui	2018-06-14 11:37:09.53	1
758	REST	http://10.130.9.111/jspui	2018-06-14 11:37:32.438	0
759	OAI	http://10.130.9.111/jspui	2018-06-14 11:52:38.257	0
760	JSPUI	http://10.130.9.111/jspui	2018-06-14 11:53:26.016	1
761	REST	http://10.130.9.111/jspui	2018-06-14 11:53:49.82	0
762	OAI	http://10.130.9.111/jspui	2018-06-14 12:02:58.156	0
787	JSPUI	http://10.130.9.111/jspui	2018-06-14 15:25:36.289	1
764	REST	http://10.130.9.111/jspui	2018-06-14 12:04:00.043	0
765	OAI	http://10.130.9.111/jspui	2018-06-14 12:16:28.879	0
767	REST	http://10.130.9.111/jspui	2018-06-14 12:17:27.14	0
768	OAI	http://10.130.9.111/jspui	2018-06-14 12:26:49.458	0
769	JSPUI	http://10.130.9.111/jspui	2018-06-14 12:27:22.98	1
770	REST	http://10.130.9.111/jspui	2018-06-14 12:27:41.379	0
771	OAI	http://10.130.9.111/jspui	2018-06-14 13:51:17.546	0
772	JSPUI	http://10.130.9.111/jspui	2018-06-14 13:51:51.039	1
773	REST	http://10.130.9.111/jspui	2018-06-14 13:52:20.706	0
774	OAI	http://10.130.9.111/jspui	2018-06-14 13:58:16.311	0
775	JSPUI	http://10.130.9.111/jspui	2018-06-14 13:59:12.718	1
776	REST	http://10.130.9.111/jspui	2018-06-14 13:59:31.275	0
777	OAI	http://10.130.9.111/jspui	2018-06-14 14:10:06.777	0
778	JSPUI	http://10.130.9.111/jspui	2018-06-14 14:10:47.261	1
779	REST	http://10.130.9.111/jspui	2018-06-14 14:11:15.268	0
780	OAI	http://10.130.9.111/jspui	2018-06-14 14:22:34.543	0
781	JSPUI	http://10.130.9.111/jspui	2018-06-14 14:23:00.433	1
782	REST	http://10.130.9.111/jspui	2018-06-14 14:23:17.054	0
783	OAI	http://10.130.9.111/jspui	2018-06-14 15:18:11.952	0
784	JSPUI	http://10.130.9.111/jspui	2018-06-14 15:18:42.275	1
785	REST	http://10.130.9.111/jspui	2018-06-14 15:19:02.759	0
788	REST	http://10.130.9.111/jspui	2018-06-14 15:25:57.572	0
789	OAI	http://10.130.9.111/jspui	2018-06-14 15:33:19.706	0
790	JSPUI	http://10.130.9.111/jspui	2018-06-14 15:33:47.629	1
791	REST	http://10.130.9.111/jspui	2018-06-14 15:34:05.886	0
792	OAI	http://10.130.9.111/jspui	2018-06-14 15:43:30.344	0
793	JSPUI	http://10.130.9.111/jspui	2018-06-14 15:44:00.987	1
794	REST	http://10.130.9.111/jspui	2018-06-14 15:44:19.56	0
795	OAI	http://10.130.9.111/jspui	2018-06-14 16:17:25.32	0
796	JSPUI	http://10.130.9.111/jspui	2018-06-14 16:17:56.331	1
797	REST	http://10.130.9.111/jspui	2018-06-14 16:18:13.621	0
798	OAI	http://10.130.9.111/jspui	2018-06-14 16:28:15.939	0
799	JSPUI	http://10.130.9.111/jspui	2018-06-14 16:28:47.322	1
800	REST	http://10.130.9.111/jspui	2018-06-14 16:29:17.762	0
801	OAI	http://10.130.9.111/jspui	2018-06-14 21:43:42.823	0
802	JSPUI	http://10.130.9.111/jspui	2018-06-14 21:44:20.709	1
803	REST	http://10.130.9.111/jspui	2018-06-14 21:44:53.463	0
804	OAI	http://10.130.9.111/jspui	2018-06-15 10:15:58.04	0
805	JSPUI	http://10.130.9.111/jspui	2018-06-15 10:16:33.824	1
806	REST	http://10.130.9.111/jspui	2018-06-15 10:16:56.035	0
807	OAI	http://10.130.9.111/jspui	2018-06-15 10:41:25.005	0
808	JSPUI	http://10.130.9.111/jspui	2018-06-15 10:41:55.552	1
809	REST	http://10.130.9.111/jspui	2018-06-15 10:42:18.799	0
810	OAI	http://10.130.9.111/jspui	2018-06-15 10:54:03.609	0
811	JSPUI	http://10.130.9.111/jspui	2018-06-15 10:54:37.18	1
812	REST	http://10.130.9.111/jspui	2018-06-15 10:54:59.662	0
813	OAI	http://10.130.9.111/jspui	2018-06-15 11:02:49.072	0
816	OAI	http://10.130.9.111/jspui	2018-06-15 11:47:35.51	0
815	REST	http://10.130.9.111/jspui	2018-06-15 11:03:47.061	0
817	JSPUI	http://10.130.9.111/jspui	2018-06-15 11:48:06.999	1
818	OAI	http://10.130.9.111/jspui	2018-06-15 11:53:42.075	0
819	JSPUI	http://10.130.9.111/jspui	2018-06-15 11:54:14.399	1
820	REST	http://10.130.9.111/jspui	2018-06-15 11:54:36.569	0
821	OAI	http://10.130.9.111/jspui	2018-06-15 12:04:19.835	0
822	JSPUI	http://10.130.9.111/jspui	2018-06-15 12:05:14.828	1
823	REST	http://10.130.9.111/jspui	2018-06-15 12:05:48.727	0
824	OAI	http://10.130.9.111/jspui	2018-06-15 12:20:11.646	0
825	JSPUI	http://10.130.9.111/jspui	2018-06-15 12:20:45.277	1
826	REST	http://10.130.9.111/jspui	2018-06-15 12:21:08.116	0
827	OAI	http://10.130.9.111/jspui	2018-06-15 12:29:03.974	0
828	JSPUI	http://10.130.9.111/jspui	2018-06-15 12:29:43.54	1
829	REST	http://10.130.9.111/jspui	2018-06-15 12:30:06.173	0
830	OAI	http://10.130.9.111/jspui	2018-06-15 14:08:58.612	0
831	JSPUI	http://10.130.9.111/jspui	2018-06-15 14:09:42.277	1
832	REST	http://10.130.9.111/jspui	2018-06-15 14:10:04.346	0
833	OAI	http://10.130.9.111/jspui	2018-06-15 14:33:08.015	0
834	JSPUI	http://10.130.9.111/jspui	2018-06-15 14:33:38.762	1
835	REST	http://10.130.9.111/jspui	2018-06-15 14:33:57.271	0
836	OAI	http://10.130.9.111/jspui	2018-06-15 15:12:21.264	0
837	JSPUI	http://10.130.9.111/jspui	2018-06-15 15:12:54.36	1
838	REST	http://10.130.9.111/jspui	2018-06-15 15:13:14.525	0
839	OAI	http://10.130.9.111/jspui	2018-06-15 17:06:33.728	0
840	JSPUI	http://10.130.9.111/jspui	2018-06-15 17:07:09.195	1
841	REST	http://10.130.9.111/jspui	2018-06-15 17:08:02.32	0
842	OAI	http://10.130.9.111/jspui	2018-06-15 22:46:26.898	0
843	JSPUI	http://10.130.9.111/jspui	2018-06-15 22:47:48.908	1
844	REST	http://10.130.9.111/jspui	2018-06-15 22:48:18.447	0
845	OAI	http://10.130.9.111/jspui	2018-06-16 10:38:36.318	0
846	JSPUI	http://10.130.9.111/jspui	2018-06-16 10:39:12.605	1
847	REST	http://10.130.9.111/jspui	2018-06-16 10:39:35.92	0
848	OAI	http://10.130.9.111/jspui	2018-06-16 12:04:43.506	0
883	OAI	http://10.130.9.111/jspui	2018-06-18 11:45:30.394	0
850	REST	http://10.130.9.111/jspui	2018-06-16 12:05:49.867	0
851	OAI	http://10.130.9.111/jspui	2018-06-16 12:11:14.107	0
852	JSPUI	http://10.130.9.111/jspui	2018-06-16 12:11:53.507	1
853	REST	http://10.130.9.111/jspui	2018-06-16 12:12:18.801	0
854	OAI	http://10.130.9.111/jspui	2018-06-16 12:19:59.383	0
855	JSPUI	http://10.130.9.111/jspui	2018-06-16 12:20:39.116	1
856	REST	http://10.130.9.111/jspui	2018-06-16 12:21:12.281	0
857	OAI	http://10.130.9.111/jspui	2018-06-16 12:32:59.83	0
858	JSPUI	http://10.130.9.111/jspui	2018-06-16 12:33:41.922	1
859	REST	http://10.130.9.111/jspui	2018-06-16 12:34:07.529	0
860	OAI	http://10.130.9.111/jspui	2018-06-16 12:57:33.255	0
861	JSPUI	http://10.130.9.111/jspui	2018-06-16 12:58:11.134	1
862	REST	http://10.130.9.111/jspui	2018-06-16 12:58:38.125	0
863	OAI	http://10.130.9.111/jspui	2018-06-16 14:02:02.671	0
864	JSPUI	http://10.130.9.111/jspui	2018-06-16 14:02:47.208	1
865	REST	http://10.130.9.111/jspui	2018-06-16 14:03:22.826	0
866	OAI	http://10.130.9.111/jspui	2018-06-16 20:19:33.024	0
867	JSPUI	http://10.130.9.111/jspui	2018-06-16 20:20:44.447	1
868	REST	http://10.130.9.111/jspui	2018-06-16 20:21:11.034	0
869	OAI	http://10.130.9.111/jspui	2018-06-16 22:43:09.351	0
871	REST	http://10.130.9.111/jspui	2018-06-16 22:44:54.494	0
872	OAI	http://10.130.9.111/jspui	2018-06-17 11:19:56.578	0
873	JSPUI	http://10.130.9.111/jspui	2018-06-17 11:20:45.523	1
874	REST	http://10.130.9.111/jspui	2018-06-17 11:21:15.938	0
875	OAI	http://10.130.9.111/jspui	2018-06-18 10:08:10.532	0
876	JSPUI	http://10.130.9.111/jspui	2018-06-18 10:08:43.906	1
877	REST	http://10.130.9.111/jspui	2018-06-18 10:09:15.427	0
878	OAI	http://10.130.9.111/jspui	2018-06-18 11:19:29.543	0
879	JSPUI	http://10.130.9.111/jspui	2018-06-18 11:20:05.724	1
880	REST	http://10.130.9.111/jspui	2018-06-18 11:20:30.239	0
881	OAI	http://10.130.9.111/jspui	2018-06-18 11:35:06.72	0
882	REST	http://10.130.9.111/jspui	2018-06-18 11:36:06.625	0
884	JSPUI	http://10.130.9.111/jspui	2018-06-18 11:46:11.391	1
885	REST	http://10.130.9.111/jspui	2018-06-18 11:46:38.084	0
886	OAI	http://10.130.9.111/jspui	2018-06-18 11:54:25.649	0
900	REST	http://10.130.9.111/jspui	2018-06-19 10:28:13.124	0
888	REST	http://10.130.9.111/jspui	2018-06-18 11:55:31.967	0
889	OAI	http://10.130.9.111/jspui	2018-06-18 12:11:28.39	0
890	JSPUI	http://10.130.9.111/jspui	2018-06-18 12:11:59.152	1
891	REST	http://10.130.9.111/jspui	2018-06-18 12:12:18.993	0
892	OAI	http://10.130.9.111/jspui	2018-06-18 13:45:14.86	0
893	JSPUI	http://10.130.9.111/jspui	2018-06-18 13:45:48.472	1
894	REST	http://10.130.9.111/jspui	2018-06-18 13:46:10.622	0
895	OAI	http://10.130.9.111/jspui	2018-06-18 21:28:27.642	0
896	JSPUI	http://10.130.9.111/jspui	2018-06-18 21:29:04.959	1
897	REST	http://10.130.9.111/jspui	2018-06-18 21:29:57.139	0
898	OAI	http://10.130.9.111/jspui	2018-06-19 10:26:59.79	0
899	JSPUI	http://10.130.9.111/jspui	2018-06-19 10:27:37.971	1
901	OAI	http://10.130.9.111/jspui	2018-06-19 12:14:51.12	0
902	JSPUI	http://10.130.9.111/jspui	2018-06-19 12:15:29.563	1
903	REST	http://10.130.9.111/jspui	2018-06-19 12:15:52.935	0
904	OAI	http://10.130.9.111/jspui	2018-06-19 12:32:29.335	0
905	JSPUI	http://10.130.9.111/jspui	2018-06-19 12:33:05.508	1
906	REST	http://10.130.9.111/jspui	2018-06-19 12:33:29.105	0
907	OAI	http://10.130.9.111/jspui	2018-06-19 12:52:48.725	0
908	JSPUI	http://10.130.9.111/jspui	2018-06-19 12:53:28.721	1
909	REST	http://10.130.9.111/jspui	2018-06-19 12:53:51.393	0
910	OAI	http://10.130.9.111/jspui	2018-06-19 14:30:36.244	0
911	OAI	http://10.130.9.111/jspui	2018-06-19 14:36:30.821	0
912	JSPUI	http://10.130.9.111/jspui	2018-06-19 14:37:00.614	1
913	REST	http://10.130.9.111/jspui	2018-06-19 14:37:27.261	0
914	OAI	http://10.130.9.111/jspui	2018-06-19 14:47:11.785	0
916	REST	http://10.130.9.111/jspui	2018-06-19 14:48:18.66	0
917	OAI	http://10.130.9.111/jspui	2018-06-19 14:56:52.722	0
918	JSPUI	http://10.130.9.111/jspui	2018-06-19 14:57:30.505	1
919	REST	http://10.130.9.111/jspui	2018-06-19 14:58:01.493	0
920	OAI	http://10.130.9.111/jspui	2018-06-19 15:06:53.451	0
921	JSPUI	http://10.130.9.111/jspui	2018-06-19 15:07:28.723	1
922	REST	http://10.130.9.111/jspui	2018-06-19 15:07:52.534	0
923	OAI	http://10.130.9.111/jspui	2018-06-19 15:17:29.041	0
924	JSPUI	http://10.130.9.111/jspui	2018-06-19 15:18:06.015	1
925	REST	http://10.130.9.111/jspui	2018-06-19 15:18:31.042	0
926	OAI	http://10.130.9.111/jspui	2018-06-19 15:35:26.571	0
927	JSPUI	http://10.130.9.111/jspui	2018-06-19 15:35:54.445	1
928	REST	http://10.130.9.111/jspui	2018-06-19 15:36:22.67	0
929	OAI	http://10.130.9.111/jspui	2018-06-19 15:48:29.349	0
930	JSPUI	http://10.130.9.111/jspui	2018-06-19 15:49:29.859	1
931	REST	http://10.130.9.111/jspui	2018-06-19 15:49:49.971	0
932	OAI	http://10.130.9.111/jspui	2018-06-19 16:02:14.964	0
933	JSPUI	http://10.130.9.111/jspui	2018-06-19 16:02:45.722	1
934	REST	http://10.130.9.111/jspui	2018-06-19 16:03:02.969	0
935	OAI	http://10.130.9.111/jspui	2018-06-20 10:17:32.368	0
936	JSPUI	http://10.130.9.111/jspui	2018-06-20 10:18:10.415	1
937	REST	http://10.130.9.111/jspui	2018-06-20 10:18:43.631	0
938	OAI	http://10.130.9.111/jspui	2018-06-20 10:43:59.775	0
939	JSPUI	http://10.130.9.111/jspui	2018-06-20 10:44:35.347	1
940	REST	http://10.130.9.111/jspui	2018-06-20 10:44:58.951	0
941	OAI	http://10.130.9.111/jspui	2018-06-20 11:06:58.34	0
942	JSPUI	http://10.130.9.111/jspui	2018-06-20 11:07:30.841	1
943	REST	http://10.130.9.111/jspui	2018-06-20 11:07:52.756	0
944	OAI	http://10.130.9.111/jspui	2018-06-20 15:41:13.926	0
945	JSPUI	http://10.130.9.111/jspui	2018-06-20 15:41:51.02	1
946	REST	http://10.130.9.111/jspui	2018-06-20 15:42:16.34	0
947	OAI	http://10.130.9.111/jspui	2018-06-20 15:53:05.291	0
948	JSPUI	http://10.130.9.111/jspui	2018-06-20 15:53:43.078	1
949	REST	http://10.130.9.111/jspui	2018-06-20 15:54:09.72	0
950	OAI	http://10.130.9.111/jspui	2018-06-20 16:04:51.974	0
978	JSPUI	http://10.130.9.111/jspui	2018-06-20 20:14:16.836	1
952	REST	http://10.130.9.111/jspui	2018-06-20 16:05:46.608	0
953	OAI	http://10.130.9.111/jspui	2018-06-20 16:16:01.68	0
955	REST	http://10.130.9.111/jspui	2018-06-20 16:16:54.436	0
956	OAI	http://10.130.9.111/jspui	2018-06-20 16:51:37.251	0
957	JSPUI	http://10.130.9.111/jspui	2018-06-20 16:52:10.853	1
958	REST	http://10.130.9.111/jspui	2018-06-20 16:52:34.186	0
959	OAI	http://10.130.9.111/jspui	2018-06-20 17:00:39.228	0
960	JSPUI	http://10.130.9.111/jspui	2018-06-20 17:01:15.41	1
961	REST	http://10.130.9.111/jspui	2018-06-20 17:01:40.219	0
962	OAI	http://10.130.9.111/jspui	2018-06-20 17:10:15.352	0
963	JSPUI	http://10.130.9.111/jspui	2018-06-20 17:11:02.379	1
964	REST	http://10.130.9.111/jspui	2018-06-20 17:11:31.416	0
965	OAI	http://10.130.9.111/jspui	2018-06-20 17:18:19.86	0
966	JSPUI	http://10.130.9.111/jspui	2018-06-20 17:18:58.199	1
967	REST	http://10.130.9.111/jspui	2018-06-20 17:19:23.786	0
968	OAI	http://10.130.9.111/jspui	2018-06-20 19:33:03.41	0
969	JSPUI	http://10.130.9.111/jspui	2018-06-20 19:33:37.896	1
970	REST	http://10.130.9.111/jspui	2018-06-20 19:34:01.83	0
971	OAI	http://10.130.9.111/jspui	2018-06-20 19:52:04.061	0
979	REST	http://10.130.9.111/jspui	2018-06-20 20:14:42.275	0
973	REST	http://10.130.9.111/jspui	2018-06-20 19:53:27.702	0
974	OAI	http://10.130.9.111/jspui	2018-06-20 20:05:42.587	0
975	JSPUI	http://10.130.9.111/jspui	2018-06-20 20:06:16.356	1
976	REST	http://10.130.9.111/jspui	2018-06-20 20:06:35.987	0
977	OAI	http://10.130.9.111/jspui	2018-06-20 20:13:39.919	0
980	OAI	http://10.130.9.111/jspui	2018-06-20 20:28:59.231	0
981	JSPUI	http://10.130.9.111/jspui	2018-06-20 20:29:28.348	1
982	REST	http://10.130.9.111/jspui	2018-06-20 20:29:51.009	0
1013	OAI	http://10.130.9.111/jspui	2018-06-20 20:33:06.601	0
1026	JSPUI	http://10.130.9.111/jspui	2018-06-20 22:12:07.381	1
1015	REST	http://10.130.9.111/jspui	2018-06-20 20:34:51.671	0
1016	OAI	http://10.130.9.111/jspui	2018-06-20 20:49:27.237	0
1017	JSPUI	http://10.130.9.111/jspui	2018-06-20 20:50:06.555	1
1018	REST	http://10.130.9.111/jspui	2018-06-20 20:50:31.744	0
1019	OAI	http://10.130.9.111/jspui	2018-06-20 21:37:36.981	0
1020	JSPUI	http://10.130.9.111/jspui	2018-06-20 21:38:23.969	1
1021	REST	http://10.130.9.111/jspui	2018-06-20 21:38:52.444	0
1022	OAI	http://10.130.9.111/jspui	2018-06-20 21:53:26.5	0
1024	REST	http://10.130.9.111/jspui	2018-06-20 21:54:21.152	0
1025	OAI	http://10.130.9.111/jspui	2018-06-20 22:11:32.773	0
1027	REST	http://10.130.9.111/jspui	2018-06-20 22:12:28.962	0
1028	OAI	http://10.130.9.111/jspui	2018-06-20 22:20:13.322	0
1029	JSPUI	http://10.130.9.111/jspui	2018-06-20 22:20:53.387	1
1030	REST	http://10.130.9.111/jspui	2018-06-20 22:21:16.425	0
1031	OAI	http://10.130.9.111/jspui	2018-06-20 22:46:14.604	0
1032	JSPUI	http://10.130.9.111/jspui	2018-06-20 22:47:06.043	1
1033	REST	http://10.130.9.111/jspui	2018-06-20 22:47:38.68	0
1034	OAI	http://10.130.9.111/jspui	2018-06-20 23:05:37.102	0
1035	JSPUI	http://10.130.9.111/jspui	2018-06-20 23:06:15.904	1
1036	REST	http://10.130.9.111/jspui	2018-06-20 23:06:39.606	0
1037	OAI	http://10.130.9.111/jspui	2018-06-20 23:14:04.956	0
1038	JSPUI	http://10.130.9.111/jspui	2018-06-20 23:14:44.836	1
1039	REST	http://10.130.9.111/jspui	2018-06-20 23:15:09.944	0
1040	OAI	http://10.130.9.111/jspui	2018-06-21 10:30:25.706	0
1041	JSPUI	http://10.130.9.111/jspui	2018-06-21 10:31:03.363	1
1042	REST	http://10.130.9.111/jspui	2018-06-21 10:31:44.443	0
1043	OAI	http://10.130.9.111/jspui	2018-06-21 10:56:53.672	0
1044	JSPUI	http://10.130.9.111/jspui	2018-06-21 10:57:27.461	1
1045	REST	http://10.130.9.111/jspui	2018-06-21 10:57:48.073	0
1046	OAI	http://10.130.9.111/jspui	2018-06-21 11:29:02.091	0
1105	REST	http://10.130.9.111/jspui	2018-06-21 15:34:52.201	0
1048	REST	http://10.130.9.111/jspui	2018-06-21 11:29:57.684	0
1049	OAI	http://10.130.9.111/jspui	2018-06-21 11:44:34.499	0
1050	JSPUI	http://10.130.9.111/jspui	2018-06-21 11:45:03.32	1
1051	REST	http://10.130.9.111/jspui	2018-06-21 11:45:22.28	0
1052	OAI	http://10.130.9.111/jspui	2018-06-21 11:52:25.409	0
1053	JSPUI	http://10.130.9.111/jspui	2018-06-21 11:52:57.255	1
1054	REST	http://10.130.9.111/jspui	2018-06-21 11:53:16.946	0
1055	OAI	http://10.130.9.111/jspui	2018-06-21 12:00:13.516	0
1056	JSPUI	http://10.130.9.111/jspui	2018-06-21 12:00:45.851	1
1057	REST	http://10.130.9.111/jspui	2018-06-21 12:01:08.093	0
1058	OAI	http://10.130.9.111/jspui	2018-06-21 12:08:16.03	0
1059	JSPUI	http://10.130.9.111/jspui	2018-06-21 12:08:45.243	1
1060	REST	http://10.130.9.111/jspui	2018-06-21 12:09:04.154	0
1061	OAI	http://10.130.9.111/jspui	2018-06-21 12:21:50.433	0
1062	JSPUI	http://10.130.9.111/jspui	2018-06-21 12:22:22.734	1
1063	REST	http://10.130.9.111/jspui	2018-06-21 12:22:43.576	0
1064	OAI	http://10.130.9.111/jspui	2018-06-21 12:29:54.775	0
1065	JSPUI	http://10.130.9.111/jspui	2018-06-21 12:30:25.437	1
1066	REST	http://10.130.9.111/jspui	2018-06-21 12:30:44.468	0
1067	OAI	http://10.130.9.111/jspui	2018-06-21 12:36:30.969	0
1068	JSPUI	http://10.130.9.111/jspui	2018-06-21 12:37:00.968	1
1069	REST	http://10.130.9.111/jspui	2018-06-21 12:37:19.46	0
1070	OAI	http://10.130.9.111/jspui	2018-06-21 12:45:28.202	0
1071	JSPUI	http://10.130.9.111/jspui	2018-06-21 12:45:57.141	1
1072	REST	http://10.130.9.111/jspui	2018-06-21 12:46:16.506	0
1073	OAI	http://10.130.9.111/jspui	2018-06-21 12:53:55.426	0
1075	REST	http://10.130.9.111/jspui	2018-06-21 12:54:43.442	0
1076	OAI	http://10.130.9.111/jspui	2018-06-21 14:08:02.3	0
1077	JSPUI	http://10.130.9.111/jspui	2018-06-21 14:08:45.168	1
1078	REST	http://10.130.9.111/jspui	2018-06-21 14:09:12.193	0
1079	OAI	http://10.130.9.111/jspui	2018-06-21 14:17:57.427	0
1080	JSPUI	http://10.130.9.111/jspui	2018-06-21 14:18:30.566	1
1081	REST	http://10.130.9.111/jspui	2018-06-21 14:18:48.82	0
1082	OAI	http://10.130.9.111/jspui	2018-06-21 14:26:15.36	0
1083	JSPUI	http://10.130.9.111/jspui	2018-06-21 14:26:46.47	1
1084	REST	http://10.130.9.111/jspui	2018-06-21 14:27:04.244	0
1085	OAI	http://10.130.9.111/jspui	2018-06-21 14:33:25.741	0
1086	JSPUI	http://10.130.9.111/jspui	2018-06-21 14:34:02.384	1
1087	REST	http://10.130.9.111/jspui	2018-06-21 14:34:23.122	0
1088	OAI	http://10.130.9.111/jspui	2018-06-21 14:42:07.829	0
1089	JSPUI	http://10.130.9.111/jspui	2018-06-21 14:42:35.324	1
1090	REST	http://10.130.9.111/jspui	2018-06-21 14:42:52.633	0
1091	OAI	http://10.130.9.111/jspui	2018-06-21 14:49:23.787	0
1092	JSPUI	http://10.130.9.111/jspui	2018-06-21 14:49:52.093	1
1093	REST	http://10.130.9.111/jspui	2018-06-21 14:50:10.407	0
1094	OAI	http://10.130.9.111/jspui	2018-06-21 15:00:22.957	0
1106	OAI	http://10.130.9.111/jspui	2018-06-21 15:48:41.898	0
1096	REST	http://10.130.9.111/jspui	2018-06-21 15:01:06.6	0
1097	OAI	http://10.130.9.111/jspui	2018-06-21 15:09:16.63	0
1098	JSPUI	http://10.130.9.111/jspui	2018-06-21 15:09:43.911	1
1099	REST	http://10.130.9.111/jspui	2018-06-21 15:10:00.277	0
1100	OAI	http://10.130.9.111/jspui	2018-06-21 15:27:28.172	0
1101	JSPUI	http://10.130.9.111/jspui	2018-06-21 15:28:02.238	1
1102	REST	http://10.130.9.111/jspui	2018-06-21 15:28:23.592	0
1103	OAI	http://10.130.9.111/jspui	2018-06-21 15:34:01.975	0
1104	JSPUI	http://10.130.9.111/jspui	2018-06-21 15:34:33.176	1
1107	JSPUI	http://10.130.9.111/jspui	2018-06-21 15:49:15.978	1
1108	REST	http://10.130.9.111/jspui	2018-06-21 15:49:36.712	0
1109	OAI	http://10.130.9.111/jspui	2018-06-21 15:57:34.909	0
1110	JSPUI	http://10.130.9.111/jspui	2018-06-21 15:58:09.299	1
1111	REST	http://10.130.9.111/jspui	2018-06-21 15:58:27.705	0
1112	OAI	http://10.130.9.111/jspui	2018-06-21 16:11:39.978	0
1113	JSPUI	http://10.130.9.111/jspui	2018-06-21 16:12:09.699	1
1114	REST	http://10.130.9.111/jspui	2018-06-21 16:12:29.084	0
1115	OAI	http://10.130.9.111/jspui	2018-06-21 16:19:30.225	0
1116	JSPUI	http://10.130.9.111/jspui	2018-06-21 16:19:59.757	1
1117	REST	http://10.130.9.111/jspui	2018-06-21 16:20:17.848	0
1118	OAI	http://10.130.9.111/jspui	2018-06-21 16:47:19.275	0
1119	JSPUI	http://10.130.9.111/jspui	2018-06-21 16:47:51.082	1
1120	REST	http://10.130.9.111/jspui	2018-06-21 16:48:13.594	0
1121	OAI	http://10.130.9.111/jspui	2018-06-21 16:54:41.939	0
1130	OAI	http://10.130.9.111/jspui	2018-06-21 19:22:03.329	0
1123	REST	http://10.130.9.111/jspui	2018-06-21 16:55:38.565	0
1124	OAI	http://10.130.9.111/jspui	2018-06-21 18:00:20.56	0
1125	JSPUI	http://10.130.9.111/jspui	2018-06-21 18:00:58.581	1
1126	REST	http://10.130.9.111/jspui	2018-06-21 18:01:30.478	0
1127	OAI	http://10.130.9.111/jspui	2018-06-21 19:08:25.297	0
1129	REST	http://10.130.9.111/jspui	2018-06-21 19:09:54.912	0
1131	JSPUI	http://10.130.9.111/jspui	2018-06-21 19:22:52.254	1
1132	REST	http://10.130.9.111/jspui	2018-06-21 19:23:19.001	0
1133	OAI	http://10.130.9.111/jspui	2018-06-21 19:35:20.35	0
1136	OAI	http://10.130.9.111/jspui	2018-06-21 19:51:23.881	0
1135	REST	http://10.130.9.111/jspui	2018-06-21 19:36:26.474	0
1137	JSPUI	http://10.130.9.111/jspui	2018-06-21 19:52:01.373	1
1138	REST	http://10.130.9.111/jspui	2018-06-21 19:52:25.053	0
1139	OAI	http://10.130.9.111/jspui	2018-06-21 20:01:50.581	0
1140	JSPUI	http://10.130.9.111/jspui	2018-06-21 20:02:23.909	1
1141	REST	http://10.130.9.111/jspui	2018-06-21 20:02:50.562	0
1142	OAI	http://10.130.9.111/jspui	2018-06-21 20:26:58.871	0
1143	JSPUI	http://10.130.9.111/jspui	2018-06-21 20:27:46.864	1
1144	REST	http://10.130.9.111/jspui	2018-06-21 20:28:09.516	0
1145	OAI	http://10.130.9.111/jspui	2018-06-22 10:35:22.503	0
1146	JSPUI	http://10.130.9.111/jspui	2018-06-22 10:36:26.147	1
1147	REST	http://10.130.9.111/jspui	2018-06-22 10:36:48.563	0
1148	OAI	http://10.130.9.111/jspui	2018-06-22 14:16:18.924	0
1149	JSPUI	http://10.130.9.111/jspui	2018-06-22 14:16:55.719	1
1150	REST	http://10.130.9.111/jspui	2018-06-22 14:17:30.105	0
1151	OAI	http://10.130.9.111/jspui	2018-06-22 14:24:54.409	0
1152	JSPUI	http://10.130.9.111/jspui	2018-06-22 14:25:33.629	1
1153	REST	http://10.130.9.111/jspui	2018-06-22 14:25:59.223	0
1154	OAI	http://10.130.9.111/jspui	2018-06-22 14:33:59.105	0
1203	JSPUI	http://10.130.9.111/jspui	2018-06-22 20:02:47.17	1
1156	REST	http://10.130.9.111/jspui	2018-06-22 14:34:51.679	0
1157	OAI	http://10.130.9.111/jspui	2018-06-22 14:42:22.636	0
1158	JSPUI	http://10.130.9.111/jspui	2018-06-22 14:42:54.21	1
1159	REST	http://10.130.9.111/jspui	2018-06-22 14:43:43.885	0
1160	OAI	http://10.130.9.111/jspui	2018-06-22 15:12:20.821	0
1162	REST	http://10.130.9.111/jspui	2018-06-22 15:13:13.636	0
1163	OAI	http://10.130.9.111/jspui	2018-06-22 15:38:34.957	0
1164	JSPUI	http://10.130.9.111/jspui	2018-06-22 15:39:02.978	1
1165	REST	http://10.130.9.111/jspui	2018-06-22 15:39:19.492	0
1166	OAI	http://10.130.9.111/jspui	2018-06-22 15:54:58.455	0
1167	JSPUI	http://10.130.9.111/jspui	2018-06-22 15:55:31.744	1
1168	REST	http://10.130.9.111/jspui	2018-06-22 15:55:52.823	0
1169	OAI	http://10.130.9.111/jspui	2018-06-22 16:08:09.797	0
1204	REST	http://10.130.9.111/jspui	2018-06-22 20:03:10.316	0
1171	REST	http://10.130.9.111/jspui	2018-06-22 16:09:07.316	0
1172	OAI	http://10.130.9.111/jspui	2018-06-22 16:18:15.252	0
1173	JSPUI	http://10.130.9.111/jspui	2018-06-22 16:18:51.311	1
1174	REST	http://10.130.9.111/jspui	2018-06-22 16:19:12.853	0
1175	OAI	http://10.130.9.111/jspui	2018-06-22 16:37:55.366	0
1176	JSPUI	http://10.130.9.111/jspui	2018-06-22 16:38:25.003	1
1177	REST	http://10.130.9.111/jspui	2018-06-22 16:38:43.248	0
1178	OAI	http://10.130.9.111/jspui	2018-06-22 16:45:02.398	0
1179	JSPUI	http://10.130.9.111/jspui	2018-06-22 16:45:31.274	1
1180	REST	http://10.130.9.111/jspui	2018-06-22 16:45:49.959	0
1181	OAI	http://10.130.9.111/jspui	2018-06-22 18:30:50.496	0
1182	JSPUI	http://10.130.9.111/jspui	2018-06-22 18:31:24.129	1
1183	REST	http://10.130.9.111/jspui	2018-06-22 18:31:57.761	0
1184	OAI	http://10.130.9.111/jspui	2018-06-22 18:50:05.012	0
1185	JSPUI	http://10.130.9.111/jspui	2018-06-22 18:50:42.04	1
1186	REST	http://10.130.9.111/jspui	2018-06-22 18:51:17.535	0
1187	OAI	http://10.130.9.111/jspui	2018-06-22 19:02:12.533	0
1189	REST	http://10.130.9.111/jspui	2018-06-22 19:03:16.456	0
1190	OAI	http://10.130.9.111/jspui	2018-06-22 19:13:28.274	0
1191	JSPUI	http://10.130.9.111/jspui	2018-06-22 19:14:04.422	1
1192	REST	http://10.130.9.111/jspui	2018-06-22 19:14:24.196	0
1193	OAI	http://10.130.9.111/jspui	2018-06-22 19:18:11.347	0
1205	OAI	http://10.130.9.111/jspui	2018-06-22 20:10:50.765	0
1195	REST	http://10.130.9.111/jspui	2018-06-22 19:19:04.209	0
1196	OAI	http://10.130.9.111/jspui	2018-06-22 19:26:22.513	0
1198	REST	http://10.130.9.111/jspui	2018-06-22 19:27:39.269	0
1199	OAI	http://10.130.9.111/jspui	2018-06-22 19:51:23.162	0
1200	JSPUI	http://10.130.9.111/jspui	2018-06-22 19:52:01.2	1
1201	REST	http://10.130.9.111/jspui	2018-06-22 19:52:27.526	0
1202	OAI	http://10.130.9.111/jspui	2018-06-22 20:02:06.666	0
1206	JSPUI	http://10.130.9.111/jspui	2018-06-22 20:11:25.117	1
1207	REST	http://10.130.9.111/jspui	2018-06-22 20:11:49.537	0
1208	OAI	http://10.130.9.111/jspui	2018-06-22 20:21:37.331	0
1209	JSPUI	http://10.130.9.111/jspui	2018-06-22 20:22:13.604	1
1210	REST	http://10.130.9.111/jspui	2018-06-22 20:22:37.461	0
1211	OAI	http://10.130.9.111/jspui	2018-06-22 20:31:14.45	0
1223	OAI	http://10.130.9.111/jspui	2018-06-22 22:14:09.778	0
1213	REST	http://10.130.9.111/jspui	2018-06-22 20:32:30.441	0
1214	OAI	http://10.130.9.111/jspui	2018-06-22 20:48:33.019	0
1215	JSPUI	http://10.130.9.111/jspui	2018-06-22 20:49:16.91	1
1216	REST	http://10.130.9.111/jspui	2018-06-22 20:49:46.804	0
1217	OAI	http://10.130.9.111/jspui	2018-06-22 21:12:58.008	0
1218	JSPUI	http://10.130.9.111/jspui	2018-06-22 21:13:43.54	1
1219	REST	http://10.130.9.111/jspui	2018-06-22 21:14:19.184	0
1220	OAI	http://10.130.9.111/jspui	2018-06-22 21:27:30.467	0
1221	JSPUI	http://10.130.9.111/jspui	2018-06-22 21:28:17.757	1
1222	REST	http://10.130.9.111/jspui	2018-06-22 21:28:45.816	0
1224	JSPUI	http://10.130.9.111/jspui	2018-06-22 22:14:54.416	1
1225	REST	http://10.130.9.111/jspui	2018-06-22 22:15:25.024	0
1226	OAI	http://10.130.9.111/jspui	2018-06-22 22:25:33.663	0
1229	OAI	http://10.130.9.111/jspui	2018-06-22 22:39:41.142	0
1228	REST	http://10.130.9.111/jspui	2018-06-22 22:26:30.293	0
1230	JSPUI	http://10.130.9.111/jspui	2018-06-22 22:40:13.931	1
1231	REST	http://10.130.9.111/jspui	2018-06-22 22:40:34.283	0
1232	OAI	http://10.130.9.111/jspui	2018-06-22 22:47:55.457	0
1233	JSPUI	http://10.130.9.111/jspui	2018-06-22 22:48:34.228	1
1234	REST	http://10.130.9.111/jspui	2018-06-22 22:48:57.466	0
1235	OAI	http://10.130.9.111/jspui	2018-06-22 22:57:17.961	0
1236	JSPUI	http://10.130.9.111/jspui	2018-06-22 22:57:56.188	1
1237	REST	http://10.130.9.111/jspui	2018-06-22 22:58:20.948	0
1238	OAI	http://10.130.9.111/jspui	2018-06-22 23:07:13.808	0
1239	JSPUI	http://10.130.9.111/jspui	2018-06-22 23:07:50.036	1
1240	REST	http://10.130.9.111/jspui	2018-06-22 23:08:12.415	0
1241	OAI	http://10.130.9.111/jspui	2018-06-22 23:16:12.139	0
1333	REST	http://10.130.9.111/jspui	2018-06-23 14:54:55.513	0
1243	REST	http://10.130.9.111/jspui	2018-06-22 23:17:12.134	0
1244	OAI	http://10.130.9.111/jspui	2018-06-22 23:29:03.52	0
1245	JSPUI	http://10.130.9.111/jspui	2018-06-22 23:29:37.021	1
1246	REST	http://10.130.9.111/jspui	2018-06-22 23:29:56.949	0
1247	OAI	http://10.130.9.111/jspui	2018-06-22 23:37:13.777	0
1248	JSPUI	http://10.130.9.111/jspui	2018-06-22 23:37:44.486	1
1249	REST	http://10.130.9.111/jspui	2018-06-22 23:38:09.05	0
1250	OAI	http://10.130.9.111/jspui	2018-06-23 10:11:52.578	0
1251	JSPUI	http://10.130.9.111/jspui	2018-06-23 10:12:28.098	1
1252	REST	http://10.130.9.111/jspui	2018-06-23 10:13:04.549	0
1253	OAI	http://10.130.9.111/jspui	2018-06-23 10:26:27.89	0
1254	JSPUI	http://10.130.9.111/jspui	2018-06-23 10:27:03.735	1
1255	REST	http://10.130.9.111/jspui	2018-06-23 10:27:23.37	0
1256	OAI	http://10.130.9.111/jspui	2018-06-23 10:33:34.504	0
1257	JSPUI	http://10.130.9.111/jspui	2018-06-23 10:34:10.851	1
1258	REST	http://10.130.9.111/jspui	2018-06-23 10:34:31.953	0
1259	OAI	http://10.130.9.111/jspui	2018-06-23 10:48:12.878	0
1260	JSPUI	http://10.130.9.111/jspui	2018-06-23 10:48:46.656	1
1261	REST	http://10.130.9.111/jspui	2018-06-23 10:49:07.547	0
1262	OAI	http://10.130.9.111/jspui	2018-06-23 10:56:51.984	0
1263	JSPUI	http://10.130.9.111/jspui	2018-06-23 10:57:27.183	1
1264	REST	http://10.130.9.111/jspui	2018-06-23 10:57:51.338	0
1265	OAI	http://10.130.9.111/jspui	2018-06-23 11:06:16.791	0
1266	JSPUI	http://10.130.9.111/jspui	2018-06-23 11:06:57.848	1
1267	REST	http://10.130.9.111/jspui	2018-06-23 11:07:22.568	0
1268	OAI	http://10.130.9.111/jspui	2018-06-23 11:13:49.231	0
1269	JSPUI	http://10.130.9.111/jspui	2018-06-23 11:14:23.504	1
1270	REST	http://10.130.9.111/jspui	2018-06-23 11:14:54.117	0
1271	OAI	http://10.130.9.111/jspui	2018-06-23 11:21:54.49	0
1273	REST	http://10.130.9.111/jspui	2018-06-23 11:22:59.418	0
1274	OAI	http://10.130.9.111/jspui	2018-06-23 11:32:07.577	0
1275	JSPUI	http://10.130.9.111/jspui	2018-06-23 11:32:34.352	1
1276	REST	http://10.130.9.111/jspui	2018-06-23 11:32:56.932	0
1277	OAI	http://10.130.9.111/jspui	2018-06-23 12:24:18.544	0
1278	JSPUI	http://10.130.9.111/jspui	2018-06-23 12:24:56.83	1
1279	REST	http://10.130.9.111/jspui	2018-06-23 12:25:27.342	0
1280	OAI	http://10.130.9.111/jspui	2018-06-23 12:37:10.593	0
1334	OAI	http://10.130.9.111/jspui	2018-06-23 15:33:35.359	0
1282	REST	http://10.130.9.111/jspui	2018-06-23 12:38:00.764	0
1283	OAI	http://10.130.9.111/jspui	2018-06-23 12:46:43.277	0
1284	JSPUI	http://10.130.9.111/jspui	2018-06-23 12:47:32.509	1
1285	REST	http://10.130.9.111/jspui	2018-06-23 12:47:51.39	0
1286	OAI	http://10.130.9.111/jspui	2018-06-23 12:55:09.05	0
1287	JSPUI	http://10.130.9.111/jspui	2018-06-23 12:55:50.362	1
1288	REST	http://10.130.9.111/jspui	2018-06-23 12:56:20.342	0
1319	OAI	http://10.130.9.111/jspui	2018-06-23 13:54:05.509	0
1320	JSPUI	http://10.130.9.111/jspui	2018-06-23 13:54:44.226	1
1321	REST	http://10.130.9.111/jspui	2018-06-23 13:55:07.592	0
1322	OAI	http://10.130.9.111/jspui	2018-06-23 14:17:23.21	0
1323	JSPUI	http://10.130.9.111/jspui	2018-06-23 14:17:53.703	1
1324	REST	http://10.130.9.111/jspui	2018-06-23 14:18:34.968	0
1325	OAI	http://10.130.9.111/jspui	2018-06-23 14:33:11.009	0
1326	JSPUI	http://10.130.9.111/jspui	2018-06-23 14:33:41.06	1
1327	REST	http://10.130.9.111/jspui	2018-06-23 14:34:06.644	0
1328	OAI	http://10.130.9.111/jspui	2018-06-23 14:46:44.118	0
1329	JSPUI	http://10.130.9.111/jspui	2018-06-23 14:47:16.476	1
1330	REST	http://10.130.9.111/jspui	2018-06-23 14:47:39.202	0
1331	OAI	http://10.130.9.111/jspui	2018-06-23 14:53:55.985	0
1351	JSPUI	http://10.130.9.111/jspui	2018-06-23 17:29:11.87	1
1336	REST	http://10.130.9.111/jspui	2018-06-23 15:34:49.822	0
1337	OAI	http://10.130.9.111/jspui	2018-06-23 15:41:05.186	0
1338	OAI	http://10.130.9.111/jspui	2018-06-23 15:49:04.203	0
1339	JSPUI	http://10.130.9.111/jspui	2018-06-23 15:49:42.418	1
1340	REST	http://10.130.9.111/jspui	2018-06-23 15:50:06.964	0
1341	OAI	http://10.130.9.111/jspui	2018-06-23 16:05:52.547	0
1342	JSPUI	http://10.130.9.111/jspui	2018-06-23 16:06:32.384	1
1343	REST	http://10.130.9.111/jspui	2018-06-23 16:06:55.317	0
1344	OAI	http://10.130.9.111/jspui	2018-06-23 16:34:51.58	0
1345	JSPUI	http://10.130.9.111/jspui	2018-06-23 16:36:03.214	1
1346	REST	http://10.130.9.111/jspui	2018-06-23 16:36:29.262	0
1347	OAI	http://10.130.9.111/jspui	2018-06-23 16:50:20.273	0
1348	JSPUI	http://10.130.9.111/jspui	2018-06-23 16:51:05.842	1
1349	REST	http://10.130.9.111/jspui	2018-06-23 16:51:36.312	0
1350	OAI	http://10.130.9.111/jspui	2018-06-23 17:28:22.907	0
1352	REST	http://10.130.9.111/jspui	2018-06-23 17:29:40.852	0
1353	OAI	http://10.130.9.111/jspui	2018-06-23 17:38:19.948	0
1354	JSPUI	http://10.130.9.111/jspui	2018-06-23 17:38:58.303	1
1355	REST	http://10.130.9.111/jspui	2018-06-23 17:39:24.57	0
1356	OAI	http://10.130.9.111/jspui	2018-06-23 18:44:50.347	0
1357	JSPUI	http://10.130.9.111/jspui	2018-06-23 18:45:21.652	1
1358	REST	http://10.130.9.111/jspui	2018-06-23 18:45:43.815	0
1359	OAI	http://10.130.9.111/jspui	2018-06-23 18:55:17.596	0
1360	JSPUI	http://10.130.9.111/jspui	2018-06-23 18:55:56.413	1
1361	REST	http://10.130.9.111/jspui	2018-06-23 18:56:21.258	0
1362	OAI	http://10.130.9.111/jspui	2018-06-23 19:20:45.036	0
1363	JSPUI	http://10.130.9.111/jspui	2018-06-23 19:21:26.536	1
1364	REST	http://10.130.9.111/jspui	2018-06-23 19:21:55.444	0
1365	OAI	http://10.130.9.111/jspui	2018-06-23 19:58:48.705	0
1366	JSPUI	http://10.130.9.111/jspui	2018-06-23 19:59:35.298	1
1367	REST	http://10.130.9.111/jspui	2018-06-23 20:00:03.481	0
1368	OAI	http://10.130.9.111/jspui	2018-06-23 20:10:24.025	0
1369	JSPUI	http://10.130.9.111/jspui	2018-06-23 20:11:10.38	1
1370	REST	http://10.130.9.111/jspui	2018-06-23 20:11:44.504	0
1371	OAI	http://10.130.9.111/jspui	2018-06-23 23:38:10.347	0
1372	JSPUI	http://10.130.9.111/jspui	2018-06-23 23:38:52.315	1
1373	REST	http://10.130.9.111/jspui	2018-06-23 23:39:14.848	0
1374	OAI	http://10.130.9.111/jspui	2018-06-23 23:44:09.982	0
1375	OAI	http://10.130.9.111/jspui	2018-06-23 23:47:06.066	0
1377	REST	http://10.130.9.111/jspui	2018-06-23 23:48:07.514	0
1378	OAI	http://10.130.9.111/jspui	2018-06-23 23:59:59.027	0
1379	JSPUI	http://10.130.9.111/jspui	2018-06-24 00:00:42.478	1
1380	REST	http://10.130.9.111/jspui	2018-06-24 00:01:12.316	0
1381	OAI	http://10.130.9.111/jspui	2018-06-24 00:04:34.644	0
1382	JSPUI	http://10.130.9.111/jspui	2018-06-24 00:05:13.764	1
1383	REST	http://10.130.9.111/jspui	2018-06-24 00:05:40.382	0
1384	OAI	http://10.130.9.111/jspui	2018-06-24 00:14:19.622	0
1385	JSPUI	http://10.130.9.111/jspui	2018-06-24 00:14:59.791	1
1386	REST	http://10.130.9.111/jspui	2018-06-24 00:15:27.191	0
1387	OAI	http://10.130.9.111/jspui	2018-06-24 00:23:17.965	0
1388	JSPUI	http://10.130.9.111/jspui	2018-06-24 00:24:03.403	1
1389	REST	http://10.130.9.111/jspui	2018-06-24 00:24:31.7	0
1390	OAI	http://10.130.9.111/jspui	2018-06-24 09:42:09.629	0
1430	OAI	http://10.130.9.111/jspui	2018-06-24 13:07:02.044	0
1392	REST	http://10.130.9.111/jspui	2018-06-24 09:43:25.103	0
1393	OAI	http://10.130.9.111/jspui	2018-06-24 09:57:03.787	0
1394	JSPUI	http://10.130.9.111/jspui	2018-06-24 09:57:37.034	1
1395	REST	http://10.130.9.111/jspui	2018-06-24 09:57:57.273	0
1396	OAI	http://10.130.9.111/jspui	2018-06-24 10:09:13.663	0
1397	JSPUI	http://10.130.9.111/jspui	2018-06-24 10:09:42.498	1
1398	REST	http://10.130.9.111/jspui	2018-06-24 10:10:09.5	0
1399	OAI	http://10.130.9.111/jspui	2018-06-24 10:23:21.92	0
1400	JSPUI	http://10.130.9.111/jspui	2018-06-24 10:23:56.132	1
1401	REST	http://10.130.9.111/jspui	2018-06-24 10:24:18.125	0
1402	OAI	http://10.130.9.111/jspui	2018-06-24 10:28:23.415	0
1403	OAI	http://10.130.9.111/jspui	2018-06-24 10:35:48.186	0
1404	JSPUI	http://10.130.9.111/jspui	2018-06-24 10:36:29.401	1
1405	REST	http://10.130.9.111/jspui	2018-06-24 10:36:54.514	0
1406	OAI	http://10.130.9.111/jspui	2018-06-24 10:47:57.349	0
1407	JSPUI	http://10.130.9.111/jspui	2018-06-24 10:48:48.852	1
1408	REST	http://10.130.9.111/jspui	2018-06-24 10:49:17.284	0
1409	OAI	http://10.130.9.111/jspui	2018-06-24 10:57:20.092	0
1410	JSPUI	http://10.130.9.111/jspui	2018-06-24 10:58:02.355	1
1411	REST	http://10.130.9.111/jspui	2018-06-24 10:58:31.197	0
1412	OAI	http://10.130.9.111/jspui	2018-06-24 11:06:43.786	0
1413	JSPUI	http://10.130.9.111/jspui	2018-06-24 11:07:25	1
1414	REST	http://10.130.9.111/jspui	2018-06-24 11:08:01.237	0
1415	OAI	http://10.130.9.111/jspui	2018-06-24 11:20:54.218	0
1416	JSPUI	http://10.130.9.111/jspui	2018-06-24 11:21:36.488	1
1417	REST	http://10.130.9.111/jspui	2018-06-24 11:22:05.706	0
1418	OAI	http://10.130.9.111/jspui	2018-06-24 11:34:07.078	0
1420	REST	http://10.130.9.111/jspui	2018-06-24 11:35:15.335	0
1421	OAI	http://10.130.9.111/jspui	2018-06-24 12:36:24.158	0
1422	JSPUI	http://10.130.9.111/jspui	2018-06-24 12:37:08.375	1
1423	REST	http://10.130.9.111/jspui	2018-06-24 12:37:37.927	0
1424	OAI	http://10.130.9.111/jspui	2018-06-24 12:48:26.957	0
1425	JSPUI	http://10.130.9.111/jspui	2018-06-24 12:49:29.589	1
1426	REST	http://10.130.9.111/jspui	2018-06-24 12:50:06.353	0
1427	OAI	http://10.130.9.111/jspui	2018-06-24 12:57:29.808	0
1429	REST	http://10.130.9.111/jspui	2018-06-24 12:58:43.04	0
1431	JSPUI	http://10.130.9.111/jspui	2018-06-24 13:07:41.875	1
1432	REST	http://10.130.9.111/jspui	2018-06-24 13:08:07.909	0
1433	OAI	http://10.130.9.111/jspui	2018-06-24 13:36:26.344	0
1448	OAI	http://10.130.9.111/jspui	2018-06-24 14:35:08.404	0
1435	REST	http://10.130.9.111/jspui	2018-06-24 13:37:25.196	0
1436	OAI	http://10.130.9.111/jspui	2018-06-24 13:48:58.107	0
1437	JSPUI	http://10.130.9.111/jspui	2018-06-24 13:49:43.096	1
1438	REST	http://10.130.9.111/jspui	2018-06-24 13:50:12.445	0
1439	OAI	http://10.130.9.111/jspui	2018-06-24 14:02:27.125	0
1440	JSPUI	http://10.130.9.111/jspui	2018-06-24 14:03:12.88	1
1441	REST	http://10.130.9.111/jspui	2018-06-24 14:03:44.01	0
1442	OAI	http://10.130.9.111/jspui	2018-06-24 14:10:41.093	0
1444	REST	http://10.130.9.111/jspui	2018-06-24 14:11:37.323	0
1445	OAI	http://10.130.9.111/jspui	2018-06-24 14:22:15.128	0
1455	JSPUI	http://10.130.9.111/jspui	2018-06-24 15:22:15.573	1
1447	REST	http://10.130.9.111/jspui	2018-06-24 14:23:15.665	0
1449	JSPUI	http://10.130.9.111/jspui	2018-06-24 14:35:58.485	1
1450	REST	http://10.130.9.111/jspui	2018-06-24 14:36:24.969	0
1451	OAI	http://10.130.9.111/jspui	2018-06-24 14:52:45.782	0
1452	JSPUI	http://10.130.9.111/jspui	2018-06-24 14:53:35.748	1
1453	REST	http://10.130.9.111/jspui	2018-06-24 14:54:02.467	0
1454	OAI	http://10.130.9.111/jspui	2018-06-24 15:21:36.237	0
1456	REST	http://10.130.9.111/jspui	2018-06-24 15:22:42.409	0
1457	OAI	http://10.130.9.111/jspui	2018-06-24 18:27:15.224	0
1460	OAI	http://10.130.9.111/jspui	2018-06-24 19:09:32.117	0
1459	REST	http://10.130.9.111/jspui	2018-06-24 18:28:55.89	0
1461	JSPUI	http://10.130.9.111/jspui	2018-06-24 19:10:09.636	1
1462	REST	http://10.130.9.111/jspui	2018-06-24 19:10:30.852	0
1463	OAI	http://10.130.9.111/jspui	2018-06-24 19:20:32.263	0
1464	JSPUI	http://10.130.9.111/jspui	2018-06-24 19:21:09.241	1
1465	REST	http://10.130.9.111/jspui	2018-06-24 19:21:33.525	0
1466	OAI	http://10.130.9.111/jspui	2018-06-24 19:31:09.524	0
1467	JSPUI	http://10.130.9.111/jspui	2018-06-24 19:31:49.049	1
1468	REST	http://10.130.9.111/jspui	2018-06-24 19:32:16.794	0
1469	OAI	http://10.130.9.111/jspui	2018-06-24 19:44:47.728	0
1470	JSPUI	http://10.130.9.111/jspui	2018-06-24 19:45:38.825	1
1471	REST	http://10.130.9.111/jspui	2018-06-24 19:46:09.326	0
1472	OAI	http://10.130.9.111/jspui	2018-06-24 19:55:31.422	0
1530	REST	http://10.130.9.111/jspui	2018-06-25 00:18:01.597	0
1474	REST	http://10.130.9.111/jspui	2018-06-24 19:56:47.299	0
1475	OAI	http://10.130.9.111/jspui	2018-06-24 20:08:54.293	0
1476	JSPUI	http://10.130.9.111/jspui	2018-06-24 20:10:01.206	1
1477	REST	http://10.130.9.111/jspui	2018-06-24 20:10:31.258	0
1478	OAI	http://10.130.9.111/jspui	2018-06-24 20:18:34.127	0
1479	JSPUI	http://10.130.9.111/jspui	2018-06-24 20:19:18.407	1
1480	REST	http://10.130.9.111/jspui	2018-06-24 20:19:49.793	0
1481	OAI	http://10.130.9.111/jspui	2018-06-24 20:36:33.135	0
1483	REST	http://10.130.9.111/jspui	2018-06-24 20:37:28.575	0
1484	OAI	http://10.130.9.111/jspui	2018-06-24 21:15:24.752	0
1485	JSPUI	http://10.130.9.111/jspui	2018-06-24 21:16:03.678	1
1486	REST	http://10.130.9.111/jspui	2018-06-24 21:16:36.245	0
1487	OAI	http://10.130.9.111/jspui	2018-06-24 21:28:58.157	0
1488	JSPUI	http://10.130.9.111/jspui	2018-06-24 21:29:44.981	1
1489	REST	http://10.130.9.111/jspui	2018-06-24 21:30:18.639	0
1490	OAI	http://10.130.9.111/jspui	2018-06-24 21:39:30.765	0
1491	JSPUI	http://10.130.9.111/jspui	2018-06-24 21:40:11.66	1
1492	REST	http://10.130.9.111/jspui	2018-06-24 21:40:40.688	0
1493	OAI	http://10.130.9.111/jspui	2018-06-24 21:48:11.591	0
1494	JSPUI	http://10.130.9.111/jspui	2018-06-24 21:48:57.457	1
1495	REST	http://10.130.9.111/jspui	2018-06-24 21:49:28.466	0
1496	OAI	http://10.130.9.111/jspui	2018-06-24 21:59:18.542	0
1497	JSPUI	http://10.130.9.111/jspui	2018-06-24 22:00:00.498	1
1498	REST	http://10.130.9.111/jspui	2018-06-24 22:00:29.818	0
1499	OAI	http://10.130.9.111/jspui	2018-06-24 22:08:15.738	0
1500	JSPUI	http://10.130.9.111/jspui	2018-06-24 22:08:58.342	1
1501	REST	http://10.130.9.111/jspui	2018-06-24 22:09:25.676	0
1502	OAI	http://10.130.9.111/jspui	2018-06-24 22:20:33.759	0
1531	OAI	http://10.130.9.111/jspui	2018-06-25 10:24:54.217	0
1504	REST	http://10.130.9.111/jspui	2018-06-24 22:21:44.316	0
1505	OAI	http://10.130.9.111/jspui	2018-06-24 22:30:47.451	0
1506	JSPUI	http://10.130.9.111/jspui	2018-06-24 22:31:25.753	1
1507	REST	http://10.130.9.111/jspui	2018-06-24 22:31:50.626	0
1508	OAI	http://10.130.9.111/jspui	2018-06-24 22:40:58.735	0
1509	JSPUI	http://10.130.9.111/jspui	2018-06-24 22:41:38.58	1
1510	REST	http://10.130.9.111/jspui	2018-06-24 22:42:17.476	0
1511	OAI	http://10.130.9.111/jspui	2018-06-24 22:50:25.606	0
1512	JSPUI	http://10.130.9.111/jspui	2018-06-24 22:51:09.685	1
1513	REST	http://10.130.9.111/jspui	2018-06-24 22:51:38.245	0
1514	OAI	http://10.130.9.111/jspui	2018-06-24 23:12:41.901	0
1515	JSPUI	http://10.130.9.111/jspui	2018-06-24 23:13:14.402	1
1516	OAI	http://10.130.9.111/jspui	2018-06-24 23:18:47.673	0
1517	JSPUI	http://10.130.9.111/jspui	2018-06-24 23:19:35.843	1
1518	REST	http://10.130.9.111/jspui	2018-06-24 23:20:05.387	0
1519	OAI	http://10.130.9.111/jspui	2018-06-24 23:33:04.406	0
1520	JSPUI	http://10.130.9.111/jspui	2018-06-24 23:33:46.51	1
1521	REST	http://10.130.9.111/jspui	2018-06-24 23:34:14.826	0
1522	OAI	http://10.130.9.111/jspui	2018-06-24 23:45:00.728	0
1523	JSPUI	http://10.130.9.111/jspui	2018-06-24 23:45:42.698	1
1524	REST	http://10.130.9.111/jspui	2018-06-24 23:46:10.504	0
1525	OAI	http://10.130.9.111/jspui	2018-06-25 00:01:22.134	0
1526	JSPUI	http://10.130.9.111/jspui	2018-06-25 00:02:06.393	1
1527	REST	http://10.130.9.111/jspui	2018-06-25 00:02:37.397	0
1528	OAI	http://10.130.9.111/jspui	2018-06-25 00:16:44.965	0
1548	REST	http://10.130.9.111/jspui	2018-06-25 12:12:51.885	0
1532	JSPUI	http://10.130.9.111/jspui	2018-06-25 10:25:45.51	1
1533	REST	http://10.130.9.111/jspui	2018-06-25 10:26:24.053	0
1534	OAI	http://10.130.9.111/jspui	2018-06-25 10:50:23.378	0
1536	REST	http://10.130.9.111/jspui	2018-06-25 10:52:09.8	0
1537	OAI	http://10.130.9.111/jspui	2018-06-25 11:04:37.648	0
1549	OAI	http://10.130.9.111/jspui	2018-06-25 12:42:22.522	0
1539	REST	http://10.130.9.111/jspui	2018-06-25 11:05:32.189	0
1540	OAI	http://10.130.9.111/jspui	2018-06-25 11:37:31.725	0
1541	JSPUI	http://10.130.9.111/jspui	2018-06-25 11:38:04.432	1
1542	REST	http://10.130.9.111/jspui	2018-06-25 11:38:26.459	0
1543	OAI	http://10.130.9.111/jspui	2018-06-25 12:00:52.101	0
1544	JSPUI	http://10.130.9.111/jspui	2018-06-25 12:01:25.815	1
1545	REST	http://10.130.9.111/jspui	2018-06-25 12:01:47.528	0
1546	OAI	http://10.130.9.111/jspui	2018-06-25 12:11:43.204	0
1547	JSPUI	http://10.130.9.111/jspui	2018-06-25 12:12:25.567	1
1550	OAI	http://10.130.9.111/jspui	2018-06-25 15:46:03.623	0
1551	OAI	http://10.130.9.111/jspui	2018-06-25 16:03:18.481	0
1555	JSPUI	http://10.130.9.111/jspui	2018-06-25 16:31:58.123	1
1553	REST	http://10.130.9.111/jspui	2018-06-25 16:04:26.909	0
1554	OAI	http://10.130.9.111/jspui	2018-06-25 16:31:13.127	0
1556	REST	http://10.130.9.111/jspui	2018-06-25 16:32:24.464	0
1557	OAI	http://10.130.9.111/jspui	2018-06-25 16:44:08.436	0
1558	JSPUI	http://10.130.9.111/jspui	2018-06-25 16:44:54.034	1
1559	REST	http://10.130.9.111/jspui	2018-06-25 16:45:21.398	0
1560	OAI	http://10.130.9.111/jspui	2018-06-26 15:13:58.855	0
1561	JSPUI	http://10.130.9.111/jspui	2018-06-26 15:14:33.81	1
1562	REST	http://10.130.9.111/jspui	2018-06-26 15:14:57.425	0
1563	OAI	http://10.130.9.111/jspui	2018-06-26 19:34:23.832	0
1564	JSPUI	http://10.130.9.111/jspui	2018-06-26 19:35:32.853	1
1565	REST	http://10.130.9.111/jspui	2018-06-26 19:35:58.068	0
1566	OAI	http://10.130.9.111/jspui	2018-06-27 10:30:33.545	0
1568	REST	http://10.130.9.111/jspui	2018-06-27 10:31:38.032	0
1569	OAI	http://10.130.9.111/jspui	2018-06-27 11:12:44.081	0
1571	REST	http://10.130.9.111/jspui	2018-06-27 11:13:44.085	0
1572	OAI	http://10.130.9.111/jspui	2018-06-27 11:21:32.572	0
1629	OAI	http://10.130.9.111/jspui	2018-06-28 16:17:57.669	0
1574	REST	http://10.130.9.111/jspui	2018-06-27 11:22:19.113	0
1575	OAI	http://10.130.9.111/jspui	2018-06-27 11:39:50.493	0
1576	JSPUI	http://10.130.9.111/jspui	2018-06-27 11:40:31.095	1
1577	REST	http://10.130.9.111/jspui	2018-06-27 11:40:51.477	0
1578	OAI	http://10.130.9.111/jspui	2018-06-27 12:43:17.492	0
1579	OAI	http://10.130.9.111/jspui	2018-06-27 12:54:40.816	0
1580	JSPUI	http://10.130.9.111/jspui	2018-06-27 12:55:20.435	1
1581	REST	http://10.130.9.111/jspui	2018-06-27 12:55:42.652	0
1582	OAI	http://10.130.9.111/jspui	2018-06-27 14:44:01.169	0
1583	OAI	http://10.130.9.111/jspui	2018-06-27 14:45:58.718	0
1584	JSPUI	http://10.130.9.111/jspui	2018-06-27 14:46:29.029	1
1585	REST	http://10.130.9.111/jspui	2018-06-27 14:46:52.87	0
1586	OAI	http://10.130.9.111/jspui	2018-06-27 14:50:48.034	0
1587	OAI	http://10.130.9.111/jspui	2018-06-27 14:56:01.621	0
1588	JSPUI	http://10.130.9.111/jspui	2018-06-27 14:56:43.783	1
1589	REST	http://10.130.9.111/jspui	2018-06-27 14:57:21.895	0
1590	OAI	http://10.130.9.111/jspui	2018-06-27 15:14:18.282	0
1591	JSPUI	http://10.130.9.111/jspui	2018-06-27 15:14:55.921	1
1592	REST	http://10.130.9.111/jspui	2018-06-27 15:15:21.14	0
1593	OAI	http://10.130.9.111/jspui	2018-06-27 16:53:04.264	0
1594	JSPUI	http://10.130.9.111/jspui	2018-06-27 16:53:42.257	1
1595	REST	http://10.130.9.111/jspui	2018-06-27 16:54:07.75	0
1596	OAI	http://10.130.9.111/jspui	2018-06-27 17:13:13.947	0
1597	JSPUI	http://10.130.9.111/jspui	2018-06-27 17:14:27.963	1
1598	REST	http://10.130.9.111/jspui	2018-06-27 17:14:52.182	0
1599	OAI	http://10.130.9.111/jspui	2018-06-27 19:36:57.495	0
1600	JSPUI	http://10.130.9.111/jspui	2018-06-27 19:37:42.195	1
1601	REST	http://10.130.9.111/jspui	2018-06-27 19:38:08.509	0
1602	OAI	http://10.130.9.111/jspui	2018-06-27 22:29:32.2	0
1603	JSPUI	http://10.130.9.111/jspui	2018-06-27 22:30:11.931	1
1604	REST	http://10.130.9.111/jspui	2018-06-27 22:30:38.329	0
1605	OAI	http://10.130.9.111/jspui	2018-06-27 23:24:22.564	0
1606	JSPUI	http://10.130.9.111/jspui	2018-06-27 23:25:12.885	1
1607	REST	http://10.130.9.111/jspui	2018-06-27 23:25:44.105	0
1608	OAI	http://10.130.9.111/jspui	2018-06-27 23:37:10.428	0
1609	JSPUI	http://10.130.9.111/jspui	2018-06-27 23:38:00.572	1
1610	REST	http://10.130.9.111/jspui	2018-06-27 23:38:33.57	0
1611	OAI	http://10.130.9.111/jspui	2018-06-27 23:51:14.311	0
1613	REST	http://10.130.9.111/jspui	2018-06-27 23:52:34.62	0
1614	OAI	http://10.130.9.111/jspui	2018-06-28 10:10:46.289	0
1648	JSPUI	http://10.130.9.111/jspui	2018-06-29 16:07:34.956	1
1616	REST	http://10.130.9.111/jspui	2018-06-28 10:12:01.062	0
1617	OAI	http://10.130.9.111/jspui	2018-06-28 11:10:31.394	0
1618	JSPUI	http://10.130.9.111/jspui	2018-06-28 11:11:24.41	1
1619	REST	http://10.130.9.111/jspui	2018-06-28 11:11:52.636	0
1620	OAI	http://10.130.9.111/jspui	2018-06-28 11:35:08.062	0
1621	JSPUI	http://10.130.9.111/jspui	2018-06-28 11:35:41.589	1
1622	REST	http://10.130.9.111/jspui	2018-06-28 11:36:03.339	0
1623	OAI	http://10.130.9.111/jspui	2018-06-28 11:47:27.66	0
1624	JSPUI	http://10.130.9.111/jspui	2018-06-28 11:48:04.807	1
1625	REST	http://10.130.9.111/jspui	2018-06-28 11:48:30.908	0
1626	OAI	http://10.130.9.111/jspui	2018-06-28 11:57:33.213	0
1628	REST	http://10.130.9.111/jspui	2018-06-28 11:58:37.743	0
1631	REST	http://10.130.9.111/jspui	2018-06-28 16:19:35.825	0
1632	OAI	http://10.130.9.111/jspui	2018-06-29 10:38:16.937	0
1649	REST	http://10.130.9.111/jspui	2018-06-29 16:07:56.877	0
1634	REST	http://10.130.9.111/jspui	2018-06-29 10:39:27.686	0
1635	OAI	http://10.130.9.111/jspui	2018-06-29 12:34:30.629	0
1636	JSPUI	http://10.130.9.111/jspui	2018-06-29 12:35:04.578	1
1637	REST	http://10.130.9.111/jspui	2018-06-29 12:35:27.135	0
1638	OAI	http://10.130.9.111/jspui	2018-06-29 14:18:34.606	0
1639	JSPUI	http://10.130.9.111/jspui	2018-06-29 14:19:07.931	1
1640	REST	http://10.130.9.111/jspui	2018-06-29 14:19:28.619	0
1641	OAI	http://10.130.9.111/jspui	2018-06-29 15:53:42.347	0
1642	JSPUI	http://10.130.9.111/jspui	2018-06-29 15:54:10.127	1
1643	REST	http://10.130.9.111/jspui	2018-06-29 15:54:43.826	0
1644	OAI	http://10.130.9.111/jspui	2018-06-29 15:56:42.306	0
1645	JSPUI	http://10.130.9.111/jspui	2018-06-29 15:57:08.391	1
1646	REST	http://10.130.9.111/jspui	2018-06-29 15:57:24.956	0
1647	OAI	http://10.130.9.111/jspui	2018-06-29 16:07:00.884	0
1650	OAI	http://10.130.9.111/jspui	2018-06-29 16:16:58.17	0
1651	JSPUI	http://10.130.9.111/jspui	2018-06-29 16:17:40.459	1
1652	REST	http://10.130.9.111/jspui	2018-06-29 16:18:03.808	0
1653	OAI	http://10.130.9.111/jspui	2018-06-29 16:24:42.84	0
1654	JSPUI	http://10.130.9.111/jspui	2018-06-29 16:25:20.649	1
1655	REST	http://10.130.9.111/jspui	2018-06-29 16:25:43.053	0
1656	OAI	http://10.130.9.111/jspui	2018-06-29 16:34:09.968	0
1657	JSPUI	http://10.130.9.111/jspui	2018-06-29 16:34:44.661	1
1658	REST	http://10.130.9.111/jspui	2018-06-29 16:35:22.862	0
1659	OAI	http://10.130.9.111/jspui	2018-06-29 16:43:08.543	0
1660	JSPUI	http://10.130.9.111/jspui	2018-06-29 16:43:42.16	1
1661	REST	http://10.130.9.111/jspui	2018-06-29 16:44:22.844	0
1662	OAI	http://10.130.9.111/jspui	2018-06-29 18:07:17.257	0
1663	JSPUI	http://10.130.9.111/jspui	2018-06-29 18:07:52.988	1
1664	REST	http://10.130.9.111/jspui	2018-06-29 18:08:16.454	0
1665	OAI	http://10.130.9.111/jspui	2018-06-29 18:23:51.949	0
1666	JSPUI	http://10.130.9.111/jspui	2018-06-29 18:24:28.542	1
1667	REST	http://10.130.9.111/jspui	2018-06-29 18:25:13.484	0
1668	OAI	http://10.130.9.111/jspui	2018-06-29 20:06:00.418	0
1669	JSPUI	http://10.130.9.111/jspui	2018-06-29 20:06:40.187	1
1670	REST	http://10.130.9.111/jspui	2018-06-29 20:07:05.926	0
1671	OAI	http://10.130.9.111/jspui	2018-06-29 22:04:15.647	0
1672	JSPUI	http://10.130.9.111/jspui	2018-06-29 22:05:34.434	1
1673	REST	http://10.130.9.111/jspui	2018-06-29 22:06:04.244	0
1674	OAI	http://10.130.9.111/jspui	2018-06-29 23:03:03.299	0
1675	JSPUI	http://10.130.9.111/jspui	2018-06-29 23:03:50.175	1
1676	REST	http://10.130.9.111/jspui	2018-06-29 23:04:25.322	0
1677	OAI	http://10.130.9.111/jspui	2018-06-29 23:12:30.882	0
1678	JSPUI	http://10.130.9.111/jspui	2018-06-29 23:13:15.277	1
1679	REST	http://10.130.9.111/jspui	2018-06-29 23:13:41.015	0
1680	OAI	http://10.130.9.111/jspui	2018-06-29 23:21:32.595	0
1681	JSPUI	http://10.130.9.111/jspui	2018-06-29 23:22:15.643	1
1682	REST	http://10.130.9.111/jspui	2018-06-29 23:23:02.913	0
1683	OAI	http://10.130.9.111/jspui	2018-06-29 23:32:54.489	0
1684	JSPUI	http://10.130.9.111/jspui	2018-06-29 23:33:32.959	1
1685	REST	http://10.130.9.111/jspui	2018-06-29 23:33:59.804	0
1686	OAI	http://10.130.9.111/jspui	2018-06-29 23:44:26.033	0
1687	JSPUI	http://10.130.9.111/jspui	2018-06-29 23:45:08.381	1
1688	REST	http://10.130.9.111/jspui	2018-06-29 23:45:36.744	0
1689	OAI	http://10.130.9.111/jspui	2018-06-29 23:56:51.963	0
1690	JSPUI	http://10.130.9.111/jspui	2018-06-29 23:57:33.331	1
1691	REST	http://10.130.9.111/jspui	2018-06-29 23:58:02.451	0
1692	OAI	http://10.130.9.111/jspui	2018-06-30 10:45:38.04	0
1693	JSPUI	http://10.130.9.111/jspui	2018-06-30 10:46:21.451	1
1694	REST	http://10.130.9.111/jspui	2018-06-30 10:46:46.313	0
1695	OAI	http://10.130.9.111/jspui	2018-06-30 10:58:26.665	0
1776	JSPUI	http://10.130.9.111/jspui	2018-06-30 18:53:27.97	1
1697	REST	http://10.130.9.111/jspui	2018-06-30 10:59:26.836	0
1698	OAI	http://10.130.9.111/jspui	2018-06-30 11:16:25.379	0
1699	JSPUI	http://10.130.9.111/jspui	2018-06-30 11:17:20.189	1
1700	REST	http://10.130.9.111/jspui	2018-06-30 11:17:41.012	0
1701	OAI	http://10.130.9.111/jspui	2018-06-30 11:27:24.302	0
1702	JSPUI	http://10.130.9.111/jspui	2018-06-30 11:28:08.711	1
1703	REST	http://10.130.9.111/jspui	2018-06-30 11:28:32.369	0
1704	OAI	http://10.130.9.111/jspui	2018-06-30 11:38:06.062	0
1705	JSPUI	http://10.130.9.111/jspui	2018-06-30 11:38:47.628	1
1706	REST	http://10.130.9.111/jspui	2018-06-30 11:39:13.163	0
1707	OAI	http://10.130.9.111/jspui	2018-06-30 14:49:59.754	0
1708	JSPUI	http://10.130.9.111/jspui	2018-06-30 14:50:33.573	1
1709	REST	http://10.130.9.111/jspui	2018-06-30 14:50:54.92	0
1710	OAI	http://10.130.9.111/jspui	2018-06-30 15:01:02.866	0
1711	JSPUI	http://10.130.9.111/jspui	2018-06-30 15:01:47.089	1
1712	REST	http://10.130.9.111/jspui	2018-06-30 15:02:09.738	0
1713	OAI	http://10.130.9.111/jspui	2018-06-30 15:09:19.395	0
1715	REST	http://10.130.9.111/jspui	2018-06-30 15:10:16.594	0
1716	OAI	http://10.130.9.111/jspui	2018-06-30 15:20:05.956	0
1717	JSPUI	http://10.130.9.111/jspui	2018-06-30 15:20:39.772	1
1718	REST	http://10.130.9.111/jspui	2018-06-30 15:21:01.841	0
1719	OAI	http://10.130.9.111/jspui	2018-06-30 15:32:25.521	0
1730	REST	http://10.130.9.111/jspui	2018-06-30 16:33:20.473	0
1721	REST	http://10.130.9.111/jspui	2018-06-30 15:33:28.276	0
1722	OAI	http://10.130.9.111/jspui	2018-06-30 15:40:53.574	0
1723	JSPUI	http://10.130.9.111/jspui	2018-06-30 15:41:28.41	1
1724	REST	http://10.130.9.111/jspui	2018-06-30 15:41:50.532	0
1725	OAI	http://10.130.9.111/jspui	2018-06-30 15:51:17.463	0
1726	JSPUI	http://10.130.9.111/jspui	2018-06-30 15:51:50.057	1
1727	REST	http://10.130.9.111/jspui	2018-06-30 15:52:10.907	0
1728	OAI	http://10.130.9.111/jspui	2018-06-30 16:32:08.222	0
1731	OAI	http://10.130.9.111/jspui	2018-06-30 16:43:32.241	0
1733	REST	http://10.130.9.111/jspui	2018-06-30 16:45:00.401	0
1734	OAI	http://10.130.9.111/jspui	2018-06-30 17:37:47.461	0
1735	OAI	http://10.130.9.111/jspui	2018-06-30 17:39:54.294	0
1736	JSPUI	http://10.130.9.111/jspui	2018-06-30 17:40:20.493	1
1737	REST	http://10.130.9.111/jspui	2018-06-30 17:40:39.471	0
1767	OAI	http://10.130.9.111/jspui	2018-06-30 18:29:24.867	0
1768	JSPUI	http://10.130.9.111/jspui	2018-06-30 18:30:30.82	1
1769	REST	http://10.130.9.111/jspui	2018-06-30 18:30:57.82	0
1770	OAI	http://10.130.9.111/jspui	2018-06-30 18:38:19.831	0
1771	JSPUI	http://10.130.9.111/jspui	2018-06-30 18:38:48.947	1
1772	REST	http://10.130.9.111/jspui	2018-06-30 18:39:07.315	0
1773	OAI	http://10.130.9.111/jspui	2018-06-30 18:45:02.843	0
1774	JSPUI	http://10.130.9.111/jspui	2018-06-30 18:45:29.054	1
1775	OAI	http://10.130.9.111/jspui	2018-06-30 18:52:53.242	0
1777	REST	http://10.130.9.111/jspui	2018-06-30 18:53:50.131	0
1778	OAI	http://10.130.9.111/jspui	2018-06-30 19:05:12.895	0
1779	JSPUI	http://10.130.9.111/jspui	2018-06-30 19:05:48.673	1
1780	REST	http://10.130.9.111/jspui	2018-06-30 19:06:12.267	0
1781	OAI	http://10.130.9.111/jspui	2018-06-30 19:22:31.06	0
1782	OAI	http://10.130.9.111/jspui	2018-06-30 19:28:05.628	0
1783	JSPUI	http://10.130.9.111/jspui	2018-06-30 19:28:49.031	1
1784	REST	http://10.130.9.111/jspui	2018-06-30 19:29:17.18	0
1785	OAI	http://10.130.9.111/jspui	2018-06-30 19:45:12.151	0
1786	JSPUI	http://10.130.9.111/jspui	2018-06-30 19:45:58.359	1
1787	REST	http://10.130.9.111/jspui	2018-06-30 19:46:28.329	0
1788	OAI	http://10.130.9.111/jspui	2018-06-30 20:25:47.846	0
1789	JSPUI	http://10.130.9.111/jspui	2018-06-30 20:26:33.67	1
1790	REST	http://10.130.9.111/jspui	2018-06-30 20:27:03.885	0
1791	OAI	http://10.130.9.111/jspui	2018-06-30 20:41:57.78	0
1792	JSPUI	http://10.130.9.111/jspui	2018-06-30 20:42:37.42	1
1793	REST	http://10.130.9.111/jspui	2018-06-30 20:43:01.276	0
1794	OAI	http://10.130.9.111/jspui	2018-06-30 20:50:55.634	0
1795	JSPUI	http://10.130.9.111/jspui	2018-06-30 20:51:41.244	1
1796	REST	http://10.130.9.111/jspui	2018-06-30 20:52:19.118	0
1797	OAI	http://10.130.9.111/jspui	2018-06-30 21:03:42.343	0
1798	JSPUI	http://10.130.9.111/jspui	2018-06-30 21:04:34.901	1
1799	REST	http://10.130.9.111/jspui	2018-06-30 21:04:58.78	0
1800	OAI	http://10.130.9.111/jspui	2018-06-30 21:39:46.974	0
1801	JSPUI	http://10.130.9.111/jspui	2018-06-30 21:40:28.464	1
1802	REST	http://10.130.9.111/jspui	2018-06-30 21:40:54.582	0
1803	OAI	http://10.130.9.111/jspui	2018-06-30 21:52:04.056	0
1804	JSPUI	http://10.130.9.111/jspui	2018-06-30 21:52:43.266	1
1805	REST	http://10.130.9.111/jspui	2018-06-30 21:53:09.316	0
1806	OAI	http://10.130.9.111/jspui	2018-06-30 22:05:12.29	0
1807	JSPUI	http://10.130.9.111/jspui	2018-06-30 22:05:50.119	1
1808	REST	http://10.130.9.111/jspui	2018-06-30 22:06:15.445	0
1809	OAI	http://10.130.9.111/jspui	2018-06-30 22:17:20.363	0
1854	OAI	http://10.130.9.111/jspui	2018-07-01 21:57:28.905	0
1811	REST	http://10.130.9.111/jspui	2018-06-30 22:18:30.027	0
1812	OAI	http://10.130.9.111/jspui	2018-06-30 22:32:56.39	0
1814	REST	http://10.130.9.111/jspui	2018-06-30 22:33:54.938	0
1815	OAI	http://10.130.9.111/jspui	2018-06-30 22:41:42.491	0
1816	JSPUI	http://10.130.9.111/jspui	2018-06-30 22:42:21.368	1
1817	REST	http://10.130.9.111/jspui	2018-06-30 22:42:52.782	0
1818	OAI	http://10.130.9.111/jspui	2018-06-30 22:48:22.043	0
1819	JSPUI	http://10.130.9.111/jspui	2018-06-30 22:48:54.108	1
1820	REST	http://10.130.9.111/jspui	2018-06-30 22:49:14.129	0
1821	OAI	http://10.130.9.111/jspui	2018-06-30 22:57:17.221	0
1855	JSPUI	http://10.130.9.111/jspui	2018-07-01 21:58:07.536	1
1823	REST	http://10.130.9.111/jspui	2018-06-30 22:58:24.552	0
1824	OAI	http://10.130.9.111/jspui	2018-06-30 23:15:13.764	0
1826	REST	http://10.130.9.111/jspui	2018-06-30 23:16:27.14	0
1827	OAI	http://10.130.9.111/jspui	2018-07-01 13:14:05.653	0
1828	JSPUI	http://10.130.9.111/jspui	2018-07-01 13:38:59.54	1
1829	REST	http://10.130.9.111/jspui	2018-07-01 13:39:21.498	0
1830	OAI	http://10.130.9.111/jspui	2018-07-01 14:20:51.853	0
1831	JSPUI	http://10.130.9.111/jspui	2018-07-01 14:21:26.544	1
1832	REST	http://10.130.9.111/jspui	2018-07-01 14:21:48.168	0
1833	OAI	http://10.130.9.111/jspui	2018-07-01 14:41:20.733	0
1834	JSPUI	http://10.130.9.111/jspui	2018-07-01 14:42:11.091	1
1835	REST	http://10.130.9.111/jspui	2018-07-01 14:42:44.763	0
1856	REST	http://10.130.9.111/jspui	2018-07-01 21:58:33.971	0
1837	JSPUI	http://10.130.9.111/jspui	2018-07-01 15:10:25.938	1
1838	REST	http://10.130.9.111/jspui	2018-07-01 15:10:50.826	0
1839	OAI	http://10.130.9.111/jspui	2018-07-01 15:52:43.944	0
1840	JSPUI	http://10.130.9.111/jspui	2018-07-01 15:53:23.378	1
1841	REST	http://10.130.9.111/jspui	2018-07-01 15:53:49.66	0
1842	OAI	http://10.130.9.111/jspui	2018-07-01 18:03:34.325	0
1843	JSPUI	http://10.130.9.111/jspui	2018-07-01 18:04:37.115	1
1844	REST	http://10.130.9.111/jspui	2018-07-01 18:05:06.538	0
1845	OAI	http://10.130.9.111/jspui	2018-07-01 18:15:54.327	0
1846	JSPUI	http://10.130.9.111/jspui	2018-07-01 18:16:32.315	1
1847	REST	http://10.130.9.111/jspui	2018-07-01 18:16:56.068	0
1848	OAI	http://10.130.9.111/jspui	2018-07-01 19:00:15.932	0
1849	JSPUI	http://10.130.9.111/jspui	2018-07-01 19:01:07.143	1
1850	REST	http://10.130.9.111/jspui	2018-07-01 19:01:33.905	0
1851	OAI	http://10.130.9.111/jspui	2018-07-01 21:41:35.629	0
1852	JSPUI	http://10.130.9.111/jspui	2018-07-01 21:42:15.467	1
1853	REST	http://10.130.9.111/jspui	2018-07-01 21:42:40.778	0
1857	OAI	http://10.130.9.111/jspui	2018-07-01 22:22:53.43	0
1858	JSPUI	http://10.130.9.111/jspui	2018-07-01 22:23:32.906	1
1859	REST	http://10.130.9.111/jspui	2018-07-01 22:23:56.859	0
1860	OAI	http://10.130.9.111/jspui	2018-07-01 22:35:32.314	0
1861	JSPUI	http://10.130.9.111/jspui	2018-07-01 22:36:12.22	1
1862	REST	http://10.130.9.111/jspui	2018-07-01 22:36:38.391	0
1863	OAI	http://10.130.9.111/jspui	2018-07-01 22:55:26.609	0
1864	JSPUI	http://10.130.9.111/jspui	2018-07-01 22:56:05.681	1
1865	REST	http://10.130.9.111/jspui	2018-07-01 22:56:32.986	0
1866	OAI	http://10.130.9.111/jspui	2018-07-02 10:16:36.281	0
1867	JSPUI	http://10.130.9.111/jspui	2018-07-02 10:17:23.475	1
1868	REST	http://10.130.9.111/jspui	2018-07-02 10:17:46.264	0
1869	OAI	http://10.130.9.111/jspui	2018-07-02 10:52:05.697	0
1870	JSPUI	http://10.130.9.111/jspui	2018-07-02 10:52:52.008	1
1871	REST	http://10.130.9.111/jspui	2018-07-02 10:53:13.802	0
1872	OAI	http://10.130.9.111/jspui	2018-07-02 12:28:53.163	0
1873	JSPUI	http://10.130.9.111/jspui	2018-07-02 12:29:36.85	1
1874	REST	http://10.130.9.111/jspui	2018-07-02 12:30:13.138	0
1875	OAI	http://10.130.9.111/jspui	2018-07-02 12:55:34.114	0
1880	REST	http://10.130.9.111/jspui	2018-07-02 14:20:03.951	0
1877	REST	http://10.130.9.111/jspui	2018-07-02 12:56:30.202	0
1878	OAI	http://10.130.9.111/jspui	2018-07-02 14:18:36.381	0
1879	JSPUI	http://10.130.9.111/jspui	2018-07-02 14:19:40.9	1
1881	OAI	http://10.130.9.111/jspui	2018-07-02 14:26:29.218	0
1882	JSPUI	http://10.130.9.111/jspui	2018-07-02 14:27:05.683	1
1883	REST	http://10.130.9.111/jspui	2018-07-02 14:27:29.069	0
1884	OAI	http://10.130.9.111/jspui	2018-07-02 14:34:15.461	0
1885	JSPUI	http://10.130.9.111/jspui	2018-07-02 14:34:49.947	1
1886	REST	http://10.130.9.111/jspui	2018-07-02 14:35:12.74	0
1887	OAI	http://10.130.9.111/jspui	2018-07-02 14:49:15.065	0
1888	JSPUI	http://10.130.9.111/jspui	2018-07-02 14:50:16.203	1
1889	REST	http://10.130.9.111/jspui	2018-07-02 14:51:03.883	0
1890	OAI	http://10.130.9.111/jspui	2018-07-02 16:07:57.012	0
1891	JSPUI	http://10.130.9.111/jspui	2018-07-02 16:08:33.441	1
1892	REST	http://10.130.9.111/jspui	2018-07-02 16:08:56.358	0
1893	OAI	http://10.130.9.111/jspui	2018-07-02 16:24:41.234	0
1952	JSPUI	http://10.130.9.111/jspui	2018-07-05 01:06:24.649	1
1895	REST	http://10.130.9.111/jspui	2018-07-02 16:25:38.612	0
1896	OAI	http://10.130.9.111/jspui	2018-07-02 20:48:21.526	0
1897	JSPUI	http://10.130.9.111/jspui	2018-07-02 20:48:57.456	1
1898	REST	http://10.130.9.111/jspui	2018-07-02 20:49:19.515	0
1899	OAI	http://10.130.9.111/jspui	2018-07-03 10:20:50.301	0
1900	JSPUI	http://10.130.9.111/jspui	2018-07-03 10:21:54.871	1
1901	REST	http://10.130.9.111/jspui	2018-07-03 10:22:18.83	0
1902	OAI	http://10.130.9.111/jspui	2018-07-03 10:29:19.094	0
1903	OAI	http://10.130.9.111/jspui	2018-07-03 10:30:53.34	0
1904	JSPUI	http://10.130.9.111/jspui	2018-07-03 10:31:19.024	1
1905	REST	http://10.130.9.111/jspui	2018-07-03 10:31:35.636	0
1906	OAI	http://10.130.9.111/jspui	2018-07-03 10:32:52.694	0
1907	JSPUI	http://10.130.9.111/jspui	2018-07-03 10:33:19.387	1
1908	REST	http://10.130.9.111/jspui	2018-07-03 10:33:35.911	0
1909	OAI	http://10.130.9.111/jspui	2018-07-03 10:42:13.169	0
1910	JSPUI	http://10.130.9.111/jspui	2018-07-03 10:42:48.076	1
1911	REST	http://10.130.9.111/jspui	2018-07-03 10:43:11.038	0
1912	OAI	http://10.130.9.111/jspui	2018-07-03 11:03:40.357	0
1913	JSPUI	http://10.130.9.111/jspui	2018-07-03 11:04:16.098	1
1914	REST	http://10.130.9.111/jspui	2018-07-03 11:04:39.156	0
1915	OAI	http://10.130.9.111/jspui	2018-07-03 11:17:48.683	0
1916	JSPUI	http://10.130.9.111/jspui	2018-07-03 11:18:26.116	1
1917	REST	http://10.130.9.111/jspui	2018-07-03 11:18:49.706	0
1918	OAI	http://10.130.9.111/jspui	2018-07-03 12:38:30.706	0
1919	JSPUI	http://10.130.9.111/jspui	2018-07-03 12:39:18.247	1
1920	REST	http://10.130.9.111/jspui	2018-07-03 12:39:49.372	0
1921	OAI	http://10.130.9.111/jspui	2018-07-03 14:45:07.833	0
1923	REST	http://10.130.9.111/jspui	2018-07-03 14:47:24.199	0
1924	OAI	http://10.130.9.111/jspui	2018-07-03 16:11:21.986	0
1925	JSPUI	http://10.130.9.111/jspui	2018-07-03 16:11:55.365	1
1926	REST	http://10.130.9.111/jspui	2018-07-03 16:12:16.845	0
1927	OAI	http://10.130.9.111/jspui	2018-07-03 16:29:24.969	0
1928	JSPUI	http://10.130.9.111/jspui	2018-07-03 16:29:59.506	1
1929	REST	http://10.130.9.111/jspui	2018-07-03 16:30:21.882	0
1930	OAI	http://10.130.9.111/jspui	2018-07-03 17:38:17.854	0
1931	JSPUI	http://10.130.9.111/jspui	2018-07-03 17:39:04.833	1
1932	REST	http://10.130.9.111/jspui	2018-07-03 17:39:28.112	0
1933	OAI	http://10.130.9.111/jspui	2018-07-03 18:36:46.007	0
1934	JSPUI	http://10.130.9.111/jspui	2018-07-03 18:37:23.062	1
1935	REST	http://10.130.9.111/jspui	2018-07-03 18:37:47.09	0
1936	OAI	http://10.130.9.111/jspui	2018-07-04 08:33:54.628	0
1937	JSPUI	http://10.130.9.111/jspui	2018-07-04 08:35:36.152	1
1938	REST	http://10.130.9.111/jspui	2018-07-04 08:36:02.873	0
1939	OAI	http://10.130.9.111/jspui	2018-07-04 10:36:53.237	0
1940	JSPUI	http://10.130.9.111/jspui	2018-07-04 10:38:38.069	1
1941	REST	http://10.130.9.111/jspui	2018-07-04 10:39:08.749	0
1942	OAI	http://10.130.9.111/jspui	2018-07-04 14:34:11.671	0
1943	JSPUI	http://10.130.9.111/jspui	2018-07-04 14:34:46.621	1
1944	REST	http://10.130.9.111/jspui	2018-07-04 14:35:09.02	0
1945	OAI	http://10.130.9.111/jspui	2018-07-04 17:36:18.233	0
1946	JSPUI	http://10.130.9.111/jspui	2018-07-04 17:37:23.333	1
1947	REST	http://10.130.9.111/jspui	2018-07-04 17:37:47.757	0
1948	OAI	http://10.130.9.111/jspui	2018-07-04 21:08:51.299	0
1953	REST	http://10.130.9.111/jspui	2018-07-05 01:06:48.671	0
1950	REST	http://10.130.9.111/jspui	2018-07-04 21:09:48.36	0
1951	OAI	http://10.130.9.111/jspui	2018-07-05 01:05:44.533	0
1954	OAI	http://10.130.9.111/jspui	2018-07-05 07:20:23.262	0
1955	JSPUI	http://10.130.9.111/jspui	2018-07-05 07:20:57.507	1
1956	REST	http://10.130.9.111/jspui	2018-07-05 07:21:20.349	0
1957	OAI	http://10.130.9.111/jspui	2018-07-05 07:32:33.945	0
1958	JSPUI	http://10.130.9.111/jspui	2018-07-05 07:33:08.557	1
1959	REST	http://10.130.9.111/jspui	2018-07-05 07:33:30.155	0
1960	OAI	http://10.130.9.111/jspui	2018-07-05 09:34:30.386	0
1961	JSPUI	http://10.130.9.111/jspui	2018-07-05 09:35:31.974	1
1962	REST	http://10.130.9.111/jspui	2018-07-05 09:35:55.132	0
1963	OAI	http://10.130.9.111/jspui	2018-07-05 09:46:17.898	0
1964	JSPUI	http://10.130.9.111/jspui	2018-07-05 09:46:53.626	1
1965	REST	http://10.130.9.111/jspui	2018-07-05 09:47:17.172	0
1966	OAI	http://10.130.9.111/jspui	2018-07-05 09:57:36.231	0
1967	JSPUI	http://10.130.9.111/jspui	2018-07-05 09:58:10.409	1
1968	REST	http://10.130.9.111/jspui	2018-07-05 09:58:33.672	0
1969	OAI	http://10.130.9.111/jspui	2018-07-05 10:06:16.548	0
1970	JSPUI	http://10.130.9.111/jspui	2018-07-05 10:06:51.383	1
1971	REST	http://10.130.9.111/jspui	2018-07-05 10:07:14.686	0
1972	OAI	http://10.130.9.111/jspui	2018-07-05 10:18:09.268	0
1973	JSPUI	http://10.130.9.111/jspui	2018-07-05 10:18:47.759	1
1974	REST	http://10.130.9.111/jspui	2018-07-05 10:19:10.589	0
1975	OAI	http://10.130.9.111/jspui	2018-07-05 10:31:12.65	0
1981	OAI	http://10.130.9.111/jspui	2018-07-05 11:11:06.497	0
1977	REST	http://10.130.9.111/jspui	2018-07-05 10:32:00.039	0
1979	JSPUI	http://10.130.9.111/jspui	2018-07-05 10:41:00.243	1
1980	REST	http://10.130.9.111/jspui	2018-07-05 10:41:29.48	0
1984	OAI	http://10.130.9.111/jspui	2018-07-05 12:05:13.189	0
1983	REST	http://10.130.9.111/jspui	2018-07-05 11:12:39.484	0
1985	JSPUI	http://10.130.9.111/jspui	2018-07-05 12:05:46.923	1
1986	REST	http://10.130.9.111/jspui	2018-07-05 12:06:18.026	0
1987	OAI	http://10.130.9.111/jspui	2018-07-05 13:56:01.97	0
1988	JSPUI	http://10.130.9.111/jspui	2018-07-05 13:56:38.227	1
1989	REST	http://10.130.9.111/jspui	2018-07-05 13:57:02.417	0
1990	OAI	http://10.130.9.111/jspui	2018-07-05 16:38:37.595	0
1991	JSPUI	http://10.130.9.111/jspui	2018-07-05 16:39:35.721	1
1992	REST	http://10.130.9.111/jspui	2018-07-05 16:40:17.656	0
1993	OAI	http://10.130.9.111/jspui	2018-07-06 08:14:07.281	0
1994	JSPUI	http://10.130.9.111/jspui	2018-07-06 08:15:24.62	1
1995	REST	http://10.130.9.111/jspui	2018-07-06 08:15:51.643	0
1996	OAI	http://10.130.9.111/jspui	2018-07-06 21:52:01.367	0
1997	JSPUI	http://10.130.9.111/jspui	2018-07-06 21:52:36.111	1
1998	REST	http://10.130.9.111/jspui	2018-07-06 21:52:58.333	0
1999	OAI	http://10.130.9.111/jspui	2018-07-12 14:48:15.634	0
2000	JSPUI	http://10.130.9.111/jspui	2018-07-12 14:49:21.267	1
2001	REST	http://10.130.9.111/jspui	2018-07-12 14:49:44.945	0
2002	OAI	http://10.130.9.111/jspui	2018-07-15 12:55:52.605	0
2004	REST	http://10.130.9.111/jspui	2018-07-15 12:57:28.557	0
2005	OAI	http://10.130.9.111/jspui	2018-07-16 21:30:29.355	0
2007	REST	http://10.130.9.111/jspui	2018-07-16 21:32:17.914	0
2008	OAI	http://10.130.9.111/jspui	2018-07-16 22:27:00.399	0
2009	JSPUI	http://10.130.9.111/jspui	2018-07-16 22:27:50.892	1
2010	REST	http://10.130.9.111/jspui	2018-07-16 22:28:14.138	0
2011	OAI	http://10.130.9.111/jspui	2018-07-17 19:04:07.545	0
2012	JSPUI	http://10.130.9.111/jspui	2018-07-17 19:04:45.165	1
2013	REST	http://10.130.9.111/jspui	2018-07-17 19:05:16.297	0
\.


--
-- Name: webapp_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.webapp_seq', 2013, true);


--
-- Data for Name: workflowitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.workflowitem (workflow_id, state, multiple_titles, published_before, multiple_files, item_id, collection_id, owner) FROM stdin;
\.


--
-- Name: workflowitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.workflowitem_seq', 35, true);


--
-- Data for Name: workspaceitem; Type: TABLE DATA; Schema: public; Owner: dspace
--

COPY public.workspaceitem (workspace_item_id, multiple_titles, published_before, multiple_files, stage_reached, page_reached, item_id, collection_id) FROM stdin;
3	t	t	t	5	1	7d72e5b6-7704-476f-9d38-8d5f261016c7	b7b1b7e1-3a94-439e-ade7-f9ef898e272f
4	t	t	t	2	1	2c8bc593-9707-4c60-a079-792175fad7c2	9f445d1d-8fa5-47d5-8d32-e8b860e61328
5	t	t	t	5	1	e555b73c-4e0c-453a-bc10-e1509fa18348	9f445d1d-8fa5-47d5-8d32-e8b860e61328
42	t	t	t	3	1	8a1952f5-fbf7-4888-9d3c-e15c9e738991	9f445d1d-8fa5-47d5-8d32-e8b860e61328
6	t	t	t	2	1	29805781-fa7a-438a-a500-7e4be2bf776c	9f445d1d-8fa5-47d5-8d32-e8b860e61328
38	t	t	t	2	1	c60dc41d-0a57-4cb9-8023-26f096e32efb	9f445d1d-8fa5-47d5-8d32-e8b860e61328
39	t	t	t	2	1	202b3483-3fec-47ac-a4f3-3274a4049977	8c7e552a-5797-4dd1-a35b-85a265feeb3f
\.


--
-- Name: workspaceitem_seq; Type: SEQUENCE SET; Schema: public; Owner: dspace
--

SELECT pg_catalog.setval('public.workspaceitem_seq', 43, true);


--
-- Name: bitstream_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_id_unique UNIQUE (uuid);


--
-- Name: bitstream_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_pkey PRIMARY KEY (uuid);


--
-- Name: bitstream_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_uuid_key UNIQUE (uuid);


--
-- Name: bitstreamformatregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstreamformatregistry
    ADD CONSTRAINT bitstreamformatregistry_pkey PRIMARY KEY (bitstream_format_id);


--
-- Name: bitstreamformatregistry_short_description_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstreamformatregistry
    ADD CONSTRAINT bitstreamformatregistry_short_description_key UNIQUE (short_description);


--
-- Name: bundle2bitstream_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_pkey PRIMARY KEY (bitstream_id, bundle_id, bitstream_order);


--
-- Name: bundle_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_id_unique UNIQUE (uuid);


--
-- Name: bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_pkey PRIMARY KEY (uuid);


--
-- Name: bundle_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_uuid_key UNIQUE (uuid);


--
-- Name: checksum_history_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_pkey PRIMARY KEY (check_id);


--
-- Name: checksum_results_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_results
    ADD CONSTRAINT checksum_results_pkey PRIMARY KEY (result_code);


--
-- Name: collection2item_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_pkey PRIMARY KEY (collection_id, item_id);


--
-- Name: collection_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_id_unique UNIQUE (uuid);


--
-- Name: collection_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_pkey PRIMARY KEY (uuid);


--
-- Name: collection_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_uuid_key UNIQUE (uuid);


--
-- Name: community2collection_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_pkey PRIMARY KEY (collection_id, community_id);


--
-- Name: community2community_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_pkey PRIMARY KEY (parent_comm_id, child_comm_id);


--
-- Name: community_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_id_unique UNIQUE (uuid);


--
-- Name: community_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_pkey PRIMARY KEY (uuid);


--
-- Name: community_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_uuid_key UNIQUE (uuid);


--
-- Name: doi_doi_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_doi_key UNIQUE (doi);


--
-- Name: doi_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_pkey PRIMARY KEY (doi_id);


--
-- Name: dspaceobject_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.dspaceobject
    ADD CONSTRAINT dspaceobject_pkey PRIMARY KEY (uuid);


--
-- Name: eperson_email_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_email_key UNIQUE (email);


--
-- Name: eperson_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_id_unique UNIQUE (uuid);


--
-- Name: eperson_netid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_netid_key UNIQUE (netid);


--
-- Name: eperson_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_pkey PRIMARY KEY (uuid);


--
-- Name: eperson_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_uuid_key UNIQUE (uuid);


--
-- Name: epersongroup2eperson_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_pkey PRIMARY KEY (eperson_group_id, eperson_id);


--
-- Name: epersongroup2workspaceitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2workspaceitem
    ADD CONSTRAINT epersongroup2workspaceitem_pkey PRIMARY KEY (workspace_item_id, eperson_group_id);


--
-- Name: epersongroup_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_id_unique UNIQUE (uuid);


--
-- Name: epersongroup_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_pkey PRIMARY KEY (uuid);


--
-- Name: epersongroup_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_uuid_key UNIQUE (uuid);


--
-- Name: fileextension_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.fileextension
    ADD CONSTRAINT fileextension_pkey PRIMARY KEY (file_extension_id);


--
-- Name: group2group_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_pkey PRIMARY KEY (parent_id, child_id);


--
-- Name: group2groupcache_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_pkey PRIMARY KEY (parent_id, child_id);


--
-- Name: handle_handle_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_handle_key UNIQUE (handle);


--
-- Name: handle_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_pkey PRIMARY KEY (handle_id);


--
-- Name: harvested_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.harvested_collection
    ADD CONSTRAINT harvested_collection_pkey PRIMARY KEY (id);


--
-- Name: harvested_item_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.harvested_item
    ADD CONSTRAINT harvested_item_pkey PRIMARY KEY (id);


--
-- Name: item2bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_pkey PRIMARY KEY (bundle_id, item_id);


--
-- Name: item_id_unique; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_id_unique UNIQUE (uuid);


--
-- Name: item_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_pkey PRIMARY KEY (uuid);


--
-- Name: item_uuid_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_uuid_key UNIQUE (uuid);


--
-- Name: metadatafieldregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatafieldregistry
    ADD CONSTRAINT metadatafieldregistry_pkey PRIMARY KEY (metadata_field_id);


--
-- Name: metadataschemaregistry_namespace_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadataschemaregistry
    ADD CONSTRAINT metadataschemaregistry_namespace_key UNIQUE (namespace);


--
-- Name: metadataschemaregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadataschemaregistry
    ADD CONSTRAINT metadataschemaregistry_pkey PRIMARY KEY (metadata_schema_id);


--
-- Name: metadatavalue_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_pkey PRIMARY KEY (metadata_value_id);


--
-- Name: mycourse_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.mycourse
    ADD CONSTRAINT mycourse_pkey PRIMARY KEY (course_id);


--
-- Name: rating_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_pkey PRIMARY KEY (rating_id);


--
-- Name: registrationdata_email_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.registrationdata
    ADD CONSTRAINT registrationdata_email_key UNIQUE (email);


--
-- Name: registrationdata_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.registrationdata
    ADD CONSTRAINT registrationdata_pkey PRIMARY KEY (registrationdata_id);


--
-- Name: requestitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_pkey PRIMARY KEY (requestitem_id);


--
-- Name: requestitem_token_key; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_token_key UNIQUE (token);


--
-- Name: resourcepolicy_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_pkey PRIMARY KEY (policy_id);


--
-- Name: schema_version_pk; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.schema_version
    ADD CONSTRAINT schema_version_pk PRIMARY KEY (installed_rank);


--
-- Name: site_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_pkey PRIMARY KEY (uuid);


--
-- Name: subscription_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_pkey PRIMARY KEY (subscription_id);


--
-- Name: tasklistitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.tasklistitem
    ADD CONSTRAINT tasklistitem_pkey PRIMARY KEY (tasklist_id);


--
-- Name: versionhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionhistory
    ADD CONSTRAINT versionhistory_pkey PRIMARY KEY (versionhistory_id);


--
-- Name: versionitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_pkey PRIMARY KEY (versionitem_id);


--
-- Name: webapp_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.webapp
    ADD CONSTRAINT webapp_pkey PRIMARY KEY (webapp_id);


--
-- Name: workflowitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_pkey PRIMARY KEY (workflow_id);


--
-- Name: workspaceitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_pkey PRIMARY KEY (workspace_item_id);


--
-- Name: bit_bitstream_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bit_bitstream_fk_idx ON public.bitstream USING btree (bitstream_format_id);


--
-- Name: bitstream_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bitstream_id_idx ON public.bitstream USING btree (bitstream_id);


--
-- Name: bundle2bitstream_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bundle2bitstream_bitstream ON public.bundle2bitstream USING btree (bitstream_id);


--
-- Name: bundle2bitstream_bundle; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bundle2bitstream_bundle ON public.bundle2bitstream USING btree (bundle_id);


--
-- Name: bundle_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bundle_id_idx ON public.bundle USING btree (bundle_id);


--
-- Name: bundle_primary; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX bundle_primary ON public.bundle USING btree (primary_bitstream_id);


--
-- Name: ch_result_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX ch_result_fk_idx ON public.checksum_history USING btree (result);


--
-- Name: checksum_history_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX checksum_history_bitstream ON public.checksum_history USING btree (bitstream_id);


--
-- Name: collecion2item_collection; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collecion2item_collection ON public.collection2item USING btree (collection_id);


--
-- Name: collecion2item_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collecion2item_item ON public.collection2item USING btree (item_id);


--
-- Name: collection_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_bitstream ON public.collection USING btree (logo_bitstream_id);


--
-- Name: collection_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_id_idx ON public.collection USING btree (collection_id);


--
-- Name: collection_submitter; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_submitter ON public.collection USING btree (submitter);


--
-- Name: collection_template; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_template ON public.collection USING btree (template_item_id);


--
-- Name: collection_workflow1; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_workflow1 ON public.collection USING btree (workflow_step_1);


--
-- Name: collection_workflow2; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_workflow2 ON public.collection USING btree (workflow_step_2);


--
-- Name: collection_workflow3; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX collection_workflow3 ON public.collection USING btree (workflow_step_3);


--
-- Name: community2collection_collection; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community2collection_collection ON public.community2collection USING btree (collection_id);


--
-- Name: community2collection_community; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community2collection_community ON public.community2collection USING btree (community_id);


--
-- Name: community2community_child; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community2community_child ON public.community2community USING btree (child_comm_id);


--
-- Name: community2community_parent; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community2community_parent ON public.community2community USING btree (parent_comm_id);


--
-- Name: community_admin; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community_admin ON public.community USING btree (admin);


--
-- Name: community_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community_bitstream ON public.community USING btree (logo_bitstream_id);


--
-- Name: community_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX community_id_idx ON public.community USING btree (community_id);


--
-- Name: doi_doi_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX doi_doi_idx ON public.doi USING btree (doi);


--
-- Name: doi_object; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX doi_object ON public.doi USING btree (dspace_object);


--
-- Name: doi_resource_id_and_type_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX doi_resource_id_and_type_idx ON public.doi USING btree (resource_id, resource_type_id);


--
-- Name: eperson_email_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX eperson_email_idx ON public.eperson USING btree (email);


--
-- Name: eperson_group_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX eperson_group_id_idx ON public.epersongroup USING btree (eperson_group_id);


--
-- Name: eperson_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX eperson_id_idx ON public.eperson USING btree (eperson_id);


--
-- Name: epersongroup2eperson_group; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX epersongroup2eperson_group ON public.epersongroup2eperson USING btree (eperson_group_id);


--
-- Name: epersongroup2eperson_person; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX epersongroup2eperson_person ON public.epersongroup2eperson USING btree (eperson_id);


--
-- Name: epersongroup2workspaceitem_group; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX epersongroup2workspaceitem_group ON public.epersongroup2workspaceitem USING btree (eperson_group_id);


--
-- Name: epersongroup_unique_idx_name; Type: INDEX; Schema: public; Owner: dspace
--

CREATE UNIQUE INDEX epersongroup_unique_idx_name ON public.epersongroup USING btree (name);


--
-- Name: epg2wi_workspace_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX epg2wi_workspace_fk_idx ON public.epersongroup2workspaceitem USING btree (workspace_item_id);


--
-- Name: fe_bitstream_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX fe_bitstream_fk_idx ON public.fileextension USING btree (bitstream_format_id);


--
-- Name: group2group_child; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX group2group_child ON public.group2group USING btree (child_id);


--
-- Name: group2group_parent; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX group2group_parent ON public.group2group USING btree (parent_id);


--
-- Name: group2groupcache_child; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX group2groupcache_child ON public.group2groupcache USING btree (child_id);


--
-- Name: group2groupcache_parent; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX group2groupcache_parent ON public.group2groupcache USING btree (parent_id);


--
-- Name: handle_handle_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX handle_handle_idx ON public.handle USING btree (handle);


--
-- Name: handle_object; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX handle_object ON public.handle USING btree (resource_id);


--
-- Name: handle_resource_id_and_type_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX handle_resource_id_and_type_idx ON public.handle USING btree (resource_legacy_id, resource_type_id);


--
-- Name: harvested_collection_collection; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX harvested_collection_collection ON public.harvested_collection USING btree (collection_id);


--
-- Name: harvested_item_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX harvested_item_item ON public.harvested_item USING btree (item_id);


--
-- Name: item2bundle_bundle; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX item2bundle_bundle ON public.item2bundle USING btree (bundle_id);


--
-- Name: item2bundle_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX item2bundle_item ON public.item2bundle USING btree (item_id);


--
-- Name: item_collection; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX item_collection ON public.item USING btree (owning_collection);


--
-- Name: item_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX item_id_idx ON public.item USING btree (item_id);


--
-- Name: item_submitter; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX item_submitter ON public.item USING btree (submitter_id);


--
-- Name: metadatafield_schema_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX metadatafield_schema_idx ON public.metadatafieldregistry USING btree (metadata_schema_id);


--
-- Name: metadatafieldregistry_idx_element_qualifier; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX metadatafieldregistry_idx_element_qualifier ON public.metadatafieldregistry USING btree (element, qualifier);


--
-- Name: metadataschemaregistry_unique_idx_short_id; Type: INDEX; Schema: public; Owner: dspace
--

CREATE UNIQUE INDEX metadataschemaregistry_unique_idx_short_id ON public.metadataschemaregistry USING btree (short_id);


--
-- Name: metadatavalue_field_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX metadatavalue_field_fk_idx ON public.metadatavalue USING btree (metadata_field_id);


--
-- Name: metadatavalue_field_object; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX metadatavalue_field_object ON public.metadatavalue USING btree (metadata_field_id, dspace_object_id);


--
-- Name: metadatavalue_object; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX metadatavalue_object ON public.metadatavalue USING btree (dspace_object_id);


--
-- Name: most_recent_checksum_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX most_recent_checksum_bitstream ON public.most_recent_checksum USING btree (bitstream_id);


--
-- Name: mrc_result_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX mrc_result_fk_idx ON public.most_recent_checksum USING btree (result);


--
-- Name: requestitem_bitstream; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX requestitem_bitstream ON public.requestitem USING btree (bitstream_id);


--
-- Name: requestitem_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX requestitem_item ON public.requestitem USING btree (item_id);


--
-- Name: resourcepolicy_group; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX resourcepolicy_group ON public.resourcepolicy USING btree (epersongroup_id);


--
-- Name: resourcepolicy_idx_rptype; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX resourcepolicy_idx_rptype ON public.resourcepolicy USING btree (rptype);


--
-- Name: resourcepolicy_object; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX resourcepolicy_object ON public.resourcepolicy USING btree (dspace_object);


--
-- Name: resourcepolicy_person; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX resourcepolicy_person ON public.resourcepolicy USING btree (eperson_id);


--
-- Name: resourcepolicy_type_id_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX resourcepolicy_type_id_idx ON public.resourcepolicy USING btree (resource_type_id, resource_id);


--
-- Name: schema_version_s_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX schema_version_s_idx ON public.schema_version USING btree (success);


--
-- Name: subscription_collection; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX subscription_collection ON public.subscription USING btree (collection_id);


--
-- Name: subscription_person; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX subscription_person ON public.subscription USING btree (eperson_id);


--
-- Name: tasklist_workflow_fk_idx; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX tasklist_workflow_fk_idx ON public.tasklistitem USING btree (workflow_id);


--
-- Name: versionitem_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX versionitem_item ON public.versionitem USING btree (item_id);


--
-- Name: versionitem_person; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX versionitem_person ON public.versionitem USING btree (eperson_id);


--
-- Name: workspaceitem_coll; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX workspaceitem_coll ON public.workspaceitem USING btree (collection_id);


--
-- Name: workspaceitem_item; Type: INDEX; Schema: public; Owner: dspace
--

CREATE INDEX workspaceitem_item ON public.workspaceitem USING btree (item_id);


--
-- Name: metdata; Type: TRIGGER; Schema: public; Owner: dspace
--

CREATE TRIGGER metdata AFTER DELETE ON public.metadatavalue FOR EACH STATEMENT EXECUTE PROCEDURE public.export();


--
-- Name: metdata; Type: TRIGGER; Schema: public; Owner: dspace
--

CREATE TRIGGER metdata AFTER INSERT OR DELETE ON public.handle FOR EACH STATEMENT EXECUTE PROCEDURE public.export_handle();


--
-- Name: bitstream_bitstream_format_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_bitstream_format_id_fkey FOREIGN KEY (bitstream_format_id) REFERENCES public.bitstreamformatregistry(bitstream_format_id);


--
-- Name: bitstream_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: bundle2bitstream_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: bundle2bitstream_bundle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_bundle_id_fkey FOREIGN KEY (bundle_id) REFERENCES public.bundle(uuid);


--
-- Name: bundle_primary_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_primary_bitstream_id_fkey FOREIGN KEY (primary_bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: bundle_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: checksum_history_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: checksum_history_result_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_result_fkey FOREIGN KEY (result) REFERENCES public.checksum_results(result_code);


--
-- Name: collection2item_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: collection2item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: collection_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_admin_fkey FOREIGN KEY (admin) REFERENCES public.epersongroup(uuid);


--
-- Name: collection_submitter_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_submitter_fkey FOREIGN KEY (submitter) REFERENCES public.epersongroup(uuid);


--
-- Name: collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: collection_workflow_step_1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_workflow_step_1_fkey FOREIGN KEY (workflow_step_1) REFERENCES public.epersongroup(uuid);


--
-- Name: collection_workflow_step_2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_workflow_step_2_fkey FOREIGN KEY (workflow_step_2) REFERENCES public.epersongroup(uuid);


--
-- Name: collection_workflow_step_3_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_workflow_step_3_fkey FOREIGN KEY (workflow_step_3) REFERENCES public.epersongroup(uuid);


--
-- Name: community2collection_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: community2collection_community_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.community(uuid);


--
-- Name: community2community_child_comm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_child_comm_id_fkey FOREIGN KEY (child_comm_id) REFERENCES public.community(uuid);


--
-- Name: community2community_parent_comm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_parent_comm_id_fkey FOREIGN KEY (parent_comm_id) REFERENCES public.community(uuid);


--
-- Name: community_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_admin_fkey FOREIGN KEY (admin) REFERENCES public.epersongroup(uuid);


--
-- Name: community_logo_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_logo_bitstream_id_fkey FOREIGN KEY (logo_bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: community_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: course_cuuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_cuuid_fkey FOREIGN KEY (cuuid) REFERENCES public.collection(uuid);


--
-- Name: course_euuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_euuid_fkey FOREIGN KEY (euuid) REFERENCES public.eperson(uuid);


--
-- Name: courses_cuuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_cuuid_fkey FOREIGN KEY (cuuid) REFERENCES public.collection(uuid);


--
-- Name: courses_euuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_euuid_fkey FOREIGN KEY (euuid) REFERENCES public.eperson(uuid);


--
-- Name: doi_dspace_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_dspace_object_fkey FOREIGN KEY (dspace_object) REFERENCES public.dspaceobject(uuid);


--
-- Name: eperson_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: epersongroup2eperson_eperson_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_eperson_group_id_fkey FOREIGN KEY (eperson_group_id) REFERENCES public.epersongroup(uuid);


--
-- Name: epersongroup2eperson_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: epersongroup2workspaceitem_eperson_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2workspaceitem
    ADD CONSTRAINT epersongroup2workspaceitem_eperson_group_id_fkey FOREIGN KEY (eperson_group_id) REFERENCES public.epersongroup(uuid);


--
-- Name: epersongroup2workspaceitem_workspace_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup2workspaceitem
    ADD CONSTRAINT epersongroup2workspaceitem_workspace_item_id_fkey FOREIGN KEY (workspace_item_id) REFERENCES public.workspaceitem(workspace_item_id);


--
-- Name: epersongroup_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: fileextension_bitstream_format_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.fileextension
    ADD CONSTRAINT fileextension_bitstream_format_id_fkey FOREIGN KEY (bitstream_format_id) REFERENCES public.bitstreamformatregistry(bitstream_format_id);


--
-- Name: group2group_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2group_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2groupcache_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2groupcache_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.epersongroup(uuid);


--
-- Name: handle_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.dspaceobject(uuid);


--
-- Name: harvested_collection_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.harvested_collection
    ADD CONSTRAINT harvested_collection_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: harvested_item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.harvested_item
    ADD CONSTRAINT harvested_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: item2bundle_bundle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_bundle_id_fkey FOREIGN KEY (bundle_id) REFERENCES public.bundle(uuid);


--
-- Name: item2bundle_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: item_owning_collection_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_owning_collection_fkey FOREIGN KEY (owning_collection) REFERENCES public.collection(uuid);


--
-- Name: item_submitter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_submitter_id_fkey FOREIGN KEY (submitter_id) REFERENCES public.eperson(uuid);


--
-- Name: item_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: metadatafieldregistry_metadata_schema_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatafieldregistry
    ADD CONSTRAINT metadatafieldregistry_metadata_schema_id_fkey FOREIGN KEY (metadata_schema_id) REFERENCES public.metadataschemaregistry(metadata_schema_id);


--
-- Name: metadatavalue_dspace_object_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_dspace_object_id_fkey FOREIGN KEY (dspace_object_id) REFERENCES public.dspaceobject(uuid) ON DELETE CASCADE;


--
-- Name: metadatavalue_metadata_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_metadata_field_id_fkey FOREIGN KEY (metadata_field_id) REFERENCES public.metadatafieldregistry(metadata_field_id);


--
-- Name: most_recent_checksum_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.most_recent_checksum
    ADD CONSTRAINT most_recent_checksum_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: most_recent_checksum_result_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.most_recent_checksum
    ADD CONSTRAINT most_recent_checksum_result_fkey FOREIGN KEY (result) REFERENCES public.checksum_results(result_code);


--
-- Name: mycourse_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.mycourse
    ADD CONSTRAINT mycourse_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: mycourse_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.mycourse
    ADD CONSTRAINT mycourse_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: mycourses_cuuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.mycourses
    ADD CONSTRAINT mycourses_cuuid_fkey FOREIGN KEY (cuuid) REFERENCES public.collection(uuid);


--
-- Name: mycourses_euuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.mycourses
    ADD CONSTRAINT mycourses_euuid_fkey FOREIGN KEY (euuid) REFERENCES public.eperson(uuid);


--
-- Name: rating_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: rating_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: requestitem_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: requestitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: resourcepolicy_dspace_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_dspace_object_fkey FOREIGN KEY (dspace_object) REFERENCES public.dspaceobject(uuid) ON DELETE CASCADE;


--
-- Name: resourcepolicy_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: resourcepolicy_epersongroup_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_epersongroup_id_fkey FOREIGN KEY (epersongroup_id) REFERENCES public.epersongroup(uuid);


--
-- Name: site_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: subscription_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: subscription_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: tasklistitem_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.tasklistitem
    ADD CONSTRAINT tasklistitem_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: tasklistitem_workflow_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.tasklistitem
    ADD CONSTRAINT tasklistitem_workflow_id_fkey FOREIGN KEY (workflow_id) REFERENCES public.workflowitem(workflow_id);


--
-- Name: versionitem_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: versionitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: versionitem_versionhistory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_versionhistory_id_fkey FOREIGN KEY (versionhistory_id) REFERENCES public.versionhistory(versionhistory_id);


--
-- Name: workflowitem_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workflowitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: workflowitem_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_owner_fkey FOREIGN KEY (owner) REFERENCES public.eperson(uuid);


--
-- Name: workspaceitem_collection_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_collection_id_fk FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workspaceitem_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workspaceitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dspace
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

