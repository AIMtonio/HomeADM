-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZASACTIVOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZASACTIVOSPRO`;

DELIMITER $$
CREATE PROCEDURE `POLIZASACTIVOSPRO`(
	# =====================================================================================
	# ------- STORE PARA CREAR POLIZAS DE ACTIVOS ---------
	# =====================================================================================
	Par_Poliza          	BIGINT(20),				-- Num Poliza
	Par_Fecha           	DATE,					-- Fecha
	Par_Instrumento     	VARCHAR(20),			-- Instrumento ID activo (ACTIVOS)
	Par_SucOperacion    	INT(11),				-- Id de Sucursal
	Par_ConceptoActivoID 	INT(11),			    -- Concepto de Activos (CTASMAYORACTIVOS)

	Par_Cargos          	DECIMAL(14,4),			-- Monto del Cargo
	Par_Abonos          	DECIMAL(14,4),			-- Monto del Abono
	Par_TipoActivo      	INT(11),                -- Moneda: Tabla (TIPOSACTIVOS)
	Par_Moneda          	INT(11),                -- Moneda: Tabla (MONEDAS)
	Par_ProveedorID     	INT(11),                -- Tipo de Proveedor: Tabla (PROVEEDORES)

	Par_Descripcion     	VARCHAR(100),			-- Descripcion
	Par_Referencia     	 	VARCHAR(50),			-- Referencia

	Par_Salida          	CHAR(1),                -- Especifica si hay una salida o no la hay
	OUT Par_NumErr      	INT(11),                -- Para el control de Errores y retorno en store procedures
	OUT Par_ErrMen      	VARCHAR(400),           -- Para el control de Errores y retorno en store procedures

	Par_Empresa         	INT(11),				-- Num EmpresaID
	Aud_Usuario         	INT(11),				-- Parametro de auditoria ID del usuario
	Aud_FechaActual     	DATETIME,				-- Parametro de auditoria Fecha actual
	Aud_DireccionIP     	VARCHAR(15),			-- Parametro de auditoria Direccion IP
	Aud_ProgramaID      	VARCHAR(50),			-- Parametro de auditoria Programa
	Aud_Sucursal        	INT(11),				-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion  	BIGINT(20)  			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	--  Declaracion de Variables
	DECLARE Var_Control	        VARCHAR(200);	-- Variable de control
	DECLARE Var_Cuenta          VARCHAR(50);
	DECLARE Var_CentroCostosID  INT(11);
	DECLARE Var_Nomenclatura    VARCHAR(30);
	DECLARE Var_NomenclaturaCR  VARCHAR(3);

	DECLARE Var_CuentaMayor     VARCHAR(4);
	DECLARE	Var_NomenclaturaSO  INT(11);
	DECLARE	Var_SubCuentaTA     CHAR(15);
	DECLARE Var_SubCuentaCA		CHAR(15);
	DECLARE Var_FolioUUID		VARCHAR(100);
	DECLARE Var_ProvRFC			VARCHAR(13);

	DECLARE Var_FactProv		VARCHAR(50);
	DECLARE Var_TipoPersona 	CHAR(1);
	DECLARE	Var_NomenclaturaSC	INT(11);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Salida_SI 			CHAR(1);
	DECLARE Salida_NO  	    	CHAR(1);

	DECLARE	Cuenta_Vacia		CHAR(25);
	DECLARE	For_CueMayor		CHAR(3);
	DECLARE	For_SucOrigen   	CHAR(3);
	DECLARE For_TipoActivo		CHAR(3);
	DECLARE Cla_TipoActivo		CHAR(3);
	DECLARE	Procedimiento   	VARCHAR(20);

	DECLARE TipoInstrumentoID	INT(11);
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE PersonaFisica		CHAR(1);
	DECLARE	For_SucCliente		CHAR(3);

	/* Asignacion de Constantes */
	SET Cadena_Vacia    	:= '';									-- Constante Cadena Vacia.
	SET Fecha_Vacia     	:= '1900-01-01';						-- Constante Fecha Vacia.
	SET Entero_Cero     	:= 0;									-- Constante Entero Cero.
	SET Salida_SI       	:= 'S';									-- Salida SI.
	SET Salida_NO       	:= 'N';									-- Salida NO.

	SET Cuenta_Vacia   	 	:= '0000000000000000000000000';			-- Constante Cuenta Contable Vacia.
	SET For_CueMayor    	:= '&CM';								-- Nomenclatura &CM
	SET For_SucOrigen   	:= '&SO';								-- Nomenclatura &SO
	SET For_TipoActivo   	:= '&TA';								-- Nomenclatura &TA
	SET Cla_TipoActivo   	:= '&TS';								-- Nomenclatura &TS Clasificacion de Activo
	SET Procedimiento		:= 'POLIZASACTIVOSPRO';					-- Nombre Procedimiento

	SET TipoInstrumentoID 	:= 17; 									-- TIPO DE INTRUMENTO ????? TIPOINSTRUMENTOS
	SET Decimal_Cero		:= 0.0;
	SET PersonaFisica		:= 'F';
	SET	For_SucCliente		:= '&SA';								-- centro de costos cliente --

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-POLIZASACTIVOSPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET	Var_Cuenta			:= '0000000000000000000000000';			-- Cuenta
		SET Var_CentroCostosID	:= Entero_Cero;							-- Centro Costos Incial

		/* Seleccion de la Formula para evaluacion de la Cuenta Contable. */
		SELECT	Nomenclatura,		Cuenta,				NomenclaturaCC
		  INTO	Var_Nomenclatura, 	Var_CuentaMayor, 	Var_NomenclaturaCR
			FROM CTASMAYORACTIVOS Ctm
			WHERE	Ctm.ConceptoActivoID	= Par_ConceptoActivoID;

		-- Descripcion concepto activo
		SET Par_Descripcion :=(SELECT Descripcion FROM CONCEPTOSACTIVOS WHERE ConceptoActivoID = Par_ConceptoActivoID);

		SET Var_Nomenclatura 	:= IFNULL(Var_Nomenclatura, Cadena_Vacia);
		SET Var_NomenclaturaCR 	:= IFNULL(Var_NomenclaturaCR, Cadena_Vacia);

		IF(Var_Nomenclatura = Cadena_Vacia) THEN
			SET Var_Cuenta := Cuenta_Vacia;
		ELSE
			/* Formula: Por Centro de Costos; SUCURSAL ORIGINA EL MOVIMIENTO  */
			IF(LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero) THEN
				SET Var_NomenclaturaSO := Par_SucOperacion;

				IF(Var_NomenclaturaSO != Entero_Cero) THEN
					SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
				END IF;
			ELSE
				IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
					SET Var_NomenclaturaSC := (SELECT	SucursalID
													FROM  ACTIVOS
														WHERE ActivoID =Par_Instrumento);-- El istrumento trae el id del activo

					SET Var_NomenclaturaSC	:=IFNULL(Var_NomenclaturaSC,Entero_Cero );
					IF (Var_NomenclaturaSC != Entero_Cero) THEN
						SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
					END IF;

				ELSE
					SET Var_CentroCostosID:= FNCENTROCOSTOS(Aud_Sucursal);
				END IF;
			END IF;

			SET Var_Cuenta := Var_Nomenclatura;

			/* Formula: Por Cuenta de Mayor */
			IF(LOCATE(For_CueMayor, Var_Cuenta) > Entero_Cero) THEN
				SET Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
			END IF;

			/* Formula: Por Tipo de Activo */
			IF(LOCATE(For_TipoActivo, Var_Cuenta) > Entero_Cero) THEN
				SELECT	SubCuenta	INTO	Var_SubCuentaTA
					FROM SUBCTATIPOACTIVO Sub
					WHERE	Sub.TipoActivoID		= Par_TipoActivo
					  AND	Sub.ConceptoActivoID	= Par_ConceptoActivoID;

				SET Var_SubCuentaTA := IFNULL(Var_SubCuentaTA, Cadena_Vacia);

				IF(Var_SubCuentaTA != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipoActivo, Var_SubCuentaTA);
				END IF;
			END IF;

			/* Formula: SubCuenta por Clasificación de Activo */
			IF(LOCATE(Cla_TipoActivo, Var_Cuenta) > Entero_Cero) THEN
				SELECT	SubCuenta
				INTO	Var_SubCuentaCA
				FROM  SUBCTACLASIFACTIVO Sub
				WHERE Sub.TipoActivoID		= Par_TipoActivo
				  AND Sub.ConceptoActivoID	= Par_ConceptoActivoID;

				SET Var_SubCuentaCA := IFNULL(Var_SubCuentaCA, Cadena_Vacia);

				IF(Var_SubCuentaCA != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, Cla_TipoActivo, Var_SubCuentaCA);
				END IF;
			END IF;

		END IF;

		SET Var_FactProv := SUBSTRING(Par_Referencia,1,LOCATE('-',Par_Referencia)-1);
		SET Var_Cuenta := REPLACE(Var_Cuenta, '-', Cadena_Vacia);


		SELECT	FolioUUID	INTO	Var_FolioUUID
			FROM	FACTURAPROV
			WHERE	NoFactura 	= Var_FactProv
			  AND	ProveedorID = Par_ProveedorID
			LIMIT 1;


		SET Var_FolioUUID = IFNULL(Var_FolioUUID,Cadena_Vacia);
		SET Var_TipoPersona := (SELECT	TipoPersona	FROM	PROVEEDORES	WHERE	ProveedorID=Par_ProveedorID);

		IF(Var_TipoPersona = PersonaFisica) THEN
			SET Var_ProvRFC := (SELECT	RFC	FROM	PROVEEDORES	WHERE	ProveedorID = Par_ProveedorID);
		ELSE
			SET Var_ProvRFC := (SELECT	RFCpm	FROM	PROVEEDORES	WHERE	ProveedorID = Par_ProveedorID);
		END IF;


		CALL DETALLEPOLIZASALT(
			Par_Empresa,		Par_Poliza,			Par_Fecha, 			Var_CentroCostosID,	Var_Cuenta,
			Par_Instrumento,	Par_Moneda,			Par_Cargos,			Par_Abonos,			Par_Descripcion,
			Par_Referencia,		Procedimiento,		TipoInstrumentoID,	Var_ProvRFC,		Decimal_Cero,
			Var_FolioUUID,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
		);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET	Par_NumErr := 000;
		SET	Par_ErrMen := 'Poliza Tesoreria Aplicada.';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$