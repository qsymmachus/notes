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

Syntax varies by database, but in MySQL and PostgreSQL, you can also limit the number of columns returned by a select statement with a `LIMIT` clause:

```sql
SELECT *
FROM table_name
LIMIT number;
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

INSERT INTO
-----------

To insert new records into a table:

```sql
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);
```

You can omit the column list if you're inserting values for every column. Be sure that your value order matches the column order, however.

UPDATE
------

To modify existing records in a table:

```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
```

Be careful, if you omit the `WHERE` clause, _all_ records in the database will be updated!

DELETE
------

To delete existing records in a table:

```
DELETE FROM table_name
WHERE condition;
```

Again, be careful – if you forget the `WHERE` clause, _all_ records will be deleted. There are times you may want to do this, will still preserving the table (for example to delete test data).

MIN, MAX, COUNT, AVG, SUM
-------------------------

These are _functions_ that operate on column values.

The min function returns the smallest value of the selected column, and max returns the biggest:

```sql
SELECT MIN(column_name), MAX(column_name
FROM table_name;
```

Count returns the number of rows returned by a query:

```sql
SELECT COUNT(column_name)
FROM table_name
WHERE condition;
```

Average returns the average value of a _numeric_ column:

```sql
SELECT AVG(column_name)
FROM table_name
WHERE condition;
```

Sum returns the total sum of a _numeric_ column:

```sql
SELECT SUM(column_name)
FROM table_name
WHERE condition;
```

