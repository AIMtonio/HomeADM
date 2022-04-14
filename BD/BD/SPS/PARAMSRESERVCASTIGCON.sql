-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMSRESERVCASTIGCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMSRESERVCASTIGCON`;DELIMITER $$

CREATE PROCEDURE `PARAMSRESERVCASTIGCON`(
    Par_EmpresaID       int,
    Par_TipoCon         int,

    Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			   int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN

DECLARE ConPrincipal    int;


SET ConPrincipal        := 1;

IF(Par_TipoCon = ConPrincipal) THEN

    SELECT EmpresaID, 			RegContaEPRC, 		EPRCIntMorato,	 DivideEPRCCapitaInteres, 	CondonaIntereCarVen,
           CondonaMoratoCarVen, CondonaAccesorios, 	DivideCastigo, 	 EPRCAdicional,				IVARecuperacion
    FROM PARAMSRESERVCASTIG
    WHERE EmpresaID=Par_EmpresaID;

END IF;

END TerminaStore$$