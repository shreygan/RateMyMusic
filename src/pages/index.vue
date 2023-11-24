

<script setup lang="ts">

async function loadResults() {
  let url = 'http://localhost:3000/songs/findsongs'

  if (searchTerm.value) {
    url += `?q=${encodeURIComponent(searchTerm.value.trim().toLowerCase())}`
  }

  const response = await fetch(url)
  return await response.json()
}

const searchTerm = ref('')
const isLoading = ref(false)
const results = computedAsync(loadResults, [], isLoading)

const getReleaseYear = (dateString) => {
  const date = new Date(dateString);
  return date.getFullYear();
};


</script>


<template>
  <BContainer class="my-4">
    <BFormInput v-model="searchTerm" />
    <!-- <b-button variant="primary" class="btn-top-right" @click="handleButtonClick">Click Me</b-button> -->
    <router-link :to="{ path: '/MainPage' }">
        <b-button variant="primary" class="btn-top-right">Click Me</b-button>
    </router-link>

    <BCol v-for="(result, index) in results" :key="index" class="mb-3">
      <BCard>
        <BCardTitle>{{ result.song_name }} ({{ getReleaseYear(result.song_release_date) }})</BCardTitle>

        <!-- Album name as a clickable link to the AlbumPage -->
        <router-link to="/AlbumPage">
          <BCardText>{{ result.album_name }}</BCardText>
        </router-link>
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
</style>