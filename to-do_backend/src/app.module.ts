import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UserModule } from './user/user.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TodoModule } from './todo/todo.module';
import config from 'ormconfig';

@Module({
  imports: [UserModule, TypeOrmModule.forRoot(config), TodoModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
