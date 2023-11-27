<script setup lang="ts">
import axios from "axios";
import { useUserStore } from "../../composables/userStore";

const { allUsers, currentUser } = useUserStore();

const user = {
  username: "",
  password: "",
  email: "",
  birthday: "",
  birthplace: "",
};

async function login() {
  let url = "http://localhost:3000/users/login";

  const response = await axios.post(url, user);

  if (response.data) {
    console.log(response.data);
    // currentUser.value = response.data;
    currentUser.value = response.data.pid;
    console.log(currentUser.value);
  }
}
</script>

<template>
  <BRow gutter="4">
    <h2>Login</h2>
    <BCol class="d-flex flex-column gap-2">
      <BFormInput v-model="user.username" placeholder="username" />

      <BFormInput
        v-model="user.password"
        placeholder="password"
        type="password"
      />

      <BButton variant="primary" @click="login()">Join</BButton>
    </BCol>
  </BRow>
</template>
