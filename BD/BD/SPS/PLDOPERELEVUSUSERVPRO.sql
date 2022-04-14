-- SP PLDOPERELEVUSUSERVPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS `PLDOPERELEVUSUSERVPRO`;

DELIMITER $$

CREATE PROCEDURE `PLDOPERELEVUSUSERVPRO`(
	-- STORE DE DETECCION DE OPERACIONES REELEVANTES PARA USUARIOS DE SERVICIOS POR TRANSACCION
	Par_SucursalOpe				INT(11),		-- Numero de la Sucursal de la Operacion
	Par_UsuarioServicioID		INT(11),		-- Numero de Usuario de Servicio
	Par_MontoOperacion			DECIMAL(16,2),	-- Monto de la Operacion
	Par_FechaOperacion			DATE,			-- Fecha de la Operacion
	Par_NumeroMov				BIGINT(20),		-- Numero de Transaccion del Movimiento

	Par_NatMovimiento			CHAR(1),		-- Naturaleza del Movimiento
	Par_MonedaID				INT(11),		-- ID de la Moneda de la Operacion
	Par_DescripMov				VARCHAR(150),	-- Descripcion del Movimiento
	Par_Salida					CHAR(1),		-- Tipo de Salida S = SI N = NO.

	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	Par_EmpresaID       		INT(11),		-- Parametro de auditoria ID de la Empresa
    Aud_Usuario         		INT(11),		-- Parametro de auditoria ID del Usuario
    Aud_FechaActual     		DATETIME,		-- Parametro de auditoria Fecha Actual
    Aud_DireccionIP     		VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      		VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        		INT(11),		-- Parametro de auditoria ID de la Sucursal
    Aud_NumTransaccion  		BIGINT(20)  	-- Parametro de auditoria Numero de la Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables.
	DECLARE Var_ClaveSuc			CHAR(10);		-- Clave de la sucursal (puede ser el CP o la clave proporcionada de la CNBV
	DECLARE Var_Control				CHAR(30);		-- campo Control.
	DECLARE Var_DescripMov			VARCHAR(100);	-- Descripción del movimiento de la cuenta.
	DECLARE Var_DeteccionesCargo	VARCHAR(200);	-- Detección de movimientos de cargo.
	DECLARE Var_DetecOpeRelevante	CHAR(1);		-- Detección de op. relevantes.

	DECLARE Var_EntidadRegulada		VARCHAR(2);		-- Indica si la financiera es una entidad regulada,
	DECLARE Var_FechaOperacion		DATE;			-- Fecha de Operacion
	DECLARE Var_FechaSistema		DATE;			-- Fecha del sistema
	DECLARE Var_HoraOperacion		TIME;			-- Hora de Operacion
	DECLARE Var_LimiteInfOPR		DECIMAL(16,2);	-- Límite de op. relevantes.

	DECLARE Var_LocalidadSucursal	VARCHAR(10);	-- Localidad
	DECLARE Var_MonedaBaseID		INT(11);		-- Moneda base.
	DECLARE Var_MonedaCNBV			VARCHAR(3);		-- Clave de la moneda CNBV.
	DECLARE Var_MonedaLimOPR		INT(11);		-- Moneda de op. relevantes.
    DECLARE Var_NombreCorto			VARCHAR(45);	-- Nombre corto del tipo de institucion financiera

    DECLARE Var_NombreInstitucion	VARCHAR(150);	-- Nombre corto de la institucion
	DECLARE Var_OpeReelevanteID		INT(11);		-- Id consecutivo
	DECLARE Var_SucursalRelPLD		VARCHAR(200);	-- Tipo de valor para sucursal por dep. referenciado.
	DECLARE Var_TipoInstitID		INT(11);		-- Tipo de institucion financiera
	DECLARE Var_TipoMovAhoID		INT(11);		-- Tipo de mov. de ahorro.

    DECLARE Var_TipoOpeCNBV			VARCHAR(3);		-- Clave de operación de acuerdo a la CNBV.
	DECLARE Var_EsEfectivo			CHAR(1);		-- Es operacion en efectivo.
    DECLARE Var_ExisteOperaReelev	INT(11);		-- Valida si existen Operaciones Relevantes

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia			VARCHAR(1);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Entero_Cero				INT(11) DEFAULT 0;
	DECLARE Fecha_Vacia				DATE;
	DECLARE NatAbono				CHAR(1);

    DECLARE NombreDefaultSistema	VARCHAR(4);
	DECLARE Cons_NO					CHAR(1);
	DECLARE Cons_SI					CHAR(1);
	DECLARE Salida_NO       		CHAR(1);
	DECLARE Salida_SI       		CHAR(1);

    DECLARE TipoOpePagCre			VARCHAR(3);
    DECLARE TipoMovDepVent			INT(11) DEFAULT 10;
    DECLARE TipoSocap				VARCHAR(10);
	DECLARE TipoSofipo				VARCHAR(10);
	DECLARE TipoSofom				VARCHAR(10);

    DECLARE TipoOpeCNBVOrdenPag		CHAR(2);

	-- Asignacion de Constantes
	SET Cadena_Vacia				:= '';				-- Cadena Vacia
    SET Decimal_Cero				:= 0.00;			-- Decimal Cero
	SET Entero_Cero					:= 0;				-- Entero cero
	SET Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacia
	SET NatAbono					:= 'A';				-- Naturaleza de la operacion: Abono.

    SET NombreDefaultSistema		:= 'SAFI';			-- Nombre DEFAULT del sistema
    SET Cons_NO						:= 'N';				-- Constante NO
	SET Cons_SI						:= 'S';				-- Constante SI
	SET Salida_NO          			:= 'N';				-- Parametro de Salida NO
	SET Salida_SI          			:= 'S';				-- Parametro de Salida SI

    SET TipoOpePagCre				:='09';				-- Tipo de operacion para pago de credito.
    SET TipoMovDepVent				:= 10;				-- Tipo de movimiento depósito en ventanilla.
    SET TipoSocap					:= 'scap';			-- Tipo SOCAP, corresponde a la tabla TIPOSINSTITUCION
    SET TipoSofipo					:= 'sofipo';		-- Tipo SOFIPO, corresponde a la tabla TIPOSINSTITUCION
	SET TipoSofom					:= 'sofom';			-- Tipo SOFOM, corresponde a la tabla TIPOSINSTITUCION

    SET TipoOpeCNBVOrdenPag			:= '07';			-- Tipo de Operacion de Acuerdo a Catalogo de CNBV: 07 Ordenes de Pago

	-- Asignacion de Variables
	SET Var_FechaSistema			:= Par_FechaOperacion;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr = 999;
			SET Par_ErrMen = LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-PLDOPERELEVUSUSERVPRO','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control = 'SQLEXCEPTION';
		END;

        -- SE OBTIENE LOS VALORRES DE LA INSTITUCION FINANCIERA
		SELECT
			Ins.NombreCorto,		Ins.TipoInstitID,	Tip.NombreCorto,	Par.MonedaBaseID,	DetecOpeRelevante,
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

		-- INICIO SI DETECTA OPERACIONES RELEVANTES
		IF(Var_DetecOpeRelevante = Cons_SI) THEN
			-- SE VALIDA QUE SEA ABONO
			SET Var_EsEfectivo := Cons_SI;

            -- INICIO SI ES EFECTIVO
			IF(IFNULL(Var_EsEfectivo, Cons_NO) = Cons_SI)THEN
				-- INICIO SI ES ABONO
				IF((Par_NatMovimiento = NatAbono)) THEN
					-- Obtener la Moneda Extranjera de acuerdo al parametro manejado para Operaciones Reelevantes
					-- Obtener el Tipo de Cambio DOF, de la moneda en que se expresa el limite de Op Reelevantes
					-- Obtener Tipo de Cambio del Dia anterior o la ultima capturada
					-- Tabla: PARAMETROSOPREL
					SET Var_MonedaLimOPR := (SELECT MonedaLimOPR FROM PARAMETROSOPREL);
					SET Var_LimiteInfOPR := (SELECT LimiteInferior FROM PARAMETROSOPREL);
					SET Var_LimiteInfOPR := ROUND((Var_LimiteInfOPR * FNGETTIPOCAMBIO(Var_MonedaLimOPR, 1, Var_FechaSistema)),2);

					-- SI EL MONTO DE LA OPERACION ES IGUAL O MAYOR QUE EL LIMITE DE OP. RELEVANTES, SE REGISTRA COMO DETECCION.
					IF(IFNULL(Par_MontoOperacion, Decimal_Cero) >= Var_LimiteInfOPR)THEN
						-- SE OBTIENE EL TIPO DE OPERACION DE ACUERDO A LA CNBV.
						SET Var_TipoOpeCNBV := TipoOpeCNBVOrdenPag;

						-- SI ES SOFOM ENTIDAD NO REGULADA ENTONCES SE ASIGNA LA CLAVE 09 PARA DEPOSITOS.
						IF(Var_NombreCorto = TipoSofom AND Var_EntidadRegulada = Cons_NO)THEN
							SET Var_TipoOpeCNBV := TipoOpePagCre;
						END IF;

						SET Var_TipoOpeCNBV := LPAD(Var_TipoOpeCNBV,2,"0");

						-- SE OBTIENE LA LOCALIDAD DE LA SUCURSAL DE LA OPERACION.
						SET Var_LocalidadSucursal := (SELECT MR.Localidad FROM MUNICIPIOSREPUB MR
														INNER JOIN SUCURSALES S ON MR.EstadoID = S.EstadoID AND MR.MunicipioID = S.MunicipioID
														WHERE SucursalID = Par_SucursalOpe LIMIT 1);

						SET Var_MonedaCNBV  := (SELECT EqCNBVUIF FROM MONEDAS WHERE MonedaID = Par_MonedaID);

						-- Codigo de la sucursal:
						-- Si es sofom se obtiene el codigo postal (de acuerdo al formato publicado en el DOF para sofomes.
						-- Si no es sofom, se obtiene la clave proporcionado por la CNBV (socaps y sofipos).
						SET Var_ClaveSuc := (SELECT IF(Var_NombreCorto = TipoSofom, CP, ClaveSucCNBV)
												FROM SUCURSALES
												WHERE SucursalID = Par_SucursalOpe);
						SET Var_ClaveSuc := IFNULL(Var_ClaveSuc, Entero_Cero);

						IF(Par_SucursalOpe = Entero_Cero)THEN
							SET Var_LocalidadSucursal := IFNULL(Var_LocalidadSucursal, Entero_Cero);
						END IF;

						-- FECHA Y HORA DE LA OPERACION
						SET Var_FechaOperacion	:= DATE(Par_FechaOperacion);
						SET Var_HoraOperacion	:= DATE_FORMAT(Aud_FechaActual,'%H:%i:%s');
						SET Var_DescripMov		:= LEFT(Par_DescripMov,100);

                        -- SE VALIDA SI EXISTEN REGISTROS REPETIDOS
                        SET Var_ExisteOperaReelev	:= (SELECT COUNT(OpeReelevanteID)
														FROM PLDOPEREELEVANT AS REV
														WHERE REV.SucursalID = Var_ClaveSuc AND REV.Fecha = Var_FechaOperacion AND
														REV.Hora = Var_HoraOperacion AND REV.UsuarioServicioID = Par_UsuarioServicioID AND
														REV.Monto = Par_MontoOperacion);

						SET Var_ExisteOperaReelev	:= IFNULL(Var_ExisteOperaReelev,Entero_Cero);

						-- SI NO EXISTEN REGISTROS REPETIDOS
						IF(Var_ExisteOperaReelev = Entero_Cero) THEN
								-- REGISTRO DE LA OPERACION REELEVANTE
								CALL PLDOPERELEVANTALT(
									Var_ClaveSuc,			Par_FechaOperacion,	Var_HoraOperacion,	Var_LocalidadSucursal,	Var_TipoOpeCNBV,
									Entero_Cero,			Entero_Cero,		Par_MontoOperacion,	Var_MonedaCNBV,			Var_DescripMov,
									Par_UsuarioServicioID,	Salida_NO,			Par_NumErr,			Par_ErrMen,				Var_OpeReelevanteID,
                                    Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
                                    Aud_Sucursal,			Aud_NumTransaccion);

								IF(Par_NumErr != Entero_Cero)THEN
									LEAVE ManejoErrores;
								END IF;
						END IF;
					END IF; -- FIN SI EL MONTO SUPERA EL LIMITE
				END IF; -- FIN SI ES ABONO
			END IF; -- FIN SI ES EFECTIVO
		END IF; -- FIN SI DETECTA OPERACIONES RELEVANTES

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= 'Proceso de Deteccion Op. Relevantes Finalizado Exitosamente.';
		SET Var_Control		:= 'opeReelevanteID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			IFNULL(Var_OpeReelevanteID, Entero_Cero) AS Consecutivo;
	END IF;

END TerminaStore$$