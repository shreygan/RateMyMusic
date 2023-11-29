<script setup lang="ts">
import axios from "axios";
import { useUserStore } from "../../composables/userStore";
import { useToast } from "vue-toastification";
import { useRoute } from "vue-router";

const { allUsers, currentUser } = useUserStore();

const route = useRoute();

const userpid = computed(() => route.params.createreview as string);


const selectedFilter = ref("songs"); // Default filter
const filterOptions = ["songs", "albums"];

async function loadAlbums() {
  let url = "http://localhost:3000/songs/find"; //findsongs
  url += selectedFilter.value;

  if (searchTerm.value) {
    url += `?q=${encodeURIComponent(searchTerm.value.trim().toLowerCase())}`;
  }

  const response = await fetch(url);
  return await response.json();
}

const reviewText = ref("");
const searchTerm = ref("");
const isLoading = ref(false);
const reviewData = ref({
  rating: 0,
  reviewText: "",
  songName: "",
  releaseDate: "",
  pid: 0,
  albumName: "",
});

const results = computedAsync(loadAlbums, [], isLoading);

const getReleaseYear = (dateString) => {
  const date = new Date(dateString);
  return date.getFullYear();
};

async function submitReview(songName: any, songReleaseDate: any, albumName: any, albumReleaseDate: any) {
  if (selectedFilter.value === "songs") {
    submitSongReview(songName, songReleaseDate);
  } else if (selectedFilter.value === "albums") {
    submitAlbumReview(albumName, albumReleaseDate);
  } else {
    console.error("Unexpected filter:", selectedFilter.value);
  }
}

async function submitSongReview(songName: any, songReleaseDate: any) {
  const toast = useToast();
  reviewData.value.songName = songName;
  reviewData.value.releaseDate = songReleaseDate.slice(0, 10);
  if (currentUser.value) {
    reviewData.value.pid = currentUser.value.pid;
  }

  if (reviewData.value.reviewText == '') {
    toast.error("Please add a review description");
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
          <BCardTitle
            >{{
              selectedFilter === "albums" ? result.album_name : result.song_name
            }}
            ({{
              selectedFilter === "albums"
                ? getReleaseYear(result.release_date)
                : getReleaseYear(result.song_release_date)
            }})</BCardTitle
          >

          <router-link to="/AlbumPage">
            <BCardText>{{
              selectedFilter === "albums" ? result.name : result.album_name
            }}</BCardText>
          </router-link>
        </BCard>
      </BCol>
    </BRow>

    <BCol class="mb-3">
      <BFormInput v-model="reviewData.rating" type="range" min="0" max="5" />
      <BFormInput v-model="reviewData.reviewText" />
    </BCol>

    <BCol class="mb-3">
      <BButton
        variant="primary"
        :disabled="!searchTerm || results.length === 0"
        @click="
          submitReview(results[0].song_name, results[0].song_release_date, results[0].album_name, results[0].release_date)
        "
        >Submit</BButton
      >
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
