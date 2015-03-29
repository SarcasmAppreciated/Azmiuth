$(document).ready(function(){

var countryFeature;

var projection = d3.geo.azimuthal()
  .scale(485)
  .origin([-71.03,42.37])
  .mode('orthographic')
  .translate([400, 400]);

var circle = d3.geo.greatCircle().origin(projection.origin());

var scale = {  orthographic: 380,  stereographic: 380,  gnomonic: 380,  
  equidistant: 380 / Math.PI * 2,  equalarea: 380 / Math.SQRT2};

var path = d3.geo.path()
  .projection(projection);

var svg = d3.select("#chart")
  .append('svg:svg')
  .attr("viewBox", "0 0 800 600")
  .on('mousedown', mousedown);

var countries = svg.append('g')
  .attr('id', 'countries');

var bubble_radius = 1;

var tooltip = d3.select("body")
  .append("div")
  .style("position", "absolute")
  .style("z-index", "10")
  .attr("class", "hoverinfo")
  .style("visibility", "hidden");

d3.json(world_countries_path, function(collection) {  

  countryFeature = countries.selectAll('path')
  .data(collection.features)
  .enter().append('svg:path')
  .attr('d', clip);
});

d3.select(window)
  .on('mousemove', mousemove)
  .on('mouseup', mouseup);

d3.select('select')
  .on('change', function() {  
      projection
      .mode(this.value)
      .scale(scale[this.value]);  
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
    plot_tweets(tweets);
    // Want to remove the old path
    d3.selectAll(".arc").remove();
    plot_paths();
    // Now refresh the entire map so that the updates take effect
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

function create_tooltip_message(bubble_data) {
  message = "ICEBERG <br/> Iceberg Number: " + bubble_data.berg_number + "<br/> Date: " + bubble_data.date + "<br/> Latitude: " + bubble_data.latitude + " <br/> Longitude: " + bubble_data.longitude + "<br/> Size: " + bubble_data.size + "<br/> Shape: " + bubble_data.shape;
  return message;
}


function create_tooltip_message_tweets(tweet_data) {
  message = "TWEET <br/> Latitude: " + tweet_data.latitude + " <br/> Longitude: " + tweet_data.longitude + "<br/> Timestamp: " + tweet_data.time_stamp + "<br/> Tweet: " + tweet_data.tweet_text;

  return message;
}

function plot_bubbles(bubble_data) {
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

// ZOOM FUNCTIONALITY

var scale_size = 485;
var scale_factor = 1;

function zoom_Helper(scale_input){
  scale_size = scale_input;
  // Remove old elements
  d3.selectAll(".arc").remove();
  d3.selectAll("circle").remove();
  // Resize the projection
  projection.scale(scale_size);
  // Plot the elements back on
  plot_bubbles(icebergs);
  plot_tweets(tweets);
  plot_paths();
  // Generate the map again.
  refresh();

  adjustFooter();
}


var aboutHeight = $(".content").offset().top + $(".content").height() + 75;
var initHeight = $(document).height() - 75;
var initialHeight = Math.max(initHeight, aboutHeight);

// Please let me keep this here; possible start for future - Ben
/*
 $("#footer").css("top", initialHeight);
  if(currentHeight > initialHeight) {
  $("#footer").fadeOut("fast", function(){
  currentHeight = $(document).height() - 75;
  $("#footer").css("top",initialHeight).animate({top: currentHeight }).fadeIn("slow");		
  });
  }
*/

function adjustFooter() {
  var currentHeight = $(document).height() - 75;
  if(currentHeight > initialHeight) {
    $("#footer").fadeOut("slow");
  } else {
    $("#footer").fadeIn("slow");
  }
}

d3.selectAll('#zoom_in').on('click', function(){
  d3.event.preventDefault();
  scale_size += 50;
  zoom_Helper(scale_size);
});

d3.selectAll('#zoom_out').on('click', function(){
  d3.event.preventDefault();
  scale_size -= 50;
  zoom_Helper(scale_size);
});


// ZOOM
var zoom = d3.behavior.zoom()
  .on("zoom",function() {

    if (d3.event.scale < 1){
      scale_factor = 0.75;
    }
    if (d3.event.scale > 1){
      scale_factor = 1.25;
    }

    if(scale_size >= 485 && scale_size <= 2500){
      scale_size = scale_size * scale_factor;
      zoom_Helper(scale_size);
      if (scale_size <= 485) {
        scale_size = 485;
      }
      if (scale_size >= 2500) {
        scale_size = 2500;
      }
    }
  });

svg.call(zoom);

// PATH FUNCTIONALITY

var lineTransition = function lineTransition(path) {
  path.transition()
    .duration(0)
    .attrTween("stroke-dasharray", ("3,3"));
};

var links = [];
if (tweets != null){
  if (tweets.length != 0) {

    for(var i=0, len=tweets.length-1; i<len; i++){
      links.push({
        type: "LineString",
        coordinates: [
        [ tweets[i].longitude, tweets[i].latitude ],
        [ tweets[i+1].longitude, tweets[i+1].latitude ]
        ]
      });
    }
  } 
}

var arcGroup = svg.append('g');
var pathArcs = arcGroup.selectAll(".arc").data(links);

function plot_paths() {

  pathArcs.enter()
    .append("path").attr({
      'class': 'arc'
    }).style({ 
      fill: 'none',
    });
  pathArcs.attr({
    d: path
  }).style({
    stroke: '#0066CC',
    'stroke-width': '2px'
  })
  .call(lineTransition); 
  pathArcs.exit().remove();
}

plot_paths();

function plot_tweets(tweet_data) {
  svg.append("g")
    .attr("class", "bubble")
    .selectAll("circle")
    .data(tweet_data)
    .enter().append("circle")
    .attr("transform", function(d) {
      tweet_dat = [d.longitude, d.latitude];
      return "translate(" + projection(tweet_dat) + ")"; 
    })
  .attr("r", function() {
    return bubble_radius;
  })
  .on("mouseover", function(d){
    tooltip.html(create_tooltip_message_tweets(d));
    return tooltip.style("visibility", "visible");
  })
  .on("mousemove", function(){
    return tooltip.style("top",(d3.event.pageY-10)+"px").style("left",(d3.event.pageX+10)+"px");
  })
  .on("mouseout", function(){
    return tooltip.style("visibility", "hidden");
  });
}

plot_tweets(tweets)
});
