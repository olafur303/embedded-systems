-- Package: Semaphores
-- 
-- ==> Do not change this file!

package Semaphores is
    type CountingSemaphoreType is (NotFull, NotEmpty);

    protected type CountingSemaphore(Max: Natural; Initial: Natural; SemType: CountingSemaphoreType)  is
        entry Wait(Caller : in String);
        entry Signal(Caller : in String);
    private
        Count : Natural := Initial;
        MaxCount : Natural := Max;
        SemaphoreType : CountingSemaphoretype := SemType;
    end CountingSemaphore;

    protected type MutexSemaphore  is
        entry Lock(Caller : in String);
        entry Unlock(Caller : in String);
    private
         Locked : Natural := 0;
    end MutexSemaphore;
end Semaphores;

