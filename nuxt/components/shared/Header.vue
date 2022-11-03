<template>
    <div class="header">
        <h3>{{ title }}</h3>
    </div>
</template>

<script>
export default {
    props: {
        title: {
            type: String,
            required: true
        }
    }
}
</script>

<style scoped>
.header {
    width: 100%;
    height: 80px;
    background-color: lightgreen;
    display: flex;
    align-items: center;
    text-indent: 20px;
}

h3 {
    font-family: 'Andale Mono';
}
</style>