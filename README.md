# QR Code to STL Mesh Converter

This is a quick-and-dirty library that converts QR codes into STL meshes.

The idea is to import the STL file into CAD, clean it up, and use it as a
positive or negative stamp to add the QR code to a model to 3d print.

## CAD Notes

The generated STL file contains lots of overlapping rectangular prisms.
You'll either have to do a boolean union of these as-is, or convert them
into CAD objects and then perform the boolean union.

In FreeCAD, my workflow is:
* Mesh -> Split by Components
* (Select all of the hundreds of new meshes.)
* Part -> Shape From Mesh
* (Select all of the hundreds of new shapes.)
* Part -> Convert to Solid
* (Select all of the hundreds of new _solid_ shapes.)
* Part -> Union
* (Select the new shape.)
* Part -> Create a Copy -> Refine Shape
* Export the refined shape as an IGES solid (not shell).

In Blender, you can perform the union on the meshes directly.

_(This is the end of the file.)_
