<script setup lang="ts">
// import { BCardTitle } from "bootstrap-vue-next";
import { useRoute } from "vue-router";
import { computed, reactive, onMounted, ref } from 'vue'
import { computedAsync } from '@vueuse/core';
// import axios from "axios";



// import { useUserStore } from "../../composables/userStore";
// const { allUsers, currentUser } = useUserStore();

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
    <b-container class="main-container" v-if="results.length > 0">
        <div class="main-title" style="margin-top: 20%">
            <h1> @<span class="main">{{ results[0].followee_username }}</span>'s Followers</h1>
        </div>
    </b-container>


    <BContainer>
        <BRow>
            <BCol>
                <BListGroup>
                    <BListGroupItem v-for="(result, index) in results" :key="index" style="width: 40vw">
                        <BRow class="justify-content-end">
                            <BCol style="max-width: 10rem" class="my-2">
                                <BImg v-if="result.follower_pic" :src="arrayBufferToBase64(result.follower_pic.data)"
                                    style="max-block-size: 5rem; border-radius: 0.5rem" />
                            </BCol>
                            <BCol class="my-3" style="width: 20vw;">
                                <h3>@{{ result.follower_username }}</h3>
                                <h6>
                                    {{ result.follower_name }} 
                                </h6>
                            </BCol>
                            <BCol style="margin-top: 4vh;">
                                <h6>
                                    {{ result.follower_birthplace}} 
                                </h6>
                            </BCol>
                        </BRow>
                    </BListGroupItem>
                </BListGroup>
            </BCol>
        </BRow>
    </BContainer>
</template>
