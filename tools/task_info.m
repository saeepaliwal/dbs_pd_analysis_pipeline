function g = task_info

file = ['/Users/saee/Dropbox/Doctorate/projects/DBS_PD/'...
    'tasks/breakspear_slot_machine/taskBackend.txt'];
f = fopen(file,'r');
[A] = textscan(f,'%s');
win = zeros(100,1);
loss = zeros(100,1);
big_win = zeros(100,1);
small_win = zeros(100,1);
near_miss = zeros(100,1);
true_loss = zeros(100,1);
can_gamble = zeros(100,1);
double_up_won = zeros(100,1);
double_up_lost = zeros(100,1);
remain = A{1}{:}(1:end-1);
i = 1;

for j = 1:5
    [tok,remain] = strtok(remain,',');
end

while remain
   [tok,remain] = strtok(remain,',');
    if tok(1) == '1' && ismember(tok(2),{'8','9'})
        big_win(i) = 1;
        win(i) = 1;
    elseif tok(1) == '1' && ismember(tok(2),{'1','2','3','4','5','6','7'})
        small_win(i) = 1;
        win(i) = 1;
    elseif tok(1) == '2'
        near_miss(i) = 1;
        loss(i) = 1;
    elseif tok(1) == '0' && tok(2) ~= tok(3)
        true_loss(i) = 1;
        loss(i) = 1;
    end
    
    if tok(5) == '1'
        can_gamble(i) = 1;
    end
    if tok(6) == '1'
        double_up_won(i) = 1;
    else
        double_up_lost(i) = 1;
    end

    i = i+1;
end
g.win = win;
g.loss = loss;
g.big_win = big_win;
g.small_win = small_win;
g.near_miss = near_miss;
g.true_loss = true_loss;
g.can_gamble = can_gamble;
g.double_up_won = double_up_won;
g.double_up_lost = double_up_lost;