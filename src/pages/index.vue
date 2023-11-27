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

export default {
    methods: {
        bufferToDataURI(bufferArray: number[]) {
            // Convert the array to a base64-encoded data URI
            const uint8Array = new Uint8Array(bufferArray);
            const base64String = btoa(
                String.fromCharCode.apply(null, Array.from(uint8Array))
            );
            return "data:image/jpeg;base64," + base64String;
        },
    },
    toggleLike(review: any) {
        // Toggle the isLiked property when the checkbox is changed
        review.isLiked = !review.isLiked;

        // Adjust the likes count accordingly (e.g., send a request to the server to update likes count)
        if (review.isLiked) {
            review.likes += 1;
        } else {
            review.likes -= 1;
        }
    },

    toggleDislike(review: any) {
        // Toggle the isLiked property when the checkbox is changed
        review.isLiked = !review.isLiked;

        // Adjust the likes count accordingly (e.g., send a request to the server to update likes count)
        if (review.isLiked) {
            review.likes += 1;
        } else {
            review.likes -= 1;
        }
    },
};
</script>

<style scoped>
.btn-link {
    background-color: transparent;
    border: none;
    cursor: pointer;
}

.upvote-icon {
    width: 20px;
    /* Adjust the width and height based on your image dimensions */
    height: 20px;
    margin-right: -10px;
    margin-top: -2.5px;
    /* Add some spacing between the image and the Likes count */
    transform: rotate(180deg);
    filter: grayscale(100%);
}

.upvote-icon-upvoted {
    width: 25px;
    /* Adjust the width and height based on your image dimensions */
    height: 25px;
    margin-right: -10px;
    margin-top: -2.5px;
    /* Add some spacing between the image and the Likes count */
    transform: rotate(180deg);
}

.downvote-icon {
    width: 20px;
    /* Adjust the width and height based on your image dimensions */
    height: 20px;
    margin-right: -10px;
    margin-top: 0;
    /* Add some spacing between the image and the Likes count */
    filter: grayscale(100%);
}

.downvote-icon-downvoted {
    width: 25px;
    /* Adjust the width and height based on your image dimensions */
    height: 25px;
    margin-right: -10px;
    /* Add some spacing between the image and the Likes count */
    filter: grayscale(100%);
    filter: hue-rotate(240deg);
}
</style>

<template>
    <b-container class="main-container">
        <div class="main-title" style="margin-top: 20%">
            <h1>Welcome to <span class="main">RateMyMusic</span></h1>
            <p>Your go-to place for music ratings and reviews</p>
        </div>
    </b-container>

    <div>
        <BContainer fluid class="my-4">
            <BRow no-gutters>
                <!-- Left Column (Album Reviews) -->
                <BCol lg="6" class="mb-3 column">
                    <BContainer fluid>
                        <BCol v-for="(review, index) in albumReviews" :key="index" class="mb-3">
                            <BCard style="width: 100%">
                                <!-- Large text for album name at the top of the card -->
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h2>{{ review.album_name }}</h2>
                                    <span>@{{ review.username }}</span>
                                </div>

                                <!-- Album cover image -->
                                <b-card-img style="width: 20vw;" :src="bufferToDataURI(review.cover.data)" alt="Album Cover"></b-card-img>

                                <!-- Other card content -->
                                <div class="p-3">
                                    <BCardText class="d-flex justify-content-between align-items-center mb-3">{{
                                        review.review_text }}</BCardText>
                                    <!-- <BCardText class="d-flex justify-content-between align-items-center mb-3">{{
                                        review.likes }}</BCardText> -->

                                    <div class="d-flex align-items-center">
                                        <button @click="toggleLike(review)" class="btn btn-link upvote-button">
                                            <img v-if="review.isLiked" src="/src/assets/vote.png" alt="Upvoted"
                                                class="upvote-icon-upvoted" />
                                            <img v-else src="/src/assets/vote.png" alt="Upvote" class="upvote-icon" />
                                        </button>
                                        <!-- <img src="/src/assets/vote.png"> -->
                                        <span class="me-4">{{ review.likes }} </span>
                                    </div>

                                    <!-- ADD UserReviewLikes and UserCommentLikes tables, so we can store what reviews and comments a user has liked -->
                                    <!-- to make sure that review.isLiked work properly -->

                                    <div class="d-flex align-items-center">
                                        <button @click="toggleDislike(review)" class="btn btn-link upvote-button">
                                            <img v-if="review.isLiked" src="/src/assets/vote.png" alt="Downvoted"
                                                class="downvote-icon-downvoted" />
                                            <img v-else src="/src/assets/vote.png" alt="Downvote" class="downvote-icon" />
                                        </button>
                                        <!-- <img src="/src/assets/vote.png"> -->
                                        <span class="me-4">{{ review.dislikes }} </span>
                                    </div>

                                    <!-- <BCardText>{{ review.dislikes }}</BCardText> -->
                                    <BCardFooter>Rating: {{ review.rating }}</BCardFooter>
                                </div>
                            </BCard>
                        </BCol>
                    </BContainer>
                </BCol>

                <!-- Right Column (Song Reviews) -->
                <!-- <BCol lg="6" class="mb-3 column">
                    <BContainer fluid>
                        <BCol v-for="(review, index) in songReviews" :key="index" class="mb-3">
                            <BCard style="width: 100%;">
                                <b-card-img :src="bufferToDataURI(review.cover.data)" alt="Album Cover"></b-card-img>
                                <BCardTitle>{{ review.song_name }}</BCardTitle>
                                <BCardText>{{ review.review_text }}</BCardText>
                                <BCardText>{{ review.likes }}</BCardText>
                                <BCardText>{{ review.dislikes }}</BCardText>
                                <BCardFooter>Rating: {{ review.rating }}</BCardFooter>
                            </BCard>
                        </BCol>
                    </BContainer>
                </BCol> -->
                <BCol lg="6" class="mb-3 column">
                <BContainer fluid>
                    <BCol v-for="(review, index) in songReviews" :key="index" class="mb-3">
                        <BCard style="width: 100%">
                            <!-- Large text for album name at the top of the card -->
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h2>{{ review.song_name }}</h2>
                                <span>@{{ review.username }}</span>
                            </div>

                            <!-- Album cover image -->
                            <b-card-img style="width: 20vw;" :src="bufferToDataURI(review.cover.data)" alt="Album Cover"></b-card-img>

                            <!-- Other card content -->
                            <div class="p-3">
                                <BCardText class="d-flex justify-content-between align-items-center mb-3">{{
                                    review.review_text }}</BCardText>
                                <!-- <BCardText class="d-flex justify-content-between align-items-center mb-3">{{
                                        review.likes }}</BCardText> -->

                                <div class="d-flex align-items-center">
                                    <button @click="toggleLike(review)" class="btn btn-link upvote-button">
                                        <img v-if="review.isLiked" src="/src/assets/vote.png" alt="Upvoted"
                                            class="upvote-icon-upvoted" />
                                        <img v-else src="/src/assets/vote.png" alt="Upvote" class="upvote-icon" />
                                    </button>
                                    <!-- <img src="/src/assets/vote.png"> -->
                                    <span class="me-4">{{ review.likes }} </span>
                                </div>

                                <div class="d-flex align-items-center">
                                    <button @click="toggleDislike(review)" class="btn btn-link upvote-button">
                                        <img v-if="review.isLiked" src="/src/assets/vote.png" alt="Downvoted"
                                            class="downvote-icon-downvoted" />
                                        <img v-else src="/src/assets/vote.png" alt="Downvote" class="downvote-icon" />
                                    </button>
                                    <!-- <img src="/src/assets/vote.png"> -->
                                    <span class="me-4">{{ review.dislikes }} </span>
                                </div>

                                <!-- <BCardText>{{ review.dislikes }}</BCardText> -->
                                <BCardFooter>Rating: {{ review.rating }}</BCardFooter>
                            </div>
                        </BCard>
                    </BCol>
                </BContainer>
                </BCol>
            </BRow>
        </BContainer>
    </div>
</template>
