-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZASAHORROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZASAHORROPRO`;
DELIMITER $$

CREATE PROCEDURE `POLIZASAHORROPRO`(



	Par_Poliza			BIGINT,
	Par_Empresa			INT,
	Par_Fecha			DATE,
	Par_Cliente			INT,
	Par_ConceptoOpera	INT,

	Par_CuentaID		BIGINT,
	Par_Moneda			INT,
	Par_Cargos			DECIMAL(12,2),
	Par_Abonos			DECIMAL(12,2),
	Par_Descripcion		VARCHAR(100),
	Par_Referencia		VARCHAR(50),

	Par_Salida			CHAR(1),
	INOUT	Par_NumErr	INT,
	INOUT	Par_ErrMen	VARCHAR(400),

	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN


	DECLARE Var_Control	    	VARCHAR(100);
	DECLARE Var_Consecutivo		BIGINT(20);
	DECLARE	Var_TipoPersona		CHAR(1);
	DECLARE	Var_TipoCuenta		INT;
	DECLARE	Var_GeneraInteres	CHAR(1);
	DECLARE	Var_NomComple		VARCHAR(100);
	DECLARE	Var_Instrumento		VARCHAR(20);
	DECLARE Var_Cuenta			VARCHAR(50);
	DECLARE Var_CentroCostosID	INT(11);
	DECLARE Var_CuentaComple	CHAR(25);
	DECLARE Var_Nomenclatura	VARCHAR(30);
	DECLARE Var_NomenclaturaCR	VARCHAR(3);
	DECLARE Var_CuentaMayor		VARCHAR(4);
	DECLARE	Var_SubCuentaTP		CHAR(6);
	DECLARE	Var_SubCuentaTC		CHAR(2);
	DECLARE	Var_SubCuentaTR		CHAR(2);
	DECLARE	Var_SubCuentaTM		CHAR(2);
	DECLARE	Var_SubCuentaCL		VARCHAR(6);
	DECLARE	Var_NomenclaturaSO	INT(11);
	DECLARE	Var_NomenclaturaSC	INT(11);
	DECLARE	Var_ClasifCta		CHAR(1);


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Cuenta_Vacia		CHAR(12);
	DECLARE	Per_Fisica			CHAR(1);
	DECLARE	Per_Moral			CHAR(1);
	DECLARE	Ren_Si				CHAR(1);
	DECLARE	Ren_No				CHAR(1);
	DECLARE	Procedimiento		VARCHAR(20);
	DECLARE	For_CueMayor		CHAR(3);
	DECLARE	For_TipProduc		CHAR(3);
	DECLARE	For_TipRend			CHAR(3);
	DECLARE	For_TipCliente		CHAR(3);
	DECLARE	For_Moneda			CHAR(3);
	DECLARE	For_Clasif			CHAR(3);
	DECLARE	For_SucOrigen		CHAR(3);
	DECLARE	For_SucCliente		CHAR(3);
	DECLARE	Salida_SI			CHAR(1);
	DECLARE Salida_NO       	CHAR(1);
	DECLARE TipoInstrumentoID	INT(11);
	DECLARE Decimal_cero		DECIMAL(14,2);


	SET	Salida_SI			:= 'S';
	SET Salida_NO       	:= 'N';
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Cuenta_Vacia		:= '000000000000';
	SET	Entero_Cero			:= 0;
	SET	Per_Fisica			:= 'F';
	SET	Per_Moral			:= 'M';
	SET	Ren_Si				:= 'S';
	SET	Ren_No				:= 'N';
	SET	For_CueMayor		:= '&CM';
	SET	For_TipProduc		:= '&TP';
	SET	For_TipRend			:= '&TR';
	SET	For_TipCliente		:= '&TC';
	SET	For_Moneda			:= '&TM';
	SET	For_Clasif			:= '&CL';
	SET	For_SucOrigen		:= '&SO';
	SET	For_SucCliente		:= '&SC';
	SET TipoInstrumentoID	:=	2;
	SET	Procedimiento		:= 'POLIZASAHORROPRO';
	SET Var_Instrumento 	:= CONVERT(Par_CuentaID, CHAR);
	SET Var_CentroCostosID	:= 0;
	SET Decimal_cero		:= 0.00;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-POLIZASAHORROPRO');
				SET Var_Control = 'sqlException';
			END;

		SELECT	Nomenclatura,		Cuenta,				NomenclaturaCR
		  INTO	Var_Nomenclatura,	Var_CuentaMayor,	Var_NomenclaturaCR
			FROM CUENTASMAYORAHO Ctm
			WHERE	Ctm.ConceptoAhoID = Par_ConceptoOpera;

		SET Var_Nomenclatura 	:= IFNULL(Var_Nomenclatura, Cadena_Vacia);
		SET Var_NomenclaturaCR 	:= IFNULL(Var_NomenclaturaCR, Cadena_Vacia);

		IF(Var_Nomenclatura = Cadena_Vacia) THEN
			SET Var_Cuenta := Cuenta_Vacia;
		 ELSE

			SET Var_Cuenta	:= Var_Nomenclatura;

			SELECT	Tip.TipoCuentaID,	Tip.GeneraInteres,	Tip.ClasificacionConta
			  INTO	Var_TipoCuenta,		Var_GeneraInteres,	Var_ClasifCta
				FROM CUENTASAHO Cue,
					TIPOSCUENTAS Tip
				WHERE	Cue.CuentaAhoID  = Par_CuentaID
				  AND	Cue.TipoCuentaID = Tip.TipoCuentaID;

			SET Var_ClasifCta := IFNULL(Var_ClasifCta, Cadena_Vacia);

			IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
				SET Var_NomenclaturaSO := IFNULL(Aud_Sucursal, Entero_Cero);
				IF (Var_NomenclaturaSO != Entero_Cero) THEN
					SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
				END IF;

			ELSE
				IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
					SET Var_NomenclaturaSC 	:= (SELECT	SucursalOrigen	FROM	CLIENTES WHERE ClienteID = Par_Cliente);
					SET Var_NomenclaturaSC	:= IFNULL(Var_NomenclaturaSC,Entero_Cero );
					IF (Var_NomenclaturaSC 	!= Entero_Cero) THEN
						SET Var_CentroCostosID 	:= FNCENTROCOSTOS(Var_NomenclaturaSC);
					END IF;

				ELSE
					SET Var_CentroCostosID:= FNCENTROCOSTOS(Aud_Sucursal);
				END IF;
			END IF;


			IF LOCATE(For_CueMayor, Var_Cuenta) > Entero_Cero THEN
				SET Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
			END IF;


			IF LOCATE(For_TipProduc, Var_Cuenta) > Entero_Cero THEN
				SELECT	SubCuenta	INTO	Var_SubCuentaTP
					FROM SUBCTATIPROAHO Sub
					WHERE	Sub.TipoProductoID	= Var_TipoCuenta
					  AND	Sub.ConceptoAhoId	= Par_ConceptoOpera;

				SET Var_SubCuentaTP := IFNULL(Var_SubCuentaTP, Cadena_Vacia);

				IF (Var_SubCuentaTP != Cadena_Vacia) THEN
					SET Var_Cuenta 	:= REPLACE(Var_Cuenta, For_TipProduc, Var_SubCuentaTP);
				END IF;
			END IF;


			IF LOCATE(For_Clasif, Var_Cuenta) > Entero_Cero THEN
				SELECT	SubCuenta	INTO	Var_SubCuentaCL
					FROM SUBCTACLASIFAHO Sub
					WHERE	Sub.Clasificacion	= Var_ClasifCta
					  AND	Sub.ConceptoAhoId	= Par_ConceptoOpera;

				SET Var_SubCuentaCL := IFNULL(Var_SubCuentaCL, Cadena_Vacia);

				IF (Var_SubCuentaCL != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_Clasif, Var_SubCuentaCL);
				END IF;
			END IF;


			IF LOCATE(For_Moneda, Var_Cuenta) > Entero_Cero THEN
				SELECT	SubCuenta	INTO	Var_SubCuentaTM
					FROM SUBCTAMONEDAAHO Sub
					WHERE	Sub.MonedaID		= Par_Moneda
					  AND	Sub.ConceptoAhoId	= Par_ConceptoOpera;

				SET Var_SubCuentaTM := IFNULL(Var_SubCuentaTM, Cadena_Vacia);

				IF (Var_SubCuentaTM != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_Moneda, Var_SubCuentaTM);
				END IF;
			END IF;


			IF LOCATE(For_TipRend, Var_Cuenta) > Entero_Cero THEN
				IF Var_GeneraInteres = Ren_Si THEN
					SELECT	Paga	INTO	Var_SubCuentaTR
						FROM SUBCTARENDIAHO Sub
						WHERE	Sub.ConceptoAhoId	= Par_ConceptoOpera;
				ELSE
					SELECT	NoPaga	INTO	Var_SubCuentaTR
						FROM SUBCTARENDIAHO Sub
						WHERE	Sub.ConceptoAhoId	= Par_ConceptoOpera;
				END IF;

				SET Var_SubCuentaTR := IFNULL(Var_SubCuentaTR, Cadena_Vacia);

				IF (Var_SubCuentaTR != Cadena_Vacia) then
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipRend, Var_SubCuentaTR);
				END IF;
			END IF;


			IF LOCATE(For_TipCliente, Var_Cuenta) > Entero_Cero THEN
				SELECT	TipoPersona		INTO	Var_TipoPersona
					FROM CLIENTES
					WHERE	ClienteID = Par_Cliente;

				IF Var_TipoPersona = Per_Fisica THEN
					SELECT	Fisica		INTO	Var_SubCuentaTC
						FROM SUBCTATIPERAHO Sub
						WHERE	Sub.ConceptoAhoId	= Par_ConceptoOpera;
				ELSE
					SELECT	Moral	INTO	Var_SubCuentaTC
						FROM SUBCTATIPERAHO Sub
						WHERE	Sub.ConceptoAhoId	= Par_ConceptoOpera;
				END IF;

				SET Var_SubCuentaTC := IFNULL(Var_SubCuentaTC, Cadena_Vacia);

				IF (Var_SubCuentaTC != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipCliente, Var_SubCuentaTC);
				END IF;
			END IF;
		END IF;

		SET Var_Cuenta = REPLACE(Var_Cuenta, '-', Cadena_Vacia);

		CALL DETALLEPOLIZASALT (
			Par_Empresa,		Par_Poliza,			Par_Fecha, 			Var_CentroCostosID,		Var_Cuenta,
			Var_Instrumento,	Par_Moneda,			Par_Cargos,			Par_Abonos,			Par_Descripcion,
			Par_Referencia,		Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,		Decimal_cero,
			Cadena_Vacia,		Salida_NO, 			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT('Transacción Realizada Exitosamente: ', CONVERT(Par_Poliza, CHAR));
		SET Var_Control	:= 'cuentaAhoID' ;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$