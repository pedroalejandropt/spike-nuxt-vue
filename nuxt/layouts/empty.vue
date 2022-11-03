<template>
  <div class="empty">
    <Nuxt />
  </div>
</template>

<script>
export default {
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