

<script setup lang="ts">

import axios from 'axios';

async function loadResults() {
    let url = 'http://localhost:3000/songs/findsongs'

    if (searchTerm.value) {
        url += `?q=${encodeURIComponent(searchTerm.value.trim().toLowerCase())}`
    }
    

    const response = await fetch(url)
    return await response.json()
}

const review = ref({
  rating: 1, // default rating
  reviewText: '',
  albumName: '',
  releaseDate: '', // Ensure this is formatted as expected by your backend
  pid: '' // The PID value, ensure this is correctly set
});


const searchTerm = ref('')
const isLoading = ref(false)
const results = computedAsync(loadResults, [], isLoading)
const showPreview = ref(false);




function selectAlbum(album: any) {
  review.value.songAlbumName = album.album_name;
  searchTerm.value = ''; // Clear search term
}


const getReleaseYear = (dateString: string|number|Date) => {
    const date = new Date(dateString);
    return date.getFullYear();
};


const submitReview = async () => {
  try {
    const response = await axios.post('http://localhost:3000/songs/createalbumreviews', review.value);
    console.log('Review submitted:', response.data);
    // Additional success handling
  } catch (error) {
    console.error('Error submitting review:', error);
    // Additional error handling
  }
};


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
    
    <BContainer class="my-4">
      <BForm @submit.prevent="submitReview">
        <BFormGroup label="Album Name:">
          <BFormInput v-model="review.albumName" placeholder="Enter Album Name" />
        </BFormGroup>
  
        <BFormGroup label="Your Review:">
          <BFormTextarea v-model="review.reviewText" placeholder="Enter your review" rows="4" />
        </BFormGroup>
  
        <BFormGroup label="Rating (1-5):">
          <BFormInput type="number" v-model.number="review.rating" min="1" max="5" placeholder="Rating" />
        </BFormGroup>
  
        <BFormGroup label="Release Date:">
          <BFormInput type="date" v-model="review.releaseDate" placeholder="Release Date" />
        </BFormGroup>
  
        <BFormGroup label="PID:">
          <BFormInput v-model="review.pid" placeholder="Enter PID" />
        </BFormGroup>
  
        <BButton type="submit" variant="primary">Submit Review</BButton>
      </BForm>
    </BContainer>
  </template>
 
   
  


  <style scoped>
  /* Custom styling for the button in the top right corner */
  .btn-top-right {
    position: fixed;
    top: 20px;
    right: 20px;
  }
  
  .review-preview {
    position: fixed;
    top: 20px;
    right: 20px;
    z-index: 1000; /* Ensure it's above other content */
    width: 250px; /* Adjust width as needed */
  }
  
  ul {
    list-style: none;
    padding: 0;
  }
  li {
    cursor: pointer;
    /* additional styles */
  }
  </style>