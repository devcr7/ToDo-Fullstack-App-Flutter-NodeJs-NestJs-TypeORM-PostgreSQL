import { Todo } from "src/todo/entities/todo.entity";
import { User } from "src/user/entities/user.entity";
import { PostgresConnectionOptions } from "typeorm/driver/postgres/PostgresConnectionOptions";

const config: PostgresConnectionOptions = {
    type: "postgres",
    database: "postgres",
    host: "localhost",
    port: 5432,
    username: "postgres",
    password: "postgres",
    entities: [User, Todo],
    synchronize: true
}

export default config;