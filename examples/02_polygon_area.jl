using Gdstk

# This example demonstrates how to extract polygons from a cell and calculate their area.
# Note: You will need to replace `gds_file_path` and `cell_name` with valid values for your specific GDS file.

gds_file_path = "path/to/your/layout.gds"
cell_name = "MAIN_CELL"

if isfile(gds_file_path)
    println("Reading GDS file: ", gds_file_path)
    lib = read_gds(gds_file_path)
    
    # 1. Extract the target cell from the library
    my_cell = Gdstk.get_cell(lib, cell_name)
    
    # 2. Extract polygons from the cell
    # Arguments for get_polygons: 
    # cell, apply_repetitions (bool), layer (int), datatype (int)
    layer = 1
    datatype = 0
    
    # We call this using the Gdstk module prefix because it's not exported by default
    polygons = Gdstk.get_polygons(my_cell, true, layer, datatype)
    
    num_polygons = length(polygons)
    println("Found $num_polygons polygons on Layer $layer, Datatype $datatype.")
    
    # 3. Calculate areas
    if num_polygons > 0
        total_area = 0.0
        
        # Iterate over the Julia array of C++ Polygon pointers
        for i in 1:num_polygons
            poly = polygons[i]
            
            # The area() method is exported and operates directly on the Polygon object
            p_area = area(poly)
            
            println("Polygon $i Area: ", p_area)
            total_area += p_area
        end
        
        println("-------------------------")
        println("Total Area: ", total_area)
    end
else
    println("Could not find $gds_file_path. Please edit this script and provide a valid GDS file path.")
end
