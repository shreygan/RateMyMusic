<script setup lang="ts">
import { BCardTitle } from "bootstrap-vue-next";
import { useRoute } from "vue-router";
import { computed, reactive, onMounted, ref } from 'vue'
import { sanitizeInput, arrayBufferToBase64 } from "../../../utils/utils";

const route = useRoute();



async function loadAlbumReviews() {
    let url = "http://localhost:3000/songs/getalbumreviews";
    url += `?q=${encodeURIComponent(computed(() => route.params.albumName as string).value.trim().toLowerCase())}`;
    url += `&year=${encodeURIComponent(computed(() => route.params.year as string).value.trim().toLowerCase())}`;

    const response = await fetch(url);
    return await response.json();
}

async function loadAlbumSongs() {
    // console.log("DFGJNDFKJNGDKFJGNDKFJN");
    // console.log(computed(() => route.params.albumName as string).value.trim().toLowerCase());
    // console.log(year.value.trim().toLowerCase());

    let url = "http://localhost:3000/songs/getalbumsongs";
    url += `?q=${encodeURIComponent(computed(() => route.params.albumName as string).value.trim().toLowerCase())}`;
    url += `&year=${encodeURIComponent(computed(() => route.params.year as string).value.trim().toLowerCase())}`;

    const response = await fetch(url);
    return await response.json();
}

function formatDuration(duration: number): string {
    const minutes = Math.floor(duration / 60);
    const seconds = duration % 60;

    return `${minutes}:${seconds < 10 ? "0" : ""}${seconds}`;
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
const reviews = computedAsync(loadAlbumReviews, [], isLoading);
const songs = computedAsync(loadAlbumSongs, [], isLoading);

const albumName = computed(() => route.params.albumName as string);
const year = computed(() => route.params.year as string);

const selectedFilter = ref("Songs"); // Default filter
const filterOptions = ["Songs", "Reviews"];

const albumRating = computed(() => {
    if (reviews.value.length == 0) {
        return 0;
    }

    return (
        reviews.value.reduce((acc, review) => acc + review.rating, 0) /
        reviews.value.length
    );
});
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
        <div class="main-title" style="margin-top: 5rem; margin-bottom: 3rem;">
            <h1> {{ albumName }} </h1>
        </div>
    </BContainer>


    <BCard style="margin-bottom: 1rem; width: 35rem;">
        <BImg v-if="songs[0]" :src="arrayBufferToBase64(songs[0].cover.data)" style="width: 100%;" />
    </BCard>

    <BCol class="mb-4">
        <BFormSelect v-model="selectedFilter" class="mr-2" style="width: 35rem;">
            <option v-for="filter in filterOptions" :key="filter" :value="filter">
                {{ filter }}
            </option>
        </BFormSelect>
    </BCol>

    <BContainer style="margin-top: -.35rem;" v-if="selectedFilter == 'Songs'">
        <BRow>
            <BCol>
                <BListGroup>
                    <BListGroupItem v-for="(song, index) in songs" :key="index" style="width: 33.4rem">
                        <BRow class="justify-content-end">
                            <small class="text-muted" style="position: absolute; top: 42%; left: -45.5%;"> {{ index + 1 }}
                            </small>
                            <!-- <BCol style="max-width: -2rem;" class="d-flex align-items-center">
                                <p>{{ index + 1 }}</p>
                            </BCol> -->
                            <BCol style="max-width: 10rem; " class="my-2">
                                <BImg :src="arrayBufferToBase64(song.cover.data)"
                                    style="max-block-size: 4rem; border-radius: 0.5rem" />
                            </BCol>
                            <BCol class="my-3" style="width: 20vw;">
                                <RouterLink
                                    :to="{ name: '/songs/[songName]/[year]', params: { songName: song.song_name, year: song.song_release_date } }">
                                    <h5 class="align-self-start mb-0">{{ song.song_name }}</h5>
                                </RouterLink>
                            </BCol>
                            <BCol style="margin-top: 3vh;">
                                <h6> {{ formatDuration(song.duration) }}</h6>
                            </BCol>
                        </BRow>
                    </BListGroupItem>
                </BListGroup>
            </BCol>
        </BRow>
    </BContainer>

    <!-- <h2 style="margin-top: 3rem;">Album Reviews</h2> -->

    <BCol style="margin-top: -.35rem;" v-if="selectedFilter == 'Reviews'" v-for="(review, index) in reviews" :key="index"
        class="mb-3">
        <BCard style="width: 35rem;">
            <small class="text-muted" style="position: absolute; top: 7%; right: 5%;">
                {{ new Date(review.review_date).toLocaleString([], {
                    year: 'numeric', month: 'numeric',
                    day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: false
                })
                }}</small>
            <div class="d-flex justify-content-between align-items-center mb-3">
                <!-- <h2>{{ review.album_name }}</h2> -->
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
                    type: 'Album'
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
</template>
