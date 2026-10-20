# rgoulter's keyboard labs' CH552-36 keyboard.
#
# A Split 3x5+3 keyboard, with a PCB smaller than 100x100mm.

let { RowToColKey, ColToRowKey, PeripheralSideKey, PhysicalEncoder, .. } = import "fak/keyboard.ncl" in
let { CH552T, .. } = import "fak/mcus.ncl" in

let MatrixKey = ColToRowKey in

# RHS / all in one
let side_central = {
  mcu = CH552T,
  encoders = [
    PhysicalEncoder 34 35 4,
    PhysicalEncoder 12 13 4
  ],
  matrix = {
    cols = [32, 14, 15, 16, 17],
    rows = [10, 11, 31, 30, 33]
  },
  #split.channel = CH552T.features.uart_12_13,
} in

# LHS
let side_periph = {
  mcu = CH552T,
  matrix = {
    cols = [32, 14, 15, 16, 17],
    rows = [10, 11, 31, 30, 33]
  },
  split.channel = CH552T.features.uart_12_13,
  keys =
    let M = MatrixKey in
    [
      M 0 4, M 0 3, M 0 2, M 0 1, M 0 0, M 3 0,
      M 1 4, M 1 3, M 1 2, M 1 1, M 1 0, M 3 1,
      M 2 4, M 2 3, M 2 2, M 2 1, M 2 0, M 3 2,
                                         M 3 3, 
                                         M 4 1, M 4 3, 
                                         M 4 0, M 4 2, M 4 4
    ],
    # [
    #   X 0 4, X 1 4, X 2 4, X 3 4, X 4 4, X 4 1,
    #   X 0 3, X 1 3, X 2 3, X 3 3, X 4 3, X 3 1,
    #   X 0 2, X 1 2, X 2 2, X 3 2, X 4 2, X 2 1,
    #                                      X 1 1, 
    #                                      X 3 0, X 1 0, 
    #                                      X 4 0, X 2 0, X 0 0
    # ]
} in

side_central & {
  usb_dev = {
    vendor_id = 65261, # 0xFEED
    product_id = 8,
    product_ver = 256, # 0x0100
  },
  #split.peripheral = side_periph,
  keys =
    let M = MatrixKey in
    let X = RowToColKey in
    let S = PeripheralSideKey in
    # single mcu setup, so the keys are defined in the central side.
    [
      X 0 4, X 1 4, X 2 4, X 3 4, X 4 4, X 4 1,                               M 3 0, M 0 0, M 0 1, M 0 2, M 0 3, M 0 4,
      X 0 3, X 1 3, X 2 3, X 3 3, X 4 3, X 3 1,                               M 3 1, M 1 0, M 1 1, M 1 2, M 1 3, M 1 4,
      X 0 2, X 1 2, X 2 2, X 3 2, X 4 2, X 2 1,                               M 3 2, M 2 0, M 2 1, M 2 2, M 2 3, M 2 4,
#                           X 0 1,                                                           M 3 4,
                           X 0 0,                                                           M 4 4,
                                  X 1 0, X 3 0, X 1 1,                 M 3 3, M 4 1, M 4 3, 
                                         X 2 0, X 4 0,                 M 4 0, M 4 2
    ]
    # [
    #   X 0 4, X 1 4, X 2 4, X 3 4, X 4 4, X 4 1,                               M 3 0, M 0 0, M 0 1, M 0 2, M 0 3, M 0 4,
    #   X 0 3, X 1 3, X 2 3, X 3 3, X 4 3, X 3 1,                               M 3 1, M 1 0, M 1 1, M 1 2, M 1 3, M 1 4,
    #   X 0 2, X 1 2, X 2 2, X 3 2, X 4 2, X 2 1,                               M 3 2, M 2 0, M 2 1, M 2 2, M 2 3, M 2 4,
    #                                      X 1 1,                               M 3 3, 
    #                                      X 3 0, X 1 0,                 M 4 3, M 4 1, 
    #                                      X 4 0, X 2 0, X 0 0,   M 4 4, M 4 2, M 4 0,
    # ]

    # double mcu setup, so the keys are defined in the peripheral side, and the central side is just a passthrough.
    # [
    #   S 0,  S 1,  S 2,  S 3,  S 4,  S 5,                                M 3 0, M 0 0, M 0 1, M 0 2, M 0 3, M 0 4,
    #   S 6,  S 7,  S 8,  S 9,  S 10, S 11,                               M 3 1, M 1 0, M 1 1, M 1 2, M 1 3, M 1 4,
    #   S 12, S 13, S 14, S 15, S 16, S 17,                               M 3 2, M 2 0, M 2 1, M 2 2, M 2 3, M 2 4,
    #                                 S 18,                               M 3 3, 
    #                                 S 19, S 20,                  M 4 3, M 4 1, 
    #                                 S 21, S 22, S 23,     M 4 4, M 4 2, M 4 0
    # ]
}
