
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPERELEVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPERELEVPRO`;

DELIMITER $$
CREATE PROCEDURE `PLDOPERELEVPRO`(
/* STORE DE DETECCION DE OPERACIONES REELEVANTES POR TRANSACCIÓN. */
	Par_SucursalOpe					INT(11),		-- NÚM. DE LA SUCURSAL DE LA OPERACIÓN.
	Par_CuentaAhoID					BIGINT(12),		-- NÚM. CUENTA DE AHORRO.
	Par_MontoOperacion				DECIMAL(16,2),	-- MONTO DE LA OPERACIÓN.
	Par_FechaOperacion				DATE,			-- FECHA DE LA OPERACIÓN.
	Par_NumeroMov					BIGINT(20),		-- NUM TRANSACCIÓN DEL MOVIMIENTO.

	Par_NatMovimiento				CHAR(1),		-- NATURALEZA DEL MOVIMIENTO.
	Par_MonedaID					INT(11),		-- ID DE LA MONEDA DE LA OPERACIÓN.
	Par_TipoMovAhoID				INT(11),		-- TIPO DE MOVIMIENTO DE AHORRO.
	Par_DescripMov					VARCHAR(150),	-- DESCRIPCIÓN DEL MOVIMIENTO DE AHORRO.
	Par_Salida						CHAR(1),		-- TIPO DE SALIDA S.- SI N.- NO.

	INOUT Par_NumErr				INT(11),		-- NUMERO DE ERROR.
	INOUT Par_ErrMen				VARCHAR(400),	-- MENSAJE DE ERROR.
	/* Parametros de Auditoria */
	Par_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,

	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaración de Variables.
	DECLARE Var_ClaveSuc			CHAR(10);		-- Clave de la sucursal (puede ser el CP o la clave proporcionada de la CNBV
	DECLARE Var_ClienteID			INT(11);		-- Numero del Cliente involucrado
	DECLARE Var_Control				CHAR(30);		-- campo Control.
	DECLARE Var_DescripMov			VARCHAR(100);	-- Descripción del movimiento de la cuenta.
	DECLARE Var_DeteccionesCargo	VARCHAR(200);	-- Detección de movimientos de cargo.
	DECLARE Var_DetecOpeRelevante	CHAR(1);		-- Detección de op. relevantes.
	DECLARE Var_EmpresaDefault		INT(11);		-- Empresa DEFAULT (1)
	DECLARE Var_EntidadRegulada		VARCHAR(2);		-- Indica si la financiera es una entidad regulada,
	DECLARE Var_FecFinMes			DATE;			-- Almacena la fehca con el ultimo dia del mes actual
	DECLARE Var_FechaOperacion		DATE;			-- Fecha de Operacion
	DECLARE Var_FechaSig			DATE;			-- Almacena la fecha de un dia habil siguiente a la fecha actual del sistema
	DECLARE Var_FechaSistema		DATE;			-- Fecha del sistema
	DECLARE Var_FecIniMes			DATE;			-- Almacena la fecha con el primer dia del mes actual
	DECLARE Var_HoraOperacion		TIME;			-- Hora de Operacion
	DECLARE Var_Institucion			INT(11);		-- Id de la institucion
	DECLARE Var_LimiteInfOPR		DECIMAL(16,2);	-- Límite de op. relevantes.
	DECLARE Var_Localidad			VARCHAR(45);	-- Localidad del cliente
	DECLARE Var_LocalidadSucursal	VARCHAR(10);	-- Localidad
	DECLARE Var_Mayusculas			CHAR(2);		-- Mayusculas.
	DECLARE Var_MonedaBaseID		INT(11);		-- Moneda base.
	DECLARE Var_MonedaCNBV			VARCHAR(3);		-- Clave de la moneda CNBV.
	DECLARE Var_MonedaLimOPR		INT(11);		-- Moneda de op. relevantes.
	DECLARE Var_NombreCompleto		VARCHAR(200);	-- Nombre completo del cliente.
	DECLARE Var_NombreCorto			VARCHAR(45);	-- Nombre corto del tipo de institucion financiera
	DECLARE Var_NombreInstitucion	VARCHAR(150);	-- Nombre corto de la institucion
	DECLARE Var_OpeReelevanteID		INT(11);		-- Id consecutivo
	DECLARE Var_SucursalRelPLD		VARCHAR(200);	-- Tipo de valor para sucursal por dep. referenciado.
	DECLARE Var_TipoCanal			INT(11);		-- Tipo de Canal del Dep. Referenciado.
	DECLARE Var_TipoInstitID		INT(11);		-- Tipo de institucion financiera
	DECLARE Var_TipoMovAhoID		INT(11);		-- Tipo de mov. de ahorro.
	DECLARE Var_TipoOpeCNBV			VARCHAR(3);		-- Clave de operación de acuerdo a la CNBV.
	DECLARE Var_EsEfectivo			CHAR(1);		-- Es operacion en efectivo.

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia			VARCHAR(1) DEFAULT '';
	DECLARE Decimal_Cero			DECIMAL(12,2) DEFAULT 0.0;
	DECLARE DesAbonoCtaDR			VARCHAR(45);
	DECLARE DesAbonoCtaVen			VARCHAR(45);
	DECLARE DesAbonoCteDR			VARCHAR(45);
	DECLARE DesAbonoCteVen			VARCHAR(45);
	DECLARE DesPagoCreDR			VARCHAR(45);
	DECLARE DesPagoCreVen			VARCHAR(45);
	DECLARE DesRetiroCta			VARCHAR(45);
	DECLARE DiaUnoDelMes			CHAR(2);
	DECLARE Entero_Cero				INT(11) DEFAULT 0;
	DECLARE Es_DiaHabil				CHAR(1);
	DECLARE EsCliente				VARCHAR(3);
	DECLARE Fecha_Vacia				DATE;
	DECLARE NatAbono				CHAR(1);
	DECLARE NatCargo				CHAR(1);
	DECLARE NombreDefaultSistema	VARCHAR(4);
	DECLARE Str_No					CHAR(1);
	DECLARE Str_Si					CHAR(1);
	DECLARE TipoOpeCtaCte			VARCHAR(3);
	DECLARE TipoOpePagCre			VARCHAR(3);
	DECLARE TipoOpeRetCta			VARCHAR(3);
	DECLARE TipoEfectivo			CHAR(1);
	DECLARE TipoMovDepRef			INT(11) DEFAULT 14;
	DECLARE TipoMovDepVent			INT(11) DEFAULT 10;
	DECLARE TipoMovRetVent			INT(11) DEFAULT 11;
	DECLARE TipoSocap				VARCHAR(10);
	DECLARE TipoSofipo				VARCHAR(10);
	DECLARE TipoSofom				VARCHAR(10);
	DECLARE Un_DiaHabil				INT(1);

	-- Asignacion de constantes
	SET Cadena_Vacia				:= '';				-- Cadena Vacia
	SET DesAbonoCtaDR				:='DEPOSITO A CUENTA';-- Descripción por abono.
	SET DesAbonoCtaVen				:='ABONO DE EFECTIVO EN CUENTA';-- Descripción por abono.
	SET DesAbonoCteDR				:='DEPOSITO A CUENTA CLIENTE';-- Descripción por abono.
	SET DesAbonoCteVen				:='ABONO DE EFECTIVO EN CUENTA';-- Descripción por abono.
	SET DesPagoCreDR				:='DEPOSITO A CREDITO';-- Descripción por abono pago cred.
	SET DesPagoCreVen				:='DEPOSITO PAGO DE CREDITO';-- Descripción por abono pago cred.
	SET DesRetiroCta				:='RETIRO DE EFECTIVO EN CUENTA';-- Descripción por retiro.
	SET Entero_Cero					:= 0;				-- Entero cero
	SET EsCliente					:= 'CTE';			-- Tipo de persona Cliente
	SET Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacia
	SET NatAbono					:= 'A';				-- Naturaleza de la operacion: Abono.
	SET NatCargo					:= 'C';				-- Naturaleza de la operacion: Cargo.
	SET NombreDefaultSistema		:= 'SAFI';			-- Nombre DEFAULT del sistema
	SET Str_No						:= 'N';				-- Constante NO
	SET Str_Si						:= 'S';				-- Constante SI
	SET TipoOpeCtaCte				:='01';				-- Tipo de operacion para abono.
	SET TipoOpePagCre				:='09';				-- Tipo de operacion para pago de crédito.
	SET TipoOpeRetCta				:='02';				-- Tipo de operacion para cargo.
	SET TipoEfectivo				:='E';				-- Tipo de Deposito en Efectivo
	SET TipoMovDepRef				:= 14;				-- Tipo de movimiento depósito ref. efectivo.
	SET TipoMovDepVent				:= 10;				-- Tipo de movimiento depósito en ventanilla.
	SET TipoMovRetVent				:= 11;				-- Tipo de movimiento retiro en ventanilla.
	SET TipoSocap					:= 'scap';			-- Tipo SOCAP, corresponde a la tabla TIPOSINSTITUCION
	SET TipoSofipo					:= 'sofipo';		-- Tipo SOFIPO, corresponde a la tabla TIPOSINSTITUCION
	SET TipoSofom					:= 'sofom';			-- Tipo SOFOM, corresponde a la tabla TIPOSINSTITUCION
	SET Un_DiaHabil					:= 1;				-- NUMERO DE DIAS HABILES: 1 DIA
	SET Var_Mayusculas				:= 'MA';			-- Obtener el resultado en Mayusculas

	SET Var_FechaSistema			:= Par_FechaOperacion;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDOPERELEVPRO');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		-- Obtener Valores de la Institucion Financiera.
		SELECT
			Ins.NombreCorto,		Ins.TipoInstitID,	Tip.NombreCorto,	Par.MonedaBaseID,	Par.DetecOpeRelevante,
			Tip.EntidadRegulada
		INTO
			Var_NombreInstitucion,	Var_TipoInstitID,	Var_NombreCorto,	Var_MonedaBaseID,	Var_DetecOpeRelevante,
			Var_EntidadRegulada
		FROM PARAMETROSSIS Par
			INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
			INNER JOIN TIPOSINSTITUCION Tip ON Ins.TipoInstitID = Tip.TipoInstitID;

		SET Var_SucursalRelPLD		:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'SucursalRelPLD');
		SET Var_DeteccionesCargo	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'DetectRelevantesCargoOper');
		SET Var_SucursalRelPLD		:= IFNULL(Var_SucursalRelPLD, Cadena_Vacia);
		SET Var_DeteccionesCargo	:= IFNULL(Var_DeteccionesCargo, Cadena_Vacia);
		SET Var_NombreInstitucion	:= IFNULL(Var_NombreInstitucion, NombreDefaultSistema);
		SET Var_TipoInstitID		:= IFNULL(Var_TipoInstitID, Entero_Cero);
		SET Var_NombreCorto			:= IFNULL(Var_NombreCorto, Cadena_Vacia);
		SET Var_MonedaBaseID		:= IFNULL(Var_MonedaBaseID, Entero_Cero);
		SET Var_DetecOpeRelevante	:= IFNULL(Var_DetecOpeRelevante, Cadena_Vacia);
		SET Var_EntidadRegulada		:= IFNULL(Var_EntidadRegulada, Cadena_Vacia);

		/* ============== PROCESO DE DETECCION DE OPERACIONES RELEVANTES ================ */
		IF(Var_DetecOpeRelevante = Str_Si) THEN
			SET Var_EsEfectivo := (SELECT EsEfectivo FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Par_TipoMovAhoID);
			# SE VALIDA QUE EL TIPO DE MOVIMIENTO DE AHORRO SEA EN EFECTIVO.
			IF(IFNULL(Var_EsEfectivo, Str_No)=Str_Si)THEN
				# SE VALIDA QUE SEA ABONO O CARGO (SI APLICA).
				IF((Par_NatMovimiento = NatAbono) OR (Par_NatMovimiento = NatCargo AND Var_DeteccionesCargo = Str_Si)) THEN
					/* OBTENER LA MONEDA EXTRANJERA DE ACUERDO AL PARAMETRO MANEJADO PARA OPERACIONES REELEVANTES.
					 * OBTENER EL TIPO DE CAMBIO DOF, DE LA MONEDA EN QUE SE EXPRESA EL LIMITE DE OP REELEVANTES.
					 * OBTENER TIPO DE CAMBIO DEL DIA ANTERIOR O LA ÚLTIMA CAPTURADA.
					 * TABLA: PARAMETROSOPREL. */
					SET Var_MonedaLimOPR := (SELECT MonedaLimOPR FROM PARAMETROSOPREL);
					SET Var_LimiteInfOPR := (SELECT LimiteInferior FROM PARAMETROSOPREL);
					SET Var_LimiteInfOPR := ROUND((Var_LimiteInfOPR * FNGETTIPOCAMBIO(Var_MonedaLimOPR, 1, Var_FechaSistema)),2);

					# SI EL MONTO DE LA OPERACIÓN ES IGUAL O MAYOR QUE EL LÍMITE DE OP. RELEVANTES, SE REGISTRA COMO DETECCIÓN.
					IF(IFNULL(Par_MontoOperacion, Entero_Cero) >= Var_LimiteInfOPR)THEN
						# SE OBTIENE EL TIPO DE OPERACIÓN DE ACUERDO A LA CNBV.
						SET Var_TipoOpeCNBV := (SELECT TipoOpeCNBV FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Par_TipoMovAhoID);

						/* SI EL TIPO DE MOV. ES POR DEP. REFERENCIADO.
						 * SI FUE POR PAGO DE CREDITO, ENTONCES SE LE ASIGNA LA CLAVE 09.
						 * PARA LA SUCURSAL, DEPENDIENDO DEL PARÁMETRO TOMA LA SUCURSAL DE ORIGEN DEL CTE
						 * O EL DE LA CUENTA.
						 **/
						IF(Par_TipoMovAhoID = TipoMovDepRef)THEN
							IF(Par_DescripMov = DesPagoCreDR)THEN
								SET Var_TipoOpeCNBV := TipoOpePagCre;
							END IF;
							# 1 es la sucursual de origen del cliente.
							# 2 es la sucursual de la cuenta del cliente.
							SET Par_SucursalOpe := (SELECT CASE Var_SucursalRelPLD
														WHEN '1' THEN CTE.SucursalOrigen
														WHEN '2' THEN CTA.SucursalID
														ELSE '0' END AS Par_SucursalOpe
													FROM CLIENTES CTE
														INNER JOIN CUENTASAHO CTA ON CTE.ClienteID=CTA.ClienteID
													WHERE CTA.CuentaAhoID = Par_CuentaAhoID);

							SET Par_SucursalOpe := IFNULL(Par_SucursalOpe, Entero_Cero);
							SET Var_LocalidadSucursal := Entero_Cero;
						END IF;

						# SI ES SOFOM ENTIDAD NO REGULADA ENTONCES SE ASIGNA LA CLAVE 09 PARA DEPÓSITOS.
						IF(Var_NombreCorto = TipoSofom AND Var_EntidadRegulada = Str_No)THEN
							SET Var_TipoOpeCNBV := TipoOpePagCre;
						END IF;


					# SE OBTIENE LA LOCALIDAD DE LA SUCURSAL DE LA OPERACIÓN.
					SET Var_LocalidadSucursal := (SELECT FNGETPLDSITILOC(S.EstadoID, S.MunicipioID, S.LocalidadID) FROM SUCURSALES S
													WHERE S.SucursalID=Par_SucursalOpe);

						SET Var_TipoOpeCNBV := LPAD(Var_TipoOpeCNBV,2,"0");



						SET Var_ClienteID := (SELECT ClienteID FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID LIMIT 1);
						SET Var_MonedaCNBV  := (SELECT EqCNBVUIF FROM MONEDAS WHERE MonedaID = Par_MonedaID);

						/* Código de la sucursal:
						 * Si es sofom se obtiene el codigo postal (de acuerdo al formato publicado en el DOF para sofomes.
						 * Si no es sofom, se obtiene la clave proporcionado por la CNBV (socaps y sofipos).
						 * */
						SET Var_ClaveSuc := (SELECT IF(Var_NombreCorto = TipoSofom, CP, ClaveSucCNBV)
												FROM SUCURSALES
												WHERE SucursalID = Par_SucursalOpe);
						SET Var_ClaveSuc := IFNULL(Var_ClaveSuc, Entero_Cero);

						IF(Par_SucursalOpe = Entero_Cero)THEN
							SET Var_LocalidadSucursal := IFNULL(Var_Localidad, Entero_Cero);
						END IF;

						# FECHA Y HORA DE LA OPERACIÓN
						SET Var_FechaOperacion	:= DATE(Par_FechaOperacion);
						SET Var_HoraOperacion	:= DATE_FORMAT(Aud_FechaActual,'%H:%i:%s');
						SET Var_DescripMov		:= LEFT(Par_DescripMov,100);

						# REGISTRO DE LA OPERACIÓN RELEVANTE.
						CALL PLDOPERELEVANTALT(
							Var_ClaveSuc,		Par_FechaOperacion,	Var_HoraOperacion,	Var_LocalidadSucursal,	Var_TipoOpeCNBV,
							Var_ClienteID,		Par_CuentaAhoID,	Par_MontoOperacion,	Var_MonedaCNBV,			Var_DescripMov,
                                Entero_Cero,		Str_No,				Par_NumErr,			Par_ErrMen,				Var_OpeReelevanteID,
                                Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
                                Aud_Sucursal,		Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;
					END IF; # SI EL MONTO SUPERA EL LÍMITE.
				END IF; # SI ES CARGO O ABONO.
			END IF;# SI ES EFECTIVO.
		END IF; # SI DETECTA OPERACIONES RELEVANTES.

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= 'Proceso de Deteccion Op. Relevantes Finalizado Exitosamente.';
		SET Var_Control		:= 'opeReelevanteID';

	END ManejoErrores;

	IF (Par_Salida = Str_Si) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			IFNULL(Var_OpeReelevanteID, Entero_Cero) AS Consecutivo;
	END IF;

END TerminaStore$$

