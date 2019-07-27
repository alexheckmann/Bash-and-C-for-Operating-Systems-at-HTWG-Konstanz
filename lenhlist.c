#include <stdio.h>
#include <stdlib.h>

#define MAXPASSWORDS 12
#define ASCII 128

int hist[MAXPASSWORDS] = {0};
int charset[ASCII];


int getwordlen(void)
{
    int c, wordlen;
    wordlen = 0;
    while ((c = getchar()) != EOF)
    {
        charset[c] = 1;
        wordlen++;

        if (c == ' ' || c == '\n' ||  c == '\t')
        {
            wordlen--;

            if  (wordlen >= MAXPASSWORDS)
            {
                hist[0]++;

            }
            else
            {
                for (int i = 1; i < MAXPASSWORDS; i++)
                {
                    if (wordlen == i)
                    {
                        hist[i]++;
                    }
                }
            }
            wordlen = 0;
        }
    }

    return EXIT_SUCCESS;
}

void print_stars(int nlen, int nwords)
{
    double percentage = (double) nlen / (double) nwords * 100.00;
    printf(" (%5.2f%%) ", percentage);

    int stars = (int) percentage;

    for (int i = 0; i < stars; i++)
    {
        printf("*");
    }
    printf("\n");
}

void print_histo(int histo[])
{
    getwordlen();
    int i, nwords;
    nwords = 0;

    for (i = 0; i < MAXPASSWORDS; i++)
    {
        nwords += histo[i];
    }

    for (i = 1; i < MAXPASSWORDS; i++)
    {
        printf("%2d - %5d :", i, histo[i]);
        print_stars(histo[i], nwords);
    }
    printf("There are %d words of length >= %d.\nIn total there are %d words.\n", histo[0], MAXPASSWORDS, nwords);

}

void print_charset(int charset[])
{
    printf("Character set used: ");
    for (int i = 0; i < ASCII; i++)
    {

        if (charset[i] == 1)
        {
            i = (char) i;
            printf("%c", (char) i);
        }


    }
    printf("\n");
}

int main(int argc, char *argv[])
{
    print_histo(hist);
    print_charset(charset);

    return EXIT_SUCCESS;
}
