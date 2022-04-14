-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOD0842003CON
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOD0842003CON`;DELIMITER $$

CREATE PROCEDURE `REGULATORIOD0842003CON`(
	# ========== SP PARA CONSULTA DE REGULATORIO D0842 =============================================
    Par_IdentificadorID	  	INT(11),			  	-- Consecutivo que identifica el registro
	Par_Anio                INT(11),            	-- Anio en que se reporta
	Par_Mes                 INT(11),            	-- mes de generacion del reporte
    Par_NumCon          	TINYINT UNSIGNED,   	-- Numero de consulta
	Par_EmpresaID			INT(11),				-- Auditoria

	Aud_Usuario				INT(11),				-- Auditoria
	Aud_FechaActual			DATETIME,				-- Auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Auditoria
	Aud_Sucursal			INT(11),				-- Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Auditoria
		)
TerminaStore: BEGIN

	-- Declaracion de Variables

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT;
	DECLARE	Con_Principal			INT;
	DECLARE	Con_Foranea				INT;

 -- Asignacion de constantes
    SET Cadena_Vacia                := '';              -- Cadena vacia
    SET Fecha_Vacia                 := '1900-01-01';    -- Fecha vacia
    SET Entero_Cero                 := 0;               -- Entero cero
    SET Con_Principal               := 1;               -- Consulta principal
    SET Con_Foranea                 := 2;               -- Consulta foranea

	IF(Par_NumCon = Con_Principal) THEN
	   SELECT	Consecutivo, 		Anio, 				Mes, 				PeriodoPago, 		ClaveEntidad,
				Formulario, 		NumeroIden, 		TipoPrestamista, 	PaisEntidadExt, 	NumeroCuenta,
                NumeroContrato, 	ClasificaConta, 	FechaContra, 		FechaVencim, 		PlazoVencimiento,
                MontoInicial, 		MontoInicialMNX, 	TipoTasa, 			ValorTasa, 			ValorTasaInt,
                TasaIntReferencia, 	DifTasaReferencia, 	OperaDifTasaRefe, 	FrecRevTasa, 		TipoMoneda,
                PorcentajeComision, ImporteComision, 	PeriodoComision, 	TipoDispCredito, 	DestinoCredito,
                ClasificaCortLarg, 	SaldoIniPeriodo, 	PagosPeriodo, 		ComPagadasPeriodo, 	InteresPagado,
                InteresDevengados, 	SaldoCierre, 		PorcentajeLinRev, 	FechaUltPago, 		PagoAnticipado,
                MontoUltimoPago, 	FechaPagoSig, 		MontoPagImediato, 	TipoGarantia, 		MontoGarantia,
                FechaValuaGaran
			FROM REGULATORIOD0842003
			WHERE Consecutivo = Par_IdentificadorID
				AND Anio = Par_Anio
                AND	Mes  = Par_Mes;
	END IF;


END TerminaStore$$