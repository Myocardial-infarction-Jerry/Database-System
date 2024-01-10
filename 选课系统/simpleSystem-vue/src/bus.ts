import { reactive } from "vue";

const bus = reactive({
  isLogin: false,
  username: ''
})

export default bus