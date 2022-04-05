package queue

import (
	"context"
	"encoding/json"
	"errors"
	"log"
	"os"
	"time"

	"github.com/coocos/example/events"
	"github.com/go-redis/redis/v8"
)

type queueSettings struct {
	redisAddress    string
	redisEventQueue string
}

func readSettings() queueSettings {
	return queueSettings{
		redisAddress:    os.Getenv("REDIS_ADDRESS"),
		redisEventQueue: os.Getenv("REDIS_EVENT_QUEUE"),
	}
}

// ReadEvents returns a channel of events
func ReadEvents(ctx context.Context) <-chan events.Event {

	queue := make(chan events.Event)

	settings := readSettings()
	rdb := redis.NewClient(&redis.Options{
		Addr: settings.redisAddress,
	})

	go func() {
		defer close(queue)
		for {
			val, err := rdb.BLPop(ctx, time.Hour, settings.redisEventQueue).Result()
			if err != nil && !errors.Is(err, redis.Nil) {
				log.Println("Stopping reading events:", err)
				return
			}
			// Timed out
			if len(val) == 0 {
				continue
			}
			var event events.Event
			err = json.Unmarshal([]byte(val[1]), &event)
			if err != nil {
				log.Println("Failed to unmarshal event:", err, val)
				continue
			}
			queue <- event
		}
	}()

	return queue
}
