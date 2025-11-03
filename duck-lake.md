# DuckLake

This notes capture what I've learned about [DuckLake](https://ducklake.select/).

Much of what I learned came from watching [this video](https://www.youtube.com/watch?v=zeonmOO9jm4).

## A brief history of the data stack

To understand DuckLake you need a basic understanding of the "data stack" – how do we perform analytic workloads over large sets of data? Recall the distinction between OLTP (Online Transaction Processing) databases, which operate primarily over rows, and OLAP (Online Analytics Processing), which operate primarily over columns.

### Data Lakes

The basic idea is to separate the machines where we _store_ data from the machines where we _compute_ over the data. This allows you to scale each dimensions independently. Early examples include [Snowflake](https://en.wikipedia.org/wiki/Snowflake_Inc.) and [Big Query](https://en.wikipedia.org/wiki/BigQuery). This approach is usually contrasted with earlier models like [Hadoop](https://hadoop.apache.org/) where compute and date are co-located.

### Parquet file format

[Parquet](https://en.wikipedia.org/wiki/Apache_Parquet) is a columnar file format for analytic data storage. Because it's just binary, it's ideal for blob storage (like S3) and is highly portable. For these reasons among others, it has emerged as the _de facto_ standard file format for analytic data storage.

It has a few limitations:

- It is immutable and cannot be updated. Applying updates to a parquet file requires to rewrite the entire file.
- This immutability also makes things like time travel, transactional guarantees, and schema updates very hard to do.

### Lake houses

"Lake houses" (a portmanteau of "data lake" + "data warehouse") attempts to solve the limitations of parquet files by adding a layer of **metadata** on top of our data lake (e.g. [Iceberg](https://en.wikipedia.org/wiki/Apache_Iceberg)) The **metadata catalog** describes the raw data in the data lake (just parquet files), adding a transaction log that describes data changes, versions, and schema changes. Query engines then use this metadata catalog to narrow down the specific parquet files needed to satisfy a particular query.

Lake houses allow you to add behaviors to your data lake like:

- Time travel
- Schema changes
- Partitioning

Many lake houses are commited to a _file based_ approach to metadata management. This has a few draw backs:

- They struggle with _atomic commits_ to metadata.
- They're typically designed to describe and manage a _single table_ of data.

To solve for this they introduced **catalogs** – REST services backed by databases like Postgres – for making atomic commits to metadata files and managing multiple tables. The critique of this approach is that it introduces significant complexity to work around the commitment to storing metadata in files

## The DuckLake idea

With that background covered, what is DuckLake and what distinguishes it?

**DuckLake centralizes _all_ metadata in a traditional database.** This simplifies metadata management by removing metadata files and the catalogs used to manage them.

It immediately solves the limitations of "file-based" lake houses (lack of atomic commits, single table management) because relational databases solve them for us. In practice this just means two things:

- Database tables –> store the actual metadata.
- Database queries -> implement updates to the metadata.

Your underlying data lake is still a mass of parquet files, but you manage the metadata describing them in an ordinary database. Any ACID compliant database that supports primary keys can be the backing implementation of DuckLake; it's more accurate to think of DuckLake as a _standard_ for working with metadata than as a specific technology.
