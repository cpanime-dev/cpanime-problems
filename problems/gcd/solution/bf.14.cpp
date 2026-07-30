#include <bits/stdc++.h>
using namespace std;

int main(void) {
  ios::sync_with_stdio(false), cin.tie(nullptr), cout.tie(nullptr);
  int a, b;
  cin >> a >> b;
  int ans = 1;
  for (int i = 1; i <= a && i <= b; ++i)
    if (a % i == 0 && b % i == 0) ans = i;
  cout << ans;
  return 0;
}