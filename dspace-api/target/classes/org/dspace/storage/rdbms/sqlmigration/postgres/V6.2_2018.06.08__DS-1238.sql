CREATE TABLE Courses
(
  euuid     uuid REFERENCES EPerson(uuid),
  cuuid     uuid REFERENCES Collection(uuid)
);

