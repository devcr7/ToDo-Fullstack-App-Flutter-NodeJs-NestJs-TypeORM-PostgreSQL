import { Controller, Get, Post, Body, Patch, Param, Delete, ValidationPipe, Put, Headers, Query } from '@nestjs/common';
import { TodoService } from './todo.service';
import { CreateTodoDto } from './dto/create-todo.dto';
import { UpdateTodoDto } from './dto/update-todo.dto';
import { throwError } from 'rxjs';

@Controller('todo')
export class TodoController {
  constructor(private readonly todoService: TodoService) {}

  @Post('addTodo')
  addTodo(@Body(ValidationPipe) createTodoDto: CreateTodoDto, @Headers('Authorization') authHeader: string) {
    try{
      return this.todoService.addTodo(createTodoDto, authHeader);
    } catch(error) {
      throw error;
    }
  }

  @Get('getUserTodoList')
  getUserTodoList(@Headers('Authorization') authHeader: string,  @Query('completed') completed?: boolean, @Query('order') order?: string){
    try{
      return this.todoService.getUserTodoList(authHeader, completed, order);
    } catch(error) {
      throw error
    }
  }

  @Put('updateTodo/:id')
  updateTodo(@Param('id') id: number, @Body() createTodoDto: CreateTodoDto) {
    try{
      const update = this.todoService.updateTodo(Number(id), createTodoDto);
      return {status: true, message: `Update item ${id} successfully!`, result: update};
    } catch(error) {
      throw error;
    }
  }


  @Delete('deleteTodo/:id')
  deleteTodo(@Param('id') id: string) {
    try {
      const deleted = this.todoService.deleteTodo(Number(id));
      return {status: true, message: `${id} deleted successfully!`, result: deleted}
    } catch(error) {
      throw error;
    }
  }
}
