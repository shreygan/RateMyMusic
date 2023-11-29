<script setup lang="ts">
import { useRoute } from "vue-router";
import axios from "axios";
import { useToast } from "vue-toastification";
// const { allUsers, currentUser } = useUserStore();

const route = useRoute();

const userpid = computed(() => route.params.user as string);

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
  console.log(url);

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

  console.log(data[0].pid);
}

async function loadAlbumReviews() {
  let url = "http://localhost:3000/users/getuseralbumreviews";

  if (currentUser.pid) {
    url += `?q=${encodeURIComponent(currentUser.pid)}`;
  }
  const response = await fetch(url);
  return await response.json();
}

async function loadSongReviews() {
  let url = "http://localhost:3000/users/getusersongreviews";

  if (currentUser.pid) {
    url += `?q=${encodeURIComponent(currentUser.pid)}`;
  }
  const response = await fetch(url);
  return await response.json();
}

async function deleteReview(rid: string, userpid: string) {
  const toast = useToast();
  let url = "http://localhost:3000/users/deletereview";

  try {
    const response = await axios.post(url, { rid: rid, userpid: userpid });
    
    if (selectedFilter.value === "Album Reviews") {
      albumReviews.value = albumReviews.value.filter(
        (review: any) => review.rid !== rid
      );
    } else if (selectedFilter.value === "Song Reviews") {
      songReviews.value = songReviews.value.filter(
        (review: any) => review.rid !== rid
      );
    }

    console.log(response.data);

    toast.success("Review deleted");
  } catch (error) {
    console.log(error);
    toast.error("Error deleting review");
  }
}

async function avgRatingPerUser(agg_choice: string) {
  let url = "http://localhost:3000/users/avgratingperuser";
  const response = await axios.post(url, {
    aggChoice: agg_choice,
    pid: userpid.value,
  });
  console.log(response.data);
  return await response.data;
}

const isLoading = ref(false);

const albumReviews = computedAsync(loadAlbumReviews, [], isLoading);
const songReviews = computedAsync(loadSongReviews, [], isLoading);
const avgRatings = computedAsync(avgRatingPerUser, [], isLoading);

const selectedFilter = ref("Song Reviews"); // Default filter
const filterOptions = ["Song Reviews", "Album Reviews"];
</script>

<script lang="ts">
export default {
  data() {
    return {
      selectedAggregation: "SUM",
    };
  },
  methods: {
    arrayBufferToBase64(buffer: number[]) {
      var binary = "";
      var bytes = new Uint8Array(buffer);
      var len = bytes.byteLength;
      for (var i = 0; i < len; i++) {
        binary += String.fromCharCode(bytes[i]);
      }
      return "data:image/jpeg;base64," + window.btoa(binary);
    },
    selectAggregation(aggregation: any) {
      this.selectedAggregation = aggregation;
      // You can perform actions based on the selected aggregation here
    },
  },
};
</script>

<style scoped>
.btn-link {
  background-color: transparent;
  border: none;
  cursor: pointer;
}

.upvote-icon {
  width: 20px;
  /* Adjust the width and height based on your image dimensions */
  height: 20px;
  margin-right: -10px;
  margin-top: -2.5px;
  /* Add some spacing between the image and the Likes count */
  transform: rotate(180deg);
  filter: grayscale(100%);
}

.upvote-icon-upvoted {
  width: 25px;
  /* Adjust the width and height based on your image dimensions */
  height: 25px;
  margin-right: -10px;
  margin-top: -2.5px;
  /* Add some spacing between the image and the Likes count */
  transform: rotate(180deg);
}

.downvote-icon {
  width: 20px;
  /* Adjust the width and height based on your image dimensions */
  height: 20px;
  margin-right: -10px;
  margin-top: 0;
  /* Add some spacing between the image and the Likes count */
  filter: grayscale(100%);
}

.downvote-icon-downvoted {
  width: 25px;
  /* Adjust the width and height based on your image dimensions */
  height: 25px;
  margin-right: -10px;
  /* Add some spacing between the image and the Likes count */
  filter: grayscale(100%);
  filter: hue-rotate(240deg);
}
</style>

<template>
  <BCol class="mb-3">
    <BCard style="width: 50vw; margin-top: 15%">
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>{{ currentUser.name }}, {{ currentUser.age }}</h2>
        <span>@{{ currentUser.username }}</span>
      </div>

      <b-card-img
        v-if="currentUser.profile_pic"
        :src="arrayBufferToBase64(currentUser.profile_pic.data)"
        alt="Album Cover"
      ></b-card-img>

      <div class="p-3">
        <BCardText class="d-flex mb-3">
          <b> Email:</b>&nbsp;&nbsp;{{ currentUser.email }}
        </BCardText>

        <BCardText class="d-flex mb-3">
          <b> Birthplace:</b>&nbsp;&nbsp;{{ currentUser.birthplace }}
        </BCardText>

        <BCardText class="d-flex mb-3">
          <b> Birthdate:</b>&nbsp;&nbsp;{{
            new Date(currentUser.birthdate).toLocaleDateString()
          }}
        </BCardText>
        <!-- {{ console.log(userpid) }} -->
        <div>
          <RouterLink
            :to="{ name: '/users/[userstats]', params: { userstats: userpid } }"
          >
            <BButton
              style="margin-top: 3%; margin-bottom: -3%"
              variant="primary"
              class="btn-bottom-left"
              >View User Stats
            </BButton>
          </RouterLink>
        </div>

        <div style="margin-top: 2vh">
          <RouterLink
            :to="{ name: '/users/[useralluc]', params: { useralluc: userpid } }"
          >
            <BButton
              style="margin-top: 3%; margin-bottom: -3%"
              variant="primary"
              class="btn-bottom-left"
              >View User Charts
            </BButton>
          </RouterLink>
        </div>
      </div>
    </BCard>
  </BCol>

  <BCol class="mb-4">
    <BFormSelect v-model="selectedFilter" class="mr-2">
      <option v-for="filter in filterOptions" :key="filter" :value="filter">
        {{ filter }}
      </option>
    </BFormSelect>
  </BCol>

  <BContainer fluid class="my-4">
    <BCol v-if="selectedFilter == 'Album Reviews'" lg="6" class="mb-3 column">
  <BContainer fluid>
    <BCol v-for="(review, index) in albumReviews" :key="index" class="mb-3">
      <RouterLink
        :to="{ 
          name: '/users/[pid]/[rid]/[type]', 
          params: { 
            pid: userpid, 
            rid: review.rid, 
            type: 'Album' 
          } 
        }"
      >
        <BCard style="width: 70vw">
          <div class="d-flex justify-content-between align-items-center mb-3">
            <h2>{{ review.album_name }}</h2>
            <span>@{{ currentUser.username }}</span>
          </div>

          <!-- Album cover image -->
          <!-- <b-card-img style="width: 40vw;" :src="arrayBufferToBase64(review.cover.data)"
                          alt="Album Cover"></b-card-img> -->

          <div class="p-3">
            <BCardText
              class="d-flex justify-content-between align-items-center mb-3"
              >{{ review.review_text }}</BCardText
            >

            <BCardFooter>Rating: {{ review.rating }}</BCardFooter>
          </div>

          <BButton
            style="margin-top: 3%; margin-bottom: -3%"
            variant="danger"
            class="btn-bottom-left"
            @click="deleteReview(review.rid, currentUser.pid)"
            >Delete Review</BButton
          >
        </BCard>
      </RouterLink>
    </BCol>
  </BContainer>
</BCol>




    <BCol v-if="selectedFilter == 'Song Reviews'" lg="6" class="mb-3 column">
      <BContainer fluid>
        <BCol v-for="(review, index) in songReviews" :key="index" class="mb-3">
          {{ console.log(review) }}
          <RouterLink
            :to="{ name: '/users/[pid]/[rid]/[type]', params: { pid: userpid, rid: review.rid, type: selectedFilter.split(' ')[0] } }"
          >
          <BCard style="width: 200%">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <h2>{{ review.song_name }}</h2>
              <span>@{{ currentUser.username }}</span>
            </div>

            <!-- Album cover image -->
            <b-card-img style="width: 40vw;" :src="arrayBufferToBase64(review.cover.data)"
                            alt="Album Cover"></b-card-img>

                            <div class="p-3">
              <BCardText
                class="d-flex justify-content-between align-items-center mb-3"
                >{{ review.review_text }}</BCardText
              >
              <BCardFooter>Rating: {{ review.rating }}</BCardFooter>
            </div>

            <BButton
              style="margin-top: 3%; margin-bottom: -3%"
              variant="danger"
              class="btn-bottom-left"
              @click="deleteReview(review.rid, currentUser.pid)"
              >Delete Review</BButton
            >
          </BCard>
        </RouterLink>
        </BCol>
      </BContainer>
    </BCol>

  </BContainer>
</template>
