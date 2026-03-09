// SPDX-License-Identifier: GPL-2.0-only
/* Copyright (c) 2025
 *
 * HID-BPF fix for Lenovo ThinkPad X1 Yoga Gen 10 Touchpad
 * (SNSL0028:00 2C2F:0028)
 *
 * Problem: The touchpad firmware incorrectly clears the HID Confidence
 * bit (Usage 0x47) for legitimate finger touches near the left and right
 * edges of the touchpad. The kernel's hid-multitouch driver interprets
 * confidence=0 as MT_TOOL_PALM, which causes libinput to ignore the
 * touch entirely. This results in dead zones on both edges of the
 * touchpad.
 *
 * Fix: Force the Confidence bit to 1 for all touch contacts in the
 * HID input report, so hid-multitouch always sees them as finger
 * contacts. This disables firmware-level palm rejection, but
 * libinput has its own palm detection that works correctly.
 *
 * Report ID 0x03 layout (touchpad, 5 contacts):
 *   Byte 0:    Report ID (0x03)
 *   Per contact (5 contacts, 5 bytes each):
 *     Byte 0:  [bit0=Confidence, bit1=TipSwitch, bits2-7=ContactID]
 *     Byte 1-2: X position (16-bit LE)
 *     Byte 3-4: Y position (16-bit LE)
 *   Byte 26-27: Scan Time (16-bit LE)
 *   Byte 28:    Contact Count
 *   Byte 29:    [bit0=Button, bits1-7=padding]
 */

#include "vmlinux.h"
#include "hid_bpf.h"
#include "hid_bpf_helpers.h"
#include <bpf/bpf_tracing.h>

#define VID_SYNA   0x2C2F
#define PID_TP     0x0028
#define RDESC_SIZE 499 /* expected report descriptor size */

#define REPORT_ID_TOUCHPAD 0x03
#define REPORT_SIZE        30 /* total bytes incl. report ID */
#define NUM_CONTACTS        5
#define CONTACT_SIZE        5 /* bytes per contact */
#define CONFIDENCE_BIT   0x01 /* bit 0 in the contact's first byte */

HID_BPF_CONFIG(
	HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8, VID_SYNA, PID_TP)
);

SEC("syscall")
int probe(struct hid_bpf_probe_args *ctx)
{
	/*
	 * Only attach to the touchpad interface.
	 * Check that the report descriptor starts with the expected
	 * Usage Page (Generic Desktop) + Usage (Mouse) for the first
	 * collection, which is the mouse/touchpad composite.
	 */
	ctx->retval = ctx->rdesc_size != RDESC_SIZE;
	if (ctx->retval)
		ctx->retval = -EINVAL;

	return 0;
}

SEC(HID_BPF_DEVICE_EVENT)
int BPF_PROG(x1_yoga_fix_confidence, struct hid_bpf_ctx *hctx)
{
	__u8 *data;

	if (hctx->size < REPORT_SIZE)
		return 0;

	data = hid_bpf_get_data(hctx, 0, REPORT_SIZE);
	if (!data)
		return 0;

	/* Only process touchpad reports */
	if (data[0] != REPORT_ID_TOUCHPAD)
		return 0;

	/*
	 * Force the Confidence bit (bit 0) to 1 for all 5 contact slots.
	 * Contact headers are at byte offsets 1, 6, 11, 16, 21.
	 *
	 * This ensures hid-multitouch always sees MT_TOOL_FINGER
	 * instead of MT_TOOL_PALM, even when the firmware incorrectly
	 * reports low confidence for edge touches.
	 */
	data[1]  |= CONFIDENCE_BIT;  /* Contact 0 */
	data[6]  |= CONFIDENCE_BIT;  /* Contact 1 */
	data[11] |= CONFIDENCE_BIT;  /* Contact 2 */
	data[16] |= CONFIDENCE_BIT;  /* Contact 3 */
	data[21] |= CONFIDENCE_BIT;  /* Contact 4 */

	return 0;
}

HID_BPF_OPS(x1_yoga_tp) = {
	.hid_device_event = (void *)x1_yoga_fix_confidence,
};

SEC("license")
char _license[] = "GPL";
