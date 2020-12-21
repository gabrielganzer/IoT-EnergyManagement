#include "inc/utilities.h"

int parse_args(int argc, char *argv[], char *fwl, char *res, psm_t *psm, dpm_policy_t
        *selected_policy, dpm_timeout_params *tparams, dpm_history_params
        *hparams)
{
    int cur = 1;
    while(cur < argc) {
		
        if(strcmp(argv[cur], "-help") == 0) {
            print_command_line();
            return 0;
        }

        // set policy to timeout and get timeout value
        if(strcmp(argv[cur], "-t") == 0) {
            *selected_policy = DPM_TIMEOUT;
			// modified if(argc > cur + 1) to if(argc > cur + 2)
            if(argc > cur + 2) {
				// Original To_idle
                tparams->timeout[0] = atof(argv[++cur]);
				printf("\n**************************** DPM SIMULATION ****************************\n");
				printf("Timeout to idle: %f\n", tparams->timeout[0]);
				// Extended To_sleep
                tparams->timeout[1] = atof(argv[++cur]);
				printf("Timeout to sleep: %f\n", tparams->timeout[1]);
            }
            else return	0;
        }

        // set policy to history based and get parameters and thresholds
        if(strcmp(argv[cur], "-h") == 0) {
            *selected_policy = DPM_HISTORY;
            if(argc > cur + DPM_HIST_WIND_SIZE){
                int i;
                for(i = 0; i < DPM_HIST_WIND_SIZE; i++) {
                    hparams->alpha[i] = atof(argv[++cur]);
                }
                hparams->threshold[0] = atof(argv[++cur]);
                hparams->threshold[1] = atof(argv[++cur]);
				printf("K0: %f\n", hparams->alpha[0]);
				printf("K1: %f\n", hparams->alpha[1]);
				printf("K2: %f\n", hparams->alpha[2]);
				printf("Threshold0: %f\n", hparams->threshold[0]);
				printf("Threshold1: %f\n", hparams->threshold[1]);
            } else return 0;
        }

        // set name of file for the power state machine
        if(strcmp(argv[cur], "-psm") == 0) {
            if(argc <= cur + 1 || !psm_read(psm, argv[++cur]))
                return 0;
        }

        // set name of file for the workload
        if(strcmp(argv[cur], "-wl") == 0)
        {
            if(argc > cur + 1)
            {
                strcpy(fwl, argv[++cur]);
            }
            else return	0;
        }
		
        // set name of file for storing the results
        if(strcmp(argv[cur], "-res") == 0) {
            if(argc > cur + 1)
            {
                strcpy(res, argv[++cur]);
            }
            else return	0;
        }
		
        cur ++;
    }
    return 1;
}

void print_command_line(){
	printf("\n******************************************************************************\n");
	printf(" DPM simulator: \n");
	printf("\t-t <timeout_idle> <timeout_sleep>: time to idle & sleep timeout policy\n");
	printf("\t-h <Value1> …<Value5> <Threshold1> <Threshold2>: history-based policy \n");
	printf("\t   <Value1-5> value of coefficients\n");
	printf("\t   <Threshold1-2> predicted time thresholds\n");
	printf("\t-psm <psm filename>: the power state machine file\n");
	printf("\t-wl <wl filename>: the workload file\n");
	printf("******************************************************************************\n\n");
}
