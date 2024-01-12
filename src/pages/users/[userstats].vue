<script setup lang="ts">
import { useRoute } from "vue-router";
import axios from "axios";

const route = useRoute();

const userpid = computed(() => route.params.userstats as string);

const currentUser = reactive({
    pid: "",
    name: "",
    username: "",
    email: "",
    birthdate: "",
    birthplace: "",
    age: "",
    profile_pic: "",
});


onMounted(() => {
    getCurrentUser();
    avgRatingPerUser(selectedFilter.value);
});

async function getCurrentUser() {
    let url = "http://localhost:3000/users/getuserbyid";

    if (userpid.value) {
        url += `?q=${encodeURIComponent(userpid.value)}`;
    }


    const response = await fetch(url);
    const data = await response.json();
    currentUser.pid = data[0].pid;
    currentUser.name = data[0].name;
    currentUser.username = data[0].username;
    currentUser.email = data[0].email;
    currentUser.birthdate = data[0].birthdate;
    currentUser.birthplace = data[0].birthplace;
    currentUser.age = data[0].age;
    currentUser.profile_pic = data[0].profile_pic;
}

const avgRatings = ref([]);

async function avgRatingPerUser(agg_choice: string) {
    let url = "http://localhost:3000/users/avgratingperuser";
    const response = await axios.post(url, {
        aggChoice: agg_choice,
        pid: userpid.value,
    });
    avgRatings.value = response.data;
    return await response.data;
}

const filterText = computed(() => {
    switch (selectedFilter.value) {
        case "SUM": return "Sum of ratings";
        case "COUNT": return "Number of reviews";
        case "MAX": return "Maximum rating";
        case "MIN": return "Minimum rating";
        case "AVG": return "Average rating";
        default: return "";
    }
});

const selectedFilter = ref("SUM");

watch(selectedFilter, async (newValue) => {
    await avgRatingPerUser(newValue);
});

const filterOptions = ["SUM", "MAX", "MIN", "AVG", "COUNT"];

</script>

<script lang="ts">
export default {
    data() {
        return {
            selectedAggregation: "SUM",
        };
    },
};
</script>

<style scoped></style>

<template>
    <b-container class="main-container">
        <div class="main-title" style="margin-top: 5rem; margin-bottom: 3rem;">
            <h1>View Stats by Artist for @{{ currentUser.username }}</h1>
        </div>
    </b-container>

    <BFormSelect v-model="selectedFilter" class="mr-2">
        <option v-for="filter in filterOptions" :key="filter" :value="filter" style="width: 10vw;">
            {{ filter }}
        </option>
    </BFormSelect>

    <BCol v-for="(artist, index) in avgRatings" :key="index" class="mb-3" lg="4" xl="4" style="width: 100%;">
        <BCard style="
        width: 20rem;
        margin-left: 20%;
        margin-top: 1rem;
        max-height: 80vh;
        overflow-y: auto;
      ">
            {{ console.log(artist) }}
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="center-me">{{ artist.name }}</h2>
            </div>

            <div class="p-3">
                <div class="p-3">
                    <BCardText class="center-me">
                        <b> {{ filterText }} </b>&nbsp;&nbsp;{{ artist.agg_value }}
                    </BCardText>
                </div>
            </div>
        </BCard>
    </BCol>
</template>

<style>
.center-me {
    margin-left: auto;
    margin-right: auto;
}
</style>
