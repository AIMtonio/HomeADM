-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVERSASOPERCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `REVERSASOPERCON`;DELIMITER $$

CREATE PROCEDURE `REVERSASOPERCON`(
	Par_TransaccionID 	INT(11),
	Par_NumCon			TINYINT UNSIGNED,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore:BEGIN


DECLARE Con_Principal		INT;
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Entero_Cero         INT(11);


DECLARE	Var_Transaccion		INT(11);


SET Con_Principal  		:= 1;
SET Cadena_Vacia        := '';
SET Entero_Cero         := 0;

IF(Par_NumCon = Con_Principal) THEN
	SELECT TransaccionID,	Motivo,	DescripcionOper,	TipoOperacion,	Referencia,
			Monto,			CajaID,	SucursalID,			Fecha,			UsuarioID,
			ClaveUsuarioAut,ContraseniaAut
	FROM REVERSASOPER
		WHERE TransaccionID = Par_TransaccionID;
END IF;

END TerminaStore$$