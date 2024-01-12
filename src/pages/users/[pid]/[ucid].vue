<script setup lang="ts">
import { useRoute } from "vue-router";
import axios from "axios";

const route = useRoute();

const userpid = computed(() => route.params.pid as string);
const ucid = computed(() => route.params.ucid as string);

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
    getAvgRatingPerUserChartAlbum();
});

const getReleaseYear = (dateString: string) => {
    const date = new Date(dateString);
    return date.getFullYear();
};

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

async function getUserChartAlbums() {
    let url = "http://localhost:3000/users/getuserchartalbums";

    const response = await axios.post(url, { pid: userpid.value, ucid: ucid.value });
    return response.data;
}

async function getAvgRatingPerUserChartAlbum() {
    let url = "http://localhost:3000/users/getavgratingperuserchartalbum";

    const response = await axios.post(url, { pid: userpid.value, ucid: ucid.value });
    return response.data;
}

const isLoading = ref(false);
const albums = computedAsync(getUserChartAlbums, [], isLoading);
const avgRatingPerAlbum = computedAsync(getAvgRatingPerUserChartAlbum, [], isLoading);


const results = computed(() => {
    if (albums.value && avgRatingPerAlbum.value) {
        return albums.value.map((album: any) => {
            const rankingData = avgRatingPerAlbum.value.find((r: any) => r.album_name === album.album_name);
            return {
                ...album,
                avg_rating: rankingData ? rankingData['AVG(ar.rating)'] : null // Replace with the correct property if different
            };
        });
    }
    return [];
});
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
            <div class="main-title" style="margin-top: 2.5rem; margin-bottom: 2.75rem;">
                <h1 style="display: inline;"> {{ results[0].userchart_name }} </h1>
                <h5 style="display: inline;"> by
                    <RouterLink style="text-decoration: none;"
                        :to="{ name: '/users/[user]', params: { user: userpid } }">
                        <span>@{{ results[0].username }}</span>
                    </RouterLink>
                </h5>
            </div>
        </BContainer>

    <BContainer>
        <BRow>
            <BCol>
                <BListGroup>
                    <BListGroupItem v-for="(result, index) in results" :key="index" style="width: 35rem;">
                        <BRow class="justify-content-end">
                            <BCol style="max-width: 10rem" class="my-2">
                                <strong style="margin-right: 1.5vw;">{{ result.ranking }}</strong>
                                <BImg :src="arrayBufferToBase64(result.cover.data)"
                                    style="max-block-size: 5rem; border-radius: 0.5rem" />
                            </BCol>
                            <BCol class="my-3">
                                <RouterLink style="text-decoration: none; color: inherit;"
                                    :to="{ name: '/albums/[albumName]/[year]', params: { albumName: result.album_name, year: result.release_date } }">
                                    <h3>{{ result.album_name }}</h3>
                                </RouterLink>
                                <h6 style="margin-top: -0.5rem;">
                                    {{ result.artist_name }} ({{
                                        getReleaseYear(result.release_date)
                                    }})
                                </h6>

                                <!-- {{ const parts = result.avg_rating.split('.') }} -->

                                <p style="margin-top: -0.25rem; margin-bottom: -5rem; font-size: 0.7rem;">
                                    Average Rating: {{ result.avg_rating ? result.avg_rating.split('.')[0] + "." + result.avg_rating.split('.')[1].substring(0, 1) : "0.0" }}/5
                                </p>
                            </BCol>
                        </BRow>
                    </BListGroupItem>
                </BListGroup>
            </BCol>
        </BRow>
    </BContainer>
</template>
