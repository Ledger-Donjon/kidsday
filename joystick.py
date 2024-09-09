import pygame
from press_button import tap, unlock, move_above, move_relative
from press_button import cnc
from press_button import zero, one, two, three, four, five, six, seven, eight, nine, y_sep

keypad = [
    [one, two, three],
    [four, five, six],
    [seven, eight, nine],
    [zero, zero, zero],
]
print(len(keypad), len(keypad[0]))

# Position is line, column
pos_row = 3
pos_col = 1

pygame.init()
joystick = pygame.joystick.Joystick(0)

print("Ready to go. First, move to the 0 and press any button to calibrate.")
calibrated = None


def move(axe, direction):
    if not calibrated:
        # The factor of move is from the little slider at the left of the joystick (axe 2)
        factor = (joystick.get_axis(2) - 1.0) * (y_sep / 2)
        if axe == 0:
            factor = -factor
        # Distance, according the the direction and the factor
        distance = direction * factor
        move_relative(axe, distance)
        return

    global pos_row, pos_col
    if axe == 0:
        pos_col += direction
        pos_col = max(0, min(pos_col, len(keypad[0]) - 1))
    elif axe == 1:
        pos_row += direction
        pos_row = max(0, min(pos_row, len(keypad) - 1))
    # If we are on last row (the zero line) we systematically go over the zero
    if pos_row == 3:
        pos_col = 1
    move_above(keypad[pos_row][pos_col])


def press():
    tap(keypad[pos_row][pos_col])


def swipe():
    unlock()


def process_button(e):
    global calibrated
    if not calibrated:
        calibrated = cnc.set_origin()
        print("Calibrated!")
        return

    if (e.type not in [pygame.JOYBUTTONDOWN]) or e.joy != 0 or e.button > 1:
        return

    # [press, swipe][e.button]()
    press()


def process_hat(e):
    # Ignore all HAT operation if calibration is done
    if calibrated:
        return

    # Check which axis is moved
    if e.value[0] == 0:
        # Get only vertical hits
        if e.value[1] == 0:
            return

        # The factor of move is from the little slider at the left of the joystick (axe 2)
        factor = -joystick.get_axis(2) + 1.0
        # Distance, according the the direction and the factor
        distance = e.value[1] * factor
        move_relative(2, distance)


threshold = 0.8
axes = [0.0, 0.0, 0.0]


def process_motion(e: pygame.event.Event):
    # Filter out all unwanted events
    if (e.type not in [pygame.JOYAXISMOTION]) or e.joy != 0 or e.axis > 1:
        return

    # Get the previous value of the axe for which the value is changed
    old_value = axes[e.axis]
    axes[e.axis] = e.value
    # Check if the new value passed the threshold
    if (old_value < threshold and e.value > threshold) or (
        old_value > -threshold and e.value < -threshold
    ):
        # Perform a move if so
        move(e.axis, 1 if e.value > 0 else -1)


def process_event(e: pygame.event.Event):
    if e.type == pygame.JOYAXISMOTION:
        # The Joystick is moved
        process_motion(e)
    elif e.type == pygame.JOYBUTTONDOWN:
        # A button is pressed
        process_button(e)
    elif e.type == pygame.JOYHATMOTION:
        # The hat cross is moved
        process_hat(e)


while True:
    # Get all pending events from the JOYSTICK
    while not len(events := pygame.event.get()):
        pass
    # Process them consecutively
    for event in events:
        process_event(event)
