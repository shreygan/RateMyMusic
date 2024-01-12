<script setup lang="ts">
import { useRoute } from "vue-router";
import axios from "axios";
import { useToast } from "vue-toastification";
import { useUserStore } from "../../composables/userStore";
import { sanitizeInput, arrayBufferToBase64 } from "../../utils/utils";
const { currentUser } = useUserStore();

const route = useRoute();

const userpid = computed(() => route.params.user as string);

const profile = reactive({
    pid: "",
    name: "",
    username: "",
    email: "",
    birthdate: "",
    birthplace: "",
    age: "",
    profile_pic: "",
    followers: 0,
    following: 0,
});

onMounted(() => {
    getProfile();
});

function renderStars(rating: number) {
    const stars: string[] = [];
    for (let i = 0; i < 5; i++) {
        if (i < rating) {
            stars.push('★');
        } else {
            stars.push('☆');
        }
    }
    return stars.join(' ');
}

async function getProfile() {
    let url = "http://localhost:3000/users/getuserbyid";

    if (userpid.value) {
        url += `?q=${encodeURIComponent(userpid.value)}`;
    }

    const response = await fetch(url);
    const data = await response.json();
    profile.pid = data[0].pid;
    profile.name = data[0].name;
    profile.username = data[0].username;
    profile.email = data[0].email;
    profile.birthdate = data[0].birthdate;
    profile.birthplace = data[0].birthplace;
    profile.age = data[0].age;
    profile.profile_pic = data[0].profile_pic;
    profile.followers = data[0].followers;
    profile.following = data[0].following;
}

async function loadAlbumReviews() {
    let url = "http://localhost:3000/users/getuseralbumreviews";

    if (profile.pid) {
        url += `?q=${encodeURIComponent(profile.pid)}`;
    }
    const response = await fetch(url);
    return await response.json();
}

async function loadSongReviews() {
    let url = "http://localhost:3000/users/getusersongreviews";

    if (profile.pid) {
        url += `?q=${encodeURIComponent(profile.pid)}`;
    }
    const response = await fetch(url);
    return await response.json();
}

async function loadUserchartReviews() {
    let url = "http://localhost:3000/users/getuseruserchartreviews";

    if (profile.pid) {
        url += `?q=${encodeURIComponent(profile.pid)}`;
    }

    const response = await fetch(url);
    return await response.json();
}

async function deleteReview(rid: string, userpid: string) {
    const toast = useToast();
    let url = "http://localhost:3000/users/deletereview";

    try {
        const response = await axios.post(url, { rid: rid, userpid: userpid });

        if (selectedFilter.value === "Album Reviews") {
            albumReviews.value = albumReviews.value.filter(
                (review: any) => review.rid !== rid
            );
        } else if (selectedFilter.value === "Song Reviews") {
            songReviews.value = songReviews.value.filter(
                (review: any) => review.rid !== rid
            );
        }

        toast.success("Review deleted");
    } catch (error) {
        toast.error("Error deleting review");
    }
}

async function avgRatingPerUser(agg_choice: string) {
    let url = "http://localhost:3000/users/avgratingperuser";
    const response = await axios.post(url, {
        aggChoice: agg_choice,
        pid: userpid.value,
    });
    return await response.data;
}


const isLoading = ref(false);

const albumReviews = computedAsync(loadAlbumReviews, [], isLoading);
const songReviews = computedAsync(loadSongReviews, [], isLoading);
const userchartReviews = computedAsync(loadUserchartReviews, [], isLoading);

const selectedFilter = ref("Song Reviews"); // Default filter
const filterOptions = ["Song Reviews", "Album Reviews", "UserChart Reviews"];
</script>

<script lang="ts">
export default {
    data() {
        return {
            selectedAggregation: "SUM",
        };
    },
};
</script>

<template>
    <BCol class="mb-3">
        <BCard style="width: 35rem; margin-top: 5rem;">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2>{{ profile.name }}, {{ profile.age }}</h2>
                <span>@{{ profile.username }}</span>
            </div>

            <b-card-img v-if="profile.profile_pic" :src="arrayBufferToBase64(profile.profile_pic.data)" alt="Album Cover"
                style="width: 100%; border-radius: 50%;"></b-card-img>

            <div class="p-3">
                <BCardText class="d-flex mb-3">
                    <b> Email:</b>&nbsp;&nbsp;{{ profile.email }}
                </BCardText>

                <BCardText class="d-flex mb-3">
                    <b> Birthplace:</b>&nbsp;&nbsp;{{ profile.birthplace }}
                </BCardText>

                <BCardText class="d-flex mb-3">
                    <b> Birthdate:</b>&nbsp;&nbsp;{{
                        new Date(profile.birthdate).toLocaleDateString()
                    }}
                </BCardText>

                <BCardText class="d-flex mb-3">
                    <b> Followers:</b>&nbsp;&nbsp;{{ profile.followers }}
                </BCardText>

                <BCardText class="d-flex mb-3">
                    <b> Following:</b>&nbsp;&nbsp;{{ profile.following }}
                </BCardText>
                <div>
                    <RouterLink :to="{ name: '/users/[userstats]', params: { userstats: userpid } }">
                        <BButton style="margin-top: 3%; width: 53%;" variant="primary" class="btn-bottom-left">View User
                            Stats
                        </BButton>
                    </RouterLink>
                </div>
                <div>
                    <RouterLink :to="{ name: '/users/[followers]', params: { followers: userpid } }">
                        <BButton style="margin-top: 3%; width: 53%;" variant="primary" class="btn-bottom-left">View
                            Followers
                        </BButton>
                    </RouterLink>
                </div>
                <div>
                    <RouterLink :to="{ name: '/users/[following]', params: { following: userpid } }">
                        <BButton style="margin-top: 3%; width: 53%;" variant="primary" class="btn-bottom-left">View
                            Following
                        </BButton>
                    </RouterLink>
                </div>
                <div>
                    <RouterLink :to="{ name: '/users/[useralluc]', params: { useralluc: userpid } }">
                        <BButton style=" margin-bottom: -10%; width: 53%" variant="primary" class="btn-bottom-left">View
                            User Charts
                        </BButton>
                    </RouterLink>
                </div>
            </div>
        </BCard>
    </BCol>

    <BCol class="mb-4">
        <BFormSelect v-model="selectedFilter" class="mr-2" style="width: 35rem;">
            <option v-for="filter in filterOptions" :key="filter" :value="filter">
                {{ filter }}
            </option>
        </BFormSelect>
    </BCol>

    <BContainer fluid class="my-4">
        <!-- <BCol v-if="selectedFilter == 'Album Reviews'" lg="6" class="mb-3 column">
            <BContainer fluid>
                <BCol v-for="(review, index) in albumReviews" :key="index" class="mb-3">
                    <BCard style="width: 32rem;">
                        <RouterLink style="text-decoration: none; color: black;" :to="{
                            name: '/users/[pid]/[rid]/[type]',
                            params: {
                                pid: userpid,
                                rid: review.rid,
                                type: 'Album'
                            }
                        }">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h2>{{ review.album_name }}</h2>
                                <span>@{{ profile.username }}</span>
                            </div>

                            <b-card-img style="width: 30vh;" :src="arrayBufferToBase64(review.cover.data)"
                                alt="Album Cover"></b-card-img>

                            <div class="p-3">
                                <BCardText class="d-flex justify-content-between align-items-center mb-3">{{
                                    review.review_text }}</BCardText>

                                <BCardFooter>Rating: {{ review.rating }}</BCardFooter>
                            </div>
                        </RouterLink>

                        <BButton v-if="currentUser && currentUser.pid == profile.pid"
                            style="margin-top: 3%; margin-bottom: -3%" variant="danger" class="btn-bottom-left"
                            @click="deleteReview(review.rid, profile.pid)">Delete Review</BButton>
                    </BCard>
                </BCol>
            </BContainer>
        </BCol> -->

        <BCol v-if="selectedFilter == 'Album Reviews'" lg="6" class="mb-3 column">
            <BContainer>
                <BCol v-for="(review, index) in albumReviews" :key="index" class="mb-3">
                    <BCard style="width: 32.5rem; min-height: 20rem;">
                        <small class="text-muted" style="position: absolute; top: 5%; left: 5%;">Album</small>
                        <small class="text-muted" style="position: absolute; top: 5%; right: 5%;">
                            {{ new Date(review.review_date).toLocaleString([], {
                                year: 'numeric', month: 'numeric',
                                day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: false
                            })
                            }}</small>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <RouterLink style="text-decoration: none; color: inherit;"
                                :to="{ name: '/albums/[albumName]/[year]', params: { albumName: review.album_name, year: review.release_date } }">
                                <h2>{{ review.album_name }}</h2>
                            </RouterLink>
                            <span>@{{ profile.username }}</span>
                        </div>


                        <b-card-img style="max-width: 10rem" :src="arrayBufferToBase64(review.cover.data)"
                            alt="Album Cover"></b-card-img>

                        <div class="p-3">
                            <BCardText class="d-flex justify-content-between align-items-center mb-3">{{
                                review.review_text }}</BCardText>

                            <BCardFooter style="margin-bottom: -5%;"> {{ renderStars(review.rating) }}</BCardFooter>

                            <BButton v-if="currentUser && currentUser.pid == profile.pid"
                                style="margin-top: 2.25rem; margin-bottom: -2.25rem;" variant="danger"
                                class="btn-bottom-left" @click="deleteReview(review.rid, profile.pid)">Delete Review
                            </BButton>
                        </div>
                    </BCard>
                </BCol>
            </BContainer>
        </BCol>

        <BCol v-if="selectedFilter == 'Song Reviews'" lg="6" class="mb-3 column">
            <BContainer>

                <BCol v-for="(review, index) in songReviews" :key="index" class="mb-3">
                    <BCard style="width: 32.5rem; min-height: 20rem;">
                        <small class="text-muted" style="position: absolute; top: 5%; left: 5%;">Song</small>
                        <small class="text-muted" style="position: absolute; top: 5%; right: 5%;">
                            {{ new Date(review.review_date).toLocaleString([], {
                                year: 'numeric', month: 'numeric',
                                day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: false
                            })
                            }}</small>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <RouterLink style="text-decoration: none; color: inherit;"
                                :to="{ name: '/songs/[songName]/[year]', params: { songName: review.song_name, year: review.release_date } }">
                                <h2>{{ review.song_name }}</h2>
                            </RouterLink>
                            <span>@{{ profile.username }}</span>
                        </div>

                        <b-card-img v-if="review.cover" style="max-width: 10rem"
                            :src="arrayBufferToBase64(review.cover.data)" alt="Album Cover"></b-card-img>

                        <div class="p-3">
                            <BCardText class="d-flex justify-content-between align-items-center mb-3">
                                {{ review.review_text }}
                            </BCardText>

                            <BCardFooter style="margin-bottom: -5%;"> {{ renderStars(review.rating) }}</BCardFooter>

                            <BButton v-if="currentUser && currentUser.pid == profile.pid"
                                style="margin-top: 2.25rem; margin-bottom: -2.25rem;" variant="danger"
                                class="btn-bottom-left" @click="deleteReview(review.rid, profile.pid)">Delete Review
                            </BButton>
                        </div>
                    </BCard>
                </BCol>
            </BContainer>
        </BCol>

        <!-- 
        <BCol v-if="selectedFilter == 'Song Reviews'" lg="6" class="mb-3 column">
            <BContainer fluid>
                <BCol style="width: 32rem;" v-for="(review, index) in songReviews" :key="index" class="mb-3">
                    <BCard>
                        <RouterLink style="text-decoration: none; color: black;"
                            :to="{ name: '/users/[pid]/[rid]/[type]', params: { pid: userpid, rid: review.rid, type: selectedFilter.split(' ')[0] } }">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h2>{{ review.song_name }}</h2>
                                <span>@{{ profile.username }}</span>
                            </div>

                            <b-card-img style="width: 30vh;" :src="arrayBufferToBase64(review.cover.data)"
                                alt="Album Cover"></b-card-img>

                            <div class="p-3">
                                <BCardText class="d-flex justify-content-between align-items-center mb-3">{{
                                    review.review_text }}</BCardText>
                                <BCardFooter>Rating: {{ review.rating }}</BCardFooter>
                            </div>
                        </RouterLink>

                        <BButton v-if="currentUser && currentUser.pid == profile.pid"
                            style="margin-top: 3%; margin-bottom: -3%" variant="danger" class="btn-bottom-left"
                            @click="deleteReview(review.rid, profile.pid)">
                            Delete Review</BButton>
                    </BCard>
                </BCol>
            </BContainer>
        </BCol> -->

        <BCol v-if="selectedFilter == 'UserChart Reviews'" lg="6" class="mb-3 column">
            <BContainer>

                <BCol v-for="(review, index) in userchartReviews" :key="index" class="mb-3">
                    <BCard style="width: 32.5rem; min-height: 20rem;">
                        <small class="text-muted" style="position: absolute; top: 5%; left: 5%;">UserChart</small>
                        <small class="text-muted" style="position: absolute; top: 5%; right: 5%;">
                            {{ new Date(review.review_date).toLocaleString([], {
                                year: 'numeric', month: 'numeric',
                                day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: false
                            })
                            }}</small>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <!-- <RouterLink style="text-decoration: none; color: inherit;"
                                :to="{ name: '/songs/[songName]/[year]', params: { songName: review.song_name, year: review.release_date } }">
                                <h2>{{ review.song_name }}</h2>
                            </RouterLink> -->
                            <RouterLink style="text-decoration: none; color: black;" :to="{
                                name: '/users/[pid]/[rid]/[type]',
                                params: {
                                    pid: userpid,
                                    rid: review.rid,
                                    type: 'Userchart'
                                }}">
                                <h2>{{ review.userchart_name }}</h2>
                             </RouterLink>
                            <span>@{{ profile.username }}</span>
                        </div>

                        <b-card-img v-if="review.image" style="max-width: 10rem"
                            :src="arrayBufferToBase64(review.image.data)" alt="Album Cover"></b-card-img>

                        <div class="p-3">
                            <BCardText class="d-flex justify-content-between align-items-center mb-3">
                                {{ review.review_text }}
                            </BCardText>

                            <BCardFooter style="margin-bottom: -5%;"> {{ renderStars(review.rating) }}</BCardFooter>

                            <BButton v-if="currentUser && currentUser.pid == profile.pid"
                                style="margin-top: 2.25rem; margin-bottom: -2.25rem;" variant="danger"
                                class="btn-bottom-left" @click="deleteReview(review.rid, profile.pid)">Delete Review
                            </BButton>
                        </div>
                    </BCard>
                </BCol>
            </BContainer>
        </BCol>

<!-- 
        <BCol v-if="selectedFilter == 'UserChart Reviews'" lg="6" class="mb-3 column">
            <BContainer fluid>
                <BCol v-for="(review, index) in userchartReviews" :key="index" class="mb-3">
                    <BCard style="width: 32rem;">
                        <RouterLink style="text-decoration: none; color: black;" :to="{
                            name: '/users/[pid]/[rid]/[type]',
                            params: {
                                pid: userpid,
                                rid: review.rid,
                                type: 'Userchart'
                            }
                        }">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h2>{{ review.userchart_name }}</h2>
                                <span>@{{ profile.username }}</span>
                            </div>

                            <b-card-img v-if="review.image" style="width: 30vh;"
                                :src="arrayBufferToBase64(review.image.data)" alt="Album Cover"></b-card-img>

                            <div class="p-3">
                                <BCardText class="d-flex justify-content-between align-items-center mb-3">{{
                                    review.review_text }}</BCardText>

                                <BCardFooter>Rating: {{ review.rating }}</BCardFooter>
                            </div>
                        </RouterLink>

                        <BButton v-if="currentUser && currentUser.pid == profile.pid"
                            style="margin-top: 3%; margin-bottom: -3%" variant="danger" class="btn-bottom-left"
                            @click="deleteReview(review.rid, profile.pid)">Delete Review</BButton>
                    </BCard>
                </BCol>
            </BContainer>
        </BCol> -->

    </BContainer>
</template>
