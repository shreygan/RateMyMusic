<script setup lang="ts">
import { useRoute } from "vue-router";
import { computed, reactive, onMounted, ref } from 'vue'
import { computedAsync } from '@vueuse/core';



const route = useRoute();

const userpid = computed(() => route.params.followers as string);


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


async function getUserFollowers() {
    let url = "http://localhost:3000/users/getuserfollowers";

    if (userpid.value) {
        url += `?q=${encodeURIComponent(userpid.value)}`;
    }

    const response = await fetch(url);
    return await response.json();
}

const isLoading = ref(false);
const results = computedAsync(getUserFollowers, [], isLoading);
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
    <BContainer class="main-container" v-if="results.length > 0">
        <div class="main-title" style="margin-top: 5rem;">
            <h1> @<span class="main">{{ results[0].followee_username }}</span>'s Followers</h1>
        </div>
    </BContainer>

    <BContainer style="margin-top: 2rem;">
        <BRow>
            <BCol>
                <BListGroup>
                    <BListGroupItem v-for="(result, index) in results" :key="index" style="width: 35rem; height: 7rem;">
                        <BRow class="justify-content-end align-items-center">
                            <BCol style="max-width: 10rem" class="my-2">
                                <BImg v-if="result.follower_pic" :src="arrayBufferToBase64(result.follower_pic.data)"
                                    style="max-block-size: 5rem; border-radius: 0.5rem; width: 5rem; height: 5rem;" />

                                <div v-else style="max-block-size: 5rem; width: 5rem; height: 5rem;"></div>
                            </BCol>
                            <BCol class="my-3" style="width: 20vw; margin-left: -6%; text-align: left;">
                                <!-- <h3>@{{ result.followee_username }}</h3>
                                {{ console.log(result) }} -->
                                <RouterLink style="text-decoration: none;"
                                    :to="{ name: '/users/[user]', params: { user: result.followerid } }">
                                    <h3>@{{ result.follower_username }}</h3>
                                </RouterLink>
                            </BCol>

                            <BCol style="margin-top: 0.5rem;">
                                <h6>
                                    {{ result.follower_name }}
                                </h6>
                            </BCol>
                        </BRow>
                    </BListGroupItem>
                </BListGroup>
            </BCol>
        </BRow>
    </BContainer>
</template>
