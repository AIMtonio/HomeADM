-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZASDIVISAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZASDIVISAPRO`;
DELIMITER $$

CREATE PROCEDURE `POLIZASDIVISAPRO`(



	Par_Poliza          BIGINT,
    Par_SucursalID      INT,
    Par_CajaID          INT,
    Par_Empresa         INT(11),
    Par_Fecha           DATE,

    Par_TipoOpe         CHAR(1),
    Par_ConceptoOpera   INT,
    Par_MonedaID        INT,
    Par_Cargos          DECIMAL(12,2),
    Par_Abonos          DECIMAL(12,2),

    Par_Instrumento     VARCHAR(20),
    Par_Descripcion     VARCHAR(150),
    Par_Referencia      VARCHAR(200),
	Par_SucursalCte		INT(11),

	Par_Salida          CHAR(1),
	INOUT Par_NumErr 	INT(11),
	INOUT Par_ErrMen  	VARCHAR(400),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT
		)
TerminaStore: BEGIN


	DECLARE Procedimiento      		VARCHAR(20);
	DECLARE Var_Cuenta         		CHAR(50);
	DECLARE Var_CentroCostosID      INT(11);
	DECLARE Var_Nomenclatura   		VARCHAR(30);
	DECLARE Var_NomenclaturaCR 		VARCHAR(3);
	DECLARE Var_NomenclaturaSO		INT;
	DECLARE Var_CuentaMayor			VARCHAR(10);
	DECLARE Var_SubCuentaTM			VARCHAR(15);
	DECLARE Var_SubCuentaTP			VARCHAR(15);
	DECLARE Var_SubBillete			VARCHAR(15);
	DECLARE Var_SubMoneda      		VARCHAR(15);
	DECLARE Var_SubCuentaSuc   		VARCHAR(15);
	DECLARE Var_SubCuentaCaja  		VARCHAR(15);
	DECLARE Var_SubCuentaTipo  		VARCHAR(15);
	DECLARE Var_TipoCaja       		CHAR(2);
	DECLARE Var_TipoInstrumentoID	INT(11);
	DECLARE Var_NomenclaturaSC		CHAR(2);
	DECLARE Var_Control	    		VARCHAR(100);


	DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Fecha_Vacia     		DATE;
	DECLARE Entero_Cero     		INT;
	DECLARE Tipo_Moneda     		CHAR(1);
	DECLARE Tipo_Billete    		CHAR(1);
	DECLARE For_CueMayor    		CHAR(3);
	DECLARE For_Moneda      		CHAR(3);
	DECLARE For_Tipo        		CHAR(3);
	DECLARE For_TipoCaja    		CHAR(3);
	DECLARE For_Cajero      		CHAR(3);
	DECLARE For_Sucursal    		CHAR(3);
	DECLARE For_SucOrigen   		CHAR(3);
	DECLARE	For_SucCliente			CHAR(3);
	DECLARE Salida_NO       		CHAR(1);
	DECLARE Salida_SI       		CHAR(1);
	DECLARE Cuenta_Vacia    		CHAR(25);

	DECLARE Caja_Principal  		CHAR(2);
	DECLARE Caja_Atencion   		CHAR(2);
	DECLARE Caja_Boveda     		CHAR(2);
	DECLARE Decimal_Cero			DECIMAL(18,2);


	SET Cadena_Vacia    := '';
	SET Fecha_Vacia     := '1900-01-01';
	SET Entero_Cero     := 0;
	SET Tipo_Moneda     := 'M';
	SET Tipo_Billete    := 'B';
	SET For_CueMayor    := '&CM';
	SET For_Moneda      := '&TM';
	SET For_Tipo        := '&TP';
	SET For_TipoCaja    := '&TC';
	SET For_Cajero      := '&CA';
	SET For_Sucursal    := '&SU';
	SET For_SucOrigen   := '&SO';
	SET	For_SucCliente	:= '&SC';
	SET Caja_Principal  := 'CP';
	SET Caja_Atencion   := 'CA';
	SET Caja_Boveda     := 'BG';

	SET Salida_NO       := 'N';
	SET Salida_SI		:= 'S';
	SET Cuenta_Vacia    := '0000000000000000000000000';
	SET Decimal_Cero	:= 0.0;

	SET	Procedimiento	:= 'POLIZADIVISAPRO';
	SET	Var_Cuenta		:= Cuenta_Vacia;
	SET Var_TipoInstrumentoID	:=15;
	SET Var_CentroCostosID := 0;

    ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-POLIZASDIVISAPRO');
				SET Var_Control = 'sqlException';
			END;

		SELECT	Nomenclatura, 		Cuenta, 			NomenclaturaCR
		  INTO	Var_Nomenclatura, 	Var_CuentaMayor, 	Var_NomenclaturaCR
		  FROM CUENTASMAYORMON Ctm
		 WHERE	Ctm.ConceptoMonID	= Par_ConceptoOpera;

		SET Var_Nomenclatura 	:= IFNULL(Var_Nomenclatura, Cadena_Vacia);
		SET Var_NomenclaturaCR 	:= IFNULL(Var_NomenclaturaCR, Cadena_Vacia);


		IF(Var_Nomenclatura = Cadena_Vacia) THEN
			SET Var_Cuenta := Cuenta_Vacia;
		ELSE
			SET Var_Cuenta	:= Var_Nomenclatura;

			IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
				SET Var_NomenclaturaSO := Aud_Sucursal;
				IF (Var_NomenclaturaSO != Entero_Cero) THEN
					SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
				END IF;
			ELSE
				IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
					SET Var_NomenclaturaSC := Par_SucursalCte;
					IF (Var_NomenclaturaSC != Cadena_Vacia AND Var_NomenclaturaSC != Entero_Cero ) THEN
						SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
					ELSE
						SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
					END IF;
				ELSE
					SET Var_CentroCostosID:=FNCENTROCOSTOS(Aud_Sucursal);
				END IF;
			END IF;


			IF LOCATE(For_CueMayor, Var_Cuenta) > Entero_Cero THEN
				SET Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
			END IF;


			IF LOCATE(For_Moneda, Var_Cuenta) > Entero_Cero THEN
				SELECT	SubCuenta INTO Var_SubCuentaTM
					FROM SUBCTAMONEDADIV Sub
					WHERE	Sub.MonedaID		= Par_MonedaID
					  AND	Sub.ConceptoMonID	= Par_ConceptoOpera;

				SET Var_SubCuentaTM := IFNULL(Var_SubCuentaTM, Cadena_Vacia);

				IF (Var_SubCuentaTM != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_Moneda, Var_SubCuentaTM);
				END IF;
			END IF;


			IF LOCATE(For_Tipo, Var_Cuenta) > Entero_Cero THEN
				SELECT	Billetes, Monedas INTO Var_SubBillete, Var_SubMoneda
					FROM SUBCTATIPODIV Sub
					WHERE	Sub.ConceptoMonID	= Par_ConceptoOpera;

				IF(Par_TipoOpe = Tipo_Moneda) THEN
					SET	Var_SubCuentaTP := Var_SubMoneda;
				ELSEIF (Par_TipoOpe = Tipo_Billete) THEN
					SET	Var_SubCuentaTP := Var_SubBillete;
				ELSE
					SET	Var_SubCuentaTP := Cadena_Vacia;
				END IF;

				SET Var_SubCuentaTP := IFNULL(Var_SubCuentaTP, Cadena_Vacia);

				IF (Var_SubCuentaTP != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_Tipo, Var_SubCuentaTP);
				END IF;
			END IF;


			IF LOCATE(For_Sucursal, Var_Cuenta) > Entero_Cero THEN
				SELECT	SubCuenta INTO Var_SubCuentaSuc
					FROM SUBCTASUCURSDIV Sub
					WHERE	Sub.SucursalID		= Par_SucursalID
					  AND	Sub.ConceptoMonID	= Par_ConceptoOpera;

				SET Var_SubCuentaSuc := IFNULL(Var_SubCuentaSuc, Cadena_Vacia);

				IF (Var_SubCuentaSuc != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_Sucursal, Var_SubCuentaSuc);
				END IF;
			END IF;


			IF LOCATE(For_Cajero, Var_Cuenta) > Entero_Cero THEN
				SELECT SubCuenta INTO Var_SubCuentaCaja
					FROM SUBCTACAJERODIV Sub
					WHERE	Sub.CajaID        = Par_CajaID
					  AND	Sub.ConceptoMonID = Par_ConceptoOpera;

				SET Var_SubCuentaCaja := IFNULL(Var_SubCuentaCaja, Cadena_Vacia);

				IF (Var_SubCuentaCaja != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_Cajero, Var_SubCuentaCaja);
				END IF;
			END IF;


			IF LOCATE(For_TipoCaja, Var_Cuenta) > Entero_Cero THEN

				SELECT	TipoCaja INTO Var_TipoCaja
					FROM CAJASVENTANILLA Sub
					WHERE	Sub.CajaID        = Par_CajaID
					  AND	Sub.SucursalID    = Par_SucursalID;

				SET Var_TipoCaja := IFNULL(Var_TipoCaja, Cadena_Vacia);

				SELECT	SubCuenta INTO Var_SubCuentaTipo
					FROM SUBCTATIPCAJADIV Sub
					WHERE	Sub.TipoCaja      = Var_TipoCaja
					  AND	Sub.ConceptoMonID = Par_ConceptoOpera;

				SET Var_SubCuentaTipo := IFNULL(Var_SubCuentaTipo, Cadena_Vacia);

				IF (Var_SubCuentaTipo != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipoCaja, Var_SubCuentaTipo);
				END IF;
			END IF;
		END IF;

		SET Var_Cuenta = REPLACE(Var_Cuenta, '-', Cadena_Vacia);

		CALL DETALLEPOLIZASALT(
			Par_Empresa,			Par_Poliza,			Par_Fecha, 				Var_CentroCostosID,		Var_Cuenta,
			Par_Instrumento,		Par_MonedaID,		Par_Cargos,				Par_Abonos,			Par_Descripcion,
			Par_Referencia,			Procedimiento,		Var_TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
			Cadena_Vacia,			Salida_NO, 			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

        SET Par_NumErr	:= 000;
		SET	Par_ErrMen 	:= 'Poliza Divisa Aplicada.';
		SET Var_Control := 'Poliza';

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT  Par_NumErr 	AS NumErr,
					Par_ErrMen	AS ErrMen,
					Var_Control	AS control;
		END IF;

END TerminaStore$$