-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCLAPORRESULLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCLAPORRESULLIS`;DELIMITER $$

CREATE PROCEDURE `PLDCLAPORRESULLIS`(

    Par_ResultEscID    	VARCHAR(1),
    Par_NumLis          TINYINT UNSIGNED,

    Par_EmpresaID       INT(11),

    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
		)
TerminaStore: BEGIN


DECLARE Cadena_Vacia	CHAR(1);
DECLARE Fecha_Vacia		DATE;
DECLARE Entero_Cero		INT;
DECLARE Lis_Principal	INT;


SET Cadena_Vacia	:= '';
SET Fecha_Vacia		:= '1900-01-01';
SET Entero_Cero		:= 0;
SET Lis_Principal	:= 1;

IF(Par_NumLis = Lis_Principal) THEN
	SELECT Res.TipoResultEscID, Cla.ClaveJustEscIntID, UPPER(Cla.Descripcion) AS Descripcion
        FROM PLDCLAPORRESUL Res,
             PLDCLAJUSESCINTER Cla
        WHERE Res.TipoResultEscID = Par_ResultEscID
          AND Res.ClaveJustEscIntID = Cla.ClaveJustEscIntID;

END IF;

END TerminaStore$$