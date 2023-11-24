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


<!-- <style scoped>
.page-container {
  background-color: black;
  color: white;
  min-height: 100vh;
  padding-top: 56px;
  width: 100vw; /* Set to 100vw for full viewport width */
}
</style> -->

<style>
body,
html {
  padding: 0;
  margin: 0;
  width: 100%;
  min-height: 100vh;
  color: white;
}

body {
  background-color: #1d1d1d;
}
</style>

<style scoped>
/* .navbar {
  background-color: #333333 !important;
} */

.main-title {
  text-align: center;
  margin: 0; /* Updated to set margin-top to 0 */
  color: #ffffff;
  /* padding-bottom: 200pt; */
  padding-bottom: 10%;
  margin-top: 12%;
}

.main-title h1 {
  font-size: 4rem; /* Adjust the font size as needed */
  margin-bottom: 0.5rem;
}

.main-title p {
  font-size: 1.2rem; /* Adjust the font size as needed */
  margin: 0;
}

.p {
  color: white;
}

.dropdown {
  color: blue;
}

.column {
  padding-right: 0;
}

.main {
  color: #ff3449;
  font-weight: bold;
}

</style>

<template>
  <Navbar />
  
  <b-container class="main-container">
    <div class="main-title">
      <h1>Welcome to <span class="main">RateMyMusic</span></h1>
      <p>Your go-to place for music ratings and reviews</p>
    </div>
  </b-container>

  <!-- <div class="page-container">sdfjgndg</div> -->

  <!-- <div>
    <div>
      <b-card-group deck>
        <b-card img-src="https://placekitten.com/1000/300" img-alt="Card image" img-top>
          <b-card-text>
            Some quick example text to build on the card and make up the bulk of the card's content.
          </b-card-text>
        </b-card>

        <b-card img-src="https://placekitten.com/1000/300" img-alt="Card image" img-bottom>
          <b-card-text>
            Some quick example text to build on the card and make up the bulk of the card's content.
          </b-card-text>
        </b-card>
      </b-card-group>
    </div>
  </div> -->

  
  <!-- <BContainer class="my-4">
    <BCol v-for="(review, index) in albumReviews" :key="index" class="mb-3">
      <BCard>
        <b-card-img :src="review.cover" alt="Album Cover"></b-card-img>
        <BCardTitle>{{ review.album_name }}</BCardTitle>
        <BCardText>{{ review.review_text }}</BCardText>
        <BCardFooter>Rating: {{ review.rating }}</BCardFooter>
      </BCard>
    </BCol>
  </BContainer>

  <BContainer class="my-4">
      <BCol v-for="(review, index) in songReviews" :key="index" class="mb-3">
        <BCard>
          <b-card-img :src="review.cover" alt="Album Cover"></b-card-img>
          <BCardTitle>{{ review.album_name }}</BCardTitle>
          <BCardText>{{ review.review_text }}</BCardText>
          <BCardFooter>Rating: {{ review.rating }}</BCardFooter>
        </BCard>
      </BCol>
    </BContainer> -->

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
