#include <iostream>
#include <string>
#include <fstream>
using namespace std;

int change (string &line, string pattern, ifstream& list_file){
    int res = 0;
    string new_inst;
    size_t pos;
    pos = line.find(pattern);
    while (pos != string::npos){
        if(getline(list_file,new_inst)){
            line.replace(pos,pattern.length(),new_inst);
            res++;
        }
        else 
        {
            cout<<"Not enough instructions in list file\n";
            break;
        }
        pos = line.find(pattern);
    }

    return res;

}

int main(int argc, char* argv[]){
    if(argc != 5) {
        cout<<"Usage: bin_change original_file list_file output_file pattern\n";
        exit(0);
    }
    string pattern = argv[4];
    ofstream output;
    ifstream list, source;
    int sum = 0;

    string line;

    source.open(argv[1]);
    list.open(argv[2]);
    output.open(argv[3],ios::trunc);
    if(source.is_open())
    {
        if(list.is_open())
        {
            if(output.is_open()){
                while(getline(source,line)){
                    sum+=change(line,pattern,list);
                    output<<line<<"\n";
                }
                output.close();
                if(getline(list,line)) cout<<"Not enough lines in source for the provided list\n";
                cout<<"Substitution completed, total of "<<sum<<" substitutions done\n";
            }
            else cout << "Unable to open output file\n";
        }
        else cout<<"Unable to open list file\n";
        source.close();
        list.close();
    }
    else cout<<"Unable to open source file\n";



    return 0;
}
