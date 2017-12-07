<template>
  <div>
    <svg ref="chart" class="simple-chart"></svg>
  </div>
</template>

<script>
  import * as d3 from 'd3'

  export default {

    props: ['data', 'xLabel', 'yLabel'],

    data() {
      return {}
    },

    mounted() {
      const svg = d3.select(this.$refs.chart)
      const containerWidth = this.$refs.chart.clientWidth
      const containerHeight = this.$refs.chart.clientHeight

      const margin = {top: 5, right: 10, bottom: 35, left: 50}
      const width = containerWidth - margin.left - margin.right
      const height = containerHeight - margin.top - margin.bottom
      const g = svg.append('g')
        .attr('width', width)
        .attr('height', height)
        .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

      // Define X axe
      const x = d3.scalePoint()
        .domain(this.data.map(d => d.key))
        .rangeRound([0, width])

      // Define Y axe
      const y = d3.scaleLinear()
        .domain([0, d3.max(this.data, d => d.value)])
        .rangeRound([height, 0])

      // Define the the area
      const area = d3.area()
        .x(d => x(d.key))
        .y0(height)
        .y1(d => y(d.value))
        .curve(d3.curveBasis)


      // Add the Y gridlines
      g.append('g')
        .attr('class', 'grid')
        .call(d3.axisLeft(y)
          .ticks(5)
          .tickSize(-width)
          .tickFormat('')
        )

      // add the area
      g.append('path')
        .data([this.data])
        .attr('class', 'area')
        .attr('d', area);

      g.append('g')
        .attr('class', 'axis axis--x')
        .attr('transform', 'translate(0,' + height + ')')
        .call(d3.axisBottom(x))
        .style('font-size', '12')

      // text label for the x axis
      g.append('text')
        .attr('transform', 'translate(' + (width/2) + ' ,' + (height + margin.top + 25) + ')')
        .style('text-anchor', 'middle')
        .style('font-size', '14')
        .attr('dy', '0.3em')
        .text(this.xLabel);
      
      g.append('g')
        .attr('class', 'axis axis--y')
        .call(d3.axisLeft(y).ticks(5))
        .style('font-size', '12')

      // text label for the y axis
      g.append('text')
        .attr('transform', 'rotate(-90)')
        .attr('y', 0 - margin.left)
        .attr('x', 0 - (height / 2))
        .attr('dy', '0.7em')
        .style('text-anchor', 'middle')
        .style('font-size', '14')
        .text(this.yLabel);
    },

    methods: {
      draw() {

      }
    }

  }
</script>

<style>
  .simple-chart {
    width: 100%;
    height: 100%;
  }
  .area {
    fill: #64d6bd;
  }
  .grid line {
    stroke: lightgrey;
    stroke-opacity: 0.7;
    shape-rendering: crispEdges;
  }
  .grid .domain {
    display: none;
  }
  .tick text{
    fill: grey;
  }
</style>