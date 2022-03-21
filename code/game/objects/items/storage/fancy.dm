/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *
 * Contains:
 *		Donut Box
 *		Egg Box
 *		Candle Box
 *		Crayon Box
 *		Cigarette Box
 *		Vial Box
 *		Box of Chocolates
 */

/obj/item/storage/fancy/
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox6"
	name = "donut box"
	var/icon_type = "donut"
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/storage/fancy/update_icon(var/itemremoved = 0)
	var/total_contents = contents.len - itemremoved
	icon_state = "[icon_type]box[total_contents]"
	return

/obj/item/storage/fancy/examine(mob/user)
	. = ..()
	if(contents.len <= 0)
		. += "There are no [icon_type]s left in the box."
	else if(contents.len == 1)
		. += "There is one [icon_type] left in the box."
	else
		. += "There are [contents.len] [icon_type]s in the box."

	return

/*
 * Egg Box
 */

/obj/item/storage/fancy/egg_box
	icon = 'icons/obj/food.dmi'
	icon_state = "eggbox"
	icon_type = "egg"
	name = "egg box"
	storage_slots = 12
	max_storage_space = 12 * ITEMSIZE_COST_SMALL
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/boiledegg
		)
	starts_with = list(/obj/item/reagent_containers/food/snacks/egg = 12)

/*
 * Candle Boxes
 */

/obj/item/storage/fancy/candle_box
	name = "red candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	icon_type = "candle"
	item_state = "candlebox5"
	throwforce = 2
	slot_flags = SLOT_BELT
	max_storage_space = ITEMSIZE_COST_SMALL * 5
	starts_with = list(/obj/item/flame/candle = 5)

/obj/item/storage/fancy/whitecandle_box
	name = "white candle pack"
	desc = "A pack of white candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "whitecandlebox5"
	icon_type = "whitecandle"
	item_state = "whitecandlebox5"
	throwforce = 2
	slot_flags = SLOT_BELT
	max_storage_space = ITEMSIZE_COST_SMALL * 5
	starts_with = list(/obj/item/flame/candle/white = 5)

/obj/item/storage/fancy/blackcandle_box
	name = "black candle pack"
	desc = "A pack of black candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "blackcandlebox5"
	icon_type = "blackcandle"
	item_state = "blackcandlebox5"
	throwforce = 2
	slot_flags = SLOT_BELT
	max_storage_space = ITEMSIZE_COST_SMALL * 5
	starts_with = list(/obj/item/flame/candle/black = 5)


/*
 * Crayon Box
 */

/obj/item/storage/fancy/crayons
	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonbox"
	w_class = ITEMSIZE_SMALL
	icon_type = "crayon"
	can_hold = list(
		/obj/item/pen/crayon
	)
	starts_with = list(
		/obj/item/pen/crayon/red,
		/obj/item/pen/crayon/orange,
		/obj/item/pen/crayon/yellow,
		/obj/item/pen/crayon/green,
		/obj/item/pen/crayon/blue,
		/obj/item/pen/crayon/purple
	)

/obj/item/storage/fancy/crayons/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/storage/fancy/crayons/update_icon()
	var/mutable_appearance/ma = new(src)
	ma.overlays = list()
	for(var/obj/item/pen/crayon/crayon in contents)
		ma.overlays += image('icons/obj/crayons.dmi',crayon.colourName)
	appearance = ma

/obj/item/storage/fancy/crayons/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/pen/crayon))
		switch(W:colourName)
			if("mime")
				to_chat(user, "This crayon is too sad to be contained in this box.")
				return
			if("rainbow")
				to_chat(user, "This crayon is too powerful to be contained in this box.")
				return
	..()

/obj/item/storage/fancy/markers
	name = "box of markers"
	desc = "A very professional looking box of permanent markers."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "markerbox"
	w_class = ITEMSIZE_SMALL
	icon_type = "marker"
	can_hold = list(
		/obj/item/pen/crayon/marker
	)
	starts_with = list(
		/obj/item/pen/crayon/marker/black,
		/obj/item/pen/crayon/marker/red,
		/obj/item/pen/crayon/marker/orange,
		/obj/item/pen/crayon/marker/yellow,
		/obj/item/pen/crayon/marker/green,
		/obj/item/pen/crayon/marker/blue,
		/obj/item/pen/crayon/marker/purple
	)

/obj/item/storage/fancy/markers/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/storage/fancy/markers/update_icon()
	var/mutable_appearance/ma = new(src)
	ma.overlays = list()
	for(var/obj/item/pen/crayon/marker/marker in contents)
		ma.overlays += image('icons/obj/crayons.dmi',"m"+marker.colourName)
	appearance = ma

/obj/item/storage/fancy/markers/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/pen/crayon/marker))
		switch(W:colourName)
			if("mime")
				to_chat(user, "This marker is too depressing to be contained in this box.")
				return
			if("rainbow")
				to_chat(user, "This marker is too childish to be contained in this box.")
				return
	..()

/obj/item/storage/fancy/chalk
	name = "box of ritual chalk"
	desc = "A box of chalk for all your ritual needs."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "chalkbox"
	w_class = ITEMSIZE_SMALL
	icon_type = "chalk"
	can_hold = list(
		/obj/item/pen/crayon/chalk
	)
	starts_with = list(
		/obj/item/pen/crayon/chalk/white,
		/obj/item/pen/crayon/chalk/red,
		/obj/item/pen/crayon/chalk/black,
		/obj/item/pen/crayon/chalk/blue
	)

/obj/item/storage/fancy/chalk/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/storage/fancy/chalk/update_icon()
	var/mutable_appearance/ma = new(src)
	ma.overlays = list()
	for(var/obj/item/pen/crayon/chalk/chalk in contents)
		ma.overlays += image('icons/obj/crayons.dmi',"c"+chalk.colourName)
	appearance = ma

/*
 * Cracker Packet
 */

/obj/item/storage/fancy/crackers
	name = "\improper Getmore Crackers"
	icon = 'icons/obj/food.dmi'
	icon_state = "crackerbox"
	icon_type = "cracker"
	max_storage_space = ITEMSIZE_COST_TINY * 6
	max_w_class = ITEMSIZE_TINY
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/reagent_containers/food/snacks/cracker)
	starts_with = list(/obj/item/reagent_containers/food/snacks/cracker = 6)

////////////
//CIG PACK//
////////////
/obj/item/storage/fancy/cigarettes
	name = "\improper pack of Trans-Stellar Duty-frees"
	desc = "A ubiquitous brand of cigarettes, found in every major spacefaring corporation in the universe. As mild and flavorless as it gets."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"
	item_state_slots = list(slot_r_hand_str = "cigpacket", slot_l_hand_str = "cigpacket")
	w_class = ITEMSIZE_TINY
	throwforce = 2
	slot_flags = SLOT_BELT | SLOT_EARS
	storage_slots = 6
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette, /obj/item/flame/lighter, /obj/item/cigbutt)
	icon_type = "cigarette"
	starts_with = list(/obj/item/clothing/mask/smokable/cigarette = 6)
	var/brand = "\improper Trans-Stellar Duty-free"

/obj/item/storage/fancy/cigarettes/Initialize(mapload)
	. = ..()
	flags |= NOREACT
	create_reagents(15 * storage_slots)//so people can inject cigarettes without opening a packet, now with being able to inject the whole one
	flags |= OPENCONTAINER
	if(brand)
		for(var/obj/item/clothing/mask/smokable/cigarette/C in src)
			C.brand = brand
			C.desc += " This one is \a [brand]."

/obj/item/storage/fancy/cigarettes/update_icon()
	icon_state = "[initial(icon_state)][contents.len]"
	return

/obj/item/storage/fancy/cigarettes/remove_from_storage(obj/item/W as obj, atom/new_location)
	// Don't try to transfer reagents to lighters
	if(istype(W, /obj/item/clothing/mask/smokable/cigarette))
		var/obj/item/clothing/mask/smokable/cigarette/C = W
		reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
	..()

/obj/item/storage/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(M == user && user.zone_sel.selecting == O_MOUTH)
		// Find ourselves a cig. Note that we could be full of lighters.
		var/obj/item/clothing/mask/smokable/cigarette/cig = locate() in src

		if(cig == null)
			to_chat(user, "<span class='notice'>Looks like the packet is out of cigarettes.</span>")
			return

		// Instead of running equip_to_slot_if_possible() we check here first,
		// to avoid dousing cig with reagents if we're not going to equip it
		if(!cig.mob_can_equip(user, slot_wear_mask))
			return

		// We call remove_from_storage first to manage the reagent transfer and
		// UI updates.
		remove_from_storage(cig, null)
		user.equip_to_slot(cig, slot_wear_mask)

		reagents.maximum_volume = 15 * contents.len
		to_chat(user, "<span class='notice'>You take a cigarette out of the pack.</span>")
		update_icon()
	else
		..()

/obj/item/storage/fancy/cigarettes/dromedaryco
	name = "\improper DromedaryCo packet"
	desc = "A packet of six imported DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "Dpacket"
	brand = "\improper Dromedary Co. cigarette"

/obj/item/storage/fancy/cigarettes/killthroat
	name = "\improper AcmeCo packet"
	desc = "A packet of six AcmeCo cigarettes. For those who somehow want to obtain the record for the most amount of cancerous tumors."
	icon_state = "Bpacket"
	brand = "\improper Acme Co. cigarette"

// New exciting ways to kill your lungs! - Earthcrusher //

/obj/item/storage/fancy/cigarettes/luckystars
	name = "\improper pack of Lucky Stars"
	desc = "A mellow blend made from synthetic, pod-grown tobacco. The commercial jingle is guaranteed to get stuck in your head."
	icon_state = "LSpacket"
	brand = "\improper Lucky Star"

/obj/item/storage/fancy/cigarettes/jerichos
	name = "\improper pack of Jerichos"
	desc = "Typically seen dangling from the lips of Martian soldiers and border world hustlers. Tastes like hickory smoke, feels like warm liquid death down your lungs."
	icon_state = "Jpacket"
	brand = "\improper Jericho"

/obj/item/storage/fancy/cigarettes/menthols
	name = "\improper pack of Temperamento Menthols"
	desc = "With a sharp and natural organic menthol flavor, these Temperamentos are a favorite of NDV crews. Hardly anyone knows they make 'em in non-menthol!"
	icon_state = "TMpacket"
	brand = "\improper Temperamento Menthol"

/obj/item/storage/fancy/cigarettes/carcinomas
	name = "\improper pack of Carcinoma Angels"
	desc = "This unknown brand was slated for the chopping block, until they were publicly endorsed by an old Earthling gonzo journalist. The rest is history. They sell a variety for cats, too."
	icon_state = "CApacket"
	brand = "\improper Carcinoma Angel"

/obj/item/storage/fancy/cigarettes/professionals
	name = "\improper pack of Professional 120s"
	desc = "Let's face it - if you're smoking these, you're either trying to look upper-class or you're 80 years old. That's the only excuse. They are, however, very good quality."
	icon_state = "P100packet"
	brand = "\improper Professional 120"

/obj/item/storage/fancy/cigarettes/blackstars
	name = "\improper pack of Black Stars"
	desc = "A rare brand of imported herbal cigarettes. The package smells faintly of allspice."
	icon_state = "BSpacket"
	starts_with = list(/obj/item/clothing/mask/smokable/cigarette_import = 6)
	brand = "\improper Black Star"

/obj/item/storage/fancy/cigar
	name = "cigar case"
	desc = "A case for holding your cigars when you are not smoking them."
	icon_state = "cigarcase"
	icon = 'icons/obj/cigarettes.dmi'
	w_class = ITEMSIZE_TINY
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 7
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette/cigar, /obj/item/cigbutt/cigarbutt)
	icon_type = "cigar"
	starts_with = list(/obj/item/clothing/mask/smokable/cigarette/cigar = 7)

/obj/item/storage/fancy/cigar/Initialize(mapload)
	. = ..()
	flags |= NOREACT
	create_reagents(15 * storage_slots)

/obj/item/storage/fancy/cigar/update_icon()
	icon_state = "[initial(icon_state)][contents.len]"
	return

/obj/item/storage/fancy/cigar/remove_from_storage(obj/item/W as obj, atom/new_location)
	var/obj/item/clothing/mask/smokable/cigarette/cigar/C = W
	if(!istype(C)) return
	reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
	..()

/obj/item/storage/rollingpapers
	name = "rolling paper pack"
	desc = "A small cardboard pack containing several folded rolling papers."
	icon_state = "paperbox"
	icon = 'icons/obj/cigarettes.dmi'
	w_class = ITEMSIZE_TINY
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 14
	can_hold = list(/obj/item/rollingpaper)
	starts_with = list(/obj/item/rollingpaper = 14)

/*
 * Vial Box
 */

/obj/item/storage/fancy/vials
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox6"
	icon_type = "vial"
	name = "vial storage box"
	storage_slots = 6
	can_hold = list(/obj/item/reagent_containers/glass/beaker/vial)
	starts_with = list(/obj/item/reagent_containers/glass/beaker/vial = 6)

/obj/item/storage/lockbox/vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")
	max_w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/reagent_containers/glass/beaker/vial)
	max_storage_space = ITEMSIZE_COST_SMALL * 6 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 6
	req_access = list(access_virology)

/obj/item/storage/lockbox/vials/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/storage/lockbox/vials/update_icon(var/itemremoved = 0)
	var/total_contents = contents.len - itemremoved
	icon_state = "vialbox[total_contents]"
	overlays.Cut()
	if (!broken)
		overlays += image(icon, src, "led[locked]")
		if(locked)
			overlays += image(icon, src, "cover")
	else
		overlays += image(icon, src, "ledb")
	return

/obj/item/storage/lockbox/vials/attackby(obj/item/W as obj, mob/user as mob)
	..()
	update_icon()

/*
 * Box of Chocolates/Heart Box
 */

/obj/item/storage/fancy/heartbox
	icon_state = "heartbox"
	name = "box of chocolates"
	icon_type = "chocolate"

	var/startswith = 6
	max_storage_space = ITEMSIZE_COST_SMALL * 6
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/chocolatepiece,
		/obj/item/reagent_containers/food/snacks/chocolatepiece/white,
		/obj/item/reagent_containers/food/snacks/chocolatepiece/truffle
		)
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/chocolatepiece,
		/obj/item/reagent_containers/food/snacks/chocolatepiece,
		/obj/item/reagent_containers/food/snacks/chocolatepiece,
		/obj/item/reagent_containers/food/snacks/chocolatepiece/white,
		/obj/item/reagent_containers/food/snacks/chocolatepiece/white,
		/obj/item/reagent_containers/food/snacks/chocolatepiece/truffle
	)

/obj/item/storage/fancy/heartbox/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/storage/fancy/heartbox/update_icon(var/itemremoved = 0)
	if (contents.len == 0)
		icon_state = "heartbox_empty"
