<script setup lang="ts">
import axios from "axios";
import { useUserStore } from "../../composables/userStore";
import { useToast } from "vue-toastification";
import { useRoute } from "vue-router";
import { sanitizeInput } from "../../utils/utils";

const { allUsers, currentUser } = useUserStore();

const route = useRoute();

const userpid = computed(() => route.params.createreview as string);


const selectedFilter = ref("Songs"); // Default filter
const filterOptions = ["Songs", "Albums", "UserCharts"];

async function loadAll() {
    let url = "http://localhost:3000/songs/find"; //findsongs
    url += selectedFilter.value;

    if (searchTerm.value) {
        url += `?q=${encodeURIComponent(sanitizeInput(searchTerm.value).trim().toLowerCase())}`;
    }

    const response = await fetch(url);

    return await response.json();
}

const searchTerm = ref("");
const isLoading = ref(false);

const reviewData = ref({
    rating: 0,
    reviewText: "",
    songName: "",
    releaseDate: "",
    pid: 0,
    albumName: "",
    ucid: 0,
    uc_pid: 0,
});

const results = computedAsync(loadAll, [], isLoading);

const getReleaseYear = (dateString) => {
    const date = new Date(dateString);
    return date.getFullYear();
};

async function submitReview(songName: any, songReleaseDate: any, albumName: any, albumReleaseDate: any, ucid: any, uc_pid: any) {
    if (selectedFilter.value === "Songs") {
        submitSongReview(songName, songReleaseDate);
    } else if (selectedFilter.value === "Albums") {
        submitAlbumReview(albumName, albumReleaseDate);
    } else if (selectedFilter.value === "UserCharts") {
        submitUserChartReview(ucid, uc_pid);
    }
}

async function submitSongReview(songName: any, songReleaseDate: any) {
    const toast = useToast();
    reviewData.value.songName = songName;
    reviewData.value.releaseDate = songReleaseDate.slice(0, 10);
    reviewData.value.reviewText = sanitizeInput(reviewData.value.reviewText);
    if (currentUser.value) {
        reviewData.value.pid = currentUser.value.pid;
    }

    if (reviewData.value.reviewText == '') {
        toast.error("Please enter your review");
        return;
    }

    try {
        const response = await axios.post(
            `http://localhost:3000/songs/createsongreviews`,
            reviewData
        );

        if (response.status === 201) {
            console.log("Review submitted successfully!");
            toast.success("Review submitted successfully!");
        } else {
            console.error(
                "Failed to submit review. Unexpected status:",
                response.status
            );
            toast.error("Error submitting review");
        }
    } catch (error) {
        console.error("Error submitting review:", error.message);
        toast.error("Error submitting review");
    }
}


async function submitAlbumReview(albumName: any, albumReleaseDate: any) {
    const toast = useToast();
    reviewData.value.albumName = albumName;
    reviewData.value.releaseDate = albumReleaseDate.slice(0, 10);
    reviewData.value.pid = currentUser.value.pid;
    reviewData.value.reviewText = sanitizeInput(reviewData.value.reviewText);

    if (reviewData.value.reviewText == '') {
        toast.error("Please enter your review");
        return;
    }

    try {
        const response = await axios.post(
            `http://localhost:3000/songs/createalbumreviews`,
            reviewData
        );

        toast.success("Review submitted successfully!");

        if (response.status === 200) {
            console.log("Review submitted successfully!");
        } else {
            console.error(
                "Failed to submit review. Unexpected status:",
                response.status
            );
        }
    } catch (error) {
        toast.error("Error submitting review");
        console.error("Error submitting review:", error.message);
    }
}

async function submitUserChartReview(ucid: any, uc_pid: any) {
    const toast = useToast();

    reviewData.value.ucid = ucid;
    reviewData.value.pid = currentUser.value.pid;
    reviewData.value.uc_pid = uc_pid;
    reviewData.value.reviewText = sanitizeInput(reviewData.value.reviewText);

    if (reviewData.value.reviewText == '') {
        toast.error("Please enter your review");
        return;
    }

    try {
        const response = await axios.post(
            `http://localhost:3000/songs/createuserchartreviews`,
            reviewData
        );

        toast.success("Review submitted successfully!");

        if (response.status === 200) {
            console.log("Review submitted successfully!");
        } else {
            console.error(
                "Failed to submit review. Unexpected status:",
                response.status
            );
        }
    } catch (error) {
        toast.error("Error submitting review");
        console.error("Error submitting review:", error.message);
    }
}





</script>

<template>
    <BContainer class="my-4">
        <BCol class="mb-4">
            <BFormInput class="my-4" placeholder="Search" v-model="searchTerm" />
            <BFormSelect v-model="selectedFilter" class="mr-2">
                <option v-for="filter in filterOptions" :key="filter" :value="filter">
                    {{ filter }}
                </option>
            </BFormSelect>
            <router-link :to="{ path: '/' }">
                <b-button variant="primary" class="btn-top-right">Click Me</b-button>
            </router-link>
        </BCol>

        <BRow class="scrollable-area mb-3">
            <BCol v-for="(result, index) in results" :key="index" class="mb-3">
                <BCard>
                    <BCardTitle>{{
                        selectedFilter === "Albums" ? result.album_name : selectedFilter === "Songs" ? result.song_name :
                        result.userchart_name
                    }}
                        {{
                            selectedFilter === "Albums"
                            ? "(" + getReleaseYear(result.release_date) + ")"
                            : selectedFilter === "Songs" ? "(" + getReleaseYear(result.song_release_date) + ")" : ""
                        }}</BCardTitle>

                    <!-- <router-link to="/AlbumPage"> -->
                    <BCardText>{{
                        selectedFilter === "Albums" ? result.name : selectedFilter === "Songs" ? result.album_name : "@" +
                            result.username
                    }}</BCardText>
                    <!-- </router-link> -->
                </BCard>
            </BCol>
        </BRow>

        <BCol class="mb-3">
            <BFormInput v-model="reviewData.rating" type="range" min="0" max="5" />
            <BFormInput v-model="reviewData.reviewText" placeholder="Enter your review" />
        </BCol>

        <BCol class="mb-3">
            <BButton variant="primary" :disabled="!searchTerm || results.length === 0" @click="
                submitReview(results[0].song_name, results[0].song_release_date, results[0].album_name, results[0].release_date, results[0].ucid, results[0].uc_pid)
                ">Submit</BButton>
        </BCol>
    </BContainer>
</template>

<style scoped>
.btn-top-right {
    position: fixed;
    top: 20px;
    right: 20px;
}

.scrollable-area {
    max-height: 300px;
    max-width: 500px;
    overflow-y: auto;
}
</style>
