-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INFORMACIONADICACREDMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `INFORMACIONADICACREDMOD`;
DELIMITER $$


CREATE PROCEDURE `INFORMACIONADICACREDMOD`(
	/*SP para modificar la informacion adicional de los clientes acreditados*/
	Par_Acreditado					INT(11),					-- Numero de Acreditado equivale a ClienteID de CLIENTES
	Par_ActivoCirculante			DECIMAL(14,2),				-- Activo circulante
	Par_ActivoProductivos			DECIMAL(14,2),				-- Activos productivos
	Par_ActivoSujetosRiesgo			DECIMAL(14,2),				-- Activos sujetos a riesgos
	Par_AnioIngresosBruto			INT(4),					-- Año ingresos bruto, Indicar el año a cuatro dígitos del de Fecha estados financieros, éste campo no deberá permitir la modificación del valor ya que es tomado de un campo anterior.

	Par_CalificacionExterna			INT(11),					-- Calificación externa, 1.Cuenta con la calificación de dos o más agencias calificadoras 2.Cuenta con la calificación de una agencia calificadora 3.No cuenta con ninguna calificación.
	Par_CarteraCredito				DECIMAL(14,2),				-- Cartera de crédito
	Par_CarteraNeta					DECIMAL(14,2),				-- Cartera neta
	Par_CarteraVencida				DECIMAL(14,2),				-- Cartera vencida
	Par_Clientes					INT(11),					-- Clientes 1.Menos del 15% 2.Entre el 15% y el 35% 3.Más del 35% 4.No fue posible obtenet la información

	Par_Competencia					INT(11),					-- Competencia 1.Las características de la industría reflejan debilidades importantes. 2.Las características de la industría reflejan tendencias mixtas en crecimiento. 3.Las características de la industría reflejan crecimiento y desempeño sobresaliente. 4.No cuenta con análisis de la industría con menos de un año de antigüedad. 5.No fue posible obtener la información.
	Par_CompAccionaria				INT(11),					-- Composición accionaria: Conjunto de radiobuttons (las opciones se muestran en el diseño de pantalla).
	Par_ConsejoAdmin				INT(11),					-- Consejo de administración: Conjunto de radiobuttons (las opciones se muestran en el diseño de pantalla).
	Par_CumpleContaGuberna			INT(11),					-- Cumple conta gubernamental S:Si cumple N:No cumple,
	Par_DepositoDeBienes			DECIMAL(14,2),				-- Depósito de bienes
	Par_EmisionTitulos				INT(11),						-- Emisión de títulos 1. Emite títulos y se reconocen en contabilidad 2.Emite títulos y se reconocen como transacciones fuera de balance 3.No tiene emisiones
	Par_EntidadRegulada				INT(1),					-- Entidad regulada S:Regulada N:No regulada,
	Par_EstructOrgan				INT(11),					-- Estructura organizacional: Conjunto de radiobuttons (las opciones se muestran en el diseño de pantalla).
	Par_FechaEdoFinan				INT(6),				-- Fecha estados finan.
	Par_FechEdoFinanVentNet			INT(6),				-- Fecha estados finan. ventas netas
	Par_FondeoTotal					DECIMAL(14,2),				-- Fondeo total
	Par_GastosAdmin					DECIMAL(14,2),				-- Gastos de admin
	Par_GastosFinan					DECIMAL(14,2),				-- Gastos financieros
	Par_IngresosBrutos				DECIMAL(14,2),				-- Ingresos brutos
	Par_IngresosTotales				DECIMAL(14,2),				-- Ingresos totales
	Par_MargenFinan					DECIMAL(14,2),				-- Margen financiero, Campo calculable (Ingresos totales / Gastos de administración)
	Par_NivelPoliticas				INT(11),					-- Nivel de políticas 1.Implementa difunde y aplica manuales de políticas 2.Cuenta con manuales de políticas pero no están implementados. 3. No cuenta con manuales de políticas. 4.No es posible obtener la información.
	Par_NumeroEmpleados				INT(11),					-- Número de empleados
	Par_NumeroLineasNeg				INT(11),					-- Número de líneas de negocio: Campo de valor entero, en caso de quedar vacío, se asignará cero de default.
	Par_PasivoCirculante			DECIMAL(14,2),				-- Pasivo circulante
	Par_PasivoExigible				DECIMAL(14,2),				-- Pasivo exigible
	Par_PasivoLargoPlazo			DECIMAL(14,2),				-- Pasivo a largo plazo
	Par_PeriodoAudEdos				INT(11),					-- Periodo Aud. Edos. Fin, 1.Durante más de 2 años consecutivos 2.Durante el último año 3.Nunca han sido auditados 4.No es posible obtener la información
	Par_ProcesoAuditoria			INT(11),					-- Proceso auditoría 1.Auditoría interna formalizada 2.Auditoría interna no formalizada 3.No cuenta con proceso de auditoría 4.No es posible obtener la información
	Par_Proveedores					INT(11),					-- Proveedores,  1. Menos del 15% 2.Entre el 15% y el 35% 3.Más del 35% 4.No fue posible obtenet la información
	Par_ROE							DECIMAL(14,6),				-- Campo calculable (Utilidad / Capital contable), el capital se deberá tomar del conocimiento del cliente.
	Par_TasaRetLaboral1				DECIMAL(14,2),				-- Tasa de retención laboral 1
	Par_TasaRetLaboral2				DECIMAL(14,2),				-- Tasa de retención laboral 2
	Par_TasaRetLaboral3				DECIMAL(14,2),				-- Tasa de retención laboral 3
	Par_TipoEntidad					INT(11),					-- Tipo de Entidad
	Par_UtilAntGastImpues			DECIMAL(14,2),				-- Utilidad antes de gastos e impuestos
	Par_UtilidaNeta					DECIMAL(14,2),				-- Utilidad neta
	Par_EPRC						DECIMAL(14,2),				-- Valor Estimación preventiva para riesgos crediticios
	Par_NumFuentes					INT(11),					-- Numero de Fuentes
	Par_SaldosAcreditados			DECIMAL(14,2),				-- Suma Total de los 3 Principales Acreditados
	Par_NumConsejerosInd			INT(11),					-- Numero de Consejeros Independientes
	Par_NumConsejerosTot			INT(11),					-- Numero de Consejeros totales en el consejo de administración
	Par_PorcParticipacionAcc		DECIMAL(14,2),				-- Porcentaje de participación accionaria del accionista mayoritario
	Par_CapitalContable				DECIMAL(14,2),				-- Capital Contable del AGD.
	Par_ExpLaboral					INT(11),					-- Anios de Experiencia

	Par_Salida						CHAR(1),					-- Indica el tipo de salida S.- SI N.- No
	INOUT Par_NumErr				INT,						-- Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),				-- Mensaje de Error
	/*Parametros de Auditoria*/
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(12)
	)

TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Activos				DECIMAL(14,2);			-- Cantidad de activos que tiene el cliente.
	DECLARE Var_Consecutivo			VARCHAR(50);			-- Value del Control de Pantalla
	DECLARE Var_Control				VARCHAR(50);			-- ID del Control en pantalla
	DECLARE Var_Descripcion			VARCHAR(100);			-- Descripcion de la Sociedad
	DECLARE Var_EsFinanciera		CHAR(1);				-- Indica si el Cliente es una Institucion financiera
	DECLARE Var_MostrarPantalla		INT(11);				-- Indica que numero de subform mostrara en pantalla
	DECLARE Var_TipoPersona			CHAR(1);				-- Tipo de Persona
	DECLARE Var_TipoSociedadID		INT(11);				-- Tipo de Sociedad
	DECLARE Var_VentaAnuales		DECIMAL(14,2);			-- Cantidad de activos que tiene el cliente.

	-- Declaracion de constantes
	DECLARE ActivosSuperioresA14		DECIMAL(14,2);			-- Activos Mayores A
	DECLARE ActivosSuperioresA54	DECIMAL(14,2);			-- Activos Mayores A los 54 millones
	DECLARE ActivosSuperioresA600	DECIMAL(14,2);			-- Activos Mayores A los 600 millones
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena Vacia
	DECLARE Cons_No					CHAR(1);				-- Constante No
	DECLARE Cons_Si					CHAR(1);				-- Constante SI
	DECLARE Entero_Cero				INT;					-- Entero Cero
	DECLARE Decimal_Cero			DECIMAL(14,2);			-- Decimal Cero
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE Fecha_Vacia				DATE;					-- Fecha Vacia
	DECLARE SalidaSi				CHAR(1);
	DECLARE TipoPersFisica			CHAR(1);				-- Tipo de Persona Fisica
	DECLARE TipoPersFisicaActEmp	CHAR(1);				-- Tipo de Persona Fisica Con Actividad Empresarial
	DECLARE TipoPersMoral			CHAR(1);				-- Tipo de Persona Moral
	DECLARE TipoSocIDAlmacen		INT(11);				-- Tipo de Sociedad Financiera que es almacen
	DECLARE Var_MostrarSi			CHAR(1);				-- Mostrar SI

	-- Asignacion de constantes
	SET ActivosSuperioresA14			:= 14000000;
	SET ActivosSuperioresA54		:= 54000000;
	SET ActivosSuperioresA600		:= 600000000;
	SET Cadena_Vacia				:= '';				-- Cadena Vacia
	SET Cons_NO						:= 'N';				-- Constante No
	SET Cons_Si						:= 'S';				-- Constante Si
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET Decimal_Cero				:= 0.0;				-- Decimal Cero
	SET Estatus_Activo				:= 'A';				-- Estatus Activo
	SET Fecha_Vacia					:= '1900-01-01';	-- Fecha vacia
	SET SalidaSi					:= 'S';				-- Salida Si
	SET TipoPersFisica				:= 'F';				-- Tipo de Persona Fisica
	SET TipoPersFisicaActEmp		:= 'A';				-- Tipo de Persona Fisica con Actividad Empresaral
	SET TipoPersMoral				:= 'M';				-- Tipo de Persona Moral
	SET TipoSocIDAlmacen			:= 21;				-- De acuerdo a la tabla [TIPOSOCIEDAD] - 21 ALMACENES GENERALES DE DEPOSITO
	SET Var_MostrarSi 				:= 'N';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-INFORMACIONADICACREDMOD');
			SET Var_Control		:= 'sqlException' ;
		END;

		SELECT
			CLI.TipoSociedadID,		CLI.TipoPersona,			TIP.Descripcion,			TIP.EsFinanciera,			CON.Activos,
			CON.ImporteVta
			INTO
			Var_TipoSociedadID,		Var_TipoPersona,			Var_Descripcion,			Var_EsFinanciera,			Var_Activos,
			Var_VentaAnuales
			FROM
				CLIENTES AS CLI LEFT JOIN
				TIPOSOCIEDAD AS TIP ON CLI.TipoSociedadID = TIP.TipoSociedadID LEFT JOIN
				CONOCIMIENTOCTE AS CON ON CLI.ClienteID = CON.ClienteID
				WHERE CLI.ClienteID = Par_Acreditado;

		SET Var_Activos := IFNULL(Var_Activos, Decimal_Cero);
		SET Var_VentaAnuales := IFNULL(Var_VentaAnuales, Decimal_Cero);

		SET Var_MostrarPantalla := 0;

		-- Seteo de los Parameotrs en caso de venir vacios
		SET Par_PasivoLargoPlazo 	:= IFNULL(Par_PasivoLargoPlazo, Decimal_Cero);
		SET Par_PasivoExigible 		:= IFNULL(Par_PasivoExigible, Decimal_Cero);
		SET Par_CarteraCredito 		:= IFNULL(Par_CarteraCredito, Decimal_Cero);
		SET Par_UtilidaNeta 		:= IFNULL(Par_UtilidaNeta, Decimal_Cero);
		SET Par_ROE 				:= IFNULL(Par_ROE, Decimal_Cero);
		SET Par_ActivoSujetosRiesgo := IFNULL(Par_ActivoSujetosRiesgo,Decimal_Cero);
		SET Par_GastosAdmin 		:= IFNULL(Par_GastosAdmin,Decimal_Cero);
		SET Par_IngresosTotales 	:= IFNULL(Par_IngresosTotales,Decimal_Cero);
		SET Par_CarteraVencida 		:= IFNULL(Par_CarteraVencida,Decimal_Cero);
		SET Par_MargenFinan 		:= IFNULL(Par_MargenFinan,Decimal_Cero);
		SET Par_ActivoProductivos	:= IFNULL(Par_ActivoProductivos,Decimal_Cero);
		SET Par_FechaEdoFinan		:= IFNULL(Par_FechaEdoFinan,Entero_Cero);
		SET Par_CumpleContaGuberna	:= IFNULL(Par_CumpleContaGuberna,Entero_Cero);
		SET Par_EmisionTitulos		:= IFNULL(Par_EmisionTitulos,Entero_Cero);
		SET Par_EPRC				:= IFNULL(Par_EPRC,Decimal_Cero);
		SET Par_NumeroLineasNeg		:= IFNULL(Par_NumeroLineasNeg,Entero_Cero);
		SET Par_ProcesoAuditoria	:= IFNULL(Par_ProcesoAuditoria,Entero_Cero);
		SET Par_NivelPoliticas		:= IFNULL(Par_NivelPoliticas,Entero_Cero);
		SET Par_PeriodoAudEdos		:= IFNULL(Par_PeriodoAudEdos,Entero_Cero);

		SET Par_DepositoDeBienes	:= IFNULL(Par_DepositoDeBienes,Decimal_Cero);
		SET Par_FondeoTotal			:= IFNULL(Par_FondeoTotal,Decimal_Cero);
		SET Par_CarteraNeta			:= IFNULL(Par_CarteraNeta,Decimal_Cero);
		SET Par_NumeroEmpleados		:= IFNULL(Par_NumeroEmpleados,Entero_Cero);
		SET Par_TasaRetLaboral1		:= IFNULL(Par_TasaRetLaboral1,Decimal_Cero);
		SET Par_TasaRetLaboral2		:= IFNULL(Par_TasaRetLaboral2,Decimal_Cero);
		SET Par_TasaRetLaboral3		:= IFNULL(Par_TasaRetLaboral3,Decimal_Cero);
		SET Par_FechEdoFinanVentNet := IFNULL(Par_FechEdoFinanVentNet,Cadena_Vacia);
		SET Par_IngresosBrutos		:= IFNULL(Par_IngresosBrutos, Decimal_Cero);
		SET Par_AnioIngresosBruto	:= IFNULL(Par_AnioIngresosBruto,Entero_Cero);

		SET Par_NumFuentes			:= IFNULL(Par_NumFuentes,Entero_Cero);
		SET Par_SaldosAcreditados	:= IFNULL(Par_SaldosAcreditados,Decimal_Cero);
		SET Par_NumConsejerosInd	:= IFNULL(Par_NumConsejerosInd,Entero_Cero);
		SET Par_NumConsejerosTot	:= IFNULL(Par_NumConsejerosTot,Entero_Cero);
		SET Par_PorcParticipacionAcc := IFNULL(Par_PorcParticipacionAcc,Decimal_Cero);

		SET Par_CapitalContable		:= IFNULL(Par_CapitalContable, Decimal_Cero);
		SET Par_EntidadRegulada		:= IFNULL(Par_EntidadRegulada, Entero_Cero);

		SET Par_ActivoCirculante	:= IFNULL(Par_ActivoCirculante,Decimal_Cero);
		SET Par_PasivoCirculante	:= IFNULL(Par_PasivoCirculante,Decimal_Cero);
		SET Par_Competencia			:= IFNULL(Par_Competencia,Entero_Cero);
		SET Par_Proveedores			:= IFNULL(Par_Proveedores,Entero_Cero);
		SET Par_Clientes			:= IFNULL(Par_Clientes,Entero_Cero);
		SET Par_CalificacionExterna	:= IFNULL(Par_CalificacionExterna,Entero_Cero);
		SET Par_ConsejoAdmin		:= IFNULL(Par_ConsejoAdmin,Entero_Cero);
		SET Par_EstructOrgan		:= IFNULL(Par_EstructOrgan,Entero_Cero);
		SET Par_CompAccionaria		:= IFNULL(Par_CompAccionaria,Entero_Cero);
		SET Par_UtilAntGastImpues	:= IFNULL(Par_UtilAntGastImpues,Decimal_Cero);
		SET Par_GastosFinan			:= IFNULL(Par_GastosFinan,Decimal_Cero);

		SET Par_ExpLaboral			:= IFNULL(Par_ExpLaboral,Entero_Cero);

		IF(Var_EsFinanciera = Cons_Si AND Var_TipoSociedadID != TipoSocIDAlmacen) THEN
			SET Var_MostrarPantalla := 1;
		END IF;

		IF(Var_TipoSociedadID = TipoSocIDAlmacen AND Var_EsFinanciera = Cons_No) THEN
			SET Var_MostrarPantalla := 2;
		END IF;

		IF(((Var_TipoPersona = TipoPersMoral AND Var_EsFinanciera = Cons_No) OR (Var_TipoPersona IN('F','A')))
			AND Var_VentaAnuales < ActivosSuperioresA14) THEN
			SET Var_MostrarPantalla := 3;
		END IF;

		IF(((Var_TipoPersona = TipoPersMoral AND Var_EsFinanciera = Cons_No) OR (Var_TipoPersona IN('F','A')))
			AND Var_VentaAnuales >= ActivosSuperioresA14) THEN
			SET Var_MostrarPantalla := 3;
		END IF;


		SET Aud_FechaActual := NOW();


		IF(Var_MostrarPantalla = 1) THEN
			UPDATE INFORMACIONADICFIRA SET
				Activocirc = Par_ActivoCirculante,
				Activosprod = Par_ActivoProductivos,
				Asrtot = Par_ActivoSujetosRiesgo,
				Anioingresobruto = Par_AnioIngresosBruto,
				Carteracredito = Par_CarteraCredito,

				Carteraneta = Par_CarteraNeta,
				Carteravenc = Par_CarteraVencida,
				Clientes = Par_Clientes,
				Compaccion = Par_CompAccionaria,
				Competencia = Par_Competencia,

				Consejoadmon = Par_ConsejoAdmin,
				Contaguber = Par_CumpleContaGuberna,
				Depbienes = Par_DepositoDeBienes,
				Emisiontit = Par_EmisionTitulos,
				Entregulada = Par_EntidadRegulada,

				Estrucorganiz = Par_EstructOrgan,
				Fechaedosfin = Par_FechaEdoFinan,
				Fechaedosfinvn = Par_FechEdoFinanVentNet,
				Fondeotot = Par_FondeoTotal,
				Gastosadmon = Par_GastosAdmin,

				Gastosfin = Par_GastosFinan,
				Ingresobruto = Par_IngresosBrutos,
				Ingresostotales = Par_IngresosTotales,
				Margenfin = Par_MargenFinan,
				Nivelpoliticas = Par_NivelPoliticas,

				Numempleados = Par_NumeroEmpleados,
				Numlineas = Par_NumeroLineasNeg,
				Pasivocirc = Par_PasivoCirculante,
				Pasivoexigible = Par_PasivoExigible,
				Pasivolargo = Par_PasivoLargoPlazo,

				Edosfinaud = Par_PeriodoAudEdos,
				Gobiernocorp = Par_ProcesoAuditoria,
				Proveedores = Par_Proveedores,
				Roe = Par_ROE,
				Retlab1 = Par_TasaRetLaboral1,

				Retlab2 = Par_TasaRetLaboral2,
				Retlab3 = Par_TasaRetLaboral3,
				Tipoentidad = Par_TipoEntidad,
				Uafir = Par_UtilAntGastImpues,
				Utilidadneta = Par_UtilidaNeta,

				Califexterna = Par_CalificacionExterna,
				Eprc = Par_EPRC,
				NumFuentes = Par_NumFuentes,
				SaldoAcreditados = Par_SaldosAcreditados,
				NumConsejerosInd = Par_NumConsejerosInd,
				NumConsejerosTot = Par_NumConsejerosTot,
				PorcParticipacionAcc = Par_PorcParticipacionAcc,

				Capitalcontableagd = Par_CapitalContable,
				Aniosexp			= Par_ExpLaboral,

				EmpresaID			= Aud_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,

				Sucursal			= Aud_Sucursal,
				NumTransaccion 		= Aud_NumTransaccion
				WHERE
				ClienteID = Par_Acreditado;

		  ELSEIF(Var_MostrarPantalla = 2) THEN
			UPDATE INFORMACIONADICFIRA SET
				Activocirc = Par_ActivoCirculante,
				Activosprod = Par_ActivoProductivos,
				Asrtot = Par_ActivoSujetosRiesgo,
				Anioingresobruto = Par_AnioIngresosBruto,
				Carteracredito = Par_CarteraCredito,
				Carteraneta = Par_CarteraNeta,
				Carteravenc = Par_CarteraVencida,
				Clientes = Par_Clientes,
				Compaccion = Par_CompAccionaria,
				Competencia = Par_Competencia,
				Consejoadmon = Par_ConsejoAdmin,
				Contaguber = Par_CumpleContaGuberna,
				Depbienes = Par_DepositoDeBienes,
				Emisiontitagd = Par_EmisionTitulos,
				Entregulada = Par_EntidadRegulada,
				Estrucorganiz = Par_EstructOrgan,
				Fechaedosfinagd = Par_FechaEdoFinan,
				Fechaedosfinvn = Par_FechEdoFinanVentNet,
				Fondeotot = Par_FondeoTotal,
				Gastosadmonagd = Par_GastosAdmin,
				Gastosfin = Par_GastosFinan,
				Ingresostotagd = Par_IngresosBrutos,
				Ingresostotales = Par_IngresosTotales,
				Margenfin = Par_MargenFinan,
				Nivelpoliticas = Par_NivelPoliticas,
				Numempleados = Par_NumeroEmpleados,
				Numlineas = Par_NumeroLineasNeg,
				Pasivocirc = Par_PasivoCirculante,
				Pasivoexigible = Par_PasivoExigible,
				Pasivolargo = Par_PasivoLargoPlazo,
				Edosfinaud = Par_PeriodoAudEdos,
				Gobiernocorp = Par_ProcesoAuditoria,
				Proveedores = Par_Proveedores,
				Roeagd = Par_ROE,
				Retlab1 = Par_TasaRetLaboral1,
				Retlab2 = Par_TasaRetLaboral2,
				Retlab3 = Par_TasaRetLaboral3,
				Tipoentidad = Par_TipoEntidad,
				Uafir = Par_UtilAntGastImpues,
				Utilidadnetaagd = Par_UtilidaNeta,
				Califexterna = Par_CalificacionExterna,
				Eprc = Par_EPRC,
				NumFuentes = Par_NumFuentes,
				SaldoAcreditados = Par_SaldosAcreditados,
				NumConsejerosInd = Par_NumConsejerosInd,
				NumConsejerosTot = Par_NumConsejerosTot,
				PorcParticipacionAcc = Par_PorcParticipacionAcc,

				Capitalcontableagd = Par_CapitalContable,
				Aniosexp			= Par_ExpLaboral,

				EmpresaID			= Aud_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,

				Sucursal			= Aud_Sucursal,
				NumTransaccion 		= Aud_NumTransaccion
				WHERE
					ClienteID = Par_Acreditado;

		  ELSEIF(Var_MostrarPantalla = 3) THEN
			UPDATE INFORMACIONADICFIRA SET
				Activocirc = Par_ActivoCirculante,
				Activosprod = Par_ActivoProductivos,
				Asrtot = Par_ActivoSujetosRiesgo,
				Anioingresobrutom = Par_AnioIngresosBruto,
				Carteracredito = Par_CarteraCredito,
				Carteraneta = Par_CarteraNeta,
				Carteravenc = Par_CarteraVencida,
				Clientes = Par_Clientes,
				Compaccion = Par_CompAccionaria,
				Competencia = Par_Competencia,
				Consejoadmon = Par_ConsejoAdmin,
				Contaguber = Par_CumpleContaGuberna,
				Depbienes = Par_DepositoDeBienes,
				Emisiontitagd = Par_EmisionTitulos,
				Entregulada = Par_EntidadRegulada,
				Estrucorganiz = Par_EstructOrgan,
				Fechaedosfinm = Par_FechaEdoFinan,
				Fechaedosfinvn = Par_FechEdoFinanVentNet,
				Fondeotot = Par_FondeoTotal,
				Gastosadmonagd = Par_GastosAdmin,
				Gastosfin = Par_GastosFinan,
				Ingresobrutom = Par_IngresosBrutos,
				Ingresostotales = Par_IngresosTotales,
				Margenfin = Par_MargenFinan,
				Nivelpoliticas = Par_NivelPoliticas,
				Numempleadosm = Par_NumeroEmpleados,
				Numlineas = Par_NumeroLineasNeg,
				Pasivocirc = Par_PasivoCirculante,
				Pasivoexigible = Par_PasivoExigible,
				Pasivolargo = Par_PasivoLargoPlazo,
				Edosfinaudm = Par_PeriodoAudEdos,
				Gobiernocorp = Par_ProcesoAuditoria,
				Proveedores = Par_Proveedores,
				Roem = Par_ROE,
				Retlab1m = Par_TasaRetLaboral1,
				Retlab2m = Par_TasaRetLaboral2,
				Retlab3m = Par_TasaRetLaboral3,
				Tipoentidad = Par_TipoEntidad,
				Uafir = Par_UtilAntGastImpues,
				Utilidadnetam = Par_UtilidaNeta,
				Califexterna = Par_CalificacionExterna,
				Eprc = Par_EPRC,
				NumFuentes = Par_NumFuentes,
				SaldoAcreditados = Par_SaldosAcreditados,
				NumConsejerosInd = Par_NumConsejerosInd,
				NumConsejerosTot = Par_NumConsejerosTot,
				PorcParticipacionAcc = Par_PorcParticipacionAcc,

				Capitalcontableagd = Par_CapitalContable,
				Aniosexp			= Par_ExpLaboral,

				EmpresaID			= Aud_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,

				Sucursal			= Aud_Sucursal,
				NumTransaccion 		= Aud_NumTransaccion
				WHERE
					ClienteID = Par_Acreditado;
	  ELSE
		UPDATE INFORMACIONADICFIRA SET
			Activocirc = Par_ActivoCirculante,
			Activosprod = Par_ActivoProductivos,
			Asrtot = Par_ActivoSujetosRiesgo,
			Anioingresobruto = Par_AnioIngresosBruto,
			Carteracredito = Par_CarteraCredito,
			Carteraneta = Par_CarteraNeta,
			Carteravenc = Par_CarteraVencida,
			Clientes = Par_Clientes,
			Compaccion = Par_CompAccionaria,
			Competencia = Par_Competencia,
			Consejoadmon = Par_ConsejoAdmin,
			Contaguber = Par_CumpleContaGuberna,
			Depbienes = Par_DepositoDeBienes,
			Emisiontit = Par_EmisionTitulos,
			Entregulada = Par_EntidadRegulada,
			Estrucorganiz = Par_EstructOrgan,
			Fechaedosfin = Par_FechaEdoFinan,
			Fechaedosfinvn = Par_FechEdoFinanVentNet,
			Fondeotot = Par_FondeoTotal,
			Gastosadmon = Par_GastosAdmin,
			Gastosfin = Par_GastosFinan,
			Ingresobruto = Par_IngresosBrutos,
			Ingresostotales = Par_IngresosTotales,
			Margenfin = Par_MargenFinan,
			Nivelpoliticas = Par_NivelPoliticas,
			Numempleados = Par_NumeroEmpleados,
			Numlineas = Par_NumeroLineasNeg,
			Pasivocirc = Par_PasivoCirculante,
			Pasivoexigible = Par_PasivoExigible,
			Pasivolargo = Par_PasivoLargoPlazo,
			Edosfinaud = Par_PeriodoAudEdos,
			Gobiernocorp = Par_ProcesoAuditoria,
			Proveedores = Par_Proveedores,
			Roe = Par_ROE,
			Retlab1 = Par_TasaRetLaboral1,
			Retlab2 = Par_TasaRetLaboral2,
			Retlab3 = Par_TasaRetLaboral3,
			Tipoentidad = Par_TipoEntidad,
			Uafir = Par_UtilAntGastImpues,
			Utilidadneta = Par_UtilidaNeta,
			Califexterna = Par_CalificacionExterna,
			Eprc = Par_EPRC,
			NumFuentes = Par_NumFuentes,
			SaldoAcreditados = Par_SaldosAcreditados,
			NumConsejerosInd = Par_NumConsejerosInd,
			NumConsejerosTot = Par_NumConsejerosTot,
			PorcParticipacionAcc = Par_PorcParticipacionAcc,
			Capitalcontableagd = Par_CapitalContable,
			Aniosexp			= Par_ExpLaboral,

				EmpresaID			= Aud_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,

				Sucursal			= Aud_Sucursal,
				NumTransaccion 		= Aud_NumTransaccion
			WHERE
				ClienteID = Par_Acreditado;
	END IF;

		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('La Informaci&oacute;n Adicional del Acreditado ',Par_Acreditado,' ha sido Modificada Exitosamente.');
		SET Var_Control 	:= 'idAcreditado' ;
		SET Var_Consecutivo	:= Par_Acreditado;

	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$