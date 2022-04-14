-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOREMESASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOREMESASPRO`;
DELIMITER $$

CREATE  PROCEDURE `PAGOREMESASPRO`(
	Par_RemesaFolio         VARCHAR(45),
    Par_Monto               DECIMAL(14,2),
	Par_ClienteID			INT(11),
	Par_NombreCompleto		VARCHAR(200),
	Par_Direccion			VARCHAR(500),

	Par_NumTelefono			VARCHAR(20),
	Par_TipoIdentiID		INT(11),
	Par_FolioIdentific		VARCHAR(45)	,
	Par_FormaPago			CHAR(1),
	Par_NumeroCuenta		BIGINT(12),

	Par_SucursalID			INT(11),
    Par_CajaID              INT(11),
    Par_MonedaID            INT(11),
	Par_UsuarioID           INT(11),
	Par_NumeroMov			BIGINT,

	Par_AltaEncPoliza		CHAR(1),
	INOUT Par_Poliza		BIGINT,
	Par_AltaDetPol			CHAR(1),
	Par_RemesaCatalogoID	INT,
	Par_UsuarioServicioID   INT(11),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT,
    INOUT Par_ErrMen        VARCHAR(400),
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,

    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
		)
TerminaStore:BEGIN


DECLARE Var_ReferDetPol			VARCHAR(20);
DECLARE Var_FechaApl			DATE;
DECLARE Var_FechaOper			DATE;
DECLARE Var_EsHabil				CHAR(1);
DECLARE Var_SucCliente			INT(5);
DECLARE Var_EsMEnorEdad			CHAR(1);



DECLARE SalidaSI			CHAR(1);
DECLARE Entero_Cero			INT;
DECLARE Cadena_Vacia		CHAR;
DECLARE NatCargo			CHAR(1);
DECLARE descrpcionMov		VARCHAR(100);
DECLARE ConContaPagoRemesa 	INT(11);
DECLARE ConceptosCaja		INT;
DECLARE SalidaNO			CHAR(1);
DECLARE TipoInstrumentoID	INT(11);
DECLARE NatAbono			CHAR(1);


SET SalidaSI			:='S';
SET Entero_Cero			:=0;
SET Cadena_Vacia		:='';
SET NatCargo			:='C';
SET descrpcionMov		:='PAGO DE REMESA';
SET ConContaPagoRemesa	:= 404;
SET ConceptosCaja		:=3;
SET SalidaNO			:='N';
SET TipoInstrumentoID		:=22;
SET NatAbono			:='A';

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOREMESASPRO');
		END;

SET Par_NumErr  := Entero_Cero;
SET Par_ErrMen  := Cadena_Vacia;

SET Var_FechaOper  := (SELECT FechaSistema
                            FROM PARAMETROSSIS);



CALL DIASFESTIVOSCAL(
	Var_FechaOper,		Entero_Cero,		 Var_FechaApl,		Var_EsHabil,		Par_EmpresaID,
	Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
	Aud_NumTransaccion);

SET Aud_FechaActual := NOW();

SELECT  Cli.SucursalOrigen,Cli.EsMenorEdad  INTO Var_SucCliente, Var_EsMEnorEdad
	FROM  CLIENTES Cli
	WHERE Cli.ClienteID   = Par_ClienteID;


	CALL PAGOREMESASAALT(
		Par_RemesaFolio,		Par_Monto,			Par_ClienteID,		Par_NombreCompleto,	Par_Direccion,
		Par_NumTelefono,		Par_TipoIdentiID,	Par_FolioIdentific,	Par_FormaPago,		Par_NumeroCuenta,
		Var_FechaOper,			Par_SucursalID,		Par_CajaID,			Par_MonedaID,		Par_UsuarioID,
		Par_RemesaCatalogoID,	Cadena_Vacia,		Cadena_Vacia,		SalidaNO,			Par_NumErr,
		Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

	IF (Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	SET Var_ReferDetPol:=Par_RemesaFolio;

	CALL CONTACAJAPRO(
		Par_NumeroMov,		Var_FechaApl,		Par_Monto,			descrpcionMov,			Par_MonedaID,
		Var_SucCliente,		Par_AltaEncPoliza,	ConContaPagoRemesa,	Par_Poliza,				Par_AltaDetPol,
		ConceptosCaja,		NatCargo,			Var_ReferDetPol,	Par_RemesaCatalogoID,	Par_RemesaCatalogoID,
		TipoInstrumentoID,	SalidaNO,			Par_NumErr,			Par_ErrMen,				Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
		Aud_NumTransaccion);

    -- INICIO SI Par_UsuarioServicioID ES MAYOR A 0 ES UN USUARIO DE SERVICIO
    IF(Par_UsuarioServicioID > Entero_Cero)THEN
		-- LLAMADA AL PROCESO PARA LA DETECCION DE OPERACIONES REELEVANTES PARA USUARIOS DE SERVICIOS
		CALL PLDOPERELEVUSUSERVPRO (
			Aud_Sucursal,		Par_UsuarioServicioID,	Par_Monto,		Var_FechaOper,		Aud_NumTransaccion,
            NatAbono,			Par_MonedaID,			descrpcionMov,	SalidaNO,			Par_NumErr,
            Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
            Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;
    -- FIN SI Par_UsuarioServicioID ES MAYOR A 0 ES UN USUARIO DE SERVICIO

    -- ACTUALIZA ESTATUS REMESA WS
    UPDATE REMESASWS SET
		Estatus = 'P',
		EmpresaID	 	= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	WHERE RemesaFolioID = Par_RemesaFolio;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := "Remesa pagada exitosamente.";

END ManejoErrores;
 IF (Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'operacionID' AS control,
			Par_Poliza AS consecutivo;
END IF;

END TerminaStore$$