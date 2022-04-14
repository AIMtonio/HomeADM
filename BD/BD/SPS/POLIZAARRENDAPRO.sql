-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZAARRENDAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZAARRENDAPRO`;
DELIMITER $$

CREATE PROCEDURE `POLIZAARRENDAPRO`(
  -- SP QUE SE UTILIZA PARA DAR DE ALTA UN DETALLE DE POLIZA DEL MODULO DE ARRENDAMIENTOS
	Par_Poliza					BIGINT,				-- Numero de poliza al que se le insertara el detalle
	Par_Fecha					DATE, 				-- Fecha del detalle de poliza
	Par_TipoArrenda				VARCHAR(1), 		-- Tipo de arrendamiento (financiado o puro)
	Par_ProductoArrendaID		INT(11), 			-- Corresponde con el tipo de producto
	Par_ConceptoOpera 			INT, 				-- Concepto de operacion, corresponde con la tabla CONCEPTOSARRENDA

	Par_ArrendaID				BIGINT(12),			-- ID de arrendamiento
	Par_Cliente					INT(11),			-- ID del cliente
	Par_MonedaID 				INT(11), 			-- Moneda o Divisa
	Par_Cargos					DECIMAL(12,4),		-- Monto del Cargo
	Par_Abonos					DECIMAL(12,4),		-- Monto del Abonos

	Par_Descripcion				VARCHAR(100),		-- Descripcion de la Poliza
	Par_Referencia 				VARCHAR(50), 		-- Referencia de la Poliza
	Par_Plazo  					CHAR(1), 			-- Plazo C = corto L = largo
	Par_SucursalID 				INT(11),            -- Sucursal
	Par_Salida 					CHAR(1),			-- Salida Si o No

	INOUT Par_NumErr			INT(11),			-- Control de Errores: Numero de Error o exito
	INOUT Par_ErrMen 			VARCHAR(400),		-- Control de Errores: Descripcion del Error o exito
	Aud_EmpresaID 				INT(11),			-- Parametros de Auditoria
	Aud_Usuario 				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametros de Auditoria

	Aud_DireccionIP 			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal  				INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion 			BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN

	/* DECLARACION DE VARIABLES */
	DECLARE Var_Nomenclatura		VARCHAR(30); 	/* Guarda la nomenclatura de la cuenta contable */
	DECLARE Var_NomenclaturaCR		VARCHAR(3);		/* Guarda la nomenclatura del centro de costos  */
	DECLARE Var_CuentaMayor			VARCHAR(4);		/* Guarda la cuenta  mayor  */
	DECLARE Var_Cuenta				VARCHAR(50);	/* Guarda el numero de cuenta contable */
	DECLARE Var_SubCuentaPA			VARCHAR(6);		/* Valor de la subcuenta producto arrendamiento */
	DECLARE Var_SubCuentaTA			VARCHAR(6);		/* Valor de la subcuenta tipo de arrendamiento */
	DECLARE Var_SubCuentaSM 		VARCHAR(6);		/* Valor de la subcuenta moneda */
	DECLARE Var_SubCuentaSS			VARCHAR(6);		/* Valor de la subcuenta sucursal */
	DECLARE Var_SubCuentaSP			VARCHAR(6);		/* Valor de la subcuenta plazo */
	DECLARE Var_CentroCostosID		INT(11);		/*  Centro de Costos */
	DECLARE Var_NomenclaturaSO		INT(11);		-- Nomenclatura del centro de costos origne
	DECLARE Var_NomenclaturaSC		INT(11);		-- Nomenclatura del centro de costos del cliente

	/* DECLARACION DE CONSTANTES */
	DECLARE Cadena_Vacia			VARCHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia				DATE;			-- Fecha vacia
	DECLARE Entero_Cero				INT;			-- Entero cero
	DECLARE Cuenta_Vacia			VARCHAR(30);	-- Cuenta vacia
	DECLARE VarProcedimiento		VARCHAR(20);	-- Procedimiento

	DECLARE For_CueMayor			VARCHAR(3);		/* Formula de Cuenta Mayor*/
	DECLARE For_Producto 			VARCHAR(3);		/* Formula de Producto de arrendamiento */
	DECLARE For_Tipo				VARCHAR(3);		/* Formula de Tipo de Arrendamiento  */
	DECLARE For_Moneda				VARCHAR(3);		/* Formula de Moneda */
	DECLARE For_Sucursal 			VARCHAR(3);		/* Formula de Sucursal */
	DECLARE For_Plazo 				VARCHAR(3);		/* Formula de Plazo */
	DECLARE For_SucOrigen 			CHAR(3);		-- FORMULA SUCURSAL ORIGEN
	DECLARE For_SucCliente			CHAR(3);		-- FORMULA SUCURSAL CLIENTE

	DECLARE VarSubCtaProducto 		CHAR(6);		-- Subcuenta de producto
	DECLARE VarSubCtaTipo			CHAR(6);		-- Subcuenta de tipo
	DECLARE VarSubCtaMoneda			CHAR(6);		-- Subcuenta de moneda
	DECLARE VarSubCtaSucursal		CHAR(6);		-- Subcuenta de sucursal
	DECLARE VarSubCtaPlazo			CHAR(6);		-- Subcuenta de plazo

	DECLARE Salida_NO				VARCHAR(1);		-- Salida no
	DECLARE Salida_SI				VARCHAR(1);		-- Salida si
	DECLARE Var_Control				VARCHAR(50);	-- variable de control
	DECLARE VarTipoInstruID			INT(11);		-- Tipo de Intrumento ID

	/* ASIGNACION DE CONSTANTES */
	SET Salida_NO 			:= 'N'; 				/* Indica que no habra una salida */
	SET Salida_SI			:= 'S'; 				/* Indica que  habra una salida */

	SET Cadena_Vacia 		:= ''; 					/* Cadena vacia */
	SET Fecha_Vacia			:= '1900-01-01'; 		/* Fecha Vacia */
	SET Entero_Cero 		:= 0; 					/* Entero en Cero */
	SET Cuenta_Vacia		:= '000000000000000';	/* Numero de cuenta vacia*/

	SET For_CueMayor		:= '&CM'; 				/* Formula de Cuenta Mayor*/
	SET For_Producto 		:= '&PA';				/* Formula de Producto de arrendamiento */
	SET For_Tipo			:= '&TA';				/* Formula de Tipo de Arrendamiento  */
	SET For_Moneda 			:= '&SM'; 				/* Formula de Moneda */
	SET For_Sucursal		:= '&SS';				/* Formula de sucursal*/
	SET For_Plazo 			:= '&SP';				/* Formula de plazo */
	SET For_SucOrigen 		:= '&SO';				-- Centro de costos origen
	SET For_SucCliente 		:= '&SC'; 				-- centro de costos cliente

	SET VarProcedimiento	:= 'POLIZAARRENDAPRO';	/*Nombre del SP*/
	SET VarTipoInstruID		:= 29;					-- Tipo Instrumento ARRENDAMIENTO .- TABLA TIPOINSTRUMENTOS

	SET Aud_FechaActual		:= NOW();
	SET Var_CentroCostosID	:= 0;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										 'Disculpe las molestias que esto le ocasiona. Ref: SP-POLIZAARRENDAPRO');
				SET Var_Control = 'sqlException';
			END;

		/* Se guardan los valores de la cuenta de mayor */
		SELECT	Nomenclatura,		Cuenta,				NomenclaturaCR
		INTO	Var_Nomenclatura,	Var_CuentaMayor,	Var_NomenclaturaCR
			FROM  CUENTASMAYORARRENDA Ctm
			WHERE	Ctm.ConceptoArrendaID = Par_ConceptoOpera;

		/* si los valores son nulos se asigna un vacio */
		SET Var_Nomenclatura	:= IFNULL(Var_Nomenclatura, Cadena_Vacia);
		SET Var_NomenclaturaCR 	:= IFNULL(Var_NomenclaturaCR, Cadena_Vacia);
		SET Var_CuentaMayor		:= IFNULL(Var_CuentaMayor, Cadena_Vacia);

		IF(Var_Nomenclatura = Cadena_Vacia) THEN/* si la nomenclatura no tiene valor se asigna la cuenta vacia */
			SET Var_Cuenta  := Cuenta_Vacia;
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'La Nomenclatura de la Cuenta esta Vacia';
			LEAVE ManejoErrores;
		END IF;

		SET Var_Cuenta	:= Var_Nomenclatura;

		/*SE BUSCA LA NOMENCLATURA DEL CENTRO DE COSTOS */
		IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
			SET Var_NomenclaturaSO	:= IFNULL(Aud_Sucursal, Entero_Cero);

			IF (Var_NomenclaturaSO != Entero_Cero) THEN
				SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_NomenclaturaSO);
			END IF;
		ELSE
			IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
				SET Var_NomenclaturaSC	:= (SELECT  SucursalOrigen FROM  CLIENTES WHERE ClienteID =Par_Cliente);
				SET Var_NomenclaturaSC	:=IFNULL(Var_NomenclaturaSC,Entero_Cero );
				IF (Var_NomenclaturaSC != Entero_Cero) THEN
					SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_NomenclaturaSC);
				END IF;
			ELSE
				SET Var_CentroCostosID	:= FNCENTROCOSTOS(Aud_Sucursal) ;
			END IF;
		END IF;


		/* si se encuentra la formula de cuenta mayor entonces se reemplaza por el valor que
			le corresponde */
		IF LOCATE(For_CueMayor, Var_Cuenta) > 0 THEN
			SET Var_Cuenta	:= REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
		END IF;

		/* Si se encuentra en la formula la subcuenta por producto de arrendamiento  se reemplaza por el valor que
			le corresponde */
		IF LOCATE(For_Producto, Var_Cuenta) > 0 THEN
			SELECT	SubCuenta
			INTO	VarSubCtaProducto
				FROM  SUBCTATIPROARRENDA Sub
				WHERE	Sub.ConceptoArrendaID = Par_ConceptoOpera
				AND	Sub.ProductoArrendaID = Par_ProductoArrendaID;

			SET VarSubCtaProducto	:= IFNULL(VarSubCtaProducto, Cadena_Vacia);

			IF (VarSubCtaProducto != Cadena_Vacia) THEN
				SET Var_Cuenta	:= REPLACE(Var_Cuenta, For_Producto, VarSubCtaProducto);
			END IF;
		END IF;

		/* Si se encuentra en la formula la subcuenta POR TIPO DE ARRENDAMIENTO  se reemplaza por el valor que
			le corresponde */
		IF LOCATE(For_Tipo, Var_Cuenta) > 0 THEN
			SELECT	SubCuenta
			INTO	VarSubCtaTipo
				FROM  SUBCTATIPOARRENDA Sub
				WHERE	Sub.ConceptoArrendaID = Par_ConceptoOpera
				AND	Sub.TipoArrenda       = Par_TipoArrenda;

			SET VarSubCtaTipo	:= IFNULL(VarSubCtaTipo, Cadena_Vacia);
			IF (VarSubCtaTipo != Cadena_Vacia) THEN
				SET Var_Cuenta	:= REPLACE(Var_Cuenta, For_Tipo, VarSubCtaTipo);
			END IF;
		END IF;

		/* Si se encuentra en la formula la subcuenta DE MONEDA se reemplaza por el valor que
			le corresponde */
		IF LOCATE(For_Moneda, Var_Cuenta) > 0 THEN
			SELECT	SubCuenta
			INTO	VarSubCtaMoneda
				FROM  SUBCTAMONEDARRENDA Sub
				WHERE	Sub.ConceptoArrendaID = Par_ConceptoOpera
				AND 	Sub.MonedaID          = Par_MonedaID;

			SET VarSubCtaMoneda	:= IFNULL(VarSubCtaMoneda, Cadena_Vacia);
			IF (VarSubCtaMoneda != Cadena_Vacia) THEN
				SET Var_Cuenta	:= REPLACE(Var_Cuenta, For_Moneda, VarSubCtaMoneda);
			END IF;
		END IF;

		/* si se encuentra en la formula la subcuenta DE SUCURSAL se reemplaza por el valor que
			le corresponde */
		IF LOCATE(For_Sucursal, Var_Cuenta) > 0 THEN
			SELECT	SubCuenta
			INTO	VarSubCtaSucursal
				FROM  SUBCTASUCURARRENDA Sub
				WHERE	Sub.ConceptoArrendaID = Par_ConceptoOpera
				AND	Sub.SucursalID        = Par_SucursalID;

			SET VarSubCtaSucursal	:= IFNULL(VarSubCtaSucursal, Cadena_Vacia);
			IF (VarSubCtaSucursal != Cadena_Vacia) THEN
				SET Var_Cuenta	:= REPLACE(Var_Cuenta, For_Sucursal, VarSubCtaSucursal);
			END IF;
		END IF;

		/* si se encuentra en la formula la subcuenta DE PLAZO se reemplaza por el valor que
		le corresponde */
		IF LOCATE(For_Plazo, Var_Cuenta) > 0 THEN
			SELECT	SubCuenta
			INTO	VarSubCtaPlazo
				FROM  SUBCTAPLAZOARRENDA Sub
				WHERE	Sub.ConceptoArrendaID = Par_ConceptoOpera
				AND	Sub.Plazo             = Par_Plazo;

			SET VarSubCtaPlazo	:= IFNULL(VarSubCtaPlazo, Cadena_Vacia);
			IF (VarSubCtaPlazo != Cadena_Vacia) THEN
				SET Var_Cuenta	:= REPLACE(Var_Cuenta, For_Plazo, VarSubCtaPlazo);
			END IF;
		END IF;



		SET Var_Cuenta	:= REPLACE(Var_Cuenta, '-', Cadena_Vacia); /* se reemplazan los guiones por vacios */

		/* se hace la llamada al detalle de poliza */
		CALL DETALLEPOLIZAALT(
			Aud_EmpresaID,		Par_Poliza,			Par_Fecha,			Var_CentroCostosID, 	Var_Cuenta,
			Par_ArrendaID,		Par_MonedaID,		Par_Cargos,			Par_Abonos,			Par_Descripcion,
			Par_Referencia,		VarProcedimiento,	VarTipoInstruID, 	Cadena_Vacia, 		Entero_Cero,
			Cadena_Vacia,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,  	Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

		IF(IFNULL(Par_NumErr, Entero_Cero)!= Entero_Cero )THEN
			SET Par_ErrMen	:= CONCAT(Par_ErrMen,': ',Var_Cuenta);
			IF(IFNULL(Par_NumErr, Entero_Cero)!= 5 AND IFNULL(Par_NumErr, Entero_Cero)!= 2 )THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Poliza Agregada Exitosamente';

	END ManejoErrores;

		-- Se muestran los datos
	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr   AS NumErr,
				Par_ErrMen   AS ErrMen,
				Var_Control  AS Control,
				Par_Poliza   AS Consecutivo;
	END IF;

END TerminaStore$$