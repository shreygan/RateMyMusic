<script setup lang="ts"></script>

<template>
  <Bcontainer class="my-4">
    <!-- <BCol>
                <h3>Hello please log in :3</h3>
                <BFormInput placeholder="Username" type="text" />
                <BFormInput placeholder="Password" type="password" />
                <BButton variant="primary">LOG IN!!!</BButton>
            </BCol> -->
    <BRow class="my-1">
        <h2>Hello log in</h2>
        <BCol>
            <BFormInput :state="null" placeholder="Username" />
        </BCol>
    </BRow>

    <BRow class="my-1">
        <BCol>
            <BFormInput :state="null" placeholder="Password" type="password" />
        </BCol>
    </BRow>

    <Brow class="my-1">
        <BCol>
            <BButton variant="primary">LOG IN!!!</BButton>
        </BCol>
    </Brow>
  </Bcontainer>
</template>
