<script setup lang="ts">
import axios from "axios";

import { useUserStore } from "../composables/userStore";
import { sanitizeInput, arrayBufferToBase64 } from "../utils/utils";
const { allUsers, currentUser } = useUserStore();

const searchTerm = ref("");

const useFilters = ref(false);

async function loadAllUserCharts() {
    if (useFilters.value) {
        let url = "http://localhost:3000/users/getalluserchartsfiltered";
        if (selectedArtist.value?.pid) {
            url += `?q=${encodeURIComponent(selectedArtist.value.pid)}`;
        }

        const response = await fetch(url);
        const data = await response.json();
        return data;
    } else {
        let url = "http://localhost:3000/users/getallusercharts";

        if (searchTerm.value) {
            url += `?q=${encodeURIComponent(sanitizeInput(searchTerm.value).trim().toLowerCase())}`;
        }

        const response = await fetch(url);
        const data = await response.json();
        return data;
    }
}


watch(useFilters, async () => {
    await loadAllUserCharts();
}, { immediate: true }); // The { immediate: true } option calls the function immediately on setup


async function loadAllArtists() {
    let url = "http://localhost:3000/users/getallartists";

    if (searchTerm.value && !selectedArtist.value) {
        url += `?q=${encodeURIComponent(selectedArtist.value.name.trim().toLowerCase())}`;
    }

    const response = await fetch(url);
    const data = await response.json();
    return data;
}


interface Artist {
    name: string;
    pid: string;
}

const allArtists = computedAsync(loadAllArtists, []);
const isLoading = ref(false);
const results = computedAsync(loadAllUserCharts, [], isLoading);
const selectedArtist = ref<Artist | null>(null);

// function isArtistSelected(artist: Artist): boolean {
//     return artists.value.some(
//         (selectedSong) => selectedSong.artist_name === artist.artist_name
//     );
// }

function toggleArtistSelection(artistSelection: Artist) {
    selectedArtist.value = artistSelection;
    loadAllUserCharts();
}
</script>

<template>
    <b-container class="main-container">
        <div class="main-title" style="margin-top: 20%; margin-bottom: 10%;">
            <h1>All UserCharts</h1>
        </div>
    </b-container>

    <BCard border-variant="success" style="margin-top: 5%;">
        <BCardTitle style="margin-top: -5%;"> Filters </BCardTitle>

        <div class="filters">
            <BFormCheckbox class="mr-2" v-model="useFilters">Use Filters</BFormCheckbox>
        </div>


        <BCol v-if="useFilters" class="mb-4" style="margin-top: 2%;">
            <p>Find all UserCharts that contain all albums by:</p>
        </BCol>
        <BContainer v-if="useFilters" class="search-results">
            <BRow>
                <BCol>
                    <BListGroup>
                        <BListGroupItem v-for="(result, index) in allArtists" :key="index"
                            :active="result.name === selectedArtist?.name" @click="toggleArtistSelection(result)"
                            style="max-width: 500px">
                            <BRow>
                                <BCol style="max-width: 10rem" class="my-2">
                                    <BImg :src="arrayBufferToBase64(result.artist_pic.data)"
                                        style="max-block-size: 5rem; border-radius: 0.5rem" />
                                </BCol>
                                <BCol class="my-3">
                                    <h3>{{ result.name }}</h3>
                                </BCol>
                            </BRow>
                        </BListGroupItem>
                    </BListGroup>
                </BCol>
            </BRow>
        </BContainer>
    </BCard>

    <BFormInput v-model="searchTerm" style="margin-top: 3vh" placeholder="Search UserCharts" />

    <BCol v-for="(result, index) in results" :key="index" class="mb-3">
        <BCard style="width: 40vw; margin-top: 5%">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <RouterLink :to="{
                    name: '/users/[pid]/[ucid]',
                    params: { pid: result.pid, ucid: result.ucid },
                }">
                    <h2>{{ result.userchart_name }}</h2>
                </RouterLink>
                <span>@{{ result.username }}</span>
            </div>

            {{ console.log(result.image) }}

            <BCardImg style="width: 32vw" v-if="result.image && result.image.data.length > 0" :src="arrayBufferToBase64(result.image.data)"
                alt="UserChart Image"></BCardImg>
        </BCard>
    </BCol>
</template>

<style scoped>
/* Custom styling for the button in the top right corner */
.btn-top-right {
    position: fixed;
    top: 20px;
    right: 20px;
}

.search-item {
    /* width: 20rem; */
    max-width: 15rem;
    min-width: 15rem;
}

.search-results {
    max-height: 250px;
    overflow-y: auto;
    max-width: 500px;
}


.content {
    width: 35rem;
    padding-top: 2rem;
}

.filters {
    width: 10rem;
    margin-left: auto;
    margin-right: auto;
}
</style>
