<script setup lang="ts">
import axios from 'axios';

import { useRoute } from "vue-router";

import { useUserStore } from "../../composables/userStore";

const { allUsers, currentUser } = useUserStore();

const route = useRoute();

const userpid = computed(() => route.params.updateuser as string);


const user = {
  pid: currentUser.value.pid,
  age: currentUser.value.age,
  user: '',
  name: '',
  username: '',
  password: '',
  email: '',
  birthdate: '',
  birthplace: ''
}


async function updateCurrentUser() {
  let url = "http://localhost:3000/users/updateuser";
  console.log("Old User", currentUser.value);
  const response = await axios.post(url, user);
  currentUser.value.name = user.name;
  currentUser.value.username = user.username;
  currentUser.value.password = user.password;
  currentUser.value.email = user.email;
  currentUser.value.birthdate = user.birthdate;
  currentUser.value.birthplace = user.birthplace;
  console.log("Updated user", currentUser.value);

}

</script>

<!-- <template>
  <BRow gutter="4">
    <h2>Update a New User Profile</h2>
    <BCol class="d-flex flex-column gap-2">
      <BFormInput v-model="user.name" placeholder="name" />

      <BFormInput v-model="user.username" placeholder="username" />

      <BFormInput v-model="user.password" placeholder="password" type="password" />

      <BFormInput v-model="user.email" placeholder="email" />

      <BFormInput v-model="user.birthdate" placeholder="birthday" type="date" />

      <BFormInput v-model="user.birthplace" placeholder="birthplace" />

      <BButton variant="primary" @click="createNewUser()">Join</BButton>
    </BCol>
  </BRow>
</template> -->

<template>
    <BRow gutter="4">
      <h2>Update a New User Profile</h2>
      <BCol class="d-flex">
        <div class="flex-column gap-2">
          <!-- Display current user information -->
          <p>Old name: {{ currentUser.name }}</p>
          <p>Old username: {{ currentUser.username }}</p>
          <p>Old password: {{ currentUser.password }}</p>
          <p>Old email: {{ currentUser.email }}</p>
          <p>Old birthdate: {{ currentUser.birthdate }}</p>
          <p>Old birthplace: {{ currentUser.birthplace }}</p>
        </div>
        <BCol class="flex-column gap-2">
          <BFormInput v-model="user.name" placeholder="New name" />
          <BFormInput v-model="user.username" placeholder="New username" />
          <BFormInput v-model="user.password" placeholder="New password" />
          <BFormInput v-model="user.email" placeholder="New email" />
          <BFormInput v-model="user.birthdate" placeholder="New birthday" type="date" />
          <BFormInput v-model="user.birthplace" placeholder="New birthplace" />
          <BButton variant="primary" @click="updateCurrentUser()">Update User</BButton>
        </BCol>
      </BCol>
    </BRow>
  </template>
  
