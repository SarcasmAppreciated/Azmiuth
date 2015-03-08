// Pretty circles --------->

color = d3.scale.linear()
	.domain([12, 30])
	.range(["red", "green"]);  
	
size = d3.scale.linear()
	.domain([0, 10]);
// <----- Pretty circles

var countryFeature;

var datacentreFeature;

var projection = d3.geo.azimuthal()
			 //.scale(300)
			 .scale(600)
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

var datacentres = svg.append('g')
			.attr('width', 800)
			.attr('height', 600)
			.attr('id', 'datacentres');

var bubble_data2 = d3.text("IIP_2014IcebergSeason.csv", function(text) {
				   d3.csv.parse(text);      
});

var bubble_radius = 3;

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

d3.json('datacentres.json', function(json) {
  datacentreFeature = datacentres.selectAll('g')
	  .data(json.features)
	  .enter()
	  .append('g')
	  .append('svg:circle')
		 .attr('class', function(d) { return assignClass(d.properties.kgCO2e); })
		 .attr('r', function(d) { return 10; })
		 //return size(ballSize(d.properties.kgCO2e))
		 .attr("fill", function(d) { return color((10 * Math.exp((1 - d.properties.kgCO2e), 2))); });
   datacentreFeature = datacentres.selectAll('g');

});

d3.select(window).on('mousemove', mousemove)
				 .on('mouseup', mouseup);

d3.select('select').on('change', 
  function() {  
  projection.mode(this.value).scale(scale[this.value]);  
  refresh(750);
});

d3.text("IIP_2014IcebergSeason.csv", function(text) {
	  var bubble_data = d3.csv.parse(text);
	  plot_bubbles(bubble_data);
});

var m0, o0;

function mousedown() {  
  m0 = [d3.event.pageX, d3.event.pageY];  
  o0 = projection.origin();  
  d3.event.preventDefault();
}

function mousemove() {  
  if (m0) {    
	var m1 = [d3.event.pageX, d3.event.pageY], 
	  o1 = [o0[0] + (m0[0] - m1[0]) / 8, o0[1] + (m1[1] - m0[1]) / 8];    
	  projection.origin(o1);    
	  circle.origin(o1);    
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
 
//  (duration ? 
//    datacentreFeature.transition().duration(duration) 
//    : datacentreFeature)
//      .attr('transform', function (d) { return "translate(" + clip(d) + ")"; });
//   
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
	//message = "Name: " + bubble_data.name + "<br/> Class: " + bubble_data.fillKey + "<br/> Lat: " + bubble_data.latitude + " Long: " + bubble_data.longitude + "<br/> Sequencing: " + bubble_data.mbs + " Mbs" + "<br/>" + "Project: " + bubble_data.project;
	//ICE-YEAR,BERG_NUMBER,DATE,TIME,LATITUDE,LONGITUDE,METHOD,SIZE,SHAPE,SOURCE

	//message = "ICE_YEAR: " + bubble_data.ICE-YEAR + "<br/> BERG_NUMBER: " + bubble_data.BERG_NUMBER + "<br/> DATE: " + bubble_data.DATE + "<br/> LATITUDE: " + bubble_data.LATITUDE + " <br/> LONGITUDE: " + bubble_data.LONGITUDE + "<br/> METHOD: " + bubble_data.METHOD + "<br/> SIZE: " + bubble_data.SIZE + "<br/> SHAPE: " + bubble_data.SHAPE + "<br/> SOURCE: " + bubble_data.SOURCE;
	message = "BERG_NUMBER: " + bubble_data.BERG_NUMBER + "<br/> DATE: " + bubble_data.DATE + "<br/> LATITUDE: " + bubble_data.LATITUDE + " <br/> LONGITUDE: " + bubble_data.LONGITUDE + "<br/> METHOD: " + bubble_data.METHOD + "<br/> SIZE: " + bubble_data.SIZE + "<br/> SHAPE: " + bubble_data.SHAPE + "<br/> SOURCE: " + bubble_data.SOURCE;
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
			dat = [d.LONGITUDE, d.LATITUDE];
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