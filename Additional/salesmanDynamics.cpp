#include <bits/stdc++.h>

using namespace std;

const int INF = int(1e9);

int n;
int g[20][20];
int d[20][4194304];
bool used[20][4194304] = {{false}};

int getShortiest(int i, int mask) {
    if (used[i][mask]) return d[i][mask];
    used[i][mask] = true;
    for (int j = 0; j < n; ++j)
        if (mask & (1 << j))
            d[i][mask] = min(d[i][mask], getShortiest(j, mask - (1 << j)) + g[i][j]);
    return d[i][mask];
}

void printWay(int i, int mask) {
    printf("%d ", i + 1);
    for (int j = 0; j < n; ++j)
        if (d[i][mask] == d[j][mask - (1 << j)] + g[i][j] && (mask & (1 << j)))
            printWay(j, mask - (1 << j));
}

int main() {
    scanf("%d", &n);
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j)
            g[i][j] = rand()%1000001;
        d[i][0] = 0;
        for (int mask = 1; mask < (1 << n); ++mask) d[i][mask] = INF;
    }
    int ans = INF;
    int str = 0;
    for(int i = 0 ; i < n; ++i)
        if(ans > getShortiest(i, (1 << n) - 1 - (1 << i)))
            ans = getShortiest(i, (1 << n) - 1 - (1 << i)), str = i;
    printf("%d\n", ans);
    printWay(str, (1 << n) - 1 - (1 << str));
    return 0;
}