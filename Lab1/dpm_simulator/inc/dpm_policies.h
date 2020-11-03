/**
 * @file dpm_policies.h
 * @brief Functions related to dynamic power management policies
 */

#ifndef _INCLUDE_DPM_POLICIES_H
#define _INCLUDE_DPM_POLICIES_H

#include "inc/psm.h"

/**
 * @defgroup dpm_params Parameters of DPM policies
 * @{
 */
/** number of timeouts for timeout-based policies */
#define DPM_N_TIMEOUTS 2
/** history window size for history-based policies */
#define DPM_HIST_WIND_SIZE 5
/** number of thresholds for history-based policies */
#define DPM_N_THRESHOLDS 2
/** @} */

/**
 * @defgroup dpm_policy_ids DPM policy identifiers
 * @{
 */
/** timeout-based policy */
#define DPM_TIMEOUT 0
/** history-based policy */
#define DPM_HISTORY 1
/** @} */

/** Type alias for DPM policy IDs */
typedef int dpm_policy_t;

/**
 * @brief Container for timeout policy parameters (can store more than 1 timeout)
 */
typedef struct {
    double timeout[DPM_N_TIMEOUTS]; /**< array of timeouts */
} dpm_timeout_params;

/**
 * @brief Container for history policy parameters
 *
 */
typedef struct {
    double alpha[DPM_HIST_WIND_SIZE]; /**< regression model coefficients */
    double threshold[DPM_N_THRESHOLDS]; /**< thresholds on the predicted time that trigger a state transition */
} dpm_history_params;

/**
 * @brief Run the DPM simulation loop on a workload file
 *
 * @param psm: the input psm specification
 * @param sel_policy: the selected policy type
 * @param tparams: the timeout policy parameters (if selected)
 * @param hparams: the history policy parameters (if selected)
 * @param fwl: the worload filename
 *
 * @return 1 on success, 0 on failure
 *
 */
int dpm_simulate(psm_t psm, dpm_policy_t sel_policy, dpm_timeout_params
        tparams, dpm_history_params hparams, char* fwl);

/**
 * @brief Decide the next PSM state according to a given DPM policy
 *
 * @param next_state: will be filled with the selected next state
 * @param curr_time: the current time instant
 * @param idle_period: the next idle period in the simulation
 * @param history: the history of previous idle intervals durations (used for
 * history policies)
 * @param policy: the ID of the selected DPM policy @param tparams: the
 * parameters of the timeout policy (if selected) @param hparams: the
 * parameters of the history policy (if selected)
 *
 * @return 1 on success, 0 on failure
 *
 */
int dpm_decide_state(psm_state_t *next_state, psm_time_t curr_time,
        psm_interval_t idle_period, psm_time_t *history, dpm_policy_t policy,
        dpm_timeout_params tparams, dpm_history_params hparams);

/**
 * @brief Initialize the history of previous idle times at the beginning of a simulation
 *
 * @param h: the array containing the history of idle intervals
 *
 */
void dpm_init_history(psm_time_t *h);

/**
 * @brief Update the history of previous idle times
 *
 * @param h: the array containing the history of idle intervals
 * @param new_idle: the new idle interval to be inserted
 *
 */
void dpm_update_history(psm_time_t *h, psm_time_t new_idle);

#endif
