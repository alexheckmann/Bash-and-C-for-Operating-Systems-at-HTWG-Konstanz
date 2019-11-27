#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <err.h>

#define MAXCOUNT 999
#define MAXPASSWORDS 20

char passwords[MAXCOUNT][MAXPASSWORDS];

void usage(void)
{
    printf("usage: ./crack <dictionary> <cryptogram>\n");
    printf("Do a dictionary attack against an openssl encrypted file\n");
}

int readfile(FILE *f)
{
    // i: line count
    // j: char count
    int c, i = 0, j = 0;
    
    // reading in chars until end of file is reached
    while ((c = fgetc(f)) != EOF)
    {
        // test if whitespace char is reached
        if (c == ' ' || c == '\n' || c == '\t')
        {
            // reading in next line, resetting char count
            i++;
            j = 0;
        }
        
        else
        {
            passwords[i][j++] = c;
        }
    }

    return 0;
}

int main(int argc, char *argv[])
{
    int status, k = 0;

    if (argc != 3)
    {
        usage();
        return EXIT_FAILURE;
    }

    FILE *f = fopen(argv[1], "r");
    if (f == NULL)
    {
        err(1, "%s: %s: No such file or dictionary", argv[0], argv[1]);
        return EXIT_FAILURE;
    }

    readfile(f);
    fclose(f);

    // 
    for (int i = 0; i < MAXCOUNT + 1; i++)
    {
        // forking to create new child process
        pid_t pid = fork();

        // test whether fork was successful
        if (pid == 0)
        {
            // using child process to open openssl decryption
            execlp("openssl", "aes-256-ecb", "-d", "-in", argv[2], "-out", "decrypted.txt", "-k", passwords[i], NULL);
        }

        if (wait(&status) < 0)
        {
            err(1, "wait");
        }

        // checking for successful decryptions, printing out password candidates
        if (WEXITSTATUS(status) == 0)
        {
            printf("candidate: %s\n", passwords[i]);
        }
    }

    return EXIT_SUCCESS;
}
