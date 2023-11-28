<style scoped>
.p {
    color: white;
    font-size: large;
}

.p:hover {
    color: black;
}

.white-dropdown-arrow .navbar-toggler-icon::after {
    background-color: white;
}
</style>

<script lang="ts">
import { useUserStore } from "../composables/userStore";
import { computed } from "vue";

export default {
    data() {
        return {
            isWhiteArrow: true, // Set to true if you want the white arrow initially
        };
    },
    setup() {
        const { allUsers, currentUser } = useUserStore();

        const userPid = computed(() => currentUser.value?.pid);

        return {
            userPid,
            currentUser,
        };
    },
    // print() {
    //     console.log("hello");
    // }
};
</script>

<template>
    <!-- <BButton variant="primary" @click="print()"> Print </BButton> -->

    <b-navbar toggleable="lg" type="dark" variant="danger" fixed="top" sticky>
        <b-navbar-brand to="/" style="color: white; font-size: x-large;">RateMyMusic</b-navbar-brand>

        <b-navbar-toggle target="nav-collapse" class="p"></b-navbar-toggle>

        <b-collapse id="nav-collapse" is-nav>
            <b-navbar-nav>
                <b-nav-item to="/AlbumPage"><span class="p">Albums</span></b-nav-item>
                <b-nav-item to="/SongPage"><span class="p">Songs</span></b-nav-item>
                <b-nav-item to="/UserCharts"><span class="p">UserCharts</span></b-nav-item>
                <b-nav-item to="/Playlists"><span class="p">Playlists</span></b-nav-item>
                <b-nav-item to="/SocialPage"><span class="p">Social</span></b-nav-item>
            </b-navbar-nav>

            <b-navbar-nav class="justify-content-end" style="flex: 1">
                <b-nav-item-dropdown :toggle-class="{ 'white-dropdown-arrow': isWhiteArrow }" right>
                    <template #button-content>
                        <em class="d-none d-sm-inline p">User</em>
                        <em class="d-sm-none">U</em>
                    </template>

                    <!-- <b-dropdown-item href="#">View Profile</b-dropdown-item> -->
                    <RouterLink v-if="userPid" :to="{
                        name: '/users/[user]',
                        params: { user: userPid },
                    }">
                        <b-dropdown-item> View Profile </b-dropdown-item>
                    </RouterLink>


                    <RouterLink v-if="userPid" :to="{
                        name: '/users/[updateuser]',
                        params: { updateuser: userPid },
                    }">
                        <b-dropdown-item> Update User </b-dropdown-item>
                    </RouterLink>

                    <RouterLink v-if="userPid" :to="{
                        name: '/users/[createreview]',
                        params: { createreview: userPid },
                    }">
                        <b-dropdown-item> Create Review </b-dropdown-item>
                    </RouterLink>

                    <RouterLink v-if="userPid" :to="{
                        name: '/users/[createuserchart]',
                        params: { createuserchart: userPid },
                    }">
                        <b-dropdown-item> Create UserChart </b-dropdown-item>
                    </RouterLink>

                    <RouterLink v-if="userPid" :to="{
                        name: '/users/[createplaylist]',
                        params: { createplaylist: userPid },
                    }">
                        <b-dropdown-item> Create Playlist </b-dropdown-item>
                    </RouterLink>

                    <RouterLink v-if="userPid" :to="{
                        name: '/users/[useralluc]',
                        params: { useralluc: userPid },
                    }">
                        <b-dropdown-item> View UserCharts </b-dropdown-item>
                    </RouterLink>



                    <b-dropdown-item v-if="!userPid" href="/users/create">Create an Account</b-dropdown-item>
                    <b-dropdown-item v-if="!userPid" href="/users/login">Sign In</b-dropdown-item>

                    <!-- {{ console.log(allUsers.value) }} -->
                </b-nav-item-dropdown>
            </b-navbar-nav>
        </b-collapse>
    </b-navbar>
</template>
