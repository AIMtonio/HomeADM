-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSFAMALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSFAMALT`;DELIMITER $$

CREATE PROCEDURE `GRUPOSFAMALT`(
/* SP DE ALTA DE GRUPOS FAMILIARES */
	Par_ClienteID				BIGINT(12),		-- ID del Cliente a quien le pertenece el grupo.
	Par_FamClienteID			INT(11),		-- ID del Cliente Familiar.
	Par_TipoRelacionID			INT(11),		-- ID del Tipo de Relación del Familiar (TIPORELACIONES).
	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de Error

	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error
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

-- Declaracion de Constantes
DECLARE	Var_Control     CHAR(15);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI        CHAR(1);
DECLARE	SalidaNO        CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI        	:= 'S';				-- Salida Si
SET	SalidaNO        	:= 'N'; 			-- Salida No
SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-GRUPOSFAMALT');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(IFNULL(Par_ClienteID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' esta Vacio.');
		SET Var_Control:= 'clienteID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT ClienteID FROM CLIENTES WHERE ClienteID=Par_ClienteID)) THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' No Existe.');
		SET Var_Control:= 'clienteID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FamClienteID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' Familiar esta Vacio.');
		SET Var_Control:= 'famClienteID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT ClienteID FROM CLIENTES WHERE ClienteID=Par_FamClienteID)) THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' Familiar No Existe.');
		SET Var_Control:= 'famClienteID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ClienteID, Entero_Cero) = IFNULL(Par_FamClienteID, Entero_Cero))  THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' Titular No puede Agregarse como Integrante del Grupo.');
		SET Var_Control:= 'famClienteID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoRelacionID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 6;
		SET Par_ErrMen := CONCAT('El Parentesco esta Vacio.');
		SET Var_Control:= 'tipoRelacionID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT TipoRelacionID FROM TIPORELACIONES WHERE TipoRelacionID=Par_TipoRelacionID)) THEN
		SET Par_NumErr := 7;
		SET Par_ErrMen := 'El Parentesco No Existe.';
		SET Var_Control:= 'tipoRelacionID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(EXISTS(SELECT * FROM GRUPOSFAM WHERE ClienteID=Par_ClienteID AND FamClienteID=Par_FamClienteID)) THEN
		SET Par_NumErr 		:= 8;
		SET Par_ErrMen 		:= CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' ',Par_FamClienteID,' ya se Encuentra en este Grupo Familiar.');
		SET Var_Control		:= 'famClienteID' ;
		LEAVE ManejoErrores;
	END IF;

	INSERT INTO GRUPOSFAM(
		ClienteID,			FamClienteID,		TipoRelacionID,		EmpresaID,		UsuarioID,
		FechaActual,		DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion)
	VALUES(
		Par_ClienteID,		Par_FamClienteID,	Par_TipoRelacionID,	Par_EmpresaID,	Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,	Aud_NumTransaccion);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := CONCAT('Grupo Familiar Grabado Exitosamente para el ',
						FNGENERALOCALE('safilocale.cliente'),': ',Par_ClienteID,'.');
	SET Var_Control:= 'clienteID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_ClienteID AS Consecutivo;
END IF;

END TerminaStore$$