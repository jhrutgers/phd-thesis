#include <stdio.h>
#include <math.h>

//#define DEBUG				// enable to add labels and vectors to the output

#ifndef FRAMES
#  define FRAMES 300		// number of output frames to generate
#endif
#define SKIP_FRAMES 1		// skip frames (but do calculate) between output
#define OBJECT_NUM	9		// number of objects
#define GRAV_CONST	0.00005	// gravity constant (universe-specific)
#define SCALE_VEC	5.0		// scale the size of the motion vectors in the output
#define DRAG		0.997	// add drag to the ether, 1.0 is no drag

struct object_t {
	int id;
	double mass,pos_x,pos_y,vec_x,vec_y;
	void print(){
		printf("\t%% %d *%f: (%f,%f) +(%f,%f)\n",id,mass,pos_x,pos_y,vec_x,vec_y);
		printf("\t\\node[planet,id %d/.try,minimum size=%f\\scalemass] (p %d) at (%f,%f) {};\n",id,mass,id,pos_x,pos_y);
#ifdef DEBUG
		printf("\t\\node[label] at (p %d) {%d};\n",id,id);
		if(vec_x!=0.0||vec_y!=0.0)
			printf("\t\\draw[vec] (p %d) -- +(%f,%f);\n",id,vec_x*(double)SKIP_FRAMES*SCALE_VEC,vec_y*(double)SKIP_FRAMES*SCALE_VEC);
#endif
	}
};

#define forall(o,f) do{for(int i_=0;i_<OBJECT_NUM;i_++){o[i_].f;}}while(0)

#define radtodeg(r) ((double)(r)/(2.0*M_PI)*360.0)
#define degtorad(r) ((double)(r)/360.0*(2.0*M_PI))
#define toxy(phi,dist) cos(degtorad(phi))*(double)(dist),sin(degtorad(phi))*(double)(dist)

int main(){
	object_t objs[OBJECT_NUM]={
		{0,50.0},
		{1,1.0, toxy(340.0,1.0), toxy(70.0, 0.05) },
		{2,2.0, toxy(20.0,1.2),  toxy(110.0,0.07) },
		{3,2.5, toxy(285.0,1.5), toxy(10.0, 0.08) },
		{4,1.5, toxy(80.0,1.3),  toxy(170.0,0.05) },
		{5,0.7, toxy(120.0,1.8), toxy(210.0,0.05) },
		{6,1.2, toxy(145.0,1.4), toxy(235.0,0.05) },
		{7,1.8, toxy(189.0,1.3), toxy(275.0,0.06) },
		{8,2.1, toxy(230.0,1.6), toxy(310.0,0.06) }
	};

	object_t objs_next[OBJECT_NUM]={};
	object_t *ob=objs,*ob_n=objs_next;

	for(int f=0;f<FRAMES;f++){
		printf("\\begin{animframe}\n");
		forall(ob,print());
		printf("\\end{animframe}\n");
		for(int i=0;i<=SKIP_FRAMES;i++){

			ob_n[0]=ob[0];
			for(int o=1;o<OBJECT_NUM;o++){
				ob_n[o]=ob[o];
				ob_n[o].pos_x+=ob[o].vec_x;
				ob_n[o].pos_y+=ob[o].vec_y;
				for(int o2=0;o2<OBJECT_NUM;o2++){
					if(o2!=o){
						// force between two bodies: F = G (m1*m2)/r^2
						double dx=ob[o2].pos_x-ob[o].pos_x;
						double dy=ob[o2].pos_y-ob[o].pos_y;
						double r = dx!=0.0||dy!=0.0?sqrt(dx*dx+dy*dy):0.0;
						double F = r!=0.0?(ob[o].mass*ob[o2].mass)/(r*r):0.0;
						ob_n[o].vec_x+=F*dx*GRAV_CONST;
						ob_n[o].vec_y+=F*dy*GRAV_CONST;
					}
				}
				ob_n[o].vec_x*=DRAG;
				ob_n[o].vec_y*=DRAG;
			}

			// swap object arrays
			object_t *ob_t=ob;
			ob=ob_n;
			ob_n=ob_t;
		}
	}
}

