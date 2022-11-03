<template>
  <div class="error">
    <h1>{{ msg }}</h1>
  </div>
</template>

<script>
export default {
  name: "Error-View",
  props: {
    msg: String,
  },
};
</script>
