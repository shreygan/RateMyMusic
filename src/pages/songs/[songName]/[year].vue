<script setup lang="ts">
import { BCardTitle } from "bootstrap-vue-next";
import { useRoute } from "vue-router";

const route = useRoute();

const songName = computed(() => route.params.songName as string);
const year = computed(() => route.params.year as string);

async function loadSongReviews() {
  let url = "http://localhost:3000/songs/getsongreviews";
  url += `?q=${encodeURIComponent(songName.value.trim().toLowerCase())}`;
  url += `&year=${encodeURIComponent(year.value.trim().toLowerCase())}`;

  const response = await fetch(url);
  return await response.json();
}

const isLoading = ref(false);
const results = computedAsync(loadSongReviews, [], isLoading);

const songRating = computed(() => {
  if (results.value.length == 0) {
    return 0;
  }

  return (
    results.value.reduce((acc, review) => acc + review.rating, 0) /
    results.value.length
  );
});
</script>

<template>
  Song: {{ songName }} - Year: {{ year }}

  <BCard>
    <BCardTitle>{{ songName }}</BCardTitle>
    <BCardText>{{ songRating.toFixed(1) }} based on {{ results.length }} reviews</BCardText>
  </BCard>

  <BCol>
    <BCard v-for="review in results" class="my-4">
      <BCardText>
        <p>Rating: {{ review.rating }}</p>
        <p>Review: {{ review.review_text }}</p>
      </BCardText>
    </BCard>
  </BCol>
</template>
