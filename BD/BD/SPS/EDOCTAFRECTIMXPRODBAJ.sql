-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAFRECTIMXPRODBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAFRECTIMXPRODBAJ`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAFRECTIMXPRODBAJ`(

    Par_FrecuenciaID	CHAR(1),		-- FRECUENCIA
    Par_Salida          CHAR(1),		-- SALIDA
    INOUT Par_NumErr    INT(11),		-- NUMERO DE ERROR
    INOUT Par_ErrMen    VARCHAR(400),	-- MENSAJE DE ERROR
   
    -- PARAMETROS DE AUDITORIA
    Aud_EmpresaID       int(11),   
    Aud_Usuario         int(11),
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint(20)
        )
TerminaStore: BEGIN


	DECLARE SalidaNO    CHAR(1);
	DECLARE SalidaSI    CHAR(1);


	SET SalidaNO        :='N';
	SET SalidaSI        := 'S';


	DELETE FROM EDOCTAFRECTIMXPROD WHERE FrecuenciaID = Par_FrecuenciaID;

	IF(Par_Salida =SalidaSI) THEN
		SELECT '000' as NumErr,
		'Frecuencias de Timbrado por Producto Eliminadas.' as ErrMen,
		'frecuenciaID' as control;
		 LEAVE TerminaStore;
	END IF;
       

END TerminaStore$$