import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { CreateTodoDto } from './dto/create-todo.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Todo } from './entities/todo.entity';
import { Repository } from 'typeorm';
import { UserService } from 'src/user/user.service';
import * as jwt from 'jsonwebtoken';


@Injectable()
export class TodoService {

  constructor(@InjectRepository(Todo)
  private readonly todoRepository: Repository<Todo>, private userService: UserService){}

  async addTodo(createTodoDto: CreateTodoDto, authHeader: string) {
    try {
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        throw new HttpException('Unauthorized!', HttpStatus.UNAUTHORIZED);
      }
      const token = authHeader.split(' ')[1];
      const decoded = await this.decodeToken(token);
      const userId = decoded.userId;
      try {
        let todo: Todo = new Todo();
        todo.title = createTodoDto.title;
        todo.date = new Date().toLocaleString();
        todo.completed = false;
        todo.description = createTodoDto.description;
        todo.user = await this.userService.findUserById(userId);
        const save = await this.todoRepository.save(todo);
        return {status: true, message: `${todo.title} saved successfully!`};
      } catch (error) {
        throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  async getUserTodoList(authHeader: string, completed?: boolean, order?: string) {
    try {
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        throw new HttpException('Unauthorized!', HttpStatus.UNAUTHORIZED);
      }
      const token = authHeader.split(' ')[1];
      const decoded = await this.decodeToken(token);
      const userId = decoded.userId;
      try {
        let orderClause: 'DESC' | 'ASC' | {[key: string]: 'ASC' | 'DESC'} = 'DESC';
        if (order === 'ASC' || order === 'DESC') {
          orderClause = order; 
        }
        var todoList: Todo[];
        if(completed != undefined)
          todoList = await this.todoRepository.find({ where: { user: { id: userId }, completed: completed }, order: { date: orderClause} });
        else
          todoList = await this.todoRepository.find({ where: { user: { id: userId } }, order: { date: orderClause} });
        return { status: true, name: `${decoded.firstName} ${decoded.lastName}`, email: decoded.email, result: todoList };
      } catch (error) {
        throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  async updateTodo(id: number, createTodoDto: CreateTodoDto) {
    try {
        return await this.todoRepository.update(id, {
          title: createTodoDto.title,
          description: createTodoDto.description,
          completed: createTodoDto?.completed,
          date:new Date().toLocaleString()
        });
    } catch (error) {
      throw error;
    }
  }

  async deleteTodo(id: number) {
    try {
      return await this.todoRepository.delete(id);
    } catch(error) {
      throw error;
    }
  }

  decodeToken = async (token: string) => await new Promise<jwt.JwtPayload>((resolve, reject) => {
    jwt.verify(token, 'secretKey', (err: jwt.VerifyErrors, decoded: jwt.JwtPayload) => {
      if (err) {
        throw new HttpException('Unauthorized!', HttpStatus.UNAUTHORIZED);
      } else {
        resolve(decoded);
      }
    });
  });
}
