import Rails from 'rails-ujs'
import * as ActiveStorage from 'activestorage'

Rails.start()
ActiveStorage.start()

import './custom'

import * as bulmaToast from 'bulma-toast'
window.bulmaToast = bulmaToast

// TODO: importar chartkick somente na página do dashboard (backstage)
import Chartkick from 'chartkick'
window.Chartkick = Chartkick

import { openTab } from './tabs'
window.openTab = openTab

import Chart from 'chart.js'
Chartkick.addAdapter(Chart)

import { toggle } from './toggle'
window.toggle = toggle

import { toggleCart } from './toggle'
window.toggleCart = toggleCart
