#include <unistd.h>
#include <stdio.h>
#include <libgen.h>
#include <string.h>
#include <sys/stat.h>
#include <grp.h>
#include <sys/types.h>


// type definitions
struct LookupItem {
	char *key;
	char *hypervisor;
	char *vm_name;
};
typedef struct LookupItem LookupItem;

// constants
const LookupItem HYPERVISOR_TABLE[] = {
	{"env01", "virt-0", "hub01"},
	{"env02", "virt-0", "hub02"},
	{"env03", "virt-1", "hub03"},
	{"env04", "virt-1", "hub04"}};
const int HYPERVISOR_TABLE_SIZE = sizeof(HYPERVISOR_TABLE) / sizeof(HYPERVISOR_TABLE[0]);
const char *TARGET_SNAPSHOT="with-storage";

// functions
void hypervisor_lkp(LookupItem* env)
{
    for (int i=0; i<HYPERVISOR_TABLE_SIZE; i++) {
        if (strcmp(env->key, HYPERVISOR_TABLE[i].key) == 0) {
	    *env = HYPERVISOR_TABLE[i];
	}
    }
}

//main routine
int main(int argc, char **argv) {
    LookupItem env;
    FILE* remf;
    char buffer[1000];
    int j;

    // get target environment information
    env.key = getgrgid((int) getegid())->gr_name;
    hypervisor_lkp(&env);

    // root up
    setuid(0);

    // create commands
    j = 0;
    j += sprintf(buffer+j, "echo 'shutting down hub vm'\n");
    j += sprintf(buffer+j, "virsh destroy --domain %s\n", env.vm_name);
    j += sprintf(buffer+j, "echo 'reverting hub vm to snapshot'\n");
    j += sprintf(buffer+j, "virsh snapshot-revert --domain %s --snapshotname %s\n",
		    env.vm_name, TARGET_SNAPSHOT);
    j += sprintf(buffer+j, "echo 'starting hub vm'\n");
    j += sprintf(buffer+j, "virsh start %s\n", env.vm_name);
    j += sprintf(buffer+j, "echo 'complete'\n");

    // reset environment
    remf = popen("ssh virt-0.lab.faros.site", "w");
    if (!remf) { perror("popen ssh failed"); return(1); };
    fprintf(remf, buffer);
    fclose(remf);

    return 0;
}
