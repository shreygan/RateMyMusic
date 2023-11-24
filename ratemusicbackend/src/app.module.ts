import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { DatabaseModule } from './db.module';
import { SongsModule } from './songs/songs.module';
import { ReviewsController } from './reviews/reviews.controller';

@Module({
  imports: [DatabaseModule, SongsModule],
  controllers: [AppController, ReviewsController],
  providers: [AppService],
})
export class AppModule {}
