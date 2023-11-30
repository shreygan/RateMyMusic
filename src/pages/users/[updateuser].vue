<script setup lang="ts">
import axios from "axios";
import { useRoute } from "vue-router";
import { useUserStore } from "../../composables/userStore";
import { useToast } from "vue-toastification";
import { sanitizeInput } from "../../utils/utils";

const { currentUser } = useUserStore();

const route = useRoute();

const userpid = computed(() => route.params.updateuser as string);

const user = {
  pid: currentUser.value.pid,
  age: currentUser.value.age,
  user: "",
  name: "",
  username: "",
  password: "",
  email: "",
  birthdate: "",
  birthplace: "",
};

async function updateCurrentUser() {
  const toast = useToast();
  let url = "http://localhost:3000/users/updateuser";
  console.log("Old User", currentUser.value);

  try {
  const response = await axios.post(url, user);
  currentUser.value.name = sanitizeInput(user.name);
  currentUser.value.username = sanitizeInput(user.username);
  currentUser.value.password = sanitizeInput(user.password);
  currentUser.value.email = sanitizeInput(user.email);
  currentUser.value.birthdate = sanitizeInput(user.birthdate);
  currentUser.value.birthplace = sanitizeInput(user.birthplace);
  console.log("Updated user", currentUser.value);
  console.log(response.data.success);
  toast.success("Updated profile successfully!");
  } catch (error) {
        // toast.error(`Error following @${followee_username}`);
        if (error.response) {
            console.log(error.response.data);

            if (error.response.data?.errorCode == 1761) {
                toast.error(`This username already exists!`);
            } else {
                toast.error(`Error following ${error.response.data}`);
            }
        }
    }
  
}
</script>

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
        <BFormInput
          v-model="user.birthdate"
          placeholder="New birthday"
          type="date"
        />
        <BFormInput v-model="user.birthplace" placeholder="New birthplace" />
        <BButton variant="primary" @click="updateCurrentUser()"
          >Update User</BButton
        >
      </BCol>
    </BCol>
  </BRow>
</template>
