#include <bits/stdc++.h>

using namespace std;

typedef long long ll;

const ll INF = ll(1e12);

int main() {
    freopen("distance.in", "r", stdin),
            freopen("distance.out", "w", stdout);
    int n, m, s, f;
    scanf("%d %d %d %d", &n, &m, &s, &f);
    --s, --f;
    vector<pair<int, int>> g[71234];
    while (m--) {
        int b, e, w;
        scanf("%d %d %d", &b, &e, &w);
        --b, --e;
        g[b].push_back(make_pair(e, w));
        g[e].push_back(make_pair(b, w));
    }
    multimap<ll, int> q;
    q.insert(make_pair(0l, s));
    ll d[71234];
    bool used[71234];
    int parent[71234];
    for (int i = 0; i < n; ++i) d[i] = INF, used[i] = false, parent[i] = -1;
    d[s] = 0l;
    while (!q.empty()) {
        int v = q.begin()->second;
        q.erase(q.begin());
        if (used[v]) continue;
        used[v] = true;
        if (v == f) break;
        for (auto to : g[v])
            if (d[to.first] > d[v] + to.second) {
                parent[to.first] = v;
                d[to.first] = d[v] + to.second;
                q.insert(make_pair(d[to.first], to.first));
            }
    }
    if (d[f] >= INF) {
        printf("-1");
        return 0;
    }
    cout << d[f] << "\n";
    stack<int> way;
    int v = f;
    while (v != -1) way.push(v), v = parent[v];
    while (!way.empty()) printf("%d ", way.top() + 1), way.pop();
    return 0;
}