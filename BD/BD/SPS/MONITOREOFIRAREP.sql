
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONITOREOFIRAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONITOREOFIRAREP`;
DELIMITER $$


CREATE PROCEDURE `MONITOREOFIRAREP`(
/* GENERACIÓN DE LOS REPORTES (ARCHIVOS) DE MONITOREO CARTERA AGRO (FIRA) */
	Par_TipoReporteID			INT(11),		-- ID DEL TIPO DE REPORTE.
	Par_FechaReporte			DATE,			-- FECHA EN LA QUE SE GENERA EL REPORTE.
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

-- Declaracion de Variables
DECLARE	Var_FechaReporte		DATE;
DECLARE	TipoConsulta			CHAR(1);			-- Tipo de Consulta para el Calculo Contable D: Por Fecha, P: Por Periodo F: Fin de Periodo
DECLARE Var_ExtReg				INT(11);			-- Contador de Registros

-- Declaracion de Constantes
DECLARE	Cadena_Vacia			VARCHAR(1);
DECLARE	Fecha_Vacia				DATE;
DECLARE	Entero_Cero				INT(11);
DECLARE	SalidaSI				CHAR(1);
DECLARE	SalidaNO				CHAR(1);
DECLARE	Par_NumErr				INT(11);
DECLARE	Par_ErrMen				VARCHAR(400);
DECLARE	ReporteBalanza			INT(11);
DECLARE	ReporteEdoResultados	INT(11);
DECLARE	ReportePasivos			INT(11);
DECLARE	ReporteCastigos			INT(11);
DECLARE	ReporteCarteraFIRA		INT(11);
DECLARE	ReporteCarteraNoFIRA	INT(11);
DECLARE	ReporteCreditosRel		INT(11);
DECLARE	ReporteExcedentes		INT(11);
DECLARE	ReporteRiesgoCred		INT(11);
DECLARE ReporteRiesgoMerc		INT(11);
DECLARE ReporteCapitalNeto		INT(11);
DECLARE ReporteProyeccion		INT(11);
DECLARE	EjercicioDef			INT(11);
DECLARE	PeriodoDef				INT(11);
DECLARE	TipoConsulta_PorFecha	CHAR(1);
DECLARE	Cifras_Pesos			CHAR(1);
DECLARE	CCINICIAL_DEF			INT(11);
DECLARE	CCFINAL_DEF				INT(11);
DECLARE	TipoConsulta_PorPeriodo	CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia			:= '';				-- Cadena vacia
SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero				:= 0;				-- Entero Cero
SET	SalidaSI				:= 'S';				-- Salida Si
SET	SalidaNO				:= 'N'; 			-- Salida No
SET	ReporteBalanza			:= 1; 				-- Tipo de Reporte Balanza Corresponde a CATREPORTESFIRA.
SET	ReporteEdoResultados	:= 2; 				-- Tipo de Reporte Edo Resultados Corresponde a CATREPORTESFIRA.
SET	ReportePasivos			:= 3; 				-- Tipo de Reporte Pasivos de Fondeo Corresponde a CATREPORTESFIRA.
SET	ReporteCastigos			:= 4; 				-- Tipo de Reporte Castigos Corresponde a CATREPORTESFIRA.
SET	ReporteCarteraFIRA		:= 5; 				-- Tipo de Reporte Cartera FIRA Corresponde a CATREPORTESFIRA.
SET	ReporteCarteraNoFIRA	:= 6; 				-- Tipo de Reporte Cartera No FIRA Corresponde a CATREPORTESFIRA.
SET	ReporteCreditosRel		:= 7; 				-- Tipo de Reporte Creditos Relacionados Corresponde a CATREPORTESFIRA.
SET	ReporteExcedentes		:= 8; 				-- Tipo de Reporte Excedentes de Riesgo Corresponde a CATREPORTESFIRA.
SET	ReporteRiesgoCred		:= 9; 				-- Tipo de Reporte Riesgo Creditos Corresponde a CATREPORTESFIRA.
SET ReporteRiesgoMerc		:= 10;				-- Tipo de Reporte de Riesgo de MERCADO Corresponde a CATREPORTESFIRA.
SET ReporteCapitalNeto		:= 11;				-- Tipo de Reporte de Capital Neto Corresponde a CATREPORTESFIRA.
SET ReporteProyeccion		:= 12;				-- Tipo de Reporte de Proyeccion de Indicadores Corresponde a CATREPORTESFIRA.
SET EjercicioDef			:= 0;				-- Constante default para Numero de Ejercicio.
SET PeriodoDef				:= 0;				-- Constante default para Periodo.
SET TipoConsulta_PorFecha	:= 'D';				-- Constante default para Tipo de consulta default por Fecha.
SET Cifras_Pesos			:= 'P';				-- Constante default para Muestra las cifras en pesos.
SET CCINICIAL_DEF			:= 0;				-- Constante default para Centro de costos inicial.
SET CCFINAL_DEF				:= 0;				-- Constante default para Centro de costos final.
SET TipoConsulta_PorPeriodo	:= 'P';				-- Constante default para Tipo de consulta default por Fecha.

ManejoReporte: BEGIN

-- EL PRIER DÍA DEL MES ANTERIOR.
SET Var_FechaReporte	:= DATE_FORMAT(Par_FechaReporte,'%Y-%m-01');

SET Aud_FechaActual		:=NOW();

-- SE ELIMINAN LOS DATOS DE LA GENERACIÓN DEL REPORTE ANTERIOR.
DELETE FROM REPMONITOREOFIRA
	  WHERE TipoReporteID = Par_TipoReporteID
		AND FechaGeneracion = Var_FechaReporte;


	SELECT COUNT(*)
		INTO Var_ExtReg
	FROM SALDOSCONTABLES
	WHERE FechaCorte = Par_FechaReporte;

	SET Var_ExtReg := IFNULL(Var_ExtReg, Entero_Cero);

	IF(Var_ExtReg > Entero_Cero)THEN
		SET TipoConsulta := TipoConsulta_PorPeriodo;
	ELSE
		SET TipoConsulta := TipoConsulta_PorFecha;
	END IF;


IF(Par_TipoReporteID = ReporteBalanza)THEN
	CALL BALGENERALFIRAREP(
		EjercicioDef,		PeriodoDef,			Var_FechaReporte,	TipoConsulta,				Cadena_Vacia,
		Cifras_Pesos,		CCINICIAL_DEF,		CCFINAL_DEF,		SalidaNO,					Par_NumErr,
		Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,			Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
	LEAVE ManejoReporte;
END IF;

IF(Par_TipoReporteID = ReporteEdoResultados)THEN
	CALL EDORESINTERNOFIRAREP(
		EjercicioDef,		PeriodoDef,			Var_FechaReporte,	TipoConsulta,				Cadena_Vacia,
		Cifras_Pesos,		CCINICIAL_DEF,		CCFINAL_DEF,		SalidaNO,					Par_NumErr,
		Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,			Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
	LEAVE ManejoReporte;
END IF;

IF(Par_TipoReporteID = ReporteCreditosRel)THEN
	CALL CREDITOSRELFIRAPRO(
		Var_FechaReporte,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);
	LEAVE ManejoReporte;
END IF;

IF(Par_TipoReporteID = ReporteCastigos)THEN
	CALL CASTIGOSCARTERAVENFIRACREP(
		Var_FechaReporte,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);
	LEAVE ManejoReporte;
END IF;
-- 5 . Cartera FIRA
IF(Par_TipoReporteID = ReporteCarteraFIRA)THEN
	CALL MONITORCARTERAFIRAREP(
		Var_FechaReporte,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	LEAVE ManejoReporte;
END IF;

-- 6 . Cartera No FIRA
IF(Par_TipoReporteID = ReporteCarteraNoFIRA)THEN
	CALL MONITORCARTERANOFIRAREP(
		Var_FechaReporte,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);
	LEAVE ManejoReporte;
END IF;

-- 7 . Pasivos
IF(Par_TipoReporteID = ReportePasivos)THEN
	CALL REGPASIVOSFONDEOPRO(
		Var_FechaReporte,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);
	LEAVE ManejoReporte;
END IF;
-- 8. Excedentes riesgo comun
IF(Par_TipoReporteID = ReporteExcedentes) THEN
	CALL CREDEXCEDENSRIESGOFIRAPRO(
		Var_FechaReporte,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);
	LEAVE ManejoReporte;
END IF;

-- 9. Riesgo de Crédito
IF(Par_TipoReporteID = ReporteRiesgoCred) THEN
	CALL CREDRIESGOCREDFIRAPRO(
		Var_FechaReporte,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);
	LEAVE ManejoReporte;
END IF;

-- 10 Riesgo Mercado
IF(Par_TipoReporteID = ReporteRiesgoMerc) THEN
	CALL CREDRIESCOMERCFIRAPRO(
		Var_FechaReporte,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);
	LEAVE ManejoReporte;
END IF;

IF(Par_TipoReporteID = ReporteCapitalNeto) THEN
	CALL CREDCAPITALNETOFIRAPRO(
		Var_FechaReporte,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);
	LEAVE ManejoReporte;
END IF;

-- 12 Proyeccion de Indicadores
IF(Par_TipoReporteID = ReporteProyeccion) THEN
	CALL PROYECCIONINDICADORFIRAPRO(
		Var_FechaReporte,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);
	LEAVE ManejoReporte;
END IF;
END ManejoReporte;

SELECT ConsecutivoID, CSVReporte
		FROM REPMONITOREOFIRA
		  WHERE TipoReporteID = Par_TipoReporteID
			AND FechaGeneracion = Var_FechaReporte
			AND NumTransaccion = Aud_NumTransaccion
		  ORDER BY ConsecutivoID;


END TerminaStore$$