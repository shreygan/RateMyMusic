<script setup lang="ts">
import axios from 'axios';

const user = {
  username: '',
  password: '',
  email: '',
  birthday: '',
  birthplace: ''}


async function createNewUser() {
  let url = "http://localhost:3000/users/createuser";

  const response = await axios.post(url, user);
}
</script>

<template>
  <BRow gutter="4">
    <h2>Create a New User Profile</h2>
    <BCol class="d-flex flex-column gap-2">
      <BFormInput v-model="user.username" placeholder="username" />

      <BFormInput v-model="user.password" placeholder="password" type="password" />

      <BFormInput v-model="user.email" placeholder="email" />

      <BFormInput v-model="user.birthday" placeholder="birthday" type="date" />

      <BFormInput v-model="user.birthplace" placeholder="birthplace" />

      <BButton variant="primary" @click="createNewUser()">Join</BButton>
    </BCol>
  </BRow>
</template>
