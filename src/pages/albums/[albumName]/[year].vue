<script setup lang="ts">
import { BCardTitle } from "bootstrap-vue-next";
import { useRoute } from "vue-router";
import { computed, reactive, onMounted, ref } from 'vue'
import { sanitizeInput, arrayBufferToBase64 } from "../../../utils/utils";

const route = useRoute();

const albumName = computed(() => route.params.albumName as string);
const year = computed(() => route.params.year as string);

async function loadAlbumReviews() {
    let url = "http://localhost:3000/songs/getalbumreviews";
    url += `?q=${encodeURIComponent(albumName.value.trim().toLowerCase())}`;
    url += `&year=${encodeURIComponent(year.value.trim().toLowerCase())}`;

    const response = await fetch(url);
    return await response.json();
}


async function loadAlbumSongs() {
    let url = "http://localhost:3000/songs/getalbumsongs";
    url += `?q=${encodeURIComponent(albumName.value.trim().toLowerCase())}`;
    url += `&year=${encodeURIComponent(year.value.trim().toLowerCase())}`;

    const response = await fetch(url);
    return await response.json();
}

function formatDuration(duration: number): string {
    const minutes = Math.floor(duration / 60);
    const seconds = duration % 60;

    return `${minutes}:${seconds < 10 ? "0" : ""}${seconds}`;
}




const isLoading = ref(false);
const reviews = computedAsync(loadAlbumReviews, [], isLoading);
const songs = computedAsync(loadAlbumSongs, [], isLoading);

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

<template>
    <BCard style="margin-top: 15%; margin-bottom: 10%;">
        <h1>{{ albumName }}</h1>
        <BImg v-if="songs[0]" :src="arrayBufferToBase64(songs[0].cover.data)" style="max-block-size: 40rem;" />
    </BCard>


    <BContainer>
        <BRow>
            <BCol>
                <BListGroup>
                    <BListGroupItem v-for="(song, index) in songs" :key="index" style="width: 40vw">
                        <BRow class="justify-content-end">
                            <BCol style="max-width: 10rem; " class="my-2">
                                <BImg :src="arrayBufferToBase64(song.cover.data)"
                                    style="max-block-size: 5rem; border-radius: 0.5rem" />
                            </BCol>
                            <BCol class="my-3" style="width: 20vw;">
                                <h3>{{ song.song_name }}</h3>
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

    <h2 style="margin-top: 5%;">Album Reviews</h2>

    <BCol>
  
        <BCard v-for="(review, index) in reviews" :key="index" class="my-4">
          <RouterLink style="text-decoration: none; color: black;" :to="{
                            name: '/users/[pid]/[rid]/[type]',
                            params: {
                                pid: review.pid,
                                rid: review.rid,
                                type: 'Album'
                            }
                        }">
            <BCardText>
                <p>Rating: {{ review.rating }}</p>
                <p>Review: {{ review.review_text }}</p>
            </BCardText>
          </RouterLink> 
        </BCard>
 
    </BCol>
</template>
