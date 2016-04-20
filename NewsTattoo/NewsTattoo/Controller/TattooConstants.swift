//
//  TattooConstants.swift
//  Tattoo
//
//  Created by Jonathan Cruz Orozco on 01/03/16.
//  Copyright © 2016 TecnoSoft. All rights reserved.
//

import UIKit
import CoreData

//let IMAGE_ICON_MENU   = UIImage(named: "icon-menu")
//let IMAGE_ICON_FLORES = UIImage(named: "grupo-de-rosas")
//let IMAGE_ICON_DIOSES = UIImage(named: "bastet")
//let IMAGE_ICON_LETRAS = UIImage(named: "juguete-de-bloque-de-letras")
//let IMAGE_ICON_ANIMAL = UIImage(named: "huella-de-pata-de-animal")
//let IMAGE_ICON_GRECAS = UIImage(named: "tatuaje-de-caballo-en-variante-mirando-hacia-la-izquierda")
//let IMAGE_ICON_STUDIO = UIImage(named: "brujula")
//let IMAGE_ICON_CLOSE  = UIImage(named: "boton-de-eliminar")
//let IMAGE_ICON_SIMULADOR  = UIImage(named: "tatuaje-de-corazon")
//let IMAGE_ICON_CRANEO  = UIImage(named: "craneo-humano")
//let IMAGE_ICON_SAVE  = UIImage(named: "save")
let IMAGE_ICON_BACK  = UIImage(named: "back")
let IMAGE_ICON_FAVORITO = UIImage(named: "circulo")
let IMAGE_ICON_FB   = UIImage(named: "social")

let IMAGE_ICON_FLORES_WHITE = UIImage(named: "naturaleza")
let IMAGE_ICON_DIOSES_WHITE = UIImage(named: "formas")
let IMAGE_ICON_LETRAS_WHITE = UIImage(named: "bloques")
let IMAGE_ICON_ANIMAL_WHITE = UIImage(named: "perro")
let IMAGE_ICON_GRECAS_WHITE = UIImage(named: "animales")
let IMAGE_ICON_CRANEO_WHITE  = UIImage(named: "personas")

//Color
let COLOR_BACKGROUND_VIEW = 0x537893
let COLOR_BACKGROUND_APP  = 0xE6EAE9
let COLOR_LINE_VIEW = 0xBDBCBC
let COLOR_NEGRO = 0x000000
let COLOR_BLANCO = 0xFFFFFF

//Array Images
var imagesForSection0: [UIImage] = []
var imagesForSection1: [UIImage] = []

var imagesEstudioGalery: [UIImage] = []
//Array for save de informaton of image tattoo
var arrayDetailPages:[Magazine] = []

//Array options
var arrayBanner:[UIImage] = []
var arrayPagesMagazine: [UIView] = []

//Array Estudios
var arrayEstudiosTattoo = [Estudios]()
var arrayPortadasTattoo = [MagazinePortada]()

var arrayFavoritos = [MagazinePortada]()

//Array of Estudios CD
var estudios = [NSManagedObject]()
var magazineCD = [NSManagedObject]()
var galeriaCD = [NSManagedObject]()

//MARK- FONT
let FONT_TEXT_1 = UIFont(name: "Windsong", size: 30)
let FONT_TEXT_2 = UIFont(name: "Sofia-Regular", size: 20)
let FONT_TEXT_3 = UIFont(name: "Caviar_Dreams_Bold", size: 25)
let FONT_TEXT_4 = UIFont(name: "cac_champagne", size: 18)
