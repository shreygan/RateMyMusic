<script setup lang="ts">
import { defineComponent } from 'vue';

async function loadAlbumReviews() {
    let url = "http://localhost:3000/songs/albumreviews";
    const response = await fetch(url);
    return await response.json();
}

import { sanitizeInput, arrayBufferToBase64 } from "../utils/utils";

async function loadSongReviews() {
    let url = "http://localhost:3000/songs/songreviews";
    const response = await fetch(url);
    return await response.json();
}

function renderStars(rating: number) {
    const stars: string[] = [];
    for (let i = 0; i < 5; i++) {
        if (i < rating) {
            stars.push('★');
        } else {
            stars.push('☆');
        }
    }
    return stars.join(' ');
}

const isLoading = ref(false);
const albumReviews = computedAsync(loadAlbumReviews, [], isLoading);
const songReviews = computedAsync(loadSongReviews, [], isLoading);
</script>


<!-- 
<script lang="ts">
export default {
  toggleLike(review: any) {
    review.isLiked = !review.isLiked;

    if (review.isLiked) {
      review.likes += 1;
    } else {
      review.likes -= 1;
    }
  },

  toggleDislike(review: any) {
    review.isLiked = !review.isLiked;

    if (review.isLiked) {
      review.likes += 1;
    } else {
      review.likes -= 1;
    }
  },
};
</script> -->

<!-- <style scoped>
.btn-link {
  background-color: transparent;
  border: none;
  cursor: pointer;
}

.upvote-icon {
  width: 20px;
  /* Adjust the width and height based on your image dimensions */
  height: 20px;
  margin-right: -10px;
  margin-top: -2.5px;
  /* Add some spacing between the image and the Likes count */
  transform: rotate(180deg);
  filter: grayscale(100%);
}

.upvote-icon-upvoted {
  width: 25px;
  /* Adjust the width and height based on your image dimensions */
  height: 25px;
  margin-right: -10px;
  margin-top: -2.5px;
  /* Add some spacing between the image and the Likes count */
  transform: rotate(180deg);
}

.downvote-icon {
  width: 20px;
  /* Adjust the width and height based on your image dimensions */
  height: 20px;
  margin-right: -10px;
  margin-top: 0;
  /* Add some spacing between the image and the Likes count */
  filter: grayscale(100%);
}

.downvote-icon-downvoted {
  width: 25px;
  /* Adjust the width and height based on your image dimensions */
  height: 25px;
  margin-right: -10px;
  /* Add some spacing between the image and the Likes count */
  filter: grayscale(100%);
  filter: hue-rotate(240deg);
}
</style> -->


<style scoped>
.main-title {
    text-align: center;
    margin: 0;
    /* Updated to set margin-top to 0 */
    /* padding-bottom: 200pt; */
    padding-bottom: 2%;
    margin-top: 10%;
}

.main {
    font-weight: bold;
}
</style>


<template>
    <b-container class="main-container">
        <div class="main-title">
            <h1>Welcome to <span class="main">RateMyMusic</span></h1>
            <p>Your go-to place for music ratings and reviews</p>
        </div>
    </b-container>

    <div>
        <BRow no-gutters>
            <BCol lg="6" class="mb-3 column">

                <h4 class="mb-3">Recent Album Reviews</h4>

                <BContainer style="max-height: 20%; overflow-y: auto;">
                    <BCol v-for="(review, index) in albumReviews" :key="index" class="mb-3">
                        <BCard style="max-width: 50rem; min-height: 20rem;">
                            <small class="text-muted" style="position: absolute; top: 5%; left: 5%;">Album</small>
                            <small class="text-muted" style="position: absolute; top: 5%; right: 5%;">
                                {{ new Date(review.review_date).toLocaleString([], {
                                    year: 'numeric', month: 'numeric',
                                    day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: false
                                })
                                }}</small>
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h2>{{ review.album_name }}</h2>
                                <!-- <span>@{{ review.username }}</span> -->
                                <RouterLink style="text-decoration: none;"
                                    :to="{ name: '/users/[user]', params: { user: review.pid } }">
                                    <span>@{{ review.username }}</span>
                                </RouterLink>
                            </div>


                            <b-card-img style="max-width: 10rem" :src="arrayBufferToBase64(review.cover.data)"
                                alt="Album Cover"></b-card-img>

                            <div class="p-3">
                                <BCardText class="d-flex justify-content-between align-items-center mb-3">{{
                                    review.review_text }}</BCardText>

                                <!-- <div class="d-flex align-items-center">
                                        <button @click="toggleLike(review)" class="btn btn-link upvote-button">
                                            <img v-if="review.isLiked" src="/src/assets/vote.png" alt="Upvoted"
                                                class="upvote-icon-upvoted" />
                                            <img v-else src="/src/assets/vote.png" alt="Upvote" class="upvote-icon" />
                                        </button>
                                        <span class="me-4">{{ review.likes }} </span>
                                    </div> -->

                                <!-- ADD UserReviewLikes and UserCommentLikes tables, so we can store what reviews and comments a user has liked -->
                                <!-- to make sure that review.isLiked work properly -->

                                <!-- <div class="d-flex align-items-center">
                                        <button @click="toggleDislike(review)" class="btn btn-link upvote-button">
                                            <img v-if="review.isLiked" src="/src/assets/vote.png" alt="Downvoted"
                                                class="downvote-icon-downvoted" />
                                            <img v-else src="/src/assets/vote.png" alt="Downvote" class="downvote-icon" />
                                        </button>
                                        <span class="me-4">{{ review.dislikes }} </span>
                                    </div> -->


                                <!-- <BCardFooter>Rating: {{ review.rating}}, {{ renderStars(review.rating) }}</BCardFooter> -->
                                <BCardFooter style="margin-bottom: -5%;"> {{ renderStars(review.rating) }}</BCardFooter>
                            </div>
                        </BCard>
                    </BCol>
                </BContainer>
            </BCol>

            <BCol lg="6" class="mb-3 column">
                <h4 class="mb-3">Recent Song Reviews</h4>

                <BContainer style="max-height: 20%; overflow-y: auto;">

                    <BCol v-for="(review, index) in songReviews" :key="index" class="mb-3">
                        <BCard style="max-width: 50rem; min-height: 20rem;">
                            <small class="text-muted" style="position: absolute; top: 5%; left: 5%;">Song</small>
                            <small class="text-muted" style="position: absolute; top: 5%; right: 5%;">
                                {{ new Date(review.review_date).toLocaleString([], {
                                    year: 'numeric', month: 'numeric',
                                    day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: false
                                })
                                }}</small>
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h2>{{ review.song_name }}</h2>
                                <RouterLink style="text-decoration: none;"
                                    :to="{ name: '/users/[user]', params: { user: review.pid } }">
                                    <span>@{{ review.username }}</span>
                                </RouterLink>
                            </div>

                            <b-card-img style="max-width: 10rem" :src="arrayBufferToBase64(review.cover.data)"
                                alt="Album Cover"></b-card-img>

                            <div class="p-3">
                                <BCardText class="d-flex justify-content-between align-items-center mb-3">{{
                                    review.review_text }}</BCardText>
                                <!-- 
                                    <div class="d-flex align-items-center">
                                        <button @click="toggleLike(review)" class="btn btn-link upvote-button">
                                            <img v-if="review.isLiked" src="/src/assets/vote.png" alt="Upvoted"
                                                class="upvote-icon-upvoted" />
                                            <img v-else src="/src/assets/vote.png" alt="Upvote" class="upvote-icon" />
                                        </button>
                                        <span class="me-4">{{ review.likes }} </span>
                                    </div>

                                    <div class="d-flex align-items-center">
                                        <button @click="toggleDislike(review)" class="btn btn-link upvote-button">
                                            <img v-if="review.isLiked" src="/src/assets/vote.png" alt="Downvoted"
                                                class="downvote-icon-downvoted" />
                                            <img v-else src="/src/assets/vote.png" alt="Downvote" class="downvote-icon" />
                                        </button>
                                        <span class="me-4">{{ review.dislikes }} </span>
                                    </div> -->

                                <!-- <BCardFooter>Rating: {{ review.rating }}</BCardFooter> -->
                                <BCardFooter style="margin-bottom: -5%;"> {{ renderStars(review.rating) }}</BCardFooter>
                            </div>
                        </BCard>
                    </BCol>
                </BContainer>
            </BCol>
        </BRow>
    </div>
</template>