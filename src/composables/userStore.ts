import { createGlobalState, useLocalStorage } from "@vueuse/core";
import axios from "axios";
import { ref } from "vue";

export const useUserStore = createGlobalState(() => {
    
  const currentUser = useLocalStorage<any>('currentUser', null)  

  const allUsers = ref([])

  async function load() {
    const response = await axios.get('http://localhost:3000/users/getallusers')

    allUsers.value = response.data
  }

  load()

  return { currentUser, allUsers }
})