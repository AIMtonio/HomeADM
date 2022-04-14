-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPUPDATEESTADOS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPUPDATEESTADOS`;DELIMITER $$

CREATE PROCEDURE `TMPUPDATEESTADOS`(	)
TerminaStore: BEGIN
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='AGS' WHERE `EstadoID`='1';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='BCN' WHERE `EstadoID`='2';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='BCS' WHERE `EstadoID`='3';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='CAM' WHERE `EstadoID`='4';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='COA' WHERE `EstadoID`='5';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='COL' WHERE `EstadoID`='6';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='CHS' WHERE `EstadoID`='7';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='CHI' WHERE `EstadoID`='8';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='DF' WHERE `EstadoID`='9';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='DGO' WHERE `EstadoID`='10';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='GTO' WHERE `EstadoID`='11';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='GRO' WHERE `EstadoID`='12';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='HGO' WHERE `EstadoID`='13';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='JAL' WHERE `EstadoID`='14';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='EM' WHERE `EstadoID`='15';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='MICH' WHERE `EstadoID`='16';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='MOR' WHERE `EstadoID`='17';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='NAY' WHERE `EstadoID`='18';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='NL' WHERE `EstadoID`='19';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='OAX' WHERE `EstadoID`='20';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='PUE' WHERE `EstadoID`='21';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='QRO' WHERE `EstadoID`='22';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='QR' WHERE `EstadoID`='23';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='SLP' WHERE `EstadoID`='24';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='SIN' WHERE `EstadoID`='25';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='SON' WHERE `EstadoID`='26';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='TAB' WHERE `EstadoID`='27';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='TAM' WHERE `EstadoID`='28';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='TLA' WHERE `EstadoID`='29';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='VER' WHERE `EstadoID`='30';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='YUC' WHERE `EstadoID`='31';
UPDATE `microfin`.`ESTADOSREPUB` SET `EqBuroCred`='ZAC' WHERE `EstadoID`='32';

END TerminaStore$$