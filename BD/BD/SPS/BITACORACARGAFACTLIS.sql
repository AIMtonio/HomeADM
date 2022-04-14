-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACARGAFACTLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORACARGAFACTLIS`;
DELIMITER $$

CREATE PROCEDURE `BITACORACARGAFACTLIS`(
-- ===================================================================================
-- SP PARA LISTAR LAS FACTURAS PROCESADAS MASIVAMENTE
-- ===================================================================================
	Par_FolioCargaID			INT(11),			-- FOLIO DE CARGA
    Par_TipoLista				TINYINT UNSIGNED,	-- TIPO DE LISTAS

    /* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Lista_Principal			INT(11);
DECLARE Lista_Fallida			INT(11);
DECLARE Entero_Cero				INT(11);
-- Asignacion de Constantes
SET Entero_Cero					:=0;
SET	Lista_Principal     		:= 1; 		-- LISTA PARA FILTRAR POR FOLIO
SET Lista_Fallida				:= 2;		-- TIPO DE LISTA PARA MOSTRAR LOS REGISTROS FALLIDOS

-- LISTA DE REGISTROS EXITOSOS
IF(IFNULL(Par_TipoLista, Entero_Cero)) = Lista_Principal THEN
	SET @consecutivo := Entero_Cero;
	SELECT 	BI.FolioFacturaID, 			BI.FolioCargaID, 				BI.FechaCarga, 					BI.MesSubirFact, 			BI.UUID,
			BI.Estatus, 				BI.EsCancelable, 				BI.EstatusCancelacion, 			BI.Tipo, 					BI.Anio, 
			BI.Mes, 					BI.Dia, 						BI.FechaEmision, 				BI.FechaTimbrado, 			BI.Serie,
			BI.Folio, 					BI.LugarExpedicion, 			BI.Confirmacion, 				BI.CfdiRelacionados, 		BI.FormaPago,
			BI.MetodoPago, 				BI.CondicionesPago, 			BI.TipoCambio, 					BI.Moneda, 					BI.SubTotal,
			BI.Descuento, 				BI.Total, 						BI.ISRRetenido, 				BI.ISRTrasladado, 			BI.IVARetenidoGlobal,
			BI.IVARetenido6, 			BI.IVATrasladado16, 			BI.IVATrasladado8, 				BI.IVAExento, 				BI.BaseIVAExento,
			BI.IVATasaCero, 			BI.BaseIVATasaCero, 			BI.IEPSRetenidoTasa, 			BI.IEPSTrasladadoTasa, 		BI.IEPSRetenidoCuota,
			BI.IEPSTrasladadoCuota, 	BI.TotalImpuestosRetenidos, 	BI.TotalImpuestosTrasladados, 	BI.TotalRetencionesLocales,(@consecutivo:=@consecutivo+1) AS Consecutivo,
			BI.TotalTrasladosLocales, 	BI.ImpuestoLocalRetenido, 		BI.TasadeRetencionLocal, 		BI.ImportedeRetencionLocal, BI.ImpuestoLocalTrasladado,
			BI.TasadeTrasladoLocal, 	BI.ImportedeTrasladoLocal, 		BI.RfcEmisor, 					BI.NombreEmisor, 			BI.RegimenFiscalEmisor, 
			BI.RfcReceptor,	 			BI.NombreReceptor, 				BI.UsoCFDIReceptor, 			BI.ResidenciaFiscal, 		BI.NumRegIdTrib, 
			BI.ListaNegra, 				BI.Conceptos, 					BI.PACCertifico, 				BI.RutadelXML, 			 	BI.EstatusPro,
			BI.EsExitoso, 				BI.TipoError, 					BI.DescripcionError,			"N" AS SeleccionadoCheck, "N" AS EstatusCheck,
            IFNULL(P.ProveedorID,0) as SafiID
      FROM BITACORACARGAFACT BI
      LEFT JOIN PROVEEDORES P ON (BI.RfcEmisor = P.RFC OR BI.RfcEmisor = P.RFCpm)
      WHERE BI.FolioCargaID = Par_FolioCargaID
      AND BI.EstatusPro = "N"
      AND BI.TipoError=0;
END IF;

-- LISTA DE REGISTROS FALLIDOS
IF(IFNULL(Par_TipoLista, Entero_Cero)) = Lista_Fallida THEN
	SET @consecutivo := Entero_Cero;
	SELECT 	FolioFacturaID, 			FolioCargaID, 				FechaCarga, 				MesSubirFact, 			UUID,
			Estatus, 					EsCancelable, 				EstatusCancelacion, 		Tipo, 					Anio,
            Mes, 						Dia, 						FechaEmision, 				FechaTimbrado, 			Serie,
            Folio, 						LugarExpedicion, 			Confirmacion, 				CfdiRelacionados, 		FormaPago,
            MetodoPago, 				CondicionesPago, 			TipoCambio, 				Moneda, 				SubTotal,
            Descuento, 					Total, 						ISRRetenido, 				ISRTrasladado, 			IVARetenidoGlobal,
            IVARetenido6, 				IVATrasladado16, 			IVATrasladado8, 			IVAExento, 				BaseIVAExento,
            IVATasaCero, 				BaseIVATasaCero, 			IEPSRetenidoTasa, 			IEPSTrasladadoTasa, 	IEPSRetenidoCuota,
            IEPSTrasladadoCuota, 		TotalImpuestosRetenidos, 	TotalImpuestosTrasladados, 	TotalRetencionesLocales,(@consecutivo:=@consecutivo+1) AS Consecutivo,
            TotalTrasladosLocales, 		ImpuestoLocalRetenido, 		TasadeRetencionLocal, 		ImportedeRetencionLocal, ImpuestoLocalTrasladado,
            TasadeTrasladoLocal, 		ImportedeTrasladoLocal, 	RfcEmisor, 					NombreEmisor, 			 RegimenFiscalEmisor,
            RfcReceptor,	 			NombreReceptor, 			UsoCFDIReceptor, 			ResidenciaFiscal, 		 NumRegIdTrib,
            ListaNegra, 				Conceptos, 					PACCertifico, 				RutadelXML, 			 EstatusPro,
            EsExitoso, 					TipoError, 					DescripcionError
      FROM BITACORACARGAFACT
      WHERE FolioCargaID = Par_FolioCargaID
      AND TipoError!=0;
END IF;


END TerminaStore$$