-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZASTESOREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZASTESOREPRO`;
DELIMITER $$

CREATE PROCEDURE `POLIZASTESOREPRO`(



    Par_Poliza          BIGINT,
    Par_Empresa         INT,
    Par_Fecha           DATE,
    Par_Instrumento     VARCHAR(20),
    Par_SucOperacion    INT,

    Par_ConceptoTeso    INT,
    Par_Cargos          DECIMAL(14,4),
    Par_Abonos          DECIMAL(14,4),
    Par_Moneda          INT,
    Par_TipoGastoID     INT,

    Par_ProveedorID     INT,
    Par_TipImpuestoID   INT,
    Par_InstitucionID   INT,
    Par_CuentaBancos    VARCHAR(20),
    Par_Descripcion     VARCHAR(100),

    Par_Referencia      VARCHAR(50),
    OUT Par_Consecutivo BIGINT,

    Par_Salida          CHAR(1),
	OUT Par_NumErr      INT,
	OUT Par_ErrMen      VARCHAR(400),

    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
)
TerminaStore: BEGIN


	DECLARE	Var_Instrumento     VARCHAR(20);
	DECLARE Var_Cuenta          VARCHAR(50);
	DECLARE Var_CentroCostosID  INT(11);
	DECLARE Var_Nomenclatura    VARCHAR(30);
	DECLARE Var_NomenclaturaCR  VARCHAR(3);
	DECLARE Var_CuentaMayor     VARCHAR(4);
	DECLARE	Var_NomenclaturaSO  INT;
	DECLARE	Var_SubCuentaTM     CHAR(3);
	DECLARE	Var_SubCuentaIF     CHAR(3);
	DECLARE	Var_SubCuentaTG     CHAR(3);
	DECLARE	Var_SubCuentaTP     CHAR(3);
	DECLARE	Var_SubCuentaTI     CHAR(3);


	DECLARE Var_Control	        VARCHAR(200);
	DECLARE	Var_Estatus			CHAR(1);
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Salida_SI 			CHAR(1);
	DECLARE Salida_NO  	    	CHAR(1);
	DECLARE	Cuenta_Vacia		CHAR(25);


	DECLARE	For_CueMayor		CHAR(3);
	DECLARE	For_Instit			CHAR(3);
	DECLARE	For_Moneda			CHAR(3);
	DECLARE	For_TipGasto		CHAR(3);
	DECLARE	For_Proveedor   	CHAR(3);
	DECLARE	For_TipImpues   	CHAR(3);
	DECLARE	For_SucOrigen   	CHAR(3);

	DECLARE	Procedimiento   	VARCHAR(20);
	DECLARE TipoInstrumentoID	INT(11);
	DECLARE Var_FolioUUID		VARCHAR(100);
	DECLARE Var_ProvRFC			VARCHAR(13);
	DECLARE Var_FactProv		VARCHAR(50);
	DECLARE Var_TipoPersona 	CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE PersonaFisica		CHAR(1);


	SET Cadena_Vacia    	:= '';
	SET Fecha_Vacia     	:= '1900-01-01';
	SET Entero_Cero     	:= 0;
	SET Salida_SI       	:= 'S';
	SET Cuenta_Vacia   	 	:= '0000000000000000000000000';
	SET Salida_NO       	:= 'N';

	SET For_CueMayor    	:= '&CM';
	SET For_Instit      	:= '&IF';
	SET For_Moneda      	:= '&TM';
	SET For_TipGasto    	:= '&TG';
	SET For_Proveedor   	:= '&TP';
	SET For_TipImpues   	:= '&TI';
	SET For_SucOrigen   	:= '&SO';

	SET Procedimiento		:= 'POLIZASTESOREPRO';
	SET TipoInstrumentoID 	:= 19;


	SET Par_NumErr  		:= Entero_Cero;
	SET Par_ErrMen  		:= Cadena_Vacia;

	SET	Var_Cuenta			:= '0000000000000000000000000';
	SET Var_Instrumento 	:= Par_Instrumento;

	SET Var_CentroCostosID	:= Entero_Cero;
	SET Decimal_Cero		:= 0.00;
	SET PersonaFisica		:= 'F';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-POLIZASTESOREPRO');
				SET Var_Control = 'sqlException';
			END;



		IF(Par_InstitucionID != Entero_Cero AND Par_CuentaBancos != Cadena_Vacia) THEN
			IF(Par_SucOperacion > Entero_Cero) THEN
				SELECT	CuentaCompletaID	INTO	Var_Cuenta
					FROM CUENTASAHOTESO
					WHERE	InstitucionID = Par_InstitucionID
					  AND	NumCtaInstit  = Par_CuentaBancos;

				SET Var_Cuenta		:= IFNULL(Var_Cuenta, Cuenta_Vacia);
				SET Var_CentroCostosID    := FNCENTROCOSTOS(Par_SucOperacion);
			ELSE
				SELECT	CuentaCompletaID,	CentroCostoID
				  INTO	Var_Cuenta, 		Var_CentroCostosID
					FROM CUENTASAHOTESO
					WHERE	InstitucionID = Par_InstitucionID
					  AND	NumCtaInstit  = Par_CuentaBancos;
				SET	Var_Cuenta     := IFNULL(Var_Cuenta, Cuenta_Vacia);
				SET Var_CentroCostosID   := IFNULL(Var_CentroCostosID, FNCENTROCOSTOS(Aud_Sucursal));
			END IF;
		ELSE

			SELECT	Nomenclatura,		Cuenta,				NomenclaturaCR
			  INTO	Var_Nomenclatura, 	Var_CuentaMayor, 	Var_NomenclaturaCR
				FROM CUENTASMAYORTESO Ctm
				WHERE	Ctm.ConceptoTesoID	= Par_ConceptoTeso;

			SET Var_Nomenclatura 	:= IFNULL(Var_Nomenclatura, Cadena_Vacia);
			SET Var_NomenclaturaCR 	:= IFNULL(Var_NomenclaturaCR, Cadena_Vacia);

			IF(Var_Nomenclatura = Cadena_Vacia) THEN
				SET Var_Cuenta := Cuenta_Vacia;
			ELSE

				IF(LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero) THEN
					SET Var_NomenclaturaSO := Par_SucOperacion;
					IF(Var_NomenclaturaSO != Entero_Cero) THEN
						SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
					END IF;
				ELSE
					SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
				END IF;

				SET Var_Cuenta := Var_Nomenclatura;

				IF(LOCATE(For_CueMayor, Var_Cuenta) > Entero_Cero) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
				END IF;


				IF(LOCATE(For_Moneda, Var_Cuenta) > Entero_Cero) THEN
					SELECT	SubCuenta	INTO	Var_SubCuentaTM
						FROM SUBCTAMONEDATESO Sub
						WHERE	Sub.MonedaID		= Par_Moneda
						  AND	Sub.ConceptoTesoID	= Par_ConceptoTeso;

					SET Var_SubCuentaTM := IFNULL(Var_SubCuentaTM, Cadena_Vacia);

					IF(Var_SubCuentaTM != Cadena_Vacia) THEN
						SET Var_Cuenta := REPLACE(Var_Cuenta, For_Moneda, Var_SubCuentaTM);
					END IF;
				END IF;


				IF(LOCATE(For_Instit, Var_Cuenta) > Entero_Cero) THEN
					SELECT	SubCuenta	INTO	Var_SubCuentaIF
						FROM SUBCTAINSFINTESO Sub
						WHERE	Sub.InstitucionID	= Par_InstitucionID
						  AND	Sub.ConceptoTesoID	= Par_ConceptoTeso;

					SET Var_SubCuentaIF := IFNULL(Var_SubCuentaIF, Cadena_Vacia);

					IF(Var_SubCuentaIF != Cadena_Vacia) THEN
						SET Var_Cuenta := REPLACE(Var_Cuenta, For_Instit, Var_SubCuentaIF);
					END IF;
				END IF;


				IF(LOCATE(For_TipGasto, Var_Cuenta) > Entero_Cero) THEN
					SELECT	SubCuenta	INTO	Var_SubCuentaTG
						FROM SUBCTATIPGASTESO Sub
						WHERE	Sub.TipoGastoID		= Par_TipoGastoID
						  AND	Sub.ConceptoTesoID	= Par_ConceptoTeso;

					SET Var_SubCuentaTG := IFNULL(Var_SubCuentaTG, Cadena_Vacia);

					IF(Var_SubCuentaTG != Cadena_Vacia) THEN
						SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipGasto, Var_SubCuentaTG);
					END IF;
				END IF;


				IF(LOCATE(For_Proveedor, Var_Cuenta) > Entero_Cero) THEN
					SELECT	SubCuenta	INTO	Var_SubCuentaTP
						FROM SUBCTAPROVETESO Sub
						WHERE	Sub.ProveedorID       = Par_ProveedorID
						AND		Sub.ConceptoTesoID    = Par_ConceptoTeso;

					SET Var_SubCuentaTP := IFNULL(Var_SubCuentaTP, Cadena_Vacia);

					IF(Var_SubCuentaTP != Cadena_Vacia) THEN
						SET Var_Cuenta := REPLACE(Var_Cuenta, For_Proveedor, Var_SubCuentaTP);
					END IF;
				END IF;


				IF(LOCATE(For_TipImpues, Var_Cuenta) > Entero_Cero) THEN
					SELECT	SubCuenta	INTO	Var_SubCuentaTI
						FROM SUBCTAIMPUESTESO Sub
						WHERE	Sub.TipImpuestoID     = Par_TipImpuestoID
						  AND	Sub.ConceptoTesoID    = Par_ConceptoTeso;

					SET Var_SubCuentaTI := IFNULL(Var_SubCuentaTI, Cadena_Vacia);

					IF(Var_SubCuentaTI != Cadena_Vacia) THEN
						SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipImpues, Var_SubCuentaTI);
					END IF;
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
			Var_Instrumento,	Par_Moneda,			Par_Cargos,			Par_Abonos,			Par_Descripcion,
			Par_Referencia,		Procedimiento,		TipoInstrumentoID,	Var_ProvRFC,		Decimal_Cero,
			Var_FolioUUID,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

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