//
//  ViewController.m
//  JWGCD_Demo
//
//  Created by JackWong on 14/7/23.
//  Copyright (c) 2014年 Jack Wong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
            
@property (strong, nonatomic) NSArray *btnTitleArray;
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.btnTitleArray = @[@"Serial Queue", @"Concurrent Queue", @"延迟3秒第一种", @"延迟3秒第二种", @"组任务执行完毕，执行某个任务", @"barrier", @"重复执行任务", @"单一执行任务", @"同步或异步", @"函数指针", @"执行函数"];
    [self performSelector:@selector(setUpButtons) withObject:nil afterDelay:0.0];
}

- (void)setUpButtons
{
    CGFloat topScreenMargin = 60.0;
    CGFloat leftMargin = 5.0;
    CGFloat topMargin = 30.0;
    CGFloat btnWidth = 95;
    CGFloat btnHeight =40.0;
    for (int i = 0; i <10; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor grayColor]];
        [button setFrame:CGRectMake(leftMargin+(i%3)*(btnWidth+leftMargin), topMargin+(i/3)*(btnHeight + topMargin)+topScreenMargin, btnWidth, btnHeight)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:self.btnTitleArray[i] forState:UIControlStateNormal];
        [button setTitle:self.btnTitleArray[i] forState:UIControlStateHighlighted];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.layer.cornerRadius = 3.0;
        button.layer.masksToBounds = YES;
        button.tag = i;
        [self.view addSubview:button];
        
    }
}
- (void)buttonAction:(id)sender
{
   NSUInteger tagInteger =  ((UIButton*)sender).tag;
    switch (tagInteger) {
        case 0:
            [self serialQueue];
            break;
        case 1:
            [self concurrentQueue];
            break;

        case 2:
            [self delayGCD];
            break;

        case 3:
            [self jwWait];
            break;

        case 4:
            [self groupGCD];
            break;

        case 5:
            [self barrier];
            break;

        case 6:
            [self apply];
            break;

        case 7:
            [self once];
            break;

        case 8:
            [self synOrAsyn];
            break;
        case 9:
            [self function];
            break;

            
        default:
            break;
    }
}
- (void)serialQueue
{
    /*
     serial queue（串行队列）特点：执行完queue中第一个任务，执行第二个任务，执行完第二个任务，执行第三个任务，以此类推，任何一个任务的执行，必须等到上个任务执行完毕。
     获得serial queue的方式有2种：
     1、获得mainQueue。mainQueue会在主线程中执行，即：主线程中执行队列中的各个任务
     2、自己创建serial queue。//自己创建的serial queue不会在主线程中执行，queue会开辟一个子线程，在子线程中执行队列中的各个任务
     */
    dispatch_queue_t mySerialQueue = dispatch_queue_create("com.jwdemo_gcd.www", DISPATCH_QUEUE_SERIAL);
    dispatch_async(mySerialQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第1个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(mySerialQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第2个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(mySerialQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第3个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(mySerialQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第4个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(mySerialQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第5个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    
}
- (void)concurrentQueue
{
    /*
     concurrent queue（并行队列）特点：队列中的任务，第一个先执行，不等第一个执行完毕，第二个就开始执行了，不等第二个任务执行完毕，第三个就开始执行了，以此类推。后面的任务执行的晚，但是不会等前面的执行完才执行。
     获得concurrent queue的方法有2种：
     1、获得global queue。
     2、自己创建concurrent queue。
     */
    
    
    //global queue
    //第一个参数控制globalQueue的优先级，一共有4个优先级DISPATCH_QUEUE_PRIORITY_HIGH、DISPATCH_QUEUE_PRIORITY_DEFAULT、DISPATCH_QUEUE_PRIORITY_LOW、DISPATCH_QUEUE_PRIORITY_BACKGROUND。第二个参数是苹果预留参数，未来会用，目前填写为0。global queue会根据需要开辟若干个线程，并行执行队列中的任务（开始较晚的任务未必最后结束，开始较早的任务未必最先完成），开辟的线程数量取决于多方面因素，比如：任务的数量，系统的内存资源等等，会以最优的方式开辟线程---根据需要开辟适当的线程。
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(globalQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第1个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(globalQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第2个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(globalQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第3个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(globalQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第4个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(globalQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第5个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(globalQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第6个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(globalQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第7个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(globalQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第8个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(globalQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第9个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(globalQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第10个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
}

- (void)delayGCD
{
    //dispatch_after函数是延迟执行某个任务，任务既可以在mainQueue中进行也可以在其他queue中进行。既可以在serial队列里执行也可以在concurrent队列里执行。
    
    /*
     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
     NSLog(@"Hello");
     });
     */
    double delayInSenconds = 3.0;
    dispatch_time_t deplayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSenconds * NSEC_PER_SEC));
    dispatch_queue_t myDelayQueue = dispatch_queue_create("com.jwdemo_gcd.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_after(deplayTime, myDelayQueue, ^(void){
        NSLog(@"delayGCD");
    });
}
- (void)jwWait
{
    //dispatch_semaphore_create 创建一个semaphore
    //dispatch_semaphore_signal 发送一个信号
    //dispatch_semaphore_wait   等待信号
    
//    dispatch_group_t globalGroup = dispatch_group_create();
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    for (int i = 0; i < 100; i++)
//    {
//        //当线程收到semaphore信号时，才会继续向下执行。若没有收到信号，程序会永远的等待。
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        
//        dispatch_group_async(globalGroup, queue, ^{//在block里写要执行的任务（代码）
//            NSLog(@"第%i个任务，所在线程%@，是否是主线程：%d", i, [NSThread currentThread], [[NSThread currentThread] isMainThread]);
//            
//            //让程序睡眠3秒（延迟3秒）
//            sleep(3);
//            
//            //给线程发送semaphore信号
//            dispatch_semaphore_signal(semaphore);
//        });
//    }
//    
//    //等待组任务全部完成
//    dispatch_group_wait(globalGroup, DISPATCH_TIME_FOREVER);
    
    dispatch_group_t testGroup = dispatch_group_create();
    dispatch_semaphore_t testSemaphore = dispatch_semaphore_create(10);
    dispatch_queue_t myQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 100; i++) {
        dispatch_semaphore_wait(testSemaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(testGroup, myQueue, ^{
           
            NSLog(@"第%i个任务，所在线程%@，是否是主线程：%d", i, [NSThread currentThread], [[NSThread currentThread] isMainThread]);
            sleep(3);
            dispatch_semaphore_signal(testSemaphore);
        });
    }
    dispatch_group_wait(testGroup, DISPATCH_TIME_FOREVER);
}

- (void)groupGCD
{
    dispatch_group_t jwGroup = dispatch_group_create();
    dispatch_queue_t myQueue = dispatch_queue_create("com.myqueue.www", DISPATCH_QUEUE_CONCURRENT);
    
    //dispatch_group_async用于把不同的任务归为一组
    dispatch_group_async(jwGroup, myQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第1个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_group_async(jwGroup, myQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第2个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_group_async(jwGroup, myQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第3个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_group_async(jwGroup, myQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第4个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_group_async(jwGroup, myQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第5个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_group_async(jwGroup, myQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"第6个任务，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    
    //dispatch_group_notify当指定组的任务执行完毕之后，执行给定的任务
    dispatch_group_notify(jwGroup, myQueue, ^{
        NSLog(@"group中的任务都执行完毕之后，执行此任务。所在线程%@,是否是主线程:%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });

}
- (void)barrier
{
    //为了保证访问同一个数据时，数据的安全，我们可以使用serial queue解决数据安全访问的问题。
    //serial queue的缺陷是：后面的任务 必须等待 前面的任务 执行完毕 才能执行
    //对于往数据库写入数据 使用serial queue无疑能保证数据的安全。
    //对于从数据库中读取数据，使用serial queue就不太合适了，效率比较低。使用concurrent queue无疑是最合适的。
    //真实的项目中，通常既有对数据库的写入，又有数据库的读取。如何处理才最合适呢？
    
    //下面给出了 既有数据库数据读取，又有数据库数据写入的处理方法dispatch_barrier_async
    dispatch_queue_t myConcurrentQueue = dispatch_queue_create("com.PF_Lib.GCD.myConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(myConcurrentQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"读取第1个数据，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(myConcurrentQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"读取第2个数据，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(myConcurrentQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"读取第3个数据，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(myConcurrentQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"读取第4个数据，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    
    //dispatch_barrier_async就像一道墙，之前的任务都并行执行，执行完毕之后，执行barrier中的任务，之后的任务也是并行执行。
    dispatch_barrier_async(myConcurrentQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"写入某些数据，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    
    dispatch_async(myConcurrentQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"读取第5个数据，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(myConcurrentQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"读取第6个数据，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(myConcurrentQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"读取第7个数据，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
    dispatch_async(myConcurrentQueue, ^{//在block里写要执行的任务（代码）
        NSLog(@"读取第8个数据，所在线程%@，是否是主线程：%d", [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
}

- (void)apply
{
    //GCD中提供了API让某个任务执行若干次。
    NSArray *array = [NSArray arrayWithObjects:@"红楼梦", @"水浒传", @"三国演义", @"西游记", nil];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_apply([array count], queue, ^(size_t index) {
//        NSLog(@"%@，所在线程%@，是否是主线程：%d", [array objectAtIndex:index], [NSThread currentThread], [[NSThread currentThread] isMainThread]);
//    });
    dispatch_apply(array.count, queue, ^(size_t index){
        NSLog(@"%@，所在线程%@，是否是主线程：%d", [array objectAtIndex:index], [NSThread currentThread], [[NSThread currentThread] isMainThread]);
    });
//    dispatch_apply_f(array.count, queue, <#void *context#>, void (*work)(void *, size_t))
}


- (void)once
{
    
    
    //dispatch_once用于定义那些只需要执行一次的代码，比如单例的创建
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSLog(@"只执行一次");
        //这个block里的代码，在程序执行过程中只会执行一次。
        //比如在这里些单例的初始化
        //        static YourClass *instance = nil;
        //        instance = [[YourClass alloc] init];
    });
}

#pragma mark - 同步和异步

- (void)synOrAsyn
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
     //dispatch_sync必须等block执行完，才继续执行dispatch_sync后面的代码
     dispatch_sync(queue, ^{
     for (int i = 0; i < 10; i++) {
     NSLog(@"%d", i);
     }
     });
     NSLog(@"JWDemo_sync");
    
    
    
    //dispatch_async无需等block执行完，继续执行dispatch_async后面的代码
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"%d", i);
        }
    });
    NSLog(@"JWDemo-async");
}
#pragma mark - 函数指针

- (void)function
{
    //dispatch_async_f往队列里放函数指针，队列控制相应函数的执行，不在是控制block的执行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //函数指针对应的函数类型：必须没有返回值，参数必须是void *。函数指针对应的参数，由dispatch_async_f第二个参数提供，可以是任意对象类型。
    dispatch_async_f(queue, @"JWDemo_GCD", function);
}

void function(void *context)
{
    NSLog(@"%@，所在线程%@，是否是主线程：%d", context, [NSThread currentThread], [[NSThread currentThread] isMainThread]);
}

#pragma mark - 重
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
