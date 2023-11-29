<script setup lang="ts">
import axios from "axios";

import { useUserStore } from "../composables/userStore";
const { allUsers, currentUser } = useUserStore();

const searchTerm = ref("");
const artist = ref("");
const useFilters = ref(false);

async function loadAllUserCharts(){
    if(useFilters.value){
        let url = "http://localhost:3000/users/getalluserchartsfiltered";


        if (artist.value) {
            url += `?q=${encodeURIComponent(artist.value.trim().toLowerCase())}`;
        }

        const response = await fetch(url);
        const data = await response.json();
        return data;

    }else{
        let url = "http://localhost:3000/users/getallusercharts";

        if (searchTerm.value) {
            url += `?q=${encodeURIComponent(searchTerm.value.trim().toLowerCase())}`;
        }

        const response = await fetch(url);
        const data = await response.json();
        return data;
    }
}

interface Artist {
    artist_name: string;
    artist_id: number;
}

const isLoading = ref(false);
const results = computedAsync(loadAllUserCharts, [], isLoading);
const defaultArtist: Artist = { artist_name: "", artist_id: 0 };
const selectedArtist = ref<Artist>(defaultArtist);


function toggleSongSelection(index: number) {

const isSelected = playlist.value.some(
  (song) => song.song_name === results.value[index].song_name
);

if (isSelected) {
  // Song is already selected, remove it
  const removedIndex = playlist.value.findIndex(
    (song) => song.song_name === results.value[index].song_name
  );
  if (removedIndex !== -1) {
    playlist.value.splice(removedIndex, 1);
  }
} else {
  // Song is not selected, add it
  const artist: Song = {
    song_name: results.value[index].song_name,
    song_release_date: results.value[index].song_release_date,
    album_name: results.value[index].album_name,
    song_duration: results.value[index].duration,
    cover: results.value[index].cover,
  };
  
  

  ;
}
}

const selectedSongs = ref<number[]>([]);

function isSongSelected(song: Song): boolean {
  return playlist.value.some(
    (selectedSong) => selectedSong.song_name === song.song_name
  );
}

</script>

<script lang="ts">
export default {
    methods: {
        arrayBufferToBase64(buffer: number[]) {
            var binary = '';
            var bytes = new Uint8Array(buffer);
            var len = bytes.byteLength;
            for (var i = 0; i < len; i++) {
                binary += String.fromCharCode(bytes[i]);
            }
            return 'data:image/jpeg;base64,' + window.btoa(binary);
        }
    },
}
</script>

<template>
  <b-container class="main-container">
            <div class="main-title" style="margin-top: 20%">
                <h1>All UserCharts</h1>
            </div>
        </b-container>


        <BCard border-variant="success">
        <div class="filters">
            <BFormCheckbox class="mr-2" v-model="useFilters">Use Filters</BFormCheckbox>
        </div>

        <BCardTitle> Filters </BCardTitle>

        <!-- <p class="text-left"> Find all users who have reviewed all </p> -->

        <BCol v-if="useFilters" class="mb-4">
            <h4>Find User Charts that contain all artist Albums:</h4>
            <BFormInput v-model="artist" style="margin-top: 3vh;" />
        </BCol>

    </BCard>





        <BFormInput v-model="searchTerm" style="margin-top: 3vh;" />

        <BCol v-for="(result, index) in results" :key="index" class="mb-3">
            {{ console.log(result) }}
            <BCard style="width: 40vw; margin-top: 10%;">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <RouterLink :to="{ name: '/users/[pid]/[ucid]', params: { pid: result.pid, ucid: result.ucid } }">
                        <h2>{{ result.userchart_name }}</h2>
                    </RouterLink>
                    <span>@{{ result.username }}</span>
                </div>

                <BCardImg style="width: 32vw;" v-if="result.image" :src="arrayBufferToBase64(result.image.data)"
                    alt="Album Cover"></BCardImg>
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
