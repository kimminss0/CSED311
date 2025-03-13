// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vopcodes.h for the primary calling header

#include "Vopcodes__pch.h"
#include "Vopcodes___024root.h"

VL_ATTR_COLD void Vopcodes___024root___eval_static(Vopcodes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vopcodes___024root___eval_static\n"); );
    Vopcodes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vopcodes___024root___eval_initial__TOP(Vopcodes___024root* vlSelf);

VL_ATTR_COLD void Vopcodes___024root___eval_initial(Vopcodes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vopcodes___024root___eval_initial\n"); );
    Vopcodes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vopcodes___024root___eval_initial__TOP(vlSelf);
    vlSelfRef.__Vtrigprevexpr___TOP__part_of_inst__0 
        = vlSelfRef.part_of_inst;
}

VL_ATTR_COLD void Vopcodes___024root___eval_initial__TOP(Vopcodes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vopcodes___024root___eval_initial__TOP\n"); );
    Vopcodes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.imm_gen_out = 0U;
}

VL_ATTR_COLD void Vopcodes___024root___eval_final(Vopcodes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vopcodes___024root___eval_final\n"); );
    Vopcodes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vopcodes___024root___eval_settle(Vopcodes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vopcodes___024root___eval_settle\n"); );
    Vopcodes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vopcodes___024root___dump_triggers__act(Vopcodes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vopcodes___024root___dump_triggers__act\n"); );
    Vopcodes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @( part_of_inst)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vopcodes___024root___dump_triggers__nba(Vopcodes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vopcodes___024root___dump_triggers__nba\n"); );
    Vopcodes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @( part_of_inst)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vopcodes___024root___ctor_var_reset(Vopcodes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vopcodes___024root___ctor_var_reset\n"); );
    Vopcodes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->part_of_inst = VL_RAND_RESET_I(32);
    vlSelf->imm_gen_out = VL_RAND_RESET_I(32);
    vlSelf->__Vtrigprevexpr___TOP__part_of_inst__0 = VL_RAND_RESET_I(32);
    vlSelf->__VactDidInit = 0;
}
