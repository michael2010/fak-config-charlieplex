let { tap, hold, td, combo, macro, encoder, .. } = import "fak/keycode.ncl" in

let kc = tap.reg.kc in
let ks = tap.reg.ks in
let md = hold.reg.mod in
let tm = tap.reg.mod in
let sm = tap.sticky.mod in
let sl = tap.sticky.layer in
let me = tap.custom.media in
let ms = tap.custom.mouse in
let fk = tap.custom.fak in
let MO = hold.reg.layer in
let TG = tap.layer.TG in

# Valid Nickel identifiers for transparent and none
let TTTT = tap.trans & hold.trans in
let NONE = tap.none & hold.none in

# Virtual keys: 4 encoder directions + 4 combos = 8 virtual keys
let virtual_keys' = [
  encoder.ccw 0,
  encoder.cw  0,
  encoder.ccw 1,
  encoder.cw  1,
  combo.make 40 [19, 20], # J + K -> Quick Escape
  combo.make 50 [36, 37], # Key 36 + Key 37 -> Caps Word Toggle (fk.CWTG)
  combo.make 40 [6, 11],  # RHS Y (6) + \ (11) -> Bootloader (fk.BOOT) on Layer 4
  combo.make 35 [15, 16], # D + F -> Sticky Ctrl on Base Layer
] in

# Total key count = 48 physical keys + 8 virtual keys = 56[cite: 2]
let key_count = 48 + std.array.length virtual_keys' in

# Helper predicates for Bilateral Home-Row Mods
let is_lhs_alpha = fun i =>
  (i >= 0 && i <= 5) || (i >= 12 && i <= 17) || (i >= 24 && i <= 29)
in
let is_rhs_alpha = fun i =>
  (i >= 6 && i <= 11) || (i >= 18 && i <= 23) || (i >= 30 && i <= 35)
in

# Bilateral Home-Row Mod behaviors
let htb_hrm_lhs = hold.reg.behavior {
  timeout_ms = 200,
  timeout_decision = 'hold,
  quick_tap_ms = 150,
  key_interrupts = std.array.map (fun i =>
    if is_lhs_alpha i then
      { decision = 'tap, trigger_on = 'press }
    else
      { decision = 'hold, trigger_on = 'press }
  ) (std.array.range 0 key_count),
} in

let htb_hrm_rhs = hold.reg.behavior {
  timeout_ms = 200,
  timeout_decision = 'hold,
  quick_tap_ms = 150,
  key_interrupts = std.array.map (fun i =>
    if is_rhs_alpha i then
      { decision = 'tap, trigger_on = 'press }
    else
      { decision = 'hold, trigger_on = 'press }
  ) (std.array.range 0 key_count),
} in

# Fast Hold behavior for Thumbs & Extra Keys
let htb_fast = hold.reg.behavior {
  timeout_ms = 180,
  timeout_decision = 'hold,
  quick_tap_ms = 150,
  key_interrupts = std.array.replicate key_count { decision = 'hold, trigger_on = 'press },
} in

let hm_l = fun mod key => key & mod & htb_hrm_lhs in
let hm_r = fun mod key => key & mod & htb_hrm_rhs in
let lt   = fun layer key => key & MO layer & htb_fast in
let mt   = fun mod key => key & mod & htb_fast in

# Enhanced Keys 36 & 37: Tap for bracket, hold for multi-modifier chord
let key36_cs = kc.LBRC & md.lctl & md.lsft & htb_fast in
let key37_ca = kc.RBRC & md.lctl & md.lalt & htb_fast in

# Key 45: Sticky Shift on tap, continuous Shift on hold (FAK idiom)
let sh_thumb = sm.lsft & md.lsft & htb_fast in

# Common OS / CAD / Window / Browser shortcuts
let UNDO  = tm.lctl & kc.Z in
let CUT   = tm.lctl & kc.X in
let COPY  = tm.lctl & kc.C in
let PASTE = tm.lctl & kc.V in
let REDO  = tm.lctl & kc.Y in
let W_LFT = tm.lctl & kc.LEFT in
let W_RGT = tm.lctl & kc.RGHT in
let Z_IN  = tm.lctl & kc.EQL in
let Z_OUT = tm.lctl & kc.MINS in
let T_PRV = tm.lctl & kc.PGUP in
let T_NXT = tm.lctl & kc.PGDN in

# Programming Operator Macros for SYM layer
let m_tap = macro.tap in
let M_ARR   = macro.make [m_tap kc.MINS, m_tap ks.RABK] in # ->
let M_FARR  = macro.make [m_tap kc.EQL,  m_tap ks.RABK] in # =>
let M_SCOPE = macro.make [m_tap ks.COLN, m_tap ks.COLN] in # ::
let M_NEQ   = macro.make [m_tap ks.EXLM, m_tap kc.EQL]  in # !=
let M_EQ    = macro.make [m_tap kc.EQL,  m_tap kc.EQL]  in # ==
let M_LEQ   = macro.make [m_tap ks.LABK, m_tap kc.EQL]  in # <=
let M_GEQ   = macro.make [m_tap ks.RABK, m_tap kc.EQL]  in # >=
let M_SHL   = macro.make [m_tap ks.LABK, m_tap ks.LABK] in # <<
let M_SHR   = macro.make [m_tap ks.RABK, m_tap ks.RABK] in # >>

# Bottom Thumb Row Tap-Dances
let TD_CAD = td.make 190 [
  lt 3 kc.ENT, # 1x Tap = Enter | Hold = MO 3 (NUM)
  TG 3,        # 2x Tap = Lock NUM Layer for CAD
] in

let TD_NAV = td.make 190 [
  lt 1 kc.EQL, # 1x Tap = = | Hold = MO 1 (NAV)
  TG 1,        # 2x Tap = Lock NAV Layer
  M_EQ,        # 3x Tap = ==
] in

let TD_MODE = td.make 190 [
  fk.REP & md.ralt & htb_fast, # 1x Tap = Repeat | Hold = RAlt
  kc.CAPS,                     # 2x Tap = CapsLock
  TG 5,                        # 3x Tap = Game Mode Lock
] in

# Window & Desktop shortcuts for FUN layer
let A_TAB = tm.lalt & kc.TAB in
let A_F4  = tm.lalt & kc.F4 in
let D_LFT = tm.lgui & tm.lctl & kc.LEFT in
let D_RGT = tm.lgui & tm.lctl & kc.RGHT in
let W_MAX = tm.lgui & kc.UP in
let W_LCK = tm.lgui & kc.L in
let S_SNP = tm.lgui & tm.lsft & kc.S in
let T_NEW = tm.lctl & kc.T in
let T_CLS = tm.lctl & kc.W in
let T_REO = tm.lctl & tm.lsft & kc.T in
let DEV_T = tm.lctl & tm.lsft & kc.I in

{
  virtual_keys = virtual_keys',

  layers = [
    # =========================================================================
    # LAYER 0: BASE
    # =========================================================================
    [
      kc.GRV,        kc.Q,          kc.W,          kc.E,          kc.R,          kc.T,                                                       kc.Y,          kc.U,          kc.I,          kc.O,          kc.P,          kc.BSLS,
      kc.MINS,       hm_l md.lgui kc.A, hm_l md.lalt kc.S, hm_l md.lctl kc.D, hm_l md.lsft kc.F, kc.G,                                       kc.H,          hm_r md.rsft kc.J, hm_r md.rctl kc.K, hm_r md.ralt kc.L, hm_r md.rgui kc.SCLN, kc.QUOT,
      mt md.lctl kc.BSPC, kc.Z,     kc.X,          kc.C,          kc.V,          kc.B,                                                       kc.N,          kc.M,          kc.COMM,       kc.DOT,        kc.SLSH,       mt md.rctl fk.REP,
                                                   key36_cs,                                                                                                               key37_ca,
                                                   # Top Thumb Row (X x x   x x X)
                                                   lt 4 kc.ESC,   lt 1 kc.SPC,   lt 2 kc.TAB,                lt 2 kc.ENT,    lt 3 kc.BSPC,   lt 4 kc.DEL,
                                                   # Bottom Thumb Row (y y   y y)
                                                                  TD_CAD,        sh_thumb,                                   TD_NAV,         TD_MODE,

      # Virtual Keys
      ms.WH_U,       ms.WH_D,       me.VOLD,       me.VOLU,       kc.ESC,        fk.CWTG,       NONE,          sm.lctl,
    ],

    # =========================================================================
    # LAYER 1: NAV
    # =========================================================================
    [
      Z_IN,          ms.BTN1,       ms.WH_D,       ms.WH_U,       ms.BTN2,       kc.PGUP,                                                    T_PRV,         kc.HOME,       kc.PGDN,       kc.PGUP,       kc.END,        T_NXT,
      Z_OUT,         ms.LEFT,       ms.DOWN,       ms.UP,         ms.RGHT,       kc.PGDN,                                                    W_LFT,         kc.LEFT,       kc.DOWN,       kc.UP,         kc.RGHT,       W_RGT,
      TTTT,          UNDO,          CUT,           COPY,          PASTE,         REDO,                                                       kc.INS,        ms.BTN1,       ms.BTN2,       ms.BTN3,       kc.APP,        TTTT,
                                                   kc.MINS,                                                                                                                ks.PLUS,
                                                   # Top Thumb Row
                                                   TTTT,          TTTT,          TTTT,                       ms.BTN1,        ms.BTN3,        ms.BTN2,
                                                   # Bottom Thumb Row
                                                                  TTTT,          TTTT,                                       TG 1,           TTTT,

      # Virtual Keys
      Z_OUT,         Z_IN,          UNDO,          REDO,          kc.ESC,        TG 1,          NONE,          NONE,
    ],

    # =========================================================================
    # LAYER 2: SYM
    # =========================================================================
    [
      ks.TILD,       ks.LCBR,       ks.AMPR,       ks.ASTR,       ks.QUES,       ks.RCBR,                                                    M_ARR,         kc.LBRC,       kc.RBRC,       M_FARR,        M_SCOPE,       kc.BSLS,
      kc.GRV,        ks.COLN,       ks.DLR,        ks.PERC,       ks.CIRC,       ks.PLUS,                                                    kc.EQL,        hm_r md.rsft kc.MINS, hm_r md.rctl ks.LABK, hm_r md.ralt ks.RABK, hm_r md.rgui kc.SCLN, ks.DQUO,
      TTTT,          M_SHL,         ks.EXLM,       ks.AT,         ks.HASH,       ks.PIPE,                                                    M_NEQ,         M_EQ,          M_LEQ,         M_GEQ,         kc.SLSH,       TTTT,
                                                   kc.QUOT,                                                                                                                M_SHR,
                                                   # Top Thumb Row
                                                   ks.LPRN,       ks.RPRN,       ks.UNDS,                    TTTT,           TTTT,           TTTT,
                                                   # Bottom Thumb Row
                                                                  TTTT,          TTTT,                                       TTTT,           TTTT,

      # Virtual Keys
      T_PRV,         T_NXT,         kc.LEFT,       kc.RGHT,       kc.ESC,        fk.CWTG,       NONE,          NONE,
    ],

    # =========================================================================
    # LAYER 3: NUM
    # =========================================================================
    [
      kc.ESC,        ks.PLUS,       kc.N7,         kc.N8,         kc.N9,         ks.ASTR,                                                    ks.ASTR,       kc.N7,         kc.N8,         kc.N9,         kc.MINS,       kc.SLSH,
      kc.TAB,        kc.EQL,        kc.N4,         kc.N5,         kc.N6,         kc.SLSH,                                                    ks.PLUS,       hm_r md.rsft kc.N4, hm_r md.rctl kc.N5, hm_r md.ralt kc.N6, hm_r md.rgui kc.DOT, kc.EQL,
      TTTT,          kc.COMM,       kc.N1,         kc.N2,         kc.N3,         kc.BSLS,                                                    kc.N0,         kc.N1,         kc.N2,         kc.N3,         kc.COMM,       TTTT,
                                                   ks.LPRN,                                                                                                                ks.RPRN,
                                                   # Top Thumb Row
                                                   kc.DOT,        kc.N0,         kc.MINS,                    TTTT,           TTTT,           TTTT,
                                                   # Bottom Thumb Row
                                                                  kc.ENT,        TG 3,                                       kc.N0,          ks.COLN,

      # Virtual Keys
      kc.PGUP,       kc.PGDN,       kc.LEFT,       kc.RGHT,       kc.ESC,        TG 3,          NONE,          NONE,
    ],

    # =========================================================================
    # LAYER 4: FUN
    # =========================================================================
    [
      kc.PSCR,       kc.F12,        kc.F7,         kc.F8,         kc.F9,         TG 3,                                                       A_TAB,         D_LFT,         W_MAX,         D_RGT,         A_F4,          W_LCK,
      kc.SCRL,       kc.F11,        kc.F4,         kc.F5,         kc.F6,         TG 5,                                                       me.MUTE,       hm_r md.rsft me.VOLD, hm_r md.rctl me.VOLU, hm_r md.ralt me.PREV, hm_r md.rgui me.NEXT, me.PLAY,
      TTTT,          kc.F10,        kc.F1,         kc.F2,         kc.F3,         kc.PAUS,                                                    S_SNP,         T_NEW,         T_CLS,         T_REO,         DEV_T,         TTTT,
                                                   TTTT,                                                                                                                   TTTT,
                                                   # Top Thumb Row
                                                   TTTT,          TTTT,          TTTT,                       TTTT,           TTTT,           TTTT,
                                                   # Bottom Thumb Row
                                                                  TTTT,          TTTT,                                       TTTT,           TTTT,

      # Virtual Keys
      me.VOLD,       me.VOLU,       me.PREV,       me.NEXT,       kc.ESC,        TG 5,          fk.BOOT,       NONE,
    ],

    # =========================================================================
    # LAYER 5: GAME
    # =========================================================================
    [
      kc.ESC,        kc.Q,          kc.W,          kc.E,          kc.R,          kc.T,                                                       kc.Y,          kc.U,          kc.I,          kc.O,          kc.P,          TG 5,
      kc.TAB,        kc.A,          kc.S,          kc.D,          kc.F,          kc.G,                                                       kc.H,          kc.J,          kc.K,          kc.L,          kc.SCLN,       kc.QUOT,
      md.lsft,       kc.Z,          kc.X,          kc.C,          kc.V,          kc.B,                                                       kc.N,          kc.M,          kc.COMM,       kc.DOT,        kc.SLSH,       md.rsft,
                                                   kc.G,                                                                                                                   kc.M,
                                                   # Top Thumb Row
                                                   md.lctl,       kc.SPC,        md.lalt,                    kc.ENT,         kc.BSPC,        kc.DEL,
                                                   # Bottom Thumb Row
                                                                  kc.N1,         kc.N2,                                      kc.N3,          TG 5,

      # Virtual Keys
      me.VOLD,       me.VOLU,       kc.LBRC,       kc.RBRC,       kc.ESC,        TG 5,          NONE,          NONE,
    ],
  ]
}