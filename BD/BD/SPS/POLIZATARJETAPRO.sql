-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZATARJETAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZATARJETAPRO`;
DELIMITER $$

CREATE PROCEDURE `POLIZATARJETAPRO`(
    Par_Poliza          BIGINT,
    Par_Empresa         INT,
    Par_Fecha           DATE,
    Par_TarjetaID       VARCHAR(16),
    Par_Cliente         INT,

    Par_ConceptoOpera   INT,
    Par_Moneda          INT,
    Par_Cargos          DECIMAL(12,2),
    Par_Abonos          DECIMAL(12,2),
    Par_Descripcion     VARCHAR(100),

    Par_Referencia      VARCHAR(50),
	Par_CentroATM		INT(11),
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


	DECLARE Var_Instrumento     VARCHAR(20);
	DECLARE Var_CentroCostosID  INT(11);
	DECLARE Var_CuentaComple    CHAR(20);
	DECLARE Var_Nomenclatura    VARCHAR(30);
	DECLARE Var_NomenclaturaCR  VARCHAR(3);

	DECLARE Var_CuentaMayor		VARCHAR(4);
	DECLARE Var_Cuenta          VARCHAR(50);
	DECLARE Var_NomenclaturaSO  INT(11);
	DECLARE Var_NomenclaturaSC  INT(11);



	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE Entero_Cero         INT;
	DECLARE Cuenta_Vacia        VARCHAR(20);
	DECLARE For_CueMayor        CHAR(3);

	DECLARE For_SucOrigen       CHAR(3);
	DECLARE For_SucCliente      CHAR(3);
	DECLARE Salida_NO           CHAR(1);
	DECLARE Salida_SI           CHAR(1);
	DECLARE Procedimiento       VARCHAR(20);

	DECLARE TipoInstrumentoID	INT(11);


	SET Cadena_Vacia    	:= '';
	SET Fecha_Vacia     	:= '1900-01-01';
	SET Entero_Cero     	:= 0;
	SET Cuenta_Vacia    	:= '000000000000000';
	SET For_CueMayor    	:= '&CM';

	SET For_SucOrigen   	:= '&SO';
	SET For_SucCliente  	:= '&SC';
	SET Salida_NO       	:= 'N';
	SET Salida_SI       	:= 'S';
	SET Procedimiento   	:= 'POLIZATARJETAPRO';

	SET TipoInstrumentoID	:= 14;


	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
					concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-POLIZATARJETAPRO');
			END;


	SET Var_Instrumento := CONVERT(Par_TarjetaID, CHAR);
	SET Var_CentroCostosID    := Entero_Cero;

	SELECT	Nomenclatura, Cuenta, NomenclaturaCR  INTO Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
		FROM  CUENTASMAYORTARDEB Ctm
		WHERE Ctm.ConceptoTarDebID	= Par_ConceptoOpera;

	SET Var_Nomenclatura 	:= IFNULL(Var_Nomenclatura, Cadena_Vacia);
	SET Var_NomenclaturaCR  := IFNULL(Var_NomenclaturaCR, Cadena_Vacia);

	IF(Var_Nomenclatura = Cadena_Vacia) THEN
		SET Var_Cuenta := Cuenta_Vacia;
	ELSE

		SET Var_Cuenta      := Var_Nomenclatura;
		SET Var_CentroCostosID    := FNCENTROCOSTOS(Aud_Sucursal);

		IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
			SET Var_NomenclaturaSO := (
					SELECT	SucursalOrigen
						FROM  CLIENTES
						WHERE	ClienteID 	=	Par_Cliente);

			SET Var_NomenclaturaSO  := IFNULL(Var_NomenclaturaSO, Cadena_Vacia);
			IF (Var_NomenclaturaSO != Cadena_Vacia) THEN
					SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
			END IF;
		END IF;
		IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
			SET Var_NomenclaturaSC := Aud_Sucursal;

			IF (Var_NomenclaturaSC != Cadena_Vacia) THEN
				SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
			END IF;
		END IF;

		IF LOCATE(For_CueMayor, Var_Cuenta) > Entero_Cero THEN
			SET Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
		END IF;

	END IF;


	IF(IFNULL(Par_CentroATM,Entero_Cero) != Entero_Cero) THEN
		SET Var_CentroCostosID    := FNCENTROCOSTOS(Par_CentroATM);
	END IF;

	SET Var_Cuenta = REPLACE(Var_Cuenta, '-', Cadena_Vacia);

	CALL DETALLEPOLIZAALT (
		Par_Empresa,        Par_Poliza,			Par_Fecha,			Var_CentroCostosID,   Var_Cuenta,
		Var_Instrumento,    Par_Moneda,			Par_Cargos,     	Par_Abonos,     Par_Descripcion,
		Par_Referencia,     Procedimiento,  	TipoInstrumentoID,	Cadena_Vacia,	Entero_Cero,
		Cadena_Vacia,		Salida_NO,      	Par_NumErr,			Par_NumErr,		Aud_Usuario,
		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, 	Aud_Sucursal,   Aud_NumTransaccion);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := "Poliza de Tarjeta de Debito Registrada Exitosamente ";

	END ManejoErrores;

	 IF (Par_Salida = Salida_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen AS ErrMen,
				'PolizaID' AS control,
				Entero_Cero AS consecutivo;
	END IF;


END TerminaStore$$