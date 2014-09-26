#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <string.h>
#include <iostream>
#include <fstream>
#include <vector>
#include "graph.h"
#include <image.h>
#include <float.h>
#include <pnmfile.h>
#include <misc.h>
using namespace std;
using namespace vlib;
typedef Graph<double,double,double> GraphType;
#define smoothSigma 20
#define dataSigma   20

double getSmoothnessTerm(double a1, double a2, double a3, double b1, double b2, double b3);
double getTerm(double a1, double a2, double a3, double b1, double b2, double b3,double sigma);
void getImageData(image<rgb> * img,int i,int j,double * data);
void construstGraph(GraphType * g,image<rgb> * image, char* name,double lambda);

int IsinBoundary(int i, int j, int width, int height)
{
    if(i<0)
        return 0;
    if(j<0)
        return 0;
    if(j>width-1)
        return 0;
    if(i>height-1)
        return 0;
    return 1;
}

int main(int argc,char * * argv)
{
    image<rgb> *image = loadPPM(argv[1]);
    double  lambda = 8;
	if ( argc >= 4)
		lambda = (double) atoi( argv[3]);

    int height = image->height();
    int width  = image->width();

	GraphType *g = new GraphType(height * width,2 * height * width - height - width);

    construstGraph(g,image,argv[2], lambda);
    printf("Build graph Ok!\n");
clock_t start,finish;
start=clock();
	double flow = g -> maxflow();
finish=clock();

	printf("Flow = %lf\n", flow);
cout<<"flow-time="<< ((float)(finish-start))/CLOCKS_PER_SEC<<" sec"<<endl;
vector<rgb> colorLookup(1);
    for(int i = 0;i < height;i ++){
        for(int j = 0;j < width;j ++){
            int index = i * width + j;
            if(g->what_segment(index) == GraphType::SOURCE){
                colorLookup[0].r=255;
                colorLookup[0].g=255;
                colorLookup[0].b=255;
                imRef(image,j,i)=colorLookup[0];
            }
        }
    }

    savePPM(image, "Fake_segmentation.ppm");
	delete g;
	return 0;
}

void construstGraph(GraphType * g,image<rgb> * image, char* name, double lambda){
    int height = image->height();
    int width  = image->width();
    FILE * file = fopen(name,"r+");
    vector<double> Fake_Sal(height*width);
	for(int i = 0;i < height;i ++){
		for(int j=0;j<width;j++)
		{
			fscanf(file,"%lf",&Fake_Sal[i*width+j]);
		}
	}
	printf("Read fake saliency Ok!\n");
	fclose(file);

    //增加节点
    double sourceValue,sinkValue;
    double data[3],data1[3],data2[3];
    int index;
    for(int i = 0;i < height;i ++){
        for(int j = 0;j < width;j ++){
            g->add_node();
            index = i * width + j;
            getImageData(image,i,j,data);
            sourceValue = 1-Fake_Sal[i*width+j];
            sinkValue   = Fake_Sal[i*width+j];
            g->add_tweights(index,sourceValue,sinkValue);
        }
    }

    //增加边
    double value=0;
    int index1,index2;
    for(int i = 0;i < height;i ++)
    {
        for(int j = 0;j < width;j ++)
        {
            index1 = i * width + j;
            getImageData(image,i,j,data1);
            if (IsinBoundary(i,j+1,width,height)==1)
            {
                index2=i * width + j+1;
                getImageData(image,i,j+1,data2);
                value = lambda * getSmoothnessTerm(data1[0],data1[1],data1[2],data2[0],data2[1],data2[2]);
                g->add_edge(index1,index2,value,value);
            }
            if (IsinBoundary(i+1,j,width,height)==1)
            {
                index2=(i+1) * width + j;
                getImageData(image,i+1,j,data2);
                value = lambda * getSmoothnessTerm(data1[0],data1[1],data1[2],data2[0],data2[1],data2[2]);
                g->add_edge(index1,index2,value,value);
            }
            if (IsinBoundary(i+1,j+1,width,height)==1)
            {
                index2=(i+1) * width + j+1;
                getImageData(image,i+1,j+1,data2);
                value = lambda * getSmoothnessTerm(data1[0],data1[1],data1[2],data2[0],data2[1],data2[2]);
                g->add_edge(index1,index2,value,value);
            }
            if (IsinBoundary(i+1,j-1,width,height)==1)
            {
                index2=(i+1) * width + j-1;
                getImageData(image,i,j-1,data2);
                value = lambda * getSmoothnessTerm(data1[0],data1[1],data1[2],data2[0],data2[1],data2[2]);
                g->add_edge(index1,index2,value,value);
            }
        }
    }

}
void getImageData(image<rgb> * img,int i,int j,double * data){
        data[2] = imRef(img, j, i).r;
        data[1] = imRef(img, j, i).g;
        data[0] = imRef(img, j, i).b;

}
double getSmoothnessTerm(double a1, double a2, double a3, double b1, double b2, double b3){
    return getTerm(a1,a2,a3,b1,b2,b3,smoothSigma);
}

double getTerm(double a1, double a2, double a3, double b1, double b2, double b3,double sigma)
{
  double val= (pow( (a1 - b1), 2) + pow( (a2 - b2), 2) + pow( (a3 - b3), 2));
  val = (exp( (-1.0*val)/(2.0*sigma*sigma) ) ); //sigma value may need to be changed
   return val;
}

