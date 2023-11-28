<script setup lang="ts">
import { BCardTitle } from "bootstrap-vue-next";
import { useRoute } from "vue-router";
import axios from "axios";

import { useUserStore } from "../../composables/userStore";
// const { allUsers, currentUser } = useUserStore();

const route = useRoute();

const userpid = computed(() => route.params.useralluc as string);

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
    getPersonalUserCharts();
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

    console.log(currentUser.pid);
}


async function getPersonalUserCharts() {
    let url = "http://localhost:3000/users/getpersonalusercharts";

    if (currentUser.pid) {
        url += `?q=${encodeURIComponent(currentUser.pid)}`;
    }

    const response = await fetch(url);
    // results.value = await response.json();
    return response.json();
}


const isLoading = ref(false);
const results = computedAsync(getPersonalUserCharts, [], isLoading);

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
        <div class="main-title" style="margin-top: 20%">
            <h1>View @<span class="main">{{ currentUser.username }}</span>'s UserCharts</h1>
        </div>
    </b-container>

    <BCol v-for="(result, index) in results" :key="index" class="mb-3">
        <BCard style="width: 40vw; margin-top: 10%;">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <RouterLink :to="{ name: '/users/[pid]/[ucid]', params: { pid: userpid, ucid: result.ucid } }">
                    <h2>{{ result.userchart_name }}</h2>
                </RouterLink>
                <span>@{{ result.username }}</span>
            </div>

            <b-card-img style="width: 32vw;" v-if="result.image" :src="arrayBufferToBase64(result.image.data)"
                alt="Album Cover"></b-card-img>
        </BCard>
    </BCol>
</template>
