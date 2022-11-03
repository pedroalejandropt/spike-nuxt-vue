<template>
    <div v-if="compound" class="compound">
        <div>
            <CompoundImage></CompoundImage>
            <div class="compound-description">
              <h2>ChemSpiderId: {{ compound.ChemSpiderId }}</h2>
              <h2>Title: {{ compound.Name }}</h2>
              <div class="categories">
                <div class="category" v-for="category in compound?.Categories" :key="category.Id">
                    <cite>{{ category?.Name }}</cite>
                </div>
              </div>
              <ul class="synonyms">
                <li class="synonym" v-for="synonym in compound.Synonyms" :key="synonym.Id">
                    {{ synonym?.Name }}
                </li>
            </ul>
            
            <NuxtLink to="/compound">
              <button class="back-button"> 
                BACK 
              </button>
            </NuxtLink>
            
            </div>
        </div>
    </div>
  </template>
  
  <script>
  import awsApi from "@/api/aws";
  import CompoundImage from "@/components/compound/CompoundImage.vue";
  
  export default {
    layout: 'empty',
    data() {
      return {
        id: null,
        compound: null
      };
    },
    props: {
      msg: String,
    },
    methods: {
      async getCompound() {
        const res = await awsApi.post("", { key: Number(this.id) });
        this.compound = res.data;
        console.log(this.compound);
      },
    },
    components: {CompoundImage},
    mounted() {
      console.log(this.$route.query.id);
      this.id = this.$route.query?.id;
      if (!this.id)
        this.$router.push({name: 'compound'})
      this.getCompound();
    }
  };
  </script>
  
  <style scoped>
  .compound {
    width: 100%;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  .compound-description {
    margin-top: 15px;
  }
  .synonyms {
    padding: 25px;
  }
  .back-button {
    width: 100%;
    height: 30px;
    border: 0;
    border-radius: 5px;
    color: green;
    background-color: lightgreen;
    margin: 5px 5px 5px 5px !important;
}
  </style>
  