<template>
  <div class="url-preview">
    <div v-if="loading">Fetching preview...</div>
    <div v-else>
      <div class="urlp-image cropped-image cropped-image-3by1" v-if="info.images.length"><div><img :src="info.images[0].src" alt=""></div></div>
      <div class="urlp-title">{{ info.title }}</div>
      <div class="urlp-descr">{{ info.description }}</div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['info', 'loading'],
}
</script>
