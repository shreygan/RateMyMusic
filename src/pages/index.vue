<script setup lang="ts">

async function loadResults() {
  let url = 'http://localhost:3000/songs'

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
    <!-- <div>
      {{ results }}
    </div> -->

    <BCol v-for="(result, index) in results" :key="index" class="mb-3">
        <BCard>
          <BCardTitle>{{ result.song_name }} ({{ getReleaseYear(result.song_release_date) }})</BCardTitle>
            <BCardText>{{ result.album_name }}</BCardText>
        </BCard>
      </BCol>
  </BContainer>
</template>
