/**
 * @file utilities.h
 * @brief Utility functions for the DPM simulator
 */

#ifndef _INCLUDE_UTILITIES_H
#define _INCLUDE_UTILITIES_H

#include <stdlib.h>
#include <string.h>
#include "inc/dpm_policies.h"
#include "inc/psm.h"

/**
 * @brief Parse command line inputs and fill data structures accordingly
 *
 * @param argc: number of command line args
 * @param argv: command line args
 * @param fwl: will be filled with workload filename
 * @param psm: will be filled with power state machine data from file
 * @param selected_policy: will contain the ID of the selected policy
 * @param tparams: will contain the parameters of the timeout policy (if selected)
 * @param hparams: will contain the parameters of the history policy (if selected)
 *
 * @return 1 on success, 0 on failure
 *
 */
int parse_args(int argc, char *argv[], char *fwl, psm_t *psm, dpm_policy_t
        *selected_policy, dpm_timeout_params *tparams, dpm_history_params *hparams);

/**
 * @brief Print a message explaining command line parameters of the simulator
 *
 */
void print_command_line(void);

#endif
