-- CARTALIQUIDACIONREP

DELIMITER ;
DROP PROCEDURE IF EXISTS `CARTALIQUIDACIONREP`;
DELIMITER $$

CREATE PROCEDURE `CARTALIQUIDACIONREP`(
-- =====================================================================================
-- ------- STORED PARA EL FORMARTO DE LA CARTA DE LIQUIDACION ---------
-- =====================================================================================
	Par_CreditoID			BIGINT(12),			-- CreditoID para la carta de liquidación
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta

	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion

)
TerminaStore: BEGIN
	-- DECLARACION VARIABLES


	DECLARE Var_SucusalMatriz	INT(11);			-- Variable para obtener Sucursal Matriz
	DECLARE Var_ClienteInstitu 	INT(11);			-- Variable para obstener el Cliente que utiliza la institucion
	DECLARE Var_RazonSocial		VARCHAR(150);		-- Variable para Razon Social de la Instutucion.
	DECLARE Var_FecPriPago 		DATE; 				-- Fecha de Vencimento del Primer Pago
	DECLARE Var_DirMatriz		VARCHAR(500);		-- Direccion de la Sucursal Matriz
	DECLARE Var_NumCuotas		INT(11);			-- Numero de Cuotas
	DECLARE Var_MontoOtorgado			DECIMAL(14,2);		-- Monto del Credito Otorgado
	DECLARE Var_MontoAtrasado			DECIMAL(14,2);		-- Monto Atrasado
	DECLARE Var_PagaIVA       			CHAR(1);			-- Variable si Paga IVA
	DECLARE Var_IVA           			DECIMAL(12,2);		-- Variable del monto del IVA
	DECLARE Var_PagaIVAInt    			CHAR(1);			-- Variable Paga IVA del Interes


	-- DECLARACION DE CONSTANTES
	DECLARE Con_Cliente					INT;			-- Consulta Principal.
	DECLARE Con_DetCre					INT;			-- Constante Detalles Credito
	DECLARE Con_InfLiq					INT;			-- Constante Informacin Liquidar

	DECLARE Con_Frec_Semanal 			CHAR(1);
	DECLARE Con_Frec_Catorcenal			CHAR(1);
	DECLARE Con_Frec_Quincenal			CHAR(1);
	DECLARE Con_Frec_Mensual			CHAR(1);
	DECLARE Con_Frec_Periodica			CHAR(1);
	DECLARE Con_Frec_Bimestral			CHAR(1);
	DECLARE Con_Frec_Trimestral			CHAR(1);
	DECLARE Con_Frec_Tetramestral		CHAR(1);
	DECLARE Con_Frec_Semestral			CHAR(1);
	DECLARE Con_Frec_Anual				CHAR(1);
	DECLARE Con_Frec_Decenal			CHAR(1);
	DECLARE Con_Frec_Mixto				VARCHAR(15);

	DECLARE Con_Desc_Semanal 			VARCHAR(20);
	DECLARE Con_Desc_Catorcenal			VARCHAR(20);
	DECLARE Con_Desc_Quincenal			VARCHAR(20);
	DECLARE Con_Desc_Mensual			VARCHAR(20);
	DECLARE Con_Desc_Periodica			VARCHAR(20);
	DECLARE Con_Desc_Bimestral			VARCHAR(20);
	DECLARE Con_Desc_Trimestral			VARCHAR(20);
	DECLARE Con_Desc_Tetramestral		VARCHAR(20);
	DECLARE Con_Desc_Semestral			VARCHAR(20);
	DECLARE Con_Desc_Anual				VARCHAR(20);
	DECLARE Con_Desc_Decenal			VARCHAR(20);

	DECLARE Con_Pag_Crecientes			CHAR(1);
	DECLARE Con_Pag_Iguales				CHAR(1);
	DECLARE Con_Pag_Libres				CHAR(1);

	DECLARE Cadena_Vacia				CHAR(1);
	DECLARE Entero_Cero					INT;
	DECLARE Fecha_Vacia					DATE;
	DECLARE Est_Activo					CHAR(1);
	DECLARE Con_NO						CHAR(1);

	-- ASIGNACION DE CONSTANTES
	SET Con_Cliente				:=1;
	SET Con_DetCre				:=2;
	SET Con_InfLiq				:=3;

	SET Con_Frec_Semanal 			:='S';
	SET Con_Frec_Catorcenal			:='C';
	SET Con_Frec_Quincenal			:='Q';
	SET Con_Frec_Mensual			:='M';
	SET Con_Frec_Periodica			:='P';
	SET Con_Frec_Bimestral			:='B';
	SET Con_Frec_Trimestral			:='T';
	SET Con_Frec_Tetramestral		:='R';
	SET Con_Frec_Semestral			:='E';
	SET Con_Frec_Anual				:='A';
	SET Con_Frec_Decenal			:='D';

	SET Con_Desc_Semanal 			:='Semanal';
	SET Con_Desc_Catorcenal			:='Catorcenal';
	SET Con_Desc_Quincenal			:='Quincenal';
	SET Con_Desc_Mensual			:='Mensual';
	SET Con_Desc_Periodica			:='Periodica';
	SET Con_Desc_Bimestral			:='Bimestral';
	SET Con_Desc_Trimestral			:='Trimestral';
	SET Con_Desc_Tetramestral		:='Tetramestral';
	SET Con_Desc_Semestral			:='Semestral';
	SET Con_Desc_Anual				:='Anual';
	SET Con_Desc_Decenal			:='Decenal';


	SET Con_Pag_Crecientes			:='C';
	SET Con_Pag_Iguales				:='I';
	SET Con_Pag_Libres				:='L';

	SET Cadena_Vacia        := '';              -- String Vacio
	SET Fecha_Vacia         := '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero         := 0;               -- Entero en Cero
	SET Est_Activo          := 'A';             -- Estatus del Integrante: Activo
	SET Con_NO						:= 'N';				-- Constante NO

	-- Consulta 1
	IF(Par_NumCon = Con_Cliente) THEN

		SELECT  IFNULL(INom.NombreInstit,Cadena_Vacia) AS LugTrabajo,
				IFNULL(NEmp.NoEmpleado,Cadena_Vacia) AS EmpleadoID,
				Cli.NombreCompleto AS NomCompleto,
				FUNCIONLETRASFECHA(FechaRegistro)
			FROM CARTALIQUIDACION CL INNER JOIN CREDITOS AS Cre
				ON CL.CreditoID = Cre.CreditoID
				LEFT JOIN NOMINAEMPLEADOS AS NEmp
					ON Cre.ClienteID 			= NEmp.ClienteID
					AND Cre.InstitNominaID 		= NEmp.InstitNominaID
					AND Cre.ConvenioNominaID 	= NEmp.ConvenioNominaID
					LEFT JOIN CLIENTES AS Cli ON Cre.ClienteID = Cli.ClienteID
						LEFT JOIN INSTITNOMINA AS INom ON Cre.InstitNominaID = INom.InstitNominaID
			WHERE CL.CreditoID 	= Par_CreditoID
			  AND CL.Estatus 	= Est_Activo;
	END IF;

	IF(Par_NumCon = Con_DetCre) THEN

		SELECT MIN(FechaVencim), COUNT(AmortizacionID)
				INTO Var_FecPriPago, Var_NumCuotas
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID;


		-- DATOS DE AMORTICREDITO
		SELECT (SUM(Capital)+SUM(Interes)+SUM(IVAInteres)+ SUM(MontoSeguroCuota)+SUM(IVASeguroCuota))
		INTO Var_MontoOtorgado
		FROM AMORTICREDITO
		WHERE CreditoID = Par_CreditoID;

		SET Var_MontoOtorgado := IFNULL(Var_MontoOtorgado, Entero_Cero);

		SELECT  Cli.PagaIVA,    Suc.IVA,	Pro.CobraIVAInteres
		INTO  	Var_PagaIVA,    Var_IVA,	Var_PagaIVAInt
		FROM CREDITOS Cre,
			CLIENTES Cli,
			SUCURSALES Suc,
			PRODUCTOSCREDITO Pro
			WHERE Cre.CreditoID = Par_CreditoID
				AND Cre.ClienteID = Cli.ClienteID
				AND Cli.SucursalOrigen = Suc.SucursalID
				AND Pro.ProducCreditoID = Cre.ProductoCreditoID;

		IF(Var_PagaIVA = Con_NO ) THEN
			SET Var_IVA := Entero_Cero;
		ELSE
			IF (Var_PagaIVAInt = Con_NO) THEN
				SET Var_IVA := Entero_Cero;
			END IF;
		END IF;


		SELECT SUM(SaldoCapAtrasa + SaldoCapVencido + SaldoCapVenNExi + (SaldoInteresAtr * Var_IVA) +
			 (SaldoInteresVen * Var_IVA) + (SaldoIntNoConta * Var_IVA) + SaldoOtrasComis + SaldoIVAComisi)
		INTO Var_MontoAtrasado
		FROM AMORTICREDITO
		WHERE CreditoID = Par_CreditoID;

		SET Var_MontoAtrasado := IFNULL(Var_MontoAtrasado,Entero_Cero);


		SELECT
				CL.CartaLiquidaID AS Folio,
				CL.CreditoID AS CreditoID,
				Var_FecPriPago AS FechaPriPago,
				Var_NumCuotas AS NumeroCuotas,
				CASE WHEN (Cre.TipoPagoCapital = Con_Pag_Libres
						OR Cre.FrecuenciaCap != Cre.FrecuenciaInt) THEN
					Con_Frec_Mixto
				ELSE
					CASE Cre.FrecuenciaCap
						WHEN Con_Frec_Semanal		THEN	Con_Desc_Semanal
						WHEN Con_Frec_Catorcenal	THEN	Con_Desc_Catorcenal
						WHEN Con_Frec_Quincenal		THEN	Con_Desc_Quincenal
						WHEN Con_Frec_Mensual		THEN	Con_Desc_Mensual
						WHEN Con_Frec_Periodica		THEN	Con_Desc_Periodica
						WHEN Con_Frec_Bimestral		THEN	Con_Desc_Bimestral
						WHEN Con_Frec_Trimestral	THEN	Con_Desc_Trimestral
						WHEN Con_Frec_Tetramestral	THEN	Con_Desc_Tetramestral
						WHEN Con_Frec_Semestral		THEN	Con_Desc_Semestral
						WHEN Con_Frec_Anual			THEN	Con_Desc_Anual
						WHEN Con_Frec_Decenal		THEN	Con_Desc_Decenal
						ELSE Cadena_Vacia
					END
				END AS Plazo,
				Var_MontoOtorgado AS CreditoOri,
				Det.SaldoCapital AS Capital,
				Det.PorcenCuoPag AS CuotaPag,
				Det.ProcenCuoNoPag AS CuotaNoPag,
				ROUND(Cre.TasaFija,2) AS TasaInt,
				Det.UltAbono AS Abono,
				Det.MontoPagado AS MontoRe,
				Var_MontoAtrasado AS MontoAtr
			FROM CARTALIQUIDACION CL INNER JOIN CREDITOS Cre
				ON CL.CreditoID = Cre.CreditoID INNER JOIN CARTALIQUIDACIONDET Det
					ON Det.CartaLiquidaID = CL.CartaLiquidaID
			WHERE CL.CreditoID 	= Par_CreditoID
			  AND CL.Estatus 	= Est_Activo;
	END IF;

	IF(Par_NumCon = Con_InfLiq) THEN

		SELECT SucursalMatrizID, ClienteInstitucion
			INTO Var_SucusalMatriz, Var_ClienteInstitu
		FROM PARAMETROSSIS
		LIMIT 1;

		SELECT RazonSocial
			INTO Var_RazonSocial
		FROM CLIENTES
		WHERE ClienteID 	= Var_ClienteInstitu;

		SELECT CONCAT(FNGENDIRECCION(01,S.EstadoID,S.MunicipioID,S.LocalidadID, S.ColoniaID,S.Calle, S.Numero,'','','','',S.CP, '','',''), ' TEL.',S.Telefono)
			INTO Var_DirMatriz
			FROM SUCURSALES AS S LEFT JOIN ESTADOSREPUB AS ER ON ER.EstadoID 	= S.EstadoID
		WHERE SucursalID 	= 1;

		SELECT FechaVencim
			INTO Var_FecPriPago
		FROM AMORTICREDITO
		WHERE CreditoID 		= Par_CreditoID
		  AND AmortizacionID 	= 1;

		SELECT
			Det.CuotasGeneradas AS CuotasGen,
			CONCAT('$', FORMAT(Cre.MontoCuota,2)) AS Abono,
			CONCAT('$', FORMAT(Det.MontoTotalAdeu,2)) AS TotalPag,
			CONCAT('$', FORMAT(Det.MontoPagado,2)) AS MontoRe,
			Det.PorcenCuoPag AS CuotaPag,
			Var_FecPriPago AS FechaPriPago,
			Det.CuotasPagadas AS CuotaPag,
			CONCAT('$', FORMAT(Det.MontoPagaFec,2)) AS MontoPagFec,
			FORMAT(Det.PorcenCuoPag,2) AS PorcPen,
			Det.CuotasPendientes AS CuoPen,
			CONCAT('$', FORMAT(Det.MontoPendiente,2)) AS MontoPenInt,
			FUNCIONLETRASFECHA(Det.FechaUltDescuento) AS FechaUltPago,
			Det.MontoLiquidar AS MontoLiq,
			UPPER(CONVPORCANT(Det.MontoLiquidar, '$C',Cadena_Vacia, Cadena_Vacia)) AS MontoLiqLetra,
			FUNCIONLETRASFECHA(CL.FechaVencimiento) AS FechaVEn,
			Var_RazonSocial AS NombreFin,
			IFNULL(Ban.NombreCorto, Cadena_Vacia) AS Banco,
			CL.Convenio AS NumConvenio,
			CL.CreditoID AS CreditoID,
			Det.DescuentoPen AS MontoPendiente,
			UPPER(CONVPORCANT(Det.DescuentoPen, '$C',Cadena_Vacia, Cadena_Vacia)) AS MonLetra,
			FNCAPITALIZAPALABRA(Var_DirMatriz) AS DirSuc,
			Usu.Clave AS Usuario,
			Det.CodigoQR AS CodigoQR
			FROM CARTALIQUIDACION CL INNER JOIN CREDITOS Cre
				ON CL.CreditoID = Cre.CreditoID INNER JOIN CARTALIQUIDACIONDET Det
					ON Det.CartaLiquidaID = CL.CartaLiquidaID
						LEFT JOIN INSTITUCIONES Ban
							ON CL.InstitucionID = Ban.InstitucionID
								LEFT JOIN USUARIOS Usu
									ON CL.Usuario = Usu.UsuarioID
			WHERE CL.CreditoID 	= Par_CreditoID
			  AND CL.Estatus 	= Est_Activo;
	END IF;

END TerminaStore$$