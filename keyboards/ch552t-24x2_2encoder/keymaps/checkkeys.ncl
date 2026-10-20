# A trivial layout for 3x6+6 keys
# used to check the keyswitches have all been soldered directly.
#
# Additionally, the bootloader can be entered by tapping the two leftmost corner keys.

let { combo, tap, encoder, .. } = import "fak/keycode.ncl" in

# Prelude aliases
let kc = tap.reg.kc in

let rhs_corner_indices = [6, 11] in

# Keymap definition
{
  virtual_keys = [
    # four corners
    combo.make 255 rhs_corner_indices,
    encoder.ccw 1,
    encoder.cw 1
  ],
  layers = [
    [
      kc.TAB, kc.Q,  kc.W,  kc.E,  kc.R,  kc.T,                    kc.Y,  kc.U,  kc.I,    kc.O,   kc.P,    kc.BSPC,
      kc.SPC, kc.A,  kc.S,  kc.D,  kc.F,  kc.G,                    kc.H,  kc.J,  kc.K,    kc.L,   kc.SCLN, kc.ENT,
      kc.ESC, kc.Z,  kc.X,  kc.C,  kc.V,  kc.B,                    kc.N,  kc.M,  kc.COMM, kc.DOT, kc.SLSH, kc.DEL,
                                          kc.SPC,                  kc.ENT,
                                   kc.N7, kc.N8,            kc.N9, kc.N0,
                            kc.N1, kc.N2, kc.N3,     kc.N4, kc.N5, kc.N6,

      # combo key: four corners to enter bootloader
      tap.custom.fak.BOOT,
      kc.LEFT, kc.RIGHT,
    ],
  ]
}
