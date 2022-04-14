-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIRECEPCIONESPENBITLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIRECEPCIONESPENBITLIS`;
DELIMITER $$

CREATE PROCEDURE `SPEIRECEPCIONESPENBITLIS`(
	-- STORED PROCEDURE QUE SE ENCARGA DE PASAR AL HISTORICO LA INFORMACION DE UNA RECEPCION PENDIETE DE SPEI
	Par_FechaIni				DATE, 				-- Filtro para fecha de proceso
	Par_FechaFin 				DATE,				-- Filtro para fecha de proceso
	Par_NumLis					TINYINT,			-- Numero de actualizacion

	-- Parametros de Auditoria
	Aud_EmpresaID				INT(11),			-- Parametro de Auditoria
	Aud_Usuario					INT(11),			-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(20),		-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);				-- Cadena VAcia
	DECLARE	Fecha_Vacia				DATE;					-- Fecha Vacia
	DECLARE	Entero_Cero				INT(11);				-- Entero Cero
	DECLARE Lis_FechaProc			TINYINT;				-- Lista por PID de Tarea
	
	-- Asignacion de constantes
	SET	Cadena_Vacia				:= '';					-- Cadena VAcia
	SET	Fecha_Vacia					:= '1900-01-01';		-- Fecha Vacia
	SET	Entero_Cero					:= 0;					-- Entero Cero
	SET Lis_FechaProc				:= 1;					-- Lista por PID de Tarea

	-- Opcion 1 .- Lista de Recepciones no aplicados por fecha de proceso.
	IF(Par_NumLis = Lis_FechaProc) THEN
		SELECT 	SpeiRecepcionPenID,								TipoPagoID,				TipoCuentaOrd,			FNDECRYPTSAFI(CuentaOrd) AS CuentaOrd,						FNDECRYPTSAFI(NombreOrd) AS NombreOrd,
				IVAComision,									TipoOperacion,			InstiRemitenteID,		Estatus,													FNDECRYPTSAFI(RFCOrd) RFCOrd,
				FNDECRYPTSAFI(RFCBeneficiario) RFCBeneficiario,	InstiReceptoraID,		TipoCuentaBen,			FNDECRYPTSAFI(CuentaBeneficiario) as CuentaBeneficiario,	FNDECRYPTSAFI(NombreBeneficiario) as NombreBeneficiario,
				FNDECRYPTSAFI(ConceptoPago) ConceptoPago,		ClaveRastreo,			CodigoError,			MensajeError,												CAST(FechaProceso AS DATE) as FechaProceso,
				CAST(FechaCaptura AS DATE) as FechaCaptura,		CONCAT("$",FORMAT(CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2)),2)) as MontoTransferir
			FROM SPEIRECEPCIONESPENBIT
			WHERE CAST(FechaProceso AS DATE) BETWEEN  Par_FechaIni AND Par_FechaFin
			ORDER BY FechaProceso;
	END IF;
END TerminaStore$$ 