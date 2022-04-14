-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCAJEROSATMCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATCAJEROSATMCON`;DELIMITER $$

CREATE PROCEDURE `CATCAJEROSATMCON`(
	Par_CajeroID			VARCHAR(20),
	Par_NumCon				TINYINT UNSIGNED,

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT

	)
TerminaStore:BEGIN
-- Declaracion de Variables

-- Declaracion de Constantes
DECLARE Con_Principal	INT;
-- Asignacion de Constantes
SET Con_Principal		:=1;		-- Consulta principal del cAtalogo de Cajeros


IF (Par_NumCon = Con_Principal)THEN
	SELECT
		CajeroID,			SucursalID,	NumCajeroPROSA,	Ubicacion,		UsuarioID,
		SaldoMN,			SaldoME,	CtaContableMN,	CtaContableME,	CtaContaMNTrans,
		CtaContaMETrans,	Estatus, 	EstadoID, 		MunicipioID, 	LocalidadID,
		ColoniaID,			Calle,		Numero, 		NumInterior,	NomenclaturaCR,
        Latitud,			Longitud,	CP, 			TipoCajeroID
	FROM CATCAJEROSATM
	WHERE CajeroID = Par_CajeroID;
END IF;

END TerminaStore$$