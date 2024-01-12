<script setup lang="ts">

import { sanitizeInput, arrayBufferToBase64 } from "../utils/utils";

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
}, { immediate: true });


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


function toggleArtistSelection(artistSelection: Artist) {
    selectedArtist.value = artistSelection;
    loadAllUserCharts();
}
</script>

<template>
    <b-container class="main-container">
        <div class="main-title" style="margin-top: 5rem;">
            <h1>UserCharts</h1>
        </div>
    </b-container>

    <BCard border-variant="success" style="margin-top: 2.5rem; width: 35rem;">
        <BCardTitle style="margin-top: -1rem;"> Filters </BCardTitle>

        <div class="filters">
            <BFormCheckbox class="mr-2" v-model="useFilters">Use Filters</BFormCheckbox>
        </div>


        <BCol v-if="useFilters" class="mb-4" style="margin-top: 1rem;">
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

    <BCol v-for="(result, index) in results" :key="index" class="mb-3" style="width: 35rem;">
        <BCard style="width: 100%; margin-top: 5%">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <RouterLink :to="{
                    name: '/users/[pid]/[ucid]',
                    params: { pid: result.pid, ucid: result.ucid },
                }">
                    <h2>{{ result.userchart_name }}</h2>
                </RouterLink>
                <RouterLink style="text-decoration: none;"
                    :to="{ name: '/users/[user]', params: { user: result.pid } }">
                    <span>@{{ result.username }}</span>
                </RouterLink>
            </div>

            {{ console.log(result.image) }}

            <BCardImg style="width: 100%;" v-if="result.image && result.image.data.length > 0" :src="arrayBufferToBase64(result.image.data)"
                alt="UserChart Image"></BCardImg>
        </BCard>
    </BCol>
</template>


<style scoped>
.btn-top-right {
    position: fixed;
    top: 20px;
    right: 20px;
}

.search-item {
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
