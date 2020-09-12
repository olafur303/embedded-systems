with Ada.Text_IO;
use Ada.Text_IO;

with Ada.Real_Time;
use Ada.Real_Time;

with Ada.Numerics.Discrete_Random;

with Semaphores;
use Semaphores;

procedure ProducerConsumer_Sem is
	
	--N : constant Integer := 10; -- Number of produced and consumed tokens per task
	--X : constant Integer := 3; -- Number of producers and consumer
	N : constant Integer := 4; -- Number of produced and consumed tokens per task
	X : constant Integer := 2; -- Number of producers and consumer
		
	-- Buffer Definition
	Size: constant Integer := 4;
	type Index is mod Size;
	type Item_Array is array(Index) of Integer;
	B : Item_Array;
	In_Ptr, Out_Ptr, Count : Index := 0;

   -- Random Delays
   subtype Delay_Interval is Integer range 50..250;
   package Random_Delay is new Ada.Numerics.Discrete_Random (Delay_Interval);
   use Random_Delay;
   G : Generator;

   StrProducer : constant String := ASCII.ESC & "[36m" & "Producer" & ASCII.ESC & "[00m";
   StrConsumer : constant String := ASCII.ESC & "[32m" & "Consumer" & ASCII.ESC & "[00m";
	
   -- => Complete code: Declation of Semaphores
	--    1. Semaphore 'NotFull' to indicate that buffer is not full
   NotFull : CountingSemaphore(Size, 4, CountingSemaphoreType'Value("NotFull"));
   NotEmpty : CountingSemaphore(Size, 0,CountingSemaphoreType'Value("NotEmpty"));
   AtomicAccess : MutexSemaphore;
	--    2. Semaphore 'NotEmpty' to indicate that buffer is not empty
	--    3. Semaphore 'AtomicAccess' to ensure an atomic access to the buffer
	
   task type Producer;

   task type Consumer;

   task body Producer is
      Next : Time;
   begin
      Next := Clock;
      for I in 1..N loop
        -- => Complete Code: Write to Buffer
        NotFull.Wait(StrProducer);

        AtomicAccess.Lock(StrProducer);
        Put_Line(StrProducer & " locked AtomicAccess..");

        B(In_Ptr) := I;
        In_Ptr := In_Ptr + 1;
        Put_Line(StrProducer & " inserted " & Integer'Image(I) & " into position " & Index'Image(In_Ptr));

        -- Next 'Release' in 50..250ms

        AtomicAccess.Unlock(StrProducer);

        --delay until Next;
        Next := Next + Milliseconds(Random(G));
        delay until Next;

        NotEmpty.Signal(StrProducer);
      end loop;
   end;

   task body Consumer is
      Next : Time;
      A: Integer;
   begin
      Next := Clock;
      for I in 1..N loop
         -- => Complete Code: Read from Buffer
            NotEmpty.Wait(StrConsumer);

            AtomicAccess.Lock(StrConsumer);

            A := B(Out_Ptr);
            Out_Ptr := Out_Ptr + 1;
            Put_Line(StrConsumer & " received " & Integer'Image(A) & " from position " & Index'Image(Out_Ptr));

            AtomicAccess.Unlock(StrConsumer);

            -- Next 'Release' in 50..250ms
            Next := Next + Milliseconds(Random(G));
            delay until Next;

            NotFull.Signal(StrConsumer);
      end loop;
   end;
	
	P: array (Integer range 1..X) of Producer;
	C: array (Integer range 1..X) of Consumer;
	
begin -- main task
   null;
end ProducerConsumer_Sem;


