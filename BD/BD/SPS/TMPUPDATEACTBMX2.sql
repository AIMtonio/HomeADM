-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPUPDATEACTBMX2
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPUPDATEACTBMX2`;DELIMITER $$

CREATE PROCEDURE `TMPUPDATEACTBMX2`(	)
TerminaStore: BEGIN

Update ACTIVIDADESBMX set Descripcion='FABRICACION DE TEQUILA Y MEZCAL', ActividadINEGIID=3120, NumeroCNBV='2100006' where ActividadBMXID='2111011060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE AGUARDIENTE DE CAÑA', ActividadINEGIID=3120, NumeroCNBV='2100006' where ActividadBMXID='2112019060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE SOTOL', ActividadINEGIID=3120, NumeroCNBV='2100006' where ActividadBMXID='2113017060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTROS AGUARDIENTES NO DE CAÑA', ActividadINEGIID=3120, NumeroCNBV='2100006' where ActividadBMXID='2114015060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE VINOS Y OTROS LICORES', ActividadINEGIID=3120, NumeroCNBV='2100006' where ActividadBMXID='2114023060';
Update ACTIVIDADESBMX set Descripcion='ELABORACION DE PULQUE', ActividadINEGIID=3120, NumeroCNBV='2100006' where ActividadBMXID='2115013060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE SIDRA  CHAMPAÂA Y OTRAS BEBIDAS FERMENTADAS  EXCEPTO LAS MALTEADAS', ActividadINEGIID=3120, NumeroCNBV='2100006' where ActividadBMXID='2119015060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE MALTA', ActividadINEGIID=3121, NumeroCNBV='2100006' where ActividadBMXID='2121010060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CERVEZA', ActividadINEGIID=3121, NumeroCNBV='2100006' where ActividadBMXID='2122018060';
Update ACTIVIDADESBMX set Descripcion='EMBOTELLADO DE AGUAS MINERALES', ActividadINEGIID=3122, NumeroCNBV='2100006' where ActividadBMXID='2131019060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE BEBIDAS GASEOSAS', ActividadINEGIID=3122, NumeroCNBV='2100006' where ActividadBMXID='2131027060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE REFRESCOS DE FRUTAS NATURALES', ActividadINEGIID=3122, NumeroCNBV='2100006' where ActividadBMXID='2131035060';
Update ACTIVIDADESBMX set Descripcion='PURIFICACION DE AGUA  EXCEPTO CAPTACION TRATAMIENTO CONDUCCION      Y DISTRIBUCION DE AGUA POTABLE', ActividadINEGIID=3122, NumeroCNBV='2100006' where ActividadBMXID='2131043060';
Update ACTIVIDADESBMX set Descripcion='DESECADO DE TABACO', ActividadINEGIID=3123, NumeroCNBV='2200004' where ActividadBMXID='2211019060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CIGARROS', ActividadINEGIID=3123, NumeroCNBV='2200004' where ActividadBMXID='2212017060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PUROS', ActividadINEGIID=3123, NumeroCNBV='2200004' where ActividadBMXID='2219013060';
Update ACTIVIDADESBMX set Descripcion='PICADO DE TABACO', ActividadINEGIID=3123, NumeroCNBV='2200004' where ActividadBMXID='2219021060';
Update ACTIVIDADESBMX set Descripcion='DESFIBRACION DE ALGODON', ActividadINEGIID=3224, NumeroCNBV='2300002' where ActividadBMXID='2311017060';
Update ACTIVIDADESBMX set Descripcion='DESPEPITE DE ALGODON', ActividadINEGIID=3224, NumeroCNBV='2300002' where ActividadBMXID='2311025060';
Update ACTIVIDADESBMX set Descripcion='COMPRESORA DE ALGODON', ActividadINEGIID=3224, NumeroCNBV='2300002' where ActividadBMXID='2311033060';
Update ACTIVIDADESBMX set Descripcion='BENEFICIO DE LANAS', ActividadINEGIID=3224, NumeroCNBV='2300002' where ActividadBMXID='2312015060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE HILADOS Y TEJIDOS DE ALGODON', ActividadINEGIID=3224, NumeroCNBV='2300002' where ActividadBMXID='2312031060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE HILADOS Y TEJIDOS DE LANA', ActividadINEGIID=3224, NumeroCNBV='2300002' where ActividadBMXID='2312049060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE HILOS PARA COSER', ActividadINEGIID=3224, NumeroCNBV='2300002' where ActividadBMXID='2313013060';
Update ACTIVIDADESBMX set Descripcion='ACABADO DE HILOS', ActividadINEGIID=3224, NumeroCNBV='2300002' where ActividadBMXID='2313021060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTROS HILADOS Y TEJIDOS NO SINTETICOS', ActividadINEGIID=3224, NumeroCNBV='2300002' where ActividadBMXID='2313039060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ESTAMBRES', ActividadINEGIID=3224, NumeroCNBV='2300002' where ActividadBMXID='2314011060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE SARAPES Y COBIJAS', ActividadINEGIID=3224, NumeroCNBV='2300002' where ActividadBMXID='2315019060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CASIMIRES Y PAÑOS', ActividadINEGIID=3224, NumeroCNBV='2300002' where ActividadBMXID='2315027060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE HILADOS Y TEJIDOS DE SEDA', ActividadINEGIID=3224, NumeroCNBV='2300002' where ActividadBMXID='2317015060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTROS ARTICULOS DE LANA', ActividadINEGIID=3224, NumeroCNBV='2300002' where ActividadBMXID='2317023060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTRAS TELAS MIXTAS  DE FIBRAS BLANDAS', ActividadINEGIID=3224, NumeroCNBV='2300002' where ActividadBMXID='2317031060';
Update ACTIVIDADESBMX set Descripcion='ACABADO DE TELAS', ActividadINEGIID=3224, NumeroCNBV='2300002' where ActividadBMXID='2319011060';
Update ACTIVIDADESBMX set Descripcion='DESFIBRACION DE HENEQUEN', ActividadINEGIID=3225, NumeroCNBV='2300002' where ActividadBMXID='2331015060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE HILADOS Y TEJIDOS DE HENEQUEN', ActividadINEGIID=3225, NumeroCNBV='2300002' where ActividadBMXID='2332013060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ARTICULOS DE PALMA Y TULE', ActividadINEGIID=3225, NumeroCNBV='2300002' where ActividadBMXID='2333011060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE TEJIDOS Y TORCIDOS DE PALMA', ActividadINEGIID=3225, NumeroCNBV='2300002' where ActividadBMXID='2333029060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE TEJIDOS Y TORCIDOS DE IXTLE', ActividadINEGIID=3225, NumeroCNBV='2300002' where ActividadBMXID='2333037060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE HILADOS Y TEJIDOS DE YUTE', ActividadINEGIID=3225, NumeroCNBV='2300002' where ActividadBMXID='2339019060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE HILADOS Y TEJIDOS DE FIBRA DE COCO', ActividadINEGIID=3225, NumeroCNBV='2300002' where ActividadBMXID='2339027060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE TOALLAS', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2316017060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE COLCHAS', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2316025060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CINTAS AGUJETAS Y LISTONES', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2318013060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ENCAJES', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2318021060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE TELAS ELASTICAS', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2318039060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ARTICULOS DE LONA', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2391019060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE LONA', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2391019160';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE TELAS IMPERMEABLES', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2391035060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE TAPETES Y ALFOMBRAS', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2392017060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE TELAS PARA TAPICERIA', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2392025060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ENTRETELAS Y FIELTROS', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2393015060';
Update ACTIVIDADESBMX set Descripcion='BENEFICIO DE PELO Y CERDA PARA LA INDUSTRIA TEXTIL', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2394013060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE BORRAS Y ESTOPAS', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2394021060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTROS ARTICULOS DE ALGODON', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2394039060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE SABANAS', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2431013060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CORTINAS DE TELA Y MANTELERIA', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2431021060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CUBREASIENTOS PARA VEHICULOS', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2432011060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE TAPICES PLASTICOS', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2432029060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ALGODON ABSORBENTE VENDAS TELA ADEHESIVA Y PRODUCTOS SIMILARES', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2433019060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ARTICULOS BORDADOS Y DESHILADOS', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2434017060';
Update ACTIVIDADESBMX set Descripcion='FORRADO DE BOTONES Y HEBILLAS', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2434025060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE BANDERAS Y ADORNOS DE TELA', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2439017060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE COSTALES', ActividadINEGIID=3226, NumeroCNBV='2300002' where ActividadBMXID='2439025060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CALCETINES', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2321016060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE MEDIAS', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2321024060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE SUETERES', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2322014060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE HILADOS Y TEJIDOS DE OTRAS FIBRAS SINTETICAS', ActividadINEGIID=3227, NumeroCNBV='2300002' where ActividadBMXID='2329010060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE VESTIDOS Y OTRAS PRENDAS EXTERIORES DE VESTIR PARA DAMA', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2411015060';
Update ACTIVIDADESBMX set Descripcion='TALLER DE CONFECCION DE VESTIDOS', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2411023060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTRAS PRENDAS EXTERIORES DE VESTIR PARA CABALLERO', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2412013060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE TRAJES PARA CABALLERO', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2412021060';
Update ACTIVIDADESBMX set Descripcion='TALLER DE SASTRERIA', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2412039060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE UNIFORMES', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2413011060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CAMISAS', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2414019060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTRAS PRENDAS EXTERIORES DE VESTIR PARA NIÂO', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2415017060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CORBATAS', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2416015060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE GUANTES', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2416023060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PAÑUELOS PAÑOLETAS Y MASCADAS', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2416031060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CACHUCHAS Y GORRAS', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2417013060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE SOMBREROS EXCEPTO DE PALMA', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2417021060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE SOMBREROS DE PALMA', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2418011060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CHAMARRAS Y ABRIGOS', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2419019060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE IMPERMEABLES', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2419027060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE TIRANTES', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2419035060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE MANTONES Y CHALINAS', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2419043060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE REBOZOS Y CINTURONES TEJIDOS DE HILO', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2419051060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ROPA CON PIEL', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2419069060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CORSETERIA Y ROPA INTERIOR PARA DAMA', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2421014060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ROPA INTERIOR PARA CABALLERO', ActividadINEGIID=3227, NumeroCNBV='2400000' where ActividadBMXID='2429018060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CALZADO PARA DEPORTE EXCEPTO DE PLASTICO Y HULE', ActividadINEGIID=3228, NumeroCNBV='2500008' where ActividadBMXID='2511013060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ALPARGATAS BABUCHAS Y PANTUFLAS', ActividadINEGIID=3228, NumeroCNBV='2500008' where ActividadBMXID='2512011060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE HUARACHES Y SANDALIAS', ActividadINEGIID=3228, NumeroCNBV='2500008' where ActividadBMXID='2512029060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CALZADO DE CUERO O PIEL', ActividadINEGIID=3228, NumeroCNBV='2500008' where ActividadBMXID='2519017060';
Update ACTIVIDADESBMX set Descripcion='CURTIDURIA', ActividadINEGIID=3228, NumeroCNBV='2500008' where ActividadBMXID='2521012060';
Update ACTIVIDADESBMX set Descripcion='PREPARACION DE VISCERAS PARA INDUSTRIAS NO ALIMENTICIAS', ActividadINEGIID=3228, NumeroCNBV='2500008' where ActividadBMXID='2521020060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CEPILLOS Y PLUMEROS', ActividadINEGIID=3228, NumeroCNBV='2500008' where ActividadBMXID='2529016060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ARTICULOS DE CUERO PARA VIAJE', ActividadINEGIID=3228, NumeroCNBV='2500008' where ActividadBMXID='2529024060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ARTICULOS DE CUERO Y HUESO', ActividadINEGIID=3228, NumeroCNBV='2500008' where ActividadBMXID='2529032060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ARTICULOS DE CUERO Y PIEL PARA ZAPATERO', ActividadINEGIID=3228, NumeroCNBV='2500008' where ActividadBMXID='2529040060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ARTICULOS TEJIDOS DE CUERO', ActividadINEGIID=3228, NumeroCNBV='2500008' where ActividadBMXID='2529058060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE BANDAS Y CORREAS DE CUERO', ActividadINEGIID=3228, NumeroCNBV='2500008' where ActividadBMXID='2529066060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE BOLSAS Y CARTERAS DE CUERO', ActividadINEGIID=3228, NumeroCNBV='2500008' where ActividadBMXID='2529074060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE BROCHAS Y PINCELES', ActividadINEGIID=3959, NumeroCNBV='3900009' where ActividadBMXID='2529082060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE FORNITURAS MILITARES DE CUERO', ActividadINEGIID=3228, NumeroCNBV='2500008' where ActividadBMXID='2529090060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTROS ARTICULOS DE CUERO', ActividadINEGIID=3228, NumeroCNBV='2500008' where ActividadBMXID='2529107060';
Update ACTIVIDADESBMX set Descripcion='TALABARTERIA', ActividadINEGIID=3228, NumeroCNBV='2500008' where ActividadBMXID='2529115060';
Update ACTIVIDADESBMX set Descripcion='ASERRADERO', ActividadINEGIID=3329, NumeroCNBV='2600006' where ActividadBMXID='2611011060';
Update ACTIVIDADESBMX set Descripcion='BENEFICIO DE MADERAS (DESFLEMADO  ESTUFADO  CEPILLADO  ETC.)', ActividadINEGIID=3329, NumeroCNBV='2600006' where ActividadBMXID='2611029060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE TRIPLAY Y OTROS AGLOMERADOS DE MADERA', ActividadINEGIID=3329, NumeroCNBV='2600006' where ActividadBMXID='2612019060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CAJAS Y EMPAQUES DE MADERA', ActividadINEGIID=3330, NumeroCNBV='2600006' where ActividadBMXID='2621010060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE TONELES Y BARRICAS DE MADERA', ActividadINEGIID=3330, NumeroCNBV='2600006' where ActividadBMXID='2621028060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ARTICULOS DE PALMA VARA CARRIZO MIMBRE Y SIMILARES', ActividadINEGIID=3330, NumeroCNBV='2600006' where ActividadBMXID='2622018060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ATAUDES DE MADERA', ActividadINEGIID=3330, NumeroCNBV='2600006' where ActividadBMXID='2631019060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE JUNTAS Y EMPAQUES DE CORCHO', ActividadINEGIID=3330, NumeroCNBV='2600006' where ActividadBMXID='2632017060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTROS ARTICULOS DE CORCHO', ActividadINEGIID=3330, NumeroCNBV='2600006' where ActividadBMXID='2632025060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ASBESTOS Y CORCHOS AISLANTES', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='2632033070';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE DUELAS Y OTROS MATERIALES DE MADERA PARA PISO', ActividadINEGIID=3330, NumeroCNBV='2600006' where ActividadBMXID='2633015060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PUERTAS Y VENTANAS DE MADERA', ActividadINEGIID=3330, NumeroCNBV='2600006' where ActividadBMXID='2633023060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CARROCERIAS Y REDILAS DE MADERA', ActividadINEGIID=3330, NumeroCNBV='2600006' where ActividadBMXID='2639013060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE MANGOS DE MADERA', ActividadINEGIID=3330, NumeroCNBV='2600006' where ActividadBMXID='2639021060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTROS ARTICULOS DE MADERA', ActividadINEGIID=3330, NumeroCNBV='2600006' where ActividadBMXID='2639039060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE MUEBLES DE MADERA', ActividadINEGIID=3330, NumeroCNBV='2700004' where ActividadBMXID='2711019060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE MUEBLES DE MATERIAL SINTETICO', ActividadINEGIID=3330, NumeroCNBV='2700004' where ActividadBMXID='2711027060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PERSIANAS DE MADERA', ActividadINEGIID=3330, NumeroCNBV='2700004' where ActividadBMXID='2712017060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ALMOHADAS Y COJINES', ActividadINEGIID=3330, NumeroCNBV='2400000' where ActividadBMXID='2713015060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE COLCHONES Y COLCHONETAS', ActividadINEGIID=3330, NumeroCNBV='2700004' where ActividadBMXID='2713023060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE MARCOS Y MOLDURAS DE MADERA', ActividadINEGIID=3330, NumeroCNBV='2600006' where ActividadBMXID='2719013060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PAPEL', ActividadINEGIID=3431, NumeroCNBV='2800002' where ActividadBMXID='2811017060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PAPEL PARA CIGARROS', ActividadINEGIID=3431, NumeroCNBV='2800002' where ActividadBMXID='2811025060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PASTA DE CELULOSA', ActividadINEGIID=3431, NumeroCNBV='2800002' where ActividadBMXID='2811033060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PASTA O PULPA PARA PAPEL', ActividadINEGIID=3431, NumeroCNBV='2800002' where ActividadBMXID='2811041060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CARTON', ActividadINEGIID=3431, NumeroCNBV='2800002' where ActividadBMXID='2812015060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE SACOS Y BOLSAS DE PAPEL PARA ENVASE', ActividadINEGIID=3431, NumeroCNBV='2800002' where ActividadBMXID='2821016060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ENVASES DE CARTON', ActividadINEGIID=3431, NumeroCNBV='2800002' where ActividadBMXID='2822014060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTROS ARTICULOS DE CARTON', ActividadINEGIID=3431, NumeroCNBV='2800002' where ActividadBMXID='2829010060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTROS ARTICULOS DE PAPEL', ActividadINEGIID=3431, NumeroCNBV='2800002' where ActividadBMXID='2829028060';
Update ACTIVIDADESBMX set Descripcion='EDICION DE PERIODICOS Y REVISTAS', ActividadINEGIID=3432, NumeroCNBV='2900000' where ActividadBMXID='2911015060';
Update ACTIVIDADESBMX set Descripcion='EDICION DE LIBROS', ActividadINEGIID=3432, NumeroCNBV='2900000' where ActividadBMXID='2912013060';
Update ACTIVIDADESBMX set Descripcion='ENCUADERNACION', ActividadINEGIID=3432, NumeroCNBV='2900000' where ActividadBMXID='2921014060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE FORMULARIOS Y FORMAS CONTINUAS', ActividadINEGIID=3432, NumeroCNBV='2900000' where ActividadBMXID='2921022060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE LIBRETAS CUADERNOS Y HOJAS PARA ENCUADERNACION', ActividadINEGIID=3432, NumeroCNBV='2900000' where ActividadBMXID='2921030060';
Update ACTIVIDADESBMX set Descripcion='FOTOCOPIADO', ActividadINEGIID=3432, NumeroCNBV='2900000' where ActividadBMXID='2921048060';
Update ACTIVIDADESBMX set Descripcion='IMPRENTA ( TIPOGRAFIA )', ActividadINEGIID=3432, NumeroCNBV='2900000' where ActividadBMXID='2921056060';
Update ACTIVIDADESBMX set Descripcion='IMPRESION MEDIANTE CILINDROS DE CAUCHO', ActividadINEGIID=3432, NumeroCNBV='2900000' where ActividadBMXID='2921064060';
Update ACTIVIDADESBMX set Descripcion='IMPRESION MEDIANTE CILINDROS (ROTOGRABADO)', ActividadINEGIID=3432, NumeroCNBV='2900000' where ActividadBMXID='2921072060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CALCOMANIAS', ActividadINEGIID=3432, NumeroCNBV='2900000' where ActividadBMXID='2929018060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE TIPOS PARA IMPRENTA', ActividadINEGIID=3432, NumeroCNBV='2900000' where ActividadBMXID='2929026080';
Update ACTIVIDADESBMX set Descripcion='GRABADO E IMPRESION EN PIEDRA  VIDRIO Y OTROS MATERIALES LITOGRAFIA Y FOTOLITOGRAFIA', ActividadINEGIID=3432, NumeroCNBV='2900000' where ActividadBMXID='2929034060';
Update ACTIVIDADESBMX set Descripcion='GRABADO E IMPRESION FOTOMECANICA MEDIANTE AGUA FUERTE(HELIOGRABADO)', ActividadINEGIID=3432, NumeroCNBV='2900000' where ActividadBMXID='2929042060';
Update ACTIVIDADESBMX set Descripcion='GRABADO EN METAL (FABRICACION DE CLICHES Y FOTOGRABADO)', ActividadINEGIID=3432, NumeroCNBV='2900000' where ActividadBMXID='2929050060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE GASOLINA Y OTROS PRODUCTOS DERIVADOS DE LA REFINACION DE PETROLEO', ActividadINEGIID=3533, NumeroCNBV='3100005' where ActividadBMXID='3111010040';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE MATERIALES ASFALTICOS PARA PAVIMENTACION Y TECHADO', ActividadINEGIID=3533, NumeroCNBV='3100005' where ActividadBMXID='3122017070';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PRODUCTOS PETROQUIMICOS BASICOS', ActividadINEGIID=3534, NumeroCNBV='3000007' where ActividadBMXID='3112018060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ACEITES Y LUBRICANTES', ActividadINEGIID=3534, NumeroCNBV='3000007' where ActividadBMXID='3113016060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ANIL', ActividadINEGIID=3535, NumeroCNBV='3000007' where ActividadBMXID='3011012060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ANILINAS', ActividadINEGIID=3535, NumeroCNBV='3000007' where ActividadBMXID='3011020060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTRAS MATERIAS COLORANTES', ActividadINEGIID=3535, NumeroCNBV='3000007' where ActividadBMXID='3011038060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE GAS ACETILENO', ActividadINEGIID=3535, NumeroCNBV='3000007' where ActividadBMXID='3012010060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ACIDOS INDUSTRIALES', ActividadINEGIID=3535, NumeroCNBV='3000007' where ActividadBMXID='3013018060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTRAS SUBSTANCIAS QUIMICAS BASICAS', ActividadINEGIID=3535, NumeroCNBV='3000007' where ActividadBMXID='3013026060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PRODUCTOS AMONIACALES', ActividadINEGIID=3535, NumeroCNBV='3000007' where ActividadBMXID='3013034060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE SOSA', ActividadINEGIID=3535, NumeroCNBV='3000007' where ActividadBMXID='3013042060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ABONOS Y FERTILIZANTES QUIMICOS', ActividadINEGIID=3536, NumeroCNBV='3000007' where ActividadBMXID='3021011060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE HULE ESPUMA', ActividadINEGIID=3537, NumeroCNBV='3200003' where ActividadBMXID='3031010060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE FIBRAS SINTETICAS', ActividadINEGIID=3537, NumeroCNBV='3200003' where ActividadBMXID='3032018060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ALGODON ESTERILIZADO  GASAS Y VENDAS', ActividadINEGIID=3538, NumeroCNBV='3000007' where ActividadBMXID='3051018060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTROS PRODUCTOS FARMACEUTICOS Y MEDICAMENTOS', ActividadINEGIID=3538, NumeroCNBV='3000007' where ActividadBMXID='3051026060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OXIGENO MEDICINAL', ActividadINEGIID=3538, NumeroCNBV='3000007' where ActividadBMXID='3051034060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE DENTIFRICO', ActividadINEGIID=3539, NumeroCNBV='3000007' where ActividadBMXID='3061017060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE JABON Y DETERGENTE', ActividadINEGIID=3539, NumeroCNBV='3000007' where ActividadBMXID='3061025060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PERFUMES Y COSMETICOS', ActividadINEGIID=3539, NumeroCNBV='3000007' where ActividadBMXID='3062015060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE INSECTICIDAS Y PLAGUICIDAS', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3022201906';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PINTURAS  BARNICES Y LACAS', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3041019060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ESENCIAS', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3071016060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION Y REFINACION DE SEBO GRASAS Y ACEITES ANIMALES PARA USO INDUSTRIAL', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3072014060';
Update ACTIVIDADESBMX set Descripcion='HIDROGENADORA DE PRODUCTOS DIVERSOS', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3072030060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE COLAS Y PEGAMENTOS', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3091014060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE IMPERMEABILIZANTES', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3091022060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CERA PULIMENTOS Y ABRILLANTADORES', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3092012060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE DESINFECTANTES Y DESODORIZANTES', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3092020060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE GRASAS Y CREMAS LUSTRADORAS', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3092038060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE LANOLINA', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3092046060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE AGUARRAS', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3093010060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE TINTAS PARA IMPRESION', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3096014060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE DINAMITA', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3097012060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE MECHAS PARA MINAS', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3097020060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTROS EXPLOSIVOS', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3097038060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE POLVORA', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3097046060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PRODUCTOS PIROTECNICOS', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3097054060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ARTICULOS DE BAQUELITA', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3099018060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE DESINCRUSTANTES', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3099026060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE HIELO SECO', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3099034060';
Update ACTIVIDADESBMX set Descripcion='INDUSTRIALIZACION DE BASURA', ActividadINEGIID=3540, NumeroCNBV='3000007' where ActividadBMXID='3099042060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE LLANTAS Y CAMARAS PARA VEHICULOS', ActividadINEGIID=3541, NumeroCNBV='3200003' where ActividadBMXID='3211018060';
Update ACTIVIDADESBMX set Descripcion='REGENERACION DE HULE', ActividadINEGIID=3541, NumeroCNBV='3200003' where ActividadBMXID='3212016060';
Update ACTIVIDADESBMX set Descripcion='VULCANIZACION DE LLANTAS Y CAMARAS', ActividadINEGIID=3541, NumeroCNBV='3200003' where ActividadBMXID='3212024060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ARTICULOS CON HULE USADO', ActividadINEGIID=3541, NumeroCNBV='3200003' where ActividadBMXID='3219012060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE LINOLEO', ActividadINEGIID=3541, NumeroCNBV='3200003' where ActividadBMXID='3219020060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTROS ARTICULOS DE HULE', ActividadINEGIID=3541, NumeroCNBV='3200003' where ActividadBMXID='3219038060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE LAMINAS PERFILES TUBOS Y OTROS MATERIALES SIMILARES  DE PLASTICO', ActividadINEGIID=3542, NumeroCNBV='3200003' where ActividadBMXID='3221017060';


END TerminaStore$$