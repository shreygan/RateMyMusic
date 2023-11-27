import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { DatabaseModule } from './db.module';
import { SongsModule } from './songs/songs.module';
import { ReviewsController } from './reviews/reviews.controller';
import { UsersModule } from './users/users.module';

@Module({
  imports: [DatabaseModule, SongsModule, UsersModule],
  controllers: [AppController, ReviewsController],
  providers: [AppService],
})
export class AppModule {}
