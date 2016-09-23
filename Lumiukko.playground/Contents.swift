/*:
 # Lumiukko SpriteKitillä ja Swiftillä

 Tämä esimerkkileikkikenttä (*"playground"*) näyttää, miten
 Ohjelmointi 1 -kurssilta tuttu Lumiukko piirretään käyttäen
 Swift-ohjelmointikieltä ja Applen peliohjelmointikirjastoja.
 Käytössä on Swiftin versio 3 Xcoden versiossa 8, jonka saa
 ilmaiseksi App Storesta.  Tämän pitäisi myös toimia iOS:n
 Playground-sovelluksessa.

 Swiftiä ei tässä kirjoituksessa opeteta, mutta voin suositella
 iBooks-kirjaa [App Development with Swift](https://itunes.apple.com/fi/book/app-development-with-swift/id1118575552?l=fi&mt=11).

 Varmista ensin, että luet tätä taitettuna, eli `Editor`-valikosta
 on valittu `Show Rendered Markup`.  Varmista myös, ettei tätä
 leikkikentää ajeta jatkuvasti, eli valitse tämän editorin
 alalaidassa olevasta kolmiosta tulevasta ponnahdusikkunasta
 `Manually Run`.  Sen pitäisi näyttää tältä: ![käsinajo](manuallyrun.png)

 SpriteKit hidastuttaa valitettavan paljon XCoden Playgroundin toimintaa, joten näin on parempi.  Nyt leikkikentän voi ajaa klikkaamalla tuohon äskeisen kuvan neliön paikalle ilmestyvää ääriviivallista kolmiota.

 ## Tarvittavat kirjastot

 Otetaan ensin käyttöön SpriteKit, joka on Applen käyttisten
 2D-pelikirjasto. (3D-pelikirjasto on SceneKit, laskentaan Metal
 ja pelilogiikkaan GameplayKit.)
 */
import SpriteKit
/*:
 Pelkkä SpriteKit toimii mainiosti mac/i/tv/watchOS:llä, mutta
 tämä leikkikenttä on macOS:lle.  Jos haluat, luo toinen leikkikenttä
 haluamallasi OS:llä ja kopioi koodi sinne.

 Seuraavaksi otetaan käyttöön PlaygroundSupport, jonka avulla
 lumiukko saadaan näkyviin apueditorissa.  Varmista, että
 apueditori näkyy, eli tämän ikkunan oikeassa yläkulmassa oleva
 kaksi rengasta sisältävä painike näyttää renkaat sinisinä:
 ![apueditorin painike](altedit-button.png)
 */
import PlaygroundSupport

/*:
 Tehdään näkymä. Tätä varten JyPelissä on yksi "aliohjelma",
 mutta SpriteKitillä joudumme kirjoittamaan sen auki.  Ei
 hätää, tämä on helppoa!

 Luodaan ensin näytön koon sisältävä olio: */
let sceneSize = CGSize(width: 400.0, height: 400.0)
/*:
 Sitten luodaan `SKView`, eli näkymäolio, joka tulee
 näyttämään *näyttämön*, eli `SKScene`-olion.
 Näkymäolio tarvitsee tiedon kehyksestä (*frame*), joka
 kertoo origon, eli vasemman alanurkan paikan, sekä
 näkymän koon.  Origo menee nollaan kätevästi
 vakiolla `CGPoint.zero`, ja `sceneSize` kertoo koon. */
let view = SKView(frame: CGRect(origin: CGPoint.zero, size: sceneSize))
/*:
 Ja vielä itse näyttämö, eli *skene*.  Tässä käytetään apuna
 näkymäoliolle annettua koko-oliota.*/
var level = SKScene(size: sceneSize)
//: Nyt näkymälle pitää vielä kertoa, mitä skeneä se näyttää:
view.presentScene(level)
//: Ja sitten asetetaan skenen taustavääri tyylikkäästi mustaksi.
level.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
/*:
 Jep, tuo on värivakio, ja sitä klikkaamalla väriä voi vaihtaa
 kätevän värieditorin avulla.  Toki olisi voitu kirjoittaa
 `SKColor.black`, mutta noin on mukavampi.

 Tämä tuo SpriteKitin näkymän esille leikkikentän
 apueditoriin tuohon oikealle.*/
PlaygroundPage.current.liveView = view
/*:
 Tuo on vähän hankalaa, varsinkin kun tuossa välissä näkyy jo olioiden arvoja.  Ehkä Apple tekee tästä
 mukavampaa seuraavissa Xcode-versioissa.

 ### Lisätehtävä: Entäs fysiikkamoottori?

 Tarjolla on myös fysiikkamoottori, mutta olen kommentoinut sen
 pois päältä.  Jos haluat, voit poistaa seuraavan pätkän
 alusta pois `//`-merkit, jolloin skene saa rajat ja fysiikan.*/
// let borders = SKPhysicsBody(edgeLoopFrom: level.frame)
// borders.friction = 0
// level.physicsBody = borders
// level.physicsWorld.gravity = CGVector(dx: 0, dy: -0.9)
/*:
 Eli ensin tehdään rajat, jotteivat pallot karkaa.  Rajojen
 kitka nollataan.  Sitten skenelle `level` lisätään fysiikkakappale
 ja kerrotaan, mihin suuntaan painovoima vaikuttaa.  Spritekitin
 y-akseli kasvaa ylöspäin, mutta siitä lisää myöhemmin.*/
/*:
 ## Lumiukon piirto annettuun paikkaan.

 Alla on esitelty aliohjelma, joka piirtää lumiukon
 haluttuun paikkaan.  Huomaa myös aliohjelman päällä
 oleva dokumentointikommentti, joka näkyy QuickHelpissä,
 eli jos jätät hiiren osoittimen funktion nimen päälle,
 näkyy sen dokumentaatio pienessä ponnahdusikkunassa.

 Ohjeet noiden kirjoittamiseen löytyvät `Help`-valikosta
 löytyvästä dokumentaatiosta, sekä osoitteesta
 [https://developer.apple.com/library/content/documentation/Swift/Reference/Playground_Ref/Chapters/MarkupReference.html](https://developer.apple.com/library/content/documentation/Swift/Reference/Playground_Ref/Chapters/MarkupReference.html)*/
/// Aliohjelma piirtää lumiukon
/// annettuun paikkaan.
///
/// Parameters:
///   - level: SKScene, johon lumiukko lisätään.
///   - x: Lumiukon alimman pallon x-koordinaatti.
///   - y: Lumiukon alimman pallon y-koordinaatti.
func piirräLumiukko(level:SKScene, x:CGFloat, y:CGFloat) {
/*:
  Swiftissä tyyppi kirjoitetaan parametrin nimen jälkeen kaksoispisteellä erotettuna.  Yleensä tyyppejä ei tarvitse kirjoittaa, mutta parametrien kohdalla ne ovat pakollisia.

 Sitten luodaan ensimmäinen pallo.  Valitaan pallolle parametrina välitetty y-koordinaatti muuttujaan `pallonY`.  Sitten luodaan `SKShapeNode`, joka rakentimen parametrilla valitaan tekemään `2*50.0` yksikön säteellä oleva ympyrä.  Hassut tapa sanoa sata, mutta se on noin, jotta on helpompi löytää sitten pallon piirtoa varten tehtävän aliohjelman koodi.  Samasta syystä käytetään `palloY`:tä eikä vain `y`:tä. */
    var pallonY = y
    let p1 = SKShapeNode(circleOfRadius: 2 * 50.0)
//: Pallolle annetaan valkea väri ja se sijoitetaan parametrien mukaiseen paikkaan.
    p1.fillColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
    p1.position = CGPoint(x: x, y: pallonY)
//: Ja sitten taas lisätehtävä: Jos haluat pallon tottelevan fysiikkamoottoria, pitää sille luoda oma fysiikkakappale sekä kertoa pallon massa.  Yksikön saat päättää itse.
    // p1.physicsBody = SKPhysicsBody(circleOfRadius: 2*50.0)
    // p1.physicsBody?.mass = 3.0
//: Sitten vielä lisätään pallo skeneen.
    level.addChild(p1)

//: Sama toistuu nyt kahdesti. Voit muokata noita arvoja ja kokeilla, miten muokkaukset vaikuttavat lopputulokseen.
    pallonY = 100.0 + 50
    let p2 = SKShapeNode(circleOfRadius: 2 * 25.0)
    p2.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    p2.position = CGPoint(x: 0, y: pallonY)
    // p2.physicsBody = SKPhysicsBody(circleOfRadius: 2*25.0)
    // p2.physicsBody?.mass = 1.0
    p1.addChild(p2)

    pallonY += 50.0 + 25.0
    let p3 = SKShapeNode(circleOfRadius: 2 * 12.5)
    p3.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    p3.position = CGPoint(x: 0, y: pallonY)
    // p3.physicsBody = SKPhysicsBody(circleOfRadius: 2*12.5)
    // p3.physicsBody?.mass = 0.5
    p1.addChild(p3)

//: Lopuksi vielä lisätehtävää varten voidaan ensimmäiseen palloon kohdistaa impulssivoima, jotta kuvaruudulla tapahtuisi jotain.
    // p1.physicsBody?.applyImpulse(CGVector(dx: 15.0, dy: 0), at:p1.position)
}

/*:
 ## Ajo

 No niin, nyt olemme valmiit kutsumaan aliohjelmaamme.
 Swiftin aliohjelman kutsussa tulee mainita parametrin
 nimi ennen parametrin arvoa.  Tuntuu tylsälle, mutta sen
 avulla koodista saa luettavampaa ja auttaa se lisämäärittelyssäkin.
 Nyt tuo ei ole kovin kaunis kutsu, koska halusin pysyä C#-esimerkin
 kanssa mahdollisimman samanlaisena.*/
piirräLumiukko(level: level, x: level.size.width/2, y: level.position.y + 100.0)
//: Ääkköset nimissä eivät nyt haittaa, sillä Swift on UTF-8:aa käyttävä kieli.  Tämän takia Swiftin merkkijonot ovatkin vähän erikoisempia, mutta se on toinen juttu...