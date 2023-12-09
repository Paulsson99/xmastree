$fa = 8;
$fs = 0.01;
//////////////////////////////////////
// Start User Settings
// All lengths in mm
//////////////////////////////////////
$height = 125; // total height of the tree
$layerHeight = 0.3; // the layer height you're going to set in your slicer
$perimeterWidth = 0.6; // the perimeter width you're going to set in your slicer
$firstLayer = 0.2; // height of the first layer set in slicer
$trunkHeightWished = 10; // height of the lowest branch -- how tall is the trunk? -- cut later to match the layers.
$tipHeight = 3; // how far will the "trunk" extend past the highest branch
$baseRadius = 5; // Radius of the of the trunk at the ground
// the radius of the tip of the tree is $tipRadius, which you can set below
$bottomBranchRadius = 50; // length of the lowest branches
$topBranchRadius = 4; // length of the top branches
$branchSkip = 2; // branches will be drawn every N layers...
$branchVariance = 0.15; // branch length will vary by this amount
//////////////////////////////////////
// End User Settings
//////////////////////////////////////

$trunkHeight = floor($trunkHeightWished/$layerHeight)*$layerHeight - $layerHeight + $firstLayer;
$doublePerimeterWidth = 2*($perimeterWidth - $layerHeight * (1 - PI/4));
// ONE MORE USER SETTING, if you want to change it.
$tipRadius = $doublePerimeterWidth; // radius of the top of the trunk
$branchSpacing = 0.5*$perimeterWidth; // spacing along the trunk between branches

// draw the trunk
cylinder( $height, $baseRadius, $tipRadius);

$osAngle = 0;
// draw the branches - travel up the trunk in steps of "branchSkip" layers
for ($branchHeight = [$trunkHeight : $layerHeight*$branchSkip : $height - $tipHeight]) {
  // calculate the radius of the trunk here
  $radius = $baseRadius - ($branchHeight/$height * ($baseRadius - $tipRadius));
  // and the radius of the branches
  $branchRadius = $bottomBranchRadius - ($bottomBranchRadius - $topBranchRadius)
    *($branchHeight - $trunkHeight)/($height - $tipHeight - $trunkHeight);
  // what angle does a branch alone cut on the trunk?
  $branchAngle = acos((2*$radius^2 - $doublePerimeterWidth^2)/(2*$radius^2));
  // how long is the arc of that angle? add the minimum spacing between branches!
  $branchArc = $branchAngle * PI / 180 * $radius + $branchSpacing;
  // what angle is a branch plus the spacing?
  $branch = $branchArc * 180 / PI / $radius;
  // how many branches will there be (round to an integer number!)
  $branches = floor (360 / $branch);
  // pop up to the right height
  translate([0, 0, $branchHeight]){
      $osAngle = rands(1,360,1)[0];
      // draw the branches at this layer, offset the angle so the branches don't line up.
      for($angle = [0: 360/$branches : 360]){
        rotate([0,0,$angle + $osAngle]){
          translate([-$doublePerimeterWidth/2, 0, 0])
            cube([$doublePerimeterWidth, 
                  rands($branchRadius*(1-$branchVariance),$branchRadius,1)[0], 
                  $layerHeight]);
      }
    }
  }
}
