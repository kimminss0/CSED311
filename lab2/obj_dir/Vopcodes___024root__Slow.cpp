// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vopcodes.h for the primary calling header

#include "Vopcodes__pch.h"
#include "Vopcodes__Syms.h"
#include "Vopcodes___024root.h"

void Vopcodes___024root___ctor_var_reset(Vopcodes___024root* vlSelf);

Vopcodes___024root::Vopcodes___024root(Vopcodes__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vopcodes___024root___ctor_var_reset(this);
}

void Vopcodes___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vopcodes___024root::~Vopcodes___024root() {
}
