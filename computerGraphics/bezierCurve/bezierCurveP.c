#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define GRADO 3
#define LARGHEZZA 81
#define ALTEZZA 80
#define POINT '#'
#define NCARATTERI 4
#define EPS 1e-4

#define SOGLIA_PIATTO 0.1
#define SOGLIA_MURO 1.8

double scala_dinamica = 10.0;
double offset_x = LARGHEZZA / 2.0;
double offset_y = ALTEZZA / 2.0;

char caratteriPunto[NCARATTERI] ={ '|','_','/','\\'};

typedef int Index;

typedef struct{
  double x;
  double y;
}vec2;

void stampa(char[ALTEZZA][LARGHEZZA]); // Function to print the screen to the terminal
void disegnaPunto(vec2,char[ALTEZZA][LARGHEZZA],char); // Draw a point on the screen using the given character
void inizializzaSchermo(char[ALTEZZA][LARGHEZZA]); // Initialize the screen
vec2 scalaPunto(vec2,double); // Apply the scale to a point
vec2 beizerFunction(vec2[GRADO+1],double); // Calculate the Bezier curve at time t using the control points
double distanzaPuntoPunto(vec2,vec2); // Calculate the distance between 2 points
double lunghezzaBeizer(vec2[GRADO+1]); // Calculate the length of the Bezier curve using the control points

vec2 pointDiff(vec2,vec2); // Calculate the vector produced by the difference between 2 points
vec2* calcolaSegmenti(vec2[GRADO+1]); // Calculate the control segments between the control points
char selezionaCarattere(vec2[GRADO+1],double); // Select the character to draw on the screen based on the slope of the curve at time t

int main(void){
  vec2 puntiDiControllo[GRADO+1] = {    // Control points defining the Bezier curve
    {-10.0,0.0},{-7.0,2.0},{-2.0,-2.0},{4.0,-5.0} // Prova pure coordinate enormi!
  };

  char schermo[ALTEZZA][LARGHEZZA]; 
  int npassi;
  int i;

  // Finding the max and min coordinates the curve will reach
  double minX = puntiDiControllo[0].x, maxX = puntiDiControllo[0].x;
  double minY = puntiDiControllo[0].y, maxY = puntiDiControllo[0].y;
  for (i = 1; i < GRADO+1; i++) {
      if (puntiDiControllo[i].x < minX) minX = puntiDiControllo[i].x;
      if (puntiDiControllo[i].x > maxX) maxX = puntiDiControllo[i].x;
      if (puntiDiControllo[i].y < minY) minY = puntiDiControllo[i].y;
      if (puntiDiControllo[i].y > maxY) maxY = puntiDiControllo[i].y;
  }
  
  // Calculate the length of the curve in width and height
  double rangeX = maxX - minX;
  double rangeY = maxY - minY;
  if (rangeX == 0) rangeX = 1; // Avoiding division by 0
  if (rangeY == 0) rangeY = 1;

  // Calculating dynamic scaling for the X and Y axes based on the length of the curve in that corresponding dimension (leaving a 10 character margin)
  double scalaX = (LARGHEZZA - 10.0) / rangeX;
  double scalaY = (ALTEZZA - 10.0) / rangeY;
  
  // Now we have to choose one scale factor because we don't want the curve to stretch, and we choose the minimum one because we don't want any point of the curve to be rendered off-screen
  scala_dinamica = (scalaX < scalaY) ? scalaX : scalaY;

  // To calculate the offset on the X and Y axes, we first need to find the center of the screen, then we subtract the center of the curve
  // However, there is a problem with the unit of measurement: the center of the screen is calculated in characters (e.g., 40.5 chars), while the center of the curve is calculated in math units. That's the reason we multiply
  // by the scale we calculated earlier. Thanks to it, we know the amount of characters that correspond to a math unit, so we are converting the units to characters
  offset_x = (LARGHEZZA / 2.0) - ((maxX + minX) / 2.0) * scala_dinamica;
  offset_y = (ALTEZZA / 2.0) + ((maxY + minY) / 2.0) * scala_dinamica; // We must note that in a matrix the Y-axis is flipped, which is why we add the center of the curve here
  // -------------------------------------------------------------

  // Calculating the number of steps that t has to take. We use scala_dinamica.
  npassi =(int)ceil(lunghezzaBeizer(puntiDiControllo)*scala_dinamica*3.0);
  if(npassi < 2 ) npassi = 2; // We want at least 2 steps just to draw the first and last control points
  

  inizializzaSchermo(schermo);
  for(i = 0; i < GRADO+1; i++){
    disegnaPunto(scalaPunto(puntiDiControllo[i],scala_dinamica),schermo,POINT);
  }

  for(i = 0; i <= npassi;  i++){
    double t = (double)i / npassi;
    disegnaPunto(scalaPunto(beizerFunction(puntiDiControllo,t),scala_dinamica),schermo,'#');
  }
  stampa(schermo);
  return EXIT_SUCCESS;
}

void inizializzaSchermo(char schermo[ALTEZZA][LARGHEZZA]){
  int i,j;

  for(i = 0; i < ALTEZZA; i++){
    for(j = 0; j < LARGHEZZA-1; j++){
      schermo[i][j] = ' ';
    }
    schermo[i][j] = '\n';
  }
}


vec2 scalaPunto(vec2 punto, double scala){
  double xS = punto.x * scala;
  double yS = punto.y * scala;
  vec2 p = {xS,yS};
  return p;
}

void disegnaPunto(vec2 punto, char schermo[ALTEZZA][LARGHEZZA],char carattere){
  Index xI,yI;

  xI = (int) round(punto.x + offset_x);
  yI = (int) round(offset_y - punto.y);

  if(xI >= 0 && xI < LARGHEZZA-1 && yI >= 0 && yI < ALTEZZA) {
      schermo[yI][xI] = carattere;
  }
}

void stampa(char schermo[ALTEZZA][LARGHEZZA]){
  int i,j;
  for(i = 0; i < ALTEZZA; i++){
    for(j = 0; j< LARGHEZZA; j++){
      printf("%c",schermo[i][j]);
    }
  }
}

double distanzaPuntoPunto(vec2 p0, vec2 p1){
  return sqrt(((p1.x-p0.x)*(p1.x-p0.x)) + ((p1.y-p0.y)*(p1.y-p0.y))); 

}

double lunghezzaBeizer(vec2 puntiDiControllo[GRADO+1]){
  int i;
  double dist = 0;
  for(i = 0; i < GRADO; i++){
    dist = dist + distanzaPuntoPunto(puntiDiControllo[i],puntiDiControllo[i+1]); 
  }

  return dist;
}


vec2* calcolaSegmenti(vec2 puntiDiControllo[GRADO+1]){
  vec2* segmenti = (vec2*)malloc(GRADO * sizeof(vec2));
  if (segmenti == NULL) {
    fprintf(stderr, "Errore: Memoria esaurita!\n");
    exit(EXIT_FAILURE);
  }

  int i;
  for(i = 0; i < GRADO; i++){
    segmenti[i] = pointDiff(puntiDiControllo[i],puntiDiControllo[i+1]);
  }

  return segmenti; 
}

vec2 pointDiff(vec2 p1, vec2 p2){
  double x = p2.x - p1.x;
  double y = p2.y - p1.y;
  vec2 segmento = {x,y};

  return segmento;
  
}

char selezionaCarattere(vec2 puntiDiControllo[GRADO+1],double t){
  vec2 *segmenti = calcolaSegmenti(puntiDiControllo);
  char carattereSelezionato;
  double m = 0;
  double dx = (3 * (1-t)*(1-t) * segmenti[0].x) + (6 * (1-t) * t * segmenti[1].x) + (3 * t * t * segmenti[2].x);
  double dy = (3 * (1-t)*(1-t) * segmenti[0].y) + (6 * (1-t) * t * segmenti[1].y) + (3 * t * t * segmenti[2].y);
  if (fabs(dx) < EPS){
    carattereSelezionato = caratteriPunto[0];
  }
  else{
    m = dy/dx;
    if(fabs(dy)<EPS){
      carattereSelezionato = caratteriPunto[1];
    }else{
      if(m > 0){
        if(m < SOGLIA_PIATTO) carattereSelezionato = caratteriPunto[1];
        else if(m > SOGLIA_MURO) carattereSelezionato = caratteriPunto[0];
        else carattereSelezionato = caratteriPunto[2];
      }else{
        if(m > -SOGLIA_PIATTO) carattereSelezionato = caratteriPunto[1];
        else if(m < -SOGLIA_MURO) carattereSelezionato = caratteriPunto[0];
        else carattereSelezionato = caratteriPunto[3];
      }
    }
  }
  free(segmenti);
  return carattereSelezionato;
}

vec2 beizerFunction(vec2 puntiDiControllo[GRADO+1],double t){
    vec2 puntoCalcolato;
    
    double u = 1.0 - t;
    
    double tt = t * t;
    double uu = u * u;
    double uuu = uu * u;
    double ttt = tt * t;

    puntoCalcolato.x = uuu * puntiDiControllo[0].x;
    puntoCalcolato.x += 3 * uu * t * puntiDiControllo[1].x;
    puntoCalcolato.x += 3 * u * tt * puntiDiControllo[2].x;
    puntoCalcolato.x += ttt * puntiDiControllo[3].x;               

    puntoCalcolato.y = uuu * puntiDiControllo[0].y;
    puntoCalcolato.y += 3 * uu * t * puntiDiControllo[1].y;
    puntoCalcolato.y += 3 * u * tt * puntiDiControllo[2].y;
    puntoCalcolato.y += ttt * puntiDiControllo[3].y;

    return puntoCalcolato;
}
