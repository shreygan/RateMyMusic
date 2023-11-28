<script setup lang="ts">
import axios from "axios";

import { useUserStore } from "../composables/userStore";
const { allUsers, currentUser } = useUserStore();

const searchTerm = ref("");

async function loadAllUserCharts(){
    let url = "http://localhost:3000/users/getallusercharts";

    if (searchTerm.value) {
        url += `?q=${encodeURIComponent(searchTerm.value.trim().toLowerCase())}`;
    } 
    
    const response = await fetch(url);
    const data = await response.json();
    return data;
}

const useFilters = ref(false);

const selectedFilter = ref("songs"); // Default filter
const filterOptions = ["songs", "albums"];


const isLoading = ref(false);
const results = computedAsync(loadAllUserCharts, [], isLoading);

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
            <BFormInput v-model="searchTerm" style="margin-top: 3vh;" />
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
