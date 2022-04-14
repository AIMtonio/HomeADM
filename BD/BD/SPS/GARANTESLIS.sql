-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GARANTESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `GARANTESLIS`;DELIMITER $$

CREATE PROCEDURE `GARANTESLIS`(
# =====================================================================================
# ----- SP QUE LISTA LOS GARANTES REGISTRADOS -----------------
# =====================================================================================
    Par_NombreCompleto          VARCHAR(50),            # Nombre del Garante
    Par_NumLis                  TINYINT UNSIGNED,       # Numero de Lista

    -- Parametros de Auditoria
    Par_EmpresaID               INT(11),
    Aud_Usuario                 INT(11),
    Aud_FechaActual             DATETIME,
    Aud_DireccionIP             VARCHAR(15),
    Aud_ProgramaID              VARCHAR(50),
    Aud_Sucursal                INT(11),
    Aud_NumTransaccion          BIGINT(20)
    )
TerminaStore: BEGIN


-- Declaracion de Constantes

DECLARE Entero_Cero     INT(11);
DECLARE Fecha_Vacia     DATE;
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Lis_Principal   INT(11);
DECLARE Lis_PersonaFisica   INT(11);
DECLARE Lis_PersonaMoral    INT(11);
DECLARE PersonaMoral    CHAR(1);


-- Asignacion de Constantes
SET Entero_Cero         :=  0;              -- Constante: Entero Cero
SET Fecha_Vacia         := '1900-01-01';    -- Constante: Fecha Vacia
SET Cadena_Vacia        := '';              -- Constante: Cadena Vacia
SET Lis_Principal       := 1;               -- Lista Principal
SET Lis_PersonaFisica   := 2;               -- Lista los Garantes que son Persona Fisica y Fisica con Actividad Empresarial
SET Lis_PersonaMoral    := 6;
SET PersonaMoral        := 'M';             -- Persona Moral

IF(Par_NumLis = Lis_Principal) THEN
    SELECT Gte.GaranteID, Gte.NombreCompleto
        FROM GARANTES Gte
        WHERE  Gte.NombreCompleto LIKE CONCAT("%", Par_NombreCompleto, "%")
        LIMIT 0,15;
END IF;

-- Lista los Garantes que son Persona Fisica o Fisica con Actividad Empresarial
IF(Par_NumLis = Lis_PersonaFisica) THEN
    SELECT Gte.GaranteID, Gte.NombreCompleto
        FROM GARANTES Gte
        WHERE  Gte.NombreCompleto LIKE CONCAT("%", Par_NombreCompleto, "%")
        AND TipoPersona <> PersonaMoral
        LIMIT 0,15;
END IF;


      IF(Par_NumLis = Lis_PersonaMoral)THEN
        SELECT GaranteID, NombreCompleto
            FROM GARANTES
            WHERE NombreCompleto LIKE   CONCAT("%", Par_NombreCompleto, "%")
            AND TipoPersona = PersonaMoral
            LIMIT 0, 15;
    END IF;

END TerminaStore$$