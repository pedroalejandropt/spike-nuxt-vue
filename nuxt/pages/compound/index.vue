<template>
    <div>
        <div class="search-container">
            <h1>{{ msg }}</h1>
            <input class="search-input" type="number" placeholder="Write a id: (ex: 1)" v-model="id" />
            <button class="search-button" @click="getCompound">Search</button>
        </div>
        <div v-if="compound">
            <compound-list :compound="compound"></compound-list>
        </div>
        <div v-if="error" class="error-container">
            <p class="error-msg">{{ error }}</p>
        </div>
    </div>
</template>

<script>
import awsApi from "@/api/aws";
import CompoundList from '@/components/compound/CompoundList.vue'

export default {
    layout: 'compound-layout',
    name: 'compound',
    data() {
      return {
        id: null,
        error: null,
        compound: null,
      };
    },
    props: {
        msg: String,
    },
    components: { CompoundList },
    methods: {
        async getCompound() {
            const res = await awsApi.post("", { key: Number(this.id) });
            this.error = (res.data.errorMessage) ?? null
            this.compound = (res.data.ChemSpiderId) ? res.data : null;
            
            console.log(res.data);
        },
    },
    mounted() {
      console.log(this.$route.query);
    }
}
</script>

<style scoped>
.search-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 40vh;
}
.search-input {
    width: 200px;
    height: 30px;
    font-size: 15px;
    border: 1px solid lightgray;
    border-radius: 5px;
    text-indent: 10px;
}
.search-button {
    width: 60px;
    height: 30px;
    border: 0;
    border-radius: 5px;
    color: green;
    background-color: lightgreen;
    margin: 5px 5px 5px 5px !important;
}
.error-container {
    text-align: center;
}
.error-msg {
    color: red;
    font-size: 20px;
}
</style>