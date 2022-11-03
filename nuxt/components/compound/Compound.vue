<template>
    <div v-if="compound" class="compound">
        <div>
            <CompoundImage></CompoundImage>
            <div class="compound-description">
              <h2>ChemSpiderId: {{ compound.ChemSpiderId }}</h2>
              <h2>Title: {{ compound.Name }}</h2>
              <div class="categories">
                <div class="category" v-for="category in compound?.Categories" :key="category.Id">
                    <h3>{{ category?.Name }}</h3>
                </div>
              </div>
              <ul class="synonyms">
                <li class="synonym" v-for="synonym in compound.Synonyms" :key="synonym.Id">
                    {{ synonym?.Name }}
                </li>
            </ul>
            </div>
        </div>
    </div>
  </template>
  
  <script>
  import awsApi from "@/api/aws";
  import CompoundImage from "@/components/compound/CompoundImage.vue";
  
  export default {
    data() {
      return {
        id: null,
        compound: {
    ChemSpiderId: 1,
    Categories: [
        {
            "Id": 100,
            "Name": "Medicine"
        }
    ],
    Name: "Oxobutyric Acid",
    Synonyms: [
        {
            Id: 1,
            Name: "Oxobutyric A"
        },
        {
            Id: 2,
            Name: "O Acid"
        }
    ]
},
      };
    },
    props: {
      msg: String,
    },
    methods: {
      async getCompound() {
        const res = await awsApi.put("", { key: Number(this.id) });
        this.compound = JSON.stringify(res.data);
        console.log(res);
      },
    },
    components: {CompoundImage}
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
  </style>
  