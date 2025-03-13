// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vopcodes.h for the primary calling header

#ifndef VERILATED_VOPCODES___024ROOT_H_
#define VERILATED_VOPCODES___024ROOT_H_  // guard

#include "verilated.h"


class Vopcodes__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vopcodes___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ __VactDidInit;
    CData/*0:0*/ __VactContinue;
    VL_IN(part_of_inst,31,0);
    VL_OUT(imm_gen_out,31,0);
    IData/*31:0*/ __Vtrigprevexpr___TOP__part_of_inst__0;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vopcodes__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vopcodes___024root(Vopcodes__Syms* symsp, const char* v__name);
    ~Vopcodes___024root();
    VL_UNCOPYABLE(Vopcodes___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
