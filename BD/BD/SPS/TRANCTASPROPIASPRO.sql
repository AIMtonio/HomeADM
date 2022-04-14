-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TRANCTASPROPIASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TRANCTASPROPIASPRO`;
DELIMITER $$

CREATE PROCEDURE `TRANCTASPROPIASPRO`(
	Par_InstitEnvio			INT(11),
	Par_NumCtaInstitEnvio	VARCHAR(20),
	Par_InstitRecibe		INT(11),
	Par_NumCtaInstitRecibe	VARCHAR(20),
    Par_Monto               DECIMAL(14,4),
	Par_Referencia			VARCHAR(150),
	Par_CCostoEnvio			INT(11), -- Parametros que recibiran centro de costos de banco que envia --
	Par_CCostoRecibe		INT(11), -- Parametros que recibiran centro de costos de banco que recibe --

	Par_Salida				CHAR(1),
	INOUT	Par_NumErr		INT(11),
	INOUT	Par_ErrMen		VARCHAR(400),

	Aud_EmpresaID        	INT(11),
	Aud_Usuario          	INT(11),
	Aud_FechaActual      	DATETIME,
	Aud_DireccionIP      	VARCHAR(20),
	Aud_ProgramaID       	VARCHAR(50),
	Aud_Sucursal         	INT(11),
	Aud_NumTransaccion   	BIGINT(20)

	)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE Entero_Cero 			INT;
DECLARE Cadena_Vacia			CHAR(1);
DECLARE Fecha_Vacia            DATE;
DECLARE Salida_SI		  		CHAR(1);
DECLARE Salida_NO		  		CHAR(1);
DECLARE Var_Automatico  		CHAR(1);
DECLARE Var_EnteroUno          INT;
DECLARE Var_MsgError           VARCHAR(400);
DECLARE Var_AltaMovAho			CHAR(1);
DECLARE Fecha_Sistema			DATE;
DECLARE Fecha_Valida           DATE;
DECLARE DiaHabil               CHAR(1);
DECLARE Var_Poliza				BIGINT;
DECLARE Par_Consecutivo			BIGINT;
DECLARE Var_RefereCargo			VARCHAR(100);
DECLARE Var_RefereAbono			VARCHAR(100);
DECLARE TipoMovCargo			INT;
DECLARE TipoMovAbono			INT;
DECLARE ConceptoConCargo		INT;
DECLARE Par_NatContaCargo		CHAR(1);
DECLARE Par_NatContaAbono		CHAR(1);
DECLARE EmitePolizaSI			CHAR(1);
DECLARE EmitePolizaNO			CHAR(1);
DECLARE NatMovCargo				CHAR(1);
DECLARE NatMovAbono				CHAR(1);
DECLARE CtaAhoEnvioID			BIGINT(12);
DECLARE CtaAhoRecibeID			BIGINT(12);
DECLARE ConciliadoNO			CHAR(1);
DECLARE Var_ConceptoConta		VARCHAR(50);
DECLARE Var_SucursalCC			INT(11);

-- Asignacion de Constantes
DECLARE CliProcEsp				INT(11);
DECLARE CliEspSofi				INT(11);

SET CliEspSofi			:= 15;
SET CliProcEsp			:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico');
SET CliProcEsp 			:= IFNULL(CliProcEsp, 0);
SET Entero_Cero   		:= 0;
SET Fecha_Vacia			:= '1900-01-01';
SET Salida_SI      		:= 'S';
SET Salida_NO      		:= 'N';
SET Cadena_Vacia 		:= '';
SET TipoMovCargo		:= 100;	-- Tipo Movimiento Tesoreria corresponde con TIPOSMOVSTESO
SET TipoMovAbono		:= 105; -- Tipo Movimiento Tesoreria corresponde con TIPOSMOVSTESO
SET ConceptoConCargo	:= 90;
SET Par_NatContaCargo 	:= 'C';
SET Par_NatContaAbono 	:= 'A';
SET ConciliadoNO		:= 'N';
SET Var_SucursalCC		:= 0;

IF (CliProcEsp = CliEspSofi) THEN
	SET TipoMovCargo := 711;
	SET TipoMovAbono := 710;
END IF;

IF(IFNULL(Par_InstitEnvio, Entero_Cero)) = Entero_Cero THEN
    IF (Par_Salida = Salida_SI) THEN
		SELECT '001' AS NumErr,
        'La Institucion de Envio Esta Vacia.' AS ErrMen,
        'institucionEnvioID' AS control;
    ELSE
        SET Par_NumErr      := '001';
        SET Par_ErrMen      := 'La Institucion de Envio Esta Vacia.';

    END IF;
    LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_NumCtaInstitEnvio, Cadena_Vacia)) = Cadena_Vacia THEN
    IF (Par_Salida = Salida_SI) THEN
		SELECT '002' AS NumErr,
        'El Numero de Cuenta Bancaria de Envio Esta Vacio.' AS ErrMen,
        'numCtaInstitEnvio' AS control;
    ELSE
        SET Par_NumErr      := '002';
        SET Par_ErrMen      := 'El Numero de Cuenta Bancaria de Envio Esta Vacio.' ;
    END IF;
    LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_InstitRecibe, Entero_Cero)) = Entero_Cero THEN
    IF (Par_Salida = Salida_SI) THEN
		SELECT '003' AS NumErr,
        'La Institucion que Recibe Esta Vacia.' AS ErrMen,
        'institucionEnvioID' AS control;
    ELSE
        SET Par_NumErr      := '003';
        SET Par_ErrMen      := 'La Institucion que Recibe Esta Vacia.';

    END IF;
    LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_NumCtaInstitRecibe, Cadena_Vacia)) = Cadena_Vacia THEN
    IF (Par_Salida = Salida_SI) THEN
		SELECT '004' AS NumErr,
        'El Numero de Cuenta Bancaria que Recibe Esta Vacio.' AS ErrMen,
        'numCtaInstitEnvio' AS control;
    ELSE
        SET Par_NumErr      := '004';
        SET Par_ErrMen      := 'El Numero de Cuenta Bancaria que Recibe Esta Vacio.' ;
    END IF;
    LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_Monto, Entero_Cero)) = Entero_Cero THEN
    IF (Par_Salida = Salida_SI) THEN
		SELECT '005' AS NumErr,
        'El Monto Esta Vacio.' AS ErrMen,
        'cantidad' AS control;
    ELSE
        SET Par_NumErr      := '005';
        SET Par_ErrMen      := 'La Monto Esta Vacio.';
    END IF;
    LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_CCostoEnvio, Entero_Cero)) = Entero_Cero THEN
	IF(Par_Salida = Salida_SI) THEN
		SELECT '006' AS NumErr,
		'El Centro de Costos de Envio esta Vacio.',
		'cCostosEnvio' AS control;
		ELSE
		SET Par_NumErr	:='006';
		SET Par_ErrMen	:='El Centro de Costos de Envio esta Vacio.';
	END IF;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_CCostoRecibe, Entero_Cero)) = Entero_Cero THEN
	IF(Par_Salida = Salida_SI) THEN
	SELECT '007' AS NumErr,
	'El Centro de Costos que Recibe esta Vacio.',
	'cCostosRecibe' AS control;
	ELSE
	SET Par_NumErr	:='007';
	SET Par_ErrMen	:='El Centro de Costos que Recibe esta Vacio.';
	END IF;
	LEAVE TerminaStore;
END IF;

	SET Var_Automatico 		:= 'P';
	SET Var_EnteroUno 		:= 1;
	SET EmitePolizaSI		:= 'S';
	SET EmitePolizaNO		:= 'N';
	SET Var_MsgError       	:= 'MsgError';
	SET Var_AltaMovAho 		:= 'N';

	SET NatMovCargo := 'C';
	SET NatMovAbono := 'A';

	SET Var_ConceptoConta :=(SELECT Descripcion FROM CONCEPTOSCONTA WHERE ConceptoContaID = ConceptoConCargo);
	SET Var_RefereCargo := (SELECT Descripcion FROM TIPOSMOVTESO WHERE TipoMovTesoID = TipoMovCargo);
	SET Var_RefereAbono := (SELECT Descripcion FROM TIPOSMOVTESO WHERE TipoMovTesoID = TipoMovAbono);
	SET Var_RefereCargo := CONCAT(Var_RefereCargo,' NO. CTA: ',CONVERT(Par_NumCtaInstitRecibe,CHAR));
	SET Var_RefereAbono := CONCAT(Var_RefereAbono,' NO. CTA: ',CONVERT(Par_NumCtaInstitEnvio,CHAR));

	SET CtaAhoEnvioID  := (SELECT CuentaAhoID
								FROM CUENTASAHOTESO
								WHERE NumCtaInstit = Par_NumCtaInstitEnvio
								AND InstitucionID=Par_InstitEnvio);

	SET CtaAhoRecibeID := (SELECT CuentaAhoID
								FROM CUENTASAHOTESO
								WHERE NumCtaInstit = Par_NumCtaInstitRecibe
								AND InstitucionID=Par_InstitRecibe);

	SELECT FechaSistema  INTO Fecha_Sistema  FROM PARAMETROSSIS;

	CALL DIASFESTIVOSCAL(	Fecha_Sistema,	Entero_Cero,		Fecha_Valida,		DiaHabil,		Aud_EmpresaID,
							Aud_Usuario,    Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID, Aud_Sucursal,
							Aud_NumTransaccion);

	/* Alta del Movimiento Operativo de la Cuenta Nostro de Tesoreria para la Cuenta de Envio*/
	CALL TESORERIAMOVSALT(
			CtaAhoEnvioID,		Fecha_Sistema,  	Par_Monto,			Var_RefereCargo,		Par_Referencia,
			ConciliadoNO,   	NatMovCargo,		Var_Automatico,		TipoMovCargo,			Entero_Cero,
			Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,    	Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     	Aud_Sucursal,
			Aud_NumTransaccion);

	/* Alta del Movimiento Operativo de la Cuenta Nostro de Tesoreria para la Cuenta que Recibe*/
	CALL TESORERIAMOVSALT(
			CtaAhoRecibeID,		Fecha_Sistema,		Par_Monto,       	Var_RefereAbono, 	Par_Referencia,
			ConciliadoNO,		NatMovAbono,		Var_Automatico,     TipoMovAbono,     	Entero_Cero,
			Salida_NO,			Par_NumErr,			Par_ErrMen,         Par_Consecutivo,    Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion);

	/* Se realiza este procedimiento ya que se tiene que enviar la Sucursal como Parametro al SP CONTATESORERIAPRO del CC
		Par_CCostoEnvio en caso de que no exista manda por default el Par_CCostoEnvio y en el proceso de Generacion
		de movimientos Contables valida la Funcion FNCENTROCOSTOS si el Parametro es Sucursal o Centro de Costos*/

	SELECT SucursalID
	INTO Var_SucursalCC
		FROM SUCURSALES
		WHERE CentroCostoID = Par_CCostoEnvio;

	SET Var_SucursalCC := IFNULL(Var_SucursalCC, Entero_Cero);

	IF(Var_SucursalCC = Entero_Cero) THEN
		SET Var_SucursalCC = Par_CCostoEnvio;
	END IF;


	CALL CONTATESORERIAPRO(
			Var_SucursalCC,		Var_EnteroUno,	Par_InstitEnvio,	Par_NumCtaInstitEnvio,	Entero_Cero,
			Entero_Cero,        Entero_Cero,	Fecha_Sistema,		Fecha_Valida,       Par_Monto,
			Var_ConceptoConta,	Par_NumCtaInstitEnvio,	Par_InstitEnvio,	EmitePolizaSI,		Var_Poliza,
			ConceptoConCargo,    Entero_Cero,	Par_NatContaAbono,	Var_AltaMovAho,     Entero_Cero,
			Entero_Cero,      	Cadena_Vacia,	Cadena_Vacia,      	Entero_Cero,        Var_MsgError,
			Entero_Cero,        Aud_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,	Aud_NumTransaccion);

	SELECT SucursalID
	INTO Var_SucursalCC
		FROM SUCURSALES
		WHERE CentroCostoID = Par_CCostoRecibe;

	SET Var_SucursalCC := IFNULL(Var_SucursalCC, Entero_Cero);

	IF(Var_SucursalCC = Entero_Cero) THEN
		SET Var_SucursalCC = Par_CCostoRecibe;
	END IF;

	CALL CONTATESORERIAPRO(
			Var_SucursalCC,		Var_EnteroUno,	Par_InstitRecibe,	Par_NumCtaInstitRecibe,		Entero_Cero,
			Entero_Cero,        Entero_Cero,	Fecha_Sistema,		Fecha_Valida,       		Par_Monto,
			Var_ConceptoConta,	Par_NumCtaInstitRecibe,	Par_InstitRecibe,	EmitePolizaNO,				Var_Poliza,
			ConceptoConCargo,   Entero_Cero,	Par_NatContaCargo,	Var_AltaMovAho,     		Entero_Cero,
			Entero_Cero,      	Cadena_Vacia,	Cadena_Vacia,      	Entero_Cero,        		Var_MsgError,
			Entero_Cero,        Aud_EmpresaID,	Aud_Usuario,		Aud_FechaActual,			Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,	Aud_NumTransaccion);

	/* se utiliza para hacer un Cargo o un Abono a algun registro de la tabla CUENTASAHOTESO */
	CALL SALDOSCTATESOACT(
			Par_NumCtaInstitEnvio,	Par_InstitEnvio,	Par_Monto,			NatMovCargo,		Salida_NO,
			Par_NumErr,				Par_ErrMen,			Par_Consecutivo, 	Aud_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,   	Aud_ProgramaID, 	Aud_Sucursal,     	Aud_NumTransaccion);

	CALL SALDOSCTATESOACT(
			Par_NumCtaInstitRecibe,	Par_InstitRecibe,	Par_Monto,			NatMovAbono,		Salida_NO,
			Par_NumErr,				Par_ErrMen,			Par_Consecutivo, 	Aud_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,   	Aud_ProgramaID, 	Aud_Sucursal,     	Aud_NumTransaccion);

	IF (Par_Salida = Salida_SI) THEN
		SELECT '000' AS NumErr,
			CONCAT("Transferencia Grabada Exitosamente")  AS ErrMen,
			'polizaID' AS control,
			Var_Poliza AS consecutivo;
	END IF;

IF (Par_Salida = Salida_NO) THEN
		SET Par_NumErr      := '0';
		SET Par_ErrMen      := CONCAT("Transferencia Grabada Exitosamente") ;
	END IF;


END TerminaStore$$
