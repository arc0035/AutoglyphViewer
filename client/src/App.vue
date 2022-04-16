<template>
 <div>
    <div class="input">
      <h2>请输入draw代码(见etherscan地址0xd4e4078ca3495de5b1d4db434bebc5a986197782的draw函数)：</h2>
      <textarea  v-model="code" /> 
      <button @click="generateByCode">通过代码生成图形</button>
    </div>

    <div class="input">
      <h2>或者输入draw种子：</h2>
      <textarea  v-model="seed" /> 
      <button @click="generateBySeed">通过种子生成图形</button>
    </div>

    <div class="result" v-if="computed">
        <div v-for="item in this.charArray" class="small" :key="item">
          {{item}}
        </div>
    </div>

  </div>
</template>

<script>

import {drawCode} from '@/draw'

export default {
  data() {
    return {
      computed: false,
      USIZE: 64,
      code: '',
      seed: '167726281823327713905875984158077896770509714748',
      charArray:[],
      badCharSet: {
        '%': true,
        '0': true,
        'A': true
      }
    }
  },
  methods: {
    generateByCode() {
      this.computed = false
      //code格式清洗和校验
      var expectedLength = (this.USIZE * (this.USIZE+3)) 
      if (this.code.length > expectedLength) {
        this.code = this.code.trim().substring(30)
      }
      if (this.code.length != expectedLength && this.code.length != expectedLength){
        alert('Invalid code!')
        return
      }

      //生成charater Array
      var i=0;
      var j=0;
      for (;i<expectedLength;i++){
          var ch = this.code.charAt(i)
          if(this.badCharSet[ch]){
            continue
          }
          if(ch == '.'){
            ch = ' '
          }
          this.charArray[j++] = ch
      }
        this.$nextTick(() => {
          // 刷新vue(避免v-for的污染)
          this.computed = true
        });
    },
    generateBySeed() {
      drawCode(this.seed).then(code=>{
        this.code = code
        this.generateByCode()
      })
    },
  }
}
</script>

<style>
.input {
  border: 1px solid green;
  width: 70%;
  margin: auto;
  padding: 50px;
}

h2 {
  font-size: 30px;
  width: 80%;
  margin: auto;
  margin-bottom: 50px;
}

textarea {
  display: block;
  height: 100px;
  width: 80%;
  margin:auto;
  font-size: 30px;
}

button {
  display: block;
  width: 40%;
  font-size: 30px;
  margin: auto;
  margin-top: 50px;
}

.result {
  width: 800px;
  height: 800px;
  margin: auto;
  margin-top: 50px;
  display: grid;
  grid-template-columns: repeat(64, 1.5625%);
  grid-template-rows: repeat(64, 1.5625%);
  border: 1px solid green;
}

.small{
  text-align: center;
  //line-height:1.5625%;
  font-weight: bold;
}

</style>
