

<script setup lang="ts">
import axios from 'axios'


async function loadAllSongs() {
    let url = 'http://localhost:3000/songs/findsongs'

    if (searchTerm.value) {
        url += `?q=${encodeURIComponent(searchTerm.value.trim().toLowerCase())}`
    }

    const response = await fetch(url)
    return await response.json()
}

async function getAllGenres() {
    let url = 'http://localhost:3000/songs/getallgenres'

    const response = await fetch(url)
    return await response.json()
}


async function submitFilterRequest(filterDataValue: any) {

    try {
        const response = await axios.post(`http://localhost:3000/songs/filtersongs`, filterDataValue);
        console.log(response);
        if (response.status === 201) {
            console.log('Review submitted successfully!');
            console.log(response.data);
            return response.data;
        } else {
            console.error('Failed to submit review. Unexpected status:', response.status);
        }
    } catch (error) {
        console.error('Error submitting review:', error.message);
    }
}


async function submitAdvancedFilterRequest(advancedFilterValues: any) {

try {
    const response = await axios.post(`http://localhost:3000/songs/advancedfiltersongs`, advancedFilterValues);
    console.log(response);
    if (response.status === 201) {
        console.log('Review submitted successfully!');
        console.log(response.data);
        return response.data;
    } else {
        console.error('Failed to submit review. Unexpected status:', response.status);
    }
} catch (error) {
    console.error('Error submitting review:', error.message);
}
}



const useFilters = ref(false);


const filterValues = ref({
    searchTerm: '',
    startDate: '',
    endDate: '',
    selectedGenre: 'All',
    isSingle: false,
    minDuration: 0,
    maxDuration: 20,
})

const advancedFilterValues = ref({
    topSongsNumber: 0,
    ratingComparison: '',
    ratingValue: 0,
})




async function submitFilters() {
    if (useFilters.value) {
        // If filters are used, fetch filtered songs
        try {
            const filteredSongs = await submitFilterRequest(filterValues);

            results.value = filteredSongs; // Update results with filtered songs
        } catch (error) {
            console.error('Error fetching filtered songs:', error.message);
        }
    } else if (useAdvancedFilters.value) {
        // If filters are used, fetch filtered songs
        try {
            const advancedFilteredSongs = await submitAdvancedFilterRequest(advancedFilterValues);

            console.log(advancedFilteredSongs);

            results.value = advancedFilteredSongs; // Update results with filtered songs
        } catch (error) {
            console.error('Error fetching filtered songs:', error.message);
        }
    }
    else {
        // If not, just load all songs
        results.value = await loadAllSongs();
    }
}





const searchTerm = ref('')
const startDate = ref('');
const endDate = ref('');
const selectedGenre = ref('All');
const isSingle = ref(false);
const minDuration = ref(0);
const maxDuration = ref(20);

const useAdvancedFilters = ref(false);
const topSongsNumber = ref(0);
const ratingComparison = ref('');
const ratingValue = ref(0);



watch(searchTerm, (newVal) => {
    filterValues.value.searchTerm = newVal;
});
watch(startDate, (newVal) => {
    filterValues.value.startDate = newVal;
});
watch(endDate, (newVal) => {
    filterValues.value.endDate = newVal;
});
watch(selectedGenre, (newVal) => {
    filterValues.value.selectedGenre = newVal;
});
watch(isSingle, (newVal) => {
    filterValues.value.isSingle = newVal;
});
watch(minDuration, (newVal) => {
    filterValues.value.minDuration = newVal;
});
watch(maxDuration, (newVal) => {
    filterValues.value.maxDuration = newVal;
});

// Watch for changes in useFilters and update useAdvancedFilters
watch(useFilters, (newValue) => {
  if (newValue) {
    useAdvancedFilters.value = false;
  }
});

// Watch for changes in useAdvancedFilters and update useFilters
watch(useAdvancedFilters, (newValue) => {
  if (newValue) {
    useFilters.value = false;
  }
});

watch(topSongsNumber, (newVal) => {
    advancedFilterValues.value.topSongsNumber = newVal;
});

// Watch the ratingComparison and update advancedFilterValues
watch(ratingComparison, (newVal) => {
    advancedFilterValues.value.ratingComparison = newVal;
});

// Watch the ratingValue and update advancedFilterValues
watch(ratingValue, (newVal) => {
    advancedFilterValues.value.ratingValue = newVal;
});


// const genreOptions = ['Rap', 'Rock', 'Hip-Hop', 'R&B', 'Electronic', 'Country', 'Other'];

const isLoading = ref(false)
const results = computedAsync(loadAllSongs, [], isLoading)

const getReleaseYear = (dateString) => {
    const date = new Date(dateString);
    return date.getFullYear();
};


interface GenreObject {
  Genre: string;
}

const genreOptions = ref(['All']); // Initialize genreOptions as an empty array

// Fetch genres when the component is mounted
onMounted(async () => {
    const genres = await getAllGenres();
    console.log(genres);
    genreOptions.value = ['All', ...genres.map((genreObj: GenreObject) => genreObj.Genre)];
});





</script>

<script lang="ts">
import Navbar from '../components/Navbar.vue';

export default {
    components: {
        Navbar,
    },
    methods: {
        bufferToDataURI(bufferArray: number[]) {
            // Convert the array to a base64-encoded data URI
            const uint8Array = new Uint8Array(bufferArray);
            const base64String = btoa(String.fromCharCode.apply(null, Array.from(uint8Array)));
            return 'data:image/jpeg;base64,' + base64String;
        }
    },
};
</script>




<template>
    <BContainer class="my-4">


        <BCard>
            <BCardTitle>
                Filters
            </BCardTitle>

                <BFormCheckbox v-model="useFilters">Use Filters</BFormCheckbox>

            <BCardBody>
                <!-- Start Date and End Date -->
                <p class="filter-title">Release Date Range</p>
                <BFormInput v-model="startDate" type="date" placeholder="Start Date" />
                <BFormInput v-model="endDate" type="date" placeholder="End Date" />

                <!-- Genre Dropdown -->
                <p class="filter-title">Genre</p>
                <BFormSelect v-model="selectedGenre" :options="genreOptions" placeholder="Select Genre" />

                <!-- isSingle Checkbox -->
                <p class="filter-title">Type</p>
                <BFormCheckbox v-model="isSingle">isSingle</BFormCheckbox>

                <!-- Min and Max Duration Sliders -->
                <p class="filter-title">Duration Range</p>
                <p>Min Duration: {{ minDuration }} minutes</p>
                <BFormInput type="range" v-model="minDuration" min="0" max="20" step="0.25" />

                <p>Max Duration: {{ maxDuration }} minutes</p>
                <BFormInput type="range" v-model="maxDuration" min="0" max="20" step="0.25" />
            </BCardBody>

        <BCardTitle>Advanced Filters</BCardTitle>
        
            <BFormCheckbox v-model="useAdvancedFilters">Use Advanced Filters</BFormCheckbox>
        
        <BCardBody>
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


                <b-button @click="submitFilters" variant="primary">Submit Filters</b-button>
        </BCard>






        <BFormInput v-model="searchTerm" />
        <router-link :to="{ path: '/MainPage' }">
            <b-button variant="primary" class="btn-top-right">Click Me</b-button>
        </router-link>

        <BCol v-for="(result, index) in results" :key="index" class="mb-3">
            <BCard style="width: 100%">
                <!-- <BCardTitle>{{ result.song_name }} ({{ getReleaseYear(result.song_release_date) }})</BCardTitle> -->
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>{{ result.song_name }}</h2>
                    <span>{{ getReleaseYear(result.song_release_date) }}</span>
                </div>

                <!-- <b-card-img :src="bufferToDataURI(result.cover.data)" alt="Album Cover"></b-card-img> -->
                <b-card-img v-if="result.cover" :src="bufferToDataURI(result.cover.data)" alt="Album Cover"></b-card-img>

                <router-link to="/AlbumPage">
                    <BCardText>{{ result.album_name }}</BCardText>
                </router-link>
            </BCard>
        </BCol>

    </BContainer>
</template>

<style scoped>
/* Custom styling for the button in the top right corner */
.btn-top-right {
    position: fixed;
    top: 20px;
    right: 20px;
}
</style>