#include <bits/stdc++.h>

using namespace std;

const int INF = int(1e9);

int n;
int g[20][20];
bool used[20] = {false};
int ans = INF;
stack<int> st;

void clearSt() {
    while(!st.empty()) st.pop();
}

bool dfs(int v, int dist) {
    used[v] = true;
    bool end = true;
    bool best = false;
    for (int i = 0; i < n; ++i)
        if (!used[i]) {
            if (dfs(i, dist + g[v][i])) st.push(v), best = true;
            end = false;
        }
    used[v] = false;
    if (end && ans > dist) {
        ans = dist;
        clearSt();
        st.push(v);
        return true;
    }
    return best;
}

int main() {
    scanf("%d", &n);
    for (int i = 0; i < n; ++i)
        for (int j = 0; j < n; ++j)
            scanf("%d", &g[i][j]);
    for (int i = 0; i < n; ++i) dfs(i, 0);
    printf("%d\n", ans);
    while(!st.empty()) printf("%d ", st.top() + 1), st.pop();
    return 0;
}