import { Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { User } from './entities/user.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { HttpException, HttpStatus } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import * as jwt from 'jsonwebtoken';


@Injectable()
export class UserService {

  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async create(createUserDto: CreateUserDto): Promise<User> {
    try {
      let user: User = new User();
      user.email = createUserDto.email;
      user.firstName = createUserDto.firstName;
      user.lastName = createUserDto.lastName;
      user.password = createUserDto.password;
      return await this.userRepository.save(user);
    } catch (error) {
      console.error('Error in create:', error);
      throw new HttpException(error.message, HttpStatus.BAD_REQUEST);
    }
  }

  async login(requestBody: any) {
    try {
      const { email, password} = requestBody;
      const user = await this.check(email);

      if(!user) {
        throw new HttpException("User not found!", HttpStatus.NOT_FOUND);
      } 

      const isMatch = await this.comparePassword(user, password);
      if(isMatch == false) {
          throw new HttpException("Wrong password!", HttpStatus.BAD_REQUEST); 
      }

      let tokenData = {id:user.id, email:user.email, firstName: user.firstName, lastName: user.lastName};

      const token = this.generateToken(tokenData, 'secretKey', '1h');
      return {status: true, message:"Login successful!", token: token}
    } catch (error) {
      console.error('Error in login:', error);
      throw error; 
    }
  }

  async check(email: string) {
    try {
      return await this.userRepository.findOne({ where: { email: email } });
    } catch (error) {
      console.error('Error in check:', error);
      throw new Error('Error checking user');
    }
  }

  async findAll() {
    try {
      return await this.userRepository.find();
    } catch (error) {
      console.error('Error in findAll:', error);
      throw Error('Error finding all users');
    }
  }

  async findUserById(id: number) {
    try {
      return await this.userRepository.findOneOrFail({ where: { id: id } });
    } catch (error) {
      console.error('Error in findUserById:', error);
      throw new Error('Error finding user by ID');
    }
  }

  update(id: number, updateUserDto: UpdateUserDto) {
    try {
      return `This action updates a #${id} user`;
    } catch (error) {
      console.error('Error in update:', error);
      throw new Error('Error updating user');
    }
  }

  async remove(id: number) {
    try {
      return await this.userRepository.delete(id);
    } catch (error) {
      console.error('Error in remove:', error);
      throw error;
    }
  }

  async comparePassword(user: User, userPassword: string): Promise<boolean> {
    try {
      const isMatch = await bcrypt.compare(userPassword, user.password);
      return isMatch;
    } catch (error) {
      throw error;
    }
  }

   generateToken(tokenData: any, secretKey: string, jwt_expire: string) {
    return jwt.sign(tokenData, secretKey, {expiresIn: jwt_expire});
  }
}
