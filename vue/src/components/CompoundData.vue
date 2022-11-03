<template>
  <div class="compound">
    <h1>{{ msg }}</h1>
    <div v-if="compound" class="json">
      <pre>{{ compound }}</pre>
    </div>
  </div>
</template>

<script>
import awsApi from "@/api/aws";

export default {
  name: "Compound-Data",
  data() {
    return {
      compound: null,
    };
  },
  props: {
    id: String,
    msg: String,
  },
  mounted() {
    this.getCompound();
  },
  watch: {
    id() {
      this.getCompound();
    },
  },
  methods: {
    async getCompound() {
      if (isNaN(this.id)) {
        this.$router.push({ name: "error" });
      }
      const res = await awsApi.post("", { key: Number(this.id) });
      this.compound = JSON.stringify(res.data);
      if (!res.data.ChemSpiderId) {
        this.$router.push({ name: "error" });
      }
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
