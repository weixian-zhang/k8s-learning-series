package main

import (
	"github.com/bxcodec/faker/v3"
	"math/rand"
)

var skillsetCatelog = []string{"plumbing", "electrical", "carpentry", "painting", "gardening", "general fixing", "lockpick"}

type Handyman struct {
	Name     string
	Phone    string
	Skillset []string
}

func (h *Handyman) New() Handyman {
	hm := Handyman{}

	hm.Skillset = generateRandSkill()
	hm.Name = faker.FirstName()
	hm.Phone = faker.Phonenumber()

	return hm
}

func (h *Handyman) NewMany(num int) []Handyman {

	handymen := []Handyman{}

	for i := 0; i < num; i++ {
		handymen = append(handymen, h.New())
	}

	return handymen
}

func generateRandSkill() []string {
	min := 0
	max := len(skillsetCatelog) - 1

	skills := []string{}

	randNumOfSkills := rand.Intn(max - min)

	for i := 0; i < randNumOfSkills; i++ {
		randSkillIdx := rand.Intn(max - min)

		randSkill := skillsetCatelog[randSkillIdx]

		skills = append(skills, randSkill)
	}

	return skills
}
