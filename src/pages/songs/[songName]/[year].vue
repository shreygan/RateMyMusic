<script setup lang="ts">
import { BCardTitle } from "bootstrap-vue-next";
import { useRoute } from "vue-router";
import { arrayBufferToBase64 } from "../../../utils/utils";

const route = useRoute();

const songName = computed(() => route.params.songName as string);


const year = computed(() => route.params.year as string);

async function loadSongAlbum() {
    let url = "http://localhost:3000/songs/getsongalbum";
    url += `?q=${encodeURIComponent(computed(() => route.params.songName as string).value.trim().toLowerCase())}`;
    url += `&year=${encodeURIComponent(computed(() => route.params.year as string).value.trim().toLowerCase())}`;



    const response = await fetch(url);
    return await response.json();
}


// url += `?q=${encodeURIComponent(computed(() => route.params.albumName as string).value.trim().toLowerCase())}`;
// url += `&year=${encodeURIComponent(computed(() => route.params.year as string).value.trim().toLowerCase())}`;

async function loadSongReviews() {
    let url = "http://localhost:3000/songs/getsongreviews";
    url += `?q=${encodeURIComponent((computed(() => route.params.songName as string).value.trim().toLowerCase()))}`;
    url += `&year=${encodeURIComponent(computed(() => route.params.year as string).value.trim().toLowerCase())}`;

    const response = await fetch(url);
    return await response.json();
}

const isLoading = ref(false);
const results = computedAsync(loadSongReviews, [], isLoading);
const songAlbum = computedAsync(loadSongAlbum, [], isLoading);

const songRating = computed(() => {
    if (results.value.length == 0) {
        return 0;
    }

    return (
        results.value.reduce((acc, review) => acc + review.rating, 0) /
        results.value.length
    );
});

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


</script>

<style scoped>
.profile-pic {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    margin-right: 10px;
    filter: drop-shadow(0px 0px 2px black);
}
</style>

<template>
    <BContainer class="main-container" style="width: 35rem;">
        <div class="main-title" style="margin-top: 5rem; margin-bottom: 2rem;">
            <h1> {{ songName }} </h1>
        </div>
    </BContainer>

    <BCardText>{{ songRating.toFixed(1) }}/5 based on {{ results.length }} reviews</BCardText>

    <!-- {{ console.log(songAlbum[0].song_name) }} -->

    <BCard style="margin-bottom: 2rem; width: 35rem;">
        <BImg v-if="songAlbum[0]" :src="arrayBufferToBase64(songAlbum[0].cover.data)" style="width: 100%;" />
    </BCard>

    <BCol style="margin-top: -.35rem;" v-for="(review, index) in results" :key="index" class="mb-3">
        <BCard style="width: 35rem;">
            <small class="text-muted" style="position: absolute; top: 9%; right: 5%;">
                {{ new Date(review.review_date).toLocaleString([], {
                    year: 'numeric', month: 'numeric',
                    day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: false
                })
                }}</small>
            <div class="d-flex justify-content-between align-items-center mb-3">

                <h5>
                    <BImg v-if="review.profile_pic" :src="arrayBufferToBase64(review.profile_pic.data)"
                        class="profile-pic" />
                    <RouterLink style="text-decoration: none;"
                        :to="{ name: '/users/[user]', params: { user: review.pid } }">
                        <span>@{{ review.username }}</span>
                    </RouterLink>
                </h5>
            </div>

            <RouterLink style="text-decoration: none; color: black;" :to="{
                name: '/users/[pid]/[rid]/[type]',
                params: {
                    pid: review.pid,
                    rid: review.rid,
                    type: 'Song'
                }
            }">
                <div>
                    <BCardText class="d-flex justify-content-between align-items-center">{{
                        review.review_text }}</BCardText>

                    <BCardFooter> {{ renderStars(review.rating) }}</BCardFooter>
                </div>
            </RouterLink>
        </BCard>
    </BCol>

    <!-- <BCard style="margin-top: 5rem;">
        <BCardTitle>{{ songName }}</BCardTitle>
    </BCard>

    <BCol>
        <BCard v-for="review in results" class="my-4">
            <BCardText>
                <p>Rating: {{ review.rating }}</p>
                <p>Review: {{ review.review_text }}</p>
            </BCardText>
        </BCard>
    </BCol> -->
</template>
