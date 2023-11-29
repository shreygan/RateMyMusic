<script setup lang="ts">
import axios from 'axios';
import { useRoute } from "vue-router";
import { useToast } from "vue-toastification";

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
    const toast = useToast();
    let url = "http://localhost:3000/users/createuser";


    const fields = [
        { key: 'name', message: 'Please enter your name' },
        { key: 'username', message: 'Please enter your username' },
        { key: 'password', message: 'Please enter your password' },
        { key: 'email', message: 'Please enter your email' },
        { key: 'birthdate', message: 'Please enter your birthdate' },
        { key: 'birthplace', message: 'Please enter your birthplace' },
    ];

    var failed = false;
    fields.map(field => {
        if (user[field.key] === '') {
            failed = true;
            return toast.error(field.message);
        }
    });
    if (failed) return;


    try {
        const response = await axios.post(url, user);
        console.log(response.data);
        toast.success("User account Successfully");
    } catch (error) {
        // toast.error(`Error following @${followee_username}`);
        if (error.response) {
            console.log(error.response.data);

            if (error.response.data?.errorCode == 1062) {
                toast.error(`This username already exists!`);
            } else {
                toast.error(`Error following ${error.response.data?.detailedMessage}`);
            }
        }
    }



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

            <b-form-file v-model="user.profile_pic" :state="Boolean(user.profile_pic)"
                placeholder="Choose a file or drop it here..." drop-placeholder="Drop the file here..."></b-form-file>

            <BButton variant="primary" @click="createNewUser()">Join</BButton>
        </BCol>
    </BRow>
</template>
