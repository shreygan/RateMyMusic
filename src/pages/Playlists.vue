<script setup lang="ts">

import { sanitizeInput, arrayBufferToBase64 } from "../utils/utils";

const searchTerm = ref("");


async function loadAllPlaylists(){
    let url = "http://localhost:3000/users/getallplaylists";

    if (searchTerm.value) {
        url += `?q=${encodeURIComponent(sanitizeInput(searchTerm.value).trim().toLowerCase())}`;
    } 
    
    const response = await fetch(url);
    console.log(response);
    return response.json();
}

const isLoading = ref(false);
const results = computedAsync(loadAllPlaylists, [], isLoading);
</script>

<template>
  <b-container class="main-container">
            <div class="main-title" style="margin-top: 20%">
                <h1>All Playlists</h1>
            </div>
        </b-container>

        <BFormInput v-model="searchTerm" />

        <BCol v-for="(result, index) in results" :key="index" class="mb-3">
            <BCard style="width: 40vw; margin-top: 10%;">

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <RouterLink :to="{ name: '/users/[pid]/[creationdate]/[playlistname]', params: { pid: result.pid,  creationdate: result.creation_date, playlistname: result.playlist_name } }">
                        <h2>{{ result.playlist_name }}</h2>
                    </RouterLink>
                    <span>@{{ result.username }}</span>
                </div>

                <BCardImg style="width: 32vw;" v-if="result.image" :src="arrayBufferToBase64(result.image.data)"
                    alt=""></BCardImg>
            </BCard>
        </BCol>
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

.filters {
  width: 10rem;
  margin-left: auto;
  margin-right: auto;
}
</style>