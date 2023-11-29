<script setup lang="ts">
import { useRoute } from "vue-router";
import axios from "axios";
import { useToast } from "vue-toastification";
import { useUserStore } from "../../../../composables/userStore";
const { currentUser } = useUserStore();

const route = useRoute();

const userpid = computed(() => route.params.pid as string);
const rid = computed(() => route.params.rid as string);
const type = computed(() => route.params.type as string);
const commentText = ref("");

const reviewUser = reactive({
    pid: "",
    name: "",
    username: "",
    email: "",
    birthdate: "",
    birthplace: "",
    age: "",
    profile_pic: "",
});

const commentSubmitted = ref(false);

onMounted(() => {
    getReviewUser();
});

onMounted(async () => {
    review.value = await getUserReview();
});

// const getReleaseYear = (dateString: string) => {
//     const date = new Date(dateString);
//     return date.getFullYear();
// };

async function getReviewUser() {
    let url = "http://localhost:3000/users/getuserbyid";

    if (userpid.value) {
        url += `?q=${encodeURIComponent(userpid.value)}`;
    }

    const response = await fetch(url);
    const data = await response.json();
    reviewUser.pid = data[0].pid;
    reviewUser.name = data[0].name;
    reviewUser.username = data[0].username;
    reviewUser.email = data[0].email;
    reviewUser.birthdate = data[0].birthdate;
    reviewUser.birthplace = data[0].birthplace;
    reviewUser.age = data[0].age;
    reviewUser.profile_pic = data[0].profile_pic;

    console.log(reviewUser.pid);
}

async function getUserReview() {
    let url = "http://localhost:3000/users/getuserreviews";
    console.log(userpid.value);
    console.log(rid.value);

    const response = await axios.post(url, {
        pid: userpid.value,
        rid: rid.value,
        type: type.value,
    });
    const data = await response.data;
    console.log(data);
    return data[0];
}

async function getReviewComments() {
    let url = "http://localhost:3000/users/getreviewcomments";

    const response = await axios.post(url, {
        pid: userpid.value,
        rid: rid.value,
    });
    const data = await response.data;
    return data;
}

async function insertReviewComment() {
    const toast = useToast();
    let url = "http://localhost:3000/users/insertreviewcomment";

    try {
        const response = await axios.post(url, {
            reviewer_pid: currentUser.value.pid,
            comment_pid: currentUser.value.pid,
            rid: rid.value,
            comment_text: commentText.value,
        });

        if (response.status === 201) {
            console.log("Comment submitted successfully!");
            toast.success("Comment submitted successfully!");
        } else {
            console.error(
                "Failed to submit comment. Unexpected status:",
                response.status
            );
            toast.error("Error submitting comment");
        }
    } catch (error) {
        console.error("Error submitting comment:", error.message);
        toast.error("Error submitting comment");
    }
}

const isLoading = ref(false);

watch(
    commentSubmitted,
    async () => {
        comments.value = await getReviewComments();
    },
    { immediate: false }
);

const review = computedAsync(getUserReview, isLoading);
const comments = computedAsync(getReviewComments, [], isLoading);
// const comments = ref(await getReviewComments());
</script>

<script lang="ts">
export default {
    methods: {
        arrayBufferToBase64(buffer: number[]) {
            var binary = "";
            var bytes = new Uint8Array(buffer);
            var len = bytes.byteLength;
            for (var i = 0; i < len; i++) {
                binary += String.fromCharCode(bytes[i]);
            }
            return "data:image/jpeg;base64," + window.btoa(binary);
        },
    },
};
</script>

<template>
    <BCol>
        <BCard class="mb-3">
            <BCardText>
                {{ console.log(review) }}
                <p>{{ type }} {{ "Review for:" }}</p>
                <p>{{ review.album_name }}</p>
                <p>Rating: {{ review.rating }}</p>
                <p>Review: {{ review.review_text }}</p>
            </BCardText>
        </BCard>

        <!-- <BCol v-if="type == 'Song'" lg="6" class="mb-3 column">
            <BContainer fluid>
                <BCol class="mb-3">
                    {{ console.log(review) }}

                    <BCard style="width: 200%">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h2>{{ review.song_name }}</h2>
                            <span>@{{ currentUser.username }}</span>
                        </div>

                        <b-card-img style="width: 40vw;" :src="arrayBufferToBase64(review.cover.data)"
                            alt="Album Cover"></b-card-img>

                        <div class="p-3">
                            <BCardText class="d-flex justify-content-between align-items-center mb-3">{{
                                review.review_text }}</BCardText>
                            <BCardFooter>Rating: {{ review.rating }}</BCardFooter>
                        </div>
                    </BCard>
                </BCol>
            </BContainer>
        </BCol> -->

        <BCard title="Comments">
            <BListGroup flush>
                {{ console.log(comments) }}
                <BListGroupItem v-for="(result, index) in comments" :key="index">
                    <h6>@{{ result.username }}</h6>
                    <p>{{ result.comment_text }}</p>
                </BListGroupItem>
            </BListGroup>
        </BCard>

        <h4 style="padding-top: 2.5rem" class="my-4">Leave a new comment</h4>
        <BFormInput v-model="commentText"></BFormInput>
        <BButton @click="insertReviewComment()" class="my-4" size="lg" variant="primary">Submit</BButton>
    </BCol>
</template>
