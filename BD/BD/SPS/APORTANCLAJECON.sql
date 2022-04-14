-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTANCLAJECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTANCLAJECON`;DELIMITER $$

CREATE PROCEDURE `APORTANCLAJECON`(
	/***SP QUE SE ENCARGA DE CONSULTAR APORTACIONES ANCLADAS***/
	Par_AportacionAncID           INT(11),                -- ID Aportacion Anclada
	Par_AportacionOriID           INT(11),                -- ID Aportacion Madre
	Par_TipoConsulta        TINYINT UNSIGNED,   	-- Numero de Consulta

	Par_EmpresaID           INT(11),                -- Auditoria
	Par_UsuarioID           INT(11),                -- Auditoria
	Par_Fecha               DATE,              	 	-- Auditoria
	Par_DireccionIP         VARCHAR(15),        	-- Auditoria
	Par_ProgramaID          VARCHAR(50),        	-- Auditoria
	Par_Sucursal            INT(11),                -- Auditoria
	Par_NumeroTransaccion   BIGINT(20)              -- Auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE ConsultaPrincipal   INT;
	DECLARE ConsultaForanea     INT;
	DECLARE ConAnclajeMadre     INT;
	DECLARE ConAnclajeHijo      INT;

	-- ASIGNACION DE CONSTANTES
	SET ConsultaPrincipal       := 1;       -- Consulta Principal
	SET ConsultaForanea         := 2;       -- Consulta Foranea
	SET ConAnclajeMadre         := 3;       -- Consulta Anclaje Madre
	SET ConAnclajeHijo          := 4;       -- Consulta Anclaje Hijo

	IF(Par_TipoConsulta = ConsultaPrincipal)THEN

		SELECT  ced.Monto,                  ced.TasaFija,                   ced.InteresGenerado,    ced.PlazoOriginal,          ced.TasaISR,
				ced.InteresRetener,         ced.Plazo,                      ced.TasaNeta,           ced.InteresRecibir,         ced.FechaInicio,
				ced.ValorGat,               ced.ValorGatReal,               ced.FechaVencimiento,   ced.CalculoInteres,         ced.TasaBase,
				ced.SobreTasa,              ced.PisoTasa,                   ced.TechoTasa,          cedM.Monto AS MontoMadre,   anc.InteresGeneradoOriginal,
				anc.InteresRecibirOriginal, cedM.InteresRetener AS IntReteM,cedM.Plazo AS PlazoM,   cedM.TipoAportacionID,            anc.TasaOriginal,
				anc.TasaBaseIDOriginal,     anc.SobreTasaOriginal,          anc.PisoTasaOriginal,   anc.TechoTasaOriginal,      anc.CalculoIntOriginal,
				anc.NuevoInteresGenerado,   anc.NuevoInteresRecibir,        anc.MontoConjunto,      anc.TotalRecibir,           ced.Estatus,
				ced.ClienteID,              ced.CuentaAhoID,                ced.MonedaID,           anc.AportacionOriID,              anc.NuevaTasa

		FROM APORTACIONES ced
			INNER JOIN APORTANCLAJE anc     ON ced.AportacionID       = anc.AportacionAncID
			INNER JOIN APORTACIONES        cedM    ON anc.AportacionOriID    = cedM.AportacionID
		WHERE ced.AportacionID = Par_AportacionAncID;

	END IF;

	IF(Par_TipoConsulta = ConsultaForanea)THEN

		SELECT  Ce.AportacionID,              Ce.CuentaAhoID,     Ce.TipoAportacionID,                      Ce.FechaInicio,         Ce.FechaVencimiento,
				Anc.MontoConjunto,      Ce.Plazo,           Anc.TasaOriginal AS TasaAportacionsAnc,   Ce.TasaISR,             Ce.TasaNeta,
				Ce.InteresGenerado,     Ce.InteresRecibir,  Ce.InteresRetener,                  Ce.Estatus,             Ce.ClienteID,
				Ce.MonedaID,            Ce.ValorGat,        Ce.ValorGatReal,                    Anc.AportacionAncID,          Ce.Monto,
				Ce.TasaFija,            Anc.AportacionOriID,      Anc.FechaAnclaje,                   (Anc.MontoConjunto - Ce.Monto) AS MontoAnclar,
				Ce.TasaBase,            Ce.SobreTasa,       Ce.PisoTasa,                        Ce.TechoTasa,           Ce.CalculoInteres,
				(SELECT Plazo FROM APORTACIONES WHERE AportacionID = Par_AportacionOriID) AS PlazoInvOr
		FROM APORTACIONES Ce
		INNER JOIN APORTANCLAJE Anc
		WHERE   Ce.AportacionID = Anc.AportacionOriID
		AND Anc.AportacionAncID = Par_AportacionAncID;

	END IF;

	IF(Par_TipoConsulta = ConAnclajeMadre)THEN

		SELECT COUNT(AportacionOriID) AS AportacionID, MAX(AportacionOriID) AS AportacionOriID
			FROM APORTANCLAJE
				WHERE AportacionAncID = Par_AportacionAncID OR AportacionOriID = Par_AportacionAncID;

	END IF;

	IF(Par_TipoConsulta = ConAnclajeHijo)THEN

		SELECT  AportacionOriID AS AportacionID, GROUP_CONCAT(AportacionAncID) AS AportacionOriID
		FROM APORTANCLAJE
			WHERE AportacionOriID = Par_AportacionAncID
			GROUP BY AportacionOriID;

	END IF;

END TerminaStore$$