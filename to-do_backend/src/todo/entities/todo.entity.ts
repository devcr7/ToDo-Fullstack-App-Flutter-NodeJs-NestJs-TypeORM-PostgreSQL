import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { User } from "../../user/entities/user.entity";


@Entity()
export class Todo {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    title: string;

    @Column()
    description: string;

    @Column()
    date: string;

    @Column()
    completed: boolean;

    @ManyToOne(type => User, (user) => user.todo, { onDelete: 'CASCADE' })
    user: User;
}