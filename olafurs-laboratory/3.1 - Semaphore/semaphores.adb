-- Package: Semaphores
--
-- ==> Complete the code at the indicated places
with Ada.Text_IO;
use Ada.Text_IO;

package body Semaphores is
    protected body CountingSemaphore is
        entry Wait when Count > 0 is
        begin
            Count := Count - 1;
        end Wait;
        
        entry Signal when Count < MaxCount is
        begin
            Count := Count + 1;
        end Signal;

    end CountingSemaphore;
end Semaphores;
