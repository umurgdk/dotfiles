# HID-BPF Fix: Lenovo X1 Yoga Gen 10 Touchpad Edge Dead Zones

## Problem

The touchpad (SNSL0028:00 2C2F:0028) firmware incorrectly reports
the HID Confidence bit as 0 (= palm) for finger touches near the
left and right edges. The kernel's hid-multitouch driver translates
this into `ABS_MT_TOOL_TYPE = MT_TOOL_PALM`, and libinput ignores
the touch completely, creating dead zones on both sides.

## Fix

The BPF program intercepts HID input reports (Report ID 0x03)
and forces the Confidence bit to 1 for all 5 contact slots before
hid-multitouch processes them. This means every touch is treated
as a finger, and libinput's own palm detection takes over instead
of the broken firmware-level detection.

## How to use

### Option 1: Using udev-hid-bpf (Recommended)

1. Clone and set up udev-hid-bpf:

```bash
git clone https://gitlab.freedesktop.org/libevdev/udev-hid-bpf.git
cd udev-hid-bpf
```

2. Copy the .bpf.c file into `src/bpf/testing/` (new quirks go here):

```bash
cp /path/to/0018-2C2F-0028-fix-confidence.bpf.c \
   src/bpf/testing/
```

3. Register the file in meson so it gets compiled. Edit
   `src/bpf/testing/meson.build` and add the filename to the
   existing list of BPF sources:

```meson
# Add this line alongside the other .bpf.c entries:
'0018-2C2F-0028-fix-confidence.bpf.c',
```

4. Build (or reconfigure if you already had a builddir):

```bash
meson setup builddir
meson compile -C builddir
```

5. Test it live (auto-detects your touchpad by VID:PID from
   the HID_BPF_CONFIG macro):

```bash
sudo ./builddir/udev-hid-bpf add - \
   builddir/src/bpf/0018-2C2F-0028-fix-confidence.bpf.o
```

6. Test your touchpad edges — they should now move the pointer.
   If it works, install permanently:

```bash
sudo ./builddir/udev-hid-bpf install \
   builddir/src/bpf/0018-2C2F-0028-fix-confidence.bpf.o
```

This creates a udev rule + hwdb entry so the fix loads
automatically on every boot/plug.

7. To remove:

```bash
sudo udev-hid-bpf remove \
   builddir/src/bpf/0018-2C2F-0028-fix-confidence.bpf.o
```

### Option 2: Using the kernel's in-tree build system

If you want to upstream this, place the file in
`drivers/hid/bpf/progs/` in the kernel tree and follow
the kernel's HID-BPF contribution guidelines.

## Prerequisites

- Linux kernel >= 6.3 (for HID-BPF support)
- `CONFIG_HID_BPF=y` in your kernel config
- Fedora 43 (your current setup) should have this enabled

## Verifying the fix is loaded

```bash
# Check if the BPF program is loaded
sudo bpftool prog list | grep x1_yoga

# Check libinput debug output
sudo libinput debug-events
# Touch the edges - you should now see pointer motion events

# Verify via evdev that confidence is now always 1
# (ABS_MT_TOOL_TYPE should be 0 = finger, never 2 = palm)
sudo libinput record /dev/input/event6
```

## Notes

- This disables the firmware's palm rejection, but libinput has
  its own palm detection algorithm that works based on touch size
  and position, so you should still get reasonable palm rejection.
- If the report descriptor size changes with a firmware update,
  the probe() function will reject the program (safety check).
  Update RDESC_SIZE in the source if needed.
- The BPF program modifies the HID report before hid-multitouch
  sees it, so it's as if the firmware never had the bug.