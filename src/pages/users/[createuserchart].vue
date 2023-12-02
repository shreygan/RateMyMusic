<script setup lang="ts">
import axios from "axios";

import { useRoute } from "vue-router";
import { useToast } from "vue-toastification";
import { sanitizeInput, arrayBufferToBase64 } from "../../utils/utils";


const route = useRoute();

const userpid = computed(() => route.params.createuserchart as string);

async function loadResults() {
    let url = "http://localhost:3000/songs/findalbums";

    if (searchTerm.value) {
        url += `?q=${encodeURIComponent(sanitizeInput(searchTerm.value).trim().toLowerCase())}`;
    }

    const response = await fetch(url);
    return await response.json();
}

const searchTerm = ref("");
const selectedIndices = ref<number[]>([]);
const selectedAlbums = ref<any[]>([]);
const isLoading = ref(false);
const results = computedAsync(loadResults, [], isLoading);

const getReleaseYear = (dateString: string) => {
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
    const toast = useToast();
    let url = "http://localhost:3000/users/insertuserchart";
    UCData.title = sanitizeInput(ucTitle.value);
    UCData.albums = selectedAlbums.value;
    UCData.image = "";
    UCData.pid = userpid.value;

    console.log(selectedAlbums.value);
    console.log(UCData.albums);

    var failed = false;
    if (UCData.title === '') {
        toast.error("Please enter a title");
        failed = true;
    }
    if (UCData.albums.length === 0) {
        toast.error("Please select at least 1 album");
        failed = true;
    }

    if (failed) return;


    console.log(UCData);
    try {
        const response = await axios.post(url, UCData);
        console.log(response.data);
        toast.success("User Chart Created Successfully");
    } catch (error) {
        toast.error("User Chart Creation Failed");
    }
}

const ucTitle = ref("");

async function toggleAlbumSelection(album: Album) {
    console.log(album);
    const selectedAlbum = UCData.albums.find(
        (a: Album) => a.album_name === album.album_name
    );

    if (selectedAlbum) {
        const removedIndex = UCData.albums.indexOf(selectedAlbum);
        if (removedIndex !== -1) {
            UCData.albums.splice(removedIndex, 1);
        }
    } else {
        const albumToSelect: Album = {
            album_name: album.album_name,
            release_date: album.release_date,
        };
        selectedAlbums.value.push(albumToSelect);
        UCData.albums.push(album);
    }
}

function isAlbumSelected(album: Album): boolean {
    return UCData.albums.some((a) => a.album_name === album.album_name);
}

const selectedAlbumCovers = computed(() => {
    const covers = Array(9).fill(
        "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Square_gray.svg/2048px-Square_gray.svg.png"
    );

    UCData.albums.forEach((album, i) => {
        if (i < 9) {
            const result = results.value.find((resultAlbum) => resultAlbum.album_name === album.album_name);

            covers[i] = result ? arrayBufferToBase64(result.cover.data) : covers[i];
        }
    });

    return covers;
});

const gridAlbums = computed(() => {
    const albums = Array(9).fill(
        "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Square_gray.svg/2048px-Square_gray.svg.png"
    );

    selectedIndices.value.forEach((index, i) => {
        if (i < 9) {
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

<template>
    <BContainer style="margin-top: 10rem">
        <BRow>
            <BCol>
                <h1>Create a Chart</h1>
            </BCol>
        </BRow>

        <BFormInput class="my-4" v-model="ucTitle" placeholder="Title of UserChart" style="
        max-width: 20rem;
        margin-right: auto;
        margin-left: auto;
        font-size: large;
      " />

        <BRow>
            <BCol>
                <BFormInput class="my-4" v-model="searchTerm" placeholder="Search for an Album to Add"
                    style="max-width: 20rem; margin-right: auto; margin-left: auto" />

                <BContainer class="search-results">
                    <BRow>
                        <BCol>
                            <BListGroup>
                                <BListGroupItem v-for="(result, index) in results" :key="index"
                                    :active="isAlbumSelected(result)" @click="toggleAlbumSelection(result)"
                                    style="max-width: 500px">
                                    <BRow>
                                        <BCol style="max-width: 10rem" class="my-2">
                                            <BImg :src="arrayBufferToBase64(result.cover.data)"
                                                style="max-block-size: 5rem; border-radius: 0.5rem" />
                                        </BCol>
                                        <BCol class="my-3">
                                            <h3>
                                                {{ result.album_name }} ({{
                                                    getReleaseYear(result.release_date)
                                                }})
                                            </h3>
                                        </BCol>
                                    </BRow>
                                </BListGroupItem>
                            </BListGroup>
                        </BCol>
                    </BRow>
                </BContainer>
            </BCol>
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

        <BButton style="margin-top: 2%; margin-bottom: -3%" variant="primary" size="lg" class="btn-bottom-left"
            @click="insertUserChart()">Create User Chart
        </BButton>
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
    max-width: 15rem;
    min-width: 15rem;
}

.search-results {
    max-height: 250px;
    overflow-y: auto;
    max-width: 500px;
}

.position-relative {
    position: relative;
}

.chartImg {
    transition: filter 0.3s;
    border-radius: 0.5rem;
}

.chartImg:hover {
    filter: brightness(50%);
}

.album-name {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    color: white;
    opacity: 0;
    transition: opacity 0.3s;
}

.chartImg:hover+.album-name,
.album-name:hover {
    opacity: 1;
}
</style>
