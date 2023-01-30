<template>
  <div>
    <b-alert><slot /> {{ am }}</b-alert>
  </div>
</template>

<script>
export default {
  props: {
    am: String,
  },
  methods: {
    alerteMessage: function (message, success) {
      // ---- ALERTER -------------------------------- //
      this.am = message;
      console.log("alert");
      return success;
    },
  },
};
</script>
