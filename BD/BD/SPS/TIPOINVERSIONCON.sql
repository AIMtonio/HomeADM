-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOINVERSIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOINVERSIONCON`;
DELIMITER $$


CREATE PROCEDURE `TIPOINVERSIONCON`(
  Par_TipoInversionID INT,  -- Id del tipo de inversion
  Par_MonedaID    INT,  -- Tipo de Moneda
  Par_TipoConsulta  INT,  -- Numero de la Consulta
  Par_EmpresaID   INT,

  Aud_Usuario     INT,
  Aud_FechaActual   DATETIME,
  Aud_DireccionIP   VARCHAR(15),
  Aud_ProgramaID    VARCHAR(50),
  Aud_Sucursal    INT,
  Aud_NumTransaccion  BIGINT

  )

TerminaStore: BEGIN

DECLARE   Cadena_Vacia  CHAR(1);
DECLARE   Con_Principal   INT;
DECLARE   Con_Secundaria  INT;
DECLARE   Con_General INT;

SET Cadena_Vacia  := '';
SET Con_Principal   := 1;
SET Con_Secundaria  := 2;
SET Con_General   := 3;


IF(Par_TipoConsulta = Con_Principal) THEN

  SELECT cat.TipoInversionID, cat.Descripcion, cat.Reinvertir, mon.Descripcion, cat.Reinversion,
		 cat.Estatus
    FROM CATINVERSION cat,
         MONEDAS mon
    WHERE cat.TipoInversionID = Par_TipoInversionID
      AND mon.MonedaID  = Par_MonedaID
      AND mon.MonedaID  = cat.MonedaID;
END IF;


IF(Par_TipoConsulta = Con_Secundaria) THEN

  SELECT TipoInversionID, inv.Descripcion, Reinversion, mon.Descripcion AS DescripcionMoneda,
      inv.MonedaID AS MonedaID, inv.Estatus
  FROM CATINVERSION inv,
       MONEDAS mon
  WHERE TipoInversionID = Par_TipoInversionID
    AND mon.MonedaID = inv.MonedaID;
END IF;

IF(Par_TipoConsulta = Con_General) THEN

  SELECT  TipoInversionID, Descripcion, Reinversion, Reinvertir, MonedaId,ClaveCNBV, ClaveCNBVAmpCred,
    NumRegistroRECA,FechaInscripcion,NombreComercial, PagoPeriodico,Estatus
  FROM CATINVERSION
  WHERE TipoInversionID = Par_TipoInversionID;

END IF;

END TerminaStore$$