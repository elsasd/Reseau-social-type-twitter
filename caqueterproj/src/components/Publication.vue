<template>
  <div class="bodypubli" style="width: 60%">

    <br />
    <div id="caqueauthor+date">
      <span id="author"> <slot name="pp" /> <slot name="username" /></span>
      <span id="date"> le {{ date_pub }} à {{ heure_pub }} </span>
      <slot name="follow" />
    </div>
    <br />
    <p id="caquemsg" v-html="hashtext"></p>
    <div id="intercaque" style="position: relative">
      <div style="position: absolute; left: 0">
        <slot class="rep" name="repondre" />
      </div>
      <slot style="float: right" name="ronron" />
    </div>
    <br />
  </div>
</template>

<script>
export default {
  props: {
    message: String,
    user: String,
    date_pub: String,
    heure_pub: String,
    id_caque: Number,
    ronrons: Number,
    caque: String,
    hashtags: Array,
    liked: Boolean,
    mentions: Array,
    visible: Boolean,
    following: Boolean,
    photo: String,
  },
  computed: {
    hashtext() {
      return this.message
        .replace(/(#[a-zA-Z]+)/g, '<b-link class="hash">$&</b-link>')
        .replace(/(@[^@#\s]+)/g, '<b-link class="mention">$&</b-link>');
    },
  },
};
</script>


<style scoped>
#intercaque {
  text-align: center;
}

.bodypubli {
  border-top: 1px solid lightgray;
}
</style>
