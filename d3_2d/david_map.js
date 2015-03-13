
var bubble_radius = 3;

var width = 800,
    height = 800;

  var projection = d3.geo.mercator() 
  .scale(500)
  .translate([width/1,  height/1])
.clipAngle(90)
  .precision(.1);

var svg = d3.select("#figure").append("svg")
.attr("width", width)
.attr("height", height);

var path = d3.geo.path()
  .projection(projection);

  var tooltip = d3.select("#figure")
  .append("div")
  .style("position", "absolute")
  .style("z-index", "10")
  .attr("class", "hoverinfo")
  .style("visibility", "hidden");

var bubble_data;

var g = svg.append("g");

// load and display the World
d3.json("world-110m2.json", function(topology) {
    g.selectAll("path")
      .data(topojson.object(topology, topology.objects.countries)
          .geometries)
    .enter()
      .append("path")
      .attr("d", path)
});


function create_tooltip_message(bubble_data) {
  message = "BERG_NUMBER: " + bubble_data.BERG_NUMBER + "<br/> DATE: " + bubble_data.DATE + "<br/> LATITUDE: " + bubble_data.LATITUDE + " <br/> LONGITUDE: " + bubble_data.LONGITUDE + "<br/> METHOD: " + bubble_data.METHOD + "<br/> SIZE: " + bubble_data.SIZE + "<br/> SHAPE: " + bubble_data.SHAPE + "<br/> SOURCE: " + bubble_data.SOURCE;
  return message;
}

function plot_bubbles(bubble_data) {
  svg.append("g")
    .attr("class", "bubble")
    .selectAll("circle")
    .data(bubble_data)
    .enter().append("circle")
    .attr("transform", function(d) {
        dat = [d.LONGITUDE, d.LATITUDE];
        return "translate(" + projection(dat) + ")"; 
        })
  .attr("r", function(d) {
      return bubble_radius;
      })
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

var bubble_data2 = d3.text("IIP_2014IcebergSeason.csv", function(text) {
    bubble_data = d3.csv.parse(text);
    plot_bubbles(bubble_data);
    });

var zoom = d3.behavior.zoom()
  .on("zoom",function() {
      g.attr("transform","translate("+ 
        d3.event.translate.join(",")+")scale("+d3.event.scale+")");
      g.selectAll("path")  
      .attr("d", path.projection(projection)); 
      });

svg.call(zoom)

