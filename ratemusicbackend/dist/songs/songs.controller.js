"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SongsController = exports.CreateReviewDto = void 0;
const common_1 = require("@nestjs/common");
const songs_service_1 = require("./songs.service");
class CreateReviewDto {
}
exports.CreateReviewDto = CreateReviewDto;
let SongsController = class SongsController {
    constructor(songsService) {
        this.songsService = songsService;
    }
    async findAll(searchTerm) {
        return await this.songsService.findAll(searchTerm);
    }
    async getAllSongReviews() {
        return await this.songsService.getAllSongReviews();
    }
    async getAllAlbumReviews() {
        return await this.songsService.getAllAlbumReviews();
    }
    async createAlbumReview(createReviewDto) {
        return await this.songsService.createAlbumReview(createReviewDto);
    }
};
exports.SongsController = SongsController;
__decorate([
    (0, common_1.Get)('findsongs'),
    __param(0, (0, common_1.Query)('q')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], SongsController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)('songreviews'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], SongsController.prototype, "getAllSongReviews", null);
__decorate([
    (0, common_1.Get)('albumreviews'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], SongsController.prototype, "getAllAlbumReviews", null);
__decorate([
    (0, common_1.Post)('createalbumreviews'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [CreateReviewDto]),
    __metadata("design:returntype", Promise)
], SongsController.prototype, "createAlbumReview", null);
exports.SongsController = SongsController = __decorate([
    (0, common_1.Controller)('songs'),
    __metadata("design:paramtypes", [songs_service_1.SongsService])
], SongsController);
//# sourceMappingURL=songs.controller.js.map