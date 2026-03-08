#include <iostream>
#include <cmath>

using namespace std;

#define N 100
#define MU 2

int main()
{   
    double num, denom, diss;
    for(int i=1; i<=N; i++) {
             num = pow(3.0, i);
             denom = pow( MU, floor( log(num)/log(MU) ) );
             
             diss = (num+denom)/(num*denom);
             
             cout << num << '/' << denom << "     " << diss << '\n';
    }
    system("pause");
    
    return 0;
}
