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

</script>

<template>
  <BContainer class="my-4">
    <BFormInput v-model="searchTerm" />
    <div>
      {{ results }}
    </div>
  </BContainer>
</template>
