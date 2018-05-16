#include <bits/stdc++.h>

using namespace std;

const int INF = int(1e9);

vector<int> way1, way2;

int n;
int g[20][20];
int d[20][4194304];
bool used[20][4194304];

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
        way1.push_back(i + 1);
        for (int j = 0; j < n; ++j)
            if ((mask & (1 << j)) && d[i][mask] == d[j][mask - (1 << j)] + g[i][j]) {
                i = j, mask -= (1 << j);
                break;
            }
    }
    way1.push_back(i + 1);
}

int main1() {
    int ans = INF;
    int str = 0;
    for (int i = 0; i < n; ++i)
        if (ans > getShortiest(i, (1 << n) - 1 - (1 << i)))
            ans = getShortiest(i, (1 << n) - 1 - (1 << i)), str = i;
    printWay(str, (1 << n) - 1 - (1 << str));
    return ans;
}

bool used2[20] = {false};
int ans2 = INF;
stack<int> st;

void clearSt() {
    while(!st.empty()) st.pop();
}

bool dfs(int v, int dist) {
    used2[v] = true;
    bool end = true;
    bool best = false;
    for (int i = 0; i < n; ++i)
        if (!used2[i]) {
            if (dfs(i, dist + g[v][i])) st.push(v), best = true;
            end = false;
        }
    used2[v] = false;
    if (end && ans2 > dist) {
        ans2 = dist;
        clearSt();
        st.push(v);
        return true;
    }
    return best;
}

int main2() {
    for (int i = 0; i < n; ++i) dfs(i, 0);
    while(!st.empty()) way2.push_back(st.top() + 1), st.pop();
    return ans2;
}

int main() {
    int cs = 0;
    while (true) {
        way1.clear();
        way2.clear();
        ans2 = INF;
        clearSt();
        for(int i = 0; i < 20; ++i)
            used2[i] = false;
        srand(time(0));
        //n = rand() % 11 + 1;
        scanf("%d", &n);
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j)
                g[i][j] = rand() % 1000001;
            for (int mask = 0; mask < (1 << n); ++mask) d[i][mask] = INF, used[i][mask] = false;
            d[i][0] = 0;
        }
        printf("%d n = %d\n", cs++, n);
        for (int i = 0; i < n; ++i)
            g[i][i] = 0;
        /*for (int i = 0; i < n; ++i)
            for (int j = 0; j < n; ++j)
                g[i][j] = g[j][i];*/
        int aans1 = main1();
        //int aans2 = main2();
        /*if (aans1 != aans2 || way1 != way2) {
            printf("---------\nn = %d\n", n);
            for (int i = 0; i < n; ++i) {
                for (int j = 0; j < n; ++j)
                    printf("%d ", g[i][j]);
                printf("\n");
            }
            printf("ans1 = %d\nans2 = %d\n", aans1, aans2);
            for (auto elt : way1) printf("%d ", elt);
            printf(" way1\n");
            for (auto elt : way2) printf("%d ", elt);
            printf(" way2\n\n\n");
            break;
        }*/
        printf("ans1 = %d\n", aans1);
        for (auto elt : way1) printf("%d ", elt);
        printf(" way1\n");
    }
    return 0;
}
