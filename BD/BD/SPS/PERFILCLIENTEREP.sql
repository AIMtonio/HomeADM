-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PERFILCLIENTEREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PERFILCLIENTEREP`;DELIMITER $$

CREATE PROCEDURE `PERFILCLIENTEREP`(
# =====================================================
# ---------- SP PARA MOSTRAR PERFIL DEL CLIENTE--------
# =====================================================
	Par_Cliente         INT,
	Par_TipoReporte     INT,

	Par_EmpresaID       INT(11),
	Aud_Usuario         INT(11),
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN
	/* DECLARACION DE VARIABLES*/
	DECLARE Var_NombreGrupo     VARCHAR(120);
	DECLARE Var_NumGrupo        INT;
	DECLARE Var_CargoGrupo      INT;
	DECLARE Var_DescripcionGru  VARCHAR(200);
	DECLARE Var_ContSolicitudes INT;
	DECLARE Var_ContCreditos	INT;
	DECLARE Var_ContCuentas  	INT;
	DECLARE Var_ContInversiones	INT;
	DECLARE Var_ContCedes		INT;
	DECLARE Var_ContAport		INT;

	/* DECLARACION DE CONSTANTES*/
	DECLARE CadenaVacia        	CHAR(1);
	DECLARE EnteroCero         	INT;
	DECLARE FechaVacia         	DATE;
	DECLARE Tipo_Header        	INT;
	DECLARE Tipo_Solicitudes   	INT;
	DECLARE Tipo_Creditos      	INT;
	DECLARE Tipo_Cuentas       	INT;
	DECLARE Tipo_Inversiones    INT;
	DECLARE Tipo_Persona		CHAR(1);
	DECLARE Persona_Moral		CHAR(1);
	DECLARE Persona_Fisica		CHAR(1);
	DECLARE Tipo_Cedes			INT;
	DECLARE Tipo_Aportaciones	INT;

	/*Constantes para cedes*/
	DECLARE Esta_Vigente        CHAR(1);
	DECLARE Vencimiento         CHAR(1);
	DECLARE FinMes              CHAR(1);
	DECLARE Periodo				CHAR(1);
	DECLARE DesVencimiento      VARCHAR(20);
	DECLARE DesFinMes           VARCHAR(20);
	DECLARE DesPeriodo			VARCHAR(20);

	/* ASIGNACION DE CONSTANTES */
	SET CadenaVacia             := '';
	SET EnteroCero              := 0;
	SET FechaVacia              := '1900-01-01';
	SET Tipo_Header             := 1;
	SET Tipo_Solicitudes        := 2;
	SET Tipo_Creditos           := 3;
	SET Tipo_Cuentas            := 4;
	SET Tipo_Inversiones        := 5;
	SET Tipo_Persona			:= "";
	SET Persona_Moral			:='M';
	SET Persona_Fisica			:='F';
	SET Tipo_Cedes				:= 6;
	SET Tipo_Aportaciones		:= 7;

	/*asignacion de constantes de cedes*/
	SET Esta_Vigente            := 'N';
	SET Vencimiento             := 'V';
	SET FinMes                  := 'F';
	SET Periodo					:= 'P';			-- Tipo de pago interes por periodo
	SET DesVencimiento          := 'VENCIMIENTO';
	SET DesFinMes               := 'FIN DE MES';
	SET DesPeriodo				:= 'PERIODO';	-- Descripcion por periodo


	IF (Par_TipoReporte = Tipo_Header) THEN

		SELECT Gru.GrupoID,  Gru.NombreGrupo, Inte.Cargo
		INTO   Var_NumGrupo, Var_NombreGrupo, Var_CargoGrupo
		FROM INTEGRAGRUPOSCRE Inte
		INNER JOIN GRUPOSCREDITO Gru ON Gru.GrupoID = Inte.GrupoID
		INNER JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
		INNER JOIN CREDITOS Cre ON Cre.CreditoID = Sol.CreditoID
		WHERE Inte.ClienteID = Par_Cliente
		  AND Sol.Estatus = 'D'
		  AND Cre.Estatus IN ('V', 'B', 'K')
		LIMIT 0,1;

		IF IFNULL(Var_CargoGrupo, EnteroCero) = EnteroCero THEN
			SET Var_DescripcionGru      := CadenaVacia;
		ELSE
			SET Var_DescripcionGru      := CONCAT(CASE WHEN Var_CargoGrupo = 1 THEN 'PRESIDENTE(A)'
													   WHEN Var_CargoGrupo = 2 THEN 'SECRETARIO(A)'
													   WHEN Var_CargoGrupo = 3 THEN 'TESORERO(A)'
													   WHEN Var_CargoGrupo = 4 THEN 'INTEGRANTE'
																				ELSE ''
													END, " DEL GRUPO ", CAST(Var_NumGrupo AS CHAR), " ", Var_NombreGrupo);
		END IF;



	 SELECT COUNT(*) INTO Var_ContSolicitudes FROM SOLICITUDCREDITO
	 WHERE 	ClienteID = Par_Cliente;


	 SELECT COUNT(*) INTO Var_ContCreditos 	FROM CREDITOS
	 WHERE	ClienteID =  Par_Cliente
	 AND Estatus IN ('A', 'V', 'B', 'K', 'P', 'C');


	 SELECT COUNT(*) INTO Var_ContCuentas		FROM CUENTASAHO
	 WHERE 	ClienteID = Par_Cliente
	 AND Estatus IN ('A', 'B', 'C', 'I', 'R');


	 SELECT COUNT(*) INTO Var_ContInversiones FROM INVERSIONES
	 WHERE 	ClienteID = Par_Cliente
	 AND Estatus IN ('A', 'N', 'P', 'C', 'V');

	  SELECT COUNT(*) INTO Var_ContCedes FROM CEDES
	 WHERE 	ClienteID = Par_Cliente AND Estatus IN ('N','P','C');

	 SET Var_ContAport := (SELECT COUNT(*) FROM APORTACIONES
	 WHERE ClienteID = Par_Cliente AND Estatus IN ('N','P','C'));

	 SELECT TipoPersona INTO Tipo_Persona FROM  CLIENTES
	 WHERE ClienteID =Par_Cliente;


		SELECT Cli.ClienteID,
			CASE Tipo_Persona WHEN Persona_Fisica THEN
				CONCAT(Cli.PrimerNombre, " ", IFNULL(Cli.SegundoNombre, CadenaVacia), CASE WHEN IFNULL(Cli.TercerNombre, CadenaVacia) = CadenaVacia THEN CadenaVacia ELSE CONCAT(" ", Cli.TercerNombre) END,
						CASE WHEN IFNULL(Cli.ApellidoPaterno, CadenaVacia) = CadenaVacia THEN CadenaVacia ELSE CONCAT(" ", Cli.ApellidoPaterno) END,
						CASE WHEN IFNULL(Cli.ApellidoMaterno, CadenaVacia) = CadenaVacia THEN CadenaVacia ELSE CONCAT(" ", Cli.ApellidoMaterno) END)
			ELSE CASE TipoPersona WHEN Persona_Moral THEN
				Cli.RazonSocial
			ELSE
				CONCAT(Cli.PrimerNombre, " ", IFNULL(Cli.SegundoNombre, CadenaVacia), CASE WHEN IFNULL(Cli.TercerNombre, CadenaVacia) = CadenaVacia THEN CadenaVacia ELSE CONCAT(" ", Cli.TercerNombre) END,
						CASE WHEN IFNULL(Cli.ApellidoPaterno, CadenaVacia) = CadenaVacia THEN CadenaVacia ELSE CONCAT(" ", Cli.ApellidoPaterno) END,
						CASE WHEN IFNULL(Cli.ApellidoMaterno, CadenaVacia) = CadenaVacia THEN CadenaVacia ELSE CONCAT(" ", Cli.ApellidoMaterno) END)
			END END  AS NombreCliente ,
			 IFNULL(Cli.FechaAlta, FechaVacia) AS FechaAlta,
			 CASE WHEN Cli.Estatus = 'A' THEN 'ACTIVO'
				  WHEN Cli.Estatus = 'C' THEN 'CANCELADO'
				  WHEN Cli.Estatus = 'B' THEN 'BLOQUEADO'
				  WHEN Cli.Estatus = 'I' THEN 'INACTIVO'
										 ELSE 'NA'
			  END AS EstatusCliente,
				Var_DescripcionGru  AS Grupo,
				Var_ContSolicitudes,
				Var_ContCreditos,
				Var_ContCuentas,
				Var_ContInversiones,
				Var_ContCedes,
				Var_ContAport
		FROM CLIENTES Cli
		WHERE Cli.ClienteID = Par_Cliente;
	END IF;


	IF Par_TipoReporte = Tipo_Solicitudes THEN
		SELECT Sol.SolicitudCreditoID, Sol.FechaRegistro, Sol.ProductoCreditoID,  Prod.Descripcion, upper(Pla.Descripcion) AS Plazo,
				CASE WHEN Sol.FrecuenciaInt ='S' THEN 'SEMANAL'
					 WHEN Sol.FrecuenciaInt ='C' THEN 'CATORCENAL'
					 WHEN Sol.FrecuenciaInt ='Q' THEN 'QUINCENAL'
					 WHEN Sol.FrecuenciaInt ='M' THEN 'MENSUAL'
					 WHEN Sol.FrecuenciaInt ='P' THEN 'PERIODOS'
					 WHEN Sol.FrecuenciaInt ='B' THEN 'BIMESTRAL'
					 WHEN Sol.FrecuenciaInt ='T' THEN 'TRIMESTRAL'
					 WHEN Sol.FrecuenciaInt ='R' THEN 'TETRAMESTRAL'
					 WHEN Sol.FrecuenciaInt ='E' THEN 'SEMESTRAL'
					 WHEN Sol.FrecuenciaInt ='A' THEN 'ANUAL'
					 ELSE 'NA'
				END AS Frecuencia,
				Sol.MontoSolici,
				Sol.MontoAutorizado,
				CASE WHEN Sol.Estatus = 'I' THEN 'INACTIVA'
					 WHEN Sol.Estatus = 'L' THEN 'LIBERADA'
					 WHEN Sol.Estatus = 'A' THEN 'AUTORIZADA'
					 WHEN Sol.Estatus = 'C' THEN 'CANCELADA'
					 WHEN Sol.Estatus = 'R' THEN 'RECHAZADA'
					 WHEN Sol.Estatus = 'D' THEN 'DESEMBOLSADA'
					 ELSE 'NA'
				END AS EstatusSol
		FROM SOLICITUDCREDITO Sol
		INNER JOIN PRODUCTOSCREDITO Prod ON Prod.ProducCreditoID = Sol.ProductoCreditoID
		INNER JOIN CREDITOSPLAZOS Pla ON Pla.PlazoID = Sol.PlazoID
		WHERE Sol.ClienteID = Par_Cliente;
	END IF;



	IF (Par_TipoReporte = Tipo_Creditos) THEN

		SELECT Cre.CreditoID, Cre.MontoCredito,  FUNCIONTOTDEUDACRE(Cre.CreditoID) AS SaldoCredito,
				Cre.FechaInicio, Cre.FechaVencimien, Cre.ProductoCreditoID,  Prod.Descripcion,
				UPPER(Pla.Descripcion) AS Plazo,
				CASE WHEN Cre.FrecuenciaInt ='S' THEN 'SEMANAL'
					 WHEN Cre.FrecuenciaInt ='C' THEN 'CATORCENAL'
					 WHEN Cre.FrecuenciaInt ='Q' THEN 'QUINCENAL'
					 WHEN Cre.FrecuenciaInt ='M' THEN 'MENSUAL'
					 WHEN Cre.FrecuenciaInt ='P' THEN 'PERIODOS'
					 WHEN Cre.FrecuenciaInt ='B' THEN 'BIMESTRAL'
					 WHEN Cre.FrecuenciaInt ='T' THEN 'TRIMESTRAL'
					 WHEN Cre.FrecuenciaInt ='R' THEN 'TETRAMESTRAL'
					 WHEN Cre.FrecuenciaInt ='E' THEN 'SEMESTRAL'
					 WHEN Cre.FrecuenciaInt ='A' THEN 'ANUAL'
												 ELSE 'NA'
				END AS Frecuencia,
				Cre.TasaFija,
				Cre.FactorMora,
				CASE WHEN Cre.Estatus = 'A' THEN 'AUTORIZADO'
					 WHEN Cre.Estatus = 'V' THEN 'VIGENTE'
					 WHEN Cre.Estatus = 'B' THEN 'VENCIDO'
					 WHEN Cre.Estatus = 'K' THEN 'QUEBRANTADO'
					 WHEN Cre.Estatus = 'P' THEN 'LIQUIDADO'
					 WHEN Cre.Estatus = 'C' THEN 'CANCELADO'
											ELSE 'NA'
				END AS EstatusCredito
		FROM CREDITOS Cre
		INNER JOIN PRODUCTOSCREDITO Prod ON Prod.ProducCreditoID = Cre.ProductoCreditoID
		INNER JOIN CREDITOSPLAZOS Pla ON Pla.PlazoID = Cre.PlazoID
		WHERE Cre.ClienteID =  Par_Cliente
		  AND Cre.Estatus IN ('A', 'V', 'B', 'K', 'P', 'C');
	END IF;



	IF (Par_TipoReporte = Tipo_Cuentas) THEN
		SELECT Cue.CuentaAhoID, Cue.Etiqueta, Cue.FechaApertura, Cue.Saldo, Cue.SaldoDispon, Cue.SaldoBloq, Cue.SaldoSBC,
				CASE WHEN Cue.Estatus = 'A' THEN 'ACTIVA'
					 WHEN Cue.Estatus = 'B' THEN 'BLOQUEADA'
					 WHEN Cue.Estatus = 'C' THEN 'CANCELADA'
					 WHEN Cue.Estatus = 'I' THEN 'INACTIVA'
					 WHEN Cue.Estatus = 'R' THEN 'REGISTRADA'
											ELSE 'NA'
				END AS EstatusCredito
		FROM CUENTASAHO Cue
		WHERE Cue.ClienteID = Par_Cliente
		  AND Cue.Estatus IN ('A', 'B', 'C', 'I', 'R');
	END IF;


	IF (Par_TipoReporte = Tipo_Inversiones) THEN
		SELECT Inv.InversionID,    Inv.TipoInversionID,   	Cat.Descripcion, 	Inv.FechaInicio,    Inv.FechaVencimiento,
				Inv.Monto,			Inv.Tasa,            	Inv.TasaISR,       	Inv.TasaNeta,       Inv.Plazo,
				Inv.InteresRecibir,	Inv.InteresRetener,
			   ((Inv.Monto + Inv.InteresRecibir)) AS SaldoNeto,
				CASE WHEN Inv.Estatus = 'A' THEN 'ALTA'
					 WHEN Inv.Estatus = 'N' THEN 'VIGENTE'
					 WHEN Inv.Estatus = 'P' THEN 'PAGADA'
					 WHEN Inv.Estatus = 'C' THEN 'CANCELADA'
					 WHEN Inv.Estatus = 'V' THEN 'VENCIDA'
											ELSE 'NA'
				END AS EstatusInversion
		FROM INVERSIONES Inv, CATINVERSION Cat
		WHERE Inv.ClienteID = Par_Cliente
		  AND Inv.Estatus IN ('A', 'N', 'P', 'C', 'V')
		  AND Inv.TipoInversionID = Cat.TipoInversionID;
	END IF;

	/*SECCION CEDES*/
	IF Par_TipoReporte = Tipo_Cedes THEN
		SELECT cede.CedeID, tipo.Descripcion AS TipoCedeID, cede.FechaInicio,  cede.FechaVencimiento, cede.TasaISR,
					cede.TasaNeta,   cede.InteresRecibir,  cede.InteresRetener,   cede.InteresGenerado,
					cede.Monto,
					CASE WHEN cede.TipoPagoInt = Vencimiento 	THEN DesVencimiento
						 WHEN cede.TipoPagoInt = FinMes      	THEN DesFinMes
						 WHEN cede.TipoPagoInt = Periodo		THEN DesPeriodo
						 END AS TipoPagoInt,
					CASE 	WHEN cede.Estatus = 'N' THEN 'VIGENTE'
							WHEN cede.Estatus = 'C' THEN 'CANCELADO'
							WHEN cede.Estatus = 'P' THEN 'PAGADO'
					END AS EstatusCedes
				FROM    CEDES cede
						INNER JOIN TIPOSCEDES tipo ON cede.TipoCedeID = tipo.TipoCedeID
				WHERE   cede.ClienteID  = Par_Cliente
				AND     cede.Estatus  IN ('N', 'C', 'P');
	END IF;

	/*SECCION APORTACIONES*/
	IF(Par_TipoReporte = Tipo_Aportaciones)THEN
		SELECT
			A.AportacionID,	T.Descripcion AS TipoAportID,	A.FechaInicio,		A.FechaVencimiento,	A.TasaISR,
			A.TasaNeta,		A.InteresRecibir,				A.InteresRetener,	A.InteresGenerado,	A.Monto,
			CASE A.TipoPagoInt
				WHEN Vencimiento	THEN DesVencimiento
				WHEN FinMes			THEN DesFinMes
				WHEN Periodo		THEN DesPeriodo
			END AS TipoPagoInt,
			CASE A.Estatus
				WHEN 'N' THEN 'VIGENTE'
				WHEN 'C' THEN 'CANCELADO'
				WHEN 'P' THEN 'PAGADO'
			END AS Estatus
		FROM APORTACIONES A
			INNER JOIN TIPOSAPORTACIONES T ON A.TipoAportacionID = T.TipoAportacionID
		WHERE A.ClienteID = Par_Cliente
			AND A.Estatus IN ('N', 'C', 'P');
	END IF;

END TerminaStore$$