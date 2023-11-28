<script setup lang="ts">
import { useUserStore } from "../composables/userStore";
const { allUsers } = useUserStore();

async function loadResults() {
  let url = "http://localhost:3000/songs/findalbums";

  if (searchTerm.value) {
    url += `?q=${encodeURIComponent(searchTerm.value.trim().toLowerCase())}`;
  }

  const response = await fetch(url);
  return await response.json();
}

const searchTerm = ref("");
const selectedIndices = ref<number[]>([]);
const isLoading = ref(false);
const results = computedAsync(loadResults, [], isLoading);

const getReleaseYear = (dateString) => {
  const date = new Date(dateString);
  return date.getFullYear();
};

function getImagePath(name: string) {
  const url = new URL(`../assets/albums/${name}.jpg`, import.meta.url);
  return url.href;
}

function toggleCardSelection(index: number) {
    if (selectedIndices.value.includes(index) && selectedIndices.value.length <= 9) {
        selectedIndices.value = selectedIndices.value.filter((i) => i !== index);
    } else if (selectedIndices.value.length <= 9) {
        selectedIndices.value.push(index);
    }
}

const selectedAlbumCovers = computed(() => {
  const covers = Array(9).fill('https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Square_gray.svg/2048px-Square_gray.svg.png');

  // Fill in the grid with the selected album covers in order
  selectedIndices.value.forEach((index, i) => {
    if (i < 9) {
      covers[i] = getImagePath(results.value[index].album_name);
    }
  });

  return covers;
});

function getGridImage(index: number) {
  return selectedAlbumCovers.value[index];
}
</script>

<template>
  <BContainer style="margin-top: 10rem">
    <BRow>
      <BCol>
        <h1>Create a Chart</h1>
      </BCol>
    </BRow>

    <BRow>
      <BFormInput
        class="my-4"
        v-model="searchTerm"
        placeholder="Search for a song"
        style="max-width: 20rem; margin-right: auto; margin-left: auto"
      />

      <BContainer class="search-results">
        <BRow style="max-width: 600px;">
        <BCol v-for="(result, index) in results" :key="index" class="my-3">
          <BCard
            style="width: 100%"
            class="search-item"
            :img-src="getImagePath(result.album_name)"
            @click="toggleCardSelection(index)"
            :bg-variant="selectedIndices.includes(index) ? 'primary' : 'secondary'"
          >
            <RouterLink
              :to="{
                name: '/songs/[songName]/[year]',
                params: {
                  songName: result.album_name,
                  year: result.release_date,
                },
              }"
              style="color: white; text-decoration: none"
            >
              <h4>
                {{ result.album_name }} ({{
                  getReleaseYear(result.release_date)
                }})
              </h4>
            </RouterLink>
          </BCard>
        </BCol>
    </BRow>
      </BContainer>
    </BRow>

    <BRow v-for="row in 3" :key="row" class="grid-row my-4 mx-4">
      <BCol v-for="col in 3" :key="col" class="grid-col">
        <BImg
          class="chartImg"
          
          :src="getGridImage((row - 1) * 3 + (col - 1))"
        />
        <div class="grid-item"></div>
      </BCol>
    </BRow>
  </BContainer>
</template>

<style scoped>
.chartImg {
  max-width: 15rem;
  max-height: 15rem;
}

.grid-row {
  display: flex;
}

.grid-col {
  flex: 1;
}

.search-item {
  /* width: 20rem; */
  max-width: 15rem;
  min-width: 15rem;
}

.search-results {
  max-height: 250px;
  overflow-y: auto;
  max-width: 600px;
}
</style>
