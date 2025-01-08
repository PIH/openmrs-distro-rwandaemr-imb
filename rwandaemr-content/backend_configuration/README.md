Scripts
=====================

# Encounter Types

```sql
select t.uuid as 'UUID',
       if(t.retired, 'TRUE', null) as 'Void/Retire',
       t.name as 'Name',
       t.description as 'Description'
from encounter_type t
order by t.name
;
```

# Locations

```sql
select l.uuid as 'UUID',
        if(l.retired, 'TRUE', null) as 'Void/Retire',
        l.name as 'Name',
        p.name as 'Parent',
        l.description as 'Description'
from location l
         left join location p on l.parent_location = p.location_id
order by l.name
;
```

# Visit Types

```sql
select t.uuid as 'UUID',
       if(t.retired, 'TRUE', null) as 'Void/Retire',
       t.name as 'Name',
       t.description as 'Description'
from visit_type t
order by t.name
;
```