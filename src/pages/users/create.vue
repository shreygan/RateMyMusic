<script setup lang="ts">
import axios from 'axios';

const user = {
    name: '',
    username: '',
    password: '',
    email: '',
    birthdate: '',
    birthplace: '',
    profile_pic: null,
}


async function createNewUser() {
    let url = "http://localhost:3000/users/createuser";

    const response = await axios.post(url, user);

    // const formData = new FormData();

    // // Append user data to formData
    // Object.entries(user).forEach(([key, value]) => {
    //     formData.append(key, value);
    // });

    // // Append file data to formData
    // if (file.value) {
    //     formData.append('profile_pic', file.value);
    // }

    // try {
    //     const response = await axios.post('http://localhost:3000/users/createuser', formData, {
    //         headers: {
    //             'Content-Type': 'multipart/form-data',
    //         },
    //     });

    //     // Handle the response as needed
    //     console.log(response.data);
    // } catch (error) {
    //     // Handle error
    //     console.error('Error creating new user:', error);
}
</script>

<template>
    <BRow gutter="4">
        <h2>Create a New User Profile</h2>
        <BCol class="d-flex flex-column gap-2">
            <BFormInput v-model="user.name" placeholder="name" />

            <BFormInput v-model="user.username" placeholder="username" />

            <BFormInput v-model="user.password" placeholder="password" type="password" />

            <BFormInput v-model="user.email" placeholder="email" />

            <BFormInput v-model="user.birthdate" placeholder="birthday" type="date" />

            <BFormInput v-model="user.birthplace" placeholder="birthplace" />

            <b-form-file v-model="user.profile_pic" :state="Boolean(user.profile_pic)" placeholder="Choose a file or drop it here..."
                drop-placeholder="Drop the file here..."></b-form-file>

            <BButton variant="primary" @click="createNewUser()">Join</BButton>
        </BCol>
    </BRow>
</template>
