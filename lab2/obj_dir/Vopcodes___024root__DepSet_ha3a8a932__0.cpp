// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vopcodes.h for the primary calling header

#include "Vopcodes__pch.h"
#include "Vopcodes___024root.h"

void Vopcodes___024root___eval_act(Vopcodes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vopcodes___024root___eval_act\n"); );
    Vopcodes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

void Vopcodes___024root___nba_sequent__TOP__0(Vopcodes___024root* vlSelf);

void Vopcodes___024root___eval_nba(Vopcodes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vopcodes___024root___eval_nba\n"); );
    Vopcodes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vopcodes___024root___nba_sequent__TOP__0(vlSelf);
    }
}

VL_INLINE_OPT void Vopcodes___024root___nba_sequent__TOP__0(Vopcodes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vopcodes___024root___nba_sequent__TOP__0\n"); );
    Vopcodes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((0x40U & vlSelfRef.part_of_inst)) {
        if ((0x20U & vlSelfRef.part_of_inst)) {
            if ((0x10U & vlSelfRef.part_of_inst)) {
                vlSelfRef.imm_gen_out = 0U;
            } else if ((8U & vlSelfRef.part_of_inst)) {
                if ((4U & vlSelfRef.part_of_inst)) {
                    if ((2U & vlSelfRef.part_of_inst)) {
                        if ((1U & vlSelfRef.part_of_inst)) {
                            vlSelfRef.imm_gen_out = 
                                ((0xfff00001U & vlSelfRef.imm_gen_out) 
                                 | ((0xff000U & (vlSelfRef.part_of_inst 
                                                 >> 1U)) 
                                    | ((0x800U & (vlSelfRef.part_of_inst 
                                                  >> 0xaU)) 
                                       | (0x3feU & 
                                          (vlSelfRef.part_of_inst 
                                           >> 0x15U)))));
                            vlSelfRef.imm_gen_out = 
                                ((0xffefffffU & vlSelfRef.imm_gen_out) 
                                 | (0x100000U & (vlSelfRef.part_of_inst 
                                                 >> 0xbU)));
                            vlSelfRef.imm_gen_out = 
                                ((0x1fffffU & vlSelfRef.imm_gen_out) 
                                 | (((0x100000U & vlSelfRef.imm_gen_out)
                                      ? 0x7ffU : 0U) 
                                    << 0x15U));
                        } else {
                            vlSelfRef.imm_gen_out = 0U;
                        }
                    } else {
                        vlSelfRef.imm_gen_out = 0U;
                    }
                } else {
                    vlSelfRef.imm_gen_out = 0U;
                }
            } else if ((4U & vlSelfRef.part_of_inst)) {
                if ((2U & vlSelfRef.part_of_inst)) {
                    if ((1U & vlSelfRef.part_of_inst)) {
                        vlSelfRef.imm_gen_out = ((0xfffff000U 
                                                  & vlSelfRef.imm_gen_out) 
                                                 | (vlSelfRef.part_of_inst 
                                                    >> 0x14U));
                        vlSelfRef.imm_gen_out = ((0xfffU 
                                                  & vlSelfRef.imm_gen_out) 
                                                 | (((0x800U 
                                                      & vlSelfRef.imm_gen_out)
                                                      ? 0xfffffU
                                                      : 0U) 
                                                    << 0xcU));
                    } else {
                        vlSelfRef.imm_gen_out = 0U;
                    }
                } else {
                    vlSelfRef.imm_gen_out = 0U;
                }
            } else if ((2U & vlSelfRef.part_of_inst)) {
                if ((1U & vlSelfRef.part_of_inst)) {
                    vlSelfRef.imm_gen_out = ((0xfffff001U 
                                              & vlSelfRef.imm_gen_out) 
                                             | ((0x800U 
                                                 & (vlSelfRef.part_of_inst 
                                                    << 3U)) 
                                                | ((0x7e0U 
                                                    & (vlSelfRef.part_of_inst 
                                                       >> 0x15U)) 
                                                   | (0x1eU 
                                                      & (vlSelfRef.part_of_inst 
                                                         >> 8U)))));
                    vlSelfRef.imm_gen_out = ((0xffffefffU 
                                              & vlSelfRef.imm_gen_out) 
                                             | (0x1000U 
                                                & (vlSelfRef.part_of_inst 
                                                   >> 0x13U)));
                    vlSelfRef.imm_gen_out = ((0x1fffU 
                                              & vlSelfRef.imm_gen_out) 
                                             | (((0x1000U 
                                                  & vlSelfRef.imm_gen_out)
                                                  ? 0x7ffffU
                                                  : 0U) 
                                                << 0xdU));
                } else {
                    vlSelfRef.imm_gen_out = 0U;
                }
            } else {
                vlSelfRef.imm_gen_out = 0U;
            }
        } else {
            vlSelfRef.imm_gen_out = 0U;
        }
    } else if ((0x20U & vlSelfRef.part_of_inst)) {
        if ((0x10U & vlSelfRef.part_of_inst)) {
            vlSelfRef.imm_gen_out = 0U;
        } else if ((8U & vlSelfRef.part_of_inst)) {
            vlSelfRef.imm_gen_out = 0U;
        } else if ((4U & vlSelfRef.part_of_inst)) {
            vlSelfRef.imm_gen_out = 0U;
        } else if ((2U & vlSelfRef.part_of_inst)) {
            if ((1U & vlSelfRef.part_of_inst)) {
                vlSelfRef.imm_gen_out = ((0xfffff000U 
                                          & vlSelfRef.imm_gen_out) 
                                         | ((0xfe0U 
                                             & (vlSelfRef.part_of_inst 
                                                >> 0x14U)) 
                                            | (0x1fU 
                                               & (vlSelfRef.part_of_inst 
                                                  >> 7U))));
                vlSelfRef.imm_gen_out = ((0xfffU & vlSelfRef.imm_gen_out) 
                                         | (((0x800U 
                                              & vlSelfRef.imm_gen_out)
                                              ? 0xfffffU
                                              : 0U) 
                                            << 0xcU));
            } else {
                vlSelfRef.imm_gen_out = 0U;
            }
        } else {
            vlSelfRef.imm_gen_out = 0U;
        }
    } else if ((8U & vlSelfRef.part_of_inst)) {
        vlSelfRef.imm_gen_out = 0U;
    } else if ((4U & vlSelfRef.part_of_inst)) {
        vlSelfRef.imm_gen_out = 0U;
    } else if ((2U & vlSelfRef.part_of_inst)) {
        if ((1U & vlSelfRef.part_of_inst)) {
            vlSelfRef.imm_gen_out = ((0xfffff000U & vlSelfRef.imm_gen_out) 
                                     | (vlSelfRef.part_of_inst 
                                        >> 0x14U));
            vlSelfRef.imm_gen_out = ((0xfffU & vlSelfRef.imm_gen_out) 
                                     | (((0x800U & vlSelfRef.imm_gen_out)
                                          ? 0xfffffU
                                          : 0U) << 0xcU));
        } else {
            vlSelfRef.imm_gen_out = 0U;
        }
    } else {
        vlSelfRef.imm_gen_out = 0U;
    }
}

void Vopcodes___024root___eval_triggers__act(Vopcodes___024root* vlSelf);

bool Vopcodes___024root___eval_phase__act(Vopcodes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vopcodes___024root___eval_phase__act\n"); );
    Vopcodes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    VlTriggerVec<1> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vopcodes___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelfRef.__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelfRef.__VactTriggered, vlSelfRef.__VnbaTriggered);
        vlSelfRef.__VnbaTriggered.thisOr(vlSelfRef.__VactTriggered);
        Vopcodes___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vopcodes___024root___eval_phase__nba(Vopcodes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vopcodes___024root___eval_phase__nba\n"); );
    Vopcodes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelfRef.__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vopcodes___024root___eval_nba(vlSelf);
        vlSelfRef.__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vopcodes___024root___dump_triggers__nba(Vopcodes___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vopcodes___024root___dump_triggers__act(Vopcodes___024root* vlSelf);
#endif  // VL_DEBUG

void Vopcodes___024root___eval(Vopcodes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vopcodes___024root___eval\n"); );
    Vopcodes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY(((0x64U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vopcodes___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("immediate_generator.v", 1, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelfRef.__VactIterCount = 0U;
        vlSelfRef.__VactContinue = 1U;
        while (vlSelfRef.__VactContinue) {
            if (VL_UNLIKELY(((0x64U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                Vopcodes___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("immediate_generator.v", 1, "", "Active region did not converge.");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactContinue = 0U;
            if (Vopcodes___024root___eval_phase__act(vlSelf)) {
                vlSelfRef.__VactContinue = 1U;
            }
        }
        if (Vopcodes___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vopcodes___024root___eval_debug_assertions(Vopcodes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vopcodes___024root___eval_debug_assertions\n"); );
    Vopcodes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}
#endif  // VL_DEBUG
