<template>
  <div class="draw-board">

    <div class="canvas-container">
      <canvas id="paper" :width="canvasWidth" :height="canvasHeight" style ="border: 2px black solid; background-color:#FFFFFF"
        v-on:mousedown="start" v-on:touchstart="start" v-on:mouseup="leave"
        v-on:touchend="leave" v-on:mousemove="move" v-on:touchmove="move">
      </canvas>
    </div>

    <div class="options-container"><span class="title-tab">ペイントツール</span>
      <v-color-picker
        mode="rgba"
        class="color-picker"
        v-model="pencilColor"
        canvas-height="100"
        dot-size="5"
        hide-mode-switch
        width="250"
      >
      </v-color-picker>

      <div class="right-options">

        <div class="size-text">ペン/消しゴム</div>
        <v-btn-toggle v-model="togglePencil" mandatory>
          <v-btn>
            <v-icon>mdi-lead-pencil</v-icon>
          </v-btn>
          <v-btn>
            <v-icon>mdi-eraser</v-icon>
          </v-btn>
        </v-btn-toggle>

        <div class="size-text">太さ</div>
        <v-btn-toggle v-model="toggleSize" @change="setLineWidth()" mandatory>
          <v-btn color="blue-grey lighten-5">
            <div class="small-circle"></div>
          </v-btn>
          <v-btn color="blue-grey lighten-5">
            <div class="medium-circle"></div>
          </v-btn>
          <v-btn color="blue-grey lighten-5">
            <div class="large-circle"></div>
          </v-btn>
        </v-btn-toggle>

        <br>

        <v-btn @click.stop="clearDialog = true" color="green lighten-3" dark>
          全消し
        </v-btn>

        <v-dialog v-model="clearDialog" max-width="300">
          <v-card>
            <v-card-title class="headline">キャンバスの絵を消してもよいですか？</v-card-title>
            <v-card-text>
              ※一度消すと、元には戻りません
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn
                color="green"
                text
                @click="clearDialog = false"
              >
                キャンセル
              </v-btn>
              <v-btn
                color="green"
                text
                @click="canvasClear()"
              >
                全部消す
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </div>
    </div>

  </div>
</template>

<script>
export default {
  data() {
    return {
      canvas: null,
      ctx: null,
      canvasWidth: 800,
      canvasHeight: 450,
      pencilColor: '',
      eraserColor: '#FFFFFF',
      lineWidth: 1,
      toggleSize: 0,
      togglePencil: 0,
      prev: [],
      drawing: false,
      timeSinceLastSend: null,
      messageChannel: null,
      clearDialog: false
    }
  },
  mounted() {
    this.canvas = document.getElementById("paper")
    this.ctx = this.canvas.getContext('2d')
    this.timeSinceLastSend = new Date().getTime()
  },
  created(){
    this.$axios.defaults.headers.common['Authorization'] = "Token " + this.token;
  },
  computed: {
    userid(){
      return this.$store.getters['auth/getUserId']
    },
    token(){
      return this.$store.getters['auth/getToken']
    },
    color(){
      if(this.togglePencil == 1){
        return this.eraserColor
      }else{
        return this.pencilColor
      }
    },
  },
  methods: {
    start(e) {
        e.preventDefault();
        var x = e.layerX
        var y = e.layerY
        this.drawing = true
        this.prev.x = x
        this.prev.y = y
    },
    leave(e) {
      this.drawing = false
    },
    move(e){
      if(this.drawing && new Date().getTime() - this.timeSinceLastSend > 20){
        var x = e.layerX
        var y = e.layerY

        if(x && y){
          this.sendLine(this.$route.params['id'], this.userid, this.prev.x, this.prev.y, x, y, this.color, this.lineWidth)
          this.drawLine(this.prev.x, this.prev.y, x, y, this.color, this.lineWidth)
          this.timeSinceLastSend = new Date().getTime()
          this.prev.x = x
          this.prev.y = y
        }
      }
    },
    drawLine(fromx, fromy, tox, toy, color, width){
      this.ctx.beginPath()
      this.ctx.strokeStyle = color
      this.ctx.lineWidth = width
      this.ctx.moveTo(fromx, fromy)
      this.ctx.lineTo(tox, toy)
      this.ctx.stroke()
    },
    sendLine(room_id, user_id, fromx, fromy, tox, toy, color, width){
      this.$axios.post(this.$api.getURL('updateline'), {
        room_id: room_id,
        user_id: user_id,
        data: {
          fromx: fromx,
          fromy: fromy,
          tox: tox,
          toy: toy,
          color: color,
          width: width
        }
      })
      .then(response => {
      })
      .catch(error => {
      });
    },
    setLineWidth(){
      if(this.toggleSize == 0){
        this.lineWidth = 1
      }else if(this.toggleSize == 1){
        this.lineWidth = 3
      }else if(this.toggleSize == 2){
        this.lineWidth = 5
      }
    },
    canvasClear(){
      this.clearDialog = false
      this.drawLine(0, this.ctx.canvas.clientHeight / 2, this.ctx.canvas.clientWidth, this.ctx.canvas.clientHeight / 2, "#FFFFFF", this.ctx.canvas.clientHeight)
      this.sendLine(this.$route.params['id'], this.userid,
        0, this.ctx.canvas.clientHeight / 2, this.ctx.canvas.clientWidth, this.ctx.canvas.clientHeight / 2,
        "#FFFFFF", this.ctx.canvas.clientHeight)
    }
  }
}
</script>

<style>
.draw-board{
  overflow-y: auto;
},
#paper {
  background-color: yellow;
  margin-bottom: 1em;
}
.options-container{
  display: flex;
  position: relative;
  margin: 2em;
  padding: 1.2em 1em 1em;
  width: 600px;
  background-color: #fff; /*BOX背景色 */
  border: 2px solid #8d93c8; /* 枠線の太さ・色 */
  box-shadow: 2px 2px 2px #ccc; /* 影の色 */
}
.title-tab{
  position: absolute;
  display: inline-block;
  top: -28px; /*タブ調整 */
  left: -2px; /*タブ調整 */
  padding: 1px 10px;
  height: 26px;
  font-weight: bold;
  color: #fff; /* タイトル色 */
  background-color: #8d93c8; /* タイトル背景色 */
  border-radius: 8px 8px 0 0;
}
.color-picker{
  margin: 0em 2.5em;
}
.right-options{
  display: flex;
  flex-direction: column;
  align-items: center;
}
.size-text{
  display: inline-block;
  font-weight: bold;
  color: #000; /* タイトル色 */
}
.small-circle{
  width: 3px;
  height: 3px;
  border-radius: 50%;
  background: black;
}
.medium-circle{
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: black;
}
.large-circle{
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: black;
}
</style>
