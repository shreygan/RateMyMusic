<script setup lang="ts">
import axios from "axios";
import { sanitizeInput, arrayBufferToBase64 } from "../utils/utils";
// const { allUsers, currentUser } = useUserStore();

async function loadAllSongs() {
    let url = "http://localhost:3000/songs/findsongs";

    if (useAdvancedFilters.value) {
        let url = "http://localhost:3000/songs/advancedfiltersongs";
        const response = await axios.post(url, {
            topSongsNumber: topSongsNumber.value,
            ratingComparison: ratingComparison.value,
            ratingValue: ratingValue.value,
        });
        console.log(response.data);
        return response.data;
    } else if (useFilters.value) {
        return axios.post(
            `http://localhost:3000/songs/filtersongs`,
            filters,
        ).then(response => response.data);
    }
   
    if (filters.searchTerm) {
        url += `?q=${encodeURIComponent(sanitizeInput(filters.searchTerm).trim().toLowerCase())}`;
    }
    
    return axios.get(url).then(response => response.data);
}

async function getAllGenres() {
    let url = "http://localhost:3000/songs/getallgenres";

    const response = await fetch(url);
    return await response.json();
}

const useFilters = ref(false);

const filters = reactive({
    searchTerm: "",
    startDate: "",
    endDate: "",
    selectedGenre: "All",
    isSingle: false,
    minDuration: 0,
    maxDuration: 20,
});

const useAdvancedFilters = ref(false);

const advancedFilters = reactive({
    topSongsNumber: '0',
    ratingComparison: ">",
    ratingValue: '0',
});

const { searchTerm, startDate, endDate, selectedGenre, isSingle, minDuration, maxDuration } = toRefs(filters);
const { topSongsNumber, ratingComparison, ratingValue } = toRefs(advancedFilters);

const isLoading = ref(false);
const results = computedAsync(loadAllSongs, [], isLoading);

const getReleaseYear = (dateString: string) => {
    const date = new Date(dateString);
    return date.getFullYear();
};

interface GenreObject {
    Genre: string;
}

const genreOptions = ref(["All"]);

onMounted(async () => {
    const genres = await getAllGenres();
    console.log(genres);
    genreOptions.value = [
        "All",
        ...genres.map((genreObj: GenreObject) => genreObj.Genre),
    ];
});

// function getImagePath(name: string) {
//     const url = new URL(`../assets/albums/${name}.jpg`, import.meta.url)
//     return url.href
// }
</script>

<template>
    <BContainer class="my-4 mb-4 content">
        <BCard border-variant="success">
            <BCardTitle> Filters </BCardTitle>

            <div class="filters">
                <BFormCheckbox class="mr-2" v-model="useFilters">Use Filters</BFormCheckbox>
            </div>

            <BCardBody v-if="useFilters">
                <h5>Release Date Range</h5>
                <BFormInput v-model="startDate" type="date" placeholder="Start Date" />
                <BFormInput v-model="endDate" type="date" placeholder="End Date" />

                <h5>Genre</h5>
                <BFormSelect v-model="selectedGenre" :options="genreOptions" placeholder="Select Genre" />

                <h5>Type</h5>
                <BFormCheckbox v-model="isSingle">Singles Only</BFormCheckbox>

                <h5>Duration Range</h5>
                <p>Min Duration: {{ minDuration }} minutes</p>
                <BFormInput type="range" v-model.number="minDuration" min="0" max="20" step="0.25" :debounce="500" />

                <p>Max Duration: {{ maxDuration }} minutes</p>
                <BFormInput type="range" v-model.number="maxDuration" min="0" max="20" step="0.25" :debounce="500" />
            </BCardBody>

            <BCardTitle>Advanced Filters</BCardTitle>

            <div class="filters">
                <BFormCheckbox v-model="useAdvancedFilters">Use Advanced Filters</BFormCheckbox>
            </div>

            <BCardBody v-if="useAdvancedFilters">
                <div class="mb-3">
                    <label class="form-label">Get top</label>
                    <BFormInput v-model="topSongsNumber" type="number" placeholder="" />
                </div>
                <div class="mb-3">
                    <label class="form-label">songs by genre, with average song rating</label>
                    <BFormSelect v-model="ratingComparison" :options="['>', '<', '>=', '<=']" />
                    <BFormInput v-model="ratingValue" type="number" placeholder="" />
                </div>
            </BCardBody>
        </BCard>

        <BFormInput class="my-4" v-model="searchTerm" placeholder="Search for a song" />
        <BCol v-for="(result, index) in results" :key="index" class="mb-3">
            <BCard style="width: 100%" :img-src="arrayBufferToBase64(result.cover.data)">
                <RouterLink
                    :to="{ name: '/songs/[songName]/[year]', params: { songName: result.song_name, year: result.song_release_date } }">
                    <h2>
                        {{ result.song_name }} ({{
                            getReleaseYear(result.song_release_date)
                        }})
                    </h2>
                </RouterLink>
                <router-link to="/AlbumPage">
                    <h4>{{ result.album_name }}</h4>
                </router-link>
                <p> {{ result.genre }} </p>
            </BCard>
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

.filters {
    width: 10rem;
    margin-left: auto;
    margin-right: auto;
}
</style>