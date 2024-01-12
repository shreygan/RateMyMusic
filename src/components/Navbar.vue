<style scoped>
.p {
    color: white;
    font-size: large;
}

.white-dropdown-arrow .navbar-toggler-icon::after {
    background-color: white;
}

.navlinks {
    text-decoration: none;
}

.profile-pic {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    margin-right: 10px;
    filter: drop-shadow(0px 0px 2px black);
}
</style>

<script lang="ts">
import { useUserStore } from "../composables/userStore";
import { computed } from "vue";


export default {
    data() {
        return {
            isWhiteArrow: true,
        };
    },
    setup() {
        const { currentUser } = useUserStore();

        const userPid = computed(() => currentUser.value?.pid);

        return {
            userPid,
            currentUser,
        };
    },
    methods: {
        arrayBufferToBase64(buffer: number[]) {
            var binary = "";
            var bytes = new Uint8Array(buffer);
            var len = bytes.byteLength;
            for (var i = 0; i < len; i++) {
                binary += String.fromCharCode(bytes[i]);
            }
            return "data:image/jpeg;base64," + window.btoa(binary);
        },
    },
};
</script>

<template>
    <b-navbar toggleable="lg" type="dark" variant="dark" fixed="top" style="min-height: 5vh">
        <b-navbar-brand to="/" style="color: white; font-size: x-large">RateMyMusic</b-navbar-brand>

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
                    <template #button-content v-if="userPid">
                        <BImg v-if="currentUser.name && currentUser.profile_pic"
                            :src="arrayBufferToBase64(currentUser.profile_pic.data)" class="profile-pic" />
                        <h6 class="d-none d-sm-inline p">
                            {{ currentUser.name ? currentUser.name : "User" }}
                        </h6>
                    </template>

                    <RouterLink v-if="userPid" class="navlinks" :to="{
                        name: '/users/[user]',
                        params: { user: userPid },
                    }">
                        <b-dropdown-item> View Profile </b-dropdown-item>
                    </RouterLink>

                    <RouterLink v-if="userPid" class="navlinks" :to="{
                        name: '/users/[updateuser]',
                        params: { updateuser: userPid },
                    }">
                        <b-dropdown-item> Update User </b-dropdown-item>
                    </RouterLink>

                    <RouterLink v-if="userPid" class="navlinks" :to="{
                        name: '/users/[createreview]',
                        params: { createreview: userPid },
                    }">
                        <b-dropdown-item> Create Review </b-dropdown-item>
                    </RouterLink>

                    <RouterLink v-if="userPid" class="navlinks" :to="{
                        name: '/users/[createuserchart]',
                        params: { createuserchart: userPid },
                    }">
                        <b-dropdown-item> Create UserChart </b-dropdown-item>
                    </RouterLink>

                    <RouterLink v-if="userPid" class="navlinks" :to="{
                        name: '/users/[createplaylist]',
                        params: { createplaylist: userPid },
                    }">
                        <b-dropdown-item> Create Playlist </b-dropdown-item>
                    </RouterLink>

                    <RouterLink v-if="userPid" class="navlinks" :to="{
                        name: '/users/[useralluc]',
                        params: { useralluc: userPid },
                    }">
                        <b-dropdown-item> View UserCharts </b-dropdown-item>
                    </RouterLink>

                    <b-dropdown-item v-if="!userPid" class="navlinks" href="/users/create">Create an
                        Account</b-dropdown-item>
                    <b-dropdown-item v-if="!userPid" class="navlinks" href="/users/login">Sign In</b-dropdown-item>
                </b-nav-item-dropdown>
            </b-navbar-nav>
        </b-collapse>
    </b-navbar>
</template>
