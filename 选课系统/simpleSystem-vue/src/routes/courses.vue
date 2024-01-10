<template>
    <n-space style="margin-bottom: 20px;">
        <n-button @click="showAddModal" type="primary">更新信息</n-button>
    </n-space>
    <n-data-table :columns="columns" :data="data" striped></n-data-table>
    <n-modal preset="dialog" title="更新课程信息" v-model:show="showAddModalStatus">
        <n-space vertical>
            <n-input-number placeholder="课程编号" v-model:value="addForm.cid" clearable />
            <n-input placeholder="课程名" v-model:value="addForm.cname" />
        </n-space>
        <template #action>
            <n-button @click="addInfo">添加课程</n-button>
        </template>
    </n-modal>
</template>
  
<script setup lang="ts">
import { watch, reactive, h, ref } from "vue";
import { NDataTable, DataTableColumns, NSpace, NButton, NModal, NInput, NInputNumber, useMessage } from 'naive-ui'
import ShowOrEdit from "../components/showOrEdit.vue";
import superagent from 'superagent'
import bus from '../bus';

interface Info {
    cid: number
    cname: string
}
function getDataIndex(cid: number) {
    return data.findIndex((item) => item.cid === cid)
}

function bindFunc(rowData: Info, key: keyof Info) {
    const index = getDataIndex(rowData.cid)
    return h(ShowOrEdit, {
        value: rowData[key],
        'onUpdate:value': function (v: any) {
            (data[index][key] as string | number) = v
        }
    })
}

const message = useMessage()
const columns: DataTableColumns<Info> = [{
    title: '课程编号',
    key: 'cid',
    render: (rowData) => bindFunc(rowData, 'cid'),
}, {
    title: '课程名',
    key: 'cname',
    render: (rowData) => bindFunc(rowData, 'cname'),

}, {
    title: '操作',
    key: 'actions',
    render(rowData) {
        return [h(NButton, {
            type: 'error',
            onClick() {
                delInfo({ cid: rowData.cid })
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
    cid: undefined,
    cname: undefined,
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

    if (bus.username != 'courses_admin' && bus.username != 'admin') {
        message.error('权限不足')
        return;
    }
    superagent.get('/courses')
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
    if (bus.username != 'courses_admin' && bus.username != 'admin') {
        message.error('权限不足')
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
    if (bus.username != 'courses_admin' && bus.username != 'admin') {
        message.error('权限不足')
        return;
    }
    const msg = message.loading('添加中')
    const record = { ...addForm }
    superagent.post('/courses')
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

function delInfo({ cid }: { cid: number }) {
    if (bus.username != 'courses_admin' && bus.username != 'admin') {
        message.error('权限不足')
        return;
    }
    const loading = message.loading('加载中')
    let tmp = String(cid)
    superagent.del('/courses/' + tmp).then(e => {
        if (e.body.code == 200) {
            message.success('删除成功')
            showAddModalStatus.value = false
            getInfoList()
        } else {
            message.error('删除失败')
        }
    }).catch(() => {
        message.error('删除失败,存在参照关系')
    }).finally(() => {
        loading.destroy()
    })
}

</script>
<style lang="less"></style>