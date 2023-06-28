package main

import (
	"github.com/gofiber/fiber/v2"
)

func startWebServer() {

	hm := Handyman{}

	app := fiber.New()

	app.Get("/handymantracker/list", func(c *fiber.Ctx) error {
		handymen := hm.NewMany(10)

		return c.JSON(handymen)
	})

	app.Listen(":5000")
}
