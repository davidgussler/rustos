// Generated by PeakRDL-cheader - A free and open-source header generator
//  https://github.com/SystemRDL/PeakRDL-cheader

#ifndef EXAMP_REGS_H
#define EXAMP_REGS_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <assert.h>

// Reg - common_regfile::scratchpad
#define COMMON_REGFILE__SCRATCHPAD__SCRATCHPAD_bm 0xffffffff
#define COMMON_REGFILE__SCRATCHPAD__SCRATCHPAD_bp 0
#define COMMON_REGFILE__SCRATCHPAD__SCRATCHPAD_bw 32
#define COMMON_REGFILE__SCRATCHPAD__SCRATCHPAD_reset 0x12345678

// Reg - common_regfile::id
#define COMMON_REGFILE__ID__ID_bm 0xffffffff
#define COMMON_REGFILE__ID__ID_bp 0
#define COMMON_REGFILE__ID__ID_bw 32

// Reg - common_regfile::version
#define COMMON_REGFILE__VERSION__PATCH_bm 0xff
#define COMMON_REGFILE__VERSION__PATCH_bp 0
#define COMMON_REGFILE__VERSION__PATCH_bw 8
#define COMMON_REGFILE__VERSION__MINOR_bm 0xff00
#define COMMON_REGFILE__VERSION__MINOR_bp 8
#define COMMON_REGFILE__VERSION__MINOR_bw 8
#define COMMON_REGFILE__VERSION__MAJOR_bm 0xff0000
#define COMMON_REGFILE__VERSION__MAJOR_bp 16
#define COMMON_REGFILE__VERSION__MAJOR_bw 8

// Reg - common_regfile::git
#define COMMON_REGFILE__GIT__GIT_bm 0xffffffff
#define COMMON_REGFILE__GIT__GIT_bp 0
#define COMMON_REGFILE__GIT__GIT_bw 32

// Regfile - common_regfile
typedef struct __attribute__ ((__packed__)) {
    uint32_t scratchpad;
    uint32_t id;
    uint32_t version;
    uint32_t git;
} common_regfile_t;

// Reg - examp_regs::control
#define EXAMP_REGS__CONTROL__CTL0_bm 0x1
#define EXAMP_REGS__CONTROL__CTL0_bp 0
#define EXAMP_REGS__CONTROL__CTL0_bw 1
#define EXAMP_REGS__CONTROL__CTL0_reset 0x1
#define EXAMP_REGS__CONTROL__CTL1_bm 0x2
#define EXAMP_REGS__CONTROL__CTL1_bp 1
#define EXAMP_REGS__CONTROL__CTL1_bw 1
#define EXAMP_REGS__CONTROL__CTL1_reset 0x1

// Reg - examp_regs::status
#define EXAMP_REGS__STATUS__STS0_bm 0x1
#define EXAMP_REGS__STATUS__STS0_bp 0
#define EXAMP_REGS__STATUS__STS0_bw 1
#define EXAMP_REGS__STATUS__STS1_bm 0x2
#define EXAMP_REGS__STATUS__STS1_bp 1
#define EXAMP_REGS__STATUS__STS1_bw 1

// Reg - examp_regs::hwrw
#define EXAMP_REGS__HWRW__DATA_bm 0xffffffff
#define EXAMP_REGS__HWRW__DATA_bp 0
#define EXAMP_REGS__HWRW__DATA_bw 32
#define EXAMP_REGS__HWRW__DATA_reset 0xa

// Reg - examp_regs::wr_pulse
#define EXAMP_REGS__WR_PULSE__DATA_bm 0x1
#define EXAMP_REGS__WR_PULSE__DATA_bp 0
#define EXAMP_REGS__WR_PULSE__DATA_bw 1
#define EXAMP_REGS__WR_PULSE__DATA_reset 0x0

// Reg - examp_regs::cntr
#define EXAMP_REGS__CNTR__CNT_bm 0xffff
#define EXAMP_REGS__CNTR__CNT_bp 0
#define EXAMP_REGS__CNTR__CNT_bw 16
#define EXAMP_REGS__CNTR__CNT_reset 0x0

// Addrmap - examp_regs
typedef struct __attribute__ ((__packed__)) {
    common_regfile_t common;
    uint32_t control;
    uint32_t status;
    uint32_t hwrw;
    uint32_t wr_pulse[2];
    uint32_t cntr[2];
} examp_regs_t;


static_assert(sizeof(examp_regs_t) == 0x2c, "Packing error");

#ifdef __cplusplus
}
#endif

#endif /* EXAMP_REGS_H */
