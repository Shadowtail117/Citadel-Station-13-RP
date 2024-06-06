/datum/reagent/blood
	data = new/list("donor" = null, "viruses" = null, "species" = SPECIES_HUMAN, "blood_DNA" = null, "blood_type" = null, "blood_colour" = "#A10808", "resistances" = null, "trace_chem" = null, "antibodies" = list())
	name = "Blood"
	id = "blood"
	taste_description = "iron"
	taste_mult = 1.3
	reagent_state = REAGENT_LIQUID
	metabolism = REM * 5
	mrate_static = TRUE
	affects_dead = 1 //so you can pump blood into someone before defibbing them
	color = "#C80000"
	var/volume_mod = 1	// So if you add different subtypes of blood, you can affect how much vessel blood each unit of reagent adds
	blood_content = 4 //How effective this is for vampires.

	glass_name = "tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

/datum/reagent/blood/initialize_data(newdata)
	..()
	if(data && data["blood_colour"])
		color = data["blood_colour"]
	return

/datum/reagent/blood/get_data() // Just in case you have a reagent that handles data differently.
	var/t = data.Copy()
	if(t["virus2"])
		var/list/v = t["virus2"]
		t["virus2"] = v.Copy()
	return t

/datum/reagent/blood/touch_turf(turf/simulated/T)
	if(!istype(T) || volume < 3)
		return
	if(!data["donor"] || istype(data["donor"], /mob/living/carbon/human))
		blood_splatter(T, src, 1)
	else if(istype(data["donor"], /mob/living/carbon/alien))
		var/obj/effect/debris/cleanable/blood/B = blood_splatter(T, src, 1)
		if(B)
			B.blood_DNA["UNKNOWN DNA STRUCTURE"] = "X*"

/datum/reagent/blood/affect_ingest(mob/living/carbon/M, alien, removed)

	var/effective_dose = dose
	if(issmall(M)) 
		effective_dose *= 2

	var/nutritionvalue = 10 //for reference, normal nutrition has a value of about 30.
	var/is_vampire = M.species.is_vampire
	switch(alien) //unique interactions sorted from the species who benefit the least to the species who benefit the most.
		if(IS_SKRELL) //arguing that blood is "meat" and is still toxic for the vegan skrell at least
			if(effective_dose > 5)
				if(!is_vampire) //a vetalan skrell sounds funny as hell
					M.adjustToxLoss(removed)
			if(effective_dose > 15)
				if(!is_vampire)
					M.adjustToxLoss(removed)
		if(IS_SLIME)
			nutritionvalue = 20
			if(data["species"] == M.species.name) //just 'inject' the blood if it happens to be promethean "blood".
				M.inject_blood(src, volume * volume_mod)
				remove_self(volume)
				return
		if(IS_TESHARI) //birb.
			nutritionvalue = 30
		if(IS_UNATHI) //carnivorous lizord...
			nutritionvalue = 45
		if(IS_ALRAUNE) //lorewise, alraune are meant to enjoy blood.
			nutritionvalue = 60
		if(IS_CHIMERA) //obligate carnivores.
			nutritionvalue = 80

	if(is_vampire)
		handle_vampire(M, alien, removed, is_vampire)
		M.heal_organ_damage(0.7 * removed * volume_mod, 0) // Heals vampires more.
		M.adjust_hydration(7 * removed) // Hydrates vetalan better.
		M.add_chemical_effect(CE_BLOODRESTORE, 8 * removed) // Same rating as taking iron
	else
		M.adjust_nutrition(nutritionvalue * removed * volume_mod)
		M.heal_organ_damage(0.2 * removed * volume_mod, 0)	// Heal brute slightly like normal nutrition. More 'effective' blood means more usable material.
		M.adjust_hydration(2 * removed) // Still has some water in the form of plasma. Hydrates less than a normal drink.
		M.add_chemical_effect(CE_BLOODRESTORE, 4 * removed) //same rating as eating nutriment

	if(data && data["virus2"])
		var/list/vlist = data["virus2"]
		if(vlist.len)
			for(var/ID in vlist)
				var/datum/disease2/disease/V = vlist[ID]
				if(V.spreadtype == "Contact")
					infect_virus2(M, V.getcopy())

/datum/reagent/blood/affect_touch(mob/living/carbon/M, alien, removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.isSynthetic())
			return
	if(alien == IS_SLIME)
		affect_ingest(M, alien, removed)
		return
	if(data && data["virus2"])
		var/list/vlist = data["virus2"]
		if(vlist.len)
			for(var/ID in vlist)
				var/datum/disease2/disease/V = vlist[ID]
				if(V.spreadtype == "Contact")
					infect_virus2(M, V.getcopy())
	if(data && data["antibodies"])
		M.antibodies |= data["antibodies"]

/datum/reagent/blood/affect_blood(mob/living/carbon/M, alien, removed)
	if(alien == IS_SLIME) //They don't have blood, so it seems weird that they would instantly 'process' the chemical like another species does.
		affect_ingest(M, alien, removed)
		return

	if(M.isSynthetic())
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		var/datum/reagent/blood/recipient = H.get_blood(H.vessel)

		if(recipient && blood_incompatible(data["blood_type"], recipient.data["blood_type"], data["species"], recipient.data["species"]))
			H.inject_blood(src, removed * volume_mod)

			if(!H.isSynthetic() && data["species"] == "synthetic") // Remember not to inject oil into your veins, it's bad for you.
				H.reagents.add_reagent("toxin", removed * 1.5)

			return

	M.inject_blood(src, volume * volume_mod)
	remove_self(volume)

/datum/reagent/blood/synthblood
	name = "Synthetic blood"
	id = "synthblood"
	color = "#999966"
	volume_mod = 2

/datum/reagent/blood/synthblood/initialize_data(newdata)
	..()
	if(data && !data["blood_type"])
		data["blood_type"] = "O-"
	return

/datum/reagent/blood/bludbloodlight
	name = "Synthetic blood"
	id = "bludbloodlight"
	color = "#999966"
	volume_mod = 2

/datum/reagent/blood/bludbloodlight/initialize_data(newdata)
	..()
	if(data && !data["blood_type"])
		data["blood_type"] = "AB+"
	return

// pure concentrated antibodies
/datum/reagent/antibodies
	data = list("antibodies"=list())
	name = "Antibodies"
	taste_description = "slime"
	id = "antibodies"
	reagent_state = REAGENT_LIQUID
	color = "#0050F0"
	mrate_static = TRUE

/datum/reagent/antibodies/affect_blood(mob/living/carbon/M, alien, removed)
	if(src.data)
		M.antibodies |= src.data["antibodies"]
	..()

/// How much heat is removed when applied to a hot turf, in J/unit (19000 makes 120 u of water roughly equivalent to 4L)
#define WATER_LATENT_HEAT 19000
/datum/reagent/water
	name = "Water"
	id = "water"
	taste_description = "water"
	description = "A ubiquitous chemical substance that is composed of hydrogen and oxygen."
	reagent_state = REAGENT_LIQUID
	color = "#0064C877"
	metabolism = REM * 10

	glass_name = "water"
	glass_desc = "The father of all refreshments."

	cup_name = "water"
	cup_desc = "The father of all refreshments."

/datum/reagent/water/touch_turf(turf/simulated/T)
	if(!istype(T))
		return

	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = T0C + 100 // 100C, the boiling point of water

	var/hotspot = (locate(/atom/movable/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_cell_volume()
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, volume * WATER_LATENT_HEAT, -environment.get_thermal_energy_change(min_temperature))
		environment.adjust_thermal_energy(-removed_heat)
		if (prob(5))
			T.visible_message("<span class='warning'>The water sizzles as it lands on \the [T]!</span>")

	else if(volume >= 10)
		T.wet_floor(1)

/datum/reagent/water/touch_obj(obj/O, amount)
	if(istype(O, /obj/item/reagent_containers/food/snacks/monkeycube))
		var/obj/item/reagent_containers/food/snacks/monkeycube/cube = O
		if(!cube.wrapped)
			cube.Expand()
	else
		O.water_act(amount / 5)
	var/effective = amount || 10
	O.clean_radiation(RAD_CONTAMINATION_CLEANSE_POWER * (effective / 10), RAD_CONTAMINATION_CLEANSE_FACTOR ** (1 / (effective / 10)))

/datum/reagent/water/touch_mob(mob/living/L, amount)
	if(istype(L))
		// First, kill slimes.
		if(istype(L, /mob/living/simple_mob/slime))
			var/mob/living/simple_mob/slime/S = L
			var/amt = 15 * amount * (1-S.water_resist)
			if(amt>0)
				S.adjustToxLoss(amt)
				S.visible_message("<span class='warning'>[S]'s flesh sizzles where the water touches it!</span>", "<span class='danger'>Your flesh burns in the water!</span>")

		// Then extinguish people on fire.
		var/needed = L.fire_stacks * 5
		if(amount > needed)
			L.ExtinguishMob()
		L.adjust_fire_stacks(-(amount / 5))
		remove_self(needed)
	var/effective = amount || 10
	L.clean_radiation(RAD_CONTAMINATION_CLEANSE_POWER * (effective / 10), RAD_CONTAMINATION_CLEANSE_FACTOR ** (1 / (effective / 10)))

/datum/reagent/water/affect_ingest(mob/living/carbon/M, alien, removed)
	//if(alien == IS_SLIME)
	//	M.adjustToxLoss(6 * removed)
	//else
	M.adjust_hydration(removed * 10)
	..()

/datum/reagent/fuel
	name = "Welding fuel"
	id = "fuel"
	description = "Required for welders. Flamable."
	taste_description = "gross metal"
	reagent_state = REAGENT_LIQUID
	color = "#660000"

	glass_name = "welder fuel"
	glass_desc = "Unless you are an industrial tool, this is probably not safe for consumption."

/datum/reagent/fuel/touch_turf(turf/T, amount)
	new /obj/effect/debris/cleanable/liquid_fuel(T, amount, FALSE)
	remove_self(amount)
	return

/datum/reagent/fuel/affect_blood(mob/living/carbon/M, alien, removed)
	if(issmall(M)) removed *= 2
	M.adjustToxLoss(4 * removed)

/datum/reagent/fuel/touch_mob(mob/living/L, amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / 10) // Splashing people with welding fuel to make them easy to ignite!
