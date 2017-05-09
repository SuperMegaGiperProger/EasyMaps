#include <iostream>
#include <stack>
#include <stdio.h>

using namespace std;

const int INF = int(1e9);

int n;
int **g;
int **d;
bool **used;

struct elt {
    int i, mask0, mask;
};

elt create(int i, int mask0, int dmask = 0) {
    elt res;
    res.i = i;
    res.mask0 = mask0;
    res.mask = mask0 - dmask;
    return res;
}

int getShortiest(int i0, int mask00) {
    if(used[i0][mask00]) return d[i0][mask00];
    stack<elt> st;
    st.push(create(i0, mask00));
    while (!st.empty()) {
        int i = st.top().i;
        int mask = st.top().mask;
        int mask0 = st.top().mask0;
        auto &it = st.top();
        if (used[i][mask0]) {
            st.pop();
            continue;
        }
        for (int j = 0; j < n; ++j)
            if (mask & (1 << j))
                if (used[j][mask0 - (1 << j)])
                    d[i][mask0] = min(d[i][mask0], d[j][mask0 - (1 << j)] + g[i][j]), it.mask -= (1 << j);
                else
                    st.push(create(j, mask0 - (1 << j)));
        if (mask == 0) used[i][mask0] = true;
    }
    return d[i0][mask00];
}

void printWay(int i, int mask) {
    while (mask) {
        printf("%d ", i + 1);
        for (int j = 0; j < n; ++j)
            if ((mask & (1 << j)) && d[i][mask] == d[j][mask - (1 << j)] + g[i][j]) {
                i = j, mask -= (1 << j);
                break;
            }
    }
    printf("%d ", i + 1);
}

int main() {
    scanf("%d", &n);
    g = new int *[n];
    d = new int *[n];
    used = new bool *[n];
    for (int i = 0; i < n; ++i) {
        g[i] = new int[n];
        for (int j = 0; j < n; ++j)
            scanf("%d", &g[i][j]);
        used[i] = new bool[(1 << n) - 1];
        d[i] = new int[(1 << n) - 1];
        for (int mask = 0; mask < (1 << n); ++mask) d[i][mask] = INF, used[i][mask] = false;
        d[i][0] = 0;
    }
    int ans = INF;
    int str = 0;
    for (int i = 0; i < n; ++i)
        if (ans > getShortiest(i, (1 << n) - 1 - (1 << i)))
            ans = getShortiest(i, (1 << n) - 1 - (1 << i)), str = i;
    printf("%d\n", ans);
    printWay(str, (1 << n) - 1 - (1 << str));
    return 0;
}