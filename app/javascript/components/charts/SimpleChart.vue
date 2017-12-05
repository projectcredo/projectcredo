<template>
  <div>
    <svg ref="chart" class="simple-chart"></svg>
  </div>
</template>

<script>
  import * as d3 from 'd3'

  export default {

    props: ['data'],

    data() {
      return {}
    },

    mounted() {
      const svg = d3.select(this.$refs.chart)

      const margin = {top: 20, right: 20, bottom: 20, left: 50}
      const width = parseInt(svg.style('width')) - margin.left - margin.right
      const height = parseInt(svg.style('height')) - margin.top - margin.bottom
      const g = svg.append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

      // Define axes
      const x = d3.scaleOrdinal()
        .domain(d3.extent(this.data, d => d.value))
        .range([0, width])

      const y = d3.scaleLinear()
        .domain([0, d3.max(this.data, d => d.value)])
        .rangeRound([height, 0]);

      console.log(this.data)

      // Define lines
      var line = d3.line()
        .x(d => x(d.month))
        .y(d => y(d.value))

//      g.append('g')
//        .attr('transform', 'translate(0,' + height + ')')
//        .call(d3.axisBottom(x))
//        .select('.domain')
//        .remove()

      // Add the valueline path.
      svg.append("path")
        .data([this.data])
        .attr("class", "line")
        .attr("d", line);

      // Add the x Axis
      svg.append("g")
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(x));

      // text label for the x axis
      svg.append("text")
        .attr("transform",
          "translate(" + (width/2) + " ," +
          (height + margin.top + 20) + ")")
        .style("text-anchor", "middle")
        .text("months");

      // Add the y Axis
      svg.append("g")
        .call(d3.axisLeft(y));

      // text label for the y axis
      svg.append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 20 - margin.left)
        .attr("x", 0 - (height / 2))
        .attr("dy", "1em")
        .style("text-anchor", "middle")
        .text("contributions");
    },

  }
</script>

<style>
  .axis path,
  .axis line {
    fill: none;
    stroke: #000;
    shape-rendering: crispEdges;
  }

  .line {
    fill: none;
    stroke: steelblue;
    stroke-width: 2px;
  }

  .simple-chart {
    width: 100%;
    height: 100%;
    /*position: absolute;*/
  }
</style>