
/*
 * Include Files
 *
 */
#if defined(MATLAB_MEX_FILE)
#include "tmwtypes.h"
#include "simstruc_types.h"
#else
#define SIMPLIFIED_RTWTYPES_COMPATIBILITY
#include "rtwtypes.h"
#undef SIMPLIFIED_RTWTYPES_COMPATIBILITY
#endif



/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <math.h>
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 24
#define u_1_width 16
#define u_2_width 1000
#define y_width 1
#define y_1_width 3
#define y_2_width 3
#define y_3_width 3
#define y_4_width 1
#define y_5_width 1
#define y_6_width 16
#define y_7_width 1000

/*
 * Create external references here.  
 *
 */
/* %%%-SFUNWIZ_wrapper_externs_Changes_BEGIN --- EDIT HERE TO _END */
 
/* %%%-SFUNWIZ_wrapper_externs_Changes_END --- EDIT HERE TO _BEGIN */

/*
 * Output function
 *
 */
void IMUParser_Outputs_wrapper(const uint8_T *u0,
			const real_T *mem,
			const uint8_T *buffin,
			real_T *samp,
			real_T *theta,
			real_T *omega,
			real_T *acc,
			real_T *IMUtemp,
			uint8_T *RcvAck,
			real_T *memout,
			uint8_T *buffer)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
#define BUF_SIZE 100
#define XS_PREAMBLE 0xFA
#define XS_BID 0xFF
#define XS_MID_MTDATA2 0x36
#define XS_PREAMBLE_NOT_FOUND -1
#define XS_HEADER_END_OFFSET 3
#define XS_HDR_CS_BYTES 4
#define XS_BID_OFFSET 1
#define XS_MID_OFFSET 2
#define XS_LEN_OFFSET 3
#define XS_DATA_OFFSET 4
#define MTDATA2_DATAID 0
#define MTDATA2_DATALEN 1
#define MTDATA2_DATA 2
#define MTDATA2_MAXLEN 16
#define XS_DATAID_QUATERNION 0x2010
#define XS_DATAID_EULAR 0x2030
#define XS_DATAID_OMEGA 0x8020
#define XS_DATAID_ACCELERATION 0x4020
#define XS_DATAID_SAMPLENUM 0x1020
#define XS_DATAID_TIMESTAMP 0x1060
#define XS_DATAID_TEMPERATURE 0x0810

//***********declare variables/types***************************************
//SLRT seems to fail to compile when new variables are declared after some
//have already been assigned values
typedef unsigned char byte_T;

//all data is received as a byte array, this can convert data that should
//be interpreted as uint32
union ByteArrayUInt32
{ byte_T bytes[4];
  uint32_T val;
} ST;

//all data is received as a byte array, this can convert data that should
//be interpreted as uint16
union ByteArrayUInt16
{ byte_T bytes[2];
  uint16_T val;
} SN,mtd2_DID;

//all data is received as a byte array, this can convert data that should
//be interpreted as float
union ByteArrayFloat
{ byte_T bytes[4];
  float val;
} accX,accY,accZ,thX,thY,thZ,wX,wY,wZ,temperature,q0,q1,q2,q3;


int frontptr; //this points to the next index of the buffer for new data assignment
int rearptr; //this points to the oldest index of the buffer which has not been processed
int preptr; //if >0, this points to a potential message preamble
int lastRcvRqst; //previous state of a Receive Request bit of the EL6002
uint8_T lastRcvAck; //previous state of our Receive Acknowledge bit
byte_T MID; //Message ID of Xbus packet
byte_T LEN; //Length of Xbus packet data

int newdatalength; //amount of new data in the RS232 packet
byte_T RcvRqst; //current state of a Receive Request bit of the EL6002
bool newdata; //true when new data is present
       
uint8_T pktsum; //sum of the Xbus packet should equal the preamble
int mtd2_currentbytetype; //indicates whether the current byte in the message is an id, length, or data
int mtd2_DID_count; //count of dataids
int mtd2_Len; //length of data for the current data id
int mtd2_databuf[MTDATA2_MAXLEN]; //a small buffer to store the current submessage data
        
int i; //a loop counter
int k; //a inner loop counter


//***********initialize variables *****************************************
rearptr = (int)mem[1];
lastRcvRqst = (int)mem[2];
lastRcvAck = (uint8_T)mem[3];
preptr = (int)mem[4];
accX.val = mem[5];
accY.val = mem[6];
accZ.val = mem[7];
thX.val = mem[8];
thY.val = mem[9];
thZ.val = mem[10];
wX.val = mem[11];
wY.val = mem[12];
wZ.val = mem[13];
SN.val = mem[14];
temperature.val = mem[15];
frontptr = (int)mem[0];
mtd2_DID_count = 0;
mtd2_DID.val = 0;
for (i=0;i<BUF_SIZE;i++)
    buffer[i]=buffin[i]; //copy the previous buffer into working memory

//***************code start************************************************
RcvRqst = (u0[22]&2u); //the second bit of the status word is the Receive Request state

//there is new data if the state has changed
newdata = RcvRqst!=lastRcvRqst;

if(newdata){ //if there is new data read it into the buffer
    newdatalength = u0[23]; //the second byte of the status word reports the amount of new data
    for (i=0;i<newdatalength;i++)
        buffer[(frontptr++)%BUF_SIZE]=u0[i];
} else newdatalength = 0; //else we note there was no new data

if (preptr==XS_PREAMBLE_NOT_FOUND) { //if we haven't determined a candidate packet start byte
    for(i=rearptr;i<frontptr-2;i++) {//search the buffer for the preamble
        if (buffer[i%BUF_SIZE]==XS_PREAMBLE && buffer[(i+XS_BID_OFFSET)%BUF_SIZE]==XS_BID){ //if we find the preamble
            preptr=i; //set the start index
            break; //and stop searching
        }
    }
}
if (preptr==XS_PREAMBLE_NOT_FOUND) {//%if we didn't find a preamble during the previous search
    rearptr = frontptr-1; //keep only the last byte of the buffer only
}

if ((preptr+XS_HEADER_END_OFFSET)<frontptr && preptr>=0) { //if we have a preamble and enough bytes for a full header
    MID = buffer[(preptr+XS_MID_OFFSET)%BUF_SIZE]; //determine the message ID
    LEN = buffer[(preptr+XS_LEN_OFFSET)%BUF_SIZE]; //determine the data length
    if (MID!=XS_MID_MTDATA2 || LEN<8u || LEN>60u) { //if it's not MTData2 we don't care
        //TODO: process other messages maybe?
        MID = 0; //clear the ID
        LEN = 0; //clear the length
        rearptr = preptr+1; //move past the preamble so we don't find it again
        preptr = XS_PREAMBLE_NOT_FOUND; //reset our start index
    } else { //we have the start of a message we care about
        if (preptr+LEN+XS_HDR_CS_BYTES<frontptr) { //if it's long enough to process
            pktsum = 0; //reset the checksum
            for(i=preptr;i<=(preptr+LEN+XS_HDR_CS_BYTES);i++)
                pktsum+=buffer[i%BUF_SIZE]; //compute the checksum
            if (pktsum==XS_PREAMBLE){//if the checksum is good
                mtd2_currentbytetype = MTDATA2_DATAID; //the first byte is the start of the data id
                mtd2_Len = 0; //data length of datatype
                for (i = preptr+XS_DATA_OFFSET;i<(preptr+XS_DATA_OFFSET+LEN);/*intentionally left blank*/) {//for each byte in the MTDATA2 packet
                    switch (mtd2_currentbytetype) {
                        case MTDATA2_DATAID:
                            //the data id's are uint16's add this byte and the next to a uint16 union
                            mtd2_DID.bytes[1] = buffer[(i++)%BUF_SIZE];
                            mtd2_DID.bytes[0] = buffer[(i++)%BUF_SIZE];
                            mtd2_currentbytetype = MTDATA2_DATALEN; //the next byte is the length of the subpacket data
                            break;
                        case MTDATA2_DATALEN:
                            mtd2_DID_count++; //currently unused count of subpackets read
                            mtd2_Len = buffer[(i++)%BUF_SIZE]; //record the subpacket length
                            mtd2_currentbytetype = MTDATA2_DATA; //the next byte is the start of the subpacket data
                            break;
                        default:
                            //if it's not an id or length, it's data
                            //store the subpacket data to a new buffer
                            for(k=0;k<mtd2_Len;k++) {
                                mtd2_databuf[k%MTDATA2_MAXLEN]=buffer[(i++)%BUF_SIZE]; //modulus here in case mtd2_Len is for any reason larger than MTDATA2_MAXLEN
                            }
                            mtd2_currentbytetype = MTDATA2_DATAID;
                            switch (mtd2_DID.val) { //based on the data id parse out to values
                                case XS_DATAID_SAMPLENUM :
                                    SN.bytes[0] = mtd2_databuf[1];
                                    SN.bytes[1] = mtd2_databuf[0];
                                    break;
                                case XS_DATAID_TIMESTAMP :
                                    ST.bytes[0] = mtd2_databuf[3];
                                    ST.bytes[1] = mtd2_databuf[2];
                                    ST.bytes[2] = mtd2_databuf[1];
                                    ST.bytes[3] = mtd2_databuf[0];
                                    break;
                                case XS_DATAID_ACCELERATION :
                                    accZ.bytes[0] = mtd2_databuf[11];
                                    accZ.bytes[1] = mtd2_databuf[10];
                                    accZ.bytes[2] = mtd2_databuf[9];
                                    accZ.bytes[3] = mtd2_databuf[8];
                                    accY.bytes[0] = mtd2_databuf[7];
                                    accY.bytes[1] = mtd2_databuf[6];
                                    accY.bytes[2] = mtd2_databuf[5];
                                    accY.bytes[3] = mtd2_databuf[4];
                                    accX.bytes[0] = mtd2_databuf[3];
                                    accX.bytes[1] = mtd2_databuf[2];
                                    accX.bytes[2] = mtd2_databuf[1];
                                    accX.bytes[3] = mtd2_databuf[0];
                                    break;
                                case XS_DATAID_EULAR :
                                    thZ.bytes[0] = mtd2_databuf[11];
                                    thZ.bytes[1] = mtd2_databuf[10];
                                    thZ.bytes[2] = mtd2_databuf[9];
                                    thZ.bytes[3] = mtd2_databuf[8];
                                    thY.bytes[0] = mtd2_databuf[7];
                                    thY.bytes[1] = mtd2_databuf[6];
                                    thY.bytes[2] = mtd2_databuf[5];
                                    thY.bytes[3] = mtd2_databuf[4];
                                    thX.bytes[0] = mtd2_databuf[3];
                                    thX.bytes[1] = mtd2_databuf[2];
                                    thX.bytes[2] = mtd2_databuf[1];
                                    thX.bytes[3] = mtd2_databuf[0];
                                    break;
                                case XS_DATAID_OMEGA :
                                    wZ.bytes[0] = mtd2_databuf[11];
                                    wZ.bytes[1] = mtd2_databuf[10];
                                    wZ.bytes[2] = mtd2_databuf[9];
                                    wZ.bytes[3] = mtd2_databuf[8];
                                    wY.bytes[0] = mtd2_databuf[7];
                                    wY.bytes[1] = mtd2_databuf[6];
                                    wY.bytes[2] = mtd2_databuf[5];
                                    wY.bytes[3] = mtd2_databuf[4];
                                    wX.bytes[0] = mtd2_databuf[3];
                                    wX.bytes[1] = mtd2_databuf[2];
                                    wX.bytes[2] = mtd2_databuf[1];
                                    wX.bytes[3] = mtd2_databuf[0];
                                    break;
                                case XS_DATAID_QUATERNION :
                                    q3.bytes[0] = mtd2_databuf[15];
                                    q3.bytes[1] = mtd2_databuf[14];
                                    q3.bytes[2] = mtd2_databuf[13];
                                    q3.bytes[3] = mtd2_databuf[12];
                                    q2.bytes[0] = mtd2_databuf[11];
                                    q2.bytes[1] = mtd2_databuf[10];
                                    q2.bytes[2] = mtd2_databuf[9];
                                    q2.bytes[3] = mtd2_databuf[8];
                                    q1.bytes[0] = mtd2_databuf[7];
                                    q1.bytes[1] = mtd2_databuf[6];
                                    q1.bytes[2] = mtd2_databuf[5];
                                    q1.bytes[3] = mtd2_databuf[4];
                                    q0.bytes[0] = mtd2_databuf[3];
                                    q0.bytes[1] = mtd2_databuf[2];
                                    q0.bytes[2] = mtd2_databuf[1];
                                    q0.bytes[3] = mtd2_databuf[0];
                                    break;
                                case XS_DATAID_TEMPERATURE :
                                    temperature.bytes[0] = mtd2_databuf[3];
                                    temperature.bytes[1] = mtd2_databuf[2];
                                    temperature.bytes[2] = mtd2_databuf[1];
                                    temperature.bytes[3] = mtd2_databuf[0];
                                    break;
                                default :
                                    break;
                            }
                            break;
                        }
                    }
                } else LEN=0;
                //processbuffer(buffer(PckStart:(PckStart+LEN+4)),LEN,a,q); %process it
                rearptr = preptr+LEN+XS_HDR_CS_BYTES;
                preptr = XS_PREAMBLE_NOT_FOUND; //reset our start index
            } else LEN=0;
    }
}

//ensure both our pointers are never greater than the buffer size so they don't overflow
if (frontptr%BUF_SIZE > rearptr%BUF_SIZE) {
    frontptr%=BUF_SIZE;
    rearptr%=BUF_SIZE;
    if (preptr!=XS_PREAMBLE_NOT_FOUND) preptr%=BUF_SIZE;
}

samp[0] = (double)SN.val;
acc[0] = (double)accX.val;
acc[1] = (double)accY.val;
acc[2] = (double)accZ.val;
theta[0] = (double)thX.val;
theta[1] = (double)thY.val;
theta[2] = (double)thZ.val;
omega[0] = (double)wX.val;
omega[1] = (double)wY.val;
omega[2] = (double)wZ.val;
IMUtemp[0] = (double)temperature.val;

//RcvAck[0] = newdata ? 2u-lastRcvAck : lastRcvAck;
//RcvAck[0] = 2u-lastRcvAck;
RcvAck[0] = RcvRqst;

memout[0] = (double)frontptr;
memout[1] = (double)rearptr;
memout[2] = (double)RcvRqst;
memout[3] = (double)RcvAck[0];
memout[4] = (double)preptr;
memout[5] = acc[0];
memout[6] = acc[1];
memout[7] = acc[2];
memout[8] = theta[0];
memout[9] = theta[1];
memout[10] = theta[2];
memout[11] = omega[0];
memout[12] = omega[1];
memout[13] = omega[2];
memout[14] = (double)samp[0];
memout[15] = IMUtemp[0];
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}


