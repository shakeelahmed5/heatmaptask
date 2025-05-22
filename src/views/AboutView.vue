<!-- CountryDetailModal.vue -->
<template>
  <div class="modal-overlay" @click.self="close">
    <div class="modal-content" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
      <button class="modal-close" @click="close" aria-label="Close modal">&times;</button>
      <h2 id="modalTitle" class="modal-title">Details for {{ countryCode }}</h2>
      <div v-if="Object.keys(regionData).length">
        <MapChart
          :data="regionData"
          @region-click="onRegionClick"
          style="width: 100%; height: 400px; border-radius: 12px"
        />
        <div class="modal-region-list">
          <div
            v-for="(region, code) in regionData"
            :key="code"
            class="region-item"
            @click="onRegionClick(code)"
            tabindex="0"
            role="button"
            aria-pressed="false"
          >
            <span class="dot" :style="{ backgroundColor: region.color }"></span>
            <strong>{{ region.name }}</strong> - {{ sentimentLabels[region.value] }}
          </div>
        </div>
      </div>
      <p v-else>No regional data available for this country.</p>
    </div>
  </div>
</template>

<script setup>
import { defineProps, defineEmits } from 'vue'
import { MapChart } from 'vue3-map-chart'

const props = defineProps({
  countryCode: String,
  regionData: Object,
  sentimentLabels: Object,
})

const emit = defineEmits(['close'])

function close() {
  emit('close')
}

function onRegionClick(regionCode) {
  const region = props.regionData[regionCode]
  alert(
    `${region?.name || regionCode} Details:\nSentiment: ${
      props.sentimentLabels[region?.value] || 'Unknown'
    }\n${region?.details || ''}`,
  )
}

// This would be your country-level regions data
// For demo, I'm faking some regional data. Replace with your actual regional data.
const countryRegionData = ref({})

function prepareCountryRegionData(countryCode) {
  // Example structure:
  // { regionCode: { value: sentiment, color: color, name: 'Region Name', details: 'More info' } }

  // You should replace below with your actual region data for the country.

  // Demo example for 2 countries:
  if (countryCode === 'US') {
    countryRegionData.value = {
      CA: {
        name: 'California',
        value: 2,
        color: sentimentColor(2),
        details: 'Sunny and positive vibes',
      },
      TX: { name: 'Texas', value: 3, color: sentimentColor(3), details: 'Neutral mood here' },
      NY: { name: 'New York', value: 1, color: sentimentColor(1), details: 'Neutral sentiment' },
    }
  } else if (countryCode === 'IN') {
    countryRegionData.value = {
      DL: { name: 'Delhi', value: 3, color: sentimentColor(3), details: 'Negative sentiment' },
      MH: {
        name: 'Maharashtra',
        value: 2,
        color: sentimentColor(2),
        details: 'Positive sentiment',
      },
      KA: { name: 'Karnataka', value: 1, color: sentimentColor(1), details: 'Neutral sentiment' },
    }
  } else {
    // fallback if no data
    countryRegionData.value = {}
  }
}
</script>

<style scoped>
/* Use the same modal styles as before */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.35);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  padding: 1rem;
}

.modal-content {
  background: white;
  border-radius: 12px;
  width: 100%;
  max-width: 720px;
  max-height: 90vh;
  overflow-y: auto;
  padding: 1.5rem 2rem;
  box-shadow: 0 12px 30px rgba(0, 0, 0, 0.2);
  position: relative;
}

.modal-close {
  position: absolute;
  top: 16px;
  right: 20px;
  background: none;
  border: none;
  font-size: 2rem;
  line-height: 1;
  cursor: pointer;
  color: #999;
  transition: color 0.3s ease;
}

.modal-close:hover {
  color: #555;
}

.modal-title {
  margin-bottom: 1rem;
  font-weight: 700;
  font-size: 1.5rem;
  color: #222;
  text-align: center;
}

.modal-region-list {
  margin-top: 1rem;
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  justify-content: center;
}

.region-item {
  cursor: pointer;
  background: #f8f8f8;
  border-radius: 8px;
  padding: 10px 16px;
  min-width: 140px;
  display: flex;
  align-items: center;
  gap: 10px;
  font-weight: 600;
  font-size: 1rem;
  color: #333;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: background-color 0.3s ease;
  user-select: none;
}

.region-item:hover,
.region-item:focus {
  background-color: #e6f7e6;
  outline: none;
}

.region-item .dot {
  width: 18px;
  height: 18px;
  border-radius: 50%;
}
</style>
