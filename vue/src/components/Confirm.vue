<template>
  <v-dialog v-model="dialog" persistent max-width="290">
    <v-card>
      <v-card-title class="headline">{{ title }}</v-card-title>
      <v-card-text>{{ message }}</v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="green darken-1" text @click="agree">{{ agreeMessage }}</v-btn>
        <v-btn color="green darken-1" text @click="cancel">{{ cancelMessage }}</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>


<script>
export default {
  data: () => ({
    dialog: false,
    resolve: null,
    reject: null,
    title: null,
    message: null,
    agreeMessage: null,
    cancelMessage: null,
  }),
  methods: {
    open(title, message, agreeMessage, cancelMessage) {
      this.dialog = true
      this.title = title
      this.message = message
      this.agreeMessage = agreeMessage
      this.cancelMessage = cancelMessage
      return new Promise((resolve, reject) => {
        this.resolve = resolve
        this.reject = reject
      })
    },
    agree() {
      this.resolve(true)
      this.dialog = false
    },
    cancel() {
      this.resolve(false)
      this.dialog = false
    }
  }
}
</script>
