// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VOPCODES__SYMS_H_
#define VERILATED_VOPCODES__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vopcodes.h"

// INCLUDE MODULE CLASSES
#include "Vopcodes___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES)Vopcodes__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vopcodes* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vopcodes___024root             TOP;

    // CONSTRUCTORS
    Vopcodes__Syms(VerilatedContext* contextp, const char* namep, Vopcodes* modelp);
    ~Vopcodes__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
};

#endif  // guard
