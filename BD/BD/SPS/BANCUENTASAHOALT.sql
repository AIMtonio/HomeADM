-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANCUENTASAHOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCUENTASAHOALT`;
DELIMITER $$

CREATE PROCEDURE `BANCUENTASAHOALT`(
	-- STORE QUE DA DE ALTA CUENTAS EN SAFI A TRAVES DE LA BANCA MOVIL

	Par_ClienteID 			INT(11),				-- ID del cliente
	Par_TipoCuentaID 		INT(11),				-- ID de la cuenta
	Par_Etiqueta 			VARCHAR(60),			-- Motivo por el que se abrio la cuenta
    Par_TelefonoCelular     VARCHAR(20),			-- Numero de telefono celular
	INOUT Par_CuentaAho  	BIGINT(12),				-- Numero de cuenta

	Par_Salida				CHAR(1),				-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr		INT(11),				-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen		VARCHAR(400),			-- Parametro que corresponde a un mensaje de exito o error

    Aud_EmpresaID			INT(11),				-- Parametros de Auditoria
	Aud_Usuario         	INT(11),				-- Parametros de Auditoria
	Aud_FechaActual     	DATETIME,				-- Parametros de Auditoria
	Aud_DireccionIP     	VARCHAR(15),			-- Parametros de Auditoria
	Aud_ProgramaID      	VARCHAR(50),			-- Parametros de Auditoria
	Aud_Sucursal        	INT(11),				-- Parametros de Auditoria
	Aud_NumTransaccion  	BIGINT(20)				-- Parametros de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(50);		-- Variable de Control
	DECLARE	Var_Fecha			DATE;               -- Fecha
    DECLARE Var_NivelID			INT(11);			-- Nivel de la cuenta

	-- Declaracion de constantes
	DECLARE Cadena_Vacia		CHAR(1);			-- Cadena vacia
	DECLARE Entero_Cero			INT(11);			-- Entero cero
	DECLARE Fecha_Vacia			DATE;				-- Fecha vacia
	DECLARE	Var_MonedaID		INT(11);            -- Identificador de moneda
	DECLARE	Var_EdoCuenta		CHAR(1);            -- Estado de la cuenta
	DECLARE	Var_InstitucionId	INT(11);            -- Identificador de la institucion
	DECLARE	Var_EsPrincipal		CHAR(1);            -- La cuenta es principal
	DECLARE	Var_Nivel2			CHAR(1);			-- Nivel 2 de la cuenta
    DECLARE Salida_Si			CHAR(1);			-- Salida si
   	DECLARE Var_SucursalID 		INT(11);			-- ID Sucursal
   	DECLARE	Est_Activo			CHAR(1);
	DECLARE	Var_OrigBanca		CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';				-- Cadena vacia
	SET Fecha_Vacia			    := '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			    := 0;				-- Entero 0
	SET Salida_Si				:= 'S';             -- Salida SI

	SET	Var_EdoCuenta			:='I';            	-- I = internet
	SET	Var_InstitucionId		:='0';            	-- Identificador de la institucion
	SET	Var_EsPrincipal			:='N';            	-- La cuenta es principal = NO
	SET	Var_Nivel2				:='2';				-- Nivel de la cuenta = 2
	SET Est_Activo				:= 'A';
	SET	Var_OrigBanca			:='B';

	-- Valores por default
	SET Par_ClienteID 			:= IFNULL(Par_ClienteID,Entero_Cero);
	SET Par_TipoCuentaID		:= IFNULL(Par_TipoCuentaID,Entero_Cero);
	SET Par_Etiqueta			:= IFNULL(Par_Etiqueta,Cadena_Vacia);
	SET Par_TelefonoCelular		:= IFNULL(Par_TelefonoCelular,Cadena_Vacia);
	SET Par_CuentaAho     		:= IFNULL(Par_CuentaAho,Entero_Cero);

	ManejoErrores:BEGIN

		SET Aud_FechaActual	:= NOW(); -- Fecha actual del sistema

		SELECT FechaSistema INTO Var_Fecha FROM PARAMETROSSIS;

		SELECT	NivelID, MonedaID INTO Var_NivelID, Var_MonedaID
			FROM TIPOSCUENTAS
			WHERE	TipoCuentaID	= Par_TipoCuentaID;

		IF(Var_NivelID = Var_Nivel2) THEN

			SELECT SucursalOrigen INTO Var_SucursalID FROM CLIENTES WHERE ClienteID = Par_ClienteID;

			IF(IFNULL(Var_SucursalID, Entero_Cero))= Entero_Cero THEN

				SET	Par_NumErr 	:= 1;
				SET	Par_ErrMen 	:= 'No existe el numero de sucursal del cliente.';
				SET Var_Control := 'sucursalID';

				LEAVE ManejoErrores;
			END IF;

			CALL CUENTASAHOALT (Var_SucursalID,			Par_ClienteID,			Cadena_Vacia,		Var_MonedaID,			Par_TipoCuentaID,
								Var_Fecha,				Par_Etiqueta,			Var_EdoCuenta,		Var_InstitucionId,		Var_EsPrincipal,
								Par_TelefonoCelular,	Par_CuentaAho,			Salida_Si,			Par_NumErr,				Par_ErrMen,
								Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
								Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Cuenta agregada con exito';
			SET Var_Control := 'cuentaAhoID';

		ELSE
            SET Par_NumErr  := 005;
			SET Par_ErrMen  := 'Solo se pueden agregar cuentas nivel 2';
			SET Var_Control := 'cuentaAhoID';

		END IF;

	END ManejoErrores;

	IF (Par_Salida = Salida_Si) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Par_CuentaAho AS consecutivo;
	END IF;

END TerminaStore$$
