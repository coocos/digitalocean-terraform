package main

import (
	"context"
	"log"
	"math/rand"
	"os"
	"os/signal"
	"time"

	"github.com/coocos/example/events"
	"github.com/coocos/example/queue"
)

func process(ctx context.Context, event events.Event) {
	select {
	case <-ctx.Done():
		log.Println("Terminating processing event:", event)
		return
	case <-time.After(time.Duration(rand.Intn(10)) * time.Second):
		log.Printf("Processed event %s: %s\n", event.Id, event.Title)
	}
}

func main() {
	log.Println("Starting event processor")
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt)
	defer stop()

	for event := range queue.ReadEvents(ctx) {
		log.Println("Received event:", event)
		process(ctx, event)
	}

	log.Println("Event processor stopped")
}
