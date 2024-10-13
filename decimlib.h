#ifndef TEMP_DECIMATOR
#define TEMP_DECIMATOR
typedef struct{
  int* input; // r1
  int* out; // r2
  int n; // r3
  int sum; // r4
  int* previous; // r5
  int previous_size; //r6
  int decim_count;  // lr
}temp_decimator;
#endif
extern int decimator_nx(temp_decimator* ddd);
extern int summer_nx(temp_decimator* ddd);
extern int summer_3x(temp_decimator* ddd);
extern int summer_4x(temp_decimator* ddd);
extern int summer_5x(temp_decimator* ddd);
extern int summer_8x(temp_decimator* ddd);
extern int summer_16x(temp_decimator* ddd);
extern int summer_10x(temp_decimator* ddd);
extern int decimator_3x(temp_decimator* ddd);
extern int decimator_4x(temp_decimator* ddd);
extern int decimator_5x(temp_decimator* ddd);
extern int decimator_8x(temp_decimator* ddd);
extern int decimator_10x(temp_decimator* ddd);
extern int decimator_16x(temp_decimator* ddd);

extern int decimator_nx_bufferless(temp_decimator* ddd);
extern int decimator_3x_bufferless(temp_decimator* ddd);
extern int decimator_4x_bufferless(temp_decimator* ddd);
extern int decimator_5x_bufferless(temp_decimator* ddd);
extern int decimator_8x_bufferless(temp_decimator* ddd);
extern int decimator_10x_bufferless(temp_decimator* ddd);
extern int decimator_16x_bufferless(temp_decimator* ddd);