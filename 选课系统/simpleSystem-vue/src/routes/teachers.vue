<template>
    <n-space style="margin-bottom: 20px;">
        <n-button @click="showAddModal" type="primary">更新信息</n-button>
    </n-space>
    <n-data-table :columns="columns" :data="data" striped></n-data-table>
    <n-modal preset="dialog" title="添加教师" v-model:show="showAddModalStatus">
        <n-space vertical>
            <n-input-number placeholder="教职工编号" v-model:value="addForm.tid" clearable />
            <n-input placeholder="姓名" v-model:value="addForm.tname" />
            <n-select v-model:value="addForm.gender" placeholder="性别"
                :options="[{ label: '男', value: '男' }, { label: '女', value: '女' }]" />
            <!-- <n-select placeholder="班级" v-model:value="addForm.clid"
          :options="classList.map(e => ({ label: e.cltname, value: e.clid }))" /> -->
            <n-input-number placeholder="薪资" v-model:value="addForm.salary" clearable />
            <n-input placeholder="年龄" v-model:value="addForm.age" />
            <n-input placeholder="电话" v-model:value="addForm.telephone" />
        </n-space>
        <template #action>
            <n-button @click="addInfo">添加教师</n-button>
            <n-button @click="updateInfo">修改教师</n-button>
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
    tid: number
    tname: string
    gender: string
    age: number
    salary: number
    telephone: string
}
function getDataIndex(tid: number) {
    return data.findIndex((item) => item.tid === tid)
}

function bindFunc(rowData: Info, key: keyof Info) {
    const index = getDataIndex(rowData.tid)
    return h(ShowOrEdit, {
        value: rowData[key],
        'onUpdate:value': function (v: any) {
            (data[index][key] as string | number) = v
        }
    })
}

const message = useMessage()
const columns: DataTableColumns<Info> = [{
    title: '编号',
    key: 'tid',
    render: (rowData) => bindFunc(rowData, 'tid'),
}, {
    title: '姓名',
    key: 'tname',
    render: (rowData) => bindFunc(rowData, 'tname'),

}, {
    title: '性别',
    key: 'gender',
    render: (rowData) => bindFunc(rowData, 'gender'),

}, {
    title: '年龄',
    key: 'age',
    render: (rowData) => bindFunc(rowData, 'age'),

}, {
    title: '薪资',
    key: 'salary',
    render: (rowData) => bindFunc(rowData, 'salary'),

}, {
    title: '手机',
    key: 'telephone',
    render: (rowData) => bindFunc(rowData, 'telephone'),

}, {
    title: '操作',
    key: 'actions',
    render(rowData) {
        return [h(NButton, {
            type: 'error',
            onClick() {
                delInfo({ tid: rowData.tid })
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
    tid: undefined,
    tname: undefined,
    gender: undefined,
    salary: undefined,
    age: undefined,
    telephone: undefined
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
    if (bus.username != 'teacher_admin' && bus.username != 'admin') {
        message.error('权限不足');
        return;
    }
    superagent.get('/teachers')
        .then(e => {
            if (e.body.code == 200) {
                data.length = 0
                data.push(...e.body.data)
            } else {
                message.error('获取教师信息失败')
            }
        }).catch(e => {
            console.error(e);
            message.error('获取教师信息失败')
        })
}

function showAddModal() {
    if (bus.username != 'teacher_admin' && bus.username != 'admin') {
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
    if (bus.username != 'teacher_admin' && bus.username != 'admin') {
        message.error('权限不足');
        return;
    }
    const msg = message.loading('添加中')
    const record = { ...addForm }
    superagent.post('/teachers')
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
    if (bus.username != 'teacher_admin' && bus.username != 'admin') {
        message.error('权限不足');
        return;
    }
    const msg = message.loading('修改中')
    const record = { ...addForm }
    superagent.put('/teachers')
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

function delInfo({ tid }: { tid: number }) {
    if (bus.username != 'teacher_admin' && bus.username != 'admin') {
        message.error('权限不足');
        return;
    }
    const loading = message.loading('加载中')
    let tmp = String(tid)
    superagent.del('/teachers/' + tmp).then(e => {
        if (e.body.code == 200) {
            message.success('删除成功')
            showAddModalStatus.value = false
            getInfoList()
        } else {
            message.error('删除失败')
        }
    }).catch(() => {
        message.error('删除失败，存在外键参照')
    }).finally(() => {
        loading.destroy()
    })
}

</script>
<style lang="less"></style>