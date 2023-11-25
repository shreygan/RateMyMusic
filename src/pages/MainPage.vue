<script setup lang="ts">

async function loadAlbumReviews() {
  let url = "http://localhost:3000/songs/albumreviews";
  const response = await fetch(url);
  return await response.json();
}

async function loadSongReviews() {
  let url = "http://localhost:3000/songs/songreviews";
  const response = await fetch(url);
  return await response.json();
}

const isLoading = ref(false);
const albumReviews = computedAsync(loadAlbumReviews, [], isLoading);
const songReviews = computedAsync(loadSongReviews, [], isLoading);

</script>

<script lang="ts">
import Navbar from '../components/Navbar.vue';

export default {
  components: {
    Navbar,
  },
};
</script>

<template>
  <Navbar />
  
  <b-container class="main-container">
    <div class="main-title">
      <h1>Welcome to <span class="main">RateMyMusic</span></h1>
      <p>Your go-to place for music ratings and reviews</p>
    </div>
  </b-container>

    <div>
      <BContainer fluid class="my-4">
        <BRow no-gutters>
          <!-- Left Column (Album Reviews) -->
          <BCol lg="6" class="mb-3 column">
            <BContainer fluid>
              <BCol v-for="(review, index) in albumReviews" :key="index" class="mb-3">
                <BCard style="width: 100%;">
                  <b-card-img :src="review.cover" alt="Album Cover"></b-card-img>
                  <BCardTitle>{{ review.album_name }}</BCardTitle>
                  <BCardText>{{ review.review_text }}</BCardText>
                  <BCardText>{{ review.likes }}</BCardText>
                  <BCardText>{{ review.dislikes }}</BCardText>
                  <BCardFooter>Rating: {{ review.rating }}</BCardFooter>
                </BCard>
              </BCol>
            </BContainer>
          </BCol>

          <!-- Right Column (Song Reviews) -->
          <BCol lg="6" class="mb-3 column">
            <BContainer fluid>
              <BCol v-for="(review, index) in songReviews" :key="index" class="mb-3">
                <BCard style="width: 100%;">
                  <b-card-img :src="review.cover" alt="Album Cover"></b-card-img>
                  <BCardTitle>{{ review.song_name }}</BCardTitle>
                  <BCardText>{{ review.review_text }}</BCardText>
                  <BCardText>{{ review.likes }}</BCardText>
                  <BCardText>{{ review.dislikes }}</BCardText>
                  <BCardFooter>Rating: {{ review.rating }}</BCardFooter>
                </BCard>
              </BCol>
            </BContainer>
          </BCol>
        </BRow>
      </BContainer>
    </div>

</template>
