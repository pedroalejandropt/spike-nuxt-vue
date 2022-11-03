<template>
  <div class="compound">
    <h1>{{ msg }}</h1>
    <input type="number" placeholder="Write a id: (ex: 1)" v-model="id" />
    <button @click="getCompound">Search</button>
    <div v-if="compound" class="json">
      <pre>{{ compound }}</pre>
    </div>
  </div>
</template>

<script>
import awsApi from "@/api/aws";

export default {
  name: "Compound-View",
  data() {
    return {
      id: null,
      compound: null,
    };
  },
  props: {
    msg: String,
  },
  methods: {
    async getCompound() {
      const res = await awsApi.post("", { key: Number(this.id) });
      this.compound = JSON.stringify(res.data);
      console.log(res);
    },
  },
};
</script>

<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
