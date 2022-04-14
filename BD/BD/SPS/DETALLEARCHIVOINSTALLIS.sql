-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEARCHIVOINSTALLIS
DELIMITER  ;
DROP PROCEDURE IF EXISTS `DETALLEARCHIVOINSTALLIS`;

DELIMITER  $$
CREATE PROCEDURE `DETALLEARCHIVOINSTALLIS`(
    -- STORE PARA CONSULTAR LA INFORMACION DE LA TABLA DETALLEARCHIVOINSTAL CON UN DETERMINADO FOLIO.
    Par_FolioID                     INT(11),        -- Idendificador del registro a consultar
    Par_TipoLis                     INT(1),         -- Tipo de consulta

    -- Parametros de Auditoria
    Par_EmpresaID   	            INT(11),        -- Parametro de auditoria
	Aud_Usuario			            INT(11),        -- Parametro de auditoria
	Aud_FechaActual		            DATETIME,       -- Parametro de auditoria
	Aud_DireccionIP		            VARCHAR(15),    -- Parametro de auditoria
	Aud_ProgramaID		            VARCHAR(50),    -- Parametro de auditoria
	Aud_Sucursal		            INT(11),        -- Parametro de auditoria
	Aud_NumTransaccion	            BIGINT(20)      -- Parametro de auditoria
)
TerminaStore: BEGIN

    -- Declatacion de Constantes
    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Entero_Cero             INT(1);
    DECLARE Lis_Principal           INT(1);

    -- Asignacion de Constantes
    SET Cadena_Vacia        :=  '';
    SET Entero_Cero         :=  0;
    SET Lis_Principal       :=  1;

    -- Consulta Principal
    IF(Par_TipoLis = Lis_Principal) THEN

        SELECT DetalleArchivoID,           FolioID,            CreditoID,          Estatus,     FechaLimiteRecep
          FROM DETALLEARCHIVOINSTAL
         WHERE FolioID = Par_FolioID;

    END IF;

END TerminaStore$$