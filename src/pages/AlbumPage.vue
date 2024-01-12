<script setup lang="ts">
import { sanitizeInput, arrayBufferToBase64 } from "../utils/utils";

async function loadResults() {
    let url = "http://localhost:3000/songs/findalbums";

    if (searchTerm.value) {
        url += `?q=${encodeURIComponent(sanitizeInput(searchTerm.value).trim().toLowerCase())}`;
    }

    const response = await fetch(url);
    return await response.json();
}

const searchTerm = ref("");
const isLoading = ref(false);
const results = computedAsync(loadResults, [], isLoading);

const getReleaseYear = (dateString: string) => {
    const date = new Date(dateString);
    return date.getFullYear();
};
</script>

<template>
    <BContainer class="main-container">
        <div class="main-title" style="margin-top: 5rem; margin-bottom: -1rem;">
            <h1>Albums</h1>
        </div>
    </BContainer>


    <BContainer class="my-4 mb-4 content" style="width: 35rem;">
        <BFormInput v-model="searchTerm" placeholder="Search albums" style="margin-bottom: 2rem;"/>
        <router-link :to="{ path: '/MainPage' }">
            <BButton variant="primary" class="btn-top-right">Click Me</BButton>
        </router-link>

        <BCol v-for="(result, index) in results" :key="index" class="mb-3">
          <RouterLink
                    :to="{ name: '/albums/[albumName]/[year]', params: { albumName: result.album_name, year: result.release_date } }">
                <BCard style="width: 100%" :img-src="arrayBufferToBase64(result.cover.data)">
                    <BCardTitle>{{ result.album_name }} ({{
                        getReleaseYear(result.release_date)
                    }})</BCardTitle>


                    <BCardText>{{ result.name }}</BCardText>
                </BCard>
            </RouterLink>

        </BCol>
    </BContainer>
</template>

<style scoped>
.btn-top-right {
    position: fixed;
    top: 20px;
    right: 20px;
}

.content {
    width: 35rem;
    padding-top: 2rem;
}
</style>
