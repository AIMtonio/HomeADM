-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RECLASIFICAESTIMACIONES
DELIMITER ;
DROP PROCEDURE IF EXISTS `RECLASIFICAESTIMACIONES`;
DELIMITER $$


CREATE PROCEDURE `RECLASIFICAESTIMACIONES`(
		Par_Fecha	DATE

	)

TerminaStore: BEGIN




DROP TABLE IF EXISTS tmp_CONSUMO_VIVIENDA;

CREATE TABLE tmp_CONSUMO_VIVIENDA
SELECT Des.Clasificacion, Cli.ClienteID, Cli.NombreCompleto, Sal.CreditoID,
	   Sal.DiasAtraso, Sal.EstatusCredito, Sal.PorcReserva AS PorcReservaOriginal,
		IFNULL( CASE WHEN IFNULL(Res.Origen, '') = '' OR
												IFNULL(Res.Origen, '') = 'O' THEN "Tipo 1. Ordinaria"

					 WHEN IFNULL(Res.Origen, '') = 'R' THEN "Tipo 2. Reestructurada"
				  END, 0) AS TipoCartera,
		IFNULL( CASE WHEN IFNULL(Res.Origen, '') = '' OR
												IFNULL(Res.Origen, '') = 'O' THEN por.porResCarSReest

					 WHEN IFNULL(Res.Origen, '') = 'R' THEN por.PorResCarReest
				  END, 0) AS PorcReservaNueva

	FROM CLIENTES Cli,
		DESTINOSCREDITO Des,
		SALDOSCREDITOS Sal
	INNER JOIN CREGARPRENHIPO Gah ON Gah.CreditoID = Sal.CreditoID
	LEFT OUTER JOIN REESTRUCCREDITO Res ON Res.CreditoDestinoID = Sal.CreditoID

    INNER JOIN PORCRESPERIODO por
        ON CASE WHEN IFNULL(Sal.DiasAtraso, 0) < 0 THEN 0
                ELSE Sal.DiasAtraso
                END
        BETWEEN por.LimInferior AND por.LimSuperior
            AND por.Clasificacion = 'H'

	WHERE FechaCorte = Par_Fecha
	 AND Sal.ClienteID = Cli.ClienteID
	 AND Des.DestinoCreID = Sal.DestinoCreID
	AND Des.Clasificacion IN ('O', 'C')
	AND IFNULL(Gah.CreditoID, 0) != 0
	AND IFNULL(Gah.GarHipotecaria, 0) > 0;

ALTER TABLE tmp_CONSUMO_VIVIENDA
	ADD COLUMN RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY FIRST;



UPDATE SALDOSCREDITOS Sal, tmp_CONSUMO_VIVIENDA Tmp SET
	Sal.PorcReserva = Tmp.PorcReservaNueva
	WHERE Sal.FechaCorte = Par_Fecha
	 AND Sal.CreditoID = Tmp.CreditoID;



DROP TABLE IF EXISTS tmp_VIVIENDA_CONSUMO;

CREATE TABLE tmp_VIVIENDA_CONSUMO
SELECT Cli.ClienteID, Cli.NombreCompleto, Sal.CreditoID,
	   Sal.DiasAtraso, Sal.EstatusCredito, Sal.PorcReserva AS PorcReservaOriginal,
		IFNULL( CASE WHEN IFNULL(Res.Origen, '') = '' OR
												IFNULL(Res.Origen, '') = 'O' THEN "Tipo 1. Ordinaria"

					 WHEN IFNULL(Res.Origen, '') = 'R' THEN "Tipo 2. Reestructurada"
				  END, 0) AS TipoCartera,
		IFNULL( CASE WHEN IFNULL(Res.Origen, '') = '' OR
												IFNULL(Res.Origen, '') = 'O' THEN por.porResCarSReest

					 WHEN IFNULL(Res.Origen, '') = 'R' THEN por.PorResCarReest
				  END, 0) AS PorcReservaNueva

	FROM CLIENTES Cli,
		DESTINOSCREDITO Des,
		SALDOSCREDITOS Sal
	LEFT OUTER JOIN CREGARPRENHIPO Gah ON Gah.CreditoID = Sal.CreditoID
	LEFT OUTER JOIN REESTRUCCREDITO Res ON Res.CreditoDestinoID = Sal.CreditoID

    INNER JOIN PORCRESPERIODO por
        ON CASE WHEN IFNULL(Sal.DiasAtraso, 0) < 0 THEN 0
                ELSE Sal.DiasAtraso
                END
        BETWEEN por.LimInferior AND por.LimSuperior
            AND por.Clasificacion = 'O'

	WHERE FechaCorte = Par_Fecha
	 AND Sal.ClienteID = Cli.ClienteID
	 AND Des.DestinoCreID = Sal.DestinoCreID
	AND Des.Clasificacion = 'H'
	AND IFNULL(Gah.CreditoID, 0) = 0;

	ALTER TABLE tmp_VIVIENDA_CONSUMO
		ADD COLUMN RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY FIRST;

UPDATE SALDOSCREDITOS Sal, tmp_VIVIENDA_CONSUMO Tmp SET
	Sal.PorcReserva = Tmp.PorcReservaNueva
	WHERE Sal.FechaCorte = Par_Fecha
	 AND Sal.CreditoID = Tmp.CreditoID;

-- SELECT 'Proceso Ejecutado Correctamente' AS Mensaje;

DROP TABLE tmp_VIVIENDA_CONSUMO;
DROP TABLE tmp_CONSUMO_VIVIENDA;

END TerminaStore$$
