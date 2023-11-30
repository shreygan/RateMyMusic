<script setup lang="ts">
import axios from "axios";
import { useUserStore } from "../../composables/userStore";
import { sanitizeInput } from "../../utils/utils";

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

  for (const field in user) {
    if (typeof user[field] === 'string') {
      user[field] = sanitizeInput(user[field]);
    }
  }

  const response = await axios.post(url, user);

  if (response.data) {
    currentUser.value = response.data;
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
