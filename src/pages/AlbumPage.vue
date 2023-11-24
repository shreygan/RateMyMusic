<script setup lang="ts">

async function loadResults() {
  let url = 'http://localhost:3000/songs/albumreviews'
  const response = await fetch(url)
  return await response.json()
}

const isLoading = ref(false)
const results = computedAsync(loadResults, [], isLoading)


</script>

<template>
  <BContainer class="my-4">
    <router-link :to="{ path: '/MainPage' }">
      <b-button variant="primary" class="btn-top-right">Main Page</b-button>
    </router-link>

    <BCol v-for="(review, index) in results" :key="index" class="mb-3">
      <BCard>
        <b-card-img :src="review.cover" alt="Album Cover"></b-card-img>
        <BCardTitle>{{ review.song_name }}</BCardTitle>
        <BCardText>{{ review.review_text }}</BCardText>
        <BCardFooter>Rating: {{ review.rating }}</BCardFooter>
      </BCard>
    </BCol>
  </BContainer>
</template>



<style scoped>
/* Custom styling for the button in the top right corner */
.btn-top-right {
  position: fixed;
  top: 20px;
  right: 20px;
}

.custom-card-img {
  width: 100%;
  height: auto; /* maintain aspect ratio */
  /* other styles as needed */
}

</style>