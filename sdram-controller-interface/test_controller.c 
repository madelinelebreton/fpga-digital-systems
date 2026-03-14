// sdram-controller-interface/test_controller.c
// tests the controller by reading and writing from Nios V processor
// Author: Madeline LeBreton

// software writes values to avalon bus -> SDRAM controller -> SDRAM chip -> reads them back

#include <stdio.h>
#include "system.h" // contains base address of 

// pointers to SDRAM so CPU accesses memory directly
volatile char *char_ptr = (char *) SDRAM_CONTROLLER_0_BASE;
volatile short *short_ptr = (short *) SDRAM_CONTROLLER_0_BASE;
volatile int *int_ptr = (int *) SDRAM_CONTROLLER_0_BASE;

int main(){
    // test 1: write characters (1 byte)
    for (int i=0; i<5; i++){
        char_ptr[i] = i; // write 0, 1, 2, 3, 4 to the memory addresses
    }

    // read and verify (1)
    for (int i=0; i<5; i++){
        if(char_ptr[i] != i){
            printf("Char test failed at %d", i);
        }
    }

    // test 2: write shorts (2 bytes)
    for (int i=0; i<5; i++){
        short_ptr[i] = i;
    }

    // read and verify (2)
    for(int i=0; i<5; i++){
        if(short_prt[i] != i){
            printf("Short test failed at %d", i);
        }
    }

    // test 3: write integers (4 bytes)
    for(int i=0; i<5; i++){
        int_ptr[i] = i;
    }

    for(int i=0; i<5; i++){
        if(int_ptr[i] != i){
            printf("Int test failed at %d", i);
        }
    }

    printf("Test complete!");

    while(1); // for embedded system, keep CPU busy in infinite loop

    return 0;
}