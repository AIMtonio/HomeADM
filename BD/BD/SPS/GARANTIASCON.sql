-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GARANTIASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `GARANTIASCON`;

DELIMITER $$
CREATE PROCEDURE `GARANTIASCON`(
	/*  SP DE CONSULTA DE GARANTIAS*/
	Par_GarantiaID     	INT(11),			-- Id de garantia
	Par_ProspectoID	   	BIGINT(20),			-- Id de prospeto titular de la garantia
	Par_ClienteID	   	INT(11),			-- Id del cliente titular de la garantia
	Par_SolicitudCreditoID 	BIGINT(20),		-- ID de Solicitud de Credito
	Par_TipoCon       	INT(11),			-- Numero de consulta

	Aud_EmpresaID	    INT(11),			-- Parametros de Auditoria --
	Aud_Usuario	        INT(11),			-- Auditoria
	Aud_FechaActual		DATETIME, 			-- Auditoria
	Aud_DireccionIP		VARCHAR(15), 		-- Auditoria
	Aud_ProgramaID	    VARCHAR(70), 		-- Auditoria
	Aud_Sucursal	    INT(11), 			-- Auditoria
	Aud_NumTransaccion	BIGINT(20)  		-- Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Consultas
	DECLARE Con_principal 		INT(11);	-- Consulta Principal
	DECLARE Con_MontoDisponGar 	INT(11);	-- Consulta Monto Disponible de Garantia
	DECLARE Con_MontoAvaluo 	INT(11);	-- Consulta Monto de Avaluo de la Garantia
	DECLARE Con_MontoAsignado 	INT(11);	-- Consulta Monto Asignado de la Garantia


	-- Declaracion de constantes
	DECLARE Decimal_Cero 		DECIMAL(12,2);	-- Decimal Cero
	DECLARE	Fecha_Vacia			DATE;

	-- Asignacion de Consultas
	SET Con_principal		:= 1;
	SET Con_MontoDisponGar	:= 1;
	SET Con_MontoAvaluo		:= 2;
	SET Con_MontoAsignado	:= 3;
	Set	Fecha_Vacia			:= '1900-01-01';


	-- Asignacion de Constantes
	SET Decimal_Cero 		:= 0.00;

	IF(Par_TipoCon = Con_principal) THEN

		SELECT
			LPAD(CONVERT(GarantiaID, CHAR), 10, 0) AS GarantiaID,	 	ProspectoID, 		ClienteID,			AvalID,				GaranteID,
			TipoGarantiaID,		ClasifGarantiaID,	ValorComercial, 	Observaciones,		EstadoID,
			MunicipioID,		Calle,	 			Numero, 			NumeroInt,	 		Lote,
			Manzana,			Colonia,	 		CodigoPostal,		M2Construccion,		M2Terreno,
			Asegurado,			IFNULL(VencimientoPoliza,Fecha_Vacia) as VencimientoPoliza,	FechaValuacion,		NumAvaluo,	 		NombreValuador,
			Verificada, 		FechaVerificacion,	TipoGravemen,		TipoInsCaptacion,	InsCaptacionID,
			MontoAsignado,		Estatus ,			NoIdentificacion,  	TipoDocumentoID, 	Asegurador,
			NombreAutoridad,	CargoAutoridad,		FechaCompFactura,	IFNULL(FechaGrevemen,Fecha_Vacia) AS FechaGrevemen,		FolioRegistro,
			MontoGravemen,		NombBenefiGravem, 	NotarioID,			NumPoliza,			ReferenFactura,
			RFCEmisor,			SerieFactura,		ValorFactura,		IFNULL(FechaRegistro,Fecha_Vacia) AS FechaRegistro,		GaranteNombre,
			Sucursal,			CalleGarante,		NumIntGarante,		NumExtGarante,		ColoniaGarante,
			CodPostalGarante,	EstadoIDGarante,	MunicipioGarante,	LocalidadID,		ColoniaID,
			MontoAvaluo,
			IFNULL(FNDISPONIBLEGARANTIA(GarantiaID, Par_SolicitudCreditoID, Con_MontoDisponGar), Decimal_Cero) AS MontoDisponible,
			IFNULL(FNDISPONIBLEGARANTIA(GarantiaID, Par_SolicitudCreditoID, Con_MontoAvaluo),    Decimal_Cero) AS MontoGarantia,
			IFNULL(FNDISPONIBLEGARANTIA(GarantiaID, Par_SolicitudCreditoID, Con_MontoAsignado),  Decimal_Cero) AS MontoAvaluado
		FROM GARANTIAS
		WHERE GarantiaID = Par_GarantiaID;

	END IF;

END TerminaStore$$