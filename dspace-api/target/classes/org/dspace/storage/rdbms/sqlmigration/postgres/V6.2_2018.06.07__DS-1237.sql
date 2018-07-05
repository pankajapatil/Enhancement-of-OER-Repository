CREATE TABLE Mycourses
(
  id        INTEGER,
  euuid     uuid REFERENCES EPerson(uuid),
  cuuid     uuid REFERENCES Collection(uuid)
);

