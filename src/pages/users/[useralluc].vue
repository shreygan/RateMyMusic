<script setup lang="ts">
import { useRoute } from "vue-router";


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
    <BContainer class="main-container">
        <div class="main-title" style="margin-top: 5rem;">
            <h1>View @<span class="main">{{ currentUser.username }}</span>'s UserCharts</h1>
        </div>
    </BContainer>

    
    <BCol v-for="(result, index) in results" :key="index" class="mb-3" style="width: 35rem;">
            <BCard style="width: 100%; margin-top: 5%">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <RouterLink :to="{
                        name: '/users/[pid]/[ucid]',
                        params: { pid: currentUser.pid, ucid: result.ucid },
                    }">
                        <h2>{{ result.userchart_name }}</h2>
                    </RouterLink>
                    <RouterLink style="text-decoration: none;"
                        :to="{ name: '/users/[user]', params: { user: currentUser.pid } }">
                        <span>@{{ currentUser.username }}</span>
                    </RouterLink>
                </div>

                <BCardImg style="width: 100%;" v-if="result.image && result.image.data.length > 0" :src="arrayBufferToBase64(result.image.data)"
                    alt="UserChart Image"></BCardImg>
            </BCard>
        </BCol>
</template>
