from pystages import Vector, CNCRouter
import time
from enum import Enum, auto

cnc = CNCRouter("/dev/ttyUSB0")

# cnc.move_to(Vector(15, -45, -3))
cnc.set_origin()

# Offset of 5 milimeters
z_offset = Vector(0, 0, 3)

waiting_time_up = 3
waiting_time_down = 0.75


class MODEL(Enum):
    IPHONE = auto
    PIXEL = auto


model = MODEL.IPHONE


x_sep = 33.5 / 2 if model == MODEL.IPHONE else 15.0
y_sep = 50 / 3 if model == MODEL.IPHONE else 15.0

up = Vector(0, y_sep, 0)
right = Vector(x_sep, 0, 0)

zero = Vector(0, 0, 0)
eight = zero + up
seven = eight - right
nine = eight + right
five = eight + up
four = five - right
six = five + right
two = five + up
one = two - right
three = two + right


def move_relative(axe, direction):
    delta = [Vector(1, 0, 0), Vector(0, 1, 0), Vector(0, 0, 0.5)][axe] * direction
    cnc.position += delta
    cnc.wait_move_finished()


def move_above(position):
    cnc.move_to(position + (0, 0, 3))


def tap(position):
    move_above(position)
    cnc.position = position
    move_above(position)


def unlock():
    tap(zero)
    cnc.move_to(zero)
    cnc.position = zero + (0, 80, 2)


def tap_loop():
    while True:
        # Go down
        cnc.position -= z_offset
        # Go up
        time.sleep(waiting_time_down)
        cnc.position += z_offset
        time.sleep(waiting_time_up)


if __name__ == "__main__":
    tap(zero)
    unlock()

    target_digit = zero

    cnc.move_to(target_digit + z_offset)
    cnc.wait_move_finished()

    tap_loop()
    """
    while True:
        # Go down
        cnc.position -= z_offset
        # Go up
        time.sleep(waiting_time_down)
        cnc.position += z_offset
        time.sleep(waiting_time_up)
    """
