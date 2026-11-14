/// Malaysian states and federal territories, as (value sent to the API,
/// label shown to the user). Must match the backend's `MalaysianState`.
const List<(String, String)> malaysianStates = [
  ('Johor', 'Johor'),
  ('Kedah', 'Kedah'),
  ('Kelantan', 'Kelantan'),
  ('Melaka', 'Melaka'),
  ('Negeri Sembilan', 'Negeri Sembilan'),
  ('Pahang', 'Pahang'),
  ('Perak', 'Perak'),
  ('Perlis', 'Perlis'),
  ('Pulau Pinang', 'Pulau Pinang'),
  ('Sabah', 'Sabah'),
  ('Sarawak', 'Sarawak'),
  ('Selangor', 'Selangor'),
  ('Terengganu', 'Terengganu'),
  ('Kuala Lumpur', 'W.P. Kuala Lumpur'),
  ('Labuan', 'W.P. Labuan'),
  ('Putrajaya', 'W.P. Putrajaya'),
];

/// Same rules the backend applies (apps/common/validators.py).
final RegExp phonePattern = RegExp(r'^\+?[0-9][0-9\s-]{6,19}$');
final RegExp postcodePattern = RegExp(r'^\d{5}$');
