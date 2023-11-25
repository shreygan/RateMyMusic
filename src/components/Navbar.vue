
<style scoped>
.p {
    color: white;
    font-size: large;
}

.pp {
    color: white;
    font-size: x-large;
}

.white-dropdown-arrow .navbar-toggler-icon::after {
    background-color: white;
  }
</style>

<script>
export default {
    data() {
        return {
            isWhiteArrow: true, // Set to true if you want the white arrow initially
        };
    },
    // Add methods or lifecycle hooks as needed
};
</script>

<template>
    <b-navbar toggleable="lg" type="dark" variant="danger" fixed="top" sticky>
        <b-navbar-brand href="#" class="pp">RateMyMusic</b-navbar-brand>

        <b-navbar-toggle target="nav-collapse" class="p"></b-navbar-toggle>

        <b-collapse id="nav-collapse" is-nav>
            <b-navbar-nav>
                <b-nav-item to="/AlbumPage"><span class="p">Albums</span></b-nav-item>
                <b-nav-item to="/SongPage"><span class="p">Songs</span></b-nav-item>
                <b-nav-item href="#"><span class="p">User Charts</span></b-nav-item>
                <b-nav-item href="#"><span class="p">Playlists</span></b-nav-item>
            </b-navbar-nav>

            <b-navbar-nav class="justify-content-end" style="flex: 1">
                <b-nav-item-dropdown :toggle-class="{ 'white-dropdown-arrow': isWhiteArrow }" right>
                    <template #button-content>
                        <em class="d-none d-sm-inline p">User</em>
                        <em class="d-sm-none">U</em>
                    </template>
                    <b-dropdown-item href="/CreateReviewPage">Add a Review</b-dropdown-item>
                    <b-dropdown-item href="#">Create an Account</b-dropdown-item>
                    <b-dropdown-item href="#">Sign In</b-dropdown-item>
                </b-nav-item-dropdown>
            </b-navbar-nav>
        </b-collapse>
    </b-navbar>
</template>

