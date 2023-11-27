<script setup lang="ts">
async function loadResults() {
  let url = "http://localhost:3000/songs/findalbums";

  if (searchTerm.value) {
    url += `?q=${encodeURIComponent(searchTerm.value.trim().toLowerCase())}`;
  }

  const response = await fetch(url);
  return await response.json();
}

const searchTerm = ref("");
const isLoading = ref(false);
const results = computedAsync(loadResults, [], isLoading);

const getReleaseYear = (dateString) => {
  const date = new Date(dateString);
  return date.getFullYear();
};
</script>

<template>
  <BContainer class="my-4">
    <BFormInput v-model="searchTerm" />
    <router-link :to="{ path: '/MainPage' }">
      <b-button variant="primary" class="btn-top-right">Click Me</b-button>
    </router-link>

    <BCol v-for="(result, index) in results" :key="index" class="mb-3">
      <BCard>
        <BCardTitle
          >{{ result.album_name }} ({{
            getReleaseYear(result.release_date)
          }})</BCardTitle
        >

        <router-link to="/AlbumPage">
          <BCardText>{{ result.name }}</BCardText>
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
