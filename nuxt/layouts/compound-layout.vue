<template>
    <div class="container">
      <Header title="ChemSpider Compounds"></Header>
      <Nuxt />
    </div>
  </template>
  
  <script>
  import Header from '@/components/shared/Header.vue'
  export default {
    components: { Header },
    head () {
      return {
        bodyAttrs: {
          class: 'reset-body'
        }
      }
    }
  }
  </script>
  
  <style>
  .reset-body { 
    margin: 0;
    padding: 0;
  }
  * {
    margin: 0;
    padding: 0;
  }
  </style>