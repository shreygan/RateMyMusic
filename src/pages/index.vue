<script setup lang="ts">
// import { defineComponent } from 'vue';

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

<template>
    <div style="max-height: 95vh; overflow: hidden;">
        <BContainer class="main-container">
            <div class="main-title">
                <h1>Welcome to <span class="main">RateMyMusic</span></h1>
                <p>Your go-to place for music ratings and reviews</p>
            </div>
        </BContainer>

        <div>
            <BRow no-gutters>
                <BCol lg="6" class="mb-3 column">

                    <h4 class="mb-3">Recent Album Reviews</h4>

                    <BContainer style="max-height: 50vh; overflow-y: auto;">
                        <BCol v-for="(review, index) in albumReviews" :key="index" class="mb-3">
                            <BCard style="width: 32.5rem; min-height: 20rem;">
                                <small class="text-muted" style="position: absolute; top: 5%; left: 5%;">Album</small>
                                <small class="text-muted" style="position: absolute; top: 5%; right: 5%;">
                                    {{ new Date(review.review_date).toLocaleString([], {
                                        year: 'numeric', month: 'numeric',
                                        day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: false
                                    })
                                    }}</small>
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <RouterLink style="text-decoration: none; color: inherit;"
                                        :to="{ name: '/albums/[albumName]/[year]', params: { albumName: review.album_name, year: review.release_date } }">
                                        <h2>{{ review.album_name }}</h2>
                                    </RouterLink>
                                    <RouterLink style="text-decoration: none;"
                                        :to="{ name: '/users/[user]', params: { user: review.pid } }">
                                        <span>@{{ review.username }}</span>
                                    </RouterLink>
                                </div>

                                <RouterLink style="text-decoration: none; color: black;" :to="{
                                    name: '/users/[pid]/[rid]/[type]',
                                    params: {
                                        pid: review.pid,
                                        rid: review.rid,
                                        type: 'Album'
                                    }
                                }">

                                    <b-card-img style="max-width: 10rem" :src="arrayBufferToBase64(review.cover.data)"
                                        alt="Album Cover"></b-card-img>

                                    <div class="p-3">
                                        <BCardText class="d-flex justify-content-between align-items-center mb-3">{{
                                            review.review_text }}</BCardText>

                                        <BCardFooter style="margin-bottom: -5%;"> {{ renderStars(review.rating) }}
                                        </BCardFooter>
                                    </div>
                                </RouterLink>
                            </BCard>
                        </BCol>
                    </BContainer>
                </BCol>

                <BCol lg="6" class="mb-3 column">
                    <h4 class="mb-3">Recent Song Reviews</h4>

                    <BContainer style="max-height: 50vh; overflow-y: auto;">

                        <BCol v-for="(review, index) in songReviews" :key="index" class="mb-3">
                            <BCard style="width: 32.5rem; min-height: 20rem;">
                                <small class="text-muted" style="position: absolute; top: 5%; left: 5%;">Song</small>
                                <small class="text-muted" style="position: absolute; top: 5%; right: 5%;">
                                    {{ new Date(review.review_date).toLocaleString([], {
                                        year: 'numeric', month: 'numeric',
                                        day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: false
                                    })
                                    }}</small>
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <!-- <h2>{{ review.song_name }}</h2> -->
                                    <RouterLink style="text-decoration: none; color: inherit;"
                                        :to="{ name: '/songs/[songName]/[year]', params: { songName: review.song_name, year: review.release_date } }">
                                        <h2>{{ review.song_name }}</h2>
                                    </RouterLink>
                                    <RouterLink style="text-decoration: none;"
                                        :to="{ name: '/users/[user]', params: { user: review.pid } }">
                                        <span>@{{ review.username }}</span>
                                    </RouterLink>
                                </div>

                                <RouterLink style="text-decoration: none; color: black;" :to="{
                                    name: '/users/[pid]/[rid]/[type]',
                                    params: {
                                        pid: review.pid,
                                        rid: review.rid,
                                        type: 'Song'
                                    }
                                }">

                                    <b-card-img v-if="review.cover" style="max-width: 10rem"
                                        :src="arrayBufferToBase64(review.cover.data)" alt="Album Cover"></b-card-img>

                                    <div class="p-3">
                                        <BCardText class="d-flex justify-content-between align-items-center mb-3">{{
                                            review.review_text }}</BCardText>
                                        <BCardFooter style="margin-bottom: -5%;"> {{ renderStars(review.rating) }}
                                        </BCardFooter>
                                    </div>
                                </RouterLink>
                            </BCard>
                        </BCol>
                    </BContainer>
                </BCol>
            </BRow>
        </div>
    </div>
</template>

<style scoped>
.main-title {
    text-align: center;
    margin: 0;
    padding-bottom: 2%;
    margin-top: 10%;
}

.main {
    font-weight: bold;
}
</style>