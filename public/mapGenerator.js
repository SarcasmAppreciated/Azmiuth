$(document).ready(function(){

  var countryFeature;

  var datacentreFeature;

  var projection = d3.geo.azimuthal()
  .scale(485)
  .origin([-71.03,42.37])
  .mode('orthographic')
  .translate([400, 400]);

var circle = d3.geo.greatCircle().origin(projection.origin());

// TODO fix d3.geo.azimuthal to be consistent with scale
var scale = {  orthographic: 380,  stereographic: 380,  gnomonic: 380,  
  equidistant: 380 / Math.PI * 2,  equalarea: 380 / Math.SQRT2};

var path = d3.geo.path().projection(projection);

var svg = d3.select("#chart")
  .append('svg:svg')
  .attr('width', 800)    
  .attr('height', 600)
  .on('mousedown', mousedown);

var countries = svg.append('g')
  .attr('width', 800)
  .attr('height', 600)
  .attr('id', 'countries');

var bubble_radius = 2;

var tooltip = d3.select("body")
  .append("div")
  .style("position", "absolute")
  .style("z-index", "10")
  .attr("class", "hoverinfo")
  .style("visibility", "hidden");

d3.json('world-countries.json', function(collection) {  

  countryFeature = countries.selectAll('path')
  .data(collection.features)
  .enter().append('svg:path')
  .attr('d', clip);

countryFeature.append("svg:title").text(function(d) { return d.properties.name; }).attr('text-anchor', 'middle');

});

d3.select(window).on('mousemove', mousemove)
.on('mouseup', mouseup);

d3.select('select').on('change', 
    function() {  
      projection.mode(this.value).scale(scale[this.value]);  
      refresh(750);
    });

plot_bubbles(icebergs);

var m0, o0;

function mousedown() {  
  m0 = [d3.event.pageX, d3.event.pageY];  
  o0 = projection.origin();  
  d3.event.preventDefault();
}

function mousemove() {  
  if (m0) {    
    // translate everything to their new coordinates on the globe corresponding to the new origin 
    var m1 = [d3.event.pageX, d3.event.pageY], 
        o1 = [o0[0] + (m0[0] - m1[0]) / 8, o0[1] + (m1[1] - m0[1]) / 8];    
    projection.origin(o1);    
    circle.origin(o1);    
    // Want to remove only the icebergs
    d3.selectAll("circle").remove();
    plot_bubbles(icebergs);
    refresh();  
  }
}

function mouseup() {  
  if (m0) {    
    mousemove();    
    m0 = null;  
  }
}

function refresh(duration) {  
  (duration ? 
   countryFeature.transition().duration(duration) 
   : countryFeature)
    .attr('d', clip);
}

function clip(d) {  
  return path(circle.clip(d));
}

function ballSize (datum) {
  return (datum.kgCO2e > 1) ? 10 : (10 * Math.exp((1 - datum.kgCO2e), 2));
}  

function assignClass (datum) {
  return (datum.kgCO2e > 0.2) ? "f" : "m"; 
}


function create_tooltip_message(bubble_data) {
  message = "berg_number: " + bubble_data.berg_number + "<br/> date: " + bubble_data.date + "<br/> latitude: " + bubble_data.latitude + " <br/> longitude: " + bubble_data.longitude + "<br/> size: " + bubble_data.size + "<br/> shape: " + bubble_data.shape;
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
      return "translate(" + projection(dat) + ")"; 
    })
  .attr("r", function() {
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

var g = svg.append("g");

function zoom(){
  d3.behavior.zoom()
    .on("zoom",function() {
      g.attr("transform","translate("+ 
        d3.event.translate.join(",")+")scale("+d3.event.scale+")");
      //g.selectAll("path")  
      g.selectAll("circle")  
      .attr("d", path.projection(projection)); 
    console.log("helloworld");
    });
}

svg.call(zoom);

/*
   function plot_paths(path_data) {
// plot circles
svg.append("g")
.attr("class", "line")
.selectAll("line")
.data(path_data)
.enter().append("line")
.attr("transform", function(d) {
dat = [d.longitude, d.latitude];
return "d3.interpolate(linear).projection(dat)"; 
})
}

plot_paths(icebergs);
*/


var arcGroup = g.append('g');

var lineTransition = function lineTransition(path) {
    path.transition()
    .duration(5500)
    .attrTween("stroke-dasharray", tweenDash)
    .each("end", function(d,i) { 
    });
};

var tweenDash = function tweenDash() {
  var len = this.getTotalLength(),
      interpolate = d3.interpolateString("0," + len, len + "," + len);

  return function(t) { return interpolate(t); };
};

console.log(tweets);

var links = [
{
  type: "LineString",
    coordinates: [
      [ tweets[0].longitude, icebergs[0].latitude ],
      [ tweets[1].longitude, icebergs[1].latitude ]
    ]
}
];

links = [];
for(var i=0, len=tweets.length-1; i<len; i++){
  links.push({
    type: "LineString",
    coordinates: [
    [ tweets[i].longitude, icebergs[i].latitude ],
    [ tweets[i+1].longitude, icebergs[i+1].latitude ]
    ]
  });
}

var pathArcs = arcGroup.selectAll(".arc")
.data(links);


pathArcs.enter()
  .append("path").attr({
    'class': 'arc'
  }).style({ 
    fill: 'none',
  });

pathArcs.attr({
  d: path
})
.style({
  stroke: '#0000ff',
  'stroke-width': '2px'
})
.call(lineTransition); 
pathArcs.exit().remove();



});
