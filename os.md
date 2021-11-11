# OS



CPU 的工作模式有实模式、保护模式、长模式

- 实模式

  实模式又称实地址模式，实，即真实，这个真实分为两个方面

  一个方面是运行真实的指令，对指令的动作不作区分，直接执行指令的真实功能，

  另一方面是发往内存的地址是真实的，对任何地址不加限制地发往内存。

  - 中断

    保存cs:ip,装载新的cs:ip

  - 

- 保护模式

  cpu访问内存不受限制

  保护内存就是保护对应的段

  检查段描述符

  - 

- 长模式

  中断权限检查





## 锁

#### 自旋锁状态

lock =0 是 未加锁

```c++
//自旋锁结构
typedef struct
{
     volatile u32_t lock;//volatile可以防止编译器优化，保证其它代码始终从内存加载lock变量的值 
} spinlock_t;
//锁初始化函数
static inline void x86_spin_lock_init(spinlock_t * lock)
{
     lock->lock = 0;//锁值初始化为0是未加锁状态
}
//加锁函数
static inline void x86_spin_lock(spinlock_t * lock)
{
    __asm__ __volatile__ (
    "1: \n"
    "lock; xchg  %0, %1 \n"//把值为1的寄存器和lock内存中的值进行交换
    "cmpl   $0, %0 \n" //用0和交换回来的值进行比较
    "jnz    2f \n"  //不等于0则跳转后面2标号处运行
    "jmp 3f \n"     //若等于0则跳转后面3标号处返回
    "2:         \n" 
    "cmpl   $0, %1  \n"//用0和lock内存中的值进行比较
    "jne    2b      \n"//若不等于0则跳转到前面2标号处运行继续比较  
    "jmp    1b      \n"//若等于0则跳转到前面1标号处运行，交换并加锁
    "3:  \n"     :
    : "r"(1), "m"(*lock));
}
//解锁函数
static inline void x86_spin_unlock(spinlock_t * lock)
{
    __asm__ __volatile__(
    "movl   $0, %0\n"//解锁把lock内存中的值设为0就行
    :
    : "m"(*lock));
}
```

简单说

```c
while(lock!=0){}
lock = 1;
return ;
```



#### 排队锁的数据结构

```c++

typedef struct raw_spinlock{    
    union {        
        unsigned int slock;//真正的锁值变量        
        u16 owner;        
        u16 next;    
    }
}raw_spinlock_t;
```

1. 在排队自旋锁初始化时，slock 被置为 0，即 next 和 owner 被置为 0
2. Linux 进程执行申请自旋锁时，原子地将 next 域加 1，并将原值返回作为自己的序号
3. 返回值等于申请时的owner,说明排队到自己了
4. 进程释放自旋锁时，原子地将 owner 域加 1 即可



#### 读写锁

自选锁的变种

1. 当共享数据没有锁的时候，读取的加锁操作和写入的加锁操作都可以满足。
2. 当共享数据有读锁的时候，所有的读取加锁操作都可以满足，写入的加锁操作不能满足，读写是互斥的。
3. 当共享数据有写锁的时候，所有的读取的加锁操作都不能满足，所有的写入的加锁操作也不能满足，读与写之间是互斥的，写与写之间也是互斥的。



## 信号量

保证资源在一个时刻只有一个进程使用，这是单值信号量。

也可以作为资源计数器，比如一种资源有五份，同时最多可以有五个进程，这是多值信号量。

实现逻辑

```shell
信号量的值为正的时候。所申请的进程可以锁定使用它。
若为 0，说明它被其它进程占用，申请的进程要进入睡眠队列中，等待被唤醒。
所以信号量最大的优势是既可以使申请失败的进程睡眠，还可以作为资源计数器使用。
```



数据结构

```c++

struct semaphore{
    raw_spinlock_t lock;//保护信号量自身的自旋锁
    unsigned int count;//信号量值
    struct list_head wait_list;//挂载睡眠等待进程的链表
};
```





## 建立计算机

```shell

dd bs=512 if=/dev/zero of=hd.img count=204800

#;bs:表示块大小，这里是512字节
#;if：表示输入文件，/dev/zero就是Linux下专门返回0数据的设备文件，读取它就返回0
#;of：表示输出文件，即我们的硬盘文件。
#;count：表示输出多少块
#生成 100MB 的文件。文件数据为全 0。

sudo losetup /dev/loop0 hd.img
#将 hd.img 变成 Linux 的回环设备
#我的loop0被占用了 改成了11


sudo mkfs.ext4 -q /dev/loop11
#mkfs.ext4 命令格式化这个 /dev/loop11 回环块设备，在里面建立 EXT4 文件系统。
#lost+found:ext2,3,4文件系统，当文件系统错误时，将一些遗失片段放置到这个目录下，xfs文件系统就不存在这个目录
sudo mount -o loop ./hd.img ./hdisk/
sudo grub-install --target i386-pc --boot-directory hdisk/boot --force --allow-floppy /dev/loop13
```

