-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPROVEEDORESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOPROVEEDORESCON`;DELIMITER $$

CREATE PROCEDURE `TIPOPROVEEDORESCON`(

    Par_TipoProveID     INT,
    Par_NumCon          TINYINT UNSIGNED,
    Par_EmpresaID       INT,

    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
)
TerminaStore: BEGIN


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Con_Principal   INT;
DECLARE Con_Foranea     INT;


SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Con_Principal   := 1;
SET Con_Foranea     := 2;

IF(Par_NumCon = Con_Principal) THEN
    SELECT  `TipoProveedorID`,      `Descripcion`, `TipoPersona`
    FROM TIPOPROVEEDORES
    WHERE  TipoProveedorID = Par_TipoProveID;
END IF;

IF(Par_NumCon = Con_Foranea) THEN
    SELECT  `TipoProveedorID`,      `Descripcion`
    FROM TIPOPROVEEDORES
    WHERE  TipoProveedorID = Par_TipoProveID;
END IF;

END TerminaStore$$