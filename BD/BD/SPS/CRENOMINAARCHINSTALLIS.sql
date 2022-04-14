-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRENOMINAARCHINSTALLIS
DELIMITER  ;
DROP PROCEDURE IF EXISTS `CRENOMINAARCHINSTALLIS`;

DELIMITER  $$
CREATE PROCEDURE `CRENOMINAARCHINSTALLIS`(
    -- STORE PARA ENLISTAR LA INFORMACION DE LOS PRIMEROS 15 RESULTADOS DE LA TABLA CRENOMINAARCHINSTAL CON LA DESCRIPCION COMO FILTRO
    Par_Descripcion                 VARCHAR(250),        -- Descripcion del archivo de instalacion
    Par_TipoLis                     INT(1),         -- Tipo de consulta

    /* Parametros de Auditoria */
    Par_EmpresaID   	            INT(11),        -- Parametro de auditoria
	Aud_Usuario			            INT(11),        -- Parametro de auditoria
	Aud_FechaActual		            DATETIME,       -- Parametro de auditoria
	Aud_DireccionIP		            VARCHAR(15),    -- Parametro de auditoria
	Aud_ProgramaID		            VARCHAR(50),    -- Parametro de auditoria
	Aud_Sucursal		            INT(11),        -- Parametro de auditoria
	Aud_NumTransaccion	            BIGINT(20)      -- Parametro de auditoria
)
TerminaStore: BEGIN

    /* Declatacion de Constantes */
    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Entero_Cero             INT(1);
    DECLARE Lis_Principal           INT(1);

    /* Asignacion de Constantes */
    SET Cadena_Vacia        :=  '';
    SET Entero_Cero         :=  0;
    SET Lis_Principal       :=  1;



    /* Lista Principal */
    IF(Par_TipoLis = Lis_Principal) THEN

        SELECT FolioID, Descripcion, InstitucionID, ConvenioID
          FROM CRENOMINAARCHINSTAL
         WHERE Descripcion LIKE CONCAT("%",Par_Descripcion,"%")
         LIMIT 15;

    END IF;

END TerminaStore$$
