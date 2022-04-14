-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REPCIRCULOCRE
DELIMITER ;
DROP PROCEDURE IF EXISTS `REPCIRCULOCRE`;

DELIMITER $$
CREATE PROCEDURE `REPCIRCULOCRE`(
	/* REPORTE DEL RESULTADO DE LA CONSULTA DE CIRCULO DE CREDITO */
	Par_FolioConsulta	INT(11),
	Par_TipoSeccion		INT(11),
	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE Rep_Encabezado		INT(11);
DECLARE Rep_Nombre			INT(11);
DECLARE Rep_Domicilios		INT(11);
DECLARE Rep_Empleos			INT(11);
DECLARE Rep_Cuentas			INT(11);
DECLARE Rep_Consultas	 	INT(11);
DECLARE Rep_Historico	 	INT(11);
DECLARE Rep_GraficaDeuda 	INT(11);
DECLARE Rep_GraficaCreAc 	INT(11);
DECLARE Rep_LogoReporte		INT(11);
DECLARE Rep_Score			INT(11);
DECLARE Rep_Mensajes		INT(11);
DECLARE Rep_PLDCheck		INT(11);
DECLARE Con_Oficial			CHAR(1);
DECLARE CadenaVacia			CHAR(1);
DECLARE Entero_Cero			INT(11);
DECLARE Decimal_Cero		DECIMAL(12,2);
DECLARE Fecha_Vacia			VARCHAR(30);
DECLARE LlaveLogo			VARCHAR(100);
DECLARE LlaveRutaFlechas	VARCHAR(100);
DECLARE FormatoConDiaSem	INT(11);
DECLARE FormatoCirculoCred	INT(11);
DECLARE TipoMensajeRepNeg	INT(11);
DECLARE TipoMensajeSIC		INT(11);
DECLARE TipoMensajePLD		INT(11);

-- Declaracion de Variables
DECLARE Var_NColonia		VARCHAR(400);
DECLARE Var_NLocalidad		VARCHAR(200);
DECLARE Var_NEstado			VARCHAR(200);
DECLARE Var_NSolicitud		VARCHAR(200);
DECLARE Var_RutaImagen		VARCHAR(200);
DECLARE Var_FechaSistema	DATE;
DECLARE VarMontoAprobado	DECIMAL(14,2);
DECLARE VarSaldoActual		DECIMAL(14,2);
DECLARE VarTotVigente		DECIMAL(14,2);
DECLARE VarTotAtraso		DECIMAL(14,2);
DECLARE VarTotalCreditos	DECIMAL(14,2);
DECLARE VarCreditosA		INT(11);
DECLARE VarFecMasAnt		VARCHAR(30);
DECLARE VarCreditoMax		DECIMAL(14,2);
DECLARE Var_Valor			INT(11);
DECLARE Var_NombreFlecha	VARCHAR(20);
DECLARE Var_Razon1			VARCHAR(210);
DECLARE Var_Razon2			VARCHAR(210);
DECLARE Var_Razon3			VARCHAR(210);
DECLARE Var_Razon4			VARCHAR(210);
DECLARE Var_TipoMensaje		VARCHAR(5);
DECLARE Var_Leyenda			VARCHAR(200);
DECLARE Var_FolioConsultaCC	VARCHAR(45);
DECLARE ST_Atraso			VARCHAR(15);
DECLARE ST_Bloqueado		VARCHAR(15);
DECLARE ST_Vigente			VARCHAR(15);


-- Asignacion de Variables
SET	CadenaVacia			:= '';
SET	Entero_Cero			:= 0;
SET	Decimal_Cero		:= 0.0;
SET	Fecha_Vacia			:= '0000-00-00'; /*NO CAMBIAR */
SET	Rep_Encabezado		:= 1;
SET	Rep_Nombre			:= 2;
SET	Rep_Domicilios 		:= 3;
SET	Rep_Empleos 		:= 4;
SET	Rep_Cuentas 		:= 5;
SET	Rep_Consultas 		:= 6;
SET	Rep_Historico	 	:= 7;
SET	Rep_GraficaDeuda	:= 8;
SET	Rep_GraficaCreAc	:= 9;
SET	Rep_LogoReporte		:= 10;
SET	Rep_Score			:= 11;
SET	Rep_Mensajes		:= 12;
SET	Rep_PLDCheck		:= 13;
SET	LlaveLogo			:= 'logoCirculoCredito';
SET	LlaveRutaFlechas	:= 'RutaImagenFechaCC';
SET	Con_Oficial			:= 'S';
SET	FormatoConDiaSem	:= 1;
SET	FormatoCirculoCred	:= 5;
SET	TipoMensajeRepNeg	:= 1;
SET	TipoMensajeSIC		:= 2;
SET	TipoMensajePLD		:= 3;
SET	ST_Atraso			:= 'atraso.png';
SET	ST_Bloqueado		:= 'bloqueado.png';
SET	ST_Vigente			:= 'vigente.png';


/* consulta para la seccion de encabezado */
IF(Par_TipoSeccion = Rep_Encabezado)THEN
	SELECT	CONCAT(ApellidoPaterno," ",ApellidoMaterno," ",PrimerNombre," ",SegundoNombre," ",TercerNombre) AS Nombre,
			CONCAT("NÚMERO INTERIOR ",IFNULL(NumeroInterior,CadenaVacia),", NÚMERO EXTERIOR ", IFNULL(NumeroExterior,CadenaVacia) , ", PISO ", IFNULL(Piso,CadenaVacia)  , ", COLONIA", IFNULL(Colonia,CadenaVacia) ) AS Direccion,
			mun.Nombre AS Municipio,
			edo.Nombre AS Estado,
			sol.CP AS CP,
			sol.FechaConsulta AS Fecha
		FROM	SOLBUROCREDITO	sol,
				MUNICIPIOSREPUB	mun,
				ESTADOSREPUB	edo
		WHERE CONVERT( FolioConsultaC , UNSIGNED) = Par_FolioConsulta
		 AND		sol.MunicipioID 	= mun.MunicipioID
		 AND		sol.EstadoID		= edo.EstadoID
		 AND		mun.EstadoID		= edo.EstadoID;
END IF;

IF(Par_TipoSeccion = Rep_Nombre )THEN
	SELECT	fk_SolicitudID,		ApePaterno,		ApeMaterno,		ApeAdicional,	Nombres,
			FNFECHACOMPLETA(FechaNacimiento,FormatoCirculoCred) AS FechaNacimiento,
            RFC,				Nacionalidad,	Residencia,		EstadoCivil,	Sexo,
            ClaveIFE,			NumDependiente,	FechaDefuncion,	CURP
		FROM CIRCULOCRENOMB
		WHERE fk_SolicitudID = Par_FolioConsulta;
END IF;

IF(Par_TipoSeccion = Rep_Domicilios)THEN
	SELECT fk_SolicitudID,	Consecutivo,	Direccion,	ColPoblacion,	DelMunicipio,
			FNFECHACOMPLETA(FechaResidencia,FormatoCirculoCred) AS FechaResidencia,
            Ciudad,			Estado,			CP,			NumTelefono,	TipoDomicilio
	FROM CIRCULOCREDOM WHERE fk_SolicitudID = Par_FolioConsulta;
END IF;

IF(Par_TipoSeccion = Rep_Empleos)THEN
	SELECT fk_SolicitudID,	Consecutivo,	IFNULL(NombreEmpresa,CadenaVacia)NombreEmpresa,	Direccion,		ColPoblacion,
		DelMunicipio,		Ciudad,			Estado,				CP,							NumTelefono,
		Extension,			Fax,			Puesto,				FecContratacion,			ClaveMoneda,
        SalarioMensual, 	FNFECHACOMPLETA(FecContratacion,FormatoCirculoCred) AS FecContratacion,
        FNFECHACOMPLETA(FecUltEmpleo,FormatoCirculoCred) AS FecUltEmpleo,
        FNFECHACOMPLETA(FechaVerEmpleo,FormatoCirculoCred) AS FechaVerEmpleo
	FROM CIRCULOCREEMPLE WHERE fk_SolicitudID = Par_FolioConsulta;
END IF;

/* COnsulra para seccion Cuentas */
IF ( Par_TipoSeccion = Rep_Cuentas ) THEN
	SET VarCreditosA	:= (SELECT	COUNT(*)
							FROM	CIRCULOCRECUENT cu
								WHERE	cu.fk_SolicitudID	= Par_FolioConsulta
								AND 	YEAR(FecApeCuenta) = YEAR(NOW()));

	SET VarCreditosA	:= IFNULL(VarCreditosA,Entero_Cero );

	SET VarFecMasAnt	:= (SELECT	MIN(FecApeCuenta)
								FROM	CIRCULOCRECUENT cu
									WHERE	cu.fk_SolicitudID	= Par_FolioConsulta
								GROUP BY cu.fk_SolicitudID);
	SET VarFecMasAnt	:= IFNULL(VarFecMasAnt,Fecha_Vacia );


	SET VarCreditoMax	:= (SELECT	MAX(CreditoMaximo)
								FROM	CIRCULOCRECUENT cu
									WHERE	cu.fk_SolicitudID	= Par_FolioConsulta
								GROUP BY cu.fk_SolicitudID);
	SET VarCreditoMax	:= IFNULL(VarCreditoMax,Entero_Cero );

	SELECT IFNULL(ValorParametro,CadenaVacia) INTO Var_RutaImagen
	FROM PARAMGENERALES
	WHERE LlaveParametro = LlaveRutaFlechas;

	SELECT	FecActualizacion,	RegImpugnado,		ClaveOtorgante,		FNSALTOLINEA(NomOtorgante,7) AS NomOtorgante,		CuentaActual,
			ClveUniMon,			ValActValuacion,	NumeroPagos, 		FrecuenciaPagos,

			CASE TipRespons
				WHEN 'I' THEN 'INDIVIDUAL'
				WHEN 'M' THEN 'MANCOMUNADO'
				WHEN 'O' THEN 'OBLIGADO SOLIDARIO'
				WHEN 'A' THEN 'AVAL'
				WHEN 'T' THEN 'TITULAR CON AVAL'
                ELSE CadenaVacia
			END AS TipRespons,
			CASE TipoCredito
				WHEN 'AA' THEN 'ARRENDAMIENTO AUTOMOTRIZ'		WHEN 'AB' THEN 'AUTOMOTRIZ BANCARIO'			WHEN 'AE' THEN 'FISICA ACTIVIDAD EMPRESARIAL'
				WHEN 'AM' THEN 'APARATOS/MUEBLES'				WHEN 'AR' THEN 'ARRENDAMIENTO'					WHEN 'AV' THEN 'AVIACIÓN'
				WHEN 'BC' THEN 'BANCA COMUNAL'					WHEN 'BL' THEN 'BOTE/LANCHA'					WHEN 'BR' THEN 'BIENES RAÍCES'

				WHEN 'CA' THEN 'COMPRA DE AUTOMOVIL'			WHEN 'CC' THEN 'CRÉDITO AL CONSUMO'				WHEN 'CF' THEN 'CRÉDITO FISCAL'
				WHEN 'CO' THEN 'CONSOLIDACIÓN'					WHEN 'CP' THEN 'CRÉDITO PERSONAL AL CONSUMO'	WHEN 'ED' THEN 'EDITORIAL'
				WHEN 'EQ' THEN 'EQUIPO'							WHEN 'FF' THEN 'FONDEO FIRA'					WHEN 'FI' THEN 'FIANZA'

				WHEN 'FT' THEN 'FACTORAJE'						WHEN 'GS' THEN 'GRUPO SOLIDARIO'				WHEN 'OT' THEN 'OTROS'
				WHEN 'HB' THEN 'HIPOTECARIO BANCARIO'			WHEN 'HE' THEN 'PRÉSTAMO TIPO HOME EQUITY'		WHEN 'HV' THEN 'HIPOTECARIO O VIVIENDA'
				WHEN 'LC' THEN 'LINEA DE CRÉDITO'				WHEN 'MC' THEN 'MEJORAS A LA CASA'				WHEN 'NG' THEN 'PRÉSTAMO NO GARANTIZADO'

				WHEN 'PB' THEN 'PRÉSTAMO PERSONAL BANCARIO'		WHEN 'PC' THEN 'PROCAMPO'						WHEN 'PE' THEN 'PRÉSTAMO PARA ESTUDIANTE'
				WHEN 'PG' THEN 'PRÉSTAMO GARANTIZADO'			WHEN 'PQ' THEN 'PRÉSTAMO QUIROGRAFARIO'			WHEN 'PM' THEN 'PRÉSTAMO EMPRESARIAL'
				WHEN 'PN' THEN 'PRÉSTAMO DE NÓMINA'				WHEN 'PP' THEN 'PRÉSTAMO PERSONAL'				WHEN 'SH' THEN 'SEGUNDA HIPOTECA'

				WHEN 'TC' THEN 'TARJETA DE CRÉDITO'				WHEN 'TD' THEN 'TARJETA DEPARTAMENTAL'			WHEN 'TG' THEN 'TARJETA GARANTIZADA'
				WHEN 'TS' THEN 'TARJETA DE SERVICIOS'			WHEN 'VR' THEN 'VEHÍCULO RECREATIVO'			WHEN 'NC' THEN 'DESCONOCIDO'
                ELSE CadenaVacia
			END AS TipoCredito,
			CASE TipoCuenta
				WHEN 'F' THEN 'PAGOS FIJOS'
				WHEN 'H' THEN 'HIPOTECA'
				WHEN 'L' THEN 'SIN LÍMITE PREESTABLECIDO'
				WHEN 'R' THEN 'REVOLVENTE'
				WHEN 'Q' THEN 'QUIROGRAFARIO'
				WHEN 'A' THEN 'CRÉDITO DE HABILITACIÓN O AVÍO'
				WHEN 'E' THEN 'CRÉDITO REFACCIONARIO'
				WHEN 'P' THEN 'CRÉDITO PRENDARIO'
                ELSE CadenaVacia
			END AS TipoCuenta,
			CASE IFNULL(FecApeCuenta,'1900-01-01')
				WHEN '1900-01-01' THEN Fecha_Vacia
				ELSE FNFECHACOMPLETA(FecApeCuenta,FormatoCirculoCred)
                END AS FecApeCuenta,

			CASE IFNULL(FecUltPago,'1900-01-01')
				WHEN '1900-01-01' THEN Fecha_Vacia
				ELSE FNFECHACOMPLETA(FecUltPago,FormatoCirculoCred)
                END AS FecUltPago,

			CASE IFNULL(FecUltCompra,'1900-01-01')
				WHEN '1900-01-01' THEN Fecha_Vacia
				ELSE FNFECHACOMPLETA(FecUltCompra,FormatoCirculoCred)
                END AS FecUltCompra,

			CASE IFNULL(FecCieCuenta,'1900-01-01')
				WHEN '1900-01-01' THEN Fecha_Vacia
				ELSE FNFECHACOMPLETA(FecCieCuenta,FormatoCirculoCred)
                END AS FecCieCuenta,

			CASE IFNULL(FecRespote,'1900-01-01')
				WHEN '1900-01-01' THEN Fecha_Vacia
				ELSE FNFECHACOMPLETA(FecRespote,FormatoCirculoCred)
                END AS FecRespote,

			CASE IFNULL(UltFecSalCero,'1900-01-01')
				WHEN '1900-01-01' THEN Fecha_Vacia
				ELSE FNFECHACOMPLETA(UltFecSalCero,FormatoCirculoCred)
                END AS UltFecSalCero,

			Garantia,
			FORMAT(CreditoMaximo,0)	AS CreditoMaximo,
			FORMAT(MontoPagar,0)	AS MontoPagar,
			FORMAT(SaldoActual,0)	AS SaldoActual,
			FORMAT(LimiteCredito,0)	AS LimiteCredito,
			FORMAT(SaldoVencido,0)	AS SaldoVencido,
			IFNULL(cu.PeorAtraso, 0) as NumPagVencidos,
			Cuenta,				MOP0,				MOP1,				MOP2,			MOP3,
			MOP4,				ClavePreven,		TotalPagosRep,		FecAntHisPagos,
            FNSALTOLINEA(FNFMTHISPAGCIR(IFNULL(HistoricoPagos, CadenaVacia),12),18) AS HistoricoPagos,
			FORMAT(PagoActual,0) AS PagoActual,		PeorAtraso,

			CASE IFNULL(FechaPeorAtraso,'1900-01-01')
				WHEN '1900-01-01' THEN Fecha_Vacia
				ELSE FNFECHACOMPLETA(FechaPeorAtraso,FormatoCirculoCred)
                END AS FechaPeorAtraso,

			IFNULL(SalVenPeorAtraso,0) AS SalVenPeorAtraso,	VarCreditosA AS CreAbiertosAnio,
			CASE MONTH(IF(IFNULL(VarFecMasAnt,'1900-01-01')='1900-01-01',Fecha_Vacia,VarFecMasAnt))
				WHEN 0 THEN Fecha_Vacia
				ELSE FNFECHACOMPLETA(VarFecMasAnt,FormatoCirculoCred)
			END AS FecMasAnt,
			VarCreditoMax AS CreditoMax,UPPER(IFNULL(cl.Descripcion,cu.ClavePreven)) AS Situacion,
               -- Calculo Estatus
               CONCAT(Var_RutaImagen, IF(cu.FecCieCuenta <> '1900-01-01', ST_Bloqueado,IF(cu.SaldoVencido > Decimal_Cero,ST_Atraso, ST_Vigente))) AS CuentaStatus
		FROM	CIRCULOCRECUENT cu
			LEFT OUTER JOIN CATCLAVESOBS cl ON cu.ClavePreven = cl.Clave
			LEFT JOIN CIRCULOCREMPAGO mo ON cu.fk_SolicitudID	= mo.fk_SolicitudID
				AND		cu.Consecutivo		= mo.Consecutivo
            WHERE cu.fk_SolicitudID	= Par_FolioConsulta
            ORDER BY cu.Consecutivo ASC;
END IF;

IF(Par_TipoSeccion = Rep_Consultas)THEN
	SELECT fk_SolicitudID,	Consecutivo,	ClaveOtorgante,		NomOtorgante,		TelOtorgante,
			ClaveUniMon,	FORMAT(ImporteCredito,2)AS ImporteCredito,				TipRespons,
			FNFECHACOMPLETA(FecConsulta,FormatoCirculoCred) AS FecConsulta,
            CASE TipoCredito
				WHEN 'F' THEN 'PAGOS FIJOS'
				WHEN 'H' THEN 'HIPOTECA'
				WHEN 'L' THEN 'SIN LÍMITE PREESTABLECIDO'
				WHEN 'R' THEN 'REVOLVENTE'
				WHEN 'Q' THEN 'QUIROGRAFARIO'
				WHEN 'A' THEN 'CRÉDITO DE HABILITACIÓN O AVÍO'
				WHEN 'E' THEN 'CRÉDITO REFACCIONARIO'
				WHEN 'P' THEN 'CRÉDITO PRENDARIO'
                ELSE CadenaVacia
			END AS TipoCredito
		FROM CIRCULOCRECONS
			WHERE fk_SolicitudID = Par_FolioConsulta;
END IF;

IF ( Par_TipoSeccion = Rep_Historico ) THEN
	SELECT * FROM CIRCULOCREMPAGO WHERE fk_SolicitudID = Par_FolioConsulta AND Consecutivo = Par_FolioConsulta;
END IF;

/*Seccion para la grafica de Analisis de Deuda */
IF ( Par_TipoSeccion = Rep_GraficaDeuda ) THEN

	SELECT	SUM(SaldoActual),	SUM(CreditoMaximo)
	 INTO	VarSaldoActual,		VarMontoAprobado
		FROM	CIRCULOCRECUENT cu,
				CIRCULOCREMPAGO mo
			WHERE	cu.fk_SolicitudID	= mo.fk_SolicitudID
			AND		cu.Consecutivo		= mo.Consecutivo
			AND		cu.fk_SolicitudID	= Par_FolioConsulta;

	SET VarSaldoActual := TRUNCATE((VarSaldoActual/VarMontoAprobado*100),0);
	SET VarMontoAprobado := 100 - VarSaldoActual;

	(SELECT	VarSaldoActual AS Valor, 	'Saldo Actual' AS Descripcion)
	UNION ALL
	(SELECT	VarMontoAprobado AS Valor,	'Monto Aprobado'AS Descripcion);
END IF;

/*Seccion para la grafica de Creditos Activos*/
IF ( Par_TipoSeccion = Rep_GraficaCreAc ) THEN
	SELECT	SUM(CASE WHEN SaldoVencido = Entero_Cero THEN 1 ELSE Entero_Cero END),
			SUM(CASE WHEN SaldoVencido > Entero_Cero THEN 1 ELSE Entero_Cero END),
			COUNT(*)
	INTO	VarTotVigente,				VarTotAtraso,
			VarTotalCreditos
		FROM	CIRCULOCRECUENT cu
			WHERE	cu.fk_SolicitudID	= Par_FolioConsulta
            AND 	(
            			cu.FecCieCuenta = '1900-01-01'
            			OR
            			cu.SaldoVencido > Entero_Cero
            		);

	IF VarTotalCreditos > Entero_Cero THEN
		SET  VarTotVigente  := TRUNCATE((VarTotVigente/VarTotalCreditos*100),0);
		SET  VarTotAtraso 	:= 100 - VarTotVigente;
	ELSE
		SET  VarTotAtraso := Entero_Cero;
		SET  VarTotVigente := Entero_Cero;
    END IF;

	(SELECT	VarTotVigente AS Valor, 	'Total Vigente' AS Descripcion)
	UNION ALL
	(SELECT	VarTotAtraso AS Valor,		'Total en Atraso'AS Descripcion);
END IF;

-- Seccion para mostrar el logo en el reporte de circulo de credito
IF(Par_TipoSeccion = Rep_LogoReporte)THEN
	SELECT IFNULL(ValorParametro,CadenaVacia) INTO Var_RutaImagen
		FROM PARAMGENERALES
		WHERE LlaveParametro = LlaveLogo;

	SELECT FechaConsulta INTO Var_FechaSistema
		FROM SOLBUROCREDITO
		WHERE FolioConsultaC = Par_FolioConsulta;

	SET Var_FolioConsultaCC := (SELECT FolioConsulta
									FROM CIRCULOCRESOL
											  WHERE SolicitudID = Par_FolioConsulta);
	SET Var_FolioConsultaCC := IFNULL(Var_FolioConsultaCC,CadenaVacia);

	SET Var_Razon1 := (SELECT CONCAT(RS.Codigo, ' - ', RS.Descripcion)
							FROM CIRCULOCRESCORE CS INNER JOIN CATRAZONESSCORECC RS ON (RS.Codigo = Razon1)
								WHERE fk_SolicitudID = Par_FolioConsulta);
	SET Var_Razon1 := IFNULL(Var_Razon1,CadenaVacia);

	SET Var_Razon2 := (SELECT CONCAT(RS.Codigo, ' - ', RS.Descripcion)
							FROM CIRCULOCRESCORE CS INNER JOIN CATRAZONESSCORECC RS ON (RS.Codigo = Razon2)
								WHERE fk_SolicitudID = Par_FolioConsulta);
	SET Var_Razon2 := IFNULL(Var_Razon2,CadenaVacia);

	SET Var_Razon3 := (SELECT CONCAT(RS.Codigo, ' - ', RS.Descripcion)
							FROM CIRCULOCRESCORE CS INNER JOIN CATRAZONESSCORECC RS ON (RS.Codigo = Razon3)
								WHERE fk_SolicitudID = Par_FolioConsulta);
	SET Var_Razon3 := IFNULL(Var_Razon3,CadenaVacia);

	SET Var_Razon4 := (SELECT CONCAT(RS.Codigo, ' - ', RS.Descripcion)
							FROM CIRCULOCRESCORE CS INNER JOIN CATRAZONESSCORECC RS ON (RS.Codigo = Razon4)
								WHERE fk_SolicitudID = Par_FolioConsulta);
	SET Var_Razon4 := IFNULL(Var_Razon4,CadenaVacia);

	SELECT Var_RutaImagen AS RutaImagen, FNFECHACOMPLETA(Var_FechaSistema,FormatoConDiaSem) AS FechaSistema,
			Var_Razon1 AS Razon1,	Var_Razon2 AS Razon2,	Var_Razon3 AS Razon3,	Var_Razon4 AS Razon4, Var_FolioConsultaCC;
END IF;

-- Seccion SCORE del reporte de circulo de credito
IF(Par_TipoSeccion = Rep_Score)THEN
	-- Se obtiene el valor del Score
	SET Var_Valor := (SELECT Valor
						FROM CIRCULOCRESCORE
							WHERE fk_SolicitudID = Par_FolioConsulta);

	SET Var_Valor := IFNULL(Var_Valor,Entero_Cero);

    -- Se obtiene la ruta de las imagenes de las flechas
	SELECT IFNULL(ValorParametro,CadenaVacia) INTO Var_RutaImagen
		FROM PARAMGENERALES
		WHERE LlaveParametro = LlaveRutaFlechas;

    -- Se calcula que flecha corresponde de acuerdo al score
    SET Var_NombreFlecha :=
		CASE
			WHEN Var_Valor BETWEEN 0 AND 310 THEN 'Flecha300.png'

			WHEN Var_Valor BETWEEN 311 AND 330 THEN 'Flecha320.png'

			WHEN Var_Valor BETWEEN 331 AND 350 THEN 'Flecha340.png'

			WHEN Var_Valor BETWEEN 351 AND 370 THEN 'Flecha360.png'

			WHEN Var_Valor BETWEEN 371 AND 390 THEN 'Flecha380.png'

			WHEN Var_Valor BETWEEN 391 AND 410 THEN 'Flecha400.png'

			WHEN Var_Valor BETWEEN 411 AND 430 THEN 'Flecha420.png'

			WHEN Var_Valor BETWEEN 431 AND 450 THEN 'Flecha440.png'

			WHEN Var_Valor BETWEEN 451 AND 470 THEN 'Flecha460.png'

			WHEN Var_Valor BETWEEN 471 AND 490 THEN 'Flecha480.png'

			WHEN Var_Valor BETWEEN 491 AND 510 THEN 'Flecha500.png'

			WHEN Var_Valor BETWEEN 511 AND 530 THEN 'Flecha520.png'

			WHEN Var_Valor BETWEEN 531 AND 550 THEN 'Flecha540.png'

			WHEN Var_Valor BETWEEN 551 AND 570 THEN 'Flecha560.png'

			WHEN Var_Valor BETWEEN 571 AND 590 THEN 'Flecha580.png'

			WHEN Var_Valor BETWEEN 591 AND 610 THEN 'Flecha600.png'

			WHEN Var_Valor BETWEEN 611 AND 630 THEN 'Flecha620.png'

			WHEN Var_Valor BETWEEN 631 AND 650 THEN 'Flecha640.png'

			WHEN Var_Valor BETWEEN 651 AND 670 THEN 'Flecha660.png'

			WHEN Var_Valor BETWEEN 671 AND 690 THEN 'Flecha680.png'

			WHEN Var_Valor BETWEEN 691 AND 710 THEN 'Flecha700.png'

			WHEN Var_Valor BETWEEN 711 AND 730 THEN 'Flecha720.png'

			WHEN Var_Valor BETWEEN 731 AND 750 THEN 'Flecha740.png'

			WHEN Var_Valor BETWEEN 751 AND 770 THEN 'Flecha760.png'

			WHEN Var_Valor BETWEEN 771 AND 790 THEN 'Flecha780.png'

			WHEN Var_Valor BETWEEN 791 AND 810 THEN 'Flecha800.png'

			WHEN Var_Valor BETWEEN 811 AND 830 THEN 'Flecha820.png'

			WHEN Var_Valor BETWEEN 831 AND 850 THEN 'Flecha840.png'

			WHEN Var_Valor > 850 THEN 'Flecha860.png'
		END;

	SELECT CONCAT('<html><body><span style=\'font-family: Arial; font-size: 18pt; word-spacing: 0px;\'><b>',
				NombreScore,'<sup style=\'font-family: Arial; font-size: 12pt;\'>&reg;</sup>&nbsp;&nbsp;Score </b>&nbsp;&nbsp;&nbsp;',Valor,
                '</span></body></html>')AS TituloScore, Valor,
		CONCAT('Razones de Score: ',
				IF(LENGTH(TRIM(IFNULL(Razon1, CadenaVacia)))>Entero_Cero, TRIM(IFNULL(Razon1, CadenaVacia)), CadenaVacia),
				IF(LENGTH(TRIM(IFNULL(Razon2, CadenaVacia)))>Entero_Cero, CONCAT(', ', TRIM(IFNULL(Razon2, CadenaVacia))), CadenaVacia),
				IF(LENGTH(TRIM(IFNULL(Razon3, CadenaVacia)))>Entero_Cero, CONCAT(', ', TRIM(IFNULL(Razon3, CadenaVacia))), CadenaVacia),
				IF(LENGTH(TRIM(IFNULL(Razon4, CadenaVacia)))>Entero_Cero, CONCAT(', ', TRIM(IFNULL(Razon4, CadenaVacia))), CadenaVacia)) AS RazonesScore,
		CONCAT(Var_RutaImagen,Var_NombreFlecha) AS ValorScore
		FROM CIRCULOCRESCORE
			WHERE fk_SolicitudID = Par_FolioConsulta;
END IF;

-- Seccion para mostrar informacion en la seccion de Mensajes
IF(Par_TipoSeccion = Rep_Mensajes)THEN
/* El campo TipoMensaje si no es 3, indica que es para Mensajes. */
	SELECT	TipoMensaje,		Leyenda
    INTO	Var_TipoMensaje, 	Var_Leyenda
		FROM CIRCULOCREMEN
		WHERE fk_SolicitudID = Par_FolioConsulta
			AND TipoMensaje != TipoMensajePLD
            LIMIT 1;

	SET Var_Leyenda := (
		CASE Var_TipoMensaje
			WHEN TipoMensajeRepNeg THEN 'Reporte Negativo.'
			WHEN TipoMensajeSIC THEN
				(SELECT Descripcion FROM CATRESPUESTASSIC WHERE Codigo = Var_Leyenda)
        END);

	SELECT IFNULL(Var_Leyenda,'No hay mensajes...') AS Leyenda;
END IF;

-- Seccion para mostrar informacion en la seccion de PLD Check
IF(Par_TipoSeccion = Rep_PLDCheck)THEN
-- El campo TipoMensaje si es 3, indica que es para PLD Check.
	SELECT	Consecutivo, Leyenda
		FROM CIRCULOCREMEN
		WHERE fk_SolicitudID = Par_FolioConsulta
			AND TipoMensaje = TipoMensajePLD;
END IF;

END TerminaStore$$