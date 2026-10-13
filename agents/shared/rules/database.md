# Database Conventions

Unless the project explicitly specifies otherwise:

- Use **snake_case** for all database identifiers, including tables, columns, indexes, constraints, and foreign keys.
- Use **camelCase** for all application code, including variables, object properties, DTOs, entities, models, and API responses.
- Bridge naming differences using ORM mapping features (e.g. Prisma `@map` and `@@map`) rather than exposing database naming conventions throughout the application.
- Never leak `snake_case` database field names into business logic or application code.
- Follow existing migration and repository patterns when modifying the database schema.
