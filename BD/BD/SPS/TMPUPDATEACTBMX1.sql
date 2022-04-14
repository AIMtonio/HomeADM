-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPUPDATEACTBMX1
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPUPDATEACTBMX1`;DELIMITER $$

CREATE PROCEDURE `TMPUPDATEACTBMX1`(	)
TerminaStore: BEGIN

Update ACTIVIDADESBMX set Descripcion='EMPLEADO DEL SECTOR AGROPECUARIO', ActividadINEGIID=1, NumeroCNBV='9501009' where ActividadBMXID='149907010';
Update ACTIVIDADESBMX set Descripcion='EMPLEADO DEL SECTOR INDUSTRIAL', ActividadINEGIID=1, NumeroCNBV='9501009' where ActividadBMXID='3999903060';
Update ACTIVIDADESBMX set Descripcion='PROFESIONISTA INDEPENDIENTE', ActividadINEGIID=1, NumeroCNBV='9501009' where ActividadBMXID='8415011251';
Update ACTIVIDADESBMX set Descripcion='AMA DE CASA', ActividadINEGIID=1, NumeroCNBV='9506009' where ActividadBMXID='8949888161';
Update ACTIVIDADESBMX set Descripcion='ESTUDIANTE', ActividadINEGIID=1, NumeroCNBV='9506009' where ActividadBMXID='8949888162';
Update ACTIVIDADESBMX set Descripcion='JUBILADO', ActividadINEGIID=1, NumeroCNBV='9506009' where ActividadBMXID='8949888163';
Update ACTIVIDADESBMX set Descripcion='EMPLEADO DEL SECTOR SERVICIOS', ActividadINEGIID=1, NumeroCNBV='9501009' where ActividadBMXID='8949903160';
Update ACTIVIDADESBMX set Descripcion='EMPLEADO DE GOBIERNO', ActividadINEGIID=1, NumeroCNBV='9502007' where ActividadBMXID='9411901190';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE ALPISTE', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='111013010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE ARROZ', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='111021010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE AVENA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='111039010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE CEBADA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='111047010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE LINAZA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='111055010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE MAIZ', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='111063010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE SORGO', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='111089010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE SOYA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='111097010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE TRIGO', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='111104010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE AJO', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='112011010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE CALABAZA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='112029010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE CAMOTE', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='112037010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE CEBOLLA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='112045010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE CHILE', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='112053010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE ESPARRAGO', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='112061010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE FRIJOL', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='112079010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE GARBANZO', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='112087010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE LENTEJA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='112102010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE NOPAL', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='112110010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE OTRAS HORTALIZAS', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='112128010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE PAPA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='112136010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE REMOLACHA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='112144010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE TOMATE', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='112152010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE ALFALFA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='113019010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE FRESA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='119017010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE MELON', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='119025010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE PIÂA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='119033010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE SANDIA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='119041010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE ALGODON', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='121012010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE CAÑA DE AZUCAR', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='122010010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE TABACO', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='123018010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE AJONJOLI', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='124016010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE CACAHUATE', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='124024010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE CARTAMO', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='124032010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE NUEZ', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='124040010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE OLIVO', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='124058010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE ESPECIAS', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='129016010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE OTRAS SEMILLAS', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='129024010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE SEMILLAS MEJORADAS', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='129032010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE VAINILLA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='129040010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE FLORES Y PLANTAS DE ORNATO', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='131011010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE CAFE', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='141010010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE AGUACATE', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='142018010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE DURAZNO', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='142026010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE GUAYABA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='142034010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE LIMON', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='142042010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE MANGO', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='142050010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE MANZANA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='142068010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE NARANJA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='142076010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE OTROS ARBOLES FRUTALES', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='142084010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE PAPAYA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='142092010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE PLATANO', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='142109010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE TAMARINDO', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='142117010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE TORONJA', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='142125010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE VID', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='143016010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE HENEQUEN', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='144014010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE LINO', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='144022010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE OTRAS FIBRAS DURAS', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='144030010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE AGAVE O MEZCAL', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='145012010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE MAGUEY', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='145020010';
Update ACTIVIDADESBMX set Descripcion='CULTIVO DE CACAO', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='147018010';
Update ACTIVIDADESBMX set Descripcion='IRRIGACION DE TIERRAS', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='191015010';
Update ACTIVIDADESBMX set Descripcion='PREPARACION DE TIERRAS DE CULTIVO Y OTROS SERVICIOS AGRICOLAS', ActividadINEGIID=1001, NumeroCNBV='0100008' where ActividadBMXID='191023010';
Update ACTIVIDADESBMX set Descripcion='CRIA Y EXPLOTACION DE GANADO VACUNO PARA CARNE', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='211011010';
Update ACTIVIDADESBMX set Descripcion='CRIA Y EXPLOTACION DE GANADO VACUNO PARA LECHE', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='212019010';
Update ACTIVIDADESBMX set Descripcion='CRIA DE GANADO DE LIDIA', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='213017010';
Update ACTIVIDADESBMX set Descripcion='CRIA DE GANADO CABALLAR', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='214015010';
Update ACTIVIDADESBMX set Descripcion='CRIA DE OTROS EQUINOS Y GANADO PARA EL TRABAJO', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='219015010';
Update ACTIVIDADESBMX set Descripcion='CRIA Y EXPLOTACION DE GANADO PORCINO', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='221010010';
Update ACTIVIDADESBMX set Descripcion='CRIA Y EXPLOTACION DE GANADO OVINO', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='222018010';
Update ACTIVIDADESBMX set Descripcion='CRIA Y EXPLOTACION DE GANADO CAPRINO', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='223016010';
Update ACTIVIDADESBMX set Descripcion='CRIA Y EXPLOTACION DE GALLINA PARA PRODUCCION DE HUEVO', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='231019010';
Update ACTIVIDADESBMX set Descripcion='CRIA Y EXPLOTACION DE POLLOS', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='232017010';
Update ACTIVIDADESBMX set Descripcion='CRIA Y EXPLOTACION DE OTRAS AVES PARA ALIMENTACION', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='233015010';
Update ACTIVIDADESBMX set Descripcion='CRIA Y EXPLOTACION DE ABEJAS', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='241018010';
Update ACTIVIDADESBMX set Descripcion='CRIA Y EXPLOTACION DE CONEJOS Y LIEBRES', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='251017010';
Update ACTIVIDADESBMX set Descripcion='CRIA Y EXPLOTACION DE ANIMALES DOMESTICOS  PARA LABORATORIO Y OTROS FINES NO ALIMENTICIOS', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='259011010';
Update ACTIVIDADESBMX set Descripcion='CRIA Y EXPLOTACION DE GUSANO DE SEDA', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='259029010';
Update ACTIVIDADESBMX set Descripcion='FORMACION DE PRADERAS Y POTREROS ARTIFICIALES', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='291013010';
Update ACTIVIDADESBMX set Descripcion='INSEMINACION ARTIFICIAL Y OTROS SERVICIOS DE GANADERIA', ActividadINEGIID=1002, NumeroCNBV='0200006' where ActividadBMXID='291021010';
Update ACTIVIDADESBMX set Descripcion='PLANTACION Y REFORESTACION', ActividadINEGIID=1003, NumeroCNBV='0300004' where ActividadBMXID='311019030';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION DE TRONCOS PARA ASERRADEROS Y PARA PULPA INCLUSO LA MADE RA TOSCAMENTE ASERRADA', ActividadINEGIID=1003, NumeroCNBV='0300004' where ActividadBMXID='312017030';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION DE CARBON VEGETAL', ActividadINEGIID=1003, NumeroCNBV='0300004' where ActividadBMXID='313015030';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION DE CHICLE', ActividadINEGIID=1003, NumeroCNBV='0300004' where ActividadBMXID='321018030';
Update ACTIVIDADESBMX set Descripcion='EXPLOTACION DE CANDELILLA', ActividadINEGIID=1003, NumeroCNBV='0300004' where ActividadBMXID='322016030';
Update ACTIVIDADESBMX set Descripcion='EXPLOTACION DE HULE', ActividadINEGIID=1003, NumeroCNBV='0300004' where ActividadBMXID='322024030';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION DE OTRAS RESINAS', ActividadINEGIID=1003, NumeroCNBV='0300004' where ActividadBMXID='322040030';
Update ACTIVIDADESBMX set Descripcion='EXPLOTACION DE RAICES', ActividadINEGIID=1003, NumeroCNBV='0300004' where ActividadBMXID='323014030';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION DE ALQUITRAN VEGETAL', ActividadINEGIID=1003, NumeroCNBV='0300004' where ActividadBMXID='323022030';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION DE TREMENTINA', ActividadINEGIID=1003, NumeroCNBV='0300004' where ActividadBMXID='323030030';
Update ACTIVIDADESBMX set Descripcion='CULTIVO Y EXPLOTACION DE PALMA Y LECHUGUILLA', ActividadINEGIID=1003, NumeroCNBV='0300004' where ActividadBMXID='329012030';
Update ACTIVIDADESBMX set Descripcion='EXPLOTACION DE BARBASCO ARBORESCENTES Y ARBUSTOS', ActividadINEGIID=1003, NumeroCNBV='0300004' where ActividadBMXID='329020030';
Update ACTIVIDADESBMX set Descripcion='SERVICIOS DE CORTADO ESTIMACION DEL VOLUMEN DE MADERA PROTECCION DE BOSQUES Y OTROS SERVICIOS RELACIONADOS', ActividadINEGIID=1003, NumeroCNBV='0300004' where ActividadBMXID='391011030';
Update ACTIVIDADESBMX set Descripcion='CAPTURA DE ATUN BONITO BARRILETE Y SIMILARES', ActividadINEGIID=1004, NumeroCNBV='0400002' where ActividadBMXID='411017030';
Update ACTIVIDADESBMX set Descripcion='CAPTURA DE SARDINA Y SIMILARES', ActividadINEGIID=1004, NumeroCNBV='0400002' where ActividadBMXID='412015030';
Update ACTIVIDADESBMX set Descripcion='CAPTURA DE TIBURON CAZON RAYA Y SIMILARES', ActividadINEGIID=1004, NumeroCNBV='0400002' where ActividadBMXID='413013030';
Update ACTIVIDADESBMX set Descripcion='CAPTURA DE CAMARON', ActividadINEGIID=1004, NumeroCNBV='0400002' where ActividadBMXID='421016030';
Update ACTIVIDADESBMX set Descripcion='CAPTURA DE OSTION', ActividadINEGIID=1004, NumeroCNBV='0400002' where ActividadBMXID='422014030';
Update ACTIVIDADESBMX set Descripcion='CAPTURA DE OTROS CRUSTACEOS Y MOLUSCOS MARINOS', ActividadINEGIID=1004, NumeroCNBV='0400002' where ActividadBMXID='429010030';
Update ACTIVIDADESBMX set Descripcion='CAPTURA DE TORTUGA Y OTROS REPTILES MARINOS', ActividadINEGIID=1004, NumeroCNBV='0400002' where ActividadBMXID='431015030';
Update ACTIVIDADESBMX set Descripcion='CAPTURA DE MAMIFEROS ANFIBIOS Y DIVERSOS INVERTEBRADOS DE MAR', ActividadINEGIID=1004, NumeroCNBV='0400002' where ActividadBMXID='439019030';
Update ACTIVIDADESBMX set Descripcion='RECOLECCION DE CONCHAS HUEVOS CORALES ESPONJAS Y PERLAS', ActividadINEGIID=1004, NumeroCNBV='0400002' where ActividadBMXID='441014030';
Update ACTIVIDADESBMX set Descripcion='RECOLECCION DE ALGAS Y OTRAS PLANTAS ACUATICAS', ActividadINEGIID=1004, NumeroCNBV='0400002' where ActividadBMXID='442012030';
Update ACTIVIDADESBMX set Descripcion='CAPTURA DE CRUSTACEOS MOLUSCOS REPTILES ANFIBIOS Y OTRA FAUNA DE AGUA DULCE', ActividadINEGIID=1004, NumeroCNBV='0400002' where ActividadBMXID='452011030';
Update ACTIVIDADESBMX set Descripcion='CRIA Y EXPLOTACION DE OSTRAS', ActividadINEGIID=1004, NumeroCNBV='0400002' where ActividadBMXID='459017030';
Update ACTIVIDADESBMX set Descripcion='SERVICIOS DE PESQUERIAS MARITIMAS Y DE AGUA DULCE POR CONTRATO', ActividadINEGIID=1004, NumeroCNBV='0400002' where ActividadBMXID='491019030';
Update ACTIVIDADESBMX set Descripcion='CAPTURA Y PRESERVACION DE ESPECIES ANIMALES SALVAJES', ActividadINEGIID=1004, NumeroCNBV='0500000' where ActividadBMXID='511015030';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION Y BENEFICIO DE CARBON MINERAL Y GRAFITO', ActividadINEGIID=2005, NumeroCNBV='1100007' where ActividadBMXID='1111012020';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE COQUE Y OTROS DERIVADOS DEL CARBON MINERAL', ActividadINEGIID=2005, NumeroCNBV='1100007' where ActividadBMXID='3121019070';
Update ACTIVIDADESBMX set Descripcion='EXPLORACION DE PETROLEO POR COMPAÑIAS', ActividadINEGIID=2006, NumeroCNBV='1200005' where ActividadBMXID='1211010040';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION DE PETROLEO CRUDO Y GAS NATURAL', ActividadINEGIID=2006, NumeroCNBV='1200005' where ActividadBMXID='1211028040';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION Y BENEFICIO DE MINERAL DE HIERRO', ActividadINEGIID=2007, NumeroCNBV='1300003' where ActividadBMXID='1311018020';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION Y BENEFICIO DE ORO PLATA Y OTROS METALES PRECIOSOS', ActividadINEGIID=2008, NumeroCNBV='1300003' where ActividadBMXID='1321017020';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION Y BENEFICIO DE MERCURIO Y ANTIMONIO', ActividadINEGIID=2008, NumeroCNBV='1300003' where ActividadBMXID='1322015020';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION Y BENEFICIO DE COBRE PLOMO  ZINC Y OTROS MINERALES NO FERROSOS', ActividadINEGIID=2008, NumeroCNBV='1300003' where ActividadBMXID='1329011020';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION Y BENEFICIO DE PIEDRA', ActividadINEGIID=2009, NumeroCNBV='1400001' where ActividadBMXID='1411016020';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION DE YESO', ActividadINEGIID=2009, NumeroCNBV='1400001' where ActividadBMXID='1412014020';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION Y BENEFICIO DE ARENA Y GRAVA', ActividadINEGIID=2009, NumeroCNBV='1400001' where ActividadBMXID='1413012020';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION Y BENEFICIO DE OTROS MATERIALES PARA CONSTRUCCION', ActividadINEGIID=2009, NumeroCNBV='1400001' where ActividadBMXID='1419010020';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION Y BENEFICIO DE ARCILLAS REFRACTARIAS', ActividadINEGIID=2009, NumeroCNBV='1400001' where ActividadBMXID='1421015020';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION Y BENEFICIO DE BARITA Y ROCA FOSFORICA', ActividadINEGIID=2010, NumeroCNBV='1400001' where ActividadBMXID='1431014020';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION Y BENEFICIO DE FLUORITA', ActividadINEGIID=2010, NumeroCNBV='1400001' where ActividadBMXID='1432012020';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION Y BENEFICIO DE SILICE', ActividadINEGIID=2010, NumeroCNBV='1400001' where ActividadBMXID='1433010020';
Update ACTIVIDADESBMX set Descripcion='EXTRACCION Y BENEFICIO DE OTROS MINERALES NO METALICOS EXCEPTO SAL', ActividadINEGIID=2010, NumeroCNBV='1400001' where ActividadBMXID='1439018020';
Update ACTIVIDADESBMX set Descripcion='EXPLOTACION DE SAL MARINA Y DE YACIMIENTOS', ActividadINEGIID=2010, NumeroCNBV='1500009' where ActividadBMXID='1511014020';
Update ACTIVIDADESBMX set Descripcion='RASTRO', ActividadINEGIID=3111, NumeroCNBV='2000008' where ActividadBMXID='2041010060';
Update ACTIVIDADESBMX set Descripcion='EMPACADORA DE CARNE', ActividadINEGIID=3111, NumeroCNBV='2000008' where ActividadBMXID='2049014060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CARNES FRIAS Y EMBUTIDOS', ActividadINEGIID=3111, NumeroCNBV='2000008' where ActividadBMXID='2049022060';
Update ACTIVIDADESBMX set Descripcion='REFRIGERACION DE CARNES', ActividadINEGIID=3111, NumeroCNBV='2000008' where ActividadBMXID='2049030060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION Y REHIDRATACION DE LECHE', ActividadINEGIID=3111, NumeroCNBV='2000008' where ActividadBMXID='2051019060';
Update ACTIVIDADESBMX set Descripcion='PASTEURIZACION HOMOGENEIZACION Y ENVASADO DE LECHE', ActividadINEGIID=3111, NumeroCNBV='2000008' where ActividadBMXID='2051027060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CREMA MANTEQUILLA Y QUESO', ActividadINEGIID=3111, NumeroCNBV='2000008' where ActividadBMXID='2052017060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE LECHE CONDENSADA EVAPORADA Y PULVERIZADA', ActividadINEGIID=3111, NumeroCNBV='2000008' where ActividadBMXID='2053015060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE GELATINAS', ActividadINEGIID=3111, NumeroCNBV='2000008' where ActividadBMXID='2054013060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE GRENETINA', ActividadINEGIID=3111, NumeroCNBV='2000008' where ActividadBMXID='2054021060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CAJETAS YOGOURTS Y OTROS PRODUCTOS A BASE DE LECHE', ActividadINEGIID=3111, NumeroCNBV='2000008' where ActividadBMXID='2059013060';
Update ACTIVIDADESBMX set Descripcion='DESHIDRATACION DE FRUTAS', ActividadINEGIID=3112, NumeroCNBV='2000008' where ActividadBMXID='2011013060';
Update ACTIVIDADESBMX set Descripcion='EMPACADORA DE CONSERVAS ALIMENTICIAS', ActividadINEGIID=3112, NumeroCNBV='2000008' where ActividadBMXID='2012011060';
Update ACTIVIDADESBMX set Descripcion='EMPACADORA DE FRUTAS Y LEGUMBRES', ActividadINEGIID=3112, NumeroCNBV='2000008' where ActividadBMXID='2012029060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CONCENTRADOS DE FRUTAS', ActividadINEGIID=3112, NumeroCNBV='2000008' where ActividadBMXID='2012037060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ENCURTIDOS', ActividadINEGIID=3112, NumeroCNBV='2000008' where ActividadBMXID='2012045060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE SALSAS', ActividadINEGIID=3112, NumeroCNBV='2000008' where ActividadBMXID='2014017060';
Update ACTIVIDADESBMX set Descripcion='MOLINO DE TRIGO', ActividadINEGIID=3113, NumeroCNBV='2000008' where ActividadBMXID='2021012060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PAN Y PASTELES', ActividadINEGIID=3113, NumeroCNBV='2000008' where ActividadBMXID='2071017060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CONOS PARA NIEVE', ActividadINEGIID=3113, NumeroCNBV='2000008' where ActividadBMXID='2072015060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE GALLETAS', ActividadINEGIID=3113, NumeroCNBV='2000008' where ActividadBMXID='2072023060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PASTAS ALIMENTICIAS', ActividadINEGIID=3113, NumeroCNBV='2000008' where ActividadBMXID='2072031060';
Update ACTIVIDADESBMX set Descripcion='MOLINO DE MAIZ', ActividadINEGIID=3114, NumeroCNBV='2000008' where ActividadBMXID='2022101060';
Update ACTIVIDADESBMX set Descripcion='MOLINO DE NIXTAMAL', ActividadINEGIID=3114, NumeroCNBV='2000008' where ActividadBMXID='2023018060';
Update ACTIVIDADESBMX set Descripcion='TORTILLERIA', ActividadINEGIID=3114, NumeroCNBV='2000008' where ActividadBMXID='2093011060';
Update ACTIVIDADESBMX set Descripcion='BENEFICIO DE CAFE EXCEPTO MOLIENDA Y TOSTADO', ActividadINEGIID=3115, NumeroCNBV='2000008' where ActividadBMXID='2025014060';
Update ACTIVIDADESBMX set Descripcion='MOLINO Y TOSTADOR DE CAFE', ActividadINEGIID=3115, NumeroCNBV='2000008' where ActividadBMXID='2026012060';
Update ACTIVIDADESBMX set Descripcion='EMPACADORA DE TE', ActividadINEGIID=3115, NumeroCNBV='2000008' where ActividadBMXID='2027010060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE MARQUETAS Y ESTUCHADOS DE AZUCAR', ActividadINEGIID=3116, NumeroCNBV='2000008' where ActividadBMXID='2031011060';
Update ACTIVIDADESBMX set Descripcion='INGENIO AZUCARERO', ActividadINEGIID=3116, NumeroCNBV='2000008' where ActividadBMXID='2031029060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PILONCILLO', ActividadINEGIID=3116, NumeroCNBV='2000008' where ActividadBMXID='2032019060';
Update ACTIVIDADESBMX set Descripcion='DESTILACION DE ALCOHOL ETILICO', ActividadINEGIID=3116, NumeroCNBV='2000008' where ActividadBMXID='2033017060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ACEITES VEGETALES COMESTIBLES', ActividadINEGIID=3117, NumeroCNBV='2000008' where ActividadBMXID='2091015060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE MANTECAS VEGETALES COMESTIBLES', ActividadINEGIID=3117, NumeroCNBV='2000008' where ActividadBMXID='2091023060';
Update ACTIVIDADESBMX set Descripcion='DESHIDRATACION DE PLANTAS PARA FORRAJES', ActividadINEGIID=3118, NumeroCNBV='2000008' where ActividadBMXID='2098011060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ALIMENTO PARA GANADO Y OTROS ANIMALES', ActividadINEGIID=3118, NumeroCNBV='2000008' where ActividadBMXID='2098029060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ALIMENTOS PARA AVES', ActividadINEGIID=3118, NumeroCNBV='2000008' where ActividadBMXID='2098037060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ATES', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2013019060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE QUESO Y MIEL DE TUNA', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2013027060';
Update ACTIVIDADESBMX set Descripcion='MOLINO DE ARROZ', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2024016060';
Update ACTIVIDADESBMX set Descripcion='BENEFICIO DE ARROZ EXCEPTO MOLIENDA', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2028018060';
Update ACTIVIDADESBMX set Descripcion='DESCASCARADO Y TOSTADO DE CACAHUATE Y NUEZ', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2028026060';
Update ACTIVIDADESBMX set Descripcion='DESCASCARADORA Y TOSTADORA DE SEMILLA DE CALABAZA', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2028034060';
Update ACTIVIDADESBMX set Descripcion='MOLINO PARA OTROS GRANOS EXCEPTO CEREALES', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2028042060';
Update ACTIVIDADESBMX set Descripcion='MOLINO DE AVENA', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2029016060';
Update ACTIVIDADESBMX set Descripcion='MOLINO DE CEBADA', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2029024060';
Update ACTIVIDADESBMX set Descripcion='MOLINO DE OTROS CEREALES', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2029032060';
Update ACTIVIDADESBMX set Descripcion='CONGELADORA DE PRODUCTOS MARINOS', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2061018060';
Update ACTIVIDADESBMX set Descripcion='EMPACADORA DE OTROS MARISCOS', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2061026060';
Update ACTIVIDADESBMX set Descripcion='EMPACADORA DE PESCADO', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2061034060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE CHOCOLATES', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2081016060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE DULCES BOMBONES Y CONFITES', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2082014060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE GOMA DE MASCAR', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2083012060';
Update ACTIVIDADESBMX set Descripcion='TRATAMIENTO Y ENVASE DE MIEL DE ABEJA', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2084010060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE JARABES', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2089010060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ALMIDON', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2092013060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE LEVADURAS', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2092021060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE FRITURAS', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2094019060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE OTROS PREPARADOS ALIMENTICIOS DERIVADOS DE CEREALES', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2094027060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE VINAGRE', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2095017060';
Update ACTIVIDADESBMX set Descripcion='REFINACION DE SAL', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2095025060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE HIELO', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2096015060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE HELADOS NIEVES Y PALETAS', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2097013060';
Update ACTIVIDADESBMX set Descripcion='EMPACADORA DE ESPECIAS', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2099019060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE ACEITES Y MANTECAS ANIMALES COMESTIBLES', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2099027060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE HARINA DE PESCADO', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2099035060';
Update ACTIVIDADESBMX set Descripcion='FABRICACION DE PASTAS PARA GUISOS', ActividadINEGIID=3119, NumeroCNBV='2000008' where ActividadBMXID='2099051060';



END TerminaStore$$