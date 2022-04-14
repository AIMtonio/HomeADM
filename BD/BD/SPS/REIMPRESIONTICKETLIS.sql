-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REIMPRESIONTICKETLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `REIMPRESIONTICKETLIS`;
DELIMITER $$


CREATE PROCEDURE `REIMPRESIONTICKETLIS`(
	Par_OpcionCajaID	INT(11),
	Par_NumTransaccion	BIGINT(20),
	Par_Nombre			VARCHAR(50),
	Par_NumLis			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT(20)


		)

TerminaStore:BEGIN
	-- Declaracion de variables

	-- Declaracion de Constantes
	DECLARE List_Principal		INT;
	DECLARE List_ConsultaGrid	INT;
	DECLARE Entero_Cero			INT(11);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Hora_Vacia			VARCHAR(5);

	-- Asignacion de Constantes
	SET List_Principal			:=1;	-- Lista Principal (lista todos los servicios registrados)
	SET List_ConsultaGrid		:=2;	-- Lista para la consulta del grid de pantalla Reimpresion de Ticket
	SET Entero_Cero				:= 0;
	SET Cadena_Vacia			:= '';
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia				:= '1900-01-01';
	SET Hora_Vacia				:= '00:00';


	-- 1. lista principal
	IF(Par_NumLis = List_Principal)THEN

		SELECT TransaccionID,Referencia, FORMAT(MontoOperacion,2) AS MontoOperacion,NombrePersona
			FROM REIMPRESIONTICKET
			WHERE NombrePersona LIKE CONCAT("%", Par_Nombre, "%")
				AND OpcionCajaID = Par_OpcionCajaID
					AND UsuarioID=Aud_Usuario
					ORDER BY TransaccionID DESC
					LIMIT 15  ;

	END IF;

	/* Modificado por Cardinal Sistemas Inteligente
		Se agregaron los siguientes elementos al final del select:
		ArrendaID,ProdArrendaID, NomProdArrendaID,SeguroVida,Seguro,IVASeguroVida,
		IVASeguro,IVACapital,IVAInteres,IVAMora,IVAOtrasComi,IVAComFaltaPag
	*/
	IF(Par_NumLis = List_ConsultaGrid) THEN



		SELECT

		 	IFNULL(TransaccionID,Entero_Cero) AS TransaccionID,			IFNULL(TipoOperacionID,Entero_Cero) AS TipoOperacionID,		IFNULL(SucursalID,Entero_Cero) AS SucursalID,				IFNULL(CajaID,Entero_Cero) AS CajaID,							IFNULL(UsuarioID,Entero_Cero) AS UsuarioID,
			IFNULL(Fecha,Fecha_Vacia) AS Fecha,							IFNULL(Hora,Hora_Vacia) AS Hora,							IFNULL(OpcionCajaID,Entero_Cero) AS OpcionCajaID,			IFNULL(Descripcion,Cadena_Vacia) AS Descripcion,				IFNULL(MontoOperacion,Decimal_Cero) AS MontoOperacion,
			IFNULL(Efectivo,Decimal_Cero) AS Efectivo,					IFNULL(Cambio,Decimal_Cero) AS Cambio,						IFNULL(NombrePersona,Cadena_Vacia) AS NombrePersona,		IFNULL(NombreBeneficiario,Cadena_Vacia) AS NombreBeneficiario,	IFNULL(ClienteID,Entero_Cero) as ClienteID,
			IFNULL(ProspectoID,Entero_Cero) AS ProspectoID,				IFNULL(EmpleadoID,Entero_Cero) AS EmpleadoID,				IFNULL(NombreEmpleado,Cadena_Vacia) AS NombreEmpleado,		IFNULL(CuentaIDRetiro,Entero_Cero) AS CuentaIDRetiro,			IFNULL(CuentaIDDeposito,Entero_Cero) AS CuentaIDDeposito,
			IFNULL(EtiquetaCtaRetiro,Cadena_Vacia) AS EtiquetaCtaRetiro,IFNULL(EtiquetaCtaDepo,Cadena_Vacia) AS EtiquetaCtaDepo,	IFNULL(DesTipoCuenta,Cadena_Vacia) AS DesTipoCuenta,		IFNULL(DesTipoCtaDepo,Cadena_Vacia) AS DesTipoCtaDepo,			IFNULL(SaldoActualCta,Decimal_Cero) AS SaldoActualCta,
			IFNULL(Referencia,Cadena_Vacia) AS Referencia,				IFNULL(FormaPagoCobro,Cadena_Vacia) AS FormaPagoCobro,		IFNULL(CreditoID,Entero_Cero) AS CreditoID,					IFNULL(ProducCreditoID,Entero_Cero) AS ProducCreditoID,			IFNULL(NombreProdCred,Cadena_Vacia) AS NombreProdCred,
			IFNULL(MontoCredito,Decimal_Cero) AS MontoCredito,			IFNULL(MontoPorDesem,Decimal_Cero) AS MontoPorDesem,		IFNULL(MontoDesemb,Decimal_Cero) AS MontoDesemb,			IFNULL(GrupoID,Entero_Cero) AS GrupoID,							IFNULL(NombreGrupo,Cadena_Vacia) AS NombreGrupo,
			IFNULL(CicloActual,Entero_Cero) AS CicloActual,				IFNULL(MontoProximoPago,Decimal_Cero) AS MontoProximoPago,	IFNULL(FechaProximoPago,Fecha_Vacia) AS FechaProximoPago,	IFNULL(TotalAdeudo,Decimal_Cero) AS TotalAdeudo,				IFNULL(Capital,Cadena_Vacia) AS Capital,
			IFNULL(Interes,Cadena_Vacia) AS Interes,					IFNULL(Moratorios,Cadena_Vacia) AS Moratorios,				IFNULL(Comision,Cadena_Vacia) AS Comision,					IFNULL(ComisionAdmon,Cadena_Vacia) AS ComisionAdmon,			IFNULL(IVA,Cadena_Vacia) AS IVA,
			 (Efectivo - MontoOperacion) AS GarantiaAdicional,			IFNULL(InstitucionID,Entero_Cero) AS InstitucionID,			IFNULL(NumCtaInstit,Cadena_Vacia) AS NumCtaInstit,			IFNULL(NumCheque,Entero_Cero) AS NumCheque,						IFNULL(NombreInstit,Cadena_Vacia) AS NombreInstit,
			IFNULL(PolizaID,Entero_Cero) AS PolizaID,					IFNULL(Telefono,Cadena_Vacia) AS Telefono,					IFNULL(Identificacion,Cadena_Vacia) AS Identificacion,		IFNULL(FolioIdentificacion,Cadena_Vacia) AS FolioIdentificacion,IFNULL(FolioPago,Cadena_Vacia ) AS FolioPago,
			IFNULL(CatalogoServID,Entero_Cero) AS CatalogoServID,		IFNULL(NombreCatalServ,Cadena_Vacia) AS NombreCatalServ,	IFNULL(MontoServicio,Decimal_Cero) AS MontoServicio,		IFNULL(IVAServicio,Decimal_Cero) AS IVAServicio,				IFNULL(OrigenServicio,Cadena_Vacia) AS OrigenServicio,
			IFNULL(MontoComision,Decimal_Cero) AS MontoComision,		IFNULL(TotalCastigado,Decimal_Cero) AS TotalCastigado,		IFNULL(TotalRecuperado,Decimal_Cero) AS TotalRecuperado,	IFNULL(Monto_PorRecuperar,Decimal_Cero) AS Monto_PorRecuperar,	IFNULL(TipoServServifun,Cadena_Vacia) AS TipoServServifun,
			IFNULL(CobraSeguroCuota,Cadena_Vacia ) AS CobraSeguroCuota,	IFNULL(MontoSeguroCuota,Decimal_Cero) AS MontoSeguroCuota,	IFNULL(IVASeguroCuota,Decimal_Cero) AS IVASeguroCuota,		IFNULL(ArrendaID,Entero_Cero) AS ArrendaID,						IFNULL(ProdArrendaID,Entero_Cero) AS ProdArrendaID,
			IFNULL(NomProdArrendaID,Cadena_Vacia) AS NomProdArrendaID,	IFNULL(SeguroVida,Decimal_Cero) AS SeguroVida,				IFNULL(Seguro,Decimal_Cero) AS Seguro,						IFNULL(IVASeguroVida,Decimal_Cero) AS IVASeguroVida,			IFNULL(IVASeguro,Decimal_Cero) AS IVASeguro,
			IFNULL(IVACapital,Decimal_Cero)  AS IVACapital, 			IFNULL(IVAInteres,Decimal_Cero) AS IVAInteres,				IFNULL(IVAMora,Decimal_Cero) AS IVAMora,					IFNULL(IVAOtrasComi,Decimal_Cero) AS IVAOtrasComi,				IFNULL(IVAComFaltaPag,Decimal_Cero) AS IVAComFaltaPag,
			IFNULL(AccesorioID,Entero_Cero) AS AccesorioID
		FROM REIMPRESIONTICKET
		WHERE OpcionCajaID=Par_OpcionCajaID AND UsuarioID=Aud_Usuario
		  AND TransaccionID= Par_NumTransaccion;
	END IF;
END TerminaStore$$
