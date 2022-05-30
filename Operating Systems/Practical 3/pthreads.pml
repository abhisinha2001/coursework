// pthreads.pml

// Task: modify lock, unlock, wait and signal to do the correct thing.

mtype = { unlocked, locked } ;

typedef mutexData {
  mtype mstate;
  byte mid;
  // may need more fields here
}


typedef condvarData {
  bool dummy;
  // may need different fields here
}

mutexData mtx;

condvarData cvars[2];
#define PRODCONDVAR 0
#define CONSCONDVAR 1

inline initsync() {
  mtx.mstate = unlocked;
  cvars[0].dummy = true;
  cvars[1].dummy = true;
  // may need more/different code to initialise fields here
}

// pthread_mutex_lock(&m);
inline lock(m) {
  printf("@@@ %d LOCKING : state is %e\n",_pid,m.mstate)
  // will need code here
  atomic{ mtx.mstate==unlocked -> mtx.mstate = locked; mtx.mid = _pid } ; // Locking the mutex autommatically, based on slides
  
  printf("@@@ %d LOCKED : state is %e\n",_pid,m.mstate)
}

// pthread_mutex_unlock(&m);
inline unlock(m) {
  printf("@@@ %d UNLOCKING : state is %e\n",_pid,m.mstate)
  // will need code here
  atomic {
  assert(mtx.mid==_pid);
  mtx.mstate = unlocked;
  mtx.mid = 0;
}// Performs unlocking of the mutex, based on slides
  printf("@@@ %d UNLOCKED : state is %e\n",_pid,m.mstate)
}

// pthread_cond_wait(&c,&m);
inline wait(c,m) {
  printf("@@@ %d WAIT for cond[%d]=%d with mutex=%e\n",_pid,
         c,cvars[c].dummy,m.mstate)
  // will need code here
  do // Wait continuosly for the signal to unclock the mutex
  :: signal(c);
  :: else -> m.mstate = unlocked;
            cvars[c].dummy = true;
  od
  

  printf("@@@ %d DONE with cond[%d]=%d with mutex=%e\n",_pid,
         c,cvars[c].dummy,m.mstate)
}

// pthread_cond_signal(&c);
inline signal(c) {
  printf("@@@ %d SIGNAL cond[%d]=%d\n",_pid,c,cvars[c].dummy)
  // will need code here
  if // If the condition variable is becomes false, then signal that the mutex job is done and unlock the mutex
  :: cvars[c].dummy == true;
  :: else -> cvars[c].dummy = false;
            
  fi
    cvars[c].dummy=false
  printf("@@@ %d SIGNALLED cond[%d]=%d\n",_pid,c,cvars[c].dummy)
}
