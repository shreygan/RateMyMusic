<script setup lang="ts">
import axios from 'axios';

import { useUserStore } from "../composables/userStore";

const { allUsers, currentUser } = useUserStore();

async function getAllGenres() {
    let url = "http://localhost:3000/songs/getallgenres";

    const response = await fetch(url);
    return await response.json();
}
const useFilters = ref(false);

const filters = reactive({
    selectedGenre: "All",
});

const { selectedGenre } = toRefs(filters);

const genreOptions = ref(["All"]);

onMounted(async () => {
    const genres = await getAllGenres();
    console.log(genres);
    genreOptions.value = [
        "All",
        ...genres.map((genreObj: any) => genreObj.Genre),
    ];
});




const selectedFilter = ref("songs"); // Default filter
const filterOptions = ["songs", "albums"];


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
    <b-container class="main-container">
        <div class="main-title" style="margin-top: 20%; margin-bottom: 15%;">
            <h1>Users of <span class="main">RateMyMusic</span></h1>
        </div>
    </b-container>


    <BCard border-variant="success">
        <div class="filters">
            <BFormCheckbox class="mr-2" v-model="useFilters">Use Filters</BFormCheckbox>
        </div>

        <BCardTitle> Filters </BCardTitle>

        <!-- <p class="text-left"> Find all users who have reviewed all </p> -->

        <BCardBody v-if="useFilters">
            <h5>Genre</h5>
            <BFormSelect v-model="selectedGenre" :options="genreOptions" placeholder="Select Genre" />
        </BCardBody>

        <BCol v-if="useFilters" class="mb-4">
            <BFormSelect v-model="selectedFilter" class="mr-2">
                <option v-for="filter in filterOptions" :key="filter" :value="filter">
                    {{ filter }}
                </option>
            </BFormSelect>
        </BCol>

    </BCard>



    <BCol v-for="(users, index) in allUsers" :key="index" class="mb-3">
        <BCard style="width: 100%; margin-top: 15%;">


            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2>{{ users.name }}, {{ users.age }}</h2>
                <RouterLink :to="{ name: '/users/[user]', params: { user: users.pid } }">
                    
                    <span>@{{ users.username }}</span>
                </RouterLink> 
            </div>

            <b-card-img v-if="users.profile_pic" :src="arrayBufferToBase64(users.profile_pic.data)"
                alt="Album Cover"></b-card-img>

            <div class="p-3">
                <BCardText class="d-flex mb-3">
                    <b> Email:</b>&nbsp;&nbsp;{{ users.email }}
                </BCardText>

                <BCardText class="d-flex mb-3">
                    <b> Birthplace:</b>&nbsp;&nbsp;{{ users.birthplace }}
                </BCardText>

                <BCardText class="d-flex mb-3">
                    <b> Birthdate:</b>&nbsp;&nbsp;{{ new Date(users.birthdate).toLocaleDateString() }}
                </BCardText>

                <!-- <BCardFooter>Rating: {{ review.rating }}</BCardFooter> -->
            </div>
            <BButton style="margin-top: -3%;" variant="primary" class="btn-bottom-left">Follow User</BButton>
        </BCard>
    </BCol>
</template>
