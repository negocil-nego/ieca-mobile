BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "tb_hymns_content" (
	"id"	INTEGER,
	"position"	INTEGER NOT NULL,
	"content"	TEXT NOT NULL,
	"type_stanza"	TEXT NOT NULL DEFAULT 'VERSE',
	"lang"	TEXT NOT NULL,
	"hymns_number_id"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("hymns_number_id") REFERENCES "tb_hymns_number"("id")
);
CREATE TABLE IF NOT EXISTS "tb_hymns_group" (
	"id"	INTEGER,
	"name"	TEXT NOT NULL,
	"beginning"	INTEGER NOT NULL,
	"finished"	INTEGER NOT NULL,
	"type"	TEXT DEFAULT 'NORMAL',
	"section_id"	INTEGER,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("section_id") REFERENCES "tb_sections"("id")
);
CREATE TABLE IF NOT EXISTS "tb_hymns_number" (
	"id"	INTEGER,
	"num"	INTEGER NOT NULL,
	"code"	TEXT NOT NULL,
	"label"	TEXT NOT NULL,
	"type"	TEXT DEFAULT 'NORMAL',
	"hymns_group_id"	INTEGER NOT NULL,
	"last_accessed_at"	INTEGER,
	"is_favorite"	INTEGER NOT NULL DEFAULT 0,
	"access_count"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("hymns_group_id") REFERENCES "tb_hymns_group"("id")
);
CREATE TABLE IF NOT EXISTS "tb_invocation_content" (
	"id"	INTEGER,
	"position"	INTEGER NOT NULL,
	"invocation_title_id"	INTEGER NOT NULL,
	"books"	TEXT,
	"content"	TEXT NOT NULL,
	PRIMARY KEY("id"),
	FOREIGN KEY("invocation_title_id") REFERENCES "tb_invocation_title"("id")
);
CREATE TABLE IF NOT EXISTS "tb_invocation_title" (
	"id"	INTEGER,
	"name"	TEXT NOT NULL,
	"position"	INTEGER NOT NULL,
	"section_id"	INTEGER NOT NULL,
	"last_accessed_at"	INTEGER,
	"is_favorite"	INTEGER DEFAULT 0,
	"access_count"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id"),
	FOREIGN KEY("section_id") REFERENCES "tb_sections"("id")
);
CREATE TABLE IF NOT EXISTS "tb_litany_content" (
	"id"	INTEGER NOT NULL,
	"person"	TEXT NOT NULL,
	"litany_title_id"	INTEGER NOT NULL,
	"content"	TEXT NOT NULL,
	"books"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("litany_title_id") REFERENCES "tb_litany_title"("id")
);
CREATE TABLE IF NOT EXISTS "tb_litany_title" (
	"id"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL,
	"position"	INTEGER NOT NULL,
	"section_id"	INTEGER NOT NULL,
	"last_accessed_at"	INTEGER,
	"is_favorite"	INTEGER NOT NULL DEFAULT 0,
	"access_count"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("section_id") REFERENCES "tb_sections"("id")
);
CREATE TABLE IF NOT EXISTS "tb_psalms_content" (
	"id"	INTEGER,
	"person"	TEXT NOT NULL,
	"psalms_title_id"	INTEGER NOT NULL,
	"content"	TEXT NOT NULL,
	"position"	INTEGER NOT NULL,
	PRIMARY KEY("id"),
	FOREIGN KEY("psalms_title_id") REFERENCES "tb_psalms_title"("id")
);
CREATE TABLE IF NOT EXISTS "tb_psalms_title" (
	"id"	INTEGER,
	"name"	TEXT NOT NULL,
	"position"	INTEGER NOT NULL,
	"section_id"	INTEGER NOT NULL,
	"last_accessed_at"	INTEGER,
	"is_favorite"	INTEGER NOT NULL DEFAULT 0,
	"access_count"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id"),
	FOREIGN KEY("section_id") REFERENCES "tb_sections"("id")
);
CREATE TABLE IF NOT EXISTS "tb_sections" (
	"id"	INTEGER NOT NULL,
	"code"	TEXT NOT NULL UNIQUE,
	"name"	TEXT NOT NULL UNIQUE,
	"is_active"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT)
);
COMMIT;
