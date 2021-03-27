/*
 * Timer Library
 *
 * The Library rely on timer drivers, the timer presented by the
 * timer driver must look like a down-counter timer, which generates
 * interrupt (if configured) when underflown.
 *
 * If Timer hardware is an up-counter the Timer driver must recalculate
 * into values that would match as if it was a down-counter.
 *
 */

struct tlib_dev;

typedef void (*tlib_isr_t)(int irqno, void *data);

struct tlib_drv {
	/*** Functions ***/
	void	(*reset)(struct tlib_dev *hand);
	void	(*get_freq)(
		struct tlib_dev *hand,
		unsigned int *basefreq,
		unsigned int *tickrate);
	int	(*set_freq)(struct tlib_dev *hand, unsigned int tickrate);
	void	(*irq_reg)(struct tlib_dev *hand, tlib_isr_t func, void *data);
	void	(*irq_unreg)(struct tlib_dev *hand, tlib_isr_t func,void *data);
	void	(*start)(struct tlib_dev *hand, int once);
	void	(*stop)(struct tlib_dev *hand);
	void	(*restart)(struct tlib_dev *hand);
	void	(*get_counter)(struct tlib_dev *hand, int *counter);
	int	(*custom)(struct tlib_dev *hand, int cmd, void *arg);
};

struct tlib_dev {
	struct tlib_dev *next;
	char status; /* 0=closed, 1=open, 2=timer started */
	char index; /* Timer Index */
	tlib_isr_t isr_func;
	void *isr_data;
	struct tlib_drv *drv;
};

#ifdef RTEMS_DRVMGR_STARTUP
/* Clock Driver Timer register function. Only used when the TLIB-Clock
 * driver is used. A specific Timer is 
 */
extern void Clock_timer_register(int timer_number);
#endif

/* Register Timer. Called by Timer Drivers in order to register
 * a Timer to the Timer Library. The registration order determines
 * the Timer Number used in tlib_open() to identify a specific
 * Timer.
 */
extern int tlib_dev_reg(struct tlib_dev *newdev);

/* Allocate a Timer.
 *
 * A Timer handle is returned identifying the timer in later calls.
 */
extern void *tlib_open(int timer_no);

/* Close Timer */
extern void tlib_close(void *hand);

/* Returns Number of Timers currently registered to Timer Library */
extern int tlib_ntimer(void);

static inline void tlib_reset(void *hand)
{
	struct tlib_dev *dev = hand;

	dev->drv->reset(dev);
}
/* Get Frequencies:
 *   - Base Frequency (unchangable base freq rate of timer, prescaler, clkinput)
 *   - Current Tick Rate [in multiples of Base Frequency]
 */
static inline void tlib_get_freq(
	void *hand,
	unsigned int *basefreq,
	unsigned int *tickrate)
{
	struct tlib_dev *dev = hand;

	dev->drv->get_freq(dev, basefreq, tickrate);
}

/* Set current Tick Rate in number of "Base-Frequency ticks" */
static inline int tlib_set_freq(void *hand, unsigned int tickrate)
{
	struct tlib_dev *dev = hand;

	return dev->drv->set_freq(dev, tickrate);
}

/* Register ISR at Timer ISR */
static inline void tlib_irq_unregister(void *hand)
{
	struct tlib_dev *dev = hand;

	if ( dev->isr_func ) {
		dev->drv->irq_unreg(dev, dev->isr_func, dev->isr_data);
		dev->isr_func = NULL;
	}
}

/* Register ISR at Timer ISR */
static inline void tlib_irq_register(void *hand, tlib_isr_t func, void *data)
{
	struct tlib_dev *dev = hand;

	/* Unregister previous ISR if installed */
	tlib_irq_unregister(hand);
	dev->isr_func = func;
	dev->isr_data = data;
	dev->drv->irq_reg(dev, func, data);
}

/* Start Timer, ISRs will be generated if enabled.
 *
 * once determines if timer should restart (=0) on underflow automatically,
 * or stop when underflow is reached (=1).
 */
static inline void tlib_start(void *hand, int once)
{
	struct tlib_dev *dev = hand;

	dev->drv->start(dev, once);
}

/* Stop Timer, no more ISRs will be generated */
static inline void tlib_stop(void *hand)
{
	struct tlib_dev *dev = hand;

	dev->drv->stop(dev);
}

/* Restart/Reload Timer, may be usefull if a Watchdog Timer */
static inline void tlib_restart(void *hand)
{
	struct tlib_dev *dev = hand;

	dev->drv->restart(dev);
}

/* Get current counter value (since last tick) */
static inline void tlib_get_counter(void *hand, int *counter)
{
	struct tlib_dev *dev = hand;

	dev->drv->get_counter(dev, counter);
}

/* Do a custom operation  */
static inline void tlib_custom(void *hand, int cmd, void *arg)
{
	struct tlib_dev *dev = hand;

	dev->drv->custom(dev, cmd, arg);
}
