-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSNOMINACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSNOMINACON`;
DELIMITER $$


CREATE PROCEDURE `PARAMETROSNOMINACON`(
	Par_EmpresaID   	int(11),
    Par_tipoCon    		int(11),

    Aud_Usuario			int(11),
	Aud_FechaActual		datetime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint(20)
	)

TerminaStore: BEGIN

DECLARE ConPrincipal    int;



SET ConPrincipal    := 1;

IF(Par_tipoCon = ConPrincipal) THEN

    SELECT  EmpresaID, 				CorreoElectronico, 				CtaPagoTransito,				NomenclaturaCR, 			TipoMovTesCon,
    		PerfilAutCalend,		CtaTransDomicilia,				TipoMovDomiciliaID
        FROM PARAMETROSNOMINA
            WHERE   EmpresaID = Par_EmpresaID;

END IF;

END TerminaStore$$