Scripts
=====================

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