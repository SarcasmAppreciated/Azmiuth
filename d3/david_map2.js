

var width = 960,
    height = 550;

var svg = d3.select("#figure").append("svg")
    .attr("width", width)
    .attr("height", height);

// Mapping colors
var colors = {
    soil: '#00441b',
    Soil: '#00441b',
    sediment: '#00441b',
    air: '#737373',
    water: '#4292c6',
    Thermal_springs: '#6baed6',
    Non_marine_Saline_and_Alkaline: '#2171b5',
    Marine: '#08519c',
    Freshwater: '#4292c6',
    Deep_subsurface: '#41ab5d',
    test: "red"
};

var my_projection = d3.geo.kavrayskiy7()
                      .scale(170)
                      //.rotate([-50,90])
                      .translate([width / 2, height / 2])
                      //.clipAngle(90)
                      .precision(.1);

var path = d3.geo.path()
             .projection(my_projection);

var tooltip = d3.select("body")
  .append("div")
  .style("position", "absolute")
  .style("z-index", "10")
  .attr("class", "hoverinfo")
  .style("visibility", "hidden");

var graticule = d3.geo.graticule();

svg.append("defs").append("path")
  .datum({type: "Sphere"})
  .attr("id", "sphere")
  .attr("d", path);

svg.append("use")
  .attr("class", "stroke")
  .attr("xlink:href", "#sphere");

svg.append("use")
  .attr("class", "fill")
  .attr("xlink:href", "#sphere");

// add graticules
svg.append("path")
   .datum(graticule)
   .attr("class", "graticule")
   .attr("d", path);


// display the world
d3.json("world.json", function(error, world) {
  if (error) return console.error(error);
  
  var subunits = topojson.feature(world, world.objects.subunits);

  // path generator
  var path = d3.geo.path()
               .projection(my_projection);
  // Styling polygons
  svg.selectAll(".subunit")
       .data(subunits.features)
       .enter().append("path")
       //.attr("class", function(d) { return "subunit " + d.id; })
       .attr("class", "land")
       .attr("d", path);
  
  // display boundaries
  svg.append("path")
      .datum(topojson.mesh(world, world.objects.subunits, function(a, b) { return a !== b }))
      .attr("d", path)
      .attr("class", "border");
  
      // parse the bubble data
      d3.text("imgm_bubble_data.csv", function(text) {
          var bubble_data = d3.csv.parse(text);
              // res = {
              //     name: d.name,
              //     radius: +d.radius,
              //     fillKey: d.fillKey,
              //     latitude: +d.latitude,
              //     longitude: +d.longitude
              // };
              // return res;
              // }, function(error, rows) {
              //    console.log(rows);
              // });
          console.log(bubble_data);
          plot_bubbles(bubble_data);
      });
  
  });

// bubble radius
var bubble_radius = d3.scale.sqrt()
    .domain([0, 100000])
    .range([2.5, 20]);




function create_tooltip_message(bubble_data) {
    message = "Name: " + bubble_data.name + "<br/> Class: " + bubble_data.fillKey + "<br/> Lat: " + bubble_data.latitude + " Long: " + bubble_data.longitude + "<br/> Sequencing: " + bubble_data.mbs + " Mbs" + "<br/>" + "Project: " + bubble_data.project;
    return message;
}

function plot_bubbles(bubble_data) {
    // plot circles
    svg.append("g")
        .attr("class", "bubble")
        .selectAll("circle")
        .data(bubble_data)
        .enter().append("circle")
        .attr("transform", function(d) {
            dat = [d.longitude, d.latitude];
            return "translate(" + my_projection(dat) + ")"; 
            })
        .attr("r", function(d) {
            return bubble_radius(d.mbs);
            })
        .attr("fill", function(d) { return colors[d.fillKey];})
        .on("mouseover", function(d){
            tooltip.html(create_tooltip_message(d));
            return tooltip.style("visibility", "visible");
            })
        .on("mousemove", function(){
            return tooltip.style("top",(d3.event.pageY-10)+"px").style("left",(d3.event.pageX+10)+"px");
            })
        .on("mouseout", function(){
            return tooltip.style("visibility", "hidden");
            });
}
