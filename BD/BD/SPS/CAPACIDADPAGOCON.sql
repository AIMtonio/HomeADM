-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAPACIDADPAGOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAPACIDADPAGOCON`;DELIMITER $$

CREATE PROCEDURE `CAPACIDADPAGOCON`(




	Par_ClienteID			INT(11),
	Par_NumCon				TINYINT UNSIGNED,


	Par_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN




	DECLARE Con_Principal		INT;


	SET Con_Principal			:=1;





		IF(Par_NumCon = Con_Principal) THEN
			SELECT  CapacidadPagoID,		ClienteID,			UsuarioID,			SucursalID,			ProducCredito1,
					ProducCredito2,			ProducCredito3,		TasaInteres1,		TasaInteres2,		TasaInteres3,
					IngresoMensual,			GastoMensual,		MontoSolicitado,	AbonoPropuesto,		Plazo,
					AbonoEstimado,			IngresosGastos,
					FORMAT(Cobertura,2) AS Cobertura,	CobSinPrestamo,		CobConPrestamo,
					Fecha
			FROM	CAPACIDADPAGO
			WHERE	ClienteID = Par_ClienteID;
		END IF;

	END TerminaStore$$