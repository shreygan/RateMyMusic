<script setup lang="ts">
import { useRoute } from "vue-router";
import { computed, reactive, onMounted, ref } from 'vue'


const route = useRoute();

const userpid = computed(() => route.params.pid as string);

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
}




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
        <div class="main-title" style="margin-top: 20%">
            <h1> @<span class="main">{{ results[0].username }}</span>'s UserChart: {{ results[0].userchart_name }}</h1>
        </div>
    </BContainer>

    <BContainer>
        <BRow>
            <BCol>
                <BListGroup>
                    <BListGroupItem v-for="(result, index) in results" :key="index" style="max-width: 500px">
                        <BRow class="justify-content-end">
                            <BCol style="max-width: 10rem" class="my-2">
                                <strong style="margin-right: 1.5vw;">{{ result.ranking }}</strong>
                                <BImg :src="arrayBufferToBase64(result.cover.data)"
                                    style="max-block-size: 5rem; border-radius: 0.5rem" />
                            </BCol>
                            <BCol class="my-3">
                                <h3>{{ result.album_name }}</h3>
                                <h6>
                                    {{ result.artist_name }} ({{
                                        getReleaseYear(result.release_date)
                                    }}) &nbsp;&nbsp;&nbsp; AVG: {{ result.avg_rating.substring(0, 3) }}/5
                                </h6>
                            </BCol>
                        </BRow>
                    </BListGroupItem>
                </BListGroup>
            </BCol>
        </BRow>
    </BContainer>
</template>
