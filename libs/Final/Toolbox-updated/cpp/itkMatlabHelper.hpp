// ITK Headers
#include "itkImage.h"
#include "itkImageRegionConstIterator.h"
#include "itkImageRegionIterator.h"

// MATLAB Headers
#include "mex.h"
#include "matrix.h"

template <typename TPixel, unsigned int Dimension>
 typename itk::Image< TPixel, Dimension >::Pointer
  mxArray2itkImage( const mxArray& input_mxarray)
{
	// Extract information from the mxArray
	mwSize num_dims = mxGetNumberOfDimensions( &input_mxarray );
	if (num_dims != Dimension)
	{
		mexErrMsgTxt("mxArray2itkImage: Mismatch in the number of dimensions.\n");
	}
	const mwSize *input_size = mxGetDimensions( &input_mxarray );

	// Create the itk Image that we will write to
	// See http://www.itk.org/CourseWare/Training/GettingStarted-V.pdf
	typedef itk::Image< TPixel, Dimension > ImageType;
	ImageType::Pointer itk_image = ImageType::New();
	// Create meta-information about the image
	ImageType::SizeType region_size;
	ImageType::IndexType start;
	if (Dimension == 2)
	{
		region_size[0] = input_size[1];
		region_size[1] = input_size[0];
		
		start[0] = 0;
		start[1] = 0;
	} 
	if (Dimension == 3) 
	{
		region_size[0] = input_size[1];
		region_size[1] = input_size[0];
			region_size[2] = input_size[2];

		start[0] = 0;
		start[1] = 0;
		start[2] = 0;
	}

	float spacing[Dimension];
	for( int i = 0; i < Dimension; ++i)
		spacing[i] = 1;
	// Create a region using that meta-information
	ImageType::RegionType region;
	region.SetSize( region_size );
	region.SetIndex( start );
	// Allocate that region within the itk_image object
	itk_image->SetRegions( region );
	itk_image->Allocate();

	// Create the objects for the iteration
	typedef itk::ImageRegionIterator< ImageType > IteratorType;
	IteratorType itk_image_iter( itk_image, region );
	// get a pointer to the internal data of the mxArray
	const double *mx_image_data = mxGetPr( &input_mxarray );

	// Iterate through the image data, transpose, and copy
	size_t count = 0;
	unsigned long slice_size = region_size[0]*region_size[1];
	for (itk_image_iter.GoToBegin(); !itk_image_iter.IsAtEnd(); ++itk_image_iter)
    {
		// iterates through the image as x - y - z
		// The first term determines the slice
		itk_image_iter.Set( mx_image_data[(count/slice_size)*slice_size + (count % slice_size)/region_size[0] + (count % region_size[0])*region_size[1]] );
		count++;
    }

	return itk_image;
}


template <typename TPixel, const unsigned int Dimension>
mxArray* itkImage2mxArray( typename itk::Image< TPixel, Dimension >::Pointer itk_image_pointer )
{
	// Extract information from the itk_image
	typedef itk::Image< TPixel, Dimension > ImageType;
	// we want the whole image and to know its size
	ImageType::RegionType region = itk_image_pointer->GetLargestPossibleRegion();
	ImageType::SizeType region_size = region.GetSize();

	// Create the mxArray that we will write to
	mxArray *mx_image_ptr = NULL;
	//  be careful of the way the size is described
	mwSize size[Dimension];
	if( Dimension == 2)
	{
		size[0] = region_size[1];
		size[1] = region_size[0];
	} else if( Dimension == 3) {
		size[0] = region_size[1];
		size[1] = region_size[0];
		size[2] = region_size[2];
	}

	mx_image_ptr = mxCreateNumericArray( Dimension, size, mxDOUBLE_CLASS, mxREAL );

	// Create the objects for the iteration
	typedef itk::ImageRegionConstIterator< ImageType > ConstIteratorType;
	ConstIteratorType itk_image_iter( itk_image_pointer, region );
	// get a pointer to the internal data of the mxArray
	double *mx_image_data = mxGetPr( mx_image_ptr );

	// Iterate through the image data, transpose, and copy
	unsigned int count = 0;
	unsigned int slice_size = region_size[0]*region_size[1];
	for (itk_image_iter.GoToBegin(); !itk_image_iter.IsAtEnd(); ++itk_image_iter)
    {
		// iterates through the image as x - y - z
		// The first term determines the slice
		mx_image_data[(count/slice_size)*slice_size + (count % slice_size)/region_size[0] + (count % region_size[0])*region_size[1]] = itk_image_iter.Value();
		count++;
    }

	return mx_image_ptr;
}

template< typename T >
std::vector<std::vector<T>> mxArray2vector(const mxArray* m_array){
	std::vector<std::vector<T>> vec;
	double *p_array = mxGetPr(m_array);
	mwSize mrows = mxGetM(m_array);
	mwSize ncols = mxGetN(m_array);
	for(int i=0; i < mrows; ++i){
		std::vector<T> temp;
		for(int j=0; j < ncols; ++j)
			temp.push_back((T)p_array[j*mrows+i]);
		vec.push_back(temp);
	}
	return vec;
}