-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before AND after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCREDITOWSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCREDITOWSREP`;

DELIMITER $$
CREATE PROCEDURE `PAGOCREDITOWSREP`(
	-- Store Procedure para generar el Reporte de pagos de credito
	-- Cartera de Credito
	Par_NegocioAfiliadoID	INT(11),		-- Negocio Afiliado
	Par_InstitNominaID		INT(11),		-- Institucion de Nomina
	Par_ClienteID			INT(11),		-- Numero de Cliente
	Par_FechaInicio			DATE,			-- Fecha de Inicio
	Par_FechaFin			DATE,			-- Fecha de Fin

	Par_TipoReporte			INT(11),		-- Tipo de Reporte

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);	-- Constantes Entero Cero
	DECLARE Cadena_Vacia	CHAR(1);	-- Constantes Cadena Vacia
	DECLARE Est_Aplicado	CHAR(1);	-- Constantes Estatus Aplicado
	DECLARE Est_Cancelado	CHAR(1);	-- Constantes Estatus Cancelado
	DECLARE Est_PorAplicar	CHAR(1);	-- Constantes Estatus PorAplicar

	-- Declaracion de Reportes
	DECLARE Rep_NegAfilia	INT(11);	-- Reporte Negocio de Afiliacion
	DECLARE Rep_EmpNomina	INT(11);	-- Reporte Empresas de nomina
	DECLARE Rep_PFyPM		INT(11);	-- Reporte Persona Fisica y Morla
	DECLARE Rep_PagAplNom	INT(11);	-- Reporte Pago Aplicado de Nomina

	-- Asignacion de Constantes
	SET	Entero_Cero		:= 0;
	SET	Cadena_Vacia	:= '';
	SET	Est_Aplicado	:= 'A';
	SET	Est_Cancelado	:= 'C';
	SET	Est_PorAplicar	:= 'P';

	-- Asignacion de Reportes
	SET	Rep_NegAfilia	:= 1;
	SET	Rep_EmpNomina	:= 2;
	SET	Rep_PFyPM		:= 3;
	SET Rep_PagAplNom	:= 4;


	SET	Par_NegocioAfiliadoID	:= IFNULL(Par_NegocioAfiliadoID, Entero_Cero);
	SET	Par_InstitNominaID		:= IFNULL(Par_InstitNominaID, Entero_Cero);
	SET	Par_ClienteID			:= IFNULL(Par_ClienteID, Entero_Cero);


	IF( Par_TipoReporte = Rep_NegAfilia ) THEN

		IF( Par_ClienteID = Entero_Cero ) THEN

			SELECT	CONCAT(CONVERT(Cli.ClienteID, CHAR), '-', Cli.NombreCompleto) AS Cliente,
					CONVERT(Pag.CreditoID, CHAR) AS Credito,
					CONVERT(Pag.FechaPago, CHAR(10)) AS FechaPago,
					Pag.MontoTotPago AS MontoPago,
					CONCAT(CONVERT(Prod.ProducCreditoID, CHAR), '-', Prod.Descripcion) AS ProductoCredito
			FROM DETALLEPAGCRE Pag
			INNER JOIN CREDITOS Cre ON Pag.CreditoID = Cre.CreditoID
			INNER JOIN PRODUCTOSCREDITO Prod ON Cre.ProductoCreditoID = Prod.ProducCreditoID
			INNER JOIN SOLICITUDCREDITO Sol ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
			INNER JOIN SOLICITUDCREDITOBE Ban ON Sol.SolicitudCreditoID = Ban.SolicitudCreditoID
			INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
			WHERE Ban.NegocioAfiliadoID = Par_NegocioAfiliadoID
			  AND Pag.FechaPago BETWEEN Par_FechaInicio AND Par_FechaFin
			ORDER BY Pag.FechaPago, Cli.ClienteID, Pag.CreditoID;
		ELSE

			SELECT 	CONCAT(CONVERT(Cli.ClienteID, CHAR), '-', Cli.NombreCompleto) AS Cliente,
					CONVERT(Pag.CreditoID, CHAR) AS Credito,
					CONVERT(Pag.FechaPago, CHAR(10)) AS FechaPago,
					Pag.MontoTotPago AS MontoPago,
					CONCAT(CONVERT(Prod.ProducCreditoID, CHAR), '-', Prod.Descripcion) AS ProductoCredito
			FROM DETALLEPAGCRE Pag
			INNER JOIN CREDITOS Cre ON Pag.CreditoID = Cre.CreditoID
			INNER JOIN PRODUCTOSCREDITO Prod ON Cre.ProductoCreditoID = Prod.ProducCreditoID
			INNER JOIN SOLICITUDCREDITO Sol ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
			INNER JOIN SOLICITUDCREDITOBE Ban ON Sol.SolicitudCreditoID = Ban.SolicitudCreditoID
			INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
			WHERE Ban.NegocioAfiliadoID = Par_NegocioAfiliadoID
			  AND Pag.FechaPago BETWEEN Par_FechaInicio AND Par_FechaFin
			  AND Cli.ClienteID = Par_ClienteID
			ORDER BY Pag.FechaPago, Pag.CreditoID;
		END IF;
	END IF;

	IF( Par_TipoReporte = Rep_EmpNomina ) THEN
		IF( Par_ClienteID = Entero_Cero ) THEN
			SELECT	CONCAT(CONVERT(Cli.ClienteID, CHAR), ' - ', Cli.NombreCompleto) AS Cliente,
					CONVERT(Pag.CreditoID, CHAR) AS Credito,LPAD(CONVERT(Cre.CuentaID, CHAR), 11, 0) AS Cuenta,
					CONVERT(Pag.FechaAplicacion, CHAR(10)) AS FechaPago,Pag.MontoPagos AS MontoPago,
					Pag.MontoAplicado, (Pag.MontoPagos-Pag.MontoAplicado) AS MontoNoAplicado,
					Pag.MontoAplicado+(Pag.MontoPagos-Pag.MontoAplicado) AS TotalRecibido,
					CONCAT(CONVERT(Pro.ProducCreditoID, CHAR), ' - ', Pro.Descripcion) AS ProductoCredito,
					TIME(NOW()) AS HoraEmision, Cre.InstitNominaID, IFNULL(Cre.ConvenioNominaID,0) AS ConvenioNominaID,
					CASE WHEN Pag.Estatus = Est_Aplicado   THEN 'PAGO APLICADO CORRECTAMENTE.'
						 WHEN Pag.Estatus = Est_Cancelado  THEN Pag.MotivoCancela
						 WHEN Pag.Estatus = Est_PorAplicar THEN 'PAGO POR APLICAR.'
						 ELSE Cadena_Vacia
					END AS MotivoCancelacion,
					CASE WHEN Pag.Estatus = Est_Aplicado   THEN 'PAGO APLICADO'
						 WHEN Pag.Estatus = Est_Cancelado  THEN 'CANCELADO'
						 WHEN Pag.Estatus = Est_PorAplicar THEN 'POR APLICAR'
						 ELSE Cadena_Vacia
					END AS Estatus, Pag.FolioCargaID
			FROM BEPAGOSNOMINA Pag
			INNER JOIN CREDITOS Cre ON Pag.CreditoID = Cre.CreditoID
			INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
			INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
			WHERE Pag.EmpresaNominaID = Par_InstitNominaID
			  AND Pag.FechaAplicacion BETWEEN Par_FechaInicio AND Par_FechaFin
			ORDER BY Pag.FolioCargaID, Pag.FechaAplicacion, Cli.ClienteID, Pag.CreditoID;
		ELSE

			SELECT	CONCAT(CONVERT(Cli.ClienteID, CHAR), ' - ', Cli.NombreCompleto) AS Cliente,
					CONVERT(Pag.CreditoID, CHAR) AS Credito,LPAD(CONVERT(Cre.CuentaID, CHAR), 11, 0) AS Cuenta,
					CONVERT(Pag.FechaAplicacion, CHAR(10)) AS FechaPago,Pag.MontoPagos AS MontoPago,
					Pag.MontoAplicado, (Pag.MontoPagos-Pag.MontoAplicado) AS MontoNoAplicado,
					Pag.MontoAplicado+(Pag.MontoPagos-Pag.MontoAplicado) AS TotalRecibido,
					CONCAT(CONVERT(Pro.ProducCreditoID, CHAR), ' - ', Pro.Descripcion) AS ProductoCredito,
					TIME(NOW()) AS HoraEmision, Cre.InstitNominaID, IFNULL(Cre.ConvenioNominaID,0) AS ConvenioNominaID,
					CASE WHEN Pag.Estatus = Est_Aplicado   THEN 'PAGO APLICADO CORRECTAMENTE.'
						 WHEN Pag.Estatus = Est_Cancelado  THEN Pag.MotivoCancela
						 WHEN Pag.Estatus = Est_PorAplicar THEN 'PAGO POR APLICAR.'
						 ELSE Cadena_Vacia
					END AS MotivoCancelacion,
					CASE WHEN Pag.Estatus = Est_Aplicado   THEN 'PAGO APLICADO'
						 WHEN Pag.Estatus = Est_Cancelado  THEN 'CANCELADO'
						 WHEN Pag.Estatus = Est_PorAplicar THEN 'POR APLICAR'
						 ELSE Cadena_Vacia
					END AS Estatus, Pag.FolioCargaID
			FROM BEPAGOSNOMINA Pag
			INNER JOIN CREDITOS Cre ON Pag.CreditoID = Cre.CreditoID
			INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
			INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
			WHERE Pag.EmpresaNominaID = Par_InstitNominaID
			  AND Pag.FechaAplicacion BETWEEN Par_FechaInicio AND Par_FechaFin
			  AND Cli.ClienteID = Par_ClienteID
			ORDER BY Pag.FolioCargaID, Pag.FechaAplicacion, Cli.ClienteID, Pag.CreditoID;
		END IF;
	END IF;

	IF( Par_TipoReporte = Rep_PFyPM ) THEN

		SELECT	CONCAT(CONVERT(Cli.ClienteID, CHAR), '-', Cli.NombreCompleto) AS Cliente,
				CONVERT(Pag.CreditoID, CHAR) AS Credito,
				CONVERT(Pag.FechaPago, CHAR(10)) AS FechaPago,
				Pag.MontoTotPago AS MontoPago,
				CONCAT(CONVERT(Prod.ProducCreditoID, CHAR), '-', Prod.Descripcion) AS ProductoCredito
		FROM DETALLEPAGCRE Pag
		INNER JOIN CREDITOS Cre ON Pag.CreditoID = Cre.CreditoID
		INNER JOIN PRODUCTOSCREDITO Prod ON Cre.ProductoCreditoID = Prod.ProducCreditoID
		INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
		WHERE Pag.FechaPago BETWEEN Par_FechaInicio AND Par_FechaFin
		  AND Cli.ClienteID = Par_ClienteID
		ORDER BY Pag.FechaPago, Pag.CreditoID;
	END IF;

	IF( Par_TipoReporte = Rep_PagAplNom ) THEN
		SELECT	CONCAT(CONVERT(Cli.ClienteID, CHAR), '-', Cli.NombreCompleto) AS Cliente,
				CONVERT(Pag.CreditoID, CHAR) AS Credito,
				CONVERT(Pag.FechaAplicacion, CHAR(10)) AS FechaPago,
				Pag.MontoAplicado AS MontoPago,
				CONCAT(CONVERT(Prod.ProducCreditoID, CHAR), '-', Prod.Descripcion) AS ProductoCredito
		FROM BEPAGOSNOMINA Pag
		INNER JOIN CREDITOS Cre ON Pag.CreditoID = Cre.CreditoID
		INNER JOIN PRODUCTOSCREDITO Prod ON Cre.ProductoCreditoID = Prod.ProducCreditoID
		INNER JOIN SOLICITUDCREDITO Sol ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
		INNER JOIN SOLICITUDCREDITOBE Ban ON Sol.SolicitudCreditoID = Ban.SolicitudCreditoID
										 AND Ban.InstitNominaID = Pag.EmpresaNominaID
		INNER JOIN CLIENTES Cli ON Pag.ClienteID = Cli.ClienteID
		WHERE Pag.FechaAplicacion BETWEEN Par_FechaInicio AND Par_FechaFin
		ORDER BY Pag.FechaAplicacion, Cli.ClienteID, Pag.CreditoID;
	END IF;

END TerminaStore$$