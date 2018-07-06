CREATE SEQUENCE course_seq;

CREATE TABLE Mycourse
(
  course_id   INTEGER PRIMARY KEY,
  eperson_id        UUID REFERENCES EPerson(uuid),
  collection_id     UUID REFERENCES Collection(uuid)
);

