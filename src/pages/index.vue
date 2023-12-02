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

                            {{ console.log(review) }}

                            <b-card-img v-if="review.cover" style="max-width: 10rem" :src="arrayBufferToBase64(review.cover.data)"
                                alt="Album Cover"></b-card-img>

                            <div class="p-3">
                                <BCardText class="d-flex justify-content-between align-items-center mb-3">{{
                                    review.review_text }}</BCardText>
                                <BCardFooter style="margin-bottom: -5%;"> {{ renderStars(review.rating) }}</BCardFooter>
                            </div>
                        </BCard>
                    </BCol>
                </BContainer>
            </BCol>
        </BRow>
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