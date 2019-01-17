# tRacking
Scripts for handling of radiotracking data

### field_test_reference_points
formats the reference points
### field_test_stations
formats the station points


### field_test_bearings
takes raw logger data and calculates bearings at each station for each point

### field_test_triangulation
take bearings and triangulates</br>
current testings:
* different amounts of antennas (1-4)
* different min angles allowed
* different max angles allowed

### field_test_distance
function for updating triangulaion data.frames to include distance to the matching reference point

### field_test_visualization
nice ggplots of the results
