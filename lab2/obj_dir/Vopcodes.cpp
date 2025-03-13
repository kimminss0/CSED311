// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vopcodes__pch.h"

//============================================================
// Constructors

Vopcodes::Vopcodes(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vopcodes__Syms(contextp(), _vcname__, this)}
    , part_of_inst{vlSymsp->TOP.part_of_inst}
    , imm_gen_out{vlSymsp->TOP.imm_gen_out}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vopcodes::Vopcodes(const char* _vcname__)
    : Vopcodes(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vopcodes::~Vopcodes() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vopcodes___024root___eval_debug_assertions(Vopcodes___024root* vlSelf);
#endif  // VL_DEBUG
void Vopcodes___024root___eval_static(Vopcodes___024root* vlSelf);
void Vopcodes___024root___eval_initial(Vopcodes___024root* vlSelf);
void Vopcodes___024root___eval_settle(Vopcodes___024root* vlSelf);
void Vopcodes___024root___eval(Vopcodes___024root* vlSelf);

void Vopcodes::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vopcodes::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vopcodes___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vopcodes___024root___eval_static(&(vlSymsp->TOP));
        Vopcodes___024root___eval_initial(&(vlSymsp->TOP));
        Vopcodes___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vopcodes___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vopcodes::eventsPending() { return false; }

uint64_t Vopcodes::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vopcodes::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vopcodes___024root___eval_final(Vopcodes___024root* vlSelf);

VL_ATTR_COLD void Vopcodes::final() {
    Vopcodes___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vopcodes::hierName() const { return vlSymsp->name(); }
const char* Vopcodes::modelName() const { return "Vopcodes"; }
unsigned Vopcodes::threads() const { return 1; }
void Vopcodes::prepareClone() const { contextp()->prepareClone(); }
void Vopcodes::atClone() const {
    contextp()->threadPoolpOnClone();
}
