/*
 * mm.c
 *
 * Name: [Brendan Kenney]
 *
 * For the overall solution for checkpoint one, the main idea was to use a segregated list implementation
 * To do this, I used 12 lists which store range of sizes specified in select_list function
 * While traversing to find a good block, I used first-fit method to help speed up throughput a lot
 * That was the overall main idea, but details for each instructions are in comments directly above each function
 */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdbool.h>
#include <stdint.h>
#include <math.h>

#include "mm.h"
#include "memlib.h"

/*
 * If you want to enable your debugging output and heap checker code,
 * uncomment the following line. Be sure not to have debugging enabled
 * in your final submission.
 */
//#define DEBUG

#ifdef DEBUG
/* When debugging is enabled, the underlying functions get called */
#define dbg_printf(...) printf(__VA_ARGS__)
#define dbg_assert(...) assert(__VA_ARGS__)
#else
/* When debugging is disabled, no code gets generated */
#define dbg_printf(...)
#define dbg_assert(...)
#endif /* DEBUG */

/* do not change the following! */
#ifdef DRIVER
/* create aliases for driver tests */
#define malloc mm_malloc
#define free mm_free
#define realloc mm_realloc
#define calloc mm_calloc
#define memset mem_memset
#define memcpy mem_memcpy
#endif /* DRIVER */

/* What is the correct alignment? */
#define ALIGNMENT 16

static uint64_t *start_header;
static uint64_t *end_footer;

/* rounds up to the nearest multiple of ALIGNMENT */
static size_t align(size_t x)
{
    return ALIGNMENT * ((x+ALIGNMENT-1)/ALIGNMENT);
}

//structure we store at the beginning of each free payload
struct node{
    struct node* next;
    struct node* prev;
};
//array holding 12 pointers which point to start of each doubly linked list
//each lists is assigned a range of size values in bytes
struct node* lists[12];

//function definitions
static void add_node(struct node* new, int list_num);
static void remove_node(struct node* victim, int list_num);
static int select_list(size_t size);
static void set_hdrftr(uint64_t* ptr, size_t size, bool alloc);
static size_t get_size(uint64_t* ptr);
static void* get_ptr(size_t size, int list_num);
static void split(void* ptr, size_t best_size, size_t size, int list_num);
static bool extend_heap(size_t increment);
static void coalesce(uint64_t* hdr, size_t current_size);


/* add_node
 * adds a node to the start of the list
 * we know which list by the index passed in as an argument
 */
static void add_node(struct node* new, int list_num){
    struct node* start = lists[list_num];

    new->prev = NULL;
    new->next = start;
    if(start != NULL){
        start->prev = new;
    }
    lists[list_num] = new;
}

/* remove_node
 * removes the node at the pointer values
 * the neighbor nodes next and prev are altered so the removal doesn't affect the overall linked list
 */
static void remove_node(struct node* victim, int list_num){
    if(victim->prev != NULL){
        victim->prev->next = victim->next;
    }else{
        lists[list_num] = victim->next;
    }
    if(victim->next != NULL){
        victim->next->prev = victim->prev;
    }
}

/* select_list
 * returns the list index based off the size given
 */
static int select_list(size_t size){
    if(size < pow(2,6)){
        return 0;
    }else if(size < pow(2,8)){
        return 1;
    }else if(size < pow(2,10)){
        return 2;
    }else if(size < pow(2,12)){
        return 3;
    }else if(size < pow(2,14)){
        return 4;
    }else if(size < pow(2,15)){
        return 5;
    }else if(size < pow(2,16)){
        return 6;
    }else if(size < pow(2,17)){
        return 7;
    }else if(size < pow(2,18)){
        return 8;
    }else if(size < pow(2,19)){
        return 9;
    }else if(size < pow(2,20)){
        return 10;
    }else{
        return 11;
    }
}

/* split
 * splits the block if there is more than 24 extra bytes
 * we remove the node from the lists its in
 * the new headers and footers are then set with their new split sizes
 * and then we add the free split node to a list
 */
static void split(void* ptr_n, size_t best_size, size_t size, int list_num){
    uint64_t* ptr = (uint64_t*)ptr_n;
    if(best_size - size < 24){
        remove_node((struct node*)ptr, list_num);
        set_hdrftr(ptr - 1, best_size, 1);
        set_hdrftr(ptr + (best_size/8) - 2, best_size, 1);
    }else{
        remove_node((struct node*)ptr, list_num);
        //printf("ptr: %p\n1: %p\n2: %p\n3: %p\n4: %p\n", ptr, ptr - 1, ptr + (size/8) - 2, ptr + (size/8) - 1, ptr + (best_size/8) - 2);
        set_hdrftr(ptr - 1, size, 1);//sets 1st header
        set_hdrftr(ptr + (size/8) - 2, size, 1);//sets 1st footer
        set_hdrftr(ptr + (size/8) - 1, best_size - size, 0);//sets second header
        set_hdrftr(ptr + (best_size/8) - 2, best_size - size, 0);//sets second footer
        list_num = select_list(best_size - size);
        add_node((struct node*)(ptr + (size/8)), list_num);

    }
}

/* set_hdrftr
 * sets the header and footer to new value based off size and alloc which are passed as arguments
 */
static void set_hdrftr(uint64_t* ptr, size_t size, bool alloc){
    *ptr = (size * 2) | alloc;
}

/* get_size
 * returns the size of the block where payload is located
 * since we pass in payload pointer, we have to go back 8 bytes to the header
 * this is why we do ptr - 1
 */
static size_t get_size(uint64_t* ptr){
    return (size_t)(*(ptr - 1) >> 1);
}

/* extend_heap
 * when there is a need for more space in the heap, this function is called
 * we want to align the increment so that we will always be aligned whenever we call this function
 * a call to mem_sbrk is made and we store the pointer returned
 * the header and footer of this new area are set with correct sizes
 * this new block is added to the correct list based on size and then we coalesce
 */
static bool extend_heap(size_t increment){
    increment = align(increment);
    void* new_area = mem_sbrk(increment);
    if(new_area == (void*)-1){
        return false;
    }
    uint64_t* ptr = (uint64_t*)new_area;
    *ptr = increment * 2;
    *(ptr + (increment/8) - 1) = increment * 2;
    end_footer = mem_heap_hi() - 1;
    int list_num = select_list(increment);
    add_node((struct node*)(ptr + 1), list_num);
    coalesce(ptr, increment);
    return true;
}

/* coalesce
 * In simple terms, this function is checking if the previous and/or next headers are allocated or not
 * this leaves us with 3 cases: both are free, prev is free, or next is free
 * thats what those three if/else-if statements take care of
 * for each case we remove the blocks we need to and then set the new larger block's hdrs and ftrs
 * the new block is then added to the appropriate list
 */
static void coalesce(uint64_t* hdr, size_t current_size){
    uint64_t* prev_ftr = hdr - 1;
    uint64_t* next_hdr = hdr + (current_size/8);
    size_t total_size;
    size_t next_size = get_size(next_hdr + 1);
    size_t prev_size = get_size(prev_ftr + 1);
    int list_num;
    int list_num_prev = select_list(prev_size);
    int list_num_curr = select_list(current_size);
    int list_num_next = select_list(next_size);

    if(((*prev_ftr & 1) == 0) && ((*next_hdr & 1) == 0) && (next_hdr < end_footer) && (prev_size != 0) && ((int)next_size != 0)){
        total_size = current_size + next_size + prev_size;
        *(hdr - (prev_size/8)) = total_size * 2;
        *(prev_ftr - (prev_size/8) + (total_size/8)) = total_size * 2;
        list_num = select_list(total_size);
        remove_node((struct node*)(hdr - (prev_size/8) + 1), list_num_prev);
        remove_node((struct node*)(hdr + 1), list_num_curr);
        remove_node((struct node*)(next_hdr + 1), list_num_next);
        add_node((struct node*)(hdr - (prev_size/8) + 1), list_num);

    }else if(((*next_hdr & 1) == 0)  && (next_hdr < end_footer) && ((int)next_size != 0)){
        total_size = current_size + next_size;
        *hdr = total_size * 2;
        *(hdr + (total_size/8) - 1) = total_size * 2;
        list_num = select_list(total_size);
        remove_node((struct node*)(next_hdr + 1), list_num_next);
        remove_node((struct node*)(hdr + 1), list_num_curr);
        add_node((struct node*)(hdr + 1), list_num);

    }else if(((*prev_ftr & 1) == 0) && ((int)prev_size != 0)){
        total_size = current_size + prev_size;
        *(hdr - (prev_size/8)) = total_size * 2;
        *(prev_ftr - (prev_size/8) + (total_size/8)) = total_size * 2;
        list_num = select_list(total_size);
        remove_node((struct node*)(hdr - (prev_size/8) + 1), list_num_prev);
        remove_node((struct node*)(hdr + 1), list_num_curr);
        add_node((struct node*)(hdr - (prev_size/8) + 1), list_num);
    }
    return;
}

/* get_ptr
 * This function is called straight from malloc
 * In here, the list is traversed until we find the first blocks which is begin enough
 * when we do, that blocks ptr and size are stored for when we call split
 * split is called only when we have a valid pointer
 */
static void* get_ptr(size_t size, int list_num){
    struct node* block = lists[list_num];
    void* ptr = (void*)-1;
    size_t current_block_size = 0;
    while(block != NULL){
        current_block_size = get_size((uint64_t*)block);
        if(current_block_size >= size){
            ptr = (void*)block;
            break;
        }
        block = block->next;
    }
    if(ptr != (void*)-1){
        //split(ptr, best_size, size, list_num);
        split(ptr, current_block_size, size, list_num);
    }
    return (void*)ptr;
}


/*
 * Initialize: returns false on error, true on success.
 * First we essentially create the heap by incrementing it
 * We then initialize our header and footer
 * We then set the values of the header and footer correctly
 * the contents of the list array are all initialized to NULL
 * the pointer for list with index 1 adds a node which at the point of initialization, is the entire size of the heap
 */
bool mm_init(void)
{
    /* IMPLEMENT THIS */
    size_t start_size = align(pow(10,2)) + 8;
    if((mem_sbrk(start_size)) == (void *)-1){
        return false;
    }
    start_header = mem_heap_lo() + 8;
    end_footer = mem_heap_hi() - 8;
    *start_header = (mem_heapsize() - 8) * 2;
    *end_footer = *start_header;

    int i;
    for(i = 0; i < 12; i++){
        lists[i] = NULL;
    }

    add_node((struct node*)(start_header + 1), 1);

    return true;
}

/*
 * malloc
 * We return NULL if size == 0
 * We then align our size to 16 bytes and add 16 more bytes for our header and footer
 * The call get_ptr in while loop with appropriate list index passed in
 * The while loop will continue until a valid ptr is returned 
 * each traversal, the list index is increased by 1
 * we expand the heap only after each list is looked at but no valid ptr is returned
 */
void* malloc(size_t size)
{
    /* IMPLEMENT THIS */
    if(size == 0){
        return NULL;
    }
    void* ptr = (void*)-1;
    size_t new_size = align(size) + 16;
    int list = select_list(new_size);
    while(list < 12){
        ptr = get_ptr(new_size, list);
        if(ptr == (void*)-1){
            list++;
        }else{
            break;
        }
    }
    if((ptr == (void*)-1)){
        if(!extend_heap(2 * new_size)){
            return NULL;
        }
        return malloc(size);
    }
    return (void*)ptr;
}

/*
 * free
 * We first store the header of the given pointer to a new pointer called start.
 * Next, the header and footer of the pointer have their allocated bit changed to 0 in set_hdrftr func.
 * since the block is free, it is then added to the appropriate list with add_node
 * coalesce is called at the end
 */
void free(void* ptr)
{
    uint64_t* start = ((uint64_t*)ptr) - 1;
    if(ptr == NULL || ((*start & 1) == 0)){
        return;
    }
    size_t size = get_size((uint64_t*)ptr);
    int list = select_list(size);
    set_hdrftr(((uint64_t*)ptr) - 1, size, 0);//sets header alloc bit to 0
    set_hdrftr(((uint64_t*)ptr) + (size/8) - 2, size, 0);//sets footer alloc bit to 0
    add_node((struct node*)ptr, list);
    coalesce(start, size);
}

/*
 * realloc
 * First, we take care of some base cases. If oldptr is NULL, we do a malloc call and if size is 0, we do a free call.
 * After base cases, we call malloc with the new size the user wants allocated. This is stored into a new_ptr.
 * We then calculate the size of the payload of the oldptr.
 * If the oldsize < new size, we copy all the payload bytes from the oldptr into the new_ptr.
 * If not, we only copy new_size payload bytes from oldptr to new_ptr
 * After that, the oldptr is freed and we return our new_ptr
 */
void* realloc(void* oldptr, size_t size)
{
    /* IMPLEMENT THIS */
    if(oldptr == NULL){
        return malloc(size);
    }
    if(size == 0){
        free(oldptr);
        return NULL;
    }
    size_t oldsize = get_size((uint64_t*)oldptr) - 16;
    uint64_t* new_ptr = (uint64_t*)malloc(size);
    if(new_ptr == NULL){
        return NULL;
    }
    if(oldsize < size){
        memcpy((void*)new_ptr, oldptr, oldsize);
    }else{
        memcpy((void*)new_ptr, oldptr, size);
    }
    free(oldptr);
    return (void*)new_ptr;
}

/*
 * calloc
 * This function is not tested by mdriver, and has been implemented for you.
 */
void* calloc(size_t nmemb, size_t size)
{
    void* ptr;
    size *= nmemb;
    ptr = malloc(size);
    if (ptr) {
        memset(ptr, 0, size);
    }
    return ptr;
}

/*
 * Returns whether the pointer is in the heap.
 * May be useful for debugging.
 */
static bool in_heap(const void* p)
{
    return p <= mem_heap_hi() && p >= mem_heap_lo();
}

/*
 * Returns whether the pointer is aligned.
 * May be useful for debugging.
 */
static bool aligned(const void* p)
{
    size_t ip = (size_t) p;
    return align(ip) == ip;
}

/*
 * mm_checkheap
 * I think that the most important thing is that every payload is aligned to 16 bytes
 * Things can go bad if they aren't with a lot of errors
 * That's why this function checks if each payload is 16 byte aligned
 * All it does is traverse to each header and make sure each size stored there is a 16 byte aligned size
 * we know that the payload is since it is aligned in the very beginning during initialization
 */
bool mm_checkheap(int lineno)
{
#ifdef DEBUG
    /* Write code to check heap invariants here */
    /* IMPLEMENT THIS */
    
    uint64_t *ptr = mem_heap_lo() + 1;
    while(ptr != mem_heap_hi()){
        size_t size = *ptr >> 1;
        if(align(size) != size){
            return false;
        }
        if((*ptr & 1) == 0){
            struct node* payload = (struct node*)(ptr + 1);
            struct node* next = payload->next;
            struct node* prev = payload->prev;
            if(((void*)prev == (void*)-1) || ((void*)next == (void*)-1) || ((void*)prev > (void*)end_footer) || ((void*)next > (void*)end_footer)){
                return false;
            }
        }
        ptr += size;
        
    }
#endif /* DEBUG */
    return true;
}
