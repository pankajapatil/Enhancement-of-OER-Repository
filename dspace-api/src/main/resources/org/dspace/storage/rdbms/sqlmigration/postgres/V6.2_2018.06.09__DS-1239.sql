CREATE TABLE course
(
  uuid        uuid,
  euuid     uuid REFERENCES EPerson(uuid),
  cuuid     uuid REFERENCES Collection(uuid)
);

