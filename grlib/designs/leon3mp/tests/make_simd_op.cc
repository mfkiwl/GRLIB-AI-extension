#include<iostream>
#include<string>
#include<bitset>
using namespace std;

int main(){
    const bitset<2> op("10");
    const bitset<6> opcode ("001001");
    const bitset<1> imm ("0");
    int input;
    
    cout<<"Use default addresses?(1/0)\n";
    cin>>input;
    bitset<5> rd(1);
    bitset<5> rs1(2);
    bitset<5> rs2(1);
    if(!input){
        cout<<"Input destination register:\n";
        cin>>input;
        bitset<5> rd(input);
        cout<<"Input source1 register:\n";
        cin>>input;
        bitset<5> rs1(input);
        cout<<"Input source2 register:\n";
        cin>>input;
        bitset<5> rs2(input);
    }
    cout<<"Input stage1 op:\n";
    cin>>input;
    bitset<5> op1(input);
    cout<<"Input stage2 op:\n";
    cout<<"NOP = 0   MAX = 2    XOR = 4   MAX = 6\n";
    cout<<"SUM = 1   MIN = 3   USUM = 5   MIN = 7\n";
    cin>>input;
    bitset<3> op2(input);
    bitset<32> instr(op.to_string()+rd.to_string()+opcode.to_string()+rs1.to_string()+imm.to_string()+op2.to_string()+op1.to_string()+rs2.to_string());

    cout<<instr<<endl;
    cout << hex << instr.to_ulong() << endl;
}
