-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZAATMPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZAATMPRO`;
DELIMITER $$

CREATE PROCEDURE `POLIZAATMPRO`(

	Par_CajeroID			VARCHAR(20),
	Par_Poliza				BIGINT,
	Par_Fecha				DATE,
	Par_Instrumento			VARCHAR(20),
	Par_Moneda				INT,

	Par_Cargos				DECIMAL(12,2),
	Par_Abonos				DECIMAL(12,2),
	Par_DescripcionMov		VARCHAR(100),
	Par_ReferDetPol			VARCHAR(50),
	Par_TipoAfectacion		VARCHAR(20),

	Par_TipoInstrumento		INT(11),
	Par_NumeroTarjeta		VARCHAR(16),
	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Par_Empresa				INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN


	DECLARE Var_Cuenta				VARCHAR(50);
	DECLARE Var_CenCosto			INT;
	DECLARE Var_MonedaBaseID 		INT;
	DECLARE Var_MonedaExtrangeraID	INT;
	DECLARE Var_NomenclaturaCR		VARCHAR(5);


	DECLARE MonedaPesos				INT(1);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Procedimiento			VARCHAR(50);
	DECLARE AfectacionTransito		CHAR(1);
	DECLARE Entero_Cero				INT;

    DECLARE Decimal_Cero			DECIMAL(16,2);
	DECLARE SucCajero				VARCHAR(5);
	DECLARE SucCliente				VARCHAR(5);
	DECLARE Cadena_Cero				CHAR(1);
	DECLARE SalidaSI				CHAR(1);
	DECLARE Var_CentroCostosID		INT(11);


	SET MonedaPesos			:= 1;
	SET Cadena_Vacia		:= '';
	SET Procedimiento		:= 'POLIZAATMPRO';
	SET AfectacionTransito	:= 'T';
	SET Entero_Cero			:= 0;

    SET Decimal_Cero		:= 0.0;
	SET SucCajero			:= '&SO';
	SET SucCliente			:= '&SC';
	SET Cadena_Cero			:= '0';
	SET SalidaSI			:= 'S';


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
					concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-POLIZAATMPRO');
			END;

	SELECT  MonedaBaseID,MonedaExtrangeraID  INTO Var_MonedaBaseID, Var_MonedaExtrangeraID FROM PARAMETROSSIS LIMIT 1;
	SET Var_MonedaBaseID		:= IFNULL(Var_MonedaBaseID,Entero_Cero);
	SET Var_MonedaExtrangeraID	:= IFNULL(Var_MonedaExtrangeraID,Entero_Cero);


	IF (Par_Moneda = Var_MonedaBaseID) THEN
		IF(Par_TipoAfectacion = AfectacionTransito)THEN
			SET Var_Cuenta	:=	(SELECT CtaContaMNTrans
				FROM CATCAJEROSATM
				WHERE CajeroID = Par_CajeroID);
		ELSE
			SET Var_Cuenta	:=(SELECT CtaContableMN
				FROM CATCAJEROSATM
				WHERE CajeroID = Par_CajeroID);
		END IF;
	ELSE
		IF(Par_TipoAfectacion = SI )THEN
			SET Var_Cuenta	:=(SELECT CtaContaMETrans
				FROM CATCAJEROSATM
				WHERE CajeroID=Par_CajeroID);
		ELSE
			SET Var_Cuenta	:=(SELECT CtaContableME
				FROM CATCAJEROSATM
				WHERE CajeroID=Par_CajeroID);
		END IF;

	END IF;

	SELECT NomenclaturaCR,SucursalID
		INTO Var_NomenclaturaCR,Var_CenCosto
		FROM CATCAJEROSATM
		WHERE CajeroID=Par_CajeroID;

	SET Var_CentroCostosID := FNCENTROCOSTOS(Var_CenCosto);

	IF(Par_NumeroTarjeta!=Cadena_Cero)THEN

		IF(LOCATE(Var_NomenclaturaCR,SucCliente)> Entero_Cero)THEN
			SET Var_CenCosto    := 	(SELECT SucursalOrigen
										FROM TARJETADEBITO tb
										INNER JOIN CLIENTES ctes ON tb.ClienteID=ctes.ClienteID
										WHERE tb.TarjetaDebID=Par_NumeroTarjeta);
			SET Var_CenCosto 	:= IFNULL(Var_CenCosto,Entero_Cero);
			SET Var_CentroCostosID := FNCENTROCOSTOS(Var_CenCosto);
    	ELSE
    		IF(LOCATE(Var_NomenclaturaCR,SucCajero)> Entero_Cero)THEN
    			SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
            ELSE
                SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
    		END IF;
        END IF;
	END IF;


	IF(Par_NumeroTarjeta=Cadena_Cero)THEN

		IF(LOCATE(Var_NomenclaturaCR,SucCliente)> Entero_Cero)THEN
			SET Var_CenCosto    := Aud_Sucursal;
		END IF;

	END IF;

	CALL DETALLEPOLIZAALT(
		Par_Empresa,		Par_Poliza,			Par_Fecha,				Var_CentroCostosID,	Var_Cuenta,
		Par_Instrumento,	Par_Moneda,			Par_Cargos,				Par_Abonos,			Par_DescripcionMov,
		Par_ReferDetPol,	Procedimiento,		Par_TipoInstrumento,	Cadena_Vacia,		Decimal_Cero,
		Cadena_Vacia,		Par_Salida,			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);


	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Par_PolizaID AS consecutivo;
	END IF;


END TerminaStore$$