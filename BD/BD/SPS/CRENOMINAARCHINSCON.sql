-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRENOMINAARCHINSCON
DELIMITER  ;
DROP PROCEDURE IF EXISTS `CRENOMINAARCHINSCON`;

DELIMITER  $$
CREATE PROCEDURE `CRENOMINAARCHINSCON`(
    -- STORE PARA CONSULTAR LA INFORMACION DE LA TABLA CRENOMINAARCHINSTAL CON UN DETERMINADO FOLIO.
    Par_InstitNominaID              INT(11),        -- Identificador de la institucion de nomina
    Par_ConvenioNominaID            INT(11),        -- Identificador del convenio de nomina
    Par_TipoCon                     INT(1),         -- Tipo de consulta

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
    DECLARE Con_Principal           INT(1);
    DECLARE Con_Secundaria          INT(1);

    /* Asignacion de Constantes */
    SET Cadena_Vacia        :=  '';
    SET Entero_Cero         :=  0;
    SET Con_Principal       :=  2;
    SET Con_Secundaria      :=  3;



    /* Consulta Principal */
    IF(Par_TipoCon = Con_Principal) THEN

        SELECT FolioID, Descripcion, InstitucionID, ConvenioID, Estatus
          FROM CRENOMINAARCHINSTAL
         WHERE InstitucionID    = Par_InstitNominaID
           AND ConvenioID       = Par_ConvenioNominaID
           AND Estatus          = 'E'
        ORDER BY FolioID DESC Limit 1;

    END IF;

END TerminaStore$$
