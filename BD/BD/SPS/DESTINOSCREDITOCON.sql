-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESTINOSCREDITOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DESTINOSCREDITOCON`;
DELIMITER $$


CREATE PROCEDURE `DESTINOSCREDITOCON`(
/* CONSULTA LOS DESTINOS DE CREDITO */
  Par_ProducCreditoID INT(11),
  Par_DestinoCreID  INT(11),
  Par_NumCon      TINYINT UNSIGNED,
  /* Parámetros de Auditoría */
  Par_EmpresaID   INT(11),
  Aud_Usuario     INT(11),
  Aud_FechaActual   DATETIME,

  Aud_DireccionIP   VARCHAR(15),
  Aud_ProgramaID    VARCHAR(50),
  Aud_Sucursal    INT(11),
  Aud_NumTransaccion  BIGINT(20)
)

TerminaStore: BEGIN

-- DECLARACIÓN DE CONSTANTES
DECLARE Cadena_Vacia  CHAR(1);
DECLARE Fecha_Vacia   DATE;
DECLARE Entero_Cero   INT;
DECLARE Con_Principal INT;
DECLARE Con_Actualiza INT;
DECLARE Con_Foranea   INT;
DECLARE Con_PorProducCre INT;

DECLARE TipoClasifCom       CHAR(1);
DECLARE TipoClasifCon       CHAR(1);
DECLARE TipoClasifHip       CHAR(1);
DECLARE NomDispCom          VARCHAR(20);
DECLARE NomDispCon          VARCHAR(20);
DECLARE NomDispHip          VARCHAR(20);

-- ASIGNACIÓN DE CONSTANTES
SET Cadena_Vacia  := '';
SET Fecha_Vacia   := '1900-01-01';
SET Entero_Cero   := 0;
SET Con_Principal := 1;
SET Con_Foranea   := 2;
SET Con_PorProducCre := 3;  # Consulta Destino Por Producto de Crédito

SET TipoClasifCom       := 'C';       
SET TipoClasifCon       := 'O';
SET TipoClasifHip       := 'H';
SET NomDispCom          := 'Comercial';
SET NomDispCon          := 'Consumo';
SET NomDispHip          := 'Hipotecario';

IF(Par_NumCon = Con_Principal) THEN
  SELECT
    DestinoCreID,	Descripcion,  DestinCredFRID, 	DestinCredFOMURID,  Clasificacion,
    SubClasifID,	Cadena_Vacia AS DescripcionFR,	Cadena_Vacia AS DescripcionFOMUR
    FROM DESTINOSCREDITO
    WHERE DestinoCreID= Par_DestinoCreID;
END IF;

IF(Par_NumCon = Con_Foranea) THEN
 SELECT DES.DestinoCreID,	DES.Descripcion,DES.DestinCredFRID, DES.DestinCredFOMURID,
			DES.Clasificacion, DFR.Descripcion AS DescripcionFR, DFOM.Descripcion AS DescripcionFOMUR,
			CASE DES.Clasificacion
			    WHEN TipoClasifCom THEN NomDispCom
			    WHEN TipoClasifCon THEN NomDispCon
			    WHEN TipoClasifHip THEN NomDispHip
			END AS DesClasificacion
		FROM DESTINOSCREDITO  DES
		LEFT  JOIN DESTINCREDFR DFR ON  DES.DestinCredFRID=  DFR.DestinCredFRID
		LEFT  JOIN DESTINCREDFOMUR DFOM ON DES.DestinCredFOMURID=DFOM.DestinCredFOMURID
		WHERE DestinoCreID= Par_DestinoCreID;
END IF;

IF(Par_NumCon = Con_PorProducCre) THEN
  SELECT
    DES.DestinoCreID,	DES.Descripcion,  DES.DestinCredFRID,	DES.DestinCredFOMURID,  DES.Clasificacion,
    DES.SubClasifID,	DFR.Descripcion AS DescripcionFR,		DFOM.Descripcion AS DescripcionFOMUR
    FROM DESTINOSCREDITO DES
	LEFT  JOIN DESTINCREDFR DFR ON  DES.DestinCredFRID=  DFR.DestinCredFRID
    LEFT  JOIN DESTINCREDFOMUR DFOM ON DES.DestinCredFOMURID=DFOM.DestinCredFOMURID
    INNER JOIN DESTINOSCREDPROD DPC ON DES.DestinoCreID = DPC.DestinoCreID
		AND DES.DestinoCreID = Par_DestinoCreID
		AND DPC.ProductoCreditoID = Par_ProducCreditoID;
END IF;

END TerminaStore$$
