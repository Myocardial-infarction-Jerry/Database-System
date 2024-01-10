import { createRouter, createWebHashHistory, RouteRecordRaw } from 'vue-router'

import Info from './info.vue'
import Course from './course.vue'
import Teachers from './teachers.vue'
import Courses from './courses.vue'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    alias: '/info',
    name: 'info',
    component: Info
  },
  {
    path: '/course',
    name: 'course',
    component: Course
  },
  {
    path: '/teachers',
    name: 'teachers',
    component: Teachers
  },
  {
    path: '/courses',
    name: 'courses',
    component: Courses
  },
]

export const router = createRouter({
  routes,
  history: createWebHashHistory()
})
