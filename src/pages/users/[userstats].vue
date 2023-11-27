<script setup lang="ts">
import { BCardTitle } from "bootstrap-vue-next";
import { useRoute } from "vue-router";
import axios from "axios";

import { useUserStore } from "../../composables/userStore";
// const { allUsers, currentUser } = useUserStore();

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
    avgRatingPerUser(selectedFilter.value); // Call the function when component is mounted
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

// Create a computed property
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



const isLoading = ref(false);

const selectedFilter = ref("SUM"); 

watch(selectedFilter, async (newValue) => {
    await avgRatingPerUser(newValue);
});


// Default filter
const filterOptions = ["SUM", "MAX", "MIN", "AVG", "COUNT"];

</script>

<script lang="ts">
export default {
    data() {
        return {
            selectedAggregation: "SUM",
        };
    },
    //     methods: {
    //         bufferToDataURI(bufferArray: number[]) {
    //             // Convert the array to a base64-encoded data URI
    //             const uint8Array = new Uint8Array(bufferArray);
    //             const base64String = btoa(
    //                 String.fromCharCode.apply(null, Array.from(uint8Array))
    //             );
    //             return "data:image/jpeg;base64," + base64String;
    //         },
    //         selectAggregation(aggregation: any) {
    //             this.selectedAggregation = aggregation;
    //             // You can perform actions based on the selected aggregation here
    //         },
    //     },
    // };
};
</script>

<style scoped></style>

<template>
   <BFormSelect v-model="selectedFilter" class="mr-2" style="margin-top: 10vh;">
            <option v-for="filter in filterOptions" :key="filter" :value="filter" style="width: 10vw;">
                {{ filter }}
            </option>
        </BFormSelect>

    <BCol v-for="(artist, index) in avgRatings" :key="index" class="mb-3" lg="4" xl="4" style="width:70vw;">
        <BCard style="
        width: 70%;
        margin-left: 20%;
        margin-top: 15%;
        max-height: 80vh;
        overflow-y: auto;
      ">
      {{console.log(artist)}}
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2>{{ artist.name }}</h2>
            </div>

            <div class="p-3">
                <div class="p-3">
                <BCardText class="d-flex mb-3">
                    <b> {{ filterText }} :</b>&nbsp;&nbsp;{{ artist.agg_value }}
                </BCardText>
            </div>
            </div>
        </BCard>
    </BCol>
</template>
