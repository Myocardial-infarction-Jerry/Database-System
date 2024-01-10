<template>
  <n-space style="margin-bottom: 20px;">
    <n-button @click="showAddModal" type="primary">更新信息</n-button>
  </n-space>
  <n-data-table :columns="columns" :data="data" striped></n-data-table>
  <n-modal preset="dialog" title="添加学生" v-model:show="showAddModalStatus">
    <n-space vertical>
      <n-input-number placeholder="学号" v-model:value="addForm.sid" clearable />
      <n-input placeholder="姓名" v-model:value="addForm.name" />
      <n-select v-model:value="addForm.gender" placeholder="性别"
        :options="[{ label: '男', value: '男' }, { label: '女', value: '女' }]" />
      <!-- <n-select placeholder="班级" v-model:value="addForm.clid"
        :options="classList.map(e => ({ label: e.clname, value: e.clid }))" /> -->
      <n-input placeholder="年级" v-model:value="addForm.grade" />
      <n-input placeholder="电话" v-model:value="addForm.telephone" />
    </n-space>
    <template #action>
      <n-button @click="addInfo">添加学生</n-button>
      <n-button @click="updateInfo">修改学生</n-button>
    </template>
  </n-modal>
</template>

<script setup lang="ts">
import { watch, reactive, h, ref } from "vue";
import { NDataTable, DataTableColumns, NSpace, NButton, NModal, NInput, NInputNumber, NSelect, useMessage } from 'naive-ui'
import ShowOrEdit from "../components/showOrEdit.vue";
import superagent from 'superagent'
import bus from '../bus';

interface Info {
  sid: number
  name: string
  gender: string
  grade: string
  telephone: string
}
function getDataIndex(sid: number) {
  return data.findIndex((item) => item.sid === sid)
}

function bindFunc(rowData: Info, key: keyof Info) {
  const index = getDataIndex(rowData.sid)
  return h(ShowOrEdit, {
    value: rowData[key],
    'onUpdate:value': function (v: any) {
      (data[index][key] as string | number) = v
    }
  })
}

const message = useMessage()
const columns: DataTableColumns<Info> = [{
  title: '学号',
  key: 'sid',
  render: (rowData) => bindFunc(rowData, 'sid'),
}, {
  title: '姓名',
  key: 'name',
  render: (rowData) => bindFunc(rowData, 'name'),

}, {
  title: '性别',
  key: 'gender',
  render: (rowData) => bindFunc(rowData, 'gender'),

}, {
  title: '手机',
  key: 'telephone',
  render: (rowData) => bindFunc(rowData, 'telephone'),

}, {
  title: '年级',
  key: 'grade',
  render: (rowData) => bindFunc(rowData, 'grade'),

}, {
  title: '操作',
  key: 'actions',
  render(rowData) {
    return [h(NButton, {
      type: 'error',
      onClick() {
        delInfo({ sid: rowData.sid })
      },
      style: {
        marginRight: '10px'
      }
    }, () => '删除'),
    ]
  },
}]
const data = reactive<Info[]>([])
const addForm = reactive({
  sid: undefined,
  name: undefined,
  gender: undefined,
  clid: undefined,
  telephone: undefined,
  grade: undefined
})

const showAddModalStatus = ref(false)

watch(() => bus.isLogin, v => {
  console.log('登录状态', v);

  if (v && !data.length) {
    getInfoList()
  }
}, {
  immediate: true
})

function getInfoList() {
  if (bus.username != 'student_admin' && bus.username != 'admin') {
    message.error('权限不足');
    return;
  }
  superagent.get('/student')
    .then(e => {
      if (e.body.code == 200) {
        data.length = 0
        data.push(...e.body.data)
      } else {
        message.error('获取学生信息失败')
      }
    }).catch(e => {
      console.error(e);
      message.error('获取学生信息失败')
    })
}

function showAddModal() {
  if (bus.username != 'student_admin' && bus.username != 'admin') {
    message.error('权限不足');
    return;
  }
  for (const key in addForm) {
    if (Object.hasOwn(addForm, key)) {
      addForm[key as keyof typeof addForm] = undefined
    }
  }
  showAddModalStatus.value = true
}

function addInfo() {
  if (bus.username != 'student_admin' && bus.username != 'admin') {
    message.error('权限不足');
    return;
  }
  const msg = message.loading('添加中')
  const record = { ...addForm }
  superagent.post('/student')
    .send(record).then(e => {
      if (e.body.code == 200) {
        message.success('添加成功')
        showAddModalStatus.value = false
        getInfoList()
      } else {
        message.error('添加失败')
      }
    }).catch(() => {
      message.error('添加失败')
    }).finally(() => {
      msg.destroy()
    })
}

function updateInfo() {
  if (bus.username != 'student_admin' && bus.username != 'admin') {
    message.error('权限不足');
    return;
  }
  const msg = message.loading('修改中')
  const record = { ...addForm }
  superagent.put('/student')
    .send(record).then(e => {
      if (e.body.code == 200) {
        message.success('添加成功')
        showAddModalStatus.value = false
        getInfoList()
      } else {
        message.error('修改失败')
      }
    }).catch(() => {
      message.error('修改失败')
    }).finally(() => {
      msg.destroy()
    })
}

function delInfo({ sid }: { sid: number }) {
  if (bus.username != 'student_admin' && bus.username != 'admin') {
    message.error('权限不足');
    return;
  }
  const loading = message.loading('加载中')
  let tmp = String(sid)
  superagent.del('/student/' + tmp).then(e => {
    if (e.body.code == 200) {
      message.success('删除成功')
      showAddModalStatus.value = false
      getInfoList()
    } else {
      message.error('删除失败')
    }
  }).catch(() => {
    message.error('删除失败，存在外键参照关系')
  }).finally(() => {
    loading.destroy()
  })
}

</script>
<style lang="less"></style>