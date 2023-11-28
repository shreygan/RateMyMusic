<script setup lang="ts">
import axios from "axios";
import { useUserStore } from "../../composables/userStore";

const { allUsers, currentUser } = useUserStore();
const successModal = ref(false);

const user = {
  username: "",
  password: "",
  email: "",
  birthdate: "",
  birthplace: "",
};

async function login() {
  console.log(currentUser.value);
  console.log(allUsers.value);
  let url = "http://localhost:3000/users/login";

  const response = await axios.post(url, user);

  if (response.data) {
    // console.log(response.data);
    // currentUser.value = response.data;
    currentUser.value = response.data;
    console.log(currentUser.value);
    console.log(currentUser.value.pid);
    console.log(currentUser.value.username);
    console.log(currentUser.value.email);
    console.log(currentUser.value.birthdate);
    console.log(currentUser.value.birthplace);
    successModal.value = true;
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
      <BModal v-model="successModal" title="Success!">You may now browse and review songs and albums.</BModal>
    </BCol>
  </BRow>
</template>
