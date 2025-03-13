// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vopcodes.h for the primary calling header

#include "Vopcodes__pch.h"
#include "Vopcodes__Syms.h"
#include "Vopcodes___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vopcodes___024root___dump_triggers__act(Vopcodes___024root* vlSelf);
#endif  // VL_DEBUG

void Vopcodes___024root___eval_triggers__act(Vopcodes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vopcodes___024root___eval_triggers__act\n"); );
    Vopcodes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered.set(0U, (vlSelfRef.part_of_inst 
                                       != vlSelfRef.__Vtrigprevexpr___TOP__part_of_inst__0));
    vlSelfRef.__Vtrigprevexpr___TOP__part_of_inst__0 
        = vlSelfRef.part_of_inst;
    if (VL_UNLIKELY(((1U & (~ (IData)(vlSelfRef.__VactDidInit)))))) {
        vlSelfRef.__VactDidInit = 1U;
        vlSelfRef.__VactTriggered.set(0U, 1U);
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vopcodes___024root___dump_triggers__act(vlSelf);
    }
#endif
}
