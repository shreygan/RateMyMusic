<script setup lang="ts">
import axios from "axios";
import { useUserStore } from "../../composables/userStore";

import { useRoute } from "vue-router";

const { allUsers, currentUser } = useUserStore();

const route = useRoute();

const userpid = computed(() => route.params.createplaylist as string);



interface Song {
    song_name: string;
    song_release_date: string;
    album_name: string;
    song_duration: number;
    cover: any;
}

const playlistData = reactive({
    pid: "",
    playlist_name: "",
    image: "",
    description: "",
    songs: [],
});

async function loadResults() {
    let url = "http://localhost:3000/songs/findsongs";

    if (searchTerm.value) {
        url += `?q=${encodeURIComponent(searchTerm.value.trim().toLowerCase())}`;
    }

    const response = await fetch(url);
    return await response.json();
}


async function insertPlaylist() {
    let url = "http://localhost:3000/users/createplaylist";
    playlistData.pid = userpid.value; 
    playlistData.playlist_name = playlistName.value;
    playlistData.description = description.value;
    playlistData.songs = playlist.value.map((song: Song) => ({
        song_name: song.song_name,
        song_release_date: song.song_release_date
    }));

    const response = await axios.post(url, playlistData);
    console.log(response.data);
}






const searchTerm = ref("");

const description = ref("");
const playlistName = ref("");
const selectedIndices = ref<number[]>([]);
const isLoading = ref(false);
const results = computedAsync(loadResults, [], isLoading);
const playlist = ref<Song[]>([]);

const getReleaseYear = (dateString: string) => {
    const date = new Date(dateString);
    return date.getFullYear();
};

// function getImagePath(name: string) {
//     const url = new URL(`../assets/albums/${name}.jpg`, import.meta.url);
//     return url.href;
// }

function toggleSongSelection(index: number) {
    if (selectedIndices.value.includes(index)) {
        selectedIndices.value = selectedIndices.value.filter((i) => i !== index);
        const removedIndex = playlist.value.findIndex(
            (song) => song.song_name === results.value[index].song_name
        );
        if (removedIndex !== -1) {
            playlist.value.splice(removedIndex, 1);
        }
    } else {
        selectedIndices.value.push(index);

        console.log(results.value[index])

        const selectedSong: Song = {
            song_name: results.value[index].song_name,
            song_release_date: results.value[index].song_release_date,
            album_name: results.value[index].album_name,
            song_duration: results.value[index].duration,
            cover: results.value[index].cover,
        };

        playlist.value.push(selectedSong);
    }
}

function formatDuration(duration: number): string {
    const minutes = Math.floor(duration / 60);
    const seconds = duration % 60;

    return `${minutes}:${seconds < 10 ? "0" : ""}${seconds}`;
}

function getTotalDuration(): number {
    return playlist.value.reduce((acc, song) => acc + song.song_duration, 0);
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
};
</script>

<template>
    <BContainer style="margin-top: 5vh">
        <BRow>
            <BCol>
                <h1>Create a Playlist</h1>
            </BCol>
        </BRow>

        {{ console.log(new Date()) }}

    

        <BRow>
            <BFormInput class="my-4" v-model="searchTerm" placeholder="Search for a song"
                style="max-width: 20rem; margin-right: auto; margin-left: auto" />


            <BContainer class="search-results">
                <BRow>
                    <BCol>
                        <BListGroup>
                            <BListGroupItem v-for="(result, index) in results" :key="index"
                                :active="selectedIndices.includes(index)" @click="toggleSongSelection(index)"
                                style="max-width: 500px">
                                <BRow>
                                    <BCol style="max-width: 10rem" class="my-2">
                                        <BImg :src="arrayBufferToBase64(result.cover.data)"
                                            style="max-block-size: 5rem; border-radius: 0.5rem" />
                                    </BCol>
                                    <BCol class="my-3">
                                        <h3>{{ result.song_name }}</h3>
                                        <h6>
                                            {{ result.album_name }} ({{
                                                getReleaseYear(result.song_release_date)
                                            }}) {{ result.song_duration }}
                                        </h6>
                                    </BCol>
                                </BRow>
                            </BListGroupItem>
                        </BListGroup>
                    </BCol>
                </BRow>
            </BContainer>
        </BRow>
        <BRow>
            <BCol class="my-4">
                <BFormInput class="my-4 playlist-title" v-model="playlistName" v-if="playlist.length > 0"
                    placeholder="Playlist Title" />
                <BFormInput class="my-4 playlist-title" v-model="description" v-if="playlist.length > 0"
                placeholder="Playlist Description" />
                <h4 v-if="playlist.length > 0" style="margin-top: 2rem;">Total Duration: {{
                    formatDuration(getTotalDuration()) }}</h4>
                <BListGroup>
                    <BListGroupItem v-for="song in playlist">
                        <BRow>
                            <BCol style="max-width: 10rem" class="my-2">
                                <BImg :src="arrayBufferToBase64(song.cover.data)"
                                    style="max-block-size: 5rem; border-radius: 0.5rem" />
                            </BCol>
                            <BCol style="margin-top: auto; margin-bottom: auto">
                                <h3>{{ song.song_name }}</h3>
                                <h6>
                                    {{ song.album_name }} ({{
                                        getReleaseYear(song.song_release_date)
                                    }})
                                </h6>
                            </BCol>
                            <BCol style="margin-top: auto; margin-bottom: auto">
                                <h6>
                                    Duration: {{ formatDuration(song.song_duration) }}
                                </h6>
                            </BCol>
                        </BRow>
                    </BListGroupItem>
                </BListGroup>
            </BCol>
        </BRow>

        <BButton style="margin-top: 2%; margin-bottom: -3%;" variant="primary" class="btn-bottom-left"
            @click="insertPlaylist()">Create Playlist </BButton>
    </BContainer>
</template>


<style scoped>

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

.playlist-title {
    font-size: xx-large;
    font-weight: 400;
}
</style>
