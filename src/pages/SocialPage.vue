<script setup lang="ts">
import axios from "axios";
import { useToast } from "vue-toastification";
import { useUserStore } from "../composables/userStore";

import { sanitizeInput, arrayBufferToBase64 } from "../utils/utils";

const { allUsers, currentUser } = useUserStore();

async function getAllGenres() {
    let url = "http://localhost:3000/songs/getallgenres";

    const response = await fetch(url);
    return await response.json();
}
// const useFilters = ref(false);

// const filters = reactive({
//     selectedGenre: "All",
// });

// const { selectedGenre } = toRefs(filters);

const genreOptions = ref(["All"]);

onMounted(async () => {
    const genres = await getAllGenres();
    genreOptions.value = [
        "All",
        ...genres.map((genreObj: any) => genreObj.Genre),
    ];

    if (currentUser.value.pid) {
        await getUserFollowing();
    }
});

async function followUser(followee: string, followee_username: string) {
    const toast = useToast();
    try {
        const response = await axios.post(
            `http://localhost:3000/users/followuser`, { follower_id: currentUser.value.pid, followee_id: followee });

        if (response.status === 201) {
            toast.success(`Followed @${followee_username} successfully!`);
            refreshKey.value++;
        } else {
            // toast.error(`Error following @${followee_username}`);
            toast.error(`Error following @${followee_username}: ${response.statusText}`);
        }
    } catch (error) {
        // toast.error(`Error following @${followee_username}`);
        if (error.response) {
            console.log(error.response.data);

            if (error.response.data?.errorCode == 1062) {
                toast.error(`You are already following @${followee_username}!`);
            } else {
                toast.error(`Error following @${followee_username}: ${error.response.data?.detailedMessage}`);
            }
        }
    }
}


const isLoading = ref(false);


async function loadUsers() {
    const response = await axios.get('http://localhost:3000/users/getallusers');
    allUsers.value = response.data;
    console.log('Updated allUsers:', allUsers.value);
}

const refreshKey = ref(0);

function getCardKey(user) {
        return `${user.pid}-${refreshKey.value}`;
  }

async function unfollowUser(follower_id: string, followee_id: string, username: string) {
    const toast = useToast();

    console.log("Follower ID: ", follower_id);
    console.log("Followee ID: ", followee_id);
    
    const response = await axios.post(`http://localhost:3000/users/unfollowuser`, { data: { follower_id: follower_id, followee_id: followee_id } });
    console.log(response);
    if (response.status === 201) {
        toast.success(`Unfollowed @${username} successfully!`);
        await getUserFollowing();
        await loadUsers();
    } else {
        toast.error(`Error unfollowing @${followee_id}`);
    }

}

async function getUserFollowing() {
    console.log("COMPUTING");
    isLoading.value = true;

    let url = "http://localhost:3000/users/getuserfollowing";

    if (currentUser.value.pid) {
        url += `?q=${encodeURIComponent(currentUser.value.pid)}`;
    }
    refreshKey.value++;

    const response = await fetch(url);
    return await response.json();
}

const following = computedAsync(getUserFollowing, [], isLoading);
</script>

<template>
    <b-container class="main-container">
        <div class="main-title" style="margin-top: 20%; margin-bottom: 15%">
            <h1>Users of <span class="main">RateMyMusic</span></h1>
        </div>
    </b-container>
    
    <BCol v-for="(users, index) in allUsers" :key="getCardKey(users)" class="mb-3">
        <BCard style="width: 50vh; margin-top: 15%">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2>{{ users.name }}, {{ users.age }}</h2>
                <RouterLink :to="{ name: '/users/[user]', params: { user: users.pid } }">
                    <span>@{{ users.username }}</span>
                </RouterLink>
            </div>

            <b-card-img v-if="users.profile_pic" :src="arrayBufferToBase64(users.profile_pic.data)"
                style="border-radius: 50%; width: 40vh; height: 40vh;" alt="Album Cover"></b-card-img>

            <div class="p-3">
                <BCardText class="d-flex mb-3">
                    <b> Email:</b>&nbsp;&nbsp;{{ users.email }}
                </BCardText>

                <BCardText class="d-flex mb-3">
                    <b> Birthplace:</b>&nbsp;&nbsp;{{ users.birthplace }}
                </BCardText>

                <BCardText class="d-flex mb-3">
                    <b> Birthdate:</b>&nbsp;&nbsp;{{
                        new Date(users.birthdate).toLocaleDateString()
                    }}
                </BCardText>

            </div>

            <BButton v-if="currentUser.pid && currentUser.pid != users.pid &&  !following.some(f => f.followeeid === users.pid)"
                @click="followUser(users.pid, users.username)" style="margin-top: -3%" variant="primary"
                class="btn-bottom-left">
                Follow User
            </BButton>

            <BButton v-if="currentUser.pid && currentUser.pid != users.pid &&  following.some(f => f.followeeid === users.pid)" @click="unfollowUser(currentUser.pid, users.pid, users.username)"
                style="margin-top: -3%" variant="danger" class="btn-bottom-left">
                Unfollow User</BButton>
        </BCard>
    </BCol>
</template>
