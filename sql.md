SQL
===

SELECT
------

Select specific columns from a table:

```sql
SELECT column1, column2, ...
FROM table_name;
```

Select all columns from a table:

```sql
SELECT *
FROM table_name;
```

Select distinct returns only distinct (different) values, so no column contains duplicate values:

```sql
SELECT DISTINCT column1, column2, ...
FROM table_name;
```

WHERE
-----

The where clause is used to filter records based on some conditions. It's not just used for select statements, but also update, delete, and so on:

```sql
SELECT *
FROM table_name
WHERE condition;
```

### WHERE clause operators

| Operator | Description                        |
| -------- | ---------------------------------- |
| =        | Equal                              |
| >        | Greater than                       |
| <        | Less than                          |
| >=       | Greater than or equal to           |
| <=       | Less than or equal to              |
| <> or != | Not equal                          |
| BETWEEN  | Within a range, `BETWEEN x AND y`  |
| LIKE     | Search for a pattern, `LIKE 'y%s'` |
| IN       | Within a set, `IN (x, y, z)`       |

You can combine or negate where conditions with `AND`, `OR`, and `NOT` operators:

```sql
SELECT *
FROM table_name
WHERE condition AND (condition OR condition);
```

```sql
SELECT *
FROM table_name
WHERE NOT condition;
```

ORDER BY
--------

Order by is used to sort the result set in ascending or descending order using a specified column:

```sql
SELECT *
FROM table_name
ORDER BY column1, column2, ... ASC|DESC;
```

In this example it will sort by `column1`, but use `column2` as a secondary sort value if the values of `column1` happen to match.

By default, order by sorts in ascending (`ASC`) order.

