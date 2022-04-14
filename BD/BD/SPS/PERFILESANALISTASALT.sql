DELIMITER ;
DROP PROCEDURE IF EXISTS `PERFILESANALISTASALT`; 
DELIMITER $$

CREATE PROCEDURE `PERFILESANALISTASALT`(
	Par_RolID				INT(11),		-- ID de Rol del Usuario
	Par_TipoPerfil      	CHAR(1),		-- Indica si el Perfil es un Analista o Usuario 
	
	Par_Salida				CHAR(1),		-- Parametro Establece si requiere Salida
	INOUT Par_NumErr		INT(11),		-- Parametro INOUT para el Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro INOUT para la Descripcion del Error

	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE		NumeroPerfil	INT(11);		-- ID de Usuario
	DECLARE		varRolID		INT(11);		-- ID de Rol
	DECLARE		varTipoPerfil   CHAR(1);		-- ID de Rol
    DECLARE 	Var_Control		VARCHAR(100);	-- Control de Retorno en pantalla
	-- Declaracion de Constantes
	DECLARE		Estatus_Activo	CHAR(1);	-- estatus Activo
	DECLARE		Cadena_Vacia	CHAR(1);	-- cadena vacia
	DECLARE		Fecha_Vacia		DATE;		-- fecha vacia
	DECLARE		Entero_Cero		INT(11);	-- entero en cero
    DECLARE 	Salida_SI 		CHAR(1);	-- Salida SI
    DECLARE 	EsAnalista 		CHAR(1);	-- Salida A
    DECLARE 	EsEjecutivo 	CHAR(1);	-- Salida E

	-- Asignacion de Constantes
	SET	Estatus_Activo	:= 'A';
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET Var_Control		:= '';
	SET Salida_SI		:= 'S';
	SET EsAnalista		:= 'A';
	SET EsEjecutivo		:= 'E';


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-PERFILESANALISTASALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;
		-- Asignacion de Variables
		SET	NumeroPerfil	:= 0;
		-- se guarda el valor del rol id para validar que  exista
		SET varRolID		:= (SELECT RolID FROM ROLES WHERE RolID = Par_RolID);
	
  

		IF(IFNULL(varRolID,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Rol indicado no existe.';
			SET Var_Control	:= 'rolID';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_TipoPerfil, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 002;
			SET Par_ErrMen    := 'El Tipo de Perfil està vacio.';
			SET Var_Control   := 'Perfil Vacio';

			LEAVE ManejoErrores;
		END IF;
	    IF(Par_TipoPerfil <> EsAnalista) THEN
			IF(Par_TipoPerfil <> EsEjecutivo)THEN
			SET Par_NumErr     := 003;
			SET Par_ErrMen    := 'El Perfil no existe o es incorrecta.';
			SET Var_Control   := 'Perfil';
			LEAVE ManejoErrores;
	        END IF;
		END IF;		


		-- se guarda el valor del Rol y el Tipo perfil para validar que no exista en la tabla
		SELECT 	TipoPerfil  INTO varTipoPerfil
		FROM PERFILESANALISTAS
		WHERE RolID = varRolID AND TipoPerfil = Par_TipoPerfil  LIMIT 1;


        -- numero conseutivo del perfil
		SET NumeroPerfil := (SELECT IFNULL(MAX(PerfilID),Entero_Cero) + 1  FROM PERFILESANALISTAS);

		SET Aud_FechaActual := NOW();

		INSERT INTO PERFILESANALISTAS (
			PerfilID,	                RolID,                      TipoPerfil,				    EmpresaID,			    		Usuario,					
			FechaActual,				DireccionIP,				ProgramaID,				    Sucursal,				    	NumTransaccion		)
		VALUES(
			NumeroPerfil,				Par_RolID,					Par_TipoPerfil,             Par_EmpresaID,			     	Aud_Usuario,				
			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,			    Aud_Sucursal,			    Aud_NumTransaccion		);


		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;



		SET	Par_NumErr := Entero_Cero;
	    SET	Par_ErrMen := 'Catalogo Grabado Exitosamente.';
	    SET Var_Control:= 'perfilExpediente';


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			NumeroPerfil AS Consecutivo;
	END IF;

END TerminaStore$$