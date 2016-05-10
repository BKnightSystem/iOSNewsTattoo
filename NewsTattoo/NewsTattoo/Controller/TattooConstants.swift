//
//  TattooConstants.swift
//  Tattoo
//
//  Created by Jonathan Cruz Orozco on 01/03/16.
//  Copyright © 2016 TecnoSoft. All rights reserved.
//

import UIKit
import CoreData

var TIMEOUT_REQUEST = 20.0
var TIMEOUT_RESOURCE = 20.0

let IMAGE_ICON_BACK  = UIImage(named: "back")
let IMAGE_ICON_FAVORITO = UIImage(named: "circulo")
let IMAGE_ICON_FB   = UIImage(named: "social")

let IMAGE_LAUNCH_SCREEN = UIImage(named: "backgroundApp.png")
//let IMAGE_ICON_DIOSES_WHITE = UIImage(named: "formas")
//let IMAGE_ICON_LETRAS_WHITE = UIImage(named: "bloques")
//let IMAGE_ICON_ANIMAL_WHITE = UIImage(named: "perro")
//let IMAGE_ICON_GRECAS_WHITE = UIImage(named: "animales")
//let IMAGE_ICON_CRANEO_WHITE  = UIImage(named: "personas")

//Color
let COLOR_BACKGROUND_VIEW = 0x537893
let COLOR_BACKGROUND_APP  = 0xE6EAE9
let COLOR_LINE_VIEW = 0xBDBCBC
let COLOR_NEGRO = 0x000000
let COLOR_BLANCO = 0xFFFFFF
let COLOR_ROJO  = 0xFF0000
let COLOR_ICONOS = 0xDE5240
let COLOR_BACKGROUND_PAGE = 0xF4F4EC
let COLOR_TITLE_PAGE = 0x61605C

var IMG_DEFAULT_PROMO = UIImage(named: "headerTattoo")

//Array Images
var imagesForSection0: [UIImage] = []
var imagesForSection1: [UIImage] = []

var imagesEstudioGalery: [UIImage] = []
//Array for save de informaton of image tattoo
var arrayDetailPages:[Magazine] = []

//Array options
//var arrayBanner:[UIImage] = []
var arrayPagesMagazine: [UIView] = []

//Array Estudios
var arrayEstudiosTattoo = [Estudios]()
var arrayPortadasTattoo = [MagazinePortada]()

//Array Favoritos
var arrayFavoritos = [MagazinePortada]()

//Array Promociones
var arrayPromociones = [Promociones]()

//Array of Estudios CD
var estudios = [NSManagedObject]()
var magazineCD = [NSManagedObject]()
var galeriaCD = [NSManagedObject]()

//MARK- FONT
let FONT_TEXT_1 = UIFont(name: "Windsong", size: 30)
let FONT_TEXT_2 = UIFont(name: "Sofia-Regular", size: 20)
let FONT_TEXT_3 = UIFont(name: "Caviar_Dreams_Bold", size: 25)
let FONT_TEXT_4 = UIFont(name: "Times New Roman", size: 18)


//MARK: Months
let ARRAY_MONTHS = ["ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"]


