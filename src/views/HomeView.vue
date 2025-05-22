<template>
  <div class="dashboard">
    <!-- Filters -->
    <div class="controls">
      <!-- Sentiment Filter -->
      <label for="sentiment-select" class="filter-label">Filter by Sentiment:</label>
      <select id="sentiment-select" v-model="selectedSentiment" class="custom-select">
        <option value="all">All Sentiments</option>
        <option value="positive">Positive</option>
        <option value="neutral">Neutral</option>
        <option value="negative">Negative</option>
      </select>

      <!-- Country Filter -->
      <label for="country-select" class="filter-label">Filter by Country:</label>
      <select id="country-select" v-model="selectedCountry" class="custom-select">
        <option value="all">All Countries</option>
        <option v-for="country in uniqueCountries" :key="country.Country" :value="country.Country">
          {{ country.CountryName }}
        </option>
      </select>
    </div>

    <!-- Map Chart -->
    <MapChart
      :key="selectedSentiment + '-' + selectedCountry"
      :data="mappedData"
      @map-item-hover="onHover"
      @map-item-click="onClick"
      :displayLegend="false"
      class="map-chart"
    />

    <!-- Legend -->
    <div class="legend">
      <div class="legend-item">
        <span class="dot positive"></span><span class="legend-label">Positive (2)</span>
      </div>
      <div class="legend-item">
        <span class="dot neutral"></span><span class="legend-label">Neutral (1)</span>
      </div>
      <div class="legend-item">
        <span class="dot negative"></span><span class="legend-label">Negative (3)</span>
      </div>
    </div>

    <!-- Tooltip -->
    <div v-if="hoveredRegion" class="tooltip" role="tooltip" aria-live="polite">
      Sentiment: {{ sentimentLabels[regionSentiment[hoveredRegion]] || 'Unknown' }}
    </div>
  </div>

  <!-- Modal -->
  <div v-if="showModal" class="modal-overlay" @click.self="showModal = false">
    <div class="modal-content" role="dialog" aria-modal="true">
      <h2>Country Details</h2>
      <p><b>Country:</b> {{ modalData.countryName }}</p>
      <p><b>Region:</b> {{ modalData.region }}</p>
      <p><b>Sentiment:</b> {{ modalData.sentiment }}</p>

      <div class="modal-footer">
        <button class="modal-close" @click="showModal = false">Close</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { MapChart } from 'vue3-map-chart'
import 'vue3-map-chart/dist/style.css'
import rawJsonData from '../data.json'

const selectedSentiment = ref('all')
const selectedCountry = ref('all')
const hoveredRegion = ref(null)

const showModal = ref(false)
const modalData = ref({
  countryName: '',
  region: '',
  sentiment: '',
})

const sentimentLabels = {
  3: 'Negative',
  1: 'Neutral',
  2: 'Positive',
}

const sentimentColor = (value) => {
  switch (value) {
    case 3:
      return '#ff4d4f'
    case 1:
      return '#faad14'
    case 2:
      return '#52c41a'
    default:
      return '#d9d9d9'
  }
}

// Unique country list
const uniqueCountries = computed(() => {
  const seen = new Set()
  return rawJsonData.filter(({ Country }) => {
    if (seen.has(Country)) return false
    seen.add(Country)
    return true
  })
})

const reducedSentiments = computed(() => {
  const result = {}
  rawJsonData.forEach(({ Country, RandomValue }) => {
    result[Country] = RandomValue
  })
  return result
})

const mappedData = computed(() => {
  const result = {}
  for (const [country, sentiment] of Object.entries(reducedSentiments.value)) {
    const match =
      selectedSentiment.value === 'all' ||
      (selectedSentiment.value === 'positive' && sentiment === 2) ||
      (selectedSentiment.value === 'neutral' && sentiment === 1) ||
      (selectedSentiment.value === 'negative' && sentiment === 3)
    const matchesCountry = selectedCountry.value === 'all' || country === selectedCountry.value
    console.log('selectedCountry value:', selectedCountry.value)
    if (match && matchesCountry) {
      result[country] = {
        value: 1,
        color: sentimentColor(sentiment),
      }
    }
  }
  return result
})

function onHover(regionCode) {
  hoveredRegion.value = regionCode
}

function onClick(regionCode) {
  const sentiment = reducedSentiments.value[regionCode]
  const regionData = rawJsonData.find((item) => item.Country === regionCode)

  modalData.value = {
    countryName: regionData?.CountryName?.toUpperCase() || 'Unknown',
    region: regionData?.Region?.toUpperCase() || 'Unknown',
    sentiment: sentimentLabels[sentiment] || 'Unknown',
  }

  showModal.value = true
}

const regionSentiment = computed(() => reducedSentiments.value)
</script>
