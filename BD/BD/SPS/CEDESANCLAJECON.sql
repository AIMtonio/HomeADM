-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESANCLAJECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESANCLAJECON`;DELIMITER $$

CREATE PROCEDURE `CEDESANCLAJECON`(
    /***SP QUE SE ENCARGA DE CONSULTAR CEDES ANCLADAS***/
    Par_CedeAncID           INT(11),                -- ID Cede Anclada
    Par_CedeOriID           INT(11),                -- ID Cede Madre
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
				anc.InteresRecibirOriginal, cedM.InteresRetener AS IntReteM,cedM.Plazo AS PlazoM,   cedM.TipoCedeID,            anc.TasaOriginal,
				anc.TasaBaseIDOriginal,     anc.SobreTasaOriginal,          anc.PisoTasaOriginal,   anc.TechoTasaOriginal,      anc.CalculoIntOriginal,
				anc.NuevoInteresGenerado,   anc.NuevoInteresRecibir,        anc.MontoConjunto,      anc.TotalRecibir,           ced.Estatus,
				ced.ClienteID,              ced.CuentaAhoID,                ced.MonedaID,           anc.CedeOriID,              anc.NuevaTasa

		FROM CEDES ced
			INNER JOIN CEDESANCLAJE anc     ON ced.CedeID       = anc.CedeAncID
			INNER JOIN CEDES        cedM    ON anc.CedeOriID    = cedM.CedeID
		WHERE ced.CedeID = Par_CedeAncID;

	END IF;

	IF(Par_TipoConsulta = ConsultaForanea)THEN

		SELECT  Ce.CedeID,              Ce.CuentaAhoID,     Ce.TipoCedeID,                      Ce.FechaInicio,         Ce.FechaVencimiento,
				Anc.MontoConjunto,      Ce.Plazo,           Anc.TasaOriginal AS TasaCedesAnc,   Ce.TasaISR,             Ce.TasaNeta,
				Ce.InteresGenerado,     Ce.InteresRecibir,  Ce.InteresRetener,                  Ce.Estatus,             Ce.ClienteID,
				Ce.MonedaID,            Ce.ValorGat,        Ce.ValorGatReal,                    Anc.CedeAncID,          Ce.Monto,
				Ce.TasaFija,            Anc.CedeOriID,      Anc.FechaAnclaje,                   (Anc.MontoConjunto - Ce.Monto) AS MontoAnclar,
				Ce.TasaBase,            Ce.SobreTasa,       Ce.PisoTasa,                        Ce.TechoTasa,           Ce.CalculoInteres,
				(SELECT Plazo FROM CEDES WHERE CedeID = Par_CedeOriID) AS PlazoInvOr
		FROM CEDES Ce
		INNER JOIN CEDESANCLAJE Anc
		WHERE   Ce.CedeID = Anc.CedeOriID
		AND Anc.CedeAncID = Par_CedeAncID;

	END IF;

	IF(Par_TipoConsulta = ConAnclajeMadre)THEN

		SELECT COUNT(CedeOriID) AS CedeID, MAX(CedeOriID) AS CedeOriID
			FROM CEDESANCLAJE
				WHERE CedeAncID = Par_CedeAncID OR CedeOriID = Par_CedeAncID;

	END IF;

	IF(Par_TipoConsulta = ConAnclajeHijo)THEN

		SELECT  CedeOriID AS CedeID, GROUP_CONCAT(CedeAncID) AS CedeOriID
		FROM CEDESANCLAJE
			WHERE CedeOriID = Par_CedeAncID
			GROUP BY CedeOriID;

	END IF;

END TerminaStore$$