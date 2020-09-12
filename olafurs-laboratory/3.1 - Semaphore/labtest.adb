with Ada.Text_IO;
use Ada.Text_IO;

with Semaphores;
use Semaphores;

procedure LabTest is
    counter : CountingSemaphore(4,3);
begin
    Put_Line("Testing...");
    Put_Line("counter.Wait");
    counter.Wait;
    Put_Line("counter.Signal");
    counter.Signal;
    Put_Line("counter.Wait");
    counter.Wait;
end LabTest;
