#SingleInstance, Menu, Exit, ExitApp
#SingleInstance force
#NoEnv
#Persistent
CoordMode, Mouse, Relative	
; Usar @lgp, @square 14 e @circle off e deixar os quadrado totalmente visivel (é a range de visão dos mobs)
; @restock 	= 1 poção de Despertar
; 			= 1 poção verde ou similar (tirar silence) -> Romedic p/ Iara e False Angel
; F1 = Rajada de Flexas
; F3 = Poção do Despertar
; F4 = Asa de Mosca
; F5 = Agua amaldiçoada
; F6 = True Sight
; F7 = Concentração
; F8 = Wind Walk
; F9 = Poção Verde
; 6 = Flexa de aço
; 7 = Flexa de vento
; 8 = Flexa de pedra
;----- CONFIGURAÇÔES DO BOT -----------------------------------------------------------------
global Asa_Sleep := 500				; Tempo em ms que espera após usar asa de mosca
global TP_Sleep := 2000				; Tempo em ms que espera após trocar de mapa
global Mob_Sleep := 50				; Tempo em ms que espera após clicar no mob antes de procurar outro
global ArrowCount := 500			; Quantidade de flechas para pegar no @gstorage
global HomeCount := 0				; Quantadade de vezes que volta pro point antes de guardar tudo
global TempoLimite := 6000			; Tempo maximo que fica parado entre asas de mosca
global cur_hp := 0					; 0083e1b4	
global max_hp := 0					; 0083e1b8	
global cur_sp := 0					; 0083e1bc	
global max_sp := 0					; 0083e1c0	
global cur_cap := 0					; 0083C558
global max_cap := 0					; 0083C54C
;global coordX := 0					; 0d43fc88	
;global coordY := 0					; 0d43fc8c
;---- NPCS ----------------------------------------------------------------------------------
global HealerX := 850				; Posição X do Healer
global HealerY := 335				; Posição Y do Healer
;---- COORDENADAS DAS JANELAS E GUI DO RAG --------------------------------------------------
global InventarioItemX	:= 10		; X da aba Item da janela do inventario (Alt+E)
global InventarioItemY	:= 160		; Y da aba Item da janela do inventario
global InventarioEquipX := 10		; X da aba Equip da janela do inventario 
global InventarioEquipY := 180		; Y da aba Equip da janela do inventario
global InventarioEtcX := 10			; X da aba Etc da janela do inventario 
global InventarioEtcY := 210		; Y da aba Etc da janela do inventario
global InvetarioSupX := 35			; X superior da janela do inventario
global InvetarioSupY := 140			; Y superior da janela do inventario
global InvetarioInfX := 300			; X inferior da janela do inventario
global InvetarioInfY := 340			; Y inferior da janela do inventario
global StorageSupX := 340			; X superior da janela do @gstorage
global StorageSupY := 140			; Y superior da janela do @gstorage
global StorageInfX := 590			; X inferior da janela do @gstorage
global StorageInfY := 690			; Y inferior da janela do @gstorage
global StorageItemX := 325			; X da aba de Item do @gstorage
global StorageItemY := 150			; Y da aba de Item do @gstorage
global StorageAmmoX := 325			; X da aba de Munição do @gstorage
global StorageAmmoY := 280			; Y da aba de Munição do @gstorage
global StorageCloseX := 550			; X do botão de fechar do @gstorage
global StorageCloseY := 730			; Y do botão de fechar do @gstorage
global ArrowSlotX := 720			; X de onde ficam as flechas (Alt+Q)
global ArrowSlotY := 185			; Y de onde ficam as flechas
global Width := 0					; 1/4 do comprimento da tela
global Height := 0					; 1/4 da altura da teka 
;----- CONFIGURAÇÃO DE LOOT E CAÇA ----------------------------------------------------------
global Hunt					:= 2
global crunch_toast 		:= true
global card_myst_case 		:= true
global card_plasma 			:= true
global card_mimic 			:= true
global card_jing_guai 		:= false
global upkeep				:= false
global arrow				:= "img/arrow/flecha_de_pedra.png"
global chooseHunt			:= 0
global LastDungeon			:= 
;--------------------------------------------------------------------------------------------

LoadIni() 
Gui Bot:Default
Gui, Add, Text, x5 y5, Posição dos NPCs
Gui, Add, Text, Y+5 h15, Healer X:
Gui, Add, Text, hp Y+, Healer Y:

;Gui, Add, Text, x5 Y+10, Tempo de Espera
;Gui, Add, Text, hp Y+, Asa de Mosca:
;Gui, Add, Text, hp Y+, Teleporte:
;Gui, Add, Text, hp Y+, Limite Parado:

Gui, Add, Edit, h15 X+M y21+Y- gchkb vHealerX, %HealerX%
Gui, Add, Edit, hp Y+ gchkb vHealerY, %HealerY%

Gui, Add, Text, x+10+X- y5+Y-, Escolha o que matar:
Gui, Add, DropDownList, gchkb vHunt Choose%chooseHunt% Sort, Wild_Rose|Sky_Petit|Iara|False_Angel|Roween

Gui, Add, Text, , @aloot adicional:
Gui, Add, Checkbox, Y+2 gchkb vcrunch_toast Checked%crunch_toast%, Torrada Crocante
Gui, Add, Checkbox, Y+2 gchkb vcard_myst_case Checked%card_myst_case%, Carta Presente
Gui, Add, Checkbox, Y+2 gchkb vcard_plasma Checked%card_plasma%, Carta Plasma
Gui, Add, Checkbox, Y+2 gchkb vcard_mimic Checked%card_mimic%, Carta Mimico
Gui, Add, Checkbox, Y+2 gchkb vcard_jing_guai Checked%card_jing_guai%, Carta Jing Guai

gui, Submit, NoHide
gui, show, Center, BOT by I s h
Return

chkb:
	gui, Submit, NoHide
	SaveIni()
	return  	

;--------------------------------------------------------------------------------------------
^F12::
	MouseGetPos, xpos, ypos 				
	Tooltip, The cursor is at X%xpos% Y%ypos%		;Mostra a posição X e Y do mouse
 	return 
;--------------------------------------------------------------------------------------------

; Para vender as khukri
^F11::
	CloseChat()
	SetKeyDelay 25,50
	Send, !{e}		
	SendInput, {Enter}@gstorage{Enter}
	Sleep, 350
	Loop, img/store/equip/*.png {
		st := true
		while st {
			MouseClick, Left, %InventarioEquipX%, %InventarioEquipY%
			MouseClick, Left, %StorageItemX%, 65+StorageItemY
			Sleep, 100
			ImageSearch, Px, Py, StorageSupX, StorageSupY, StorageInfX, StorageInfY, img/store/equip/%A_LoopFileName%
			if (ErrorLevel = 0) {
				MouseClickDrag, Left, Px+14, Py+14, (InvetarioSupX+InvetarioInfX)/2, (InvetarioSupY+InvetarioInfY)/2, 0
			} else {
				st := false	
			}
			
			Update()
			if(0.89 < cur_cap/max_cap) {
				break 2
			}
		}
	}
	MouseClick, Left, %StorageCloseX%, %StorageCloseY%
	Send, !{e}
	CloseChat()
	SetKeyDelay 0, -1
 	return 
	
^F10::
	GoPoint()
	Configure()
	ConfigureLoot()
	loop {
		HomeCount := 0
		GearUp()
		Loop {
			GoPoint()	
			Buff()
			;Heal()
			EnterDungeon()
			TempoNaDungeon := A_TickCount
			Loop {
				search := 0
				if (Hunt = "False_Angel") {
					upkeep = true
					search := Search(false, "spr/fake_angel.png")
				} else if (Hunt = "Iara") {
					upkeep = true
					search := Search(true, "spr/iara.png")
				} else if (Hunt = "Sky_Petit") {
					search := Search(false, "spr/petit_.png")
				} ; else if (Hunt = "Roween") {
				;	search := Search(false, "spr/roween.png")
				;} else if (Hunt = "Wild_Rose") {
				;	search := Search(true, "spr/wild_rose.png")
				;}
				
				; Mais de 6 min em um mapa 	6 * 60 * 1000
				;if (A_TickCount > TempoNaDungeon + 360000) {
				;	break
				;}
				
				; Verifica a cap
				Update()
				if(0.89 < cur_cap/max_cap) {
					break 2
				; usa asa
				} else if (search != 1) {
					EnterDungeon()
					Sleep, %Asa_Sleep%
				} else {
					break
				}
			}
			HomeCount++
		}
	}
	return
;--------------------------------------------------------------------------------------------

; @return = 1 Sem HP/SP, 2 Estorou o Tempo
Search(ByRef mode, ByRef sprite) {
	StartTime := A_TickCount
	if (mode) {
		if (isHPLowerThan(15)) {
			return 1
		}
		searchCount := 0
		while (searchCount < 31) {
			searchCount := 0
			Loop 6 {
				i := A_Index
				Loop 6 {
					j := A_Index
					if ((A_TickCount - StartTime) > TempoLimite) {
						return 2
					}
					ImageSearch, Px, Py, (i)*Width-32, (j)*Height-32, (i+1)*Width+32, (j+1)*Height+32, *h2 *w2 %sprite%
					if (ErrorLevel = 0) {
						searchCount := 0
						if (DoubleStrafe(1, Px, Py)) {
							return 1
						}
					} else {
						searchCount += 1
					}
				}
			}
		}
	} else {
		loop {
			if (isHPLowerThan(15)){
				return 1
			}
			if ((A_TickCount - StartTime) > TempoLimite) {
				return 2
			}
			ImageSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, *h2 *w2 %sprite%
			if (ErrorLevel = 0) {
				if (DoubleStrafe(3, Px, Py)) {
					return 1
				}
			} else {
				return 0
			}
		}
	}
	return 0
}

; @return = 0 ok, 1 = Sem SP
DoubleStrafe(ByRef amount, ByRef Px, ByRef Py) {
	if (isSPLowerThan(60)) {
		return 1
	}
	
	if (upkeep) {
		ImageSearch, , , Width4a*3, 0, A_ScreenWidth, A_ScreenHeight, *TransBlack gui/true_sight.png
		if (ErrorLevel != 0) {
			SendInput, {F6}					; True Sight
			sleep 100
		}
	}
		
	loop %amount% {
		SendInput, {F1}						; Double Strafe
		Sleep, 50
		MouseClick, Left, %Px%+24, %Py%+24
	}
	return 0
}

ConfigureLoot() {
	Send, {Enter}
	Sleep, 300
	if (card_plasma) {
		SendInput, @aloot item 12118 {Enter}		; Item ID# 12118 (Resist_Fire)		25% - Carta Plasma
		SendInput, @aloot item 12119 {Enter}		; Item ID# 12119 (Resist_Water)		
		SendInput, @aloot item 12120 {Enter}		; Item ID# 12120 (Resist_Earth)		
		SendInput, @aloot item 12121 {Enter}		; Item ID# 12121 (Resist_Wind)
	}	
	if (card_myst_case) {
		SendInput, @aloot item 644 {Enter}			; Item ID# 644 (Gift_Box)			30% - Carta Presente
	}
	if (card_mimic) {
		SendInput, @aloot item 603 {Enter}			; Item ID# 603 (Old_Blue_Box)		20% - Carta Mimico
	}
	if (crunch_toast) {
		SendInput, @aloot item 617 {Enter}			; Item ID# 617 (Old_Violet_Box)		2% - Torrada Crocante
	}
	SendInput, @aloot rate 1 {Enter}				; 5%
	if (Hunt = "False_Angel") {
		SendInput, @aloot item 12020 {Enter}		; Item ID# 12020 (Water_Of_Darkness)
		SendInput, @aloot item 12033 {Enter}		; Item ID# 12033 (Box_Of_Sunlight)
	} else if (Hunt = "Iara") {
		SendInput, @aloot item 748 {Enter}			; Item ID# 748 (Witherless_Rose)
		SendInput, @aloot item 747 {Enter}			; Item ID# 747 (Crystal_Mirror)
		;SendInput, @aloot item 710 {Enter}			; Item ID# 710 (Illusion_Flower)
		;SendInput, @aloot item 995 {Enter}			; Item ID# 995 (Mistic_Frozen)
		;SendInput, @aloot item 950 {Enter}			; Item ID# 950 (Heart_Of_Mermaid)
		;SendInput, @aloot item 951 {Enter}			; Item ID# 951 (Fin)
	} else if (Hunt = "Sky_Petit") {
		;SendInput, @aloot item 509 {Enter}			; Item ID# 509 (White_Herb)
		SendInput, @aloot item 606 {Enter}			; Item ID# 606 (Aloebera)
		SendInput, @aloot item 985 {Enter}			; Item ID# 985 (Elunium)
		;SendInput, @aloot item 1036 {Enter}			; Item ID# 1036 (Dragon_Scale)
		;SendInput, @aloot item 1037 {Enter}			; Item ID# 1037 (Dragon_Train)
		SendInput, @aloot item 13006 {Enter}		; Item ID# 13006 (Khukri)
	}
	closeChat()
	Sleep, 500
	return
}

GearUp() {
	CloseChat()
	SetKeyDelay 25,50
	Send, !{e}
	Send, !{q}				
	SendInput, {Enter}@gstorage{Enter}
	Sleep, 350
	; Store Item Tab -----------------------------------------------------------
	Loop, img/store/item/*.png {
		st := true
		while st {
			MouseClick, Left, %InventarioItemX%, %InventarioItemY%
			Sleep, 100
			ImageSearch, Px, Py, InvetarioSupX, InvetarioSupY, InvetarioInfX, InvetarioInfY, img/store/item/%A_LoopFileName%
			if (ErrorLevel = 0) {
				MouseClickDrag, Left, Px+14, Py+14, (StorageSupX+StorageInfX)/2, (StorageSupY+StorageInfY)/2, 0
				SendInput, {Enter}
			} else {
				st := false	
			}
		}
	}
	; Store Equip Tab -----------------------------------------------------------
	Loop, img/store/equip/*.png {
		st := true
		while st {
			MouseClick, Left, %InventarioEquipX%, %InventarioEquipY%
			Sleep, 100
			ImageSearch, Px, Py, InvetarioSupX, InvetarioSupY, InvetarioInfX, InvetarioInfY, img/store/equip/%A_LoopFileName%
			if (ErrorLevel = 0) {
				MouseClickDrag, Left, Px+14, Py+14, (StorageSupX+StorageInfX)/2, (StorageSupY+StorageInfY)/2, 0
			} else {
				st := false	
			}
		}
	}
	; Store Etc Tab -------------------------------------------------------------
	Loop, img/store/etc/*.png {
		st := true
		while st {
			MouseClick, Left, %InventarioEtcX%, %InventarioEtcY%	
			Sleep, 100
			ImageSearch, Px, Py, InvetarioSupX, InvetarioSupY, InvetarioInfX, InvetarioInfY, img/store/etc/%A_LoopFileName%
			if (ErrorLevel = 0) {
				MouseClickDrag, Left, Px+14, Py+14, (StorageSupX+StorageInfX)/2, (StorageSupY+StorageInfY)/2, 0
				SendInput, {Enter}
			} else {
				st := false	
			}
		}
	}
	; Store Arrow ---------------------------------------------------------------
	loop img/arrow/*.png {
		st := true
		while st {
			MouseClick, Left, %ArrowSlotX%, %ArrowSlotY%
			Sleep, 40
			MouseClick, Left, %ArrowSlotX%, %ArrowSlotY%
			Sleep, 100
			MouseClick, Left, %InventarioEtcX%, %InventarioEtcY%
			Sleep, 100
			ImageSearch, Px, Py, InvetarioSupX, InvetarioSupY, InvetarioInfX, InvetarioInfY, img/arrow/%A_LoopFileName%
			if (ErrorLevel = 0) {
				MouseClickDrag, Left, Px+14, Py+14, (StorageSupX+StorageInfX)/2, (StorageSupY+StorageInfY)/2, 0
				Sleep, 100
				SendInput, {Enter}
			} else {
				st := false	
			}
		}
	}
	Sleep, 100	
	; Load Cursed Water --------------------------------------------------------
	if (Hunt = "False_Angel") {
		closeChat()
		ld := true
		while ld {
			MouseClick, Left, %InventarioitemX%, %InventarioitemY%
			Sleep 100
			MouseClick, Left, %StorageItemX%, %StorageItemY%
			Sleep 100
			ImageSearch, Px, Py, StorageSupX, StorageSupY, StorageInfX, StorageInfY, img/store/item/cursed_water.png
			if (ErrorLevel = 0) {
				MouseClickDrag, Left, Px+14, Py+14, (InvetarioSupX+InvetarioInfX)/2, (InvetarioSupY+InvetarioInfY)/2, 5
				Sleep, 200
				Send, 1
				Sleep, 200
				SendInput, {Enter}
				Sleep, 350
				ImageSearch, Px, Py, InvetarioSupX, InvetarioSupY, InvetarioInfX, InvetarioInfY, img/store/item/cursed_water.png
				if (ErrorLevel == 0) {
					ld := false
				}
			}
		}
	}
	; Load Arrow ----------------------------------------------------------------
	ld := true
	while ld {
		MouseClick, Left, %InventarioEtcX%, %InventarioEtcY%
		Sleep 75
		MouseClick, Left, %StorageAmmoX%, %StorageAmmoY%
		Sleep 75
		closeChat()
	
		if (Hunt = "False_Angel") {	
			arrow := "img/arrow/flecha_de_aco.png"
		} else if (Hunt = "Iara") {
			arrow := "img/arrow/flecha_de_vento.png"
		} else {
			arrow := "img/arrow/flecha_de_pedra.png"
		}
		
		ImageSearch, Px, Py, StorageSupX, StorageSupY, StorageInfX, StorageInfY, %arrow%
		if (ErrorLevel = 0) {
			MouseClickDrag, Left, Px+14, Py+14, (InvetarioSupX+InvetarioInfX)/2, (InvetarioSupY+InvetarioInfY)/2, 5
			Sleep, 200
			Send, %ArrowCount%
			Sleep, 200
			SendInput, {Enter}
			Sleep, 350
			ImageSearch, Px, Py, InvetarioSupX, InvetarioSupY, InvetarioInfX, InvetarioInfY, %arrow%
			if (ErrorLevel == 0) {
				ld := false
			}
		}
	}
	MouseClick, Left, %StorageCloseX%, %StorageCloseY%
	Send, !{e}
	Send, !{q}
	CloseChat()
	SetKeyDelay 0, -1
	return
}

GoPoint() {
	CloseChat()
	Sleep, 300
	SendInput {Enter}@go 10{Enter}
	Sleep, TP_Sleep
	return
}

Heal() {
	MouseClick, Left, %HealerX%, %HealerY%
	Sleep, 1000
	return
}

Buff() {
	SendInput, {6}						; Flexa de Aço
	SendInput, {7}						; Flexa de Vento
	SendInput, {8}						; Flexa de Pedra
	if (Hunt = "False_Angel") {
		SendInput, {F5}					; Cursed Water
		Sleep, 333
		SendInput, {F3}					; Poção do Despertar
	}
	Sleep, 333
	SendInput, {F6}						; True Sight
	Sleep, 333
	SendInput, {F7}						; Concentração
	Sleep, 333
	SendInput, {F8}						; Windwalk
	Sleep, 800
	return
}

EnterDungeon() {	
	if (Hunt = "False_Angel") {
		Warp("gefenia01", 0, 0)
	} else if (Hunt = "Iara") {
		Warp("bra_dun02", 0, 0)
	} else if (Hunt = "Sky_Petit") {
		Warp("mjolnir_03", 0, 0)
	}
	return
}

CloseChat() {
	ImageSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, *TransBlack gui/chat.png
	if (ErrorLevel == 0) {
		SendInput, {Enter}
	}
	sleep 200
	return
}

isHPLowerThan(byRef percent) {
	cur_hp := 	ReadMemory(0x0083E1B4, "AWESOMERO - WE ARE AWESOME!")		; 0083e1b4	
	max_hp := 	ReadMemory(0x0083E1B8, "AWESOMERO - WE ARE AWESOME!")		; 0083e1b8
	if (percent/100 > cur_hp/max_hp) {
		return true
	}
	return false
}

isSPLowerThan(byRef amount){
	cur_sp := 	ReadMemory(0x0083E1BC, "AWESOMERO - WE ARE AWESOME!")		; 0083e1bc	
	max_sp := 	ReadMemory(0x0083E1C0, "AWESOMERO - WE ARE AWESOME!")		; 0083e1c0	
	if (amount > cur_sp) {
		return true
	}
	return false
}

Update() {
	;cur_hp := 	ReadMemory(0x0083E1B4, "AWESOMERO - WE ARE AWESOME!")		; 0083e1b4	
	;max_hp := 	ReadMemory(0x0083E1B8, "AWESOMERO - WE ARE AWESOME!")		; 0083e1b8
	;cur_sp := 	ReadMemory(0x0083E1BC, "AWESOMERO - WE ARE AWESOME!")		; 0083e1bc	
	;max_sp := 	ReadMemory(0x0083E1C0, "AWESOMERO - WE ARE AWESOME!")		; 0083e1c0	
	;pX := 		ReadMemory(0x008375F4, "AWESOMERO - WE ARE AWESOME!")		; 008375F4	0E858338
	;pY := 		ReadMemory(0x008375F8, "AWESOMERO - WE ARE AWESOME!")		; 008375F8	0E85833C
	cur_cap := 	ReadMemory(0x0083C558, "AWESOMERO - WE ARE AWESOME!")		; 0083C558
	max_cap := 	ReadMemory(0x0083C54C, "AWESOMERO - WE ARE AWESOME!")		; 0083C54C
	return 
}

ReadMemory(MADDRESS,PROGRAM) {
	winget, pid, PID, %PROGRAM%
	VarSetCapacity(MVALUE,4,0)
	ProcessHandle := DllCall("OpenProcess", "Int", 24, "Char", 0, "UInt", pid, "UInt")
	DllCall("ReadProcessMemory", "UInt", ProcessHandle, "Ptr", MADDRESS, "Ptr", &MVALUE, "Uint",4)
	Loop 4
		result += *(&MVALUE + A_Index-1) << 8*(A_Index-1)
	return, result
}

Warp(byRef map, byRef x, byRef y) {
	CloseChat()
	warpString := "@warp " . map . " " . x . " " . y
	SendInput, {Enter}%warpString%{Enter}
	return
}

Configure() {
	CloseChat()
	SetKeyDelay 25,50
	Send, !{e}
	Send, !{q}				
	Send, {Enter}
	Sleep, 200
	SendInput, @gstorage {Enter}
	Sleep, 350
	ImageSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, gui/inventario.png
	if (ErrorLevel == 0) { 				; 6 133
		InventarioItemX	:= Px + 5		; X da aba Item da janela do inventario
		InventarioItemY	:= Py + 30		; Y da aba Item da janela do inventario
		InventarioEquipX := Px + 5		; X da aba Equip da janela do inventario 
		InventarioEquipY := Py + 50		; Y da aba Equip da janela do inventario
		InventarioEtcX := Px + 5		; X da aba Etc da janela do inventario 
		InventarioEtcY := Py + 80		; Y da aba Etc da janela do inventario

		InvetarioSupX := Px				; X superior da janela do inventario
		InvetarioSupY := Py				; Y superior da janela do inventario
		InvetarioInfX := Px + 300		; X inferior da janela do inventario
		InvetarioInfY := Py + 210		; Y inferior da janela do inventario		
	}
	ImageSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, gui/armazem.png
	if (ErrorLevel == 0) {				; 316 133
		StorageSupX := Px				; X superior da janela do @gstorage
		StorageSupY := Py				; Y superior da janela do @gstorage
		StorageInfX := Px + 280			; X inferior da janela do @gstorage
		StorageInfY := Py + 560			; Y inferior da janela do @gstorage		
		
		StorageItemX := Px + 10			; X da aba de Item do @gstorage
		StorageItemY := Py + 15			; Y da aba de Item do @gstorage
		
		StorageAmmoX := Px + 10			; X da aba de Munição do @gstorage
		StorageAmmoY := Py + 150		; Y da aba de Munição do @gstorage	

		StorageCloseX := Px + 230		; X do botão de fechar do @gstorage
		StorageCloseY := Py + 600		; Y do botão de fechar do @gstorage
	}
	ImageSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, gui/equipamento.png
	if (ErrorLevel == 0) {				; 598 133
		ArrowSlotX := Px + 120			; X de onde ficam as flechas (Alt+Q)
		ArrowSlotY := Py + 50			; Y de onde ficam as flechas
	}
	MouseClick, Left, %StorageCloseX%, %StorageCloseY%
	Send, !{e}
	Send, !{q}				
	CloseChat()
	
	ImageSearch, HPSPBarX, HPSPBarY, 0, 0, A_ScreenWidth, A_ScreenHeight, *TransBlack gui/hpspbar.png
	Width := A_ScreenWidth / 6
	Height := A_ScreenHeight / 6
	
	; False Angel e Iara
	if (Hunt = "False_Angel" | Hunt = "Iara") {
		upkeep := true
	}
	SaveIni()
	SetKeyDelay 0, -1		
	return
}

SaveIni() {
FileDelete config.ini
FileAppend,
(
[Config]
Hunt=%Hunt%
TempoLimite=%TempoLimite%
[Loot]
Torrada_Crocante=%crunch_toast%
Carta_Presente=%card_myst_case%
Carta_Plasma=%card_plasma%
Carta_Mimico=%card_mimic%
Carta_Jing_Guai=%card_jing_guai%
[Coord]
HealerX=%HealerX%
HealerY=%HealerY%
InventarioItemX=%InventarioItemX%	
InventarioItemY=%InventarioItemY%		
InventarioEquipX=%InventarioEquipX%		
InventarioEquipY=%InventarioEquipY%		
InventarioEtcX=%InventarioEtcX%		
InventarioEtcY=%InventarioEtcY%	
InvetarioSupX=%InvetarioSupX%			
InvetarioSupY=%InvetarioSupY%	
InvetarioInfX=%InvetarioInfX%			
InvetarioInfY=%InvetarioInfY%		
StorageSupX=%StorageSupX%			
StorageSupY=%StorageSupY%		
StorageInfX=%StorageInfX%			
StorageInfY=%StorageInfY%			
StorageItemX=%StorageItemX%			
StorageItemY=%StorageItemY%			
StorageAmmoX=%StorageAmmoX%		
StorageAmmoY=%StorageAmmoY%		
StorageCloseX=%StorageCloseX%		
StorageCloseY=%StorageCloseY%		
ArrowSlotX=%ArrowSlotX%			
ArrowSlotY=%ArrowSlotY%	
Width4a=%Width4a%
Height4a=%Height4a%
), config.ini
return
}

LoadIni() {
	if FileExist("config.ini") {
		; [Config]
		IniRead, Hunt, config.ini, Config, Hunt,
		IniRead, TempoLimite, config.ini, Config, TempoLimite,
		; [Loot]
		IniRead, crunch_toast, config.ini, Loot, Torrada_Crocante,
		IniRead, card_myst_case, config.ini, Loot, Carta_Presente,
		IniRead, card_plasma, config.ini, Loot, Carta_Plasma,
		IniRead, card_mimic, config.ini, Loot, Carta_Mimico,
		IniRead, card_jing_guai, config.ini, Loot, Carta_Jing_Guai,
		; [Coord]
		IniRead, HealerX, config.ini, Coord, HealerX,
		IniRead, HealerY, config.ini, Coord, HealerY,
		IniRead, InventarioItemX, config.ini, Coord, InventarioItemX,
		IniRead, InventarioItemY, config.ini, Coord, InventarioItemY,
		IniRead, InventarioEquipX, config.ini, Coord, InventarioEquipX,
		IniRead, InventarioEquipY, config.ini, Coord, InventarioEquipY,
		IniRead, InventarioEtcX, config.ini, Coord, InventarioEtcX,
		IniRead, InventarioEtcY, config.ini, Coord, InventarioEtcY,
		IniRead, InvetarioSupX, config.ini, Coord, InvetarioSupX,
		IniRead, InvetarioSupY, config.ini, Coord, InvetarioSupY,
		IniRead, InvetarioInfX, config.ini, Coord, InvetarioInfX,
		IniRead, InvetarioInfY, config.ini, Coord, InvetarioInfY,
		IniRead, StorageSupX, config.ini, Coord, StorageSupX,
		IniRead, StorageSupY, config.ini, Coord, StorageSupY,
		IniRead, StorageInfX, config.ini, Coord, StorageInfX,
		IniRead, StorageInfY, config.ini, Coord, StorageInfY,
		IniRead, StorageItemX, config.ini, Coord, StorageItemX,
		IniRead, StorageItemY, config.ini, Coord, StorageItemY,
		IniRead, StorageAmmoX, config.ini, Coord, StorageAmmoX,
		IniRead, StorageAmmoY, config.ini, Coord, StorageAmmoY,
		IniRead, StorageCloseX, config.ini, Coord, StorageCloseX,
		IniRead, StorageCloseY, config.ini, Coord, StorageCloseY,
		IniRead, ArrowSlotX, config.ini, Coord, ArrowSlotX,
		IniRead, ArrowSlotY, config.ini, Coord, ArrowSlotY,
		IniRead, Width4a, config.ini, Coord, Width4a,
		IniRead, Height4a, config.ini, Coord, Height4a,
		
		if (Hunt = "False_Angel") {
			chooseHunt := 1
		} else if (Hunt = "Iara") {
			chooseHunt := 2
		} else if (Hunt = "Roween") {
			chooseHunt := 3
		} else if (Hunt = "Sky_Petit") {
			chooseHunt := 4
		} else if (Hunt = "Wild_Rose") {
			chooseHunt := 5
		}
	} else {
		SaveIni()
	}	

return
}

;--------------------------------------------------------------------------------------------
^R::Reload

Esc::
	;Suspend On
	Pause On
	return
;--------------------------------------------------------------------------------------------
GuiEscape:
GuiClose:
ExitApp
return