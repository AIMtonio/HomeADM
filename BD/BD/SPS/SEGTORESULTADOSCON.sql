-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTORESULTADOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTORESULTADOSCON`;DELIMITER $$

CREATE PROCEDURE `SEGTORESULTADOSCON`(
    Par_ResultadoID     INT(11),
    Par_NumCon          TINYINT UNSIGNED,

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN


    DECLARE     Cadena_Vacia    CHAR(1);
    DECLARE     Fecha_Vacia     DATE;
    DECLARE     Entero_Cero     INT(11);
    DECLARE     Con_Alcance     INT(11);
    DECLARE     EstatusVigente  CHAR(1);
    DECLARE     Con_Principal   INT(11);


    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Con_Alcance     := 3;
    SET EstatusVigente  :='V';
    SET Con_Principal   :=1;

    IF(Par_NumCon = Con_Principal) THEN
        SELECT ResultadoSegtoID, Descripcion, Alcance, ReqSupervisor, Estatus
        FROM SEGTORESULTADOS
        WHERE ResultadoSegtoID = Par_ResultadoID;
    END IF;


    IF(Par_NumCon = Con_Alcance) THEN
        SELECT ResultadoSegtoID, Alcance, ReqSupervisor
        FROM SEGTORESULTADOS
        WHERE ResultadoSegtoID = Par_ResultadoID
            AND Estatus = EstatusVigente;
    END IF;

END TerminaStore$$