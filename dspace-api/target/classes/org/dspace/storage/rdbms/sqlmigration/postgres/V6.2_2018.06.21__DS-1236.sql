CREATE SEQUENCE rating_seq;

CREATE TABLE Rating
(
  rating_id   INTEGER PRIMARY KEY,
  eperson_id        UUID REFERENCES EPerson(uuid),
  item_id     UUID REFERENCES Item(uuid),
  rating_value INTEGER
);

