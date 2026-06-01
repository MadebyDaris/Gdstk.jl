using Gdstk

println("Checking Gdstk C++ wrapper functionality...")

# hello_gds() is a simple exported function to test that the wrapper loaded
result = hello_gds()
println("Response from C++: ", result)

# Replace this with the path to your own .gds file
gds_file_path = joinpath(@__DIR__, "..", "src_cpp", "gdstk", "tests", "proof_lib.gds")

if isfile(gds_file_path)
    println("\nReading GDS file: ", gds_file_path)
    
    # read_gds returns a Library object containing all the cells
    lib = read_gds(gds_file_path)
    
    println("Successfully loaded GDS library!")
    
    # Note: To access a specific cell, you need to know its name in the GDS file.
    # For example, if you know the cell is named "MAIN", you would do:
    # my_cell = Gdstk.get_cell(lib, "MAIN")
else
    println("\nCould not find $gds_file_path.")
    println("Please replace the 'gds_file_path' variable with a valid path to run the example.")
end
