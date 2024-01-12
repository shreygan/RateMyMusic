<script setup lang="ts">
import { useRoute } from "vue-router";
import { computed, reactive, onMounted, ref } from 'vue'
import { computedAsync } from '@vueuse/core';
import axios from "axios";

const route = useRoute();

const userpid = computed(() => route.params.pid as string);
const playlist_name = computed(() => route.params.playlistname as string);
const creation_date = computed(() => route.params.creationdate as string);


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


async function getPlaylistSongs() {
    let url = "http://localhost:3000/users/getplaylistsongs";

    const response = await axios.post(url, { pid: userpid.value, creation_date: creation_date.value, playlist_name: playlist_name.value });
    console.log(response.data);
    return response.data;
}


const isLoading = ref(false);
const results = computedAsync(getPlaylistSongs, [], isLoading);

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
    <BContainer class="main-container" v-if="results.length > 0" style="width: 35rem;">
        <div class="main-title" style="margin-top: 5rem;">
            <h1 style="display: inline;"> {{ results[0].playlist_name }} </h1>
            <h5 style="display: inline;"> by
                <RouterLink style="text-decoration: none;"
                    :to="{ name: '/users/[user]', params: { user: results[0].pid } }">
                    <span>@{{ results[0].username }}</span>
                </RouterLink>
            </h5>
        </div>
    </BContainer>

    {{ console.log(results[0].description.length) }}
    {{ console.log(results[0].image) }}

    <BCol
        v-if="results.length > 0 && ((results[0].image && results[0.].image.data.length > 0) || results[0].description.length > 0)"
        class="mb-3 main-container">
        <BCard style="width: 35rem; margin-top: 2rem;">
            <BCardImg v-if="results[0].image" style="width: 100%;" :src="arrayBufferToBase64(results[0].image.data)" alt="">
            </BCardImg>

            <div v-if="results[0].description.length > 0" class="p-3">
                <BCardText>{{ results[0].description }}</BCardText>
            </div>
        </BCard>
    </BCol>

    <BContainer style="margin-top: 2rem;">
        <BRow>
            <BCol>
                <BListGroup>
                    <BListGroupItem v-for="(result, index) in results" :key="index" style="width: 33rem;">
                        <BRow class="justify-content-end">
                            <BCol style="max-width: 10rem" class="my-2">
                                <BImg :src="arrayBufferToBase64(result.cover.data)"
                                    style="max-block-size: 5rem; border-radius: 0.5rem" />
                            </BCol>
                            <BCol class="my-2">
                                <RouterLink style="text-decoration: none; color: inherit;"
                                    :to="{ name: '/albums/[albumName]/[year]', params: { albumName: result.song_name, year: result.release_date } }">
                                    <h4>{{ result.song_name }}</h4>
                                </RouterLink>
                                <!-- <h4>{{ result.song_name }}</h4> -->
                                <h6>
                                    {{ result.artist_name }}
                                </h6>
                            </BCol>
                            <BCol class="d-flex align-items-center">
                                <h6>
                                    {{ result.album_name }}
                                </h6>
                            </BCol>
                        </BRow>
                    </BListGroupItem>
                </BListGroup>
            </BCol>
        </BRow>
    </BContainer>
</template>
