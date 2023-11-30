<script setup lang="ts">
import { useRoute } from "vue-router";
import axios from "axios";
import { useToast } from "vue-toastification";
import { useUserStore } from "../../../../composables/userStore";
import { sanitizeInput, arrayBufferToBase64 } from "../../../../utils/utils";
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
    await getUserReview();
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
}

async function getUserReview() {
    let url = "http://localhost:3000/users/getuserreviews";

    const response = await axios.post(url, {
        pid: userpid.value,
        rid: rid.value,
        type: type.value,
    });
    const data = await response.data;
    return data[0];
}

async function getReviewComments() {
    let url = "http://localhost:3000/users/getreviewcomments";

    const response = await axios.post(url, {
        pid: userpid.value,
        rid: rid.value,
    });
    refreshKey.value++;
    const data = await response.data;
    return data;
}

const refreshKey = ref(0);
function getCardKey(user) {
    return `${user.pid}-${refreshKey.value}`;
}


async function fetchAndUpdateComments() {
    const newComments = await getReviewComments();
    comments.value = newComments; // Assuming comments is a reactive ref
}

async function insertReviewComment() {
    const toast = useToast();
    let url = "http://localhost:3000/users/insertreviewcomment";

    if (commentText.value === "") {
        toast.error("Comment cannot be empty");
        return;
    }

    try {
        const response = await axios.post(url, {
            review_pid: userpid.value,
            comment_pid: currentUser.value.pid,
            rid: rid.value,
            comment_text: sanitizeInput(commentText.value),
        });

        if (response.status === 201) {
            toast.success("Commented successfully!");
            refreshKey.value++;
            await fetchAndUpdateComments();

        } else {
            toast.error("Error commenting");
        }
    } catch (error) {
        toast.error("Error commenting");
    }
}

function renderStars(rating: number) {
    const stars: string[] = [];
    for (let i = 0; i < 5; i++) {
        if (i < rating) {
            stars.push('★');
        } else {
            stars.push('☆');
        }
    }
    return stars.join(' ');
}

const isLoading = ref(false);

const review = computedAsync(getUserReview, [], isLoading);

const comments = computedAsync(getReviewComments, [], isLoading);

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
    }
};
</script>

<template>
    <BCol style="margin-top: 20%;">

        {{ console.log(type) }}

        <BCard v-if="review && review.rid" style="max-width: 50rem; min-height: 20rem;">
            <small v-if="type == 'Userchart'" class="text-muted" style="position: absolute; top: 5%; left: 5%;">Userchart</small>
            <small v-if="type == 'Song'" class="text-muted" style="position: absolute; top: 5%; left: 5%;">Song</small>
            <small v-if="type == 'Album'" class="text-muted" style="position: absolute; top: 5%; left: 5%;">Album</small>
            <small class="text-muted" style="position: absolute; top: 5%; right: 5%;">
                {{ new Date(review.review_date).toLocaleString([], {
                    year: 'numeric', month: 'numeric',
                    day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: false
                })
                }}
            </small>
            <div style="margin-top: 5%;" class="d-flex justify-content-between align-items-center mb-3">
                <h2>{{ review.album_name }}</h2>
                <RouterLink style="text-decoration: none;" :to="{ name: '/users/[user]', params: { user: review.pid } }">
                    <span>@{{ review.username }}</span>
                </RouterLink>
            </div>

            <b-card-img v-if="review.cover" style="width: 30rem" :src="arrayBufferToBase64(review.cover.data)"
                alt="Album Cover"></b-card-img>

            <div class="p-3">
                <BCardText class="d-flex justify-content-between align-items-center mb-3">{{
                    review.review_text }}</BCardText>

                <BCardFooter style="margin-bottom: -5%;"> {{ renderStars(review.rating) }}</BCardFooter>
            </div>
        </BCard>


        <BCard title="Comments">
            <BListGroup flush>
                <BListGroupItem v-for="(result, index) in comments" :key="getCardKey(result)" style="max-width: 35vw;">
                    <div class="mb-2">
                        <h6>@{{ result.username }}</h6>
                        <small class="text-muted">{{ result.comment_date.substring(0, 10) + ' ' +
                            result.comment_date.substring(11, 19) }}</small>
                    </div>
                    <p>{{ result.comment_text }}</p>
                </BListGroupItem>
            </BListGroup>
        </BCard>

        <div v-if="currentUser.pid">
            <h4 style="padding-top: 2.5rem" class="my-4">Leave a new comment</h4>
            <BFormInput v-model="commentText"></BFormInput>
            <BButton @click="insertReviewComment()" class="my-4" size="lg" variant="primary">Submit</BButton>
        </div>
    </BCol>
</template>
