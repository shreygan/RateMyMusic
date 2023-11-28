<script setup lang="ts">
import { useUserStore } from "../../composables/userStore";
import axios from "axios";

import { useRoute } from "vue-router";

const { allUsers, currentUser } = useUserStore();

const route = useRoute();

const userpid = computed(() => route.params.createuserchart as string);


async function loadResults() {
    let url = "http://localhost:3000/songs/findalbums";

    if (searchTerm.value) {
        url += `?q=${encodeURIComponent(searchTerm.value.trim().toLowerCase())}`;
    }

    const response = await fetch(url);
    return await response.json();
}

const searchTerm = ref("");
const selectedIndices = ref<number[]>([]);
const selectedAlbums = ref<any[]>([]);
const isLoading = ref(false);
const results = computedAsync(loadResults, [], isLoading);

const getReleaseYear = (dateString) => {
    const date = new Date(dateString);
    return date.getFullYear();
};

interface Album {
    album_name: string;
    release_date: Date;
}

const UCData = reactive({
    pid: "",
    title: "",
    albums: [],
    image: "",
});



async function insertUserChart() {
    let url = "http://localhost:3000/users/insertuserchart";
    UCData.title = ucTitle.value;
    UCData.albums = selectedAlbums.value;
    UCData.image = "";
    UCData.pid = userpid.value;
    console.log(UCData);
    const response = await axios.post(url, UCData);
    console.log(response.data);

}

const ucTitle = ref("");

async function toggleAlbumSelection(index: number) {
    if (selectedIndices.value.includes(index)) {
        selectedIndices.value = selectedIndices.value.filter((i) => i !== index);
        const removedIndex = selectedAlbums.value.findIndex(
            (album) => album.album_name === results.value[index].album_name
        );
        if (removedIndex !== -1) {
            selectedAlbums.value.splice(removedIndex, 1);
        }
    } else {
        selectedIndices.value.push(index);

        const album: Album = {
            album_name: results.value[index].album_name,
            release_date: results.value[index].release_date,
        };
        selectedAlbums.value.push(album);
    }

}

function __arrayBufferToBase64(buffer: number[]) {
    var binary = '';
    var bytes = new Uint8Array(buffer);
    var len = bytes.byteLength;
    for (var i = 0; i < len; i++) {
        binary += String.fromCharCode(bytes[i]);
    }
    return 'data:image/jpeg;base64,' + window.btoa(binary);
}

const selectedAlbumCovers = computed(() => {
    const covers = Array(9).fill('https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Square_gray.svg/2048px-Square_gray.svg.png');

    selectedIndices.value.forEach((index, i) => {
        if (i < 9) {
            covers[i] = results.value[index];
            covers[i] = __arrayBufferToBase64(results.value[index].cover.data);
        }

        console.log(selectedAlbums.value);
    });

    return covers;
});

const gridAlbums = computed(() => {
    const albums = Array(9).fill('https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Square_gray.svg/2048px-Square_gray.svg.png');

    selectedIndices.value.forEach((index, i) => {
        if (i < 9) {
            // covers[i] = results.value[index];
            // covers[i] = __arrayBufferToBase64(results.value[index].cover.data);
            albums[i] = results.value[index];
        }
    });

    return albums;
});

function getGridImage(index: number) {
    return selectedAlbumCovers.value[index];
}

function getGridAlbum(index: number) {
    return gridAlbums.value[index];
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
    <BContainer style="margin-top: 10rem">
        <BRow>
            <BCol>
                <h1>Create a Chart</h1>
            </BCol>
        </BRow>

        <BFormInput class="my-4" v-model="ucTitle" placeholder="Title of UserChart"
            style="max-width: 20rem; margin-right: auto; margin-left: auto;" />

        <BRow>
            <BFormInput class="my-4" v-model="searchTerm" placeholder="Search for an Album to Add"
                style="max-width: 20rem; margin-right: auto; margin-left: auto;" />

            <BContainer class="search-results">
                <BRow style="max-width: 800px;">
                    <BCol v-for="(result, index) in results" :key="index" class="my-3">
                        <BCard style="width: 100%" class="search-item" :img-src="arrayBufferToBase64(result.cover.data)"
                            @click="toggleAlbumSelection(index)"
                            :bg-variant="selectedIndices.includes(index) ? 'primary' : 'secondary'">

                            <h3 style="color: white;">
                                {{ result.album_name }} ({{
                                    getReleaseYear(result.release_date)
                                }})
                            </h3>
                        </BCard>
                    </BCol>
                </BRow>
            </BContainer>
        </BRow>

        <BRow v-for="row in 3" :key="row" class="grid-row my-4 mx-4">
            <BCol v-for="col in 3" :key="col" class="grid-col">
                <div class="position-relative">
                    <BImg class="chartImg" :src="getGridImage((row - 1) * 3 + (col - 1))" />
                    <h5 class="album-name">
                        {{ getGridAlbum((row - 1) * 3 + (col - 1)).album_name }}
                    </h5>
                </div>
                <div class="grid-item"></div>
            </BCol>
        </BRow>

        <BButton style="margin-top: 2%; margin-bottom: -3%;" variant="primary" class="btn-bottom-left"
            @click="insertUserChart()">Create User Chart </BButton>



    </BContainer>
</template>

<style scoped>
.chartImg {
    max-width: 15rem;
    max-height: 15rem;
}

.grid-row {
    display: flex;
}

.grid-col {
    flex: 1;
}

.search-item {
    /* width: 20rem; */
    max-width: 20rem;
    min-width: 20rem;
}

.search-results {
    max-height: 50vh;
    overflow-y: auto;
    max-width: 40vw;
}

.position-relative {
  position: relative;
}

.chartImg {
  transition: filter 0.3s;
}

.chartImg:hover {
  filter: brightness(50%); /* Adjust the percentage to control the darkness */
}

.album-name {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: white; /* Set the text color to be visible against the darker background */
  opacity: 0;
  transition: opacity 0.3s;
}

.chartImg:hover + .album-name, .album-name:hover {
  opacity: 1;
}
</style>