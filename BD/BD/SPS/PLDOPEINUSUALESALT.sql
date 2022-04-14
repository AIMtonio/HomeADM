-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINUSUALESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEINUSUALESALT`;
DELIMITER $$


CREATE PROCEDURE `PLDOPEINUSUALESALT`(
	Par_CatProcedIntID			VARCHAR(10),		-- Categoria del procedimiento interno PLDCATPROCEDINT
	Par_CatMotivInuID			VARCHAR(15),		-- Categoria del motivo PLDCATMOTIVINU
	Par_FechaDeteccion			DATE,				-- Fecha de Deteccion
	Par_ClavePersonaInv			INT,				-- ID de la persona involucrada
	Par_NomPersonaInv			VARCHAR(200),		-- Nombre completo de la persona involucrada

	Par_EmpInvolucrado			VARCHAR(100),		-- Nombre del empleado involucrado
	Par_Frecuencia				CHAR(1),			-- Frecuencia del evento
	Par_DesFrecuencia			VARCHAR(150),		-- Descripcion de la frecuencia
	Par_DesOperacion			VARCHAR(300),		-- Descripcion de la operacion
	Par_CreditoID				BIGINT(12),			-- ID del Credito

	Par_CuentaAhoID				BIGINT(12),			-- ID de la cuenta de Ahorro
	Par_TransaccionOpe			INT(11),			-- numero de la transaccion
	Par_NaturaOperacion			CHAR(1),			-- Naturaleza de la operacion A.- Abono C.- Cargo
	Par_MontoOperacion			DECIMAL(18,2),		-- Monto de la operacion
	Par_MonedaOperacion			INT(11),			-- ID de la moneda MONEDAS

    Par_TipoPersonaSAFI			VARCHAR(3),			-- Tipo de persona SAFI CTE.- Cliente USU.- Usuario Serv. NA.- No Aplica
    Par_NombresPersonaInv		VARCHAR(150),		-- Nombres de la persona involucrada
    Par_ApPaternoPersonaInv		VARCHAR(50),		-- Apellido Paterno de la persona involucrada
    Par_ApMaternoPersonaInv		VARCHAR(50),		-- Apellido Materno de la persona involucrada
    Par_TipoListaID				VARCHAR(45),

	Par_Salida					CHAR(1),			-- Tipo de Salida
	INOUT Par_NumErr			INT(11),			-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de Error
    /* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),

	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE	Var_ClaveRegistra		CHAR(2);
DECLARE	Var_Registra			VARCHAR(10);
DECLARE	Var_Estatus				CHAR(1);
DECLARE	Var_FechaCierre			DATE;
DECLARE	Var_Control				CHAR(20);

-- Declaracion de Constantes
DECLARE	Fecha					DATE;
DECLARE	ClaveRegistraInterna	CHAR(2);
DECLARE	ClaveRegistraSistema	CHAR(2);
DECLARE	EstatusCapturada		CHAR(1);
DECLARE	EstatusReportar			CHAR(1);

DECLARE	Cadena_Vacia			CHAR(1);
DECLARE	Fecha_Vacia				DATE;
DECLARE	Entero_Cero				INT(11);
DECLARE	Str_SI					CHAR(1);
DECLARE	NumOperacion			INT(11);
DECLARE	Motivo					VARCHAR(15);
DECLARE	Proceso					VARCHAR(10);
DECLARE	Sucursal				INT(11);
DECLARE	RegistraSAFI			CHAR(4);
DECLARE	TipoOp_Inusual			INT(11);
DECLARE	Str_NO					CHAR(1);

-- Asignacion de Constantes
SET	Cadena_Vacia			:= '';							-- Cadena Vacia
SET	Fecha_Vacia				:= '1900-01-01';				-- Fecha Vacia
SET	Entero_Cero				:= 0;							-- Entero Cero
SET	Str_SI					:= 'S';							-- Cadena de Si
SET	ClaveRegistraInterna	:= '1';							-- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
SET	ClaveRegistraSistema	:= '3';							-- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
SET	EstatusCapturada		:= '1';							-- Estatus de Operacion inusual detectada y capturada (1.- Capturada  2.- En Seguimiento  3.-Reportada  4.- No Reportada)
SET	EstatusReportar			:= '3';							-- Estatus de Operacion inusual detectada y capturada (1.- Capturada  2.- En Seguimiento  3.-Reportada  4.- No Reportada)
SET	RegistraSAFI			:= 'SAFI';
SET TipoOp_Inusual			:= 2;							-- Tipo de Operación Inusual.
SET	Str_NO					:= 'N';							-- Cadena de No

-- Inicializa variables de Salida
SET	Aud_FechaActual 	:= CURRENT_TIMESTAMP();

SET	Var_ClaveRegistra	:= ClaveRegistraInterna;
SET	Var_Registra		:= Cadena_Vacia;
SET	Var_Estatus			:= EstatusCapturada;
SET	Var_FechaCierre		:= Fecha_Vacia;
SET	Fecha				:= (SELECT FechaSistema FROM PARAMETROSSIS);

ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDOPEINUSUALESALT');
			SET Var_Control	:= 'sqlException';
		END;

		SET Par_TipoListaID := IFNULL(Par_TipoListaID, Cadena_Vacia);

	IF(IFNULL(Fecha,Fecha_Vacia)) = Fecha_Vacia THEN
		SET	Par_ErrMen	:= 'La Fecha esta Vacia.' ;
		SET	Par_NumErr	:= 001;
		SET Var_Control	:= 'fecha';
		LEAVE ManejoErrores;
	END IF;


	SET Motivo := (SELECT CatMotivInuID FROM PLDCATMOTIVINU WHERE CatMotivInuID=Par_CatMotivInuID);


	IF(IFNULL(Motivo, Cadena_Vacia)) = Cadena_Vacia THEN
		SET	Par_ErrMen	:= 'El Motivo de la Operacion no es valido.';
		SET	Par_NumErr	:= 003;
		SET Var_Control	:= 'catMotivInuID';
		LEAVE ManejoErrores;
	END IF;

	SET Proceso := (SELECT CatProcedIntID FROM PLDCATPROCEDINT WHERE CatProcedIntID=Par_CatProcedIntID);

	IF(IFNULL(Proceso, Cadena_Vacia)) = Cadena_Vacia THEN
		SET	Par_ErrMen	:= 'El Proceso de la Operacion no es valido.';
		SET	Par_NumErr	:= 004;
		SET Var_Control	:= 'catProcedIntID';
		LEAVE ManejoErrores;
	END IF;

	SET NumOperacion := (SELECT IFNULL(MAX(OpeInusualID),Entero_Cero)  FROM PLDOPEINUSUALES);
	SET NumOperacion := IFNULL(NumOperacion, Entero_Cero) + 1;

	SET Sucursal := (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID=Par_ClavePersonaInv);
	SET Sucursal := IFNULL(Sucursal,Aud_Sucursal);

	IF(Par_DesOperacion LIKE '%LISTA NEGRA%' OR Par_DesOperacion LIKE '%REPORTE DE 24 HRS%'
		OR Par_DesOperacion LIKE '%PERSONAS BLOQUEADAS%' OR Par_DesOperacion LIKE '%PAISES%') THEN
		SET	Var_ClaveRegistra	:= ClaveRegistraSistema;
		SET	Var_Registra		:= RegistraSAFI;
		SET	Var_Estatus			:= EstatusCapturada;
		SET	Var_FechaCierre		:= Fecha ;
	END IF;

	INSERT INTO PLDOPEINUSUALES (
		Fecha,				OpeInusualID,		ClaveRegistra,			NombreReg,				CatProcedIntID,
		CatMotivInuID,		FechaDeteccion,		SucursalID,				ClavePersonaInv,		NomPersonaInv,
		EmpInvolucrado,		Frecuencia,			DesFrecuencia,			DesOperacion,			Estatus,
		ComentarioOC,		FechaCierre,		CreditoID,				CuentaAhoID,			TransaccionOpe,
		NaturaOperacion,	MontoOperacion,		MonedaID,				FolioInterno,			TipoOpeCNBV,
		FormaPago,			TipoPersonaSAFI,	NombresPersonaInv,		ApPaternoPersonaInv,	ApMaternoPersonaInv,
		TipoListaID,		EmpresaID,			Usuario,				FechaActual,			DireccionIP,
        ProgramaID,			Sucursal,			NumTransaccion)
	VALUES  (
		Fecha,				NumOperacion,		Var_ClaveRegistra,		Var_Registra,			Par_CatProcedIntID,
		Par_CatMotivInuID,	Par_FechaDeteccion,	Sucursal,				Par_ClavePersonaInv,	Par_NomPersonaInv,
		Par_EmpInvolucrado,	Par_Frecuencia,		Par_DesFrecuencia,		Par_DesOperacion,		Var_Estatus,
		Cadena_Vacia,		Var_FechaCierre,	Par_CreditoID,			Par_CuentaAhoID,		Par_TransaccionOpe,
		Par_NaturaOperacion,Par_MontoOperacion,	Par_MonedaOperacion,	Entero_Cero,			Cadena_Vacia,
		Cadena_Vacia,		Par_TipoPersonaSAFI,Par_NombresPersonaInv,	Par_ApPaternoPersonaInv,Par_ApMaternoPersonaInv,
        Par_TipoListaID,    Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
        Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	CALL PLDENVALERTASPRO(
		TipoOp_Inusual,		NumOperacion,		Str_No,			Par_NumErr,			Par_ErrMen,			
        Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID,		
        Aud_Sucursal,	Aud_NumTransaccion);


	SET	Par_NumErr	:= Entero_Cero;
	SET	Par_ErrMen	:= CONCAT('Operacion Inusual Reportada con Numero de Folio: ', CONVERT(NumOperacion, CHAR));
	SET Var_Control	:= 'opeInusualID';

END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT	Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			NumOperacion AS consecutivo;
END IF;

END TerminaStore$$