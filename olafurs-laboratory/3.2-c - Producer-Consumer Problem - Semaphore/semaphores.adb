-- Package: Semaphores
--
-- ==> Complete the code at the indicated places

with Ada.Text_IO;
use Ada.Text_IO;

package body Semaphores is
    protected body CountingSemaphore is
        entry Wait(Caller : String)  when Count > 0 is
        begin
            Put_Line(" " & Caller & " done waiting for " & SemaphoreType'Image & "..");
            Count := Count - 1;
        end Wait;

        entry Signal(Caller : String)  when Count < MaxCount is
        begin
            Put_Line(" " & Caller & " done signalling " & SemaphoreType'Image & "..");
            Count := Count + 1;
        end Signal;

    end CountingSemaphore;

    protected body MutexSemaphore is
        entry Lock(Caller : String) when Locked = 0 is
        begin
            Locked := 1;
            Put_Line("[" & ASCII.ESC & "[31m" & "X" & ASCII.ESC & "[00m" & "] Mutex locked by " & Caller);
        end Lock;

        entry Unlock(Caller : String) when Locked = 1 is
        begin
            Locked := 0;
            Put_Line("[ ] Mutex unlocked by " & Caller);
        end Unlock;
    end MutexSemaphore;
end Semaphores;

