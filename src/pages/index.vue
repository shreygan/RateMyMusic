

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

const selectedFilter = ref('song_name');
</script>


<template>
  <BContainer class="my-4">
    <BCol>

    <BFormInput v-model="searchTerm" />
    <BFormSelect v-model="selectedFilter" class="mr-2">
      <option value="song_name">Song Name</option>
      <option value="album_name">Album Name</option>
    </BFormSelect>

    </BCol>
    <router-link :to="{ path: '/MainPage' }">
        <b-button variant="primary" class="btn-top-right">Click Me</b-button>
    </router-link>

    <BCol v-for="(result, index) in results" :key="index" class="mb-3">
      <BCard>
        <BCardTitle>{{ result.song_name }} ({{ getReleaseYear(result.song_release_date) }})</BCardTitle>

        <router-link to="/AlbumPage">
          <BCardText>{{ result.album_name }}</BCardText>
        </router-link>
      </BCard>
    </BCol>
  </BContainer>
</template>

<style scoped>
.btn-top-right {
  position: fixed;
  top: 20px;
  right: 20px;
}
</style>