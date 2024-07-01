/* Main generated for Simulink Real-Time model Homing */
#include <ModelInfo.hpp>
#include <utilities.hpp>
#include "Homing.h"
#include "rte_Homing_parameters.h"

/* Task wrapper function definitions */
void Homing_Task1(void)
{ 
    Homing_step();
} 
/* Task descriptors */
slrealtime::TaskInfo task_1( 0u, std::bind(Homing_Task1), slrealtime::TaskInfo::PERIODIC, 0.001, 0, 40);

/* Executable base address for XCP */
#ifdef __linux__
extern char __executable_start;
static uintptr_t const base_address = reinterpret_cast<uintptr_t>(&__executable_start);
#else
/* Set 0 as placeholder, to be parsed later from /proc filesystem */
static uintptr_t const base_address = 0;
#endif

/* Model descriptor */
slrealtime::ModelInfo Homing_Info =
{
    "Homing",
    Homing_initialize,
    Homing_terminate,
    []()->char const*& { return Homing_M->errorStatus; },
    []()->unsigned char& { return Homing_M->Timing.stopRequestedFlag; },
    { task_1 },
    slrealtime::getSegmentVector()
};

int main(int argc, char *argv[]) {
    slrealtime::BaseAddress::set(base_address);
    return slrealtime::runModel(argc, argv, Homing_Info);
}
