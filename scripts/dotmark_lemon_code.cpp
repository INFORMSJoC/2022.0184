#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <cmath>
#include <lemon/list_graph.h>
#include <lemon/network_simplex.h>
#include <chrono>
#include <numeric>

using inttype = long long;
using vec = std::vector<inttype>;
using namespace lemon;

// Special modulo function
int mod_s(int x,int y){
    if (x%y==0) return y;
    return (x%y);
}

// Component sum of vector
inttype sum_vec(vec& v){
    inttype total{0};
    for (int i=0;i<v.size();i++){
        total += v[i];
    }
    return total;
}

// Component scaling of vector
void scale_vec(vec& v,double x){
    for (int i=0;i<v.size();++i){
        v[i] *= x;
    }
}

// Read supply vector
vec read_a(std::fstream& file,int m){
    vec a(m,0);
    double temp{};
    for (int i=0;i<m;++i){
        file>>temp;
        a[i] = temp*1e8;
    }
    return a;
}

// Read demand vector
vec read_b(std::fstream& file,int n){
    vec b(n,0);
    double temp{};
    for (int i=0;i<n;++i){
        file>>temp;
        b[i] = temp*1e8;
    }
    return b;
}

//Compute cost function
vec compute_dist1(int m,int n,int res,int type){
    vec c(static_cast<inttype>(m)*n,0);
    for (int i=1;i<=m;++i){
        for (int j=1;j<=n;++j){
            int Pir = mod_s(i,res);
            int Pic = ceil(static_cast<double>(i)/res);
            int Pjr = mod_s(j,res);
            int Pjc = ceil(static_cast<double>(j)/res);
            switch (type){
                case 1:
                    c[(static_cast<inttype>(j)-1)*m+i-1] = 1e8*(abs(Pir-Pjr)+abs(Pic-Pjc));
                    break;
                case 2:
                    c[(j-1)*m+i-1] = 1e8*sqrt((Pir-Pjr)*(Pir-Pjr)+(Pic-Pjc)*(Pic-Pjc));
                    break;
                case 3:
                    c[(j-1)*m+i-1] = 1e8*std::max(abs(Pir-Pjr),abs(Pic-Pjc));
                    break;
                default:
                    std::cerr<<"Wrong distance type\n";
                    return {};
            }
        }
    }
    return c;
}

// Generate vectors a and b
bool build_vectors(int class_id,int prob_id,int resolution,int m,int n,vec& a,vec& b,bool& skip_problem){
    // set input file
    char prob_name[60];
    snprintf(prob_name,60,"../data/lemon_data/class_%d_prob_%d_res_%d.txt",class_id,prob_id,resolution);
    std::fstream file(prob_name);
    if (!file) {
        std::cerr<<"- - - - Error with input file - - - - "<<'\n';
        std::cerr<<"- - - - Skipping current problem - - - - \n";
        skip_problem = true;
    }
    a = read_a(file,m);
    b = read_b(file,n);
    inttype sum_a = sum_vec(a);
    inttype sum_b = sum_vec(b);
    bool change_supply_type{true};
    if (sum_a+sum_b>0){
        change_supply_type = true;
    }else{
        change_supply_type = false;
    }
    return change_supply_type;
}

// Generate graph structure
void build_graph(int m,int n,std::vector<std::vector<int>>& v){
    inttype ind{0};
    for (int i=0;i<m;++i){
        for (int j=m;j<m+n;++j){
            v[ind++] = std::vector<int> {i,j};
        }
    }
}

int main(int argc,char** argv){

    if (argc!=7){
        std::cout<<"Required parameters:\n";
        std::cout<<" RESOLUTION\n COST_FUNCTION\n FIRST_CLASS\n LAST_CLASS\n FIRST_PROBLEM\n LAST_PROBLEM\n";
        return 1;
    }

    // PARAMETERS
    // % % % % % % % % % % % % % % % % % %
    int resolution      = atoi(argv[1]);
    int dist            = atoi(argv[2]);
    int class_id_start  = atoi(argv[3]);
    int class_id_stop   = atoi(argv[4]);
    int prob_id_start   = atoi(argv[5]);
    int prob_id_stop    = atoi(argv[6]);
    // % % % % % % % % % % % % % % % % % %


    // BUILD PROBLEM
    // % % % % % % % % % % % % % % % % % %
    std::cout<<"Building problem..."<<'\n';
    int m = resolution*resolution;
    int n = m;
    vec supply_a(m,0);
    vec supply_b(n,0);
    vec cost_vec(static_cast<inttype>(m)*n,0);
    int num_nodes{m+n};
    std::vector<std::vector<int>> edge_vec(static_cast<inttype>(m)*n,std::vector<int>(2,0));
    cost_vec = compute_dist1(m,n,resolution,dist);
    build_graph(m,n,edge_vec);
    inttype num_edges = edge_vec.size();
    // % % % % % % % % % % % % % % % % % %

    // OPEN FILE FOR RESULTS
    // % % % % % % % % % % % % % % % % % %
    char res_name[60];
    snprintf(res_name,60,"../results/lemon_results/results_resolution_%d_dist%d.txt",resolution,dist);
    FILE *results_file;
    results_file = fopen(res_name,"a");
    fprintf(results_file,"\nTime (ms)     cl  pb      cost        state\n\n");
    // % % % % % % % % % % % % % % % % % %


    //ITERATE OVER PROBLEMS
    // % % % % % % % % % % % % % % % % % %
    for (int cl_id = class_id_start;cl_id<=class_id_stop;++cl_id){

        for (int pb_id = prob_id_start;pb_id<=prob_id_stop;++pb_id){

            std::cout<<"\nSolving class "<<cl_id<<", problem "<<pb_id<<"...\n";
            bool skip_problem{false};
            bool change_supply_type = build_vectors(cl_id,pb_id,resolution,m,n,supply_a,supply_b,skip_problem);
            if (skip_problem){
                continue;
            }

            std::cout<<"Building model..."<<'\n';

            auto start_pre = std::chrono::high_resolution_clock::now();
            //create graph
            ListDigraph g;
	        g.reserveNode(num_nodes);
	        g.reserveArc(num_edges);	    


            //add nodes
            for (int i=0;i<num_nodes;++i){
                g.addNode();
            }
	        std::cout<<"Nodes added\n";            
 
            //add arcs
            for (inttype i=0;i<num_edges;++i){
                g.addArc(g.nodeFromId(edge_vec[i][0]),g.nodeFromId(edge_vec[i][1]));
            }
	        std::cout<<"Arcs added\n";

            //give cost to each arc
            ListDigraph::ArcMap<inttype> cost(g);
            for (ListDigraph::ArcIt e(g);e!=INVALID;++e){
                cost[e] = cost_vec[g.id(e)];
            }
	        std::cout<<"Cost added\n";

            //give supply to each node
            ListDigraph::NodeMap<inttype> supply(g);
            for (ListDigraph::NodeIt nn(g);nn!=INVALID;++nn){
                if (g.id(nn)<m) supply[nn] = supply_a[g.id(nn)];
                else supply[nn] = supply_b[g.id(nn)-m];
            }
	        std::cout<<"Supply added\n";

            auto end_pre = std::chrono::high_resolution_clock::now();
            std::chrono::duration<double> duration_pre = (end_pre-start_pre)*1000;
	        std::cout<<"Building time "<<duration_pre.count()<<" millisec\n";

            std::cout<<"Running model..."<<'\n';
            auto start = std::chrono::high_resolution_clock::now();
            //build and run network simplex model
            NetworkSimplex<ListDigraph,inttype> model(g);
            model.costMap(cost);
            model.supplyMap(supply);
            if (change_supply_type){
                auto st = NetworkSimplex<ListDigraph,inttype>::LEQ;
                model.supplyType(st);
            }
            auto pivot_rule=NetworkSimplex<ListDigraph,inttype>::BLOCK_SEARCH;
            NetworkSimplex<ListDigraph,inttype>::ProblemType pt;
            auto pt_opt = NetworkSimplex<ListDigraph,inttype>::ProblemType::OPTIMAL;
            auto pt_inf = NetworkSimplex<ListDigraph,inttype>::ProblemType::INFEASIBLE;
            auto pt_unb = NetworkSimplex<ListDigraph,inttype>::ProblemType::UNBOUNDED;
            pt = model.run(pivot_rule);       
            auto end = std::chrono::high_resolution_clock::now();
            std::chrono::duration<double> duration = (end-start)*1000;

            //print result
            double totalcost = model.totalCost<double>()*1e-16;
            std::cout<<"Total cost "<<totalcost<<'\n';
            std::cout<<"Time "<<duration.count()<<" millisec"<<'\n';
            char pb_state{};
            if (pt == pt_opt){
                std::cout<<"Optimal value found\n";
                pb_state = 'O';
            }
            else if(pt == pt_inf){
                std::cout<<"Problem infeasible\n";
                pb_state = 'I';
            }
            else if(pt == pt_unb){
                std::cout<<"Problem unbounded\n";
                pb_state = 'U';
            }

            //write results to file
            fprintf(results_file,"%10.2f %4d %4d %10.3f %10c\n",duration.count(),cl_id,pb_id,totalcost,pb_state);
            fflush(results_file); 
            
       }

    }
    // % % % % % % % % % % % % % % % % % %
    

    return 0;
}



