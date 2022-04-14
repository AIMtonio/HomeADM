-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFGARANTIASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLASIFGARANTIASCON`;DELIMITER $$

CREATE PROCEDURE `CLASIFGARANTIASCON`(

    Par_TipoGarantiaID		INT(11),
    Par_TipoCon      	 	INT(11),

    Aud_EmpresaID	    	INT(11),
    Aud_Usuario	        	INT(11),
    Aud_FechaActual			DATETIME,
    Aud_DireccionIP			VARCHAR(15),
    Aud_ProgramaID	    	VARCHAR(70),
    Aud_Sucursal	    	INT(11),
    Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN


	DECLARE Combo INT(11);


	SET Combo:=1;

    IF(Par_TipoCon = Combo) THEN

        SELECT ClasifGarantiaID,Descripcion
        FROM CLASIFGARANTIAS
        WHERE TipoGarantiaID = Par_TipoGarantiaID;

    END IF;

END TerminaStore$$